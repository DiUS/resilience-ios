
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Incident.h"

@class IncidentViewController;

@protocol IncidentViewControllerDelegate
- (void)detailViewControllerDidResolveIncidentAndClose:(IncidentViewController *)detailViewController;
@end

@interface IncidentViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic,strong) Incident *incident;
@property(nonatomic, weak) id<IncidentViewControllerDelegate> delegate;

@end
