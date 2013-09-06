@interface BCCredentials : NSObject
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(nonatomic) BOOL invalid;

- (id) initWithUsername:(NSString *) username password:(NSString *) password;

+ (id) credentialsWithUsername:(NSString *) username password:(NSString *) password;

@end