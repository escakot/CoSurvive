//
//  HealthComponent.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-25.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "StatsComponent.h"
#import "Unit.h"

@implementation StatsComponent

-(instancetype)initWithHealth:(NSInteger)hp andDefence:(NSInteger)dp andAttack:(NSInteger)ap
{
  self = [super init];
  if (self)
  {
    _maxHealthPoints = hp;
    _healthPoints = hp;
    _defencePoints = dp;
    _attackPoints = ap;
  }
  return self;
}

-(void)wasAttacked:(Unit *)unit
{
  if (unit.statsComponent.attackPoints < 0)
  {
    self.healthPoints -= unit.statsComponent.attackPoints;
    self.healthPoints = self.healthPoints > self.maxHealthPoints ? self.maxHealthPoints : self.healthPoints;
  } else {
    self.healthPoints -= unit.statsComponent.attackPoints - self.defencePoints;
  }
}

-(BOOL)isKilled
{
  Unit *unit = (Unit*)self.entity;
  if (self.healthPoints <= 0)
  {
    [unit.renderComponent.node removeFromParent];
    return YES;
  }
  return NO;
}

@end
