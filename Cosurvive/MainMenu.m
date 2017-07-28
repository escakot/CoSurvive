//
//  MainMenu.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-21.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "MainMenu.h"
#import "GameScene.h"

@interface MainMenu ()

@property (strong, nonatomic) SKLabelNode *startGameButton;
@property (strong, nonatomic) SKLabelNode *settingsButton;

@end

@implementation MainMenu

-(void)didMoveToView:(SKView *)view {
  
  SKSpriteNode *menuScreen = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"cosurvive-menu"] size:self.size];
  [self addChild:menuScreen];
  self.startGameButton = [SKLabelNode labelNodeWithText:@"New Game"];
  self.startGameButton.fontSize = self.size.height/12;
  self.startGameButton.position = CGPointMake(0, -self.size.height/2 + self.size.height/4);
  [self addChild:self.startGameButton];
  self.settingsButton = [SKLabelNode labelNodeWithText:@"Settings"];
  self.settingsButton.fontSize = self.size.height/12;
  self.settingsButton.position = CGPointMake(0, -self.size.height/2 + self.size.height/7);
  [self addChild:self.settingsButton];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  //    NSSet *buttonTouches = [event touchesForView:self.singlePlayerButton];
  //    UITouch *buttonTouch = buttonTouches.anyObject;
  for (UITouch * touch in touches) {
    CGPoint location = [touch locationInNode:self];
    if ([self.startGameButton containsPoint:location])
    {
      GKScene *scene = [GKScene sceneWithFileNamed:@"GameScene"];
      
      // Get the SKScene from the loaded GKScene
      GameScene *sceneNode = (GameScene *)scene.rootNode;
      
      // Copy gameplay related content over to the scene
      sceneNode.entities = [scene.entities mutableCopy];
      sceneNode.graphs = [scene.graphs mutableCopy];
      
      // Set the scale mode to scale to fit the window
      sceneNode.scaleMode = SKSceneScaleModeResizeFill;
      
      SKView *skView = (SKView *)self.view;
      
      // Present the scene
      [skView presentScene:sceneNode];
      
      //      skView.showsFPS = YES;
      //      skView.showsNodeCount = YES;
    }
    if ([self.settingsButton containsPoint:location])
    {
      GKScene *scene = [GKScene sceneWithFileNamed:@"Settings"];
      
      // Get the SKScene from the loaded GKScene
      GameScene *sceneNode = (GameScene *)scene.rootNode;
      
      // Set the scale mode to scale to fit the window
      sceneNode.scaleMode = SKSceneScaleModeResizeFill;
      
      SKView *skView = (SKView *)self.view;
      
      // Present the scene
      [skView presentScene:sceneNode];
    }
  }
  
}

@end
