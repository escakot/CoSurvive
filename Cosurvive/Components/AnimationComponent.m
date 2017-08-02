//
//  AnimationComponent.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "AnimationComponent.h"
#import "GameScene.h"

@implementation AnimationComponent

-(instancetype)initWithSize:(CGSize)size andColor:(UIColor *)color withShape:(NSInteger)shape
{
  self = [super init];
  if (self)
  {
    if (shape == 0)
    {
      _shape = [SKShapeNode shapeNodeWithRectOfSize:size];
    } else {
      _shape = [SKShapeNode shapeNodeWithCircleOfRadius:size.width/2];
    }
    _shape.fillColor = color;
  }
  return self;
}


@end
