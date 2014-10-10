//
//  Channel.h
//  iKTV
//
//  Created by Steve Yeom on 10/10/14.
//  Copyright (c) 2014 2nd Jobs. All rights reserved.
//

#import <Realm/Realm.h>

@interface Channel : RLMObject
@property  NSString *channelNum;
@property  NSString *title;
@property  NSString *quality;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Channel>
RLM_ARRAY_TYPE(Channel)
