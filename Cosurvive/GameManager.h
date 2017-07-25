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
@interface GameManager : NSObject

@property (strong, nonatomic) NSMutableArray<Player*>* players;
@property (assign, nonatomic) NSTimeInterval basicUnitRespawnTime;
@property (assign, nonatomic) NSTimeInterval basicUnitPreviousSpawnTime;

//- (void)startGame:(SKScene*)scene withAgentSystem:(GKComponentSystem*)system andTime:(NSTimeInterval)time;

- (BasicEnemy*)spawnBasicUnit:(CGSize)screenSize;

@end
