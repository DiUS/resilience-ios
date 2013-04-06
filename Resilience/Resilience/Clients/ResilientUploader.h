#import <Foundation/Foundation.h>

@class AFHTTPClient;

@interface ResilientUploader : NSObject
- (id)initWithClient:(AFHTTPClient *)client;

- (void)uploadWithBlock:(void (^)())operation;
@end