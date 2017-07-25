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

@property (strong, nonatomic) SKSpriteNode *singlePlayerButton;

@end

@implementation MainMenu

-(void)didMoveToView:(SKView *)view {
    NSLog(@"Custom Class Running");
    
    self.singlePlayerButton = [[SKSpriteNode alloc] initWithColor:[UIColor whiteColor] size:CGSizeMake(150, 30)];
    [self addChild:self.singlePlayerButton];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    NSSet *buttonTouches = [event touchesForView:self.singlePlayerButton];
//    UITouch *buttonTouch = buttonTouches.anyObject;
  for (UITouch * touch in touches) {
    CGPoint location = [touch locationInNode:self];
    if ([self.singlePlayerButton containsPoint:location])
    {
      GKScene *scene = [GKScene sceneWithFileNamed:@"GameScene"];
      
      // Get the SKScene from the loaded GKScene
      GameScene *sceneNode = (GameScene *)scene.rootNode;
      
      // Copy gameplay related content over to the scene
//      sceneNode.entities = [scene.entities mutableCopy];
//      sceneNode.graphs = [scene.graphs mutableCopy];
      
      // Set the scale mode to scale to fit the window
      sceneNode.scaleMode = SKSceneScaleModeAspectFill;
      
      SKView *skView = (SKView *)self.view;
      
      // Present the scene
      [skView presentScene:sceneNode];
      
//      skView.showsFPS = YES;
//      skView.showsNodeCount = YES;
    }
  }
    
}

@end
