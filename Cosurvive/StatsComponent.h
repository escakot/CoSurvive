//
//  StatsComponent.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-25.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class Unit;
@interface StatsComponent : GKComponent

@property (assign, nonatomic) NSInteger maxHealthPoints;
@property (assign, nonatomic) NSInteger healthPoints;
@property (assign, nonatomic) NSInteger defencePoints;
@property (assign, nonatomic) NSInteger attackPoints;

-(instancetype)initWithHealth:(NSInteger)hp andDefence:(NSInteger)dp andAttack:(NSInteger)ap;

-(void)wasAttacked:(Unit*)unit;

@end
