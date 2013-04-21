#import <Foundation/Foundation.h>

@class Incident;


@interface IncidentFooter : UIView
- (void) populateWithIncident:(Incident *)incident;
@end