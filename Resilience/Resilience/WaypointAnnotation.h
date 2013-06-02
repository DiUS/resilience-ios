//
//  WaypointAnnotation.h
//  My Ride Atlas
//
//  Created by Daryl Wilding-McBride on 3/05/11.
//  Copyright 2011 Gee Whiz Technology. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "IncidentCategory.h"
#import "Incident.h"

@interface WaypointAnnotation : NSObject <MKAnnotation>

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, strong) IncidentCategory *category;
@property (nonatomic, strong) Incident *incident;

@end
