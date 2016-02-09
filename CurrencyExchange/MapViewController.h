//
//  MapViewController.h
//  CurrencyExchange
//
//  Created by Roman Stasiv on 1/28/16.
//  Copyright © 2016 Roman Stasiv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapViewController : UIViewController <MKMapViewDelegate>

-(void) adressesToDisplay:(NSMutableArray *) arrayOfAdress withNames:(NSMutableArray *) arrayOfNames  centerOn: (NSString*) centralString;
@property (strong, nonatomic) NSMutableArray *adresses;
@property (strong, nonatomic) NSMutableArray *bankNames;

@end
