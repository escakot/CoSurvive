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
    _basicUnitLimit = 30;
    _toughUnitLimit = 10;
    _basicUnitRespawnTime = 0.5;
    _toughUnitRespawnTime = 1;
    _randomSource = [[GKARC4RandomSource alloc] init];
    _toughAgents = [[NSMutableArray alloc] init];
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
    
    [units addObject:toughEnemy];
  }
}


-(CGPoint)getRandomLocation:(Player*)targetPlayer
{
  //Randomization
  //  NSLog(@"%@", NSStringFromCGPoint(targetPlayer.renderComponent.node.position));
  CGSize size = self.scene.size;
  
  //Calculate spawn location
  NSInteger randAxis = [self.randomSource nextIntWithUpperBound:2];
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
      break;
    }
    case 1:
    {
      return [[type alloc] initWithColor:[UIColor blueColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics blueEnemy] inScene:self.scene];
      break;
    }
    case 2:
    {
      return [[type alloc] initWithColor:[UIColor greenColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics greenEnemy] inScene:self.scene];
      break;
    }
    case 3:
    {
      return [[type alloc] initWithColor:[UIColor yellowColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics yellowEnemy] inScene:self.scene];
      break;
    }
    case 4:
    {
      return [[type alloc] initWithColor:[UIColor orangeColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics orangeEnemy] inScene:self.scene];
      break;
    }
    case 5:
    {
      return [[type alloc] initWithColor:[UIColor purpleColor] atPosition:spawnLocation withTarget:targetPlayer.agent
                             withPhysics:[EntityPhysics purpleEnemy] inScene:self.scene];
      break;
    }
    default:
      return nil;
      break;
  }
}

@end
