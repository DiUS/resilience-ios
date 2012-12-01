
@interface Incident : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *subCategory;

- (id)initWithName:(NSString *)name;


//        private Impact scale;
//        private Point point;

@end