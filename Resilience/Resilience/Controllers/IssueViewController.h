
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Incident.h"
@interface IssueViewController : UIViewController<MKMapViewDelegate>

@property(nonatomic,strong) Incident *incident;

@end
