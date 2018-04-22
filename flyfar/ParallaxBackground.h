//
//  ParallaxBackground.h
//  flyfar
//
//  Created by 김혁 on 22/04/2018.
//  Copyright © 2018 KongjaStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface ParallaxBackground : NSObject

- (id)initWithParent:(SKScene*)scene files:(NSArray*)files hspeed:(NSArray*)hspeeds vfactor:(NSArray*)vfactor;
- (void)scrollBackground:(double)delta;

@property float vert_pos;
@end
