//
//  HealingEnemy.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-28.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "HealingEnemy.h"

@interface HealingEnemy ()

@property (strong, nonatomic) GKGoal *wanderGoal;
@property (strong, nonatomic) GKGoal *fleeGoal;
@property (strong, nonatomic) GKGoal *stopGoal;
@property (assign, nonatomic) BOOL isFleeing;

@end

@implementation HealingEnemy

- (instancetype)initWithColor:(UIColor*)color atPosition:(CGPoint)position withTarget:(GKAgent2D*)target withPhysics:(physicsBitMask)bitMask inScene:(GameScene*)scene
{
  self = [super init];
  if (self)
  {
    self.size = CGSizeMake(25, 25);
    self.color = color;
    self.position = position;
    self.speed = 180.0;
    self.mass = 0.1;
    self.acceleration = 300.0;
    self.target = target;
    self.scene = scene;
    
    self.renderComponent = [[RenderComponent alloc] init];
    [self addComponent:self.renderComponent];
    
    SKPhysicsBody *playerPhysics = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    PhysicsComponent *physicsComponent = [[PhysicsComponent alloc] initWithPhysicsBody:playerPhysics andPhysicsBitMask:bitMask];
    [self addComponent:physicsComponent];
    
    self.renderComponent.node.physicsBody = physicsComponent.physicsBody;
    
    self.statsComponent = [[StatsComponent alloc] initWithHealth:20 andDefence:10 andAttack:-15];
    [self addComponent:self.statsComponent];
    
    //Drawing the shape of Basic Enemy
    CGPoint points[13];
    CGFloat radius = self.size.width/2;
    CGFloat thickness = self.size.width/5;
    points[0] = CGPointMake(-thickness,radius);
    points[1] = CGPointMake(thickness,radius);
    points[2] = CGPointMake(thickness,thickness);
    points[3] = CGPointMake(radius,thickness);
    points[4] = CGPointMake(radius,-thickness);
    points[5] = CGPointMake(thickness,-thickness);
    points[6] = CGPointMake(thickness,-radius);
    points[7] = CGPointMake(-thickness,-radius);
    points[8] = CGPointMake(-thickness,-thickness);
    points[9] = CGPointMake(-radius,-thickness);
    points[10] = CGPointMake(-radius,thickness);
    points[11] = CGPointMake(-thickness,thickness);
    points[12] = CGPointMake(-thickness,radius);
    self.shape = [SKShapeNode shapeNodeWithPoints:points count:13];
    self.shape.lineWidth = 1.5;
    self.shape.zPosition = 1;
    self.shape.fillColor = color;
    [self.renderComponent.node addChild:self.shape];
//    [scene.agentSystem addComponent:self.agent];
    
    //GKAgent2D
    self.agent = [[GKAgent2D alloc] init];
    self.agent.delegate = self;
    self.agent.maxSpeed = self.speed;
    self.agent.mass = self.mass;
    self.agent.maxAcceleration = self.acceleration;
    self.agent.position = (vector_float2){position.x, position.y};
    self.agent.behavior = [[GKBehavior alloc] init];
    self.fleeGoal = [GKGoal goalToFleeAgent:target];
    self.stopGoal = [GKGoal goalToReachTargetSpeed:0];
    self.wanderGoal = [GKGoal goalToWander:self.speed];
//    [self.agent.behavior setWeight:1.0 forGoal:self.wanderGoal];
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
  if (diffX > width/2 || diffX < -width/2 || diffY > width/2 || diffY < -width/2)
  {
    if (!self.isFleeing)
    {
      [agent.behavior setWeight:0 forGoal:self.fleeGoal];
      [agent.behavior setWeight:1 forGoal:self.stopGoal];
      [agent.behavior setWeight:100 forGoal:self.wanderGoal];
      self.isFleeing = YES;
    }
  } else {
    if (self.isFleeing)
    {
      [agent.behavior setWeight:0 forGoal:self.stopGoal];
      [agent.behavior setWeight:0 forGoal:self.wanderGoal];
      [agent.behavior setWeight:100000 forGoal:self.fleeGoal];
      self.isFleeing = NO;
    }
  }
  if (diffX > width*2 || diffX < -width*2 || diffY > width*2 || diffY < -width*2)
  {
    self.isDead = YES;
  }
  
//  GKGoal *separateGoal = [GKGoal goalToSeparateFromAgents:self.agents maxDistance:self.size.width maxAngle:0];
//  [self.agent.behavior setWeight:50.0 forGoal:separateGoal];
  self.renderComponent.node.position = CGPointMake(agent.position.x, agent.position.y);
    self.renderComponent.node.zRotation = agent.rotation;
}

@end
