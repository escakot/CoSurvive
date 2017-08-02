//
//  Unit.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-21.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "RenderComponent.h"
#import "AnimationComponent.h"
#import "PhysicsComponent.h"
#import "StatsComponent.h"
#import "EntityPhysics.h"
#import "GameScene.h"
#import "HealthBarNode.h"

@interface Unit : GKEntity <GKAgentDelegate>

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) SKShapeNode *shape;
@property (assign, nonatomic) float mass;
@property (assign, nonatomic) float xVelocity;
@property (assign, nonatomic) float yVelocity;
@property (assign, nonatomic) float speed;
@property (assign, nonatomic) float acceleration;
@property (assign, nonatomic) float radius;
@property (assign, nonatomic) CGPoint position;

@property (strong, nonatomic) RenderComponent *renderComponent;
@property (strong, nonatomic) StatsComponent *statsComponent;
@property (strong, nonatomic) GKAgent2D *agent;
@property (strong, nonatomic) GKAgent2D *target;

@property (strong, nonatomic) GameScene *scene;
@property (strong, nonatomic) HealthBarNode *healthBar;

@property (assign, nonatomic) BOOL isDead;

@end
