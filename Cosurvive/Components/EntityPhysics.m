//
//  EntityPhysics.m
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import "EntityPhysics.h"

@implementation EntityPhysics

+ (PhysicsBitMask)player
{
  PhysicsBitMask player;
  player.category = playerCategory;
  player.collision = playerCategory | borderCategory;
  player.contact = enemyCategory;
  
  return player;
}

//+ (physicsBitMask)item
//{
//  physicsBitMask item;
//  item.category = itemCategory;
//  item.collision = noCategory;
//  item.contact = playerCategory;
//
//  return item;
//}

+ (PhysicsBitMask)redEnemy
{
  PhysicsBitMask redEnemy;
  redEnemy.category = redEnemyCategory | enemyCategory;
  redEnemy.collision = noCategory;
  redEnemy.contact = playerCategory | redBarrierCategory;
  
  return redEnemy;
}

+ (PhysicsBitMask)redBarrier
{
  PhysicsBitMask redBarrier;
  redBarrier.category = redBarrierCategory;
  redBarrier.collision = noCategory;
  redBarrier.contact = redEnemyCategory;
  
  return redBarrier;
}

+ (PhysicsBitMask)blueEnemy
{
  PhysicsBitMask blueEnemy;
  blueEnemy.category = blueEnemyCategory | enemyCategory;
  blueEnemy.collision = noCategory;
  blueEnemy.contact = playerCategory | blueBarrierCategory;
  
  return blueEnemy;
}

+ (PhysicsBitMask)blueBarrier
{
  PhysicsBitMask blueBarrier;
  blueBarrier.category = blueBarrierCategory;
  blueBarrier.collision = noCategory;
  blueBarrier.contact = blueEnemyCategory;
  
  return blueBarrier;
}

+ (PhysicsBitMask)greenEnemy
{
  PhysicsBitMask greenEnemy;
  greenEnemy.category = greenEnemyCategory | enemyCategory;
  greenEnemy.collision = noCategory;
  greenEnemy.contact = playerCategory | greenBarrierCategory;
  
  return greenEnemy;
}

+ (PhysicsBitMask)greenBarrier
{
  PhysicsBitMask greenBarrier;
  greenBarrier.category = greenBarrierCategory;
  greenBarrier.collision = noCategory;
  greenBarrier.contact = greenEnemyCategory;
  
  return greenBarrier;
}

+ (PhysicsBitMask)yellowEnemy
{
  PhysicsBitMask yellowEnemy;
  yellowEnemy.category = yellowEnemyCategory | enemyCategory;
  yellowEnemy.collision = noCategory;
  yellowEnemy.contact = playerCategory | yellowBarrierCategory;
  
  return yellowEnemy;
}

+ (PhysicsBitMask)yellowBarrier
{
  PhysicsBitMask yellowBarrier;
  yellowBarrier.category = yellowBarrierCategory;
  yellowBarrier.collision = noCategory;
  yellowBarrier.contact = yellowEnemyCategory;
  
  return yellowBarrier;
}

+ (PhysicsBitMask)orangeEnemy
{
  PhysicsBitMask orangeEnemy;
  orangeEnemy.category = orangeEnemyCategory | enemyCategory;
  orangeEnemy.collision = noCategory;
  orangeEnemy.contact = playerCategory | orangeBarrierCategory;
  
  return orangeEnemy;
}

+ (PhysicsBitMask)orangeBarrier
{
  PhysicsBitMask orangeBarrier;
  orangeBarrier.category = orangeBarrierCategory;
  orangeBarrier.collision = noCategory;
  orangeBarrier.contact = orangeEnemyCategory;
  
  return orangeBarrier;
}

+ (PhysicsBitMask)purpleEnemy
{
  PhysicsBitMask purpleEnemy;
  purpleEnemy.category = purpleEnemyCategory | enemyCategory;
  purpleEnemy.collision = noCategory;
  purpleEnemy.contact = playerCategory | purpleBarrierCategory;
  
  return purpleEnemy;
}

+ (PhysicsBitMask)purpleBarrier
{
  PhysicsBitMask purpleBarrier;
  purpleBarrier.category = purpleBarrierCategory;
  purpleBarrier.collision = noCategory;
  purpleBarrier.contact = purpleEnemyCategory;
  
  return purpleBarrier;
}

+ (PhysicsBitMask)border {
    PhysicsBitMask border;
    border.category = borderCategory;
    border.collision = playerCategory | redEnemyCategory | blueEnemyCategory | greenEnemyCategory | yellowEnemyCategory | orangeEnemyCategory | purpleEnemyCategory;
    border.contact = noCategory;
    
    return border;
}

@end
