//
//  GameOverNode.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-26.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameOverNode : SKNode

@property (strong, nonatomic) SKScene *targetScene;
@property (strong, nonatomic) SKSpriteNode *screen;
@property (strong, nonatomic) SKLabelNode *gameOverLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (strong, nonatomic) SKLabelNode *restartGameButton;
@property (strong, nonatomic) SKLabelNode *mainMenuButton;

-(instancetype)initWithScene:(SKScene*)scene withScore:(NSInteger)score;

@end
