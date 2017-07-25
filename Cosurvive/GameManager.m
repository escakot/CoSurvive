//
//  GameManager.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "GameManager.h"
#import "Player.h"
#import "BasicEnemy.h"

@implementation GameManager

- (instancetype)init
{
  self = [super init];
  if (self) {
    _players = [[NSMutableArray alloc] init];
  }
  return self;
}

- (BasicEnemy*)spawnBasicUnit:(CGSize)screenSize;
{
  GKARC4RandomSource *randomSource = [[GKARC4RandomSource alloc] init];
  NSInteger randTarget = [randomSource nextIntWithUpperBound:self.players.count];
  
  Player* targetPlayer = self.players[randTarget];
//  CGFloat x = ((float)screenSize.size.width * randomSource.nextUniform) - screenSize.size.width/2;
//  CGFloat y = ((float)screenSize.size.height * randomSource.nextUniform) - screenSize.size.height/2;
  BasicEnemy *basicEnemy = [[BasicEnemy alloc] initWithColor:[UIColor redColor] atPosition:CGPointMake(100, 100) withTarget:targetPlayer.agent];
  return basicEnemy;
  
}


@end
