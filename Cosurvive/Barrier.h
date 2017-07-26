//
//  Barrier.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-25.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "RenderComponent.h"
#import "AnimationComponent.h"
#import "PhysicsComponent.h"

@interface Barrier : GKEntity

@property (assign, nonatomic) CGSize size;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) SKShapeNode *shape;

@property (strong, nonatomic) AnimationComponent *animationComponent;
@property (strong, nonatomic) RenderComponent *renderComponent;
@property (strong, nonatomic) PhysicsComponent *physicsComponent;

- (instancetype)initBarrierWithSize:(CGSize)size andColor:(UIColor*)color;

@end
