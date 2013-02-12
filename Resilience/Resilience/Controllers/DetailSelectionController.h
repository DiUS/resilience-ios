
@class DetailSelectionController;
@class IncidentCategory;

@protocol DetailSelectionDelegate <NSObject>

- (void) detailSelectionController:(DetailSelectionController *)controller didSelectName:(NSString *)name andCategory:(IncidentCategory *)category;

@end

@interface DetailSelectionController : UITableViewController

@property (nonatomic, weak) id<DetailSelectionDelegate> delegate;

@end