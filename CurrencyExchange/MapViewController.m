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
@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mapView.delegate = self;
    
    self.context = [AppDelegate singleton].managedObjectContext;
    
    JSONParseCoreDataSave * jsonParser = [[JSONParseCoreDataSave alloc] init];
    //[jsonParser loadCoreDataObjects];
    
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"BranchData"];
    
    NSArray *temp = [self.context executeFetchRequest:fetchRequest error:nil];
    
    NSMutableArray *adresses = [[NSMutableArray alloc] init];
    
    for (BranchData *branch in temp)
    {
        NSString *temp = [NSString stringWithFormat:@"%@, %@, %@, Украина", branch.address, branch.city, branch.region ];
        [adresses addObject:temp];
    }
    NSLog(@"%@", adresses);
    
    [self startForwardGeocodingOfAdresses:adresses];
}

-(void) startForwardGeocodingOfAdresses:(NSArray *) adresses
{
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
             }
         }
         else
         {
             NSLog([NSString stringWithFormat:@"request limit! cache it, baca!! at index: %@", index ]);
         }
         int indexInt = [index intValue];
         index = [NSNumber numberWithInt:++indexInt];
         if ( [index intValue] < [adresses count])
         {
             [self placePinForAdressAtIndex:index fromAdresses:adresses withGeocoder:geocoder];
         }
    }];
}

-(NSArray *) fillArrayWithTestData
{
    NSMutableArray *adresses = [[NSMutableArray alloc] init];
    [adresses addObject:@"ул. Соборная, 94, Ровенская область, Украина"];
    [adresses addObject:@"ул. Батумская, 11, Днепропетровская область, Украина"];
    [adresses addObject:@"пр-т Коцюбинского, 16, Винница, Винницкая область, Украина"];
    [adresses addObject:@"пр-т Ленина, 234, Запорожье, Запорожская область, Украина"];
    [adresses addObject:@"ул. Владимира Великого, 12А, Ивано-Франковск, Ивано-Франковская область, Украина"];
    [adresses addObject:@"ул. Леси Украинки, 10, Тернополь, Тернопольская область, Украина"];
    
    return adresses;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    // Add an annotation
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
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
