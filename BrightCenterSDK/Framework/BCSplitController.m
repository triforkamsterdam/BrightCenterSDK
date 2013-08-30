#import "BCSplitController.h"
#import "BCGroupListController.h"
#import "BCStudentListController.h"
#import "BCLoggedInUserView.h"
#import "BCLoginController.h"

#define GROUP_LIST_WIDTH 320.0

@implementation BCSplitController {

    BCGroupListController *groupListController;

    BCStudentListController *studentListController;
}

- (id) init {
    self = [super init];
    if (self) {
       // TODO: Enable for iOS 7 support (needs to be disabled right now or else Cocoapods does not accept our build)
//        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
//            self.edgesForExtendedLayout = UIRectEdgeNone;
//        }

        studentListController = [BCStudentListController new];
        [self embedController:studentListController];

        groupListController = [BCGroupListController new];
        [self embedController:groupListController];
        groupListController.studentListController = studentListController;

        self.navigationItem.hidesBackButton = YES;
    }
    return self;
}

- (UIView *) studentListView {
    return studentListController.view;
}

- (void) viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doLogOut:) name:BCUserWantsToLogOutNotification object:nil];
}

- (void) viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) embedController:(UIViewController *) controller {
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    [controller didMoveToParentViewController:self];
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    groupListController.view.frame = CGRectMake(0.0, 0.0, GROUP_LIST_WIDTH, self.view.frame.size.height);
    studentListController.view.frame = CGRectMake(GROUP_LIST_WIDTH, 0.0, self.view.frame.size.width - GROUP_LIST_WIDTH, self.view.frame.size.height);
}

- (BOOL) prefersStatusBarHidden {
    return YES;
}

- (void) setGroups:(NSArray *) groups {
    groupListController.groups = groups;

    if ([groups count] > 0) {
        [groupListController selectGroup:groups[0]];
    }
}

- (void) doLogOut:(NSNotification *) notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:BCLoggedOutNotification object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end