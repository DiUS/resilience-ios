#import <Foundation/Foundation.h>

@class Incident;


@interface IncidentDetails : UIView
- (void) populateWithIncident:(Incident *)incident;
@end