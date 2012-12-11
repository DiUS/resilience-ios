
@interface IncidentCategory : NSObject
+ (IncidentCategory *)categoryFromString:(NSString *)category;

- (NSString *)categoryName;

@end

@interface Wind : IncidentCategory
@end

@interface Fire : IncidentCategory
@end

@interface Water : IncidentCategory
@end

@interface Air : IncidentCategory
@end