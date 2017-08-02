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

@property (strong, nonatomic) NSMutableArray<Player*> *players;
@property (strong, nonatomic) NSMutableDictionary* enemyUnits;
@property (strong, nonatomic) NSMutableArray<Unit*>* basicEnemies;
@property (strong, nonatomic) NSMutableArray<Unit*>* toughEnemies;
@property (strong, nonatomic) NSMutableArray<Unit*>* healingEnemies;
@property (strong, nonatomic) GameManager *gameManager;

@property (strong, nonatomic) JoystickNode *joystick;
@property (strong, nonatomic) ActionNode *colorButton;
@property (strong, nonatomic) SKSpriteNode *changeColorButton;
@property (assign, nonatomic) BOOL joystickIsPressed;

@property (strong, nonatomic) NSDictionary<NSString*, NSNumber*>* backgrounds;
@property (strong, nonatomic) NSMutableArray<NSMutableArray*>* backgroundTilesArray;
@property (strong, nonatomic) NSString* chosenBackground;
@property (assign, nonatomic) NSInteger xMovement;
@property (assign, nonatomic) NSInteger yMovement;

@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *healthLabel;
@property (strong, nonatomic) HealthBarNode *healthBar;
@property (assign, nonatomic) BOOL playGame;

//NSUserDefaults
@property (assign, nonatomic) NSUInteger score;
@property (strong, nonatomic) NSNumber* highscore;
@property (strong, nonatomic) NSArray<UIColor*>* numberOfGameColors;
@property (strong, nonatomic) NSArray<GKState*>* numberOfBarrierStates;
@property (assign, nonatomic) NSInteger playerShape;
@property (assign, nonatomic) NSInteger chosenColors;

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
  self.backgrounds = @{@"grass" : @20};
  self.chosenBackground = @"grass";
  self.xMovement = 0;
  self.yMovement = 0;
  
  [self setupBackground];
  
  //GameManager Settings
  [self loadUserDefaultsIntoGameManager];
  [GameManager sharedManager].scene = self;
  [GameManager sharedManager].isBasicEnabled = YES;
  [GameManager sharedManager].isToughEnabled = YES;
  [GameManager sharedManager].isHealingEnabled = YES;
//  [GameManager sharedManager].healingUnitLimit = 1000;
//  [GameManager sharedManager].healingUnitRespawnTime = 0.5;
  [GameManager sharedManager].chosenColors = self.chosenColors;
  
  //Game Setup
  self.playGame = YES;
  self.players = [[NSMutableArray alloc] init];
  self.basicEnemies = [[NSMutableArray alloc] init];
  self.toughEnemies = [[NSMutableArray alloc] init];
  self.healingEnemies = [[NSMutableArray alloc] init];
  self.enemyUnits = [[NSMutableDictionary alloc] init];
  [self.enemyUnits setObject:self.basicEnemies forKey:@"basicEnemies"];
  [self.enemyUnits setObject:self.toughEnemies forKey:@"toughEnemies"];
  [self.enemyUnits setObject:self.healingEnemies forKey:@"healingEnemies"];
  NSArray<UIColor*>* listOfGameColors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor orangeColor], [UIColor purpleColor]];
  NSArray<GKState*>* listOfBarrierStates = @[[RedState alloc], [BlueState alloc], [GreenState alloc], [YellowState alloc], [OrangeState alloc], [PurpleState alloc]];
  self.numberOfGameColors = [listOfGameColors subarrayWithRange:NSMakeRange(0, self.chosenColors)];
  self.numberOfBarrierStates = [listOfBarrierStates subarrayWithRange:NSMakeRange(0, self.chosenColors)];
  
  //Setup Component Systems
  self.agentSystem = [[GKComponentSystem alloc] initWithComponentClass:[GKAgent2D class]];
  
  //Physics World
  self.physicsWorld.contactDelegate = self;
  
  //Players
  Player* player = [[Player alloc] initWithScene:self andColor:[UIColor redColor] withShape:self.playerShape];
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
  
  
  self.colorButton = [[ActionNode alloc] initWithSize:20.0 withIdentifier:@"color"];
  self.colorButton.delegate = self;
  self.colorButton.position = CGPointMake(self.size.width/2 - 75, -self.size.height/2 + 75);
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
  [self saveHighScoreToUserDefaults];
}

# pragma mark - Game methods

