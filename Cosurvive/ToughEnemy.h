//
//  ToughEnemy.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-26.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "Unit.h"

@interface ToughEnemy : Unit

@property (strong, nonatomic) AnimationComponent *animationComponent;
@property (strong, nonatomic) HealthComponent *healthComponent;
@property (strong, nonatomic) PhysicsComponent *physicsComponent;


- (instancetype)initWithColor:(UIColor*)color atPosition:(CGPoint)position withTarget:(GKAgent2D*)target withPhysics:(physicsBitMask)bitMask inScene:(GameScene*)scene;

@end
