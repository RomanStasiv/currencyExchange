//
//  MapViewController.m
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/28/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import "MapViewController.h"
#import "AppDelegate.h"
#import "JSONParseCoreDataSave.h"
#import "BranchData.h"

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) __block NSMutableArray *locations;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self fetchData:self.adresses];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    if ([NSJSONSerialization isValidJSONObject:self.locations])
    {
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingString:@"//locations.dat"];
        NSOutputStream *ostream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
        
        [ostream open];
        [NSJSONSerialization writeJSONObject:self.locations
                                    toStream:ostream
                                     options:nil
                                       error:nil];
        [ostream close];
    }
    
}

-(void) fetchData:(NSMutableArray *) adresses
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    path = [path stringByAppendingString:@"//locations.dat"];
    NSData * jsonData = [NSData dataWithContentsOfFile:path];
    
    self.locations = [NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:nil];
    if ([self.locations count])
    {
        for (NSDictionary *location in self.locations )
        {
            if ([adresses indexOfObject:[location valueForKey:@"adress"]] != NSNotFound)
            {
                MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                point.coordinate = CLLocationCoordinate2DMake([[[location valueForKey:@"location"] firstObject] doubleValue],
                                                              [[[location valueForKey:@"location"] lastObject] doubleValue]);
                point.title = [location valueForKey:@"adress"];
                
                [self.mapView addAnnotation:point];
                
                NSLog(@"LOCATION %@ %@", [[location valueForKey:@"location"] firstObject], [[location valueForKey:@"location"] lastObject]);
                
                [adresses removeObject:[location valueForKey:@"adress"]];

            }
        }
    }
    else
    {
        self.locations = [[NSMutableArray alloc] init];
    }
    if ( [adresses count] )
    {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [self placePinForAdressAtIndex:@0 fromAdresses:adresses withGeocoder:geocoder];
    }
}

-(void) placePinForAdressAtIndex:(NSNumber *) indexTemp
                    fromAdresses:(NSArray *) adresses
                    withGeocoder:(CLGeocoder *) geocoder
{
    __block NSNumber *index = indexTemp;
    [geocoder geocodeAddressString:[adresses objectAtIndex:[index integerValue]]
                 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
         if (!error)
         {
             for (CLPlacemark *placemark in placemarks)
             {
                 MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                 point.coordinate = placemark.location.coordinate;
                 point.title = [adresses objectAtIndex:[index integerValue]];
                 
                 [self.mapView addAnnotation:point];
                 
                 NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
                 [temp setValue:[adresses objectAtIndex:[index integerValue]]
                         forKey:@"adress"];
                 
                 NSMutableArray *coordinates = [[NSMutableArray alloc] init];
                 [coordinates addObject:[NSNumber numberWithDouble:placemark.location.coordinate.latitude]];
                 [coordinates addObject:[NSNumber numberWithDouble:placemark.location.coordinate.longitude]];
                 [temp setValue:coordinates
                         forKey:@"location"];
                 
                 [self.locations addObject:temp];
             }
         }
         else
         {
             NSLog(@"ERROR! Trying to geocode bank at: %@", [adresses objectAtIndex:[index integerValue]]);
         }
         int indexInt = [index intValue];
         index = [NSNumber numberWithInt:++indexInt];
         if ( [index intValue] < [adresses count])
         {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.2 * NSEC_PER_SEC),
                            dispatch_get_main_queue(), ^{
                 [self placePinForAdressAtIndex:index fromAdresses:adresses withGeocoder:geocoder];
             });
         }
         
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
