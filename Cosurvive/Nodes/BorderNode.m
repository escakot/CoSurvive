//
//  BorderNode.m
//  Cosurvive
//
//  Created by Errol Cheong on 2018-05-31.
//  Copyright © 2018 Errol Cheong. All rights reserved.
//

#import "BorderNode.h"

@implementation BorderNode

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        PhysicsBitMask physics = EntityPhysics.border;
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
        self.physicsBody.categoryBitMask = physics.category;
        self.physicsBody.collisionBitMask = physics.collision;
        self.physicsBody.contactTestBitMask = physics.contact;
        self.physicsBody.usesPreciseCollisionDetection = YES;
        self.physicsBody.pinned = YES;
        self.physicsBody.density = 10000;
        SKShapeNode* shape = [SKShapeNode shapeNodeWithRect:frame];
        
        [self addChild:shape];
    }
    return self;
}

@end
