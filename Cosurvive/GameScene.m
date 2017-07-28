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
#import "ActionNode.h"
#import "GameOverNode.h"


@interface GameScene () <SKPhysicsContactDelegate, JoystickDelegate, ActionButtonDelegate>

@property (nonatomic, readwrite) GKComponentSystem *agentSystem;
@property (nonatomic, readwrite) GKComponentSystem *animationSystem;

@property (strong, nonatomic) NSArray<UIColor*>* numberOfGameColors;
@property (strong, nonatomic) NSArray<GKState*>* numberOfBarrierStates;
@property (assign, nonatomic) NSUInteger chosenColors;

@property (strong, nonatomic) NSMutableArray<Player*> *players;
@property (strong, nonatomic) NSMutableDictionary* enemyUnits;
@property (strong, nonatomic) NSMutableArray<Unit*>* basicEnemies;
@property (strong, nonatomic) NSMutableArray<Unit*>* toughEnemies;
@property (strong, nonatomic) GameManager *gameManager;

@property (strong, nonatomic) JoystickNode *joystick;
@property (strong, nonatomic) ActionNode *colorButton;
@property (strong, nonatomic) SKSpriteNode *changeColorButton;
@property (assign, nonatomic) BOOL joystickIsPressed;

@property (strong, nonatomic) SKSpriteNode *bgTexture1;
@property (strong, nonatomic) SKSpriteNode *bgTexture2;
@property (strong, nonatomic) SKSpriteNode *bgTexture3;
@property (strong, nonatomic) SKSpriteNode *bgTexture4;
@property (strong, nonatomic) SKSpriteNode *bgTexture5;
@property (strong, nonatomic) SKSpriteNode *bgTexture6;
@property (strong, nonatomic) SKSpriteNode *bgTexture7;
@property (strong, nonatomic) SKSpriteNode *bgTexture8;
@property (strong, nonatomic) SKSpriteNode *bgTexture9;
@property (assign, nonatomic) NSInteger bgCount;

@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *healthLabel;
@property (strong, nonatomic) HealthBarNode *healthBar;
@property (assign, nonatomic) BOOL playGame;

@property (assign, nonatomic) NSUInteger score;
@property (strong, nonatomic) NSNumber* highscore;

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
  //  [self setupBackground];
  
  //Game Configurations
  self.playGame = YES;
  self.players = [[NSMutableArray alloc] init];
  self.basicEnemies = [[NSMutableArray alloc] init];
  self.toughEnemies = [[NSMutableArray alloc] init];
  self.enemyUnits = [[NSMutableDictionary alloc] init];
  [self.enemyUnits setObject:self.basicEnemies forKey:@"basicEnemies"];
  [self.enemyUnits setObject:self.toughEnemies forKey:@"toughEnemies"];
  self.chosenColors = 3;
  NSArray<UIColor*>* listOfGameColors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor purpleColor]];
  NSArray<GKState*>* listOfBarrierStates = @[[RedState alloc], [BlueState alloc], [GreenState alloc], [YellowState alloc], [OrangeState alloc], [PurpleState alloc]];
  self.numberOfGameColors = [listOfGameColors subarrayWithRange:NSMakeRange(0, self.chosenColors)];
  self.numberOfBarrierStates = [listOfBarrierStates subarrayWithRange:NSMakeRange(0, self.chosenColors)];
  
  
  //GameManager Settings
  [GameManager sharedManager].scene = self;
  [GameManager sharedManager].isBasicEnabled = YES;
  [GameManager sharedManager].isToughEnabled = YES;
  [GameManager sharedManager].toughUnitLimit = 50;
  [GameManager sharedManager].chosenColors = self.chosenColors;
  
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
  self.joystick.zPosition = 100.0;
  [player.renderComponent.node addChild:self.joystick];
  
  
  self.colorButton = [[ActionNode alloc] initWithSize:15.0 withIdentifier:@"color"];
  self.colorButton.delegate = self;
  self.colorButton.position = CGPointMake(self.size.width/2 - 60, -self.size.height/2 + 60);
  self.colorButton.zPosition = 100.0;
  [player.renderComponent.node addChild:self.colorButton];
  //  self.changeColorButton = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size:CGSizeMake(30, 30)];
  //  self.changeColorButton.position = CGPointMake(self.size.width/2 - 100, -self.size.height/2 + 100);
  //  [player.renderComponent.node addChild:self.changeColorButton];
  
  
  //Score and Health
  self.score = 0;
  self.scoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Score: %li", self.score]];
  self.scoreLabel.fontColor = [UIColor whiteColor];
  [self addChild:self.scoreLabel];
  self.healthBar = [[HealthBarNode alloc] initWithSize:CGSizeMake(100.0, 10)];
  [self addChild:self.healthBar];
  
  //Load score
  [self highScoreToUserDefaults];
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
  
  if (contact.bodyA.categoryBitMask == enemyCategory)
  {
    [contact.bodyA.node removeFromParent];
    Unit *enemyBody = (Unit*)contact.bodyA.node.entity;
    [self.basicEnemies removeObject:enemyBody];
    [self.toughEnemies removeObject:enemyBody];
    [self.agentSystem removeComponent:enemyBody.agent];
    self.score++;
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
    Unit *enemyBody = (Unit*)contact.bodyB.node.entity;
    [self.basicEnemies removeObject:enemyBody];
    [self.toughEnemies removeObject:enemyBody];
    [self.agentSystem removeComponent:enemyBody.agent];
    
  } else {
    [contact.bodyB.node removeFromParent];
    Unit *enemyBody = (Unit*)contact.bodyB.node.entity;
    [self.basicEnemies removeObject:enemyBody];
    [self.toughEnemies removeObject:enemyBody];
    [self.agentSystem removeComponent:enemyBody.agent];
    self.score++;
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
  //  NSLog(@"%li", self.basicEnemies.count);
  //  NSLog(@"%li", self.toughEnemies.count);
  //  NSLog(@"%li", self.agentSystem.components.count);
  
  // Update entities
  for (GKEntity *entity in self.entities) {
    [entity updateWithDeltaTime:dt];
  }
  
  _lastUpdateTime = currentTime;
  [self checkGameOver];
  [self updateBackground];
  [self.agentSystem updateWithDeltaTime:dt];
}

