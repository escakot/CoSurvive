//
//  OrangeState.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-27.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "OrangeState.h"
#import "Player.h"

@implementation OrangeState

- (instancetype)initWithComponent:(BarrierComponent*)barrier
{
  self = [super init];
  if (self) {
    self.barrierComponent = barrier;
  }
  return self;
}

-(void)didEnterWithPreviousState:(GKState *)previousState
{
  [super didEnterWithPreviousState:previousState];
  
  Player* player = (Player*)self.barrierComponent.entity;
  player.barrierComponent.color = [UIColor orangeColor];
  player.animationComponent.sprite.color = player.barrierComponent.color;
  player.barrierComponent.sprite.color = player.barrierComponent.color;
  player.barrierComponent.sprite.physicsBody.categoryBitMask = orangeBarrierCategory;
  player.barrierComponent.sprite.physicsBody.contactTestBitMask = orangeEnemyCategory;
  
}

@end
