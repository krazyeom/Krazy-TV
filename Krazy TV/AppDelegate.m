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
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) NSDictionary *programList;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"program_list" ofType:@"plist"];
  self.programList = [[NSMutableDictionary alloc] initWithContentsOfFile:path];

  NSString *urlString = [[_programList allValues] firstObject];
  
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
  
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  [_tableView setDoubleAction:@selector(selectedChannel:)];
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
  NSURL *url = [NSURL URLWithString:urlString];
  AVAsset *asset = [AVAsset assetWithURL:url];
  AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:asset];
  self.player = [AVPlayer playerWithPlayerItem:item];
  _avPlayerView.player = _player;
  _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(playAVPlayer) userInfo:nil repeats:YES];
}

@end
