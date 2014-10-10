//
//  Server.h
//  iKTV
//
//  Created by Steve Yeom on 10/10/14.
//  Copyright (c) 2014 2nd Jobs. All rights reserved.
//

#import <Realm/Realm.h>

@interface Server : RLMObject
@property NSString *url;
@end

// This protocol enables typed collections. i.e.:
// RLMArray<Server>
RLM_ARRAY_TYPE(Server)
