//
//  RenderComponent.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "RenderComponent.h"

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

@end
