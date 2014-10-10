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
#import "PlayerView.h"

#import <Realm/Realm.h>

#import "Server.h"
#import "Channel.h"

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) AVPlayer *player;
@property (strong) IBOutlet PlayerView *avPlayerView;
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSMenuItem *item;
@property (strong) RLMArray *channels;
@property (strong) RLMArray *server;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

  NSString *path = [[NSBundle mainBundle] pathForResource:@"ktv" ofType:@"realm"];
  RLMRealm *realm  = [RLMRealm realmWithPath:path]; // Create realm pointing to default file
  _channels = [Channel allObjectsInRealm:realm];
  _server = [Server allObjectsInRealm:realm];

  self.window.delegate = self;
  self.avPlayerView.delegate = self;
  
  
  [_tableView setDoubleAction:@selector(selectedChannel:)];
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;

  NSString *channel = [self loadLastViewedChannel];
  [self playVideoWithURL:channel];
  unichar arrowKey = NSLeftArrowFunctionKey;
  [_item setKeyEquivalent:[NSString stringWithCharacters:&arrowKey length:1]];
  _player.volume = [self loadVolume];
  
  [self.avPlayerView volumeLabelInit];
}

- (NSString *)loadLastViewedChannel {
  NSString *channel = [[NSUserDefaults standardUserDefaults] stringForKey:@"channel"];
  return channel;
}

- (void)saveCurrnentChannel:(NSString *)channel {
  [[NSUserDefaults standardUserDefaults] setObject:channel forKey:@"channel"];
}

- (float)loadVolume {
  float volume = [[NSUserDefaults standardUserDefaults] floatForKey:@"volume"];
  return volume;
}

- (void)saveVolume:(float)volume {
  [[NSUserDefaults standardUserDefaults] setFloat:volume forKey:@"volume"];
}


- (void)playVideoWithURL:(NSString *)urlString {
  [_player removeObserver:self forKeyPath:@"status"];
  
  NSURL *url = [NSURL URLWithString:urlString];
  AVAsset *asset = [AVAsset assetWithURL:url];
  AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
  self.player = [AVPlayer playerWithPlayerItem:item];
  _avPlayerView.player = _player;
  _player.volume = [self loadVolume];
  
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
  return [_channels count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  return [self channelTitleWithIndex:row];
}

-(void)selectedChannel:(id)sender{
  NSInteger selectedIndex = [(NSTableView *)sender selectedRow];
  NSString *urlString = [self channelURLWithIndex:selectedIndex];
  [self playVideoWithURL:urlString];
  [self saveCurrnentChannel:urlString];
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification {
  [_tableView.superview.superview setHidden:YES];
  [[self window] setLevel:NSNormalWindowLevel];
}

- (void)windowDidExitFullScreen:(NSNotification *)notification {
  NSInteger level = [[NSUserDefaults standardUserDefaults] integerForKey:@"top"];
  if (level) {
    [[self window] setLevel:NSFloatingWindowLevel];
  }
}

- (IBAction)volumeUp:(id)sender {
  float volume = _player.volume + 0.1f;
  if (volume > 1.0f){
    volume = 1.0f;
  }
  _player.volume = volume;
  [self saveVolume:volume];
  [_avPlayerView updateVolumeString:[NSString stringWithFormat:@"%.1f", volume]];
  [_avPlayerView showVolumeLabel];
}

- (IBAction)volumeDown:(id)sender {
  float volume = _player.volume - 0.1f;
  if (volume < 0){
    volume = 0.0f;
  }
  _player.volume = volume;
  [self saveVolume:volume];
  [_avPlayerView updateVolumeString:[NSString stringWithFormat:@"%.1f", volume]];
  [_avPlayerView showVolumeLabel];
}

- (IBAction)toggleProgramList:(id)sender {
  if ([_tableView.superview.superview isHidden]) {
    [_tableView.superview.superview setHidden:NO];
  } else {
    [_tableView.superview.superview setHidden:YES];
  }
}

- (IBAction)toggleTopWindow:(id)sender {
  if ([[self window] level]) {
    [[self window] setLevel:NSNormalWindowLevel];
    [[NSUserDefaults standardUserDefaults] setInteger:NSNormalWindowLevel forKey:@"top"];
  } else {
    [[self window] setLevel:NSFloatingWindowLevel];
    [[NSUserDefaults standardUserDefaults] setInteger:NSFloatingWindowLevel forKey:@"top"];

  }
}

-(void)playPauseVideo{
  if (_player.rate == 1.0) {
    [_player pause];
  } else {
    [_player play];
  }
}

- (NSString *)channelTitleWithIndex:(NSInteger)index {
  return [(Channel *)[_channels objectAtIndex:index] title];
}

- (NSString *)channelURLWithIndex:(NSInteger)index {
  NSInteger serverInteger = RAND_FROM_TO(12, 15);
  NSString *temp1 = [(Server *)[_server firstObject] url];
  NSString *temp2 = [@(serverInteger) stringValue];
  NSString *temp3 = [(Channel *)[_channels objectAtIndex:index] channelNum];
  NSString *temp4 = [(Channel *)[_channels objectAtIndex:index] quality];
  NSString *url = [NSString stringWithFormat:@"%@%@/live/1%@%@.m3u8?sid=", temp1, temp2, temp3, temp4];
  return url;
}

@end
