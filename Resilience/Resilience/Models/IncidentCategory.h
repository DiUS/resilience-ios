#import "MTLModel+NSCoding.h"
#import "MTLJSONAdapter.h"

@interface IncidentCategory : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;

+ (NSArray *)loadCategories;

+ (void)saveCategories:(NSArray *)categories;
@end
