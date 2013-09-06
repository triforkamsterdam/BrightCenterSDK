typedef enum {
  BCRoleUnknown,
  BCRoleTeacher,      // TEACHER
  BCRoleAdmin,        // ADMIN
  BCRoleAppDeveloper  // APP_DEVELOPER
} BCRole;

@interface BCUserAccount : NSObject

@property (readonly) NSString *id;
@property (readonly) NSString *firstName;
@property (readonly) NSString *lastName;
@property (readonly) BCRole role;
@property (readonly) NSString *fullName;

- (id) initWithId:(NSString *) id firstName:(NSString *) firstName lastName:(NSString *) lastName role:(BCRole) role;

+ (id) accountWithId:(NSString *) id firstName:(NSString *) firstName lastName:(NSString *) lastName role:(BCRole) role;

@end