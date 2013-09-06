#import "BCCredentials.h"

@implementation BCCredentials {

}
- (id) initWithUsername:(NSString *) username password:(NSString *) password {
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }

    return self;
}

+ (id) credentialsWithUsername:(NSString *) username password:(NSString *) password {
    return [[self alloc] initWithUsername:username password:password];
}

@end