#import "BCDisclosureIndicator.h"

@implementation BCDisclosureIndicator {

}

static UIColor *color;

+ (void) initialize {
    [super initialize];
    color = [UIColor colorWithWhite:220 / 255.0 alpha:1.0];
}

- (id) init {
    self = [super init];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) drawRect:(CGRect) rect {
    CGContextRef context = UIGraphicsGetCurrentContext();

    [color setStroke];
    CGContextSetLineWidth(context, 3.5);
    CGContextMoveToPoint(context, 1.5, 1.5);
    CGContextAddLineToPoint(context, rect.size.width - 3.0, rect.size.height / 2.0);
    CGContextAddLineToPoint(context, 1.5, rect.size.height - 1.5);
    CGContextStrokePath(context);
}

@end