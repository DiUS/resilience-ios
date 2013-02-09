
@class CategorySelectionController;
@class IncidentCategory;

@protocol CategorySelectionDelegate <NSObject>

- (void) categorySelectionController:(CategorySelectionController *)controller didSelectCategory:(IncidentCategory *)category;

@end

@interface CategorySelectionController : UITableViewController

@property (nonatomic, weak) id<CategorySelectionDelegate> delegate;

@end