//
//  BCButtonLogo.h
//  BrightCenterSDK
//
//  Created by Rick Slot on 07/02/14.
//  Copyright (c) 2014 Tom van Zummeren. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BCButtonLogoClickedDelegate <NSObject>
@required
- (void) bcButtonIsClicked;
@end

@interface BCButtonLogo : UIView

- (id) initWithColor:(UIColor *) aColor andPositionX:(int) positionX andPositionY:(int) positionY;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@property(nonatomic, strong) id <BCButtonLogoClickedDelegate> bcButtonClickedDelegate;

@end
