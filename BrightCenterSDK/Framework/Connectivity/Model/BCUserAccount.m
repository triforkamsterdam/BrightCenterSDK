#import "BCUserAccount.h"

@implementation BCUserAccount {

}
- (id) initWithId:(NSString *) id firstName:(NSString *) firstName lastName:(NSString *) lastName role:(BCRole) role {
    self = [super init];
    if (self) {
        _id = id;
        _firstName = firstName;
        _lastName = lastName;
        _role = role;
    }
    return self;
}

+ (id) accountWithId:(NSString *) id firstName:(NSString *) firstName lastName:(NSString *) lastName role:(BCRole) role {
    return [[self alloc] initWithId:id firstName:firstName lastName:lastName role:role];
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

@end