//
//  HealthBarNode.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-26.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface HealthBarNode : SKNode

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) SKSpriteNode *redBar;
@property (strong, nonatomic) SKSpriteNode *greenBar;

-(instancetype)initWithSize:(CGSize)size;
-(void)setHealthBar:(float)percentHealth;

@end