-(void)updateBackground
{
  Player *player = self.players[0];
  [self.healthBar setHealthBar:(float)player.healthComponent.healthPoints/(float)player.healthComponent.maxHealthPoints];
  self.healthBar.position = CGPointMake(player.renderComponent.node.position.x - self.size.width/2 + self.healthBar.size.width/2 + 30, player.renderComponent.node.position.y + self.size.height/2 - 20);
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.score];
  self.scoreLabel.position = CGPointMake(player.renderComponent.node.position.x + self.size.width/2 - 100
                                         ,player.renderComponent.node.position.y + self.size.height/2 - 50 );
  //  NSLog(@"%@", NSStringFromCGPoint(player.renderComponent.node.position));
  //  NSLog(@"%@", NSStringFromCGPoint(self.bgTexture1.position));
  //  NSLog(@"%@", NSStringFromCGPoint(self.bgTexture2.position));
  
  //  if ((self.bgCount % 2) == 0)
  //  {
  //    if (self.bgTexture1.position.x < player.renderComponent.node.position.x - 100 ||
  //        self.bgTexture1.position.x > player.renderComponent.node.position.x + 100 ||
  //        self.bgTexture1.position.y < player.renderComponent.node.position.y - 100 ||
  //        self.bgTexture1.position.y > player.renderComponent.node.position.y + 100)
  //    {
  //      self.bgTexture2.position = player.renderComponent.node.position;
  //      self.bgCount++;
  //    }
  //  } else {
  //    if (self.bgTexture2.position.x < player.renderComponent.node.position.x - 100 ||
  //        self.bgTexture2.position.x > player.renderComponent.node.position.x + 100 ||
  //        self.bgTexture2.position.y < player.renderComponent.node.position.y - 100 ||
  //        self.bgTexture2.position.y > player.renderComponent.node.position.y + 100)
  //    {
  //      self.bgTexture1.position = player.renderComponent.node.position;
  //      self.bgCount++;
  //    }
  //  }
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

- (void)checkGameOver
{
  Player *player = self.players[0];
  if (player.isDead)
  {
    if (self.playGame)
    {
      [self highScoreToUserDefaults];
      self.playGame = NO;
      GameOverNode *gameOverScreen = [[GameOverNode alloc] initWithScene:self withScore:[self.highscore integerValue]];
      gameOverScreen.position = player.renderComponent.node.position;
      gameOverScreen.zPosition = 10;
      [self addChild:gameOverScreen];
    }
  }
}

-(void)highScoreToUserDefaults
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  self.highscore = [userDefaults valueForKey:@"highscore"];
  self.highscore = self.score > [self.highscore integerValue] ? [NSNumber numberWithInteger:self.score] : self.highscore;
  [userDefaults setValue:self.highscore forKey:@"highscore"];
  [userDefaults synchronize];
}

- (void)setupBackground
{
  SKTexture *backgroundTexture = [SKTexture textureWithImageNamed:@"grass"];
  self.bgTexture1 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture2 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture3 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture4 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture5 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture6 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture7 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture8 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture9 = [[SKSpriteNode alloc] initWithTexture:backgroundTexture];
  self.bgTexture1.position = CGPointMake(-self.bgTexture1.size.width, self.bgTexture1.size.height);
  self.bgTexture2.position = CGPointMake(0, self.bgTexture1.size.height);
  self.bgTexture3.position = CGPointMake(self.bgTexture1.size.width, self.bgTexture1.size.height);
  self.bgTexture4.position = CGPointMake(-self.bgTexture1.size.width, 0);
  self.bgTexture5.position = CGPointMake(0, 0);
  self.bgTexture6.position = CGPointMake(self.bgTexture1.size.width, 0);
  self.bgTexture7.position = CGPointMake(-self.bgTexture1.size.width, -self.bgTexture1.size.height);
  self.bgTexture8.position = CGPointMake(0, -self.bgTexture1.size.height);
  self.bgTexture9.position = CGPointMake(self.bgTexture1.size.width, -self.bgTexture1.size.height);
  //  NSLog(@"%@", NSStringFromCGSize(self.bgTexture1.size));
  [self addChild:self.bgTexture1];
  [self addChild:self.bgTexture2];
  [self addChild:self.bgTexture3];
  [self addChild:self.bgTexture4];
  [self addChild:self.bgTexture5];
  [self addChild:self.bgTexture6];
  [self addChild:self.bgTexture7];
  [self addChild:self.bgTexture8];
  [self addChild:self.bgTexture9];
}

-(void)performAction:(NSString *)identifier
{
  if ([identifier isEqualToString:@"color"])
  {
    Player *player = self.players[0];
    player.animationComponent.sprite.color = self.colorButton.button.fillColor;
    player.barrierComponent.sprite.color = self.colorButton.button.fillColor;
    NSUInteger currentColorIndex = [self.numberOfGameColors indexOfObject:self.colorButton.button.fillColor];
    NSUInteger nextColorIndex = (currentColorIndex + 1) % self.numberOfGameColors.count;
    self.colorButton.button.fillColor = self.numberOfGameColors[nextColorIndex];
    [player.barrierComponent.stateMachine enterState:[self.numberOfBarrierStates[nextColorIndex] class]];
  }
}

@end
