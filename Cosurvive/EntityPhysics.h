//
//  EntityPhysics.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (uint32_t, PhysicsCategory) {
  noCategory = 0,
  playerCategory = 0b1,
  enemyCategory = 0b1 << 1,
  itemCategory = 0b1 << 2
};

typedef struct
{
  PhysicsCategory category;
  PhysicsCategory collision;
  PhysicsCategory contact;
} physicsBitMask;

@interface EntityPhysics : NSObject

+ (physicsBitMask) player;
+ (physicsBitMask) enemy;
+ (physicsBitMask) item;

@end
