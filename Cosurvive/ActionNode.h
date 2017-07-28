//
//  ActionNode.h
//  Cosurvive
//
//  Created by Errol Cheong on 2017-07-27.
//  Copyright © 2017 Errol Cheong. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol ActionButtonDelegate <NSObject>

@optional
-(void)performAction:(NSString*)identifier;

@end

@interface ActionNode : SKNode 

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) SKShapeNode *button;

@property (weak, nonatomic) id <ActionButtonDelegate> delegate;

- (instancetype)initWithSize:(CGFloat)radius withIdentifier:(NSString*)identifier;

@end
