//
//  Player.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-21.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "Unit.h"
#import "BarrierComponent.h"

@interface Player : Unit

@property (strong, nonatomic) AnimationComponent *animationComponent;
@property (strong, nonatomic) PhysicsComponent *physicsComponent;
@property (strong, nonatomic) BarrierComponent *barrierComponent;

- (instancetype)initWithScene:(SKScene*)scene andColor:(UIColor*)color withShape:(NSInteger)shape;

@end
