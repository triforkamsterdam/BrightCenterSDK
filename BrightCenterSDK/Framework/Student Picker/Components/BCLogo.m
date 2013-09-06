#import "BCLogo.h"

#define OUTER_CIRCLE_LINE_WIDTH .12
#define INNER_CIRCLE_LINE_WIDTH .14

@implementation BCLogo {
    UIColor *color;
}

- (id) initWithColor:(UIColor *) aColor {
    self = [super init];
    if (self) {
        color = aColor;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }

    return self;
}

- (void) drawRect:(CGRect) rect {
    CGFloat logoSize = MIN(rect.size.width, rect.size.height);

    [color setStroke];

    [self drawOvalInRect:rect
               lineWidth:logoSize * OUTER_CIRCLE_LINE_WIDTH
                    size:logoSize - (logoSize * OUTER_CIRCLE_LINE_WIDTH)];

    [self drawOvalInRect:rect
               lineWidth:logoSize * INNER_CIRCLE_LINE_WIDTH
                    size:logoSize * .66 - (logoSize * INNER_CIRCLE_LINE_WIDTH)];
}

- (void) drawOvalInRect:(CGRect) rect lineWidth:(CGFloat) lineWidth size:(CGFloat) size {
    CGRect ovalRect2 = CGRectMake(
            rect.origin.x + ((rect.size.width / 2.0) - (size / 2.0)),
            rect.origin.y + ((rect.size.height / 2.0) - (size / 2.0)),
            size,
            size
    );
    UIBezierPath *ovalPath2 = [UIBezierPath bezierPathWithOvalInRect:ovalRect2];
    ovalPath2.lineWidth = lineWidth;
    [ovalPath2 stroke];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

@end