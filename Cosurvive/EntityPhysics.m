//
//  EntityPhysics.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "EntityPhysics.h"

@implementation EntityPhysics

+ (physicsBitMask)player
{
  physicsBitMask player;
  player.category = playerCategory;
  player.collision = noCategory;
  player.contact = enemyCategory | itemCategory;
  
  return player;
}

+ (physicsBitMask)enemy
{
  physicsBitMask enemy;
  enemy.category = enemyCategory;
  enemy.collision = noCategory;
  enemy.contact = playerCategory | itemCategory;
  
  return enemy;
}

+ (physicsBitMask)item
{
  physicsBitMask item;
  item.category = itemCategory;
  item.collision = noCategory;
  item.contact = playerCategory;
  
  return item;
}


@end
