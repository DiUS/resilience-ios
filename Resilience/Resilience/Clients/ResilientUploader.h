#import <Foundation/Foundation.h>

@class Open311Client;
@class Incident;

@interface ResilientUploader : NSObject
+ (ResilientUploader *)sharedUploader;

- (id)initWithClient:(Open311Client *)client;

- (void)saveIncident:(Incident *)incident;

- (void)uploadQueuedIncident;

@end