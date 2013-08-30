@class BCCredentials;

@interface BCLoginView : UIView <UITextFieldDelegate>
@property(nonatomic, copy) void (^loginButtonTapped)();
@property(nonatomic, readonly) BCCredentials *credentials;

- (void) clear;

- (void) handleLoginFailure;
@end