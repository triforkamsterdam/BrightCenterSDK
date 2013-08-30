#import "BCLoggedInUserView.h"
#import "BCUserAccount.h"

#define TITLE_LEFT_INSET 20.0

#define BUTTON_LOG_OUT 0

@implementation BCLoggedInUserView {
    UIButton *button;
}
- (id) init {
    self = [super init];
    if (self) {
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button setImage:[UIImage imageNamed:@"bc_avatar"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:28.0];

        [button setTitleColor:[UIColor colorWithWhite:75 / 255.0 alpha:1.0]
                     forState:UIControlStateNormal];

        [button setTitleColor:[UIColor colorWithRed:245 / 255.0 green:126 / 255.0 blue:43 / 255.0 alpha:1.0]
                     forState:UIControlStateHighlighted];

        button.titleEdgeInsets = UIEdgeInsetsMake(0.0, TITLE_LEFT_INSET, 0.0, 0.0);
        [button addTarget:self action:@selector(buttonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) buttonTapped {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Log out", nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [actionSheet showFromRect:button.frame inView:self animated:YES];
    } else {
        [actionSheet showInView:self];
    }
}

- (void) actionSheet:(UIActionSheet *) actionSheet clickedButtonAtIndex:(NSInteger) buttonIndex {
    if (buttonIndex == BUTTON_LOG_OUT) {
        [[NSNotificationCenter defaultCenter] postNotificationName:BCUserWantsToLogOutNotification object:nil];
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];

    [button sizeToFit];
    CGFloat buttonWidth = button.frame.size.width + TITLE_LEFT_INSET;
    button.frame = CGRectMake(
            self.frame.size.width - buttonWidth,
            (self.frame.size.height / 2.0) - (button.frame.size.height / 2.0),
            buttonWidth,
            button.frame.size.height
    );
}

- (void) setAccount:(BCUserAccount *) account {
    _account = account;
    [button setTitle:account.fullName forState:UIControlStateNormal];
    [self setNeedsLayout];
}

@end