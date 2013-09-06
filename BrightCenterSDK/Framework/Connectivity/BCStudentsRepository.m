#import "BCStudentsRepository.h"
#import "BCGroup.h"
#import "BCStudent.h"
#import "BCUserAccount.h"
#import "BCCredentials.h"
#import "BCAssessmentItemResult.h"
#import "BCAssessment.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

#define SANDBOX_URL @"https://tst-brightcenter.trifork.nl"
//#define PRODUCTION_URL @"does not exist yet"

@implementation BCStudentsRepository {

    // TODO: Remove this array when assessment item results are stored in the backend
    NSMutableArray *savedAssessmentItemResults;

    AFHTTPClient *client;
}

+ (BCStudentsRepository *) instance {
    static BCStudentsRepository *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }
    return _instance;
}

- (void) setCredentials:(BCCredentials *) credentials {
    _credentials = credentials;
    [client setAuthorizationHeaderWithUsername:credentials.username password:credentials.password];
}

- (void) configureForSandbox {
    [self configureClientWithBaseUrl:SANDBOX_URL];
}

//- (void) configureForProduction {
//    [self configureClientWithBaseUrl:PRODUCTION_URL];
//}

- (void) configureClientWithBaseUrl:(NSString *) baseUrl {
    client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:baseUrl]];
}

- (id) init {
    self = [super init];
    if (self) {
        savedAssessmentItemResults = [NSMutableArray new];
        // TODO: When production server is ready, change this default to configureForProduction.
        [self configureForSandbox];
    }
    return self;
}

- (void) loadGroupsAndStudents:(void (^)(NSArray *groups)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET"
                                                    path:@"/groups"
                                              parameters:nil];

    void (^httpSuccess)(NSURLRequest *, NSHTTPURLResponse *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSArray *groupsJson = json;
        NSMutableArray *groups = [NSMutableArray new];
        for (NSDictionary *groupJson in groupsJson) {
            NSString *id = groupJson[@"id"];
            NSString *name = groupJson[@"name"];
            NSString *schoolId = groupJson[@"schoolId"];
            BCGroup *group = [BCGroup groupWithId:id name:name schoolId:schoolId];
            [groups addObject:group];

            NSArray *studentsJson = groupJson[@"students"];
            for (NSDictionary *studentJson in studentsJson) {
                NSString *firstName = studentJson[@"firstName"];
                NSString *lastName = studentJson[@"lastName"];
                NSString *studentId = studentJson[@"studentId"];
                [group addStudent:[BCStudent studentWithId:studentId group:group firstName:firstName lastName:lastName]];
            }
        }
        success(groups);
    };
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:httpSuccess
                                                     failure:[self createHttpFailureCallback:failure]] start];
}

- (void) loadUserDetails:(void (^)(BCUserAccount *userAccount)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET"
                                                    path:@"/userDetails"
                                              parameters:nil];

    void (^httpSuccess)(NSURLRequest *, NSHTTPURLResponse *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSString *id = json[@"id"];
        NSString *firstName = json[@"firstName"];
        NSString *lastName = json[@"lastName"];
        NSString *roleString = json[@"role"];

        BCRole role = BCRoleUnknown;
        if ([@"TEACHER" isEqualToString:roleString]) {
            role = BCRoleTeacher;
        } else if ([@"ADMIN" isEqualToString:roleString]) {
            role = BCRoleAdmin;
        } else if ([@"APP_DEVELOPER" isEqualToString:roleString]) {
            role = BCRoleAppDeveloper;
        }

        BCUserAccount *account = [BCUserAccount accountWithId:id
                                                    firstName:firstName
                                                     lastName:lastName
                                                         role:role];
        success(account);
    };
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:httpSuccess
                                                     failure:[self createHttpFailureCallback:failure]] start];
}

- (void) saveAssessmentItemResult:(BCAssessmentItemResult *) result
                          success:
                                  (void (^)()) success
                          failure:
                                  (void (^)(NSError *error, BOOL loginFailure)) failure {
    BCAssessmentItemResult *resultToRemove = nil;
    for (BCAssessmentItemResult *savedResult in savedAssessmentItemResults) {
        if ([savedResult hasSameQuestionAndStudent:result]) {
            resultToRemove = savedResult;
        }
    }
    if (resultToRemove) {
        [savedAssessmentItemResults removeObject:resultToRemove];
    }
    [savedAssessmentItemResults addObject:result];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // TODO: Replace sleep + static data with call to backend
        [NSThread sleepForTimeInterval:1.0];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_sync(mainQueue, ^{
            if ([self invalidDummyCredentials]) {
                if (failure) {
                    failure(nil, YES);
                }
                return;
            }
            if (success) {
                success();
            }
        });
    });
}

- (void) loadAssessmentItemResults:(BCAssessment *) assessment
                           student:
                                   (BCStudent *) student
                           success:
                                   (void (^)(NSArray *assessmentItemResults)) success
                           failure:
                                   (void (^)(NSError *error, BOOL loginFailure)) failure {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // TODO: Replace sleep + static data with call to backend
        [NSThread sleepForTimeInterval:1.0];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_sync(mainQueue, ^{
            if ([self invalidDummyCredentials]) {
                if (failure) {
                    failure(nil, YES);
                }
                return;
            }
            if (success) {
                success(savedAssessmentItemResults);
            }
        });
    });
}

- (BOOL) invalidDummyCredentials {
    return ![@"leraar" isEqualToString:self.credentials.username];
}

- (void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id)) createHttpFailureCallback:(void (^)(NSError *, BOOL)) failure {
    void (^httpFailure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id o) {
        // TODO: Backend should return a 401 status code instead. Remove the "text/html" check once the backend properly responds this way.
        BOOL loginFailed = [response.allHeaderFields[@"Content-Type"] hasPrefix:@"text/html"] || response.statusCode == 401;
        failure(error, loginFailed);
    };
    return httpFailure;
}

@end