//
//  GameManager.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

#import "Player.h"
#import "BasicEnemy.h"
#import "GameScene.h"

@interface GameManager : NSObject

@property (assign, nonatomic) NSTimeInterval basicUnitRespawnTime;
@property (assign, nonatomic) NSTimeInterval basicUnitPreviousSpawnTime;

//- (void)startGame:(SKScene*)scene withAgentSystem:(GKComponentSystem*)system andTime:(NSTimeInterval)time;
+ (GameManager *) sharedManager;

- (void)spawnUnitsInScene:(GameScene*)scene players:(NSMutableArray*)players units:(NSMutableDictionary<NSMutableArray*,NSString*>*)enemyUnits time:(NSTimeInterval)delta;

- (void)spawnBasicEnemy:(GameScene*)scene players:(NSMutableArray*)players units:(NSMutableArray*)units;

@end
