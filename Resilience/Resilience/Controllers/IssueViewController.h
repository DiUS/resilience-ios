
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Incident.h"

@class IssueViewController;

@protocol IssueViewControllerDelegate
- (void)detailViewControllerDidResolveIssueAndClose:(IssueViewController *)detailViewController;
@end

@interface IssueViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic,strong) Incident *incident;
@property(nonatomic, weak) id<IssueViewControllerDelegate> delegate;

@end
