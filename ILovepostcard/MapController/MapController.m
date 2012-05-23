//
//  MapController.m
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import "MapController.h"

@implementation MapController
@synthesize myMapView;

-(void)dealloc
{
    [myMapView release];
    [super dealloc];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    myMapView = [[MKMapView alloc] init];
    myMapView.showsUserLocation = YES;
    myMapView.delegate = self;
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  [[NSUserDefaults standardUserDefaults] setFloat:userLocation.coordinate.latitude forKey:@"latitudeValue"];
  [[NSUserDefaults standardUserDefaults] setFloat:userLocation.coordinate.longitude forKey:@"longitudeValue"];
    NSLog(@"latitudeValue  = %f",[[NSUserDefaults standardUserDefaults] floatForKey:@"latitudeValue"]);
    NSLog(@"longitudeValue = %f",[[NSUserDefaults standardUserDefaults] floatForKey:@"longitudeValue"]);
}
@end
