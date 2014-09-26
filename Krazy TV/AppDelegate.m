//
//  AppDelegate.m
//  Krazy TV
//
//  Created by Steve Yeom on 9/26/14.
//  Copyright (c) 2014 2nd Jobs. All rights reserved.
//

#import "AppDelegate.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) AVPlayer *player;
@property (strong) IBOutlet AVPlayerView *avPlayerView;
@property (strong) NSTimer *timer;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"program_list" ofType:@"plist"];
  NSMutableDictionary *rootDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:path];


  NSString *urlString = [[rootDictionary allValues] firstObject];
  
  NSURL *url = [NSURL URLWithString:urlString];
  AVAsset *asset = [AVAsset assetWithURL:url];
  AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
  self.player = [AVPlayer playerWithPlayerItem:item];
  _avPlayerView.player = _player;
  
  if ([_player status] == AVPlayerStatusReadyToPlay){
    [_player play];
  } else {
     _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playAVPlayer) userInfo:nil repeats:YES];
      NSLog(@"Not ready");
  }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

- (void)playAVPlayer{
  if ([_player status] == AVPlayerStatusReadyToPlay){
    [_player play];
    [_timer invalidate];
  }
}

@end
