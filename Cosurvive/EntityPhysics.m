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
  player.collision = playerCategory;
  player.contact = enemyCategory | itemCategory;
  
  return player;
}

+ (physicsBitMask)item
{
  physicsBitMask item;
  item.category = itemCategory;
  item.collision = noCategory;
  item.contact = playerCategory;
  
  return item;
}

+ (physicsBitMask)redEnemy
{
  physicsBitMask redEnemy;
  redEnemy.category = redEnemyCategory | enemyCategory;
  redEnemy.collision = noCategory;
  redEnemy.contact = playerCategory | redBarrierCategory;
  
  return redEnemy;
}

+ (physicsBitMask)redBarrier
{
  physicsBitMask redBarrier;
  redBarrier.category = redBarrierCategory;
  redBarrier.collision = noCategory;
  redBarrier.contact = redEnemyCategory;
  
  return redBarrier;
}

+ (physicsBitMask)blueEnemy
{
  physicsBitMask blueEnemy;
  blueEnemy.category = blueEnemyCategory | enemyCategory;
  blueEnemy.collision = noCategory;
  blueEnemy.contact = playerCategory | blueBarrierCategory;
  
  return blueEnemy;
}

+ (physicsBitMask)blueBarrier
{
  physicsBitMask blueBarrier;
  blueBarrier.category = blueBarrierCategory;
  blueBarrier.collision = noCategory;
  blueBarrier.contact = blueEnemyCategory;
  
  return blueBarrier;
}

+ (physicsBitMask)greenEnemy
{
  physicsBitMask greenEnemy;
  greenEnemy.category = greenEnemyCategory | enemyCategory;
  greenEnemy.collision = noCategory;
  greenEnemy.contact = playerCategory | greenBarrierCategory;
  
  return greenEnemy;
}

+ (physicsBitMask)greenBarrier
{
  physicsBitMask greenBarrier;
  greenBarrier.category = greenBarrierCategory;
  greenBarrier.collision = noCategory;
  greenBarrier.contact = greenEnemyCategory;
  
  return greenBarrier;
}

+ (physicsBitMask)yellowEnemy
{
  physicsBitMask yellowEnemy;
  yellowEnemy.category = yellowEnemyCategory | enemyCategory;
  yellowEnemy.collision = noCategory;
  yellowEnemy.contact = playerCategory | yellowBarrierCategory;
  
  return yellowEnemy;
}

+ (physicsBitMask)yellowBarrier
{
  physicsBitMask yellowBarrier;
  yellowBarrier.category = yellowBarrierCategory;
  yellowBarrier.collision = noCategory;
  yellowBarrier.contact = yellowEnemyCategory;
  
  return yellowBarrier;
}

+ (physicsBitMask)orangeEnemy
{
  physicsBitMask orangeEnemy;
  orangeEnemy.category = orangeEnemyCategory | enemyCategory;
  orangeEnemy.collision = noCategory;
  orangeEnemy.contact = playerCategory | orangeBarrierCategory;
  
  return orangeEnemy;
}

+ (physicsBitMask)orangeBarrier
{
  physicsBitMask orangeBarrier;
  orangeBarrier.category = orangeBarrierCategory;
  orangeBarrier.collision = noCategory;
  orangeBarrier.contact = orangeEnemyCategory;
  
  return orangeBarrier;
}

+ (physicsBitMask)purpleEnemy
{
  physicsBitMask purpleEnemy;
  purpleEnemy.category = purpleEnemyCategory | enemyCategory;
  purpleEnemy.collision = noCategory;
  purpleEnemy.contact = playerCategory | purpleBarrierCategory;
  
  return purpleEnemy;
}

+ (physicsBitMask)purpleBarrier
{
  physicsBitMask purpleBarrier;
  purpleBarrier.category = purpleBarrierCategory;
  purpleBarrier.collision = noCategory;
  purpleBarrier.contact = purpleEnemyCategory;
  
  return purpleBarrier;
}

//+ (physicsBitMask)enemy
//{
//  physicsBitMask enemy;
//  enemy.category = enemyCategory;
//  enemy.collision = noCategory;
//  enemy.contact = playerCategory | barrierCategory;
//  
//  return enemy;
//}
//
//+ (physicsBitMask)barrier
//{
//  physicsBitMask barrier;
//  barrier.category = barrierCategory;
//  barrier.collision = noCategory;
//  barrier.contact = enemyCategory;
//  
//  return barrier;
//}

@end
