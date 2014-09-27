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
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) NSDictionary *programList;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  [_tableView setDoubleAction:@selector(selectedChannel:)];
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"program_list" ofType:@"plist"];
  self.programList = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
  
  NSString *channel = [self loadLastViewedChannel];
  [self playVideoWithURL:channel];
  
}

- (NSString *)loadLastViewedChannel {
  NSString *channel = [[NSUserDefaults standardUserDefaults] stringForKey:@"channel"];
  if (channel == nil) {
    channel = [[_programList allValues] firstObject];
  }
  return channel;
}

- (void)saveCurrnentChannel:(NSString *)channel {
  [[NSUserDefaults standardUserDefaults] setObject:channel forKey:@"channel"];
}


- (void)playVideoWithURL:(NSString *)urlString {
  NSURL *url = [NSURL URLWithString:urlString];
  AVAsset *asset = [AVAsset assetWithURL:url];
  AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
  self.player = [AVPlayer playerWithPlayerItem:item];
  _avPlayerView.player = _player;
  
  [_player addObserver:self forKeyPath:@"status" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if (object == _player && [keyPath isEqualToString:@"status"]) {
    if (_player.status == AVPlayerStatusReadyToPlay) {
      [_player play];
    } else if (_player.status == AVPlayerStatusFailed) {
      // something went wrong. player.error should contain some information
    }
  }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
  return [_programList count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSString *title = [[_programList allKeys] objectAtIndex:row];
  return title;
}

-(void)selectedChannel:(id)sender{
  NSInteger selected = [(NSTableView *)sender selectedRow];
  NSString *urlString = [[_programList allValues] objectAtIndex:selected];
  [self playVideoWithURL:urlString];
  [self saveCurrnentChannel:urlString];
}

@end
