//
//  GameScene.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-21.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface GameScene : SKScene

@property (nonatomic) NSMutableArray<GKEntity *> *entities;
@property (nonatomic) NSMutableDictionary<NSString*, GKGraph *> *graphs;

@property (nonatomic, readonly) GKComponentSystem *agentSystem;
@property (nonatomic, readonly) GKComponentSystem *animationSystem;
@property (nonatomic, readonly) GKComponentSystem *physicsSystem;


@end
