//
//  ToughEnemy.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-26.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "ToughEnemy.h"

@implementation ToughEnemy

- (instancetype)initWithColor:(UIColor*)color atPosition:(CGPoint)position withTarget:(GKAgent2D*)target withPhysics:(PhysicsBitMask)bitMask inScene:(GameScene*)scene
{
  self = [super init];
  if (self)
  {
    self.size = CGSizeMake(25, 25);
    self.color = color;
    self.position = position;
    self.speed = 65.0;
    self.mass = 0.1;
    self.acceleration = 100.0;
    self.radius = 12.5;
    self.target = target;
    self.scene = scene;
    
    self.renderComponent = [[RenderComponent alloc] init];
    [self addComponent:self.renderComponent];
    
    SKPhysicsBody *playerPhysics = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    PhysicsComponent *physicsComponent = [[PhysicsComponent alloc] initWithPhysicsBody:playerPhysics andPhysicsBitMask:bitMask];
    [self addComponent:physicsComponent];
    
    self.renderComponent.node.physicsBody = physicsComponent.physicsBody;
    
    AnimationComponent *animationComponent = [[AnimationComponent alloc] initWithSize:self.size andColor:self.color withShape:0];
    [self.renderComponent.node addChild:animationComponent.shape];
    
    self.statsComponent = [[StatsComponent alloc] initWithHealth:40 andDefence:10 andAttack:15];
    [self addComponent:self.statsComponent];
    
    //GKAgent2D
    self.agent = [[GKAgent2D alloc] init];
    self.agent.delegate = self;
    self.agent.maxSpeed = self.speed;
    self.agent.mass = self.mass;
    self.agent.maxAcceleration = self.acceleration;
    self.agent.position = (vector_float2){position.x, position.y};
    self.agent.behavior = [[GKBehavior alloc] init];
    GKGoal *seekGoal = [GKGoal goalToSeekAgent:target];
  	GKGoal *separateGoal = [GKGoal goalToSeparateFromAgents:@[self.agent] maxDistance:100 maxAngle:M_PI*2];
    [self.agent.behavior setWeight:1.0 forGoal:seekGoal];
    [self.agent.behavior setWeight:100.0 forGoal:separateGoal];
    //    float angle = atan2(target.position.x - position.x, target.position.y - position.y) / M_PI * 180;
    //    float corrected_angle = (angle - 90) * -1;
    //    corrected_angle = corrected_angle < 0 ? corrected_angle + 360 : corrected_angle;
    //    NSLog(@"%f", corrected_angle);
    //    self.agent.rotation = corrected_angle * M_PI / 180;
    
    [scene addChild:self.renderComponent.node];
    [scene.agentSystem addComponent:self.agent];
  }
  return self;
}

#pragma mark - GKAgentDelegate

- (void)agentWillUpdate:(nonnull GKAgent *)agent {
  // All changes to agents in this app are driven by the agent system, so
  // there's no other changes to pass into the agent system in this method.
}

- (void)agentDidUpdate:(nonnull GKAgent2D *)agent {
  // Agent and sprite use the same coordinate system (in this app),
  // so just convert vector_float2 position to CGPoint.
  CGFloat width = self.scene.size.width/2 + self.size.width;
  CGFloat height = self.scene.size.height/2 + self.size.height;
  CGFloat diffX = self.target.position.x - agent.position.x;
  CGFloat diffY = self.target.position.y - agent.position.y;
  if (diffX > width || diffX < -width || diffY > height || diffY < -height)
  {
    self.renderComponent.node.hidden = YES;
  } else {
    self.renderComponent.node.hidden = NO;
  }
  if (diffX > width*2 || diffX < -width*2 || diffY > width*2 || diffY < -width*2)
  {
    self.isDead = YES;
  }
  
//  NSMutableArray *agents = [[NSMutableArray alloc] init];
//  for (ToughEnemy *enemy in self.agents) {
//    [agents addObject:enemy.agent];
//  }
//  GKGoal *separateGoal = [GKGoal goalToSeparateFromAgents:agents maxDistance:100 maxAngle:M_PI*2];
//  [self.agent.behavior setWeight:50.0 forGoal:separateGoal];
  self.renderComponent.node.position = CGPointMake(agent.position.x, agent.position.y);
  //  self.renderComponent.node.zRotation = agent.rotation;
}

@end
