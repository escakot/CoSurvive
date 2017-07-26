//
//  RedState.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-26.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "RedState.h"
#import "Player.h"

@implementation RedState

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
  player.barrierComponent.color = [UIColor redColor];
  player.animationComponent.sprite.color = player.barrierComponent.color;
  player.barrierComponent.sprite.color = player.barrierComponent.color;
  player.barrierComponent.sprite.physicsBody.categoryBitMask = redBarrierCategory;
  player.barrierComponent.sprite.physicsBody.contactTestBitMask = redEnemyCategory;
  
}

@end
