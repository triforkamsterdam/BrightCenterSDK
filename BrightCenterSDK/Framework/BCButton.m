#import "BCButton.h"


@implementation BCButton {

}

- (id) init {
    self = [super init];
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:32.0];
    }
    return self;
}

- (void) setColor:(UIColor *) color {
    _color = color;
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (void) drawRect:(CGRect) rect {
    UIColor *buttonColor = self.highlighted ? [UIColor whiteColor] : self.color;
    [buttonColor setFill];

    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:20.0];
    [roundedRect fill];
}

- (void) setHighlighted:(BOOL) highlighted {
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end