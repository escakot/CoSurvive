//
//  HealthComponent.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-25.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "HealthComponent.h"

@implementation HealthComponent

-(instancetype)initWithHealth:(NSUInteger)hp andDefence:(NSUInteger)dp
{
  self = [super init];
  if (self)
  {
    _healthPoints = hp;
    _defencePoints = dp;
  }
  return self;
}


@end
