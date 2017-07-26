//
//  Player.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-21.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype)initWithScene:(SKScene*)scene andColor:(UIColor*)color
{
  self = [super init];
  if (self) {
    self.isDead = NO;
    self.size = CGSizeMake(50, 50);
    self.color = color;
    self.position = CGPointMake(0.0, 0.0);
    self.speed = 5.0;
    
    self.renderComponent = [[RenderComponent alloc] init];
    [self addComponent:self.renderComponent];
    
    SKPhysicsBody *playerPhysics = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsComponent = [[PhysicsComponent alloc] initWithPhysicsBody:playerPhysics andPhysicsBitMask:[EntityPhysics player]];
    [self addComponent:self.physicsComponent];
    
    self.renderComponent.node.physicsBody = self.physicsComponent.physicsBody;
    
    self.animationComponent = [[AnimationComponent alloc] initWithSize:self.size andColor:self.color];
    [self.renderComponent.node addChild:self.animationComponent.sprite];
    
    self.healthComponent = [[HealthComponent alloc] initWithHealth:100 andDefence:5];
    [self addComponent:self.healthComponent];
    
    self.barrierComponent = [[BarrierComponent alloc] initWithPlayer:self withColor:color Size:CGSizeMake(self.size.width*2, self.size.height*2)];
    [self addComponent:self.barrierComponent];
    
    
    self.agent = [[GKAgent2D alloc] init];
    self.agent.delegate = self;
    self.agent.position = (vector_float2){self.position.x, self.position.y};
    
    [scene addChild:self.renderComponent.node];
  }
  return self;
}

-(void)agentDidUpdate:(GKAgent *)agent
{
  
}

-(void)agentWillUpdate:(GKAgent *)agent
{
  self.agent.position = (vector_float2){self.renderComponent.node.position.x, self.renderComponent.node.position.y};
}

-(void)updateWithDeltaTime:(NSTimeInterval)seconds
{
  if (self.healthComponent.healthPoints <= 0)
  {
    self.isDead = YES;
    [self.renderComponent.node removeFromParent];
  } else {
    CGPoint location = self.renderComponent.node.position;
    CGPoint newLocation = CGPointMake(location.x + (self.xVelocity * self.speed), location.y + (self.yVelocity * self.speed));
    self.renderComponent.node.position = newLocation;
  }
  
}


@end
