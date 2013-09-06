@class BCUserAccount;

static NSString *const BCUserWantsToCancelNotification = @"BCUserWantsToCancelNotification";

@interface BCNavigationBar : UINavigationBar
- (void) showLoggedInUserMenu:(BCUserAccount *) account;

- (void) hideLoggedInUserMenu;
@end