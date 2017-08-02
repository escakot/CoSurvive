//
//  PurpleState.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-27.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class BarrierComponent;
@interface PurpleState : GKState

@property (strong, nonatomic) BarrierComponent *barrierComponent;

- (instancetype)initWithComponent:(BarrierComponent*)barrier;

@end
