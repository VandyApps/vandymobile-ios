//
//  UserAPIClient.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AFHTTPClient.h"

@interface UserAPIClient : AFHTTPClient

+ (id)sharedInstance;

- (void)authorizeUser:(NSString *)user withPassword:(NSString *)password withCompletionBlock:(void(^)(void))completionBlock;

@end
