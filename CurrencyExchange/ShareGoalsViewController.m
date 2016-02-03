//
//  ShareGoalsViewController.m
//  CurrencyExchange
//
//  Created by alex4eetah on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "ShareGoalsViewController.h"
#import "WebSharingViewController.h"

@interface ShareGoalsViewController ()

@property (nonatomic, strong) NSString *source;
@property(nonatomic, weak) IBOutlet UIImageView *imageView;

@end

static NSString *seaguewID = @"shareSeague";

@implementation ShareGoalsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = self.imageToShare;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)wayOfSharingBeenChosen:(UIButton *)sender
{
    switch (sender.tag)
    {
        case 1:
            self.source = @"vk";
            break;
            
        case 2:
            self.source = @"fb";
            break;
            
        case 3:
            self.source = @"Gmail";
            [self displayComposerSheet];
            break;
            
        default:
            break;
    }
    [self performSegueWithIdentifier:@"shareSeague" sender:self];
}


-(void)displayComposerSheet
{
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"I am the winner!"];
    
    // Set up the recipients.
    NSString *adress = @"gmr@inbox.ru";
    NSArray *toRecipients = [[NSArray alloc]initWithObjects:adress, nil];
    
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com",
                             @"third@example.com", nil];
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"four@example.com",
                              nil];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
    
    UIImage *myImage = [UIImage imageNamed:@"filename.png"];
    NSData *imageData = UIImagePNGRepresentation(myImage);
    [picker addAttachmentData:imageData mimeType:@"image/png" fileName:@"Name"];
    // Attach an image to the email.
    //NSString *path = [[NSBundle mainBundle] pathForResource:@"ipodnano"
   //                                                  ofType:@"png"];
   // NSData *myData = [NSData dataWithContentsOfFile:path];
   //[picker addAttachmentData:myData mimeType:@"image/png"
   //                  fileName:@"ipodnano"];
    
   
    
    // Fill out the email body text.
    NSString *emailBody = @"I am the Winner!";
    [picker setMessageBody:emailBody isHTML:NO];
    [picker setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    // Present the mail composition interface.
    //[self presentViewController:picker animated:YES completion:nil];
     dispatch_async(dispatch_get_main_queue(), ^{[self.navigationController presentViewController:picker animated:YES completion:nil];});
    
    
    //[self presentModalViewController:picker animated:YES];
    }

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
   [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton *)sender
{
    if ([segue.identifier isEqualToString:seaguewID])
    {
        if ([segue.destinationViewController isKindOfClass:[WebSharingViewController class]])
            [(WebSharingViewController *)segue.destinationViewController setSourceToShare:self.source];
    }
}

- (IBAction)showActivityViewController:(UIButton *)sender {
    NSString *str = @"Image form My app";
    NSArray *postItems = @[self.imageToShare];
    
    UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:postItems applicationActivities:nil];
    
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypePrint,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo];
    
    //if iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController* popup = [[UIPopoverController alloc] initWithContentViewController:activityVC];
        [popup presentPopoverFromRect:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/4, 0, 0)inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
}












@end
