//
//  ViewController.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/26/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MainScreenViewController.h"
#import "JSONParseCoreDataSave.h"
#import "TestCoreData.h"
#import "Fetcher.h"

//static const char *MainScreenViewControllerTimerQueueContext = "MainScreenViewControllerTimerQueueContext";

@interface MainScreenViewController ()
@property (weak, nonatomic) IBOutlet UIView *graph;

//@property (strong, nonatomic) MSWeakTimer *timer;
//@property (strong, nonatomic) MSWeakTimer *backgroundTimer;
@property (strong, nonatomic) JSONParseCoreDataSave * workObject;
//@property (strong, nonatomic) dispatch_queue_t privateQueue;
//
@end

@implementation MainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.workObject = [[JSONParseCoreDataSave alloc] init];
    TestCoreData* testObject = [[TestCoreData alloc] init];
    Fetcher*tmp = [[Fetcher alloc]init];
    
     //NSLog(@"Documents Directory: %@", [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject]);
    
    //[self.workObject deleteAllObjectsFromCoreData];
    //[self.workObject JSONParse];
    //[workObject loadCoreDataObjects];
    [tmp allBanksQuantity];
    //[testObject insertFakeDataToCoreData];
    [tmp dataForTableView];
    self.graph.backgroundColor = [UIColor blackColor];
   NSTimer* Timer = [NSTimer scheduledTimerWithTimeInterval:30.0
                                                    target: self.workObject
                                                  selector: @selector(JSONParse)
                                                  userInfo: nil
                                                   repeats: YES];
    
//self.timer = [MSWeakTimer scheduledTimerWithTimeInterval: 20
//                                                      target:self.workObject
//                                                    selector:@selector(JSONParse)
//                                                    userInfo:nil
//                                                     repeats:YES
//                                               dispatchQueue:dispatch_get_main_queue()];

}

//- (id)init
//{
//    if ((self = [super init]))
//    {
//        self.privateQueue = dispatch_queue_create("com.mindsnacks.private_queue", DISPATCH_QUEUE_CONCURRENT);
//        
//        self.backgroundTimer = [MSWeakTimer scheduledTimerWithTimeInterval:0.2
//                                                                    target:self.workObject
//                                                                  selector:@selector(JSONParse)
//                                                                  userInfo:nil
//                                                                   repeats:YES
//                                                             dispatchQueue:self.privateQueue];
//        
//        dispatch_queue_set_specific(self.privateQueue, (__bridge const void *)(self), (void *)MainScreenViewControllerTimerQueueContext, NULL);
//    }
//    
//    return self;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MSWeakTimerDelegate

//- (void)mainThreadTimerDidFire:(MSWeakTimer *)timer
//{
//    NSAssert([NSThread isMainThread], @"This should be called from the main thread");
//    
//   }
//
//#pragma mark -
//
//- (void)backgroundTimerDidFire
//{
//    NSAssert(![NSThread isMainThread], @"This shouldn't be called from the main thread");
//    
//    const BOOL calledInPrivateQueue = dispatch_queue_get_specific(self.privateQueue, (__bridge const void *)(self)) == MainScreenViewControllerTimerQueueContext;
//    NSAssert(calledInPrivateQueue, @"This should be called on the provided queue");
//}

@end
