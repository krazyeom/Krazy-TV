//
//  PlayerView.m
//  Krazy TV
//
//  Created by Steve Yeom on 9/28/14.
//  Copyright (c) 2014 2nd Jobs. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

- (instancetype)init{
  if ((self = [super init])) {
    NSTextField *textField;
    
    textField = [[NSTextField alloc] initWithFrame:NSMakeRect(10, 10, 200, 17)];
    [textField setStringValue:@"My Label"];
    [textField setTextColor:[NSColor redColor]];
    [textField setBezeled:NO];
    [textField setDrawsBackground:NO];
    [textField setEditable:NO];
    [textField setSelectable:NO];
    
    NSLog(@"asdfasfasfasfas");
    
    //  [self addSubview:textField];
    [self addSubview:textField positioned:NSWindowAbove relativeTo:nil];
    
    
    [self.layer addSublayer:[textField layer]];
    
  }
  
  return self;
}



- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
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

-(void)mouseDown:(NSEvent *)theEvent {
  NSRect  windowFrame = [[self window] frame];
  
  _initialLocation = [NSEvent mouseLocation];
  
  _initialLocation.x -= windowFrame.origin.x;
  _initialLocation.y -= windowFrame.origin.y;
}

- (void)mouseDragged:(NSEvent *)theEvent {
  NSPoint currentLocation;
  NSPoint newOrigin;
  
  NSRect  screenFrame = [[NSScreen mainScreen] frame];
  NSRect  windowFrame = [[self window] frame];
  
  currentLocation = [NSEvent mouseLocation];
  newOrigin.x = currentLocation.x - _initialLocation.x;
  newOrigin.y = currentLocation.y - _initialLocation.y;
  
  // Don't let window get dragged up under the menu bar
  if( (newOrigin.y+windowFrame.size.height) > (screenFrame.origin.y+screenFrame.size.height) ){
    newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height);
  }
  
  //go ahead and move the window to the new location
  [[self window] setFrameOrigin:newOrigin];
}

- (BOOL)isMovableByWindowBackground {
  return YES;
}

- (BOOL)mouseDownCanMoveWindow{
  return YES;
}

@end
