#import "BCStudentsRepository.h"
#import "BCGroup.h"
#import "BCStudent.h"
#import "BCUserAccount.h"
#import "BCCredentials.h"
#import "BCAssessmentItemResult.h"
#import "BCAssessment.h"

@implementation BCStudentsRepository {

    // TODO: Remove this array when assessment item results are stored in the backend
    NSMutableArray *savedAssessmentItemResults;
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
        savedAssessmentItemResults = [NSMutableArray new];
    }
    return self;
}

- (void) loadGroupsAndStudents:(void (^)(NSArray *groups)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    if (![self repositoryIsFullyConfigured]) {
        return;
    }

    BCGroup *group1 = [BCGroup groupWithName:@"Groep 4"];
    group1.students = @[
            [BCStudent studentWithName:@"Vina Mcintyre"],
            [BCStudent studentWithName:@"Francisco Brighton"],
            [BCStudent studentWithName:@"Alethea Goetz"],
            [BCStudent studentWithName:@"Tomi Odowd"],
            [BCStudent studentWithName:@"Dollie Demers"],
            [BCStudent studentWithName:@"Kristy Hodder"],
            [BCStudent studentWithName:@"Hilaria Berthelot"],
            [BCStudent studentWithName:@"Roderick Auvil"]
    ];

    BCGroup *group2 = [BCGroup groupWithName:@"Groep 5a"];
    group2.students = @[
            [BCStudent studentWithName:@"Leerling 1"],
            [BCStudent studentWithName:@"Leerling 2"],
            [BCStudent studentWithName:@"Leerling 3"]
    ];

    BCGroup *group3 = [BCGroup groupWithName:@"Groep 5b"];
    group3.students = @[
            [BCStudent studentWithName:@"Leerling 4"],
            [BCStudent studentWithName:@"Leerling 5"],
            [BCStudent studentWithName:@"Leerling 6"],
            [BCStudent studentWithName:@"Leerling 7"]
    ];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // TODO: Replace sleep + static data with call to backend
        [NSThread sleepForTimeInterval:1.0];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_sync(mainQueue, ^{
            if ([self invalidCredentials]) {
                if (failure) {
                    failure(nil, YES);
                }
                return;
            }
            if (success) {
                success(@[group1, group2, group3]);
            }
        });
    });
}

- (void) loadUserDetails:(void (^)(BCUserAccount *userAccount)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    if (![self repositoryIsFullyConfigured]) {
        return;
    }

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // TODO: Replace sleep + static data with call to backend
        [NSThread sleepForTimeInterval:1.0];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_sync(mainQueue, ^{
            if ([self invalidCredentials]) {
                if (failure) {
                    failure(nil, YES);
                }
                return;
            }
            BCUserAccount *userAccount = [BCUserAccount new];
            userAccount.fullName = @"Tom van Zummeren";
            success(userAccount);
        });
    });
}

- (void) saveAssessmentItemResult:(BCAssessmentItemResult *) result success:(void (^)()) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    if (![self repositoryIsFullyConfigured]) {
        return;
    }
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
            if ([self invalidCredentials]) {
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

- (void) loadAssessmentItemResults:(BCAssessment *) assessment student:(BCStudent *) student success:(void (^)(NSArray *assessmentItemResults)) success failure:(void (^)(NSError *error, BOOL loginFailure)) failure {
    if (![self repositoryIsFullyConfigured]) {
        return;
    }
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        // TODO: Replace sleep + static data with call to backend
        [NSThread sleepForTimeInterval:1.0];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_sync(mainQueue, ^{
            if ([self invalidCredentials]) {
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

- (BOOL) invalidCredentials {
    return ![@"leraar" isEqualToString:self.credentials.username];
}

// TODO: Move this to the HttpRequest class or whatever class that will make the connection with the backend
- (BOOL) repositoryIsFullyConfigured {
    if (!self.credentials) {
        NSLog(@"ERROR: Missing credentials. Did you log in first?");
        return NO;
    }
    return YES;
}

@end