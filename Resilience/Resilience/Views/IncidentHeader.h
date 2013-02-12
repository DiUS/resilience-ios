#import <Foundation/Foundation.h>
@class Incident;

@interface IncidentHeader : UIView
- (void) populateWithIncident:(Incident *)incident;
@end