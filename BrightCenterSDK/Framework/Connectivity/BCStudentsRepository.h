@class BCCredentials;
@class BCUserAccount;
@class BCAssessmentItemResult;
@class BCAssessment;
@class BCStudent;

@interface BCStudentsRepository : NSObject

@property(nonatomic, strong) BCCredentials *credentials;

+ (BCStudentsRepository *) instance;

- (void) configureForProduction;

- (void) loadGroupsAndStudents:(void (^)(NSArray *groups)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;

- (void) loadUserDetails:(void (^)(BCUserAccount *userAccount)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;

- (void) saveAssessmentItemResult:(BCAssessmentItemResult *) result success:(void (^)()) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;

- (void) loadAssessmentItemResults:(BCAssessment *) assessment student:(BCStudent *) student success:(void (^)(NSArray *assessmentItemResults)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure;

@end