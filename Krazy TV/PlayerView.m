//
//  PlayerView.m
//  Krazy TV
//
//  Created by Steve Yeom on 9/28/14.
//  Copyright (c) 2014 2nd Jobs. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

- (instancetype)init
{
  self = [super init];
  if (self) {
    NSLog(@"======================");
  }
  return self;
}

- (instancetype)initWithFrame:(NSRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    NSLog(@"======================");
  }
  return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}


-(void)keyUp:(NSEvent*)event {
//  NSLog(@"Key %@", event);
}

-(void)keyDown:(NSEvent*)event {
  switch( [event keyCode] ) {
    case 124:
    case 123:
      break;
    default:
      break;
  }
  
}

- (BOOL)acceptsFirstResponder {
  return YES;
}


@end
