//
//  GameManager.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

+ (GameManager *) sharedManager {
	static dispatch_once_t onceToken;
	static GameManager *gameManager = nil;
	
	dispatch_once(&onceToken, ^{
		gameManager = [[self alloc] init];
	});
	
	return gameManager;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _basicUnitRespawnTime = 0.5;
  }
  return self;
}

-(void)spawnUnitsInScene:(GameScene *)scene players:(NSMutableArray *)players units:(NSMutableDictionary<NSString *,NSMutableArray *> *)enemyUnits time:(NSTimeInterval)delta
{
  self.basicUnitPreviousSpawnTime += delta;
  if (self.basicUnitPreviousSpawnTime > self.basicUnitRespawnTime)
  {
    [self spawnBasicEnemy:scene players:players units:enemyUnits[@"basicEnemies"]];
    self.basicUnitPreviousSpawnTime = 0;
  }
}

- (void)spawnBasicEnemy:(GameScene*)scene players:(NSMutableArray*)players units:(NSMutableArray*)units
{
  GKARC4RandomSource *randomSource = [[GKARC4RandomSource alloc] init];
  NSInteger randTarget = [randomSource nextIntWithUpperBound:players.count];
  NSInteger randAxis = [randomSource nextIntWithUpperBound:2];
  float width = scene.size.width * 1.2;
  float height = scene.size.height * 1.2;
  CGFloat x; CGFloat y;
  if (randAxis)
  {
    x = (width * round(randomSource.nextUniform)) - width/2;
    y = (height * randomSource.nextUniform) - height/2;
  } else {
    x = (width * randomSource.nextUniform) - width/2;
    y = (height * round(randomSource.nextUniform)) - height/2;
    
  }
  
  Player* targetPlayer = players[randTarget];
  BasicEnemy *basicEnemy = [[BasicEnemy alloc] initWithColor:targetPlayer.color atPosition:CGPointMake(x, y) withTarget:targetPlayer.agent andScene:scene];
  
  [units addObject:basicEnemy];
  [scene.agentSystem addComponent:basicEnemy.agent];
}

@end
