#import "BCStudent.h"

@implementation BCStudent {

}

- (id) initWithName:(NSString *) name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

+ (id) studentWithName:(NSString *) name {
    return [[self alloc] initWithName:name];
}

@end