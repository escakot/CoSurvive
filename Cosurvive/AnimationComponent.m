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

-(instancetype)initWithSize:(CGSize)size andColor:(UIColor *)color
{
  self = [super init];
  if (self)
  {
    _sprite = [[SKSpriteNode alloc] initWithColor:color size:size];
  }
  return self;
}


@end
