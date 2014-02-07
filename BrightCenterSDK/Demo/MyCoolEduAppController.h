#import "BCStudentPickerController.h"
#import "BCButtonLogo.h"

@interface MyCoolEduAppController : UIViewController <BCStudentPickerControllerDelegate, BCButtonLogoClickedDelegate>
@property(nonatomic, strong) BCStudent *student;
@end