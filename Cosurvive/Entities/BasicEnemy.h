//
//  BasicEnemy.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "Unit.h"

@interface BasicEnemy : Unit 

@property (strong, nonatomic) AnimationComponent *animationComponent;
@property (strong, nonatomic) PhysicsComponent *physicsComponent;

- (instancetype)initWithColor:(UIColor*)color atPosition:(CGPoint)position withTarget:(GKAgent2D*)target withPhysics:(physicsBitMask)bitMask inScene:(GameScene*)scene;

@end
