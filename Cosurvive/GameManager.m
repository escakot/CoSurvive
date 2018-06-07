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
    _numberOfGameColors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor purpleColor]];
    _chosenColors = 2;
    _isBasicEnabled = NO;
    _isToughEnabled = NO;
    _isHealingEnabled = NO;
    _basicUnitLimit = 30;
    _toughUnitLimit = 10;
    _healingUnitLimit = 5;
    _basicUnitRespawnTime = 0.5;
    _toughUnitRespawnTime = 1;
    _healingUnitRespawnTime = 5;
    _randomSource = [[GKARC4RandomSource alloc] init];
  }
  return self;
}

-(void)spawnUnitsInScene:(GameScene *)scene players:(NSMutableArray *)players units:(NSMutableDictionary<NSString *,NSMutableArray *> *)enemyUnits time:(NSTimeInterval)delta
{
  self.basicUnitPreviousSpawnTime += delta;
  if (self.basicUnitPreviousSpawnTime > self.basicUnitRespawnTime && self.isBasicEnabled)
  {
    [self spawnBasicEnemyWithPlayers:players units:enemyUnits[@"basicEnemies"]];
    self.basicUnitPreviousSpawnTime = 0;
  }
  self.toughUnitPreviousSpawnTime += delta;
  if (self.toughUnitPreviousSpawnTime > self.basicUnitRespawnTime && self.isToughEnabled)
  {
    [self spawnToughEnemyWithPlayers:players units:enemyUnits[@"toughEnemies"]];
    self.toughUnitPreviousSpawnTime = 0;
  }
  self.healingUnitPreviousSpawnTime += delta;
  if (self.healingUnitPreviousSpawnTime > self.healingUnitRespawnTime && self.isHealingEnabled)
  {
    [self spawnHealingEnemyWithPlayers:players units:enemyUnits[@"healingEnemies"]];
    self.healingUnitPreviousSpawnTime = 0;
  }
}

- (void)spawnBasicEnemyWithPlayers:(NSMutableArray*)players units:(NSMutableArray*)units
{
  if (units.count >= self.basicUnitLimit)
  {
    return;
  }
  
  NSInteger randTarget = [self.randomSource nextIntWithUpperBound:players.count];
  Player* targetPlayer = players[randTarget];
  
  if (!targetPlayer.isDead)
  {
    BasicEnemy* basicEnemy = (BasicEnemy*)[self spawnUnitOfClassType:[BasicEnemy class] withTarget:targetPlayer];
    
    [units addObject:basicEnemy];
  }
}

- (void)spawnToughEnemyWithPlayers:(NSMutableArray*)players units:(NSMutableArray*)units
{
  if (units.count >= self.toughUnitLimit)
  {
    return;
  }
  NSInteger randTarget = [self.randomSource nextIntWithUpperBound:players.count];
  Player* targetPlayer = players[randTarget];
  
  if (!targetPlayer.isDead)
  {
    ToughEnemy* toughEnemy = (ToughEnemy*)[self spawnUnitOfClassType:[ToughEnemy class] withTarget:targetPlayer];
    
//    toughEnemy.agents = units;
    [units addObject:toughEnemy];
  }
}

- (void)spawnHealingEnemyWithPlayers:(NSMutableArray*)players units:(NSMutableArray*)units
{
  if (units.count >= self.healingUnitLimit)
  {
    return;
  }
  NSInteger randTarget = [self.randomSource nextIntWithUpperBound:players.count];
  Player* targetPlayer = players[randTarget];
  
  if (!targetPlayer.isDead)
  {
    HealingEnemy* healingEnemy = (HealingEnemy*)[self spawnUnitOfClassType:[HealingEnemy class] withTarget:targetPlayer];
    
    [units addObject:healingEnemy];
  }
}


-(CGPoint)getRandomLocation:(Player*)targetPlayer
{
  //Randomization
  //  NSLog(@"%@", NSStringFromCGPoint(targetPlayer.renderComponent.node.position));
  CGSize size = self.scene.size;
  
  //Calculate spawn location
  NSInteger randAxis = [self.randomSource nextIntWithUpperBound:2];
  CGFloat randxDistance = (self.randomSource.nextUniform) * self.scene.size.width / 6;
  CGFloat randyDistance = (self.randomSource.nextUniform) * self.scene.size.height / 5;
  float width = size.width * 1.2;
  float height = size.height * 1.2;
  CGFloat x; CGFloat y;
  if (randAxis)
  {
    x = (width * round(self.randomSource.nextUniform)) - width/2;
    y = (height * self.randomSource.nextUniform) - height/2;
  } else {
    x = (width * self.randomSource.nextUniform) - width/2;
    y = (height * round(self.randomSource.nextUniform)) - height/2;
    
  }
  x = x < 0 ? x - randxDistance : x + randxDistance;
  y = y < 0 ? y - randyDistance : y + randyDistance;
  x += targetPlayer.renderComponent.node.position.x;
  y += targetPlayer.renderComponent.node.position.y;
  
  return CGPointMake(x, y);
}

-(Unit*)spawnUnitOfClassType:(Class)type withTarget:(Player*)targetPlayer
{
  NSInteger randEnemyColor = [self.randomSource nextIntWithUpperBound:self.chosenColors];
  CGPoint spawnLocation = [self getRandomLocation:targetPlayer];
  
  switch (randEnemyColor)
  {
    case 0:
    {
      return [[type alloc] initWithColor:[UIColor redColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics redEnemy] inScene:self.scene];
    }
    case 1:
    {
      return [[type alloc] initWithColor:[UIColor blueColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics blueEnemy] inScene:self.scene];
    }
    case 2:
    {
      return [[type alloc] initWithColor:[UIColor greenColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics greenEnemy] inScene:self.scene];
    }
    case 3:
    {
      return [[type alloc] initWithColor:[UIColor yellowColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics yellowEnemy] inScene:self.scene];
    }
    case 4:
    {
      return [[type alloc] initWithColor:[UIColor orangeColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics orangeEnemy] inScene:self.scene];
    }
    case 5:
    {
      return [[type alloc] initWithColor:[UIColor purpleColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics purpleEnemy] inScene:self.scene];
    }
    default:
      return nil;
  }
}

-(float)getDifficultyMultiplier
{
  float multiplier;
  switch (self.difficulty)
  {
    case 1:{
      multiplier = 1.5;
      break;
    }
    case 2:{
      multiplier = 2.2;
      break;
    }
    case 3:{
      multiplier = 3.5;
      break;
    }
    default:{
      multiplier = 1.0;
      break;
    }
  }
  return multiplier;
}

-(void)setDifficultyRampWithTime: (float)time {
    float ramp = (time - self.gameStartTime) / 50;
    float multiplier = [self getDifficultyMultiplier] + ramp;
    self.basicUnitLimit = ceil(30 * multiplier);
    self.toughUnitLimit = ceil(10 * multiplier);
    self.healingUnitLimit = ceil(10 / multiplier);
    self.basicUnitRespawnTime = (1.0 / multiplier);
    self.toughUnitRespawnTime = (3.0 / multiplier);
    self.healingUnitRespawnTime = (5.0 * multiplier);
}

@end
