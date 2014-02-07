//
//  BCButtonLogo.m
//  BrightCenterSDK
//
//  Created by Rick Slot on 07/02/14.
//  Copyright (c) 2014 Tom van Zummeren. All rights reserved.
//

#import "BCButtonLogo.h"

#define OUTER_CIRCLE_LINE_WIDTH .100
#define INNER_CIRCLE_LINE_WIDTH .101

@implementation BCButtonLogo{
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
                                  size,size
                                  );
    UIBezierPath *ovalPath2 = [UIBezierPath bezierPathWithOvalInRect:ovalRect2];
    ovalPath2.lineWidth = lineWidth;
    [ovalPath2 stroke];
}

- (void) layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self bcButtonIsClicked];
}


- (void) bcButtonIsClicked{
    [self.bcButtonClickedDelegate bcButtonIsClicked];
}




@end
