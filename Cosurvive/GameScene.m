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
#import "HealthBarNode.h"


@interface GameScene () <SKPhysicsContactDelegate, JoystickDelegate>

@property (nonatomic, readwrite) GKComponentSystem *agentSystem;
@property (nonatomic, readwrite) GKComponentSystem *animationSystem;

@property (strong, nonatomic) NSMutableArray<Player*> *players;
@property (strong, nonatomic) NSMutableDictionary* enemyUnits;
@property (strong, nonatomic) NSMutableArray<BasicEnemy*>* basicEnemies;
@property (strong, nonatomic) GameManager *gameManager;
@property (strong, nonatomic) JoystickNode *joystick;
@property (strong, nonatomic) SKSpriteNode *changeColorButton;
@property (assign, nonatomic) BOOL joystickIsPressed;

@property (strong, nonatomic) SKSpriteNode *bgTexture1;
@property (strong, nonatomic) SKSpriteNode *bgTexture2;
@property (assign, nonatomic) NSInteger bgCount;

@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *healthLabel;
@property (strong, nonatomic) HealthBarNode *healthBar;
@property (assign, nonatomic) NSUInteger score;

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
  //Setup Background Texture
//  self.bgTexture1 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"grass"]];
//  self.bgTexture1.size = CGSizeMake(self.frame.size.width * 1.5, self.frame.size.height * 1.5);
//  self.bgTexture1.position = self.position;
//  [self addChild:self.bgTexture1];
//  self.bgTexture2 = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"grass"]];
//  self.bgTexture2.size = self.bgTexture1.size;
//  [self addChild:self.bgTexture2];
//  self.bgCount = 0;
  
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
    [self.physicsSystem addComponent:player.physicsComponent];
    [self.entities addObject:player];
  }
  
  //Camera
  SKCameraNode *camera = [[SKCameraNode alloc] init];
  self.camera = camera;
  [player.renderComponent.node addChild:camera];
  
  //Joystick
  self.joystick = [[JoystickNode alloc] initWithSize:CGSizeMake(100.0, 100.0)];
  self.joystick.userInteractionEnabled = YES;
  self.joystick.delegate = self;
  self.joystick.position = CGPointMake(-self.size.width/2 + 100, -self.size.height/2 + 100);
  [player.renderComponent.node addChild:self.joystick];
  
  self.changeColorButton = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size:CGSizeMake(30, 30)];
  self.changeColorButton.position = CGPointMake(self.size.width/2 - 100, -self.size.height/2 + 100);
  [player.renderComponent.node addChild:self.changeColorButton];
  
  
  //Score and Health
  self.healthBar = [[HealthBarNode alloc] initWithSize:CGSizeMake(100.0, 15)];
  self.healthBar.position = CGPointMake(-100, self.size.height/2 - 20);
  [self addChild:self.healthBar];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
  
  if (contact.bodyA.categoryBitMask == enemyCategory)
  {
    [contact.bodyA.node removeFromParent];
    BasicEnemy *enemyBody = (BasicEnemy*)contact.bodyA.node.entity;
    [self.basicEnemies removeObject:enemyBody];
    [self.agentSystem removeComponent:enemyBody.agent];
    if (contact.bodyB.categoryBitMask == playerCategory)
    {
      Player * playerBody = (Player*)contact.bodyB.node.entity;
      playerBody.healthComponent.healthPoints -= 10;
    }
  } else if (contact.bodyA.categoryBitMask == playerCategory)
  {
    Player * playerBody = (Player*)contact.bodyA.node.entity;
    playerBody.healthComponent.healthPoints -= 10;
    [contact.bodyB.node removeFromParent];
    BasicEnemy *enemyBody = (BasicEnemy*)contact.bodyB.node.entity;
    [self.basicEnemies removeObject:enemyBody];
    [self.agentSystem removeComponent:enemyBody.agent];
    
  } else {
    [contact.bodyB.node removeFromParent];
    BasicEnemy *enemyBody = (BasicEnemy*)contact.bodyB.node.entity;
    [self.basicEnemies removeObject:enemyBody];
    [self.agentSystem removeComponent:enemyBody.agent];
  }
}

- (void)touchDownAtPoint:(CGPoint)pos {
}

- (void)touchMovedToPoint:(CGPoint)pos {
}

- (void)touchUpAtPoint:(CGPoint)pos {
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  Player *player = self.players[0];
  for (UITouch * touch in touches) {
    CGPoint location = [touch locationInNode:player.renderComponent.node];
    if ([self.changeColorButton containsPoint:location])
    {
      if ([self.changeColorButton.color isEqual:[UIColor blueColor]])
      {
        [player.barrierComponent.stateMachine enterState:[BlueState class]];
        self.changeColorButton.color = [UIColor redColor];
      } else {
        [player.barrierComponent.stateMachine enterState:[RedState class]];
        self.changeColorButton.color = [UIColor blueColor];
        
      }
    }
  }
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
//  [self updateBackground];
  [self.agentSystem updateWithDeltaTime:dt];
}

-(void)updateBackground
{
  Player *player = self.players[0];
//  NSLog(@"%@", NSStringFromCGPoint(player.renderComponent.node.position));
//  NSLog(@"%@", NSStringFromCGPoint(self.bgTexture1.position));
//  NSLog(@"%@", NSStringFromCGPoint(self.bgTexture2.position));
  if ((self.bgCount % 2) == 0)
  {
    if (self.bgTexture1.position.x < player.renderComponent.node.position.x - 100 ||
        self.bgTexture1.position.x > player.renderComponent.node.position.x + 100 ||
        self.bgTexture1.position.y < player.renderComponent.node.position.y - 100 ||
        self.bgTexture1.position.y > player.renderComponent.node.position.y + 100)
    {
      self.bgTexture2.position = player.renderComponent.node.position;
      self.bgCount++;
    }
  } else {
    if (self.bgTexture2.position.x < player.renderComponent.node.position.x - 100 ||
        self.bgTexture2.position.x > player.renderComponent.node.position.x + 100 ||
        self.bgTexture2.position.y < player.renderComponent.node.position.y - 100 ||
        self.bgTexture2.position.y > player.renderComponent.node.position.y + 100)
    {
      self.bgTexture1.position = player.renderComponent.node.position;
      self.bgCount++;
    }
  }
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
