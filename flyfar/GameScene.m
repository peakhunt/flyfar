//
//  GameScene.m
//  flyfar
//
//  Created by 김혁 on 22/04/2018.
//  Copyright © 2018 KongjaStudio. All rights reserved.
//

#import "GameScene.h"
#import "ParallaxBackground.h"

@implementation GameScene {
  SKShapeNode     *_spinnyNode;
  SKLabelNode     *_label;

  CFTimeInterval  _last_time;
  double          _background_vert_pos;
  double          _vertical_speed;
  
  ParallaxBackground  *_parallax_back;
}

- (void)didMoveToView:(SKView *)view {
  [self setupBackground];

  // Get label node from scene and store it for use later
  _label = (SKLabelNode *)[self childNodeWithName:@"//helloLabel"];
  
  _label.alpha = 0.0;
  [_label runAction:[SKAction fadeInWithDuration:2.0]];
  
  CGFloat w = (self.size.width + self.size.height) * 0.05;
  
  // Create shape node to use during mouse interaction
  _spinnyNode = [SKShapeNode shapeNodeWithRectOfSize:CGSizeMake(w, w) cornerRadius:w * 0.3];
  _spinnyNode.lineWidth = 2.5;
  
  [_spinnyNode runAction:[SKAction repeatActionForever:[SKAction rotateByAngle:M_PI duration:1]]];
  [_spinnyNode runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:0.5],
                                              [SKAction fadeOutWithDuration:0.5],
                                              [SKAction removeFromParent],
                                              ]]];
  
  _last_time = 0;
  _background_vert_pos = 0;
  _vertical_speed = 0;
}

- (void)setupBackground {
  NSArray*    back_files = @[@"layer_08_1920x1080.png",
                             @"layer_07_1920x1080.png",
                             @"layer_06_1920x1080.png",
                             @"layer_05_1920x1080.png",
                             @"layer_04_1920x1080.png",
                             @"layer_03_1920x1080.png",
                             @"layer_02_1920x1080.png",
                             @"layer_01_1920x1080.png",
                             ];
  
  NSArray* back_speeds = @[
                           @10.0f,
                           @0.0f,
                           @35,
                           @70,
                           @90,
                           @110,
                           @130,
                           @150,
                           ];
  
  NSArray* back_vfactors = @[
                             @0,
                             @0,
                             @1,
                             @1,
                             @1,
                             @1,
                             @1,
                             @1,
                             ];
  
  _parallax_back = [[ParallaxBackground alloc] initWithParent:self
                                                        files:back_files
                                                       hspeed:back_speeds
                                                      vfactor:back_vfactors];
}

- (void)touchDownAtPoint:(CGPoint)pos {
  SKShapeNode *n = [_spinnyNode copy];
  n.position = pos;
  n.strokeColor = [SKColor greenColor];
  [self addChild:n];
}

- (void)touchMovedToPoint:(CGPoint)pos {
  SKShapeNode *n = [_spinnyNode copy];
  n.position = pos;
  n.strokeColor = [SKColor blueColor];
  [self addChild:n];
}

- (void)touchUpAtPoint:(CGPoint)pos {
  SKShapeNode *n = [_spinnyNode copy];
  n.position = pos;
  n.strokeColor = [SKColor redColor];
  [self addChild:n];
}

- (void)keyDown:(NSEvent *)theEvent {
  switch (theEvent.keyCode) {
    case 0x31 /* SPACE */:
      // Run 'Pulse' action from 'Actions.sks'
      [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
      break;
      
    case 0x7E:  //  up arrow
      _vertical_speed = 1.0f;
      break;
      
    case 0x7D:  //  down arrow
      _vertical_speed = -1.0f;
      break;
      
    case 0x7B:  //  left arrow
      break;
      
    case 0x7C:  //  right arrow
      break;
      
    default:
      NSLog(@"keyDown:'%@' keyCode: 0x%02X", theEvent.characters, theEvent.keyCode);
      break;
  }
}

- (void)keyUp:(NSEvent *)theEvent {
  switch (theEvent.keyCode) {
    case 0x7E:  //  up arrow
      _vertical_speed = 0.0f;
      break;
      
    case 0x7D:  //  down arrow
      _vertical_speed = 0.0f;
      
      break;
    case 0x7B:  //  left arrow
      break;
      
    case 0x7C:  //  right arrow
      break;
      
    default:
      NSLog(@"keyUp:'%@' keyCode: 0x%02X", theEvent.characters, theEvent.keyCode);
  }
}

- (void)mouseDown:(NSEvent *)theEvent {
  [self touchDownAtPoint:[theEvent locationInNode:self]];
}
- (void)mouseDragged:(NSEvent *)theEvent {
  [self touchMovedToPoint:[theEvent locationInNode:self]];
}
- (void)mouseUp:(NSEvent *)theEvent {
  [self touchUpAtPoint:[theEvent locationInNode:self]];
}

- (double)updateDelta:(CFTimeInterval)current {
  double delta = 0;
  
  if(_last_time != 0) {
    delta = current - _last_time;
  }
  _last_time = current;
  
  return delta;
}

-(void)update:(CFTimeInterval)currentTime {
  double delta = 0;
  
  delta = [self updateDelta:currentTime];
  
  _background_vert_pos = _background_vert_pos - _vertical_speed * 200 * delta;
  if(_background_vert_pos > 0)
  {
    _background_vert_pos = 0;
  }
  
  [_parallax_back setVert_pos:_background_vert_pos];
  [_parallax_back scrollBackground:delta];
}

@end
