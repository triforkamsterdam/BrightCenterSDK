#import "BCStudentsRepository.h"
#import "BCGroup.h"
#import "BCStudent.h"
#import "BCUserAccount.h"
#import "BCCredentials.h"
#import "BCAssessmentItemResult.h"
#import "BCAssessment.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "NSObject+JsonUtils.h"

#define SANDBOX_URL @"https://tst-brightcenter.trifork.nl"
//#define PRODUCTION_URL @"does not exist yet"

@implementation BCStudentsRepository {

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

- (id) init {
    self = [super init];
    if (self) {
        // TODO: When production server is ready, change this default to configureForProduction.
        [self configureForSandbox];
    }
    return self;
}

- (void) setCredentials:(BCCredentials *) credentials {
    _credentials = credentials;
    [client setAuthorizationHeaderWithUsername:credentials.username password:credentials.password];
}

- (void) configureForSandbox {
    client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:SANDBOX_URL]];
}

//- (void) configureForProduction {
//    client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:PRODUCTION_URL]];
//}

- (void) loadGroupsAndStudents:(void (^)(NSArray *groups)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET"
                                                    path:@"/api/groups"
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
                NSString *studentId = studentJson[@"id"];
                [group addStudent:[BCStudent studentWithId:studentId group:group firstName:firstName lastName:lastName]];
            }
        }
        if (success) {
            success(groups);
        }
    };
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:httpSuccess
                                                     failure:[self createHttpFailureCallback:failure]] start];
}

- (void) loadUserDetails:(void (^)(BCUserAccount *userAccount)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET"
                                                    path:@"/api/userDetails"
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
        if (success) {
            success(account);
        }
    };
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:httpSuccess
                                                     failure:[self createHttpFailureCallback:failure]] start];
}

- (void) saveAssessmentItemResult:(BCAssessmentItemResult *) result success:(void (^)()) success
                          failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    if (result.assessment.id.length == 0) {
        NSLog(@"ERROR - BCStudentsRepository.loadAssessmentItemResults: assessment.id cannot be nil");
        return;
    }
    if (result.student.id.length == 0) {
        NSLog(@"ERROR - BCStudentsRepository.loadAssessmentItemResults: student.id cannot be nil");
        return;
    }

    NSString *path = [NSString stringWithFormat:@"/api/assessment/%@/student/%@/assessmentItemResult/%@", result.assessment.id, result.student.id, result.questionId];

    NSString *completionStatusString = @"UNKNOWN";
    if (result.completionStatus == BCCompletionStatusCompleted) {
        completionStatusString = @"COMPLETED";
    } else if (result.completionStatus == BCCompletionStatusIncomplete) {
        completionStatusString = @"INCOMPLETE";
    } else if (result.completionStatus == BCCompletionStatusNotAttempted) {
        completionStatusString = @"NOT_ATTEMPTED";
    }

    NSDictionary *requestJson = @{
            @"score" : @(result.score),
            @"duration" : @(result.duration),
            @"attempts" : @(result.attempts),
            @"completionStatus" : completionStatusString
    };
    NSMutableURLRequest *urlRequest = [client requestWithMethod:@"PUT"
                                                    path:path
                                              parameters:nil];
    urlRequest.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestJson options:0 error:nil];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];


    void (^httpSuccess)(NSURLRequest *, NSHTTPURLResponse *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        if (success) {
            success();
        }
    };

    [[AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:httpSuccess
                                                     failure:[self createHttpFailureCallback:failure]] start];
}

- (void) loadAssessmentItemResults:(BCAssessment *) assessment student:(BCStudent *) student success:(void (^)(NSArray *assessmentItemResults)) success
                           failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    if (assessment.id.length == 0) {
        NSLog(@"ERROR - BCStudentsRepository.loadAssessmentItemResults: assessment.id cannot be nil");
        return;
    }
    if (student.id.length == 0) {
        NSLog(@"ERROR - BCStudentsRepository.loadAssessmentItemResults: student.id cannot be nil");
        return;
    }
    NSString *path = [NSString stringWithFormat:@"/api/assessment/%@/students/%@/assessmentItemResult", assessment.id, student.id];
    NSURLRequest *urlRequest = [client requestWithMethod:@"GET"
                                                    path:path
                                              parameters:nil];

    void (^httpSuccess)(NSURLRequest *, NSHTTPURLResponse *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, id json) {
        NSMutableArray *results = [NSMutableArray new];
        NSArray *resultsJson = json;
        for (NSDictionary *resultJson in resultsJson) {
            NSDate *date = [resultJson[@"date"] jsonDateValue];
            NSString *questionId = resultJson[@"questionId"];
            CGFloat duration = [resultJson[@"duration"] jsonFloatValue];
            NSInteger score = [resultJson[@"score"] jsonIntegerValue];
            NSInteger attempts = [resultJson[@"attempts"] jsonIntegerValue];
            NSString *completionStatusString = resultJson[@"completionStatus"];
            BCCompletionStatus completionStatus = BCCompletionStatusUnknown;

            if ([@"COMPLETED" isEqualToString:completionStatusString]) {
                completionStatus = BCCompletionStatusCompleted;
            } else if ([@"INCOMPLETE" isEqualToString:completionStatusString]) {
                completionStatus = BCCompletionStatusIncomplete;
            } else if ([@"NOT_ATTEMPTED" isEqualToString:completionStatusString]) {
                completionStatus = BCCompletionStatusNotAttempted;
            }

            BCAssessmentItemResult *result = [BCAssessmentItemResult new];
            result.questionId = questionId;
            result.attempts = attempts;
            result.duration = duration;
            result.score = score;
            result.completionStatus = completionStatus;
            result.date = date;
            result.student = student;
            result.assessment = assessment;
            [results addObject:result];
        }

        if (success) {
            success(results);
        }
    };
    [[AFJSONRequestOperation JSONRequestOperationWithRequest:urlRequest success:httpSuccess
                                                     failure:[self createHttpFailureCallback:failure]] start];
}

- (void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id)) createHttpFailureCallback:(void (^)(NSError *, BOOL)) failure {
    void (^httpFailure)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id o) {
        BOOL loginFailed = response.statusCode == 401;
        NSLog(@"ERROR - BCStudentsRepository: request failed: %@", error);
        if (failure) {
            failure(error, loginFailed);
        }
    };
    return httpFailure;
}

@end