//
//  GameScene.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-21.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//


#import "GameScene.h"
#import "GameManager.h"
//Characters
#import "Player.h"
#import "BasicEnemy.h"
#import "EnemyAgentNode.h"

#import "AnimationComponent.h"
#import "RenderComponent.h"
#import "PhysicsComponent.h"
#import "EntityPhysics.h"


@interface GameScene () <SKPhysicsContactDelegate>

@property (nonatomic, readwrite) GKComponentSystem *agentSystem;
@property (nonatomic, readwrite) GKComponentSystem *animationSystem;

@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) BasicEnemy *basicEnemy;
@property (strong, nonatomic) BasicEnemy *basicEnemy2;
@property (strong, nonatomic) GameManager *gameManager;
@property GKGoal *seekGoal;

@end

@implementation GameScene {
  NSTimeInterval _lastUpdateTime;
}

- (void)sceneDidLoad {
  // Setup your scene here
  
  // Initialize update time
  _lastUpdateTime = 0;
  
  
}

-(void)didMoveToView:(SKView *)view
{
  //Game Configurations
  self.gameManager = [[GameManager alloc] init];
  self.gameManager.basicUnitRespawnTime = 0.5;
  //Setup Component Systems
  self.agentSystem = [[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]];
//  self.agentSystem = [[GKComponentSystem alloc] init];
  //Physics World
  self.physicsWorld.contactDelegate = self;
  self.player = [[Player alloc] init];
  [self.gameManager.players addObject:self.player];
//  GKAgent2D *agent = [[GKAgent2D alloc] init];
//  GKGoal *goal = [GKGoal goalToSeekAgent:self.player.agent];
//  agent.behavior = [GKBehavior behaviorWithGoal:goal weight:1.0];

  
  self.basicEnemy = [[BasicEnemy alloc] initWithColor:self.player.color atPosition:CGPointMake(-150,150) withTarget:self.player.agent];
  
  self.basicEnemy2 = [[BasicEnemy alloc] initWithColor:[UIColor redColor] atPosition:CGPointMake(-150,-150) withTarget:self.player.agent];
  
  [self addChild:self.player.renderComponent.node];
  [self.agentSystem addComponent:self.player.agent];
  [self.agentSystem addComponent:self.basicEnemy2.agent];
  [self addChild:self.basicEnemy2.renderComponent.node];
  [self addChild:self.basicEnemy.renderComponent.node];
  [self.agentSystem addComponent:self.basicEnemy.agent];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
  if (contact.bodyA.categoryBitMask == enemyCategory)
  {
    [contact.bodyA.node removeFromParent];
  } else {
    [contact.bodyB.node removeFromParent];
  }
}

- (void)touchDownAtPoint:(CGPoint)pos {
  self.player.agent.position = (vector_float2){pos.x, pos.y};
}

- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  for (UITouch *t in touches) {[self touchMovedToPoint:[t locationInNode:self]];}
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//  self.seeking = YES;
//  CGPoint position = [touches.anyObject locationInNode:self];
//  self.trackingAgent.position = (vector_float2){position.x, position.y};
  
  
  for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}

-(void)update:(CFTimeInterval)currentTime {
  // Called before each frame is rendered
  
  // Initialize _lastUpdateTime if it has not already been
  if (_lastUpdateTime == 0) {
    _lastUpdateTime = currentTime;
  }
  
  // Calculate time since last update
  CGFloat dt = currentTime - _lastUpdateTime;
  
//  NSLog(@"%f", self.size.width);
  // Update entities
//  for (GKEntity *entity in self.entities) {
//    [entity updateWithDeltaTime:dt];
//  }
  [self spawnBasicEnemy];
  
  _lastUpdateTime = currentTime;
//  [self.animationSystem updateWithDeltaTime:dt];
  [self.agentSystem updateWithDeltaTime:dt];
}


-(void)spawnBasicEnemy
{
  GKARC4RandomSource *randomSource = [[GKARC4RandomSource alloc] init];
//  NSInteger randTarget = [randomSource nextIntWithUpperBound:self.players.count];
  CGFloat x = ((float)self.size.width * randomSource.nextUniform) - self.size.width/2;
  CGFloat y = ((float)self.size.height * randomSource.nextUniform) - self.size.height/2;
  BasicEnemy *basicEnemy = [[BasicEnemy alloc] initWithColor:[UIColor redColor] atPosition:CGPointMake(x, y) withTarget:self.player.agent];
  
//  SKSpriteNode *node = [[SKSpriteNode alloc] initWithColor:self.player.color size:CGSizeMake(50, 50)];
//  node.position = CGPointMake(x, y);
//  [self addChild:node];
  [self addChild:basicEnemy.renderComponent.node];
  [self.agentSystem addComponent:basicEnemy.agent];
  
}


@end
