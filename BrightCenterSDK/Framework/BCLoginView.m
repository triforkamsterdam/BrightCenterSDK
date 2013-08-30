#import "BCLoginView.h"
#import "BCTextField.h"
#import "BCButton.h"
#import "BCCredentials.h"
#import "BCStudentsRepository.h"

#define HORIZONTAL_MARGIN 10.0
#define VERTICAL_MARGIN 26.0
#define FIELD_HEIGHT 57.0
#define BUTTON_WIDTH 200.0

#define TITLE_HORIZONTAL_MARGIN 30.0
#define TITLE_VERTICAL_MARGIN 18.0
#define TITLE_HEIGHT 35.0

@implementation BCLoginView {

    UILabel *titleLabel;

    BCTextField *usernameField;

    BCTextField *passwordField;

    BCButton *loginButton;

    BCButton *cancelButton;
}

- (id) init {
    self = [super init];
    if (self) {
        titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = @"Leraar login";
        titleLabel.font = [UIFont systemFontOfSize:32.0];

        usernameField = [BCTextField new];
        [self addSubview:usernameField];
        usernameField.placeholder = @"Gebruikersnaam";
        usernameField.icon = [UIImage imageNamed:@"bc_user_icon"];
        usernameField.highlightedIcon = [UIImage imageNamed:@"bc_user_icon_active"];
        usernameField.delegate = self;

        passwordField = [BCTextField new];
        [self addSubview:passwordField];
        passwordField.placeholder = @"Wachtwoord";
        passwordField.secureTextEntry = YES;
        passwordField.icon = [UIImage imageNamed:@"bc_password_icon"];
        passwordField.highlightedIcon = [UIImage imageNamed:@"bc_password_icon_active"];
        passwordField.delegate = self;

        loginButton = [BCButton new];
        [self addSubview:loginButton];
        loginButton.color = [UIColor colorWithRed:245 / 255.0 green:126 / 255.0 blue:43 / 255.0 alpha:1.0];
        [loginButton setTitle:@"login" forState:UIControlStateNormal];
        [loginButton addTarget:self action:@selector(loginTapped) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    if ([usernameField isFirstResponder]) {
        [passwordField becomeFirstResponder];
    } else if ([passwordField isFirstResponder]) {
        [usernameField becomeFirstResponder];
    }
    return NO;
}

- (void) loginTapped {
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
    if (self.loginButtonTapped) {
        self.loginButtonTapped();
    }
}

- (void) layoutSubviews {
    [super layoutSubviews];

    CGFloat y = 0;
    titleLabel.frame = CGRectMake(
            TITLE_HORIZONTAL_MARGIN,
            TITLE_VERTICAL_MARGIN,
            self.frame.size.width - TITLE_HORIZONTAL_MARGIN * 2,
            TITLE_HEIGHT
    );
    y += TITLE_HEIGHT + TITLE_VERTICAL_MARGIN * 2;

    usernameField.frame = CGRectMake(
            HORIZONTAL_MARGIN,
            y,
            self.frame.size.width - HORIZONTAL_MARGIN * 2,
            FIELD_HEIGHT
    );
    y += FIELD_HEIGHT + VERTICAL_MARGIN;

    passwordField.frame = CGRectMake(
            HORIZONTAL_MARGIN,
            y,
            self.frame.size.width - HORIZONTAL_MARGIN * 2,
            FIELD_HEIGHT
    );
    y += FIELD_HEIGHT + VERTICAL_MARGIN;

    loginButton.frame = CGRectMake(
            self.frame.size.width - HORIZONTAL_MARGIN - BUTTON_WIDTH,
            y,
            BUTTON_WIDTH,
            FIELD_HEIGHT
    );
}

- (BCCredentials *) credentials {
    return [BCCredentials credentialsWithUsername:usernameField.text password:passwordField.text];
}

- (void) clear {
    usernameField.text = @"";
    passwordField.text = @"";
}

- (void) handleLoginFailure {
    [self clear];

    usernameField.text = [BCStudentsRepository instance].credentials.username;
    passwordField.text = @"";

    __unsafe_unretained BCLoginView *weakSelf = self;
    [self shake:^{
        if ([weakSelf->usernameField.text isEqualToString:@""]) {
            [weakSelf->usernameField becomeFirstResponder];
        } else {
            [weakSelf->passwordField becomeFirstResponder];
        }
    }];
}

- (void) shake:(void (^)()) completion {
    [CATransaction begin];

    [CATransaction setCompletionBlock:completion];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.duration = 0.05;
    animation.repeatCount = 5;
    animation.autoreverses = YES;
    animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x - 20.0, self.center.y)];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.center.x + 20.0, self.center.y)];
    [self.layer addAnimation:animation forKey:@"position"];

    [CATransaction commit];
}

@end