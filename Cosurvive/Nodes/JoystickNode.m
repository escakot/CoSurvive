//
//  JoystickNode.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-25.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "JoystickNode.h"

@implementation JoystickNode

-(instancetype)initWithSize:(CGSize)size
{
  self = [super initWithTexture:[SKTexture textureWithImageNamed:@"ControlPad"] color:[UIColor clearColor] size:size];
  if (self)
  {
    _activeAlpha = 0.5;
    _passiveAlpha = 0.3;
    
    _trackingDistance = size.width / 2;
    
    _touchPadLength = size.width / 2.2;
    _center = CGPointMake(size.width/2 - _touchPadLength, size.height/2 - _touchPadLength);
    
    _touchPadSize = CGSizeMake(_touchPadLength, _touchPadLength);
    _touchPadTexture = [SKTexture textureWithImageNamed:@"ControlPad"];
    
    _touchPad = [SKSpriteNode spriteNodeWithTexture:_touchPadTexture size:_touchPadSize];
    self.alpha = _passiveAlpha;
    [self addChild:_touchPad];
  }
  return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  self.alpha = self.activeAlpha;
  
  [self.delegate isPressed:self isPressed:YES];
}


-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches)
  {
    CGPoint touchLocation = [touch locationInNode:self];
    
    CGFloat diffX = touchLocation.x - self.center.x;
    CGFloat diffY = touchLocation.y - self.center.y;
    
    CGFloat distance = hypot(diffX, diffY);
    
    if (distance > self.trackingDistance)
    {
      diffX = (diffX / distance) * self.trackingDistance;
      diffY = (diffY / distance) * self.trackingDistance;
    }
    
    self.touchPad.position = CGPointMake(self.center.x + diffX, self.center.y + diffY);
    
    float normalizedDiffX = (float)(diffX / self.trackingDistance);
    float normalizedDiffY = (float)(diffY / self.trackingDistance);
    
    [self.delegate updateJoystick:self xValue:normalizedDiffX yValue:normalizedDiffY];
  }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesEnded:touches withEvent:event];
  
  [self resetJoystick];
}

-(void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [super touchesCancelled:touches withEvent:event];
  
  [self resetJoystick];
}



-(void)resetJoystick
{
  self.alpha = self.passiveAlpha;
  SKAction *restoreToCenter = [SKAction moveTo:CGPointZero duration:0.2];
  [self.touchPad runAction:restoreToCenter];
  [self.delegate isPressed:self isPressed:NO];
  [self.delegate updateJoystick:self xValue:0 yValue:0];
}






@end
