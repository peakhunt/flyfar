//
//  ParallaxBackground.m
//  flyfar
//
//  Created by 김혁 on 22/04/2018.
//  Copyright © 2018 KongjaStudio. All rights reserved.
//

#import "ParallaxBackground.h"

@implementation ParallaxBackground {
  NSArray*    _background_hspeed;
  NSArray*    _background_vfactor;
  
  NSUInteger          _num_layers;
  NSMutableArray*     _even_layers;
  NSMutableArray*     _odd_layers;
  SKScene*            _scene;
}

- (id)init {
  self = [super init];
  
  return self;
}

- (id)initWithParent:(SKScene*)scene files:(NSArray*)files hspeed:(NSArray*)hspeeds vfactor:(NSArray*)vfactor {
  self = [self init];
  
  _scene = scene;
  
  _background_hspeed  = [NSArray arrayWithArray:hspeeds];
  _background_vfactor = [NSArray arrayWithArray:vfactor];
  
  _num_layers = [files count];
  _vert_pos =   0;

  [self setupBackgroundLayers:files];
  return self;
}

- (void)setupBackgroundLayers:(NSArray*)bg_files {
  SKSpriteNode  *even, *odd;
  
  _even_layers  = [NSMutableArray array];
  _odd_layers   = [NSMutableArray array];
  
  for(NSString* file in bg_files)
  {
    even = [SKSpriteNode spriteNodeWithImageNamed:file];
    [even scaleToSize:_scene.size];
    [even setZPosition:-1];
    [even setPosition:CGPointMake(0,0)];
    [_even_layers addObject:even];
    [_scene addChild:even];
    
    odd = [SKSpriteNode spriteNodeWithImageNamed:file];
    [odd scaleToSize:_scene.size];
    [odd setZPosition:-1];
    [odd setPosition:CGPointMake(_scene.size.width, 0)];
    [_odd_layers addObject:odd];
    [_scene addChild:odd];
  }
}

- (void)scrollBackground:(double)delta {
  SKSpriteNode    *even, *odd;
  CGFloat         ex, ox, vpos;
  
  for(int i = 0; i < _num_layers; i++) {
    even  = _even_layers[i];
    odd   = _odd_layers[i];

    ex = [even position].x;
    ox = [odd position].x;
    
    ex -= ([_background_hspeed[i] doubleValue] * delta);
    ox -= ([_background_hspeed[i] doubleValue] * delta);
    
    vpos = ([_background_vfactor[i] doubleValue] * self.vert_pos);
    
    if(ex < -_scene.size.width)
    {
      ex = 0.0f;
      ox = _scene.size.width;
    }
    
    [even setPosition:CGPointMake(ex, vpos)];
    [odd setPosition:CGPointMake(ox,  vpos)];
  }
}

@end
