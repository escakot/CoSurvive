//
//  EnemyAgentNode.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "EnemyAgentNode.h"

@interface EnemyAgentNode ()

@property SKShapeNode *triangleShape;

@end

@implementation EnemyAgentNode

- (instancetype)initWithScene:(SKScene*)scene radius:(float)radius position:(CGPoint)position color:(UIColor*)color
{
  self = [super init];
  
  if (self) {
    self.position = position;
    self.zPosition = 10;
    [scene addChild:self];
    
    // An agent to manage the movement of this node in a scene.
    _agent = [[GKAgent2D alloc] init];
    _agent.radius = radius;
    _agent.position = (vector_float2){position.x, position.y};
    _agent.delegate = self;
    _agent.maxSpeed = 150;
    _agent.maxAcceleration = 50;
    _agent.mass = 0.4;
    
    // A triangle to represent the agent's heading (rotation) in the agent simulation.
    CGPoint points[4];
    const static float triangleBackSideAngle = (135.0f / 360.0f) * (2 * M_PI);
    points[0] = CGPointMake(radius,0); // Tip.
    points[1] = CGPointMake(radius * cos(triangleBackSideAngle), radius * sin(triangleBackSideAngle)); // Back bottom.
    points[2] = CGPointMake(radius * cos(triangleBackSideAngle), -radius * sin(triangleBackSideAngle)); // Back top.
    points[3] = CGPointMake(radius, 0); // Back top.
    _triangleShape = [SKShapeNode shapeNodeWithPoints:points count:4];
    _triangleShape.lineWidth = 1.5;
    _triangleShape.zPosition = 1;
    _triangleShape.fillColor = color;
    [self addChild:_triangleShape];
    
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
  self.position = CGPointMake(agent.position.x, agent.position.y);
  self.zRotation = agent.rotation;
}

@end
