
#import <Foundation/Foundation.h>
#import "Incident.h"

@class Profile;


@interface Incident (Open311)

- (NSDictionary *)asDictionary:(Profile *)profile;
@end