//
//  JoystickNode.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-25.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class JoystickNode;
@protocol JoystickDelegate <NSObject>

- (void)updateJoystick:(JoystickNode*)joystick xValue:(float)x yValue:(float)y;
- (void)isPressed:(JoystickNode*)joystick isPressed:(BOOL)pressed;


@end

@interface JoystickNode : SKSpriteNode

@property (assign, nonatomic) CGFloat trackingDistance;
@property (strong, nonatomic) SKSpriteNode *touchPad;
@property (assign, nonatomic) CGPoint center;

@property (assign, nonatomic) CGFloat passiveAlpha;
@property (assign, nonatomic) CGFloat activeAlpha;

@property (assign, nonatomic) CGFloat touchPadLength;
@property (assign, nonatomic) CGSize touchPadSize;
@property (strong, nonatomic) SKTexture *touchPadTexture;

@property (weak, nonatomic) id <JoystickDelegate> delegate;


-(instancetype)initWithSize:(CGSize)size;

@end
