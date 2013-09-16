#import "BCTextField.h"

#define HORIZONTAL_MARGIN 57.0

#define RIGHT_MARGIN 8.0

@implementation BCTextField {
    UIImageView *iconImageView;

    UIImage *icon;
    UIImage *highlightedIcon;
    UIImage *deleteIcon;
}
- (id) init {
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:32.0];
        self.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.returnKeyType = UIReturnKeyNext;

        iconImageView = [UIImageView new];
        self.leftView = iconImageView;
        self.leftViewMode = UITextFieldViewModeAlways;

        [self addTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
        [self addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];

        deleteIcon = [UIImage imageNamed:@"bc_delete_icon"];

        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearButton setImage:deleteIcon forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(clear) forControlEvents:UIControlEventTouchUpInside];

        self.rightView = clearButton;
        self.rightViewMode = UITextFieldViewModeWhileEditing;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    }
    return self;
}

- (void) clear {
    self.text = @"";
}

- (void) editingDidBegin {
    iconImageView.image = highlightedIcon;
}

- (void) editingDidEnd {
    iconImageView.image = icon;
}

- (void) setIcon:(UIImage *) anIcon {
    icon = anIcon;
    iconImageView.image = icon;
    [iconImageView sizeToFit];
}

- (void) setHighlightedIcon:(UIImage *) anIcon {
    highlightedIcon = anIcon;
}

- (CGRect) rightViewRectForBounds:(CGRect) bounds {
    return CGRectMake(bounds.size.width - deleteIcon.size.width - RIGHT_MARGIN, (bounds.size.height / 2.0) - (deleteIcon.size.height / 2.0),
            deleteIcon.size.width, deleteIcon.size.height);
}

- (CGRect) leftViewRectForBounds:(CGRect) bounds {
    return CGRectMake(22.0, (bounds.size.height / 2.0) - (iconImageView.frame.size.height / 2.0) - 2.0,
            iconImageView.frame.size.width, iconImageView.frame.size.height);
}

- (CGRect) textRectForBounds:(CGRect) bounds {
    return CGRectMake(HORIZONTAL_MARGIN, 0.0, bounds.size.width - HORIZONTAL_MARGIN - RIGHT_MARGIN, bounds.size.height);
}

- (CGRect) editingRectForBounds:(CGRect) bounds {
    CGFloat width = bounds.size.width - HORIZONTAL_MARGIN - RIGHT_MARGIN;
    if (self.editing) {
        width -= deleteIcon.size.width;
    }
    return CGRectMake(HORIZONTAL_MARGIN, 0.0, width, bounds.size.height);
}

- (void) drawRect:(CGRect) rect {
    [[UIColor whiteColor] setFill];
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:20.0];
    [roundedRect fill];
}

@end