//
//  PlayerView.m
//  Krazy TV
//
//  Created by Steve Yeom on 9/28/14.
//  Copyright (c) 2014 2nd Jobs. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(void)keyDown:(NSEvent*)event {
  switch( [event keyCode] ) {
    case 49:
      [self playPauseVideo];
      break;
    case 124:
    case 123:
      break;
    default:
      break;
  }
}

- (void)playPauseVideo{
  [_delegate playPauseVideo];
}

@end
