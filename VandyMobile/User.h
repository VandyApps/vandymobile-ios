//
//  User.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

/* Contains basic User information */
/* Since the user is stored in NSUserDefaults, we don't want to make it too big */
/* Only store userID, email, team and app */
/* Load any large pieces of data from the server and cache if necessary */

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, strong) NSArray *teamIds;
@property (nonatomic, strong) NSArray *appIds;

- (id)initWithResponse:(NSDictionary *)dictionary;
- (id)initWithDictionaryFromUser:(NSDictionary *)dictionary;

- (NSDictionary *)userDictionary;

+ (BOOL)loggedIn;

@end
