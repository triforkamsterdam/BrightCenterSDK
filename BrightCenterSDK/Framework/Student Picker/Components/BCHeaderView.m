#import "BCHeaderView.h"


#define HORIZONTAL_MARGIN 30.0

@implementation BCHeaderView {
    UILabel *titleLabel;
}

- (id) init {
    self = [super init];
    if (self) {
        titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        titleLabel.font = [UIFont systemFontOfSize:24.0];
        titleLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) layoutSubviews {
    titleLabel.frame = CGRectMake(HORIZONTAL_MARGIN, 0.0, self.frame.size.width - HORIZONTAL_MARGIN * 2.0, self.frame.size.height);
}

- (void) setText:(NSString *) text {
    titleLabel.text = text;
}

- (NSString *) text {
    return titleLabel.text;
}

- (UIColor *) textColor {
    return titleLabel.textColor;
}

- (void) setTextColor:(UIColor *) textColor {
    titleLabel.textColor = textColor;
}

@end