-(void)didBeginContact:(SKPhysicsContact *)contact
{
  Unit *enemyBody;
  if (contact.bodyA.categoryBitMask == enemyCategory)
  {
    [contact.bodyA.node removeFromParent];
    enemyBody = (Unit*)contact.bodyA.node.entity;
    self.score++;
    if (contact.bodyB.categoryBitMask == playerCategory)
    {
      Player * playerBody = (Player*)contact.bodyB.node.entity;
      [playerBody.statsComponent wasAttacked:enemyBody];
    }
  } else if (contact.bodyA.categoryBitMask == playerCategory)
  {
    [contact.bodyB.node removeFromParent];
    enemyBody = (Unit*)contact.bodyB.node.entity;
    Player * playerBody = (Player*)contact.bodyA.node.entity;
    [playerBody.statsComponent wasAttacked:enemyBody];
  } else {
    [contact.bodyB.node removeFromParent];
    enemyBody = (Unit*)contact.bodyB.node.entity;
    self.score++;
  }
  [self.basicEnemies removeObject:enemyBody];
  [self.toughEnemies removeObject:enemyBody];
  [self.healingEnemies removeObject:enemyBody];
  [self.agentSystem removeComponent:enemyBody.agent];
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
//    NSLog(@"%li", self.basicEnemies.count);
//    NSLog(@"%li", self.toughEnemies.count);
//    NSLog(@"%li", self.agentSystem.components.count);
  
  // Update entities
  for (GKEntity *entity in self.entities) {
    [entity updateWithDeltaTime:dt];
  }
  //Update enemies
  NSMutableArray *discardedObjects = [@[] mutableCopy];
  for (Unit* unit in self.healingEnemies)
  {
    if (unit.isDead)
    {
        [discardedObjects addObject:unit];
        [unit.renderComponent.node removeFromParent];
        [self.agentSystem removeComponent:unit.agent];
      
    }
  }
  [self.healingEnemies removeObjectsInArray:discardedObjects];
//  for (NSMutableArray* units in self.enemyUnits) {
//    NSMutableArray *discardedObjects = [@[] mutableCopy];
//    for (Unit *unit in self.enemyUnits[units])
//    {
//      if (unit.isDead)
//      {
//        [discardedObjects addObject:unit];
//        [unit.renderComponent.node removeFromParent];
//        [self.agentSystem removeComponent:unit.agent];
//      }
//    }
//    [self.enemyUnits[units] removeObjectsInArray:discardedObjects];
//  }
  
  _lastUpdateTime = currentTime;
  [self checkGameOver];
  [self updateBackground];
  [self.agentSystem updateWithDeltaTime:dt];
}

- (void)checkGameOver
{
  Player *player = self.players[0];
  if (player.isDead)
  {
    if (self.playGame)
    {
      [self saveHighScoreToUserDefaults];
      self.playGame = NO;
      GameOverNode *gameOverScreen = [[GameOverNode alloc] initWithScene:self withScore:[self.highscore integerValue]];
      gameOverScreen.position = player.renderComponent.node.position;
      gameOverScreen.zPosition = 10;
      [self addChild:gameOverScreen];
    }
  }
}


# pragma mark - Saving/Loading Game

-(void)saveHighScoreToUserDefaults
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  self.highscore = self.score > [self.highscore integerValue] ? [NSNumber numberWithInteger:self.score] : self.highscore;
  [userDefaults setValue:self.highscore forKey:@"highscore"];
  [userDefaults synchronize];
}

-(void)loadUserDefaultsIntoGameManager
{
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [GameManager sharedManager].difficulty = [(NSNumber*)[userDefaults objectForKey:@"difficulty"] integerValue];
  self.chosenColors = [(NSNumber*)[userDefaults objectForKey:@"numberOfColors"] integerValue];
  self.chosenColors  = self.chosenColors < 2 ? 2 : self.chosenColors;
  self.playerShape = [(NSNumber*)[userDefaults objectForKey:@"playerShape"] integerValue];
  self.highscore = [userDefaults valueForKey:@"highscore"];
}

# pragma mark - Background methods

- (void)setupBackground
{
//  NSInteger xTiles = ceil(self.size.width/512) + 2;
//  NSInteger yTiles = ceil(self.size.height/512) + 2;
//  CGFloat middleX = xTiles * 512 / 2 - 256;
//  CGFloat middleY = yTiles * 512 / 2 - 256;
  NSInteger xTiles = ceil(self.size.width/25) + 1;
  NSInteger yTiles = ceil(self.size.height/25) + 1;
  CGFloat middleX = xTiles * 25 / 2 - 25;
  CGFloat middleY = yTiles * 25 / 2 ;
  NSInteger randomTile = [[GKARC4RandomSource sharedRandom] nextIntWithUpperBound:(self.backgrounds[self.chosenBackground].integerValue)];
  
  self.backgroundTilesArray = [[NSMutableArray alloc] init];
  for (int i = 0; i < yTiles; i++)
  {
    NSMutableArray *yTileArray = [[NSMutableArray alloc] init];
    for (int j = 0; j < xTiles; j++)
    {
      SKSpriteNode *tile = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@%lu", self.chosenBackground, randomTile]]];
//      SKSpriteNode *tile = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"galaxy"]];
      tile.position = CGPointMake(j * 25 - middleX, middleY - i * 25);
      [yTileArray addObject:tile];
      [self addChild:tile];
    }
    [self.backgroundTilesArray addObject:yTileArray];
  }
}

-(void)updateBackground
{
  Player *player = self.players[0];
  [self.healthBar setHealthBar:(float)player.statsComponent.healthPoints/(float)player.statsComponent.maxHealthPoints];
  self.healthBar.position = CGPointMake(player.renderComponent.node.position.x - self.size.width/2 + self.healthBar.size.width/2 + 30, player.renderComponent.node.position.y + self.size.height/2 - 20);
  self.scoreLabel.text = [NSString stringWithFormat:@"Score: %li", self.score];
  self.scoreLabel.position = CGPointMake(player.renderComponent.node.position.x + self.size.width/2 - 100
                                         ,player.renderComponent.node.position.y + self.size.height/2 - 50 );
  
  if (player.renderComponent.node.position.x/25 > self.xMovement)
  {
    self.xMovement++;
    for (NSMutableArray* xTileArray in self.backgroundTilesArray) {
      SKSpriteNode *tile = xTileArray.firstObject;
      tile.position = CGPointMake(tile.position.x + (xTileArray.count) * 25, tile.position.y);
      [xTileArray removeObject:xTileArray.firstObject];
      [xTileArray addObject:tile];
    }
  }
  if(player.renderComponent.node.position.x/25 < self.xMovement)
  {
    self.xMovement--;
    for (NSMutableArray* xTileArray in self.backgroundTilesArray) {
      SKSpriteNode *tile = xTileArray.lastObject;
      tile.position = CGPointMake(tile.position.x - (xTileArray.count) * 25, tile.position.y);
      [xTileArray removeLastObject];
      [xTileArray insertObject:tile atIndex:0];
    }
  }
  if (player.renderComponent.node.position.y/25 > self.yMovement)
  {
    self.yMovement++;
    for (SKSpriteNode* tile in self.backgroundTilesArray.lastObject) {
      tile.position = CGPointMake(tile.position.x, tile.position.y + (self.backgroundTilesArray.count * 25));
    }
    NSMutableArray* tileRow = self.backgroundTilesArray.lastObject;
    [self.backgroundTilesArray removeLastObject];
    [self.backgroundTilesArray insertObject:tileRow atIndex:0];
  }
  if (player.renderComponent.node.position.y/25 < self.yMovement)
  {
    self.yMovement--;
    for (SKSpriteNode* tile in self.backgroundTilesArray.firstObject) {
      tile.position = CGPointMake(tile.position.x, tile.position.y - (self.backgroundTilesArray.count * 25));
    }
    NSMutableArray* tileRow = self.backgroundTilesArray.firstObject;
    [self.backgroundTilesArray removeObjectAtIndex:0];
    [self.backgroundTilesArray addObject:tileRow];
  }
  
}


# pragma mark - Joystick methods

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

-(void)performAction:(NSString *)identifier
{
  if ([identifier isEqualToString:@"color"])
  {
    Player *player = self.players[0];
    NSUInteger currentColorIndex = [self.numberOfGameColors indexOfObject:self.colorButton.button.fillColor];
    NSUInteger nextColorIndex = (currentColorIndex + 1) % self.numberOfGameColors.count;
    self.colorButton.button.fillColor = self.numberOfGameColors[nextColorIndex];
    [player.barrierComponent.stateMachine enterState:[self.numberOfBarrierStates[currentColorIndex] class]];
  }
}

@end
