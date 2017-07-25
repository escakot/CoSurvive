//
//  PhysicsComponent.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "PhysicsComponent.h"


@implementation PhysicsComponent

- (instancetype)initWithPhysicsBody:(SKPhysicsBody*)physicsBody andPhysicsBitMask:(physicsBitMask)physicsBitMask
{
  self = [super init];
  if (self) {
    _physicsBody = physicsBody;
    _physicsBody.categoryBitMask = physicsBitMask.category;
    _physicsBody.collisionBitMask = physicsBitMask.collision;
    _physicsBody.contactTestBitMask = physicsBitMask.contact;
  }
  return self;
}

@end
