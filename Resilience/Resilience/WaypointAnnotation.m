//
//  WaypointAnnotation.m
//  My Ride Atlas
//
//  Created by Daryl Wilding-McBride on 3/05/11.
//  Copyright 2011 Gee Whiz Technology. All rights reserved.
//

#import "WaypointAnnotation.h"


@implementation WaypointAnnotation

@synthesize coordinate = _coordinate;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize markerType = _markerType;
@synthesize ID = _ID;

+ (id)annotationWithCoordinate:(CLLocationCoordinate2D)coordinate {
    return [[[self class] alloc] initWithCoordinate:coordinate];
}

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (nil != self) {
        self.coordinate = coordinate;
    }
    return self;
}

@end
