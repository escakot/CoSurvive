//
//  EntityPhysics.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (uint32_t, PhysicsCategory) {
  noCategory =              0,
  playerCategory =          0b1,
  borderCategory =          0b1 << 1,
  redEnemyCategory =        0b1 << 2,
  redBarrierCategory =      0b1 << 3,
  blueEnemyCategory =       0b1 << 4,
  blueBarrierCategory =     0b1 << 5,
  greenEnemyCategory =      0b1 << 6,
  greenBarrierCategory =    0b1 << 7,
  yellowEnemyCategory =     0b1 << 8,
  yellowBarrierCategory =   0b1 << 9,
  orangeEnemyCategory =     0b1 << 10,
  orangeBarrierCategory =   0b1 << 11,
  purpleEnemyCategory =     0b1 << 12,
  purpleBarrierCategory =   0b1 << 13,
  enemyCategory =           0b1 << 14
};

typedef struct
{
  PhysicsCategory category;
  PhysicsCategory collision;
  PhysicsCategory contact;
} PhysicsBitMask;

@interface EntityPhysics : NSObject

+ (PhysicsBitMask) player;
//+ (physicsBitMask) item;
+ (PhysicsBitMask) redEnemy;
+ (PhysicsBitMask) redBarrier;
+ (PhysicsBitMask) blueEnemy;
+ (PhysicsBitMask) blueBarrier;
+ (PhysicsBitMask) greenEnemy;
+ (PhysicsBitMask) greenBarrier;
+ (PhysicsBitMask) yellowEnemy;
+ (PhysicsBitMask) yellowBarrier;
+ (PhysicsBitMask) orangeEnemy;
+ (PhysicsBitMask) orangeBarrier;
+ (PhysicsBitMask) purpleEnemy;
+ (PhysicsBitMask) purpleBarrier;
+ (PhysicsBitMask) border;

@end
