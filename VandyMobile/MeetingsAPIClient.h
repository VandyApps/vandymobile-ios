//
//  MeetingsAPIClient.h
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"
#import "Meeting.h"

@interface MeetingsAPIClient : AFHTTPClient

+ (id)sharedInstance;
- (void)addMeetingtoServer:(Meeting *)meeting;

@end
