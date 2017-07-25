//
//  GameScene.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-21.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//


#import "GameScene.h"
#import "GameManager.h"

#import "JoystickNode.h"


@interface GameScene () <SKPhysicsContactDelegate, JoystickDelegate>

//@property (nonatomic, readwrite) GKComponentSystem *agentSystem;
@property (nonatomic, readwrite) GKComponentSystem *animationSystem;

@property (strong, nonatomic) NSMutableArray<Player*> *players;
@property (strong, nonatomic) NSMutableDictionary* enemyUnits;
@property (strong, nonatomic) NSMutableArray<BasicEnemy*>* basicEnemies;
@property (strong, nonatomic) GameManager *gameManager;
@property (strong, nonatomic) JoystickNode *joystick;
@property (assign, nonatomic) BOOL joystickIsPressed;

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
  self.players = [[NSMutableArray alloc] init];
  self.basicEnemies = [[NSMutableArray alloc] init];
  self.enemyUnits = [[NSMutableDictionary alloc] init];
  [self.enemyUnits setObject:self.basicEnemies forKey:@"basicEnemies"];
  
  //Setup Component Systems
  self.agentSystem = [[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]];
  
  //Physics World
  self.physicsWorld.contactDelegate = self;
  
  //Players
  Player* player = [[Player alloc] initWithScene:self andColor:[UIColor redColor]];
  [self.players addObject:player];
  
  for (Player* player in self.players)
  {
    [self.agentSystem addComponent:player.agent];
    [self.entities addObject:player];
  }
  
  //Joystick
  self.joystick = [[JoystickNode alloc] initWithSize:CGSizeMake(100.0, 100.0)];
  self.joystick.userInteractionEnabled = YES;
  self.joystick.delegate = self;
  self.joystick.position = CGPointMake(-self.size.width/2 + 100, -self.size.height/2 + 100);
  [self addChild:self.joystick];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
  if (contact.bodyA.categoryBitMask == enemyCategory)
  {
    [contact.bodyA.node removeFromParent];
    BasicEnemy *enemyBody = (BasicEnemy*)contact.bodyA.node.entity;
    [self.basicEnemies removeObject:enemyBody];
    [self.agentSystem removeComponent:enemyBody.agent];
    Player * playerBody = (Player*)contact.bodyB.node.entity;
    playerBody.healthComponent.healthPoints -= 10;
  } else {
    [contact.bodyB.node removeFromParent];
    BasicEnemy *enemyBody = (BasicEnemy*)contact.bodyB.node.entity;
    [self.basicEnemies removeObject:enemyBody];
    [self.agentSystem removeComponent:enemyBody.agent];
    Player * playerBody = (Player*)contact.bodyA.node.entity;
    playerBody.healthComponent.healthPoints -= 10;
  }
}

- (void)touchDownAtPoint:(CGPoint)pos {
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
  
  [[GameManager sharedManager] spawnUnitsInScene:self players:self.players units:self.enemyUnits time:dt];
//  NSLog(@"%f", self.size.width);
  // Update entities
  for (GKEntity *entity in self.entities) {
    [entity updateWithDeltaTime:dt];
  }
  
  _lastUpdateTime = currentTime;
//  [self.animationSystem updateWithDeltaTime:dt];
  [self.agentSystem updateWithDeltaTime:dt];
}

-(void)updateJoystick:(JoystickNode *)joystick xValue:(float)x yValue:(float)y
{
  Player *player = self.players[0];
  player.xVelocity = x;
  player.yVelocity = y;
}

- (void)isPressed:(JoystickNode *)joystick isPressed:(BOOL)pressed
{
  self.joystickIsPressed = pressed;
}

@end
