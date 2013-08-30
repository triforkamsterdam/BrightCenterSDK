#import "BCLoginController.h"
#import "BCLogo.h"
#import "BCLoginView.h"
#import "BCSplitController.h"
#import "BCStudentsRepository.h"
#import "MBProgressHUD.h"
#import "BCCredentials.h"

#define LOGIN_VIEW_WIDTH 475.0
#define LOGIN_VIEW_HEIGHT 320.0

@implementation BCLoginController {

    BCLogo *backgroundView;

    BCLoginView *loginView;

    CGFloat loginViewY;

    BOOL keyboardShowing;

    MBProgressHUD *progressHud;

    BCStudentsRepository *repository;

    void (^errorHandler)(NSError *, BOOL);
}

- (void) viewDidLoad {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    repository = [BCStudentsRepository instance];

    self.view.backgroundColor = [UIColor colorWithRed:79 / 255.0 green:79 / 255.0 blue:79 / 255.0 alpha:1.0];

    backgroundView = [[BCLogo alloc] initWithColor:[UIColor colorWithRed:71 / 255.0 green:71 / 255.0 blue:71 / 255.0 alpha:1.0]];
    [self.view addSubview:backgroundView];

    loginView = [BCLoginView new];
    [self.view addSubview:loginView];

    __unsafe_unretained BCLoginController *weakSelf = self;
    loginView.loginButtonTapped = ^{
        weakSelf->repository.credentials = weakSelf->loginView.credentials;
        [weakSelf loginWithCredentials:NO];
    };

    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    errorHandler = [^(NSError *error, BOOL loginFailure) {
        [weakSelf->progressHud hide:YES];
        if (loginFailure) {
            [weakSelf handleLoginFailure];
        } else {
            [weakSelf showAlertView:error];
        }
    } copy];

    if (repository.credentials && !repository.credentials.invalid) {
        [self loginWithCredentials:YES];
    }
}

- (void) loginWithCredentials:(BOOL) pushImmediately {
    BCSplitController *splitViewController = [BCSplitController new];
    if (pushImmediately) {
        [self.navigationController pushViewController:splitViewController animated:NO];
    }

    progressHud = [MBProgressHUD showHUDAddedTo:pushImmediately ? [splitViewController studentListView] : self.view animated:NO];
    progressHud.animationType = MBProgressHUDAnimationZoomIn;

    __unsafe_unretained BCLoginController *weakSelf = self;
    [repository loadGroupsAndStudents:^(NSArray *groups) {
        // Result received, so login was successful!
        [[NSNotificationCenter defaultCenter] postNotificationName:BCLoggedInNotification object:nil];

        splitViewController.groups = groups;

        [weakSelf->progressHud hide:YES];

        if (!pushImmediately) {
            [self.navigationController pushViewController:splitViewController animated:YES];
        }
    } failure:errorHandler];
}

- (void) showAlertView:(NSError *) error {
    [[[UIAlertView alloc] initWithTitle:@"Verbindingsfout"
                               message:[NSString stringWithFormat:@"Er is iets misgegaan tijdens de communicatie met "
                                                                          "Bright Center.\n\n%@", error.localizedDescription]
                              delegate:nil
                     cancelButtonTitle:nil
                     otherButtonTitles:@"OK", nil] show];
}

- (void) handleLoginFailure {
    if (![self.navigationController.topViewController isKindOfClass:[BCLoginController class]]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }

    // If pop to login form was necessary, the password was changed while logged in, so we're now logging out.
    [[NSNotificationCenter defaultCenter] postNotificationName:BCLoggedOutNotification object:nil];
    repository.credentials.invalid = YES;

    [loginView handleLoginFailure];
}

- (void) keyboardWillShow:(NSNotification *) notification {
    NSLog(@"will show");
    keyboardShowing = YES;
    [self positionLoginView:YES];
}

- (void) keyboardWillHide:(NSNotification *) notification {
    NSLog(@"will hide");
    keyboardShowing = NO;
    [self positionLoginView:YES];
}

- (void) positionLoginView:(BOOL) animated {
    [UIView animateWithDuration:animated ? .25 : 0 animations:^{
        CGFloat y = UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && keyboardShowing ? 0.0 : loginViewY;
        loginView.frame = CGRectMake(loginView.frame.origin.x, y, loginView.frame.size.width, loginView.frame.size.height);
    }];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGSize size = self.view.frame.size;
    CGFloat logoSize = MIN(size.width, size.height) * 1.35;
    backgroundView.frame = CGRectMake(size.width * .222, size.height * -.03, logoSize, logoSize);

    loginViewY = (self.view.frame.size.height / 2.0) - (LOGIN_VIEW_HEIGHT / 2.0);
    loginView.frame = CGRectMake(
            (size.width / 2.0) - (LOGIN_VIEW_WIDTH / 2.0),
            keyboardShowing && UIInterfaceOrientationIsLandscape(self.interfaceOrientation) ? 0.0 : loginViewY,
            LOGIN_VIEW_WIDTH,
            LOGIN_VIEW_HEIGHT
    );
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void) viewWillAppear:(BOOL) animated {
    [loginView clear];
}

@end