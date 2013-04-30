#import <Foundation/Foundation.h>

@interface DataStore : NSObject

+ (id)loadObjectForKey:(NSString *)key;

+ (void)saveObject:(id)object forKey:(NSString *)key;

+ (NSString *)getPrivateDocsDir;
@end