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

typedef enum {kFireMarker, kWindMarker, kWaterMarker} MarkerType;

@interface WaypointAnnotation : NSObject <MKAnnotation> {
    CLLocationCoordinate2D _coordinate;
    NSString *_title;
    NSString *_subtitle;
    MarkerType _markerType;
}

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, assign) MarkerType markerType;

@end
