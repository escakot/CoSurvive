//
//  RedState.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-26.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@class BarrierComponent;
@interface RedState : GKState

@property (strong, nonatomic) BarrierComponent *barrierComponent;

- (instancetype)initWithComponent:(BarrierComponent*)barrier;

@end
