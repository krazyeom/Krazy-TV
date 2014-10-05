//
//  PlayerView.m
//  Krazy TV
//
//  Created by Steve Yeom on 9/28/14.
//  Copyright (c) 2014 2nd Jobs. All rights reserved.
//

#import "PlayerView.h"

@implementation PlayerView

- (void)volumeLabelInit{
  _volumeLabel = [[NSTextField alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
  _volumeLabel.stringValue = @"";
  [_volumeLabel setBezeled:NO];
  [_volumeLabel setDrawsBackground:NO];
  [_volumeLabel setEditable:NO];
  [_volumeLabel setSelectable:NO];
  [self addSubview:_volumeLabel positioned:NSWindowAbove relativeTo:nil];
}

- (void)updateVolumeString:(NSString *)volume {
  [_volumeLabel setStringValue:volume];
}

- (void)hideVolumeLabel {
  [_volumeLabel setHidden:YES];
}

- (void)showVolumeLabel {
  [_volumeLabel setHidden:NO];
}

- (void)drawRect:(NSRect)dirtyRect {
  [super drawRect:dirtyRect];
}

- (void)keyUp:(NSEvent *)theEvent {
  switch( [theEvent keyCode] ) {
    case 125:
    case 126:
      [_timer invalidate];
      _timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(hideVolumeLabel) userInfo:nil repeats:NO];

      break;
    default:
      break;
  }
}

- (void)keyDown:(NSEvent*)theEvent {
  switch( [theEvent keyCode] ) {
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
