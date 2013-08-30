#import "BCStudentPickerController.h"
#import "BCLoginController.h"
#import "BCNavigationBar.h"
#import "BCStudent.h"
#import "BCStudentsRepository.h"
#import "BCUserAccount.h"

@implementation BCStudentPickerController {
    BCStudentsRepository *repository;
}

- (id) init {
    self = [super initWithNavigationBarClass:[BCNavigationBar class] toolbarClass:[UIToolbar class]];
    if (self) {
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
            NSLog(@"ERROR: We're sorry, BCStudentPickerController is only supported on iPad at the moment");
            return nil;
        }
        self.viewControllers = @[[BCLoginController new]];

        repository = [BCStudentsRepository instance];

        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(studentPicked:) name:BCStudentPickedNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(loggedIn:) name:BCLoggedInNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(loggedOut:) name:BCLoggedOutNotification object:nil];
        [notificationCenter addObserver:self selector:@selector(close:) name:BCUserWantsToCancelNotification object:nil];
    }
    return self;
}

- (void) close:(NSNotification *) close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loggedIn:(NSNotification *) notification {
    __unsafe_unretained BCStudentPickerController *weakSelf = self;
    [repository loadUserDetails:^(BCUserAccount *account){
        BCNavigationBar *navigationBar = (BCNavigationBar *) weakSelf.navigationBar;
        [navigationBar showLoggedInUserMenu:account];
    } failure:^(NSError *error, BOOL loginFailure) {
        // TODO: Handle failure
    }];
}

- (void) loggedOut:(NSNotification *) notification {
    BCNavigationBar *navigationBar = (BCNavigationBar *) self.navigationBar;
    [navigationBar hideLoggedInUserMenu];
}

- (void) studentPicked:(NSNotification *) notification {
    [self.studentPickerDelegate studentPicked:notification.object];
}

@end