@class BCCredentials;
@class BCUserAccount;
@class BCAssessmentItemResult;
@class BCAssessment;

@interface BCStudentsRepository : NSObject

@property(nonatomic, strong) BCCredentials *credentials;
@property(nonatomic, strong) BCAssessment *assessment;

+ (BCStudentsRepository *) instance;

- (void) loadGroupsAndStudents:(void (^)(NSArray *groups)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;

- (void) loadUserDetails:(void (^)(BCUserAccount *userAccount)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;

- (void) saveAssessmentItemResult:(BCAssessmentItemResult *) result success:(void (^)()) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;

- (void) loadAssessmentItemResults:(void (^)(NSArray *assessmentItemResults)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;

@end