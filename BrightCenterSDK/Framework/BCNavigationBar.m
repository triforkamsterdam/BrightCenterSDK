#import "BCNavigationBar.h"
#import "BCUserAccount.h"
#import "BCLoggedInUserView.h"

#define HORIZONTAL_MARGIN 30.0

@implementation BCNavigationBar {

    BCLoggedInUserView *loggedInUserView;
    
    UIButton *closeButton;

    UIImage *closeButtonImage;
}

- (id) initWithFrame:(CGRect) frame {
    self = [super initWithFrame:frame];
    if (self) {
        closeButtonImage = [UIImage imageNamed:@"bc_delete_icon"];

        closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:closeButton];
        [closeButton setImage:closeButtonImage forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) closeButtonTapped {
    [[NSNotificationCenter defaultCenter] postNotificationName:BCUserWantsToCancelNotification object:nil];
}

- (CGSize) sizeThatFits:(CGSize) size {
    BOOL iPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    CGSize newSize = CGSizeMake(self.frame.size.width, iPad ? 100 : self.frame.size.height);
    return newSize;
}

- (void) drawRect:(CGRect) rect {
    [[UIColor whiteColor] setFill];
    UIRectFill(rect);

    UIImage *logoImage = [UIImage imageNamed:@"bc_logo"];
    [logoImage drawAtPoint:CGPointMake(HORIZONTAL_MARGIN, (self.frame.size.height / 2.0) - (logoImage.size.height / 2.0))];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self applyDropShadow];

    loggedInUserView.frame = CGRectMake(self.frame.size.width / 2.0, 0.0,
            (self.frame.size.width / 2.0) - HORIZONTAL_MARGIN, self.frame.size.height);

    CGFloat closeButtonHeight = closeButtonImage.size.height + 1.0;
    closeButton.frame = CGRectMake(self.frame.size.width - HORIZONTAL_MARGIN - closeButtonImage.size.width,
            (self.frame.size.height / 2.0) - (closeButtonHeight / 2.0),
            closeButtonImage.size.width, closeButtonHeight);
}

- (void) applyDropShadow {
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0.0, 2.0);
    self.layer.shadowOpacity = 1.0;

    CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.size.height - 7, self.layer.bounds.size.width + 20, 5);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
}

- (BCLoggedInUserView *) loggedInUserView {
    if (!loggedInUserView) {
        loggedInUserView = [BCLoggedInUserView new];
        [self setNeedsLayout];
    }
    return loggedInUserView;
}

- (void) showLoggedInUserMenu:(BCUserAccount *) account {
    BCLoggedInUserView *userView = [self loggedInUserView];
    userView.account = account;
    userView.alpha = 0.0;
    [self addSubview:userView];

    [UIView animateWithDuration:.25 animations:^{
        userView.alpha = 1.0;
        closeButton.alpha = 0.0;
    }];
}

- (void) hideLoggedInUserMenu {
    BCLoggedInUserView *userView = [self loggedInUserView];

    [UIView animateWithDuration:.25 animations:^{
        userView.alpha = 0.0;
        closeButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        userView.account = nil;
        [userView removeFromSuperview];
    }];
}
@end