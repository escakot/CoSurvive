//
//  Settings.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-28.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "Settings.h"
#import "MainMenu.h"

@interface Settings ()

@property (assign, nonatomic) NSInteger numberOfColors;

@property (assign, nonatomic) NSInteger playerShape;
@property (strong, nonatomic) NSArray<SKShapeNode*>* numberOfShapes;

@property (assign, nonatomic) NSInteger difficulty;
@property (strong, nonatomic) NSArray<NSString*>* difficultyLevels;

@property (strong, nonatomic) SKLabelNode *backButton;
@property (strong, nonatomic) SKLabelNode *numberOfColorsButton;
@property (strong, nonatomic) SKLabelNode *difficultyButton;
@property (strong, nonatomic) SKNode *playerShapeButton;
@property (strong, nonatomic) SKSpriteNode *shapeNode;

@end

@implementation Settings


-(void)didMoveToView:(SKView *)view
{
    [self loadUserDefaults];
    
    self.difficultyLevels = @[@"Easy", @"Normal", @"Hard", @"Insane"];
    SKLabelNode *settingsLabel = [SKLabelNode labelNodeWithText:@"Settings"];
    settingsLabel.position = CGPointMake(0, self.size.height/2 - self.size.height/8 - settingsLabel.fontSize/2);
    [self addChild:settingsLabel];
    self.backButton = [SKLabelNode labelNodeWithText:@"< Back"];
    self.backButton.position = CGPointMake(-self.size.width/2 + self.size.width/6, self.size.height/2 - self.size.height/8 - self.backButton.fontSize/2);
    [self addChild:self.backButton];
    self.numberOfColorsButton = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Number Of Colors: %li", self.numberOfColors]];
    self.numberOfColorsButton.position = CGPointMake(0, self.size.height/2 - self.size.height/3 - self.numberOfColorsButton.fontSize/2);
    [self addChild:self.numberOfColorsButton];
    self.difficultyButton = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"Difficulty: %@", self.difficultyLevels[self.difficulty]]];
    self.difficultyButton.position = CGPointMake(0, -self.size.height/2 + self.size.height/2 - self.numberOfColorsButton.fontSize/2);
    [self addChild:self.difficultyButton];
    self.playerShapeButton = [[SKNode alloc] init];
    SKLabelNode *playerShapeLabel = [SKLabelNode labelNodeWithText:@"Player Shape:"];
    playerShapeLabel.position = CGPointMake(-self.size.width/10, -self.size.height/2 + self.size.height/3 - playerShapeLabel.fontSize/2);
    [self.playerShapeButton addChild:playerShapeLabel];
    self.shapeNode = [[SKSpriteNode alloc] initWithColor:[UIColor lightGrayColor] size:CGSizeMake(40, 40)];
    self.shapeNode.position = CGPointMake(self.size.width/7, playerShapeLabel.position.y);
    [self addChild:self.playerShapeButton];
    [self addChild:self.shapeNode];
    
    SKShapeNode *square = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(30, 30)];
    square.fillColor = [UIColor redColor];
    SKShapeNode *circle = [SKShapeNode shapeNodeWithCircleOfRadius:15.0];
    circle.fillColor = [UIColor redColor];
    self.numberOfShapes = @[square, circle];
    
    [self.shapeNode addChild:self.numberOfShapes[self.playerShape]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        CGPoint touchLocation = [touch locationInNode:self];
        
        if ([self.backButton containsPoint:touchLocation])
        {
            [self saveUserDefaults];
            // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
            // including entities and graphs.
            GKScene *scene = [GKScene sceneWithFileNamed:@"MainMenu"];
            
            // Get the SKScene from the loaded GKScene
            MainMenu *sceneNode = (MainMenu *)scene.rootNode;
            
            // Set the scale mode to scale to fit the window
            //    sceneNode.scaleMode = SKSceneScaleModeAspectFill;
            sceneNode.scaleMode = SKSceneScaleModeResizeFill;
            
            SKView *skView = (SKView *)self.view;
            
            // Present the scene
            [skView presentScene:sceneNode];
        }
        if ([self.numberOfColorsButton containsPoint:touchLocation])
        {
            self.numberOfColors = self.numberOfColors >= 6 ? 2 : self.numberOfColors + 1;
            self.numberOfColorsButton.text = [NSString stringWithFormat:@"Number Of Colors: %li", self.numberOfColors];
        }
        if ([self.difficultyButton containsPoint:touchLocation])
        {
            self.difficulty++;
            self.difficultyButton.text = [NSString stringWithFormat:@"Difficulty: %@", self.difficultyLevels[self.difficulty % self.difficultyLevels.count]];
            self.difficulty = self.difficulty % self.difficultyLevels.count;
        }
        if ([self.playerShapeButton containsPoint:touchLocation] || [self.shapeNode containsPoint:touchLocation])
        {
            SKShapeNode* currentNode = (SKShapeNode*)[self.shapeNode children].firstObject;
            self.playerShape = [self.numberOfShapes indexOfObject:currentNode];
            [self.shapeNode removeAllChildren];
            [self.shapeNode addChild:self.numberOfShapes[(self.playerShape + 1) % self.numberOfShapes.count]];
        }
    }
}

-(void)loadUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.difficulty = [(NSNumber*)[userDefaults objectForKey:@"difficulty"] integerValue];
    self.numberOfColors = [(NSNumber*)[userDefaults objectForKey:@"numberOfColors"] integerValue];
    self.playerShape = [(NSNumber*)[userDefaults objectForKey:@"playerShape"] integerValue];
    self.numberOfColors = self.numberOfColors < 2 ? 2 : self.numberOfColors;
}

-(void)saveUserDefaults
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSNumber numberWithInteger:self.difficulty] forKey:@"difficulty"];
    [userDefaults setValue:[NSNumber numberWithInteger:self.numberOfColors] forKey:@"numberOfColors"];
    [userDefaults setValue:[NSNumber numberWithInteger:self.playerShape] forKey:@"playerShape"];
    [userDefaults synchronize];
}

@end
