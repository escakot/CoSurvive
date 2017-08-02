//
//  BarrierComponent.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-26.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "BarrierComponent.h"
#import "Player.h"

@implementation BarrierComponent

- (instancetype)initWithPlayer:(Player*)player withColor:(UIColor*)color Size:(CGSize)size withShape:(NSInteger)shape
{
  self = [super init];
  if (self)
  {
    _size = size;
    _color = color;
    _player = player;
    if (shape == 0)
    {
      _shape = [SKShapeNode shapeNodeWithRectOfSize:size];
    } else
    {
      _shape = [SKShapeNode shapeNodeWithCircleOfRadius:size.width/2];
      
    }
    _shape.fillColor = color;
    _shape.strokeColor = [UIColor clearColor];
    _shape.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    _shape.physicsBody.categoryBitMask = redBarrierCategory;
    _shape.physicsBody.collisionBitMask = 0;
    _shape.physicsBody.contactTestBitMask = redEnemyCategory;
    _shape.alpha = 0.4;
    [player.renderComponent.node addChild:_shape];
    _stateMachine = [[GKStateMachine alloc] initWithStates:
                     @[[[RedState alloc] initWithComponent:self],
                       [[BlueState alloc] initWithComponent:self],
                       [[GreenState alloc] initWithComponent:self],
                       [[YellowState alloc] initWithComponent:self],
                       [[OrangeState alloc] initWithComponent:self],
                       [[PurpleState alloc] initWithComponent:self]
                       ]];
    [_stateMachine enterState:[RedState class]];
  }
  return self;
}

@end
