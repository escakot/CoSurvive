//
//  Barrier.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-25.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "Barrier.h"

@implementation Barrier

- (instancetype)initBarrierWithSize:(CGSize)size andColor:(UIColor*)color
{
  self = [super init];
  if (self) {
    _renderComponent = [[RenderComponent alloc] init];
    [self addComponent:_renderComponent];
    
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    _physicsComponent = [[PhysicsComponent alloc] initWithPhysicsBody:physicsBody andPhysicsBitMask:[EntityPhysics blueBarrier]];
    _animationComponent = [[AnimationComponent alloc] initWithSize:size andColor:color];
    _animationComponent.sprite.alpha = 0.4;
    self.renderComponent.node.physicsBody = _physicsComponent.physicsBody;
    [self.renderComponent.node addChild:_animationComponent.sprite];
  }
  return self;
}

@end
