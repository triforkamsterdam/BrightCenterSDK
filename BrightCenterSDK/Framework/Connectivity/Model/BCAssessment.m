#import "BCAssessment.h"

@implementation BCAssessment {

}

- (id) initWithId:(NSString *) id {
    self = [super init];
    if (self) {
        self.id = id;
    }

    return self;
}

+ (id) assessmentWithId:(NSString *) id {
    return [[self alloc] initWithId:id];
}

- (NSString *) description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.id=%@", self.id];
    [description appendString:@">"];
    return description;
}

@end