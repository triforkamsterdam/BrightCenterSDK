#import "MyCoolEduAppController.h"
#import "BCStudent.h"
#import "BCGroup.h"
#import "BCAssessment.h"
#import "BCStudentsRepository.h"

#define TITLE_HEIGHT 50.0
#define VERTICAL_MARGIN 30.0
#define LOGIN_BUTTON_HEIGHT 50.0
#define BUTTON_WIDTH 160.0

#define IMAGE_WIDTH 200.0

#define IMAGE_HEIGHT 200.0

@implementation MyCoolEduAppController {

    UIImageView *imageView;

    UILabel *titleLabel;

    UIButton *loginButton;

    UILabel *loggedInStudentLabel;

    BCStudentPickerController *studentPickerController;
}

- (void) viewDidLoad {
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1377697751_graduated"]];
    [self.view addSubview:imageView];

    titleLabel = [UILabel new];
    [self.view addSubview:titleLabel];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:40.0];
    titleLabel.text = @"My cool educational app";
    titleLabel.textAlignment = NSTextAlignmentCenter;

    loggedInStudentLabel = [UILabel new];
    [self.view addSubview:loggedInStudentLabel];
    loggedInStudentLabel.backgroundColor = [UIColor clearColor];
    loggedInStudentLabel.font = [UIFont systemFontOfSize:30.0];
    loggedInStudentLabel.textAlignment = NSTextAlignmentCenter;

    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:loginButton];
    [loginButton setTitle:@"Connect" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:30.0];

    [loginButton addTarget:self action:@selector(loginButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    [BCStudentsRepository instance].assessment = [BCAssessment assessmentWithId:@"abc123"];
}

- (void) loginButtonTapped {
    studentPickerController = [BCStudentPickerController new];
    studentPickerController.studentPickerDelegate = self;

    if (studentPickerController) {
        [self presentViewController:studentPickerController animated:YES completion:nil];
    }
}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect rect = self.view.bounds;

    imageView.frame = CGRectMake(
            (rect.size.width / 2.0) - (IMAGE_WIDTH / 2),
            rect.size.height / 2.0 - TITLE_HEIGHT - IMAGE_HEIGHT - VERTICAL_MARGIN,
            IMAGE_WIDTH, IMAGE_HEIGHT);

    titleLabel.frame = CGRectMake(0.0, rect.size.height / 2.0 - TITLE_HEIGHT, rect.size.width, TITLE_HEIGHT);

    loginButton.frame = CGRectMake(
            (rect.size.width / 2.0) - (BUTTON_WIDTH / 2.0),
            titleLabel.frame.origin.y + titleLabel.frame.size.height + VERTICAL_MARGIN,
            BUTTON_WIDTH, LOGIN_BUTTON_HEIGHT);

    loggedInStudentLabel.frame = CGRectMake(
            0.0,
            loginButton.frame.origin.y + loginButton.frame.size.height,
            rect.size.width, TITLE_HEIGHT);
}

#pragma mark - BCStudentPickerControllerDelegate implementation

- (void) studentPicked:(BCStudent *)     student {
    self.student = student;
    loggedInStudentLabel.text = [NSString stringWithFormat:@"%@ (%@)", student.name, student.group.name];
    [loginButton setTitle:@"Change" forState:UIControlStateNormal];
}

@end