//
//  RenderComponent.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "RenderComponent.h"
#import "Unit.h"

@implementation RenderComponent

- (instancetype)init
{
  self = [super init];
  if (self) {
    _node = [[SKNode alloc] init];
  }
  return self;
}

-(void)didAddToEntity
{
  self.node.entity = self.entity;
}

-(void)willRemoveFromEntity
{
  self.node.entity = nil;
}

-(void)updateWithDeltaTime:(NSTimeInterval)seconds
{
  Unit *unit = (Unit*)self.entity;
  float speed = unit.speed * seconds * 60;
  CGPoint location = self.node.position;
  CGPoint newLocation = CGPointMake(location.x + (unit.xVelocity * speed), location.y + (unit.yVelocity * speed));
  self.node.position = newLocation;
}

@end
