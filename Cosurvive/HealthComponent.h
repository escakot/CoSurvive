//
//  HealthComponent.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-25.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface HealthComponent : GKComponent

@property (assign, nonatomic) NSUInteger healthPoints;
@property (assign, nonatomic) NSUInteger defencePoints;

-(instancetype)initWithHealth:(NSUInteger)hp andDefence:(NSUInteger)dp;

@end
