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

#define RAND_FROM_TO(min, max) (min + arc4random_uniform(max - min + 1))


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property (strong) AVPlayer *player;
@property (strong) IBOutlet PlayerView *avPlayerView;
@property (strong) IBOutlet NSTableView *tableView;
@property (strong) IBOutlet NSMenuItem *item;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  
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
  return [[self programList] count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
  NSString *title = [self channelTitleWithIndex:row];
  return title;
}

-(void)selectedChannel:(id)sender{
  NSInteger selectedIndex = [(NSTableView *)sender selectedRow];
  NSString *urlString = [self channelURLWithIndex:selectedIndex];
  [self playVideoWithURL:urlString];
  [self saveCurrnentChannel:urlString];
}

- (void)windowWillEnterFullScreen:(NSNotification *)notification {
  [_tableView.superview.superview setHidden:YES];
}

- (void)windowDidExitFullScreen:(NSNotification *)notification {
  [_tableView.superview.superview setHidden:NO];
}

- (IBAction)volumeUp:(id)sender {
  float volume = _player.volume + 0.1f;
  if (volume > 1.0f){
    volume = 1.0f;
  }
  _player.volume = volume;
  [self saveVolume:volume];
}

- (IBAction)volumeDown:(id)sender {
  float volume = _player.volume - 0.1f;
  if (volume < 0){
    volume = 0.0f;
  }
  _player.volume = volume;
  [self saveVolume:volume];
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
  } else {
    [[self window] setLevel:NSFloatingWindowLevel];
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
  return [[[self programList] objectAtIndex:index] objectAtIndex:1];
}

- (NSString *)channelURLWithIndex:(NSInteger)index {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"program_list" ofType:@"plist"];
  NSDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
  NSArray *array = [self programList];
  NSInteger serverInteger = RAND_FROM_TO(12, 15);
  NSString *temp1 = [dict objectForKey:@"url"];
  NSString *temp2 = [@(serverInteger) stringValue];
  NSString *temp3 = @"/live/1";
  NSString *temp4 = [[array objectAtIndex:index] objectAtIndex:0];
  NSString *temp5 = [[array objectAtIndex:index] objectAtIndex:2];
  NSString *temp6 = @".m3u8?sid=";
  return [NSString stringWithFormat:@"%@%@%@%@%@%@", temp1, temp2, temp3, temp4, temp5, temp6];
}
                     
- (NSArray *)programList{
  return @[
  @[@"001", @"jtbc", @"5"],
  @[@"002", @"MBN Live", @"3"],
  @[@"003", @"Channel A", @"3"],
  @[@"004", @"TV 조선 Live", @"3"],
  @[@"005", @"tvN", @"5"],
  @[@"007", @"sport HD", @"5"],
  @[@"008", @"Billiards TV", @"3"],
  @[@"009", @"CNN", @"3"],
  @[@"010", @"OnStyle", @"3"],
  @[@"011", @"Story On", @"3"],
  @[@"012", @"Olive Show", @"3"],
  @[@"013", @"OCN", @"3"],
  @[@"014", @"KBS2", @"5"],
  @[@"015", @"MTV", @"3"],
  @[@"016", @"KM", @"3"],
  @[@"017", @"KBS1", @"5"],
  @[@"018", @"EBS", @"3"],
  @[@"019", @"중화TV", @"3"],
  @[@"020", @"아시아N", @"3"],
  @[@"021", @"NOVELA", @"3"],
  @[@"022", @"IB SPORTS", @"3"],
  @[@"023", @"NAT GEO WILD", @"3"],
  @[@"024", @"NAT GEO People", @"3"],
  @[@"025", @"OnGamenet", @"3"],
  @[@"026", @"바둑 TV", @"3"],
  @[@"027", @"FTV", @"3"],
  @[@"028", @"J Golf", @"3"],
  @[@"029", @"NBC Golf", @"3"],
  @[@"030", @"YTN", @"3"],
  @[@"032", @"브레인 TV", @"3"],
  @[@"034", @"ANI PLUS", @"3"],
  @[@"035", @"연합뉴스 TV", @"3"],
  @[@"036", @"SKY ICT", @"3"],
  @[@"037", @"BBC World NEWS", @"3"],
  @[@"040", @"IB SPORTS", @"3"],
  @[@"041", @"KBS N SPORTS", @"5"],
  @[@"042", @"SBS SPORTS", @"5"],
  @[@"043", @"MBC SPORTS", @"5"],
  @[@"044", @"SKY SPORTS", @"3"],
  @[@"045", @"아이넷TV", @"3"],
  @[@"046", @"inet 한국가요채널", @"3"],
  @[@"047", @"YTN Science", @"3"],
  @[@"048", @"한국경제", @"3"],
  @[@"051", @"OBS", @"3"],
  @[@"052", @"ANIMAX", @"3"],
  @[@"054", @"MBC pooq beta", @"3"],
  @[@"055", @"SBS", @"3"],
  @[@"056", @"GS e SHOP", @"3"],
  @[@"057", @"SKY t SHOPPING", @"3"],
  @[@"058", @"디즈니 주니어", @"3"],
  @[@"059", @"디즈니 채널", @"3"],
  @[@"060", @"SBS Sport", @"3"],
  @[@"061", @"SKY ENT", @"3"],
  @[@"062", @"홈쇼핑", @"3"],
  @[@"064", @"ANI ONE", @"3"],
  @[@"065", @"EBS U", @"3"],
  @[@"066", @"ANI BOX", @"3"],
  @[@"182", @"대교어린이 TV", @"3"],
  @[@"183", @"KIDS Talk", @"3"],
  @[@"185", @"한국바둑방송", @"3"],
  @[@"186", @"토마토TV", @"3"],
  @[@"188", @"YTN weather", @"3"],
  @[@"189", @"EBS i", @"3"],
  @[@"190", @"EBS+2", @"3"],
  @[@"191", @"EBS e", @"3"],
  @[@"199", @"Sports TV 2", @"3"]
  ];
}


@end
