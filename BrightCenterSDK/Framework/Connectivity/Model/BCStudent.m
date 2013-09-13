#import "BCStudent.h"
#import "BCGroup.h"

@implementation BCStudent {

}

- (id) initWithId:(NSString *) id group:(BCGroup *) group firstName:(NSString *) firstName lastName:(NSString *) lastName {
    self = [super init];
    if (self) {
        _id = id;
        _group = group;
        _firstName = firstName;
        _lastName = lastName;
    }
    return self;
}

+ (id) studentWithId:(NSString *) id group:(BCGroup *) group firstName:(NSString *) firstName lastName:(NSString *) lastName {
    return [[self alloc] initWithId:id group:group firstName:firstName lastName:lastName];
}

- (NSString *) fullName {
    if (!self.firstName) {
        return self.lastName;
    }
    if (!self.lastName) {
        return self.firstName;
    }
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSString *) description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"self.id=%@", self.id];
    [description appendFormat:@", self.group=%@", self.group];
    [description appendFormat:@", self.firstName=%@", self.firstName];
    [description appendFormat:@", self.lastName=%@", self.lastName];
    [description appendString:@">"];
    return description;
}

@end