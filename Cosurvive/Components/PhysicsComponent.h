//
//  PhysicsComponent.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>
#import "EntityPhysics.h"

@interface PhysicsComponent : GKComponent

@property (strong, nonatomic) SKPhysicsBody *physicsBody;
- (instancetype)initWithPhysicsBody:(SKPhysicsBody*)physicsBody andPhysicsBitMask:(PhysicsBitMask)physicsBitMask;

@end
