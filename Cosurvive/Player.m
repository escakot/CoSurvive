//
//  Player.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-21.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)init
{
  self = [super init];
  if (self) {
    self.size = CGSizeMake(60, 60);
    self.color = [UIColor redColor];
    self.position = CGPointMake(0.0, 0.0);
    
    self.renderComponent = [[RenderComponent alloc] init];
    [self addComponent:self.renderComponent];
    
    SKPhysicsBody *playerPhysics = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    PhysicsComponent *physicsComponent = [[PhysicsComponent alloc] initWithPhysicsBody:playerPhysics andPhysicsBitMask:[EntityPhysics player]];
    [self addComponent:physicsComponent];
    
    self.renderComponent.node.physicsBody = physicsComponent.physicsBody;
    
    AnimationComponent *animationComponent = [[AnimationComponent alloc] initWithSize:self.size andColor:self.color];
    [self.renderComponent.node addChild:animationComponent.sprite];
    
    self.agent = [[GKAgent2D alloc] init];
    self.agent.delegate = self;
    self.agent.position = (vector_float2){self.position.x, self.position.y};
  }
  return self;
}

-(void)agentDidUpdate:(GKAgent *)agent
{
  
}

-(void)agentWillUpdate:(GKAgent *)agent
{
  self.agent.position = (vector_float2){self.position.x, self.position.y};
}


@end
