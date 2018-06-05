//
//  BasicEnemy.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "BasicEnemy.h"

@implementation BasicEnemy

- (instancetype)initWithColor:(UIColor*)color atPosition:(CGPoint)position withTarget:(GKAgent2D*)target withPhysics:(PhysicsBitMask)bitMask inScene:(GameScene*)scene
{
  self = [super init];
  if (self) {
    self.size = CGSizeMake(25, 25);
    self.color = color;
    self.position = position;
    self.speed = 150.0;
    self.mass = 0.4;
    self.acceleration = 50.0;
    self.radius = 12.5;
    self.target = target;
    self.scene = scene;
    
    self.renderComponent = [[RenderComponent alloc] init];
    [self addComponent:self.renderComponent];
    
    SKPhysicsBody *playerPhysics = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    PhysicsComponent *physicsComponent = [[PhysicsComponent alloc] initWithPhysicsBody:playerPhysics andPhysicsBitMask:bitMask];
    [self addComponent:physicsComponent];
    
    self.renderComponent.node.physicsBody = physicsComponent.physicsBody;
    
    self.statsComponent = [[StatsComponent alloc] initWithHealth:15 andDefence:0 andAttack:10];
    [self addComponent:self.statsComponent];
    
    //GKAgent2D
    self.agent = [[GKAgent2D alloc] init];
    self.agent.delegate = self;
    self.agent.maxSpeed = self.speed;
    self.agent.mass = self.mass;
    self.agent.maxAcceleration = self.acceleration;
    self.agent.position = (vector_float2){position.x, position.y};
    self.agent.behavior = [[GKBehavior alloc] init];
    GKGoal *goal = [GKGoal goalToSeekAgent:target];
    [self.agent.behavior setWeight:1.0 forGoal:goal];
    float angle = atan2(target.position.x - position.x, target.position.y - position.y) / M_PI * 180;
    float corrected_angle = (angle - 90) * -1;
    corrected_angle = corrected_angle < 0 ? corrected_angle + 360 : corrected_angle;
//    NSLog(@"%f", corrected_angle);
    self.agent.rotation = corrected_angle * M_PI / 180;
   
    //Drawing the shape of Basic Enemy
    CGPoint points[4];
    const static float triangleBackSideAngle = (135.0f / 360.0f) * (2 * M_PI);
    points[0] = CGPointMake(self.radius,0); // Tip.
    points[1] = CGPointMake(self.radius * cos(triangleBackSideAngle), self.radius * sin(triangleBackSideAngle)); // Back bottom.
    points[2] = CGPointMake(self.radius * cos(triangleBackSideAngle), -self.radius * sin(triangleBackSideAngle)); // Back top.
    points[3] = CGPointMake(self.radius, 0); // Back top.
    self.shape = [SKShapeNode shapeNodeWithPoints:points count:4];
    self.shape.lineWidth = 1.5;
    self.shape.zPosition = 1;
    self.shape.fillColor = color;
    [self.renderComponent.node addChild:self.shape];
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
  
  self.renderComponent.node.position = CGPointMake(agent.position.x, agent.position.y);
  self.renderComponent.node.zRotation = agent.rotation;
}

@end

