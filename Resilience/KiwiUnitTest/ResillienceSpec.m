
#import "Kiwi.h"


SPEC_BEGIN(ResilienceSpec)

describe(@"Resilience", ^{

  it(@"should do something", ^{
    NSString *value = @"Some string";
    [[value should] equal:@"Some string"];
  });
    
});

SPEC_END