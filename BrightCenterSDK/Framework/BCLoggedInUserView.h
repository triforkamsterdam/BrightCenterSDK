@class BCUserAccount;

static NSString *const BCUserWantsToLogOutNotification = @"BCUserWantsToLogOutNotification";

@interface BCLoggedInUserView : UIView <UIActionSheetDelegate>
@property(nonatomic, strong) BCUserAccount *account;
@end