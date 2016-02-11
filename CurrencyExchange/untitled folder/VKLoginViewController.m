//
//  VKLoginViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 2/5/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "VKLoginViewController.h"
#import "VKAccessToken.h"

@interface VKLoginViewController () <UIWebViewDelegate>

@property (copy, nonatomic) LoginCompletionBlock completionBlock;
@property (weak, nonatomic) UIWebView* webView;

@end

@implementation VKLoginViewController


- (id) initWithCompletionBlock:(LoginCompletionBlock) completionBlock
{
    self = [super init];
    if (self)
    {
        self.completionBlock = completionBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    UIWebView* webView = [[UIWebView alloc] initWithFrame:frame];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    self.webView = webView;
    
    self.navigationItem.title = @"Login";
    
    NSString* urlString =
    @"https://oauth.vk.com/authorize?"
    "client_id=5275698&"
    "scope=10242&" // + 2 + 8192 + 2048
    "redirect_uri=https://oauth.vk.com/blank.html&"
    "display=mobile&"
    "v=5.44&"
    "response_type=token";
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    
    webView.delegate = self;
    
    [webView loadRequest:request];
    
}

- (void) dealloc
{
    self.webView.delegate = nil;
}

#pragma mark - UIWebViewDelegete

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[[request URL] description] rangeOfString:@"#access_token="].location != NSNotFound)
    {
        VKAccessToken* token = [[VKAccessToken alloc] init];
        
        NSString* stringToParce = [[request URL] description];
        NSArray* array = [stringToParce componentsSeparatedByString:@"#"];
        
        if ([array count] > 1)
        {
            stringToParce = [array lastObject];
        }
        NSArray* pairs = [stringToParce componentsSeparatedByString:@"&"];
        
        for (NSString* pair in pairs)
        {
            NSArray* values = [pair componentsSeparatedByString:@"="];
            
            if ([values count] == 2)
            {
                NSString* key = [values firstObject];
                
                if ([key isEqualToString:@"access_token"])
                {
                    token.token = [values lastObject];
                }
                else if ([key isEqualToString:@"expires_in"])
                {
                    NSTimeInterval interval = [[values lastObject] doubleValue];
                    token.expirationDate = [NSDate dateWithTimeIntervalSinceNow:interval];
                }
                else if ([key isEqualToString:@"user_id"])
                {
                    token.userID = [values lastObject];
                }
            }
        }
        
        self.webView.delegate = nil;
        if (self.completionBlock)
        {
            self.completionBlock(token);
        }
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    else
    {
        return YES;
    }
    
}


@end
