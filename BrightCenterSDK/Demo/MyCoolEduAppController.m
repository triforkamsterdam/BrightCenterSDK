#import "MyCoolEduAppController.h"
#import "BCStudent.h"
#import "BCGroup.h"
#import "BCAssessment.h"
#import "BCStudentsRepository.h"
#import "BCAssessmentItemResult.h"
#import "BCButtonLogo.h"

#define TITLE_HEIGHT 50.0
#define VERTICAL_MARGIN 30.0
#define LOGIN_BUTTON_HEIGHT 50.0
#define BUTTON_WIDTH 160.0

#define IMAGE_WIDTH 200.0

#define IMAGE_HEIGHT 200.0

@implementation MyCoolEduAppController {

    UIImageView *imageView;

    UILabel *titleLabel;

    UILabel *loggedInStudentLabel;
    
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


    [self addOverlayButtonWithColor:1 andPosition:1];
    [self addOverlayButtonWithColor:2 andPosition:2];
    [self addOverlayButtonWithColor:3 andPosition:3];
    [self addOverlayButtonWithColor:4 andPosition:4];

}

- (void) viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGRect rect = self.view.bounds;

    imageView.frame = CGRectMake(
            (rect.size.width / 2.0) - (IMAGE_WIDTH / 2),
            rect.size.height / 2.0 - TITLE_HEIGHT - IMAGE_HEIGHT - VERTICAL_MARGIN,
            IMAGE_WIDTH, IMAGE_HEIGHT);

    titleLabel.frame = CGRectMake(0.0, rect.size.height / 2.0 - TITLE_HEIGHT, rect.size.width, TITLE_HEIGHT);
   
    loggedInStudentLabel.frame = CGRectMake(
            0.0,
            titleLabel.frame.origin.y + titleLabel.frame.size.height,
            rect.size.width, TITLE_HEIGHT);
}

#pragma mark - BCStudentPickerControllerDelegate implementation

- (void) studentPicked:(BCStudent *) student {
    self.student = student;
    loggedInStudentLabel.text = [NSString stringWithFormat:@"%@ (%@)", student.fullName, student.group.name];

    // TODO: Implement some buttons in MyCoolEduApp to test the load and save functionality of result items.
   [self testSaveAssessmentItemResult];
    //[self testLoadAssessmentItemResults];
}

- (void) loggedOut {
    loggedInStudentLabel.text = @"";
}

- (void) testLoadAssessmentItemResults {
    NSString *assessmentId = @"1";
    NSLog(@"Performing loadAssessmentItemResults for student \"%@\" with assessment id %@", self.student.fullName, assessmentId);
    [[BCStudentsRepository instance] loadAssessmentItemResults:[BCAssessment assessmentWithId:assessmentId]
                                                       student:self.student success:^(NSArray *assessmentItemResults) {
        NSLog(@"SUCCESS! Loaded %i assessment item results for assessmentId = %@", [assessmentItemResults count], assessmentId);
    } failure:^(NSError *error, BOOL loginFailure) {
        NSLog(@"ERROR: Failed to perform loadAssessmentItemResults: %@", error);
    }];
}

- (void) testSaveAssessmentItemResult {
    BCStudentsRepository *repository = [BCStudentsRepository instance];
    BCAssessmentItemResult *result = [BCAssessmentItemResult new];
    result.student = self.student;
    result.questionId = @"1";
    result.assessment = [BCAssessment assessmentWithId:@"1"];
    result.attempts = 2;
    result.duration = 5;
    result.completionStatus = BCCompletionStatusCompleted;
    result.score = 0.8;
    // Saving an assessment makes a call to the backend, so it could take a second. It is wise to display a progress indicator.
    [repository saveAssessmentItemResult:result success:^{
        // Saving the assessment item was successful!
        // At this point you can hide the progress indicator.
    } failure:^(NSError *error, BOOL loginFailure) {
        // Saving the result failed. This could happen when:
        // 1) the given credentials are no longer valid or
        // 2) there was a network error
    }];
}


- (void) addOverlayButtonWithColor: (int) color andPosition: (int) position{
    UIColor *logoColor;
    switch (color) {
        case 1:
            logoColor =[UIColor colorWithRed:244 / 255.0 green:126 / 255.0 blue:43 / 255.0 alpha:1.0];
            break;
        case 2:
            //blue
            logoColor = [UIColor colorWithRed:0 / 255.0 green:156 / 255.0 blue:250 / 255.0 alpha:1.0];
            break;
        case 3:
            //grey
            logoColor = [UIColor colorWithRed:77 / 255.0 green:77 / 255.0 blue:77 / 255.0 alpha:1.0];
            break;
        default:
            logoColor = [UIColor colorWithRed:244 / 255.0 green:126 / 255.0 blue:43 / 255.0 alpha:1.0];
            break;
    }
    
    BCButtonLogo *backgroundView = [[BCButtonLogo alloc] initWithColor:logoColor];
    [self.view addSubview:backgroundView];
    CGSize size = self.view.frame.size;
    CGFloat logoSize = MIN(size.width, size.height) * 0.25;
    
    int x = 0;
    int y = 0;
    
    switch (position) {
        case 1:
            x = (logoSize * 1.1) - logoSize;
            y = (logoSize * 1.1) - logoSize;
            break;
        case 2:
            x = size.width - (logoSize * 1.1);
            y = (logoSize * 1.1) - logoSize;
            break;
        case 3:
            x = (logoSize * 1.1) - logoSize;
            y = size.height - (logoSize * 1.1);
            break;
        case 4:
            x = size.width - (logoSize * 1.1);
            y = size.height - (logoSize * 1.1);
            break;
            
        default:
            x = size.width - (logoSize * 1.1);
            y = size.height - (logoSize * 1.1);
            break;
    }

    backgroundView.frame = CGRectMake(x, y, logoSize, logoSize);
    backgroundView.bcButtonClickedDelegate = self;

}

- (void) bcButtonIsClicked{
    BCStudentPickerController *studentPickerController = [BCStudentPickerController new];
    studentPickerController.studentPickerDelegate = self;
    if (studentPickerController) {
        [self presentViewController:studentPickerController animated:YES completion:nil];
    }
}

@end