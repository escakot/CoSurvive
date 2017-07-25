//
//  EnemyAgentNode.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>

@interface EnemyAgentNode : SKNode <GKAgentDelegate>


@property (readonly) GKAgent2D *agent;

-(instancetype)initWithScene:(SKScene*)scene radius:(float)radius position:(CGPoint)position color:(UIColor*)color;

@end
