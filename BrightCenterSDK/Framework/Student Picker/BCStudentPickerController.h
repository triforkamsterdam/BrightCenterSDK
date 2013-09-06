@class BCStudent;

static NSString *const BCStudentPickedNotification = @"BCStudentPickedNotification";

@protocol BCStudentPickerControllerDelegate <NSObject>
@required
- (void) studentPicked:(BCStudent *) student;
@end

/**
 * Main entry point for app developers to integrate with Bright Center.
 */
@interface BCStudentPickerController : UINavigationController

@property(nonatomic, strong) id <BCStudentPickerControllerDelegate> studentPickerDelegate;

@end