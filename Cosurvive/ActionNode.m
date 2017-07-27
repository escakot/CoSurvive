//
//  ActionNode.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-27.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "ActionNode.h"

@implementation ActionNode

- (instancetype)initWithSize:(CGFloat)radius withIdentifier:(NSString*)identifier
{
  self = [super init];
  if (self) {
    _button = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
    [self addChild:_button];
    self.userInteractionEnabled = YES;
    
    _identifier = identifier;
  }
  return self;
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  [self.delegate performAction:self.identifier];
}

@end
