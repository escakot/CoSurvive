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
#import "ToughEnemy.h"
#import "HealingEnemy.h"
#import "GameScene.h"

@interface GameManager : NSObject

@property (strong, nonatomic) GameScene *scene;

@property (strong, nonatomic) NSArray *numberOfGameColors;
@property (assign, nonatomic) NSInteger chosenColors;
@property (assign, nonatomic) NSInteger difficulty;

@property (assign, nonatomic) BOOL isBasicEnabled;
@property (assign, nonatomic) BOOL isToughEnabled;
@property (assign, nonatomic) BOOL isHealingEnabled;

@property (assign, nonatomic) NSInteger basicUnitLimit;
@property (assign, nonatomic) NSInteger toughUnitLimit;
@property (assign, nonatomic) NSInteger healingUnitLimit;

@property (assign, nonatomic) NSTimeInterval gameStartTime;
@property (assign, nonatomic) NSTimeInterval currentTime;

@property (assign, nonatomic) NSTimeInterval basicUnitRespawnTime;
@property (assign, nonatomic) NSTimeInterval basicUnitPreviousSpawnTime;
@property (assign, nonatomic) NSTimeInterval toughUnitRespawnTime;
@property (assign, nonatomic) NSTimeInterval toughUnitPreviousSpawnTime;
@property (assign, nonatomic) NSTimeInterval healingUnitRespawnTime;
@property (assign, nonatomic) NSTimeInterval healingUnitPreviousSpawnTime;

@property (strong, nonatomic) GKARC4RandomSource *randomSource;
@property (strong, nonatomic) NSMutableArray<GKAgent2D*> *toughAgents;

+ (GameManager *) sharedManager;

- (void)setDifficultyRampWithTime: (float)time;
- (void)spawnUnitsInScene:(GameScene*)scene players:(NSMutableArray*)players units:(NSMutableDictionary<NSMutableArray*,NSString*>*)enemyUnits time:(NSTimeInterval)delta;

@end

