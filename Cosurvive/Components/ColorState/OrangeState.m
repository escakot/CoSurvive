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
  player.animationComponent.shape.fillColor = player.barrierComponent.color;
  player.barrierComponent.shape.fillColor = player.barrierComponent.color;
  player.barrierComponent.shape.physicsBody.categoryBitMask = orangeBarrierCategory;
  player.barrierComponent.shape.physicsBody.contactTestBitMask = orangeEnemyCategory;
  
}

@end
