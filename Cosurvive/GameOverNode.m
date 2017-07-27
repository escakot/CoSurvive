//
//  GameOverNode.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-26.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "GameOverNode.h"
#import "GameScene.h"
#import "MainMenu.h"
#import <GameplayKit/GameplayKit.h>

@implementation GameOverNode

-(instancetype)initWithScene:(SKScene*)scene withScore:(NSInteger)score
{
  self = [super init];
  if (self) {
    _targetScene = scene;
    _screen = [[SKSpriteNode alloc] initWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4] size:CGSizeMake(scene.size.width * .7, scene.size.height * .7)];
    _gameOverLabel = [SKLabelNode labelNodeWithText:@"Game Over!"];
    _gameOverLabel.position = CGPointMake(0, _screen.size.height/2 - _screen.size.height/6.5 - _gameOverLabel.fontSize/2);
    [_screen addChild:_gameOverLabel];
    _scoreLabel = [SKLabelNode labelNodeWithText:[NSString stringWithFormat:@"High Score: %li", score]];
    _scoreLabel.position = CGPointMake(0, _screen.size.height/2 - _screen.size.height/3 - _gameOverLabel.fontSize/2);
    [_screen addChild:_scoreLabel];
    _restartGameButton = [SKLabelNode labelNodeWithText:@"Restart Game"];
    _restartGameButton.position = CGPointMake(0, -_screen.size.height/2 + _screen.size.height/3.5 + _gameOverLabel.fontSize/2);
    [_screen addChild:_restartGameButton];
    _mainMenuButton = [SKLabelNode labelNodeWithText:@"Return to Main Menu"];
    _mainMenuButton.position = CGPointMake(0, -_screen.size.height/2 + _screen.size.height/8 + _gameOverLabel.fontSize/2);
    [_screen addChild:_mainMenuButton];
    
    self.userInteractionEnabled = YES;
    [self addChild:_screen];
  }
  return self;
}


-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
  for (UITouch *touch in touches)
  {
    CGPoint touchLocation = [touch locationInNode:self];
    if ([self.restartGameButton containsPoint:touchLocation])
    {
      GKScene *scene = [GKScene sceneWithFileNamed:@"GameScene"];
      
      // Get the SKScene from the loaded GKScene
      GameScene *sceneNode = (GameScene *)scene.rootNode;
    
      // Copy gameplay related content over to the scene
      sceneNode.entities = [scene.entities mutableCopy];
      sceneNode.graphs = [scene.graphs mutableCopy];
      
      // Set the scale mode to scale to fit the window
  //    sceneNode.scaleMode = SKSceneScaleModeAspectFill;
      sceneNode.scaleMode = SKSceneScaleModeResizeFill;
      
      SKView *skView = self.targetScene.view;
      
      // Present the scene
      [skView presentScene:sceneNode];
      
      skView.showsFPS = YES;
      skView.showsNodeCount = YES;
    }
    if ([self.mainMenuButton containsPoint:touchLocation])
    {
      GKScene *scene = [GKScene sceneWithFileNamed:@"MainMenu"];
      
      // Get the SKScene from the loaded GKScene
      GameScene *sceneNode = (GameScene *)scene.rootNode;
    
      // Copy gameplay related content over to the scene
      sceneNode.entities = [scene.entities mutableCopy];
      sceneNode.graphs = [scene.graphs mutableCopy];
      
      // Set the scale mode to scale to fit the window
  //    sceneNode.scaleMode = SKSceneScaleModeAspectFill;
      sceneNode.scaleMode = SKSceneScaleModeResizeFill;
      
      SKView *skView = self.targetScene.view;
      
      // Present the scene
      [skView presentScene:sceneNode];
      
      skView.showsFPS = YES;
      skView.showsNodeCount = YES;
    }
  }
}


@end
