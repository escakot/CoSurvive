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

- (instancetype)initWithPlayer:(Player*)player withColor:(UIColor*)color Size:(CGSize)size
{
  self = [super init];
  if (self)
  {
    _size = size;
    _color = color;
    _player = player;
    _sprite = [[SKSpriteNode alloc] initWithColor:color size:size];
    _sprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:size];
    _sprite.physicsBody.categoryBitMask = redBarrierCategory;
    _sprite.physicsBody.collisionBitMask = 0;
    _sprite.physicsBody.contactTestBitMask = redEnemyCategory;
    _sprite.alpha = 0.4;
    [player.renderComponent.node addChild:_sprite];
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
