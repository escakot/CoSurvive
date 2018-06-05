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
@property (strong, nonatomic) PhysicsComponent *physicsComponent;

//@property (strong, nonatomic) NSMutableArray* agents;

- (instancetype)initWithColor:(UIColor*)color atPosition:(CGPoint)position withTarget:(GKAgent2D*)target withPhysics:(PhysicsBitMask)bitMask inScene:(GameScene*)scene;

@end
