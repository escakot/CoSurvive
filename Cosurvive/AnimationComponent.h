//
//  AnimationComponent.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-24.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <GameplayKit/GameplayKit.h>

@interface AnimationComponent : GKComponent

@property (strong, nonatomic) SKSpriteNode *sprite;
@property (strong, nonatomic) SKSpriteNode *barrier;

-(instancetype)initWithSize:(CGSize)size andColor:(UIColor *)color;

@end
