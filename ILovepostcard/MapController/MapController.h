//
//  MapController.h
//  ILovepostcard
//
//  Created by 进 吴 on 12-5-23.
//  Copyright (c) 2012年 开趣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface MapController : UIViewController <MKMapViewDelegate>

@property(nonatomic, retain) MKMapView *myMapView;


@end
