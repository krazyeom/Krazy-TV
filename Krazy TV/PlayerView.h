//
//  PlayerView.h
//  Krazy TV
//
//  Created by Steve Yeom on 9/28/14.
//  Copyright (c) 2014 2nd Jobs. All rights reserved.
//

#import <AVKit/AVKit.h>

@protocol PlayerDelegate;

@interface PlayerView : AVPlayerView

@property (strong) id<PlayerDelegate> delegate;
@property NSPoint initialLocation;

@end

@protocol PlayerDelegate <NSObject>

@optional
- (void)playPauseVideo;

@end
