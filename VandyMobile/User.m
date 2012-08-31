//
//  User.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

#define USER_KEY        @"user"
#define ID_KEY          @"id"
#define EMAIL_KEY       @"email"
#define TEAM_KEY        @"teams"
#define TEAM_IDS_KEY    @"teamIds"
#define APP_KEY         @"app"
#define APP_IDS_KEY     @"appIds"
#define NAME_KEY        @"name"

@implementation User

@synthesize userID = _userID;
@synthesize email = _email;
@synthesize teamIds = _teamIds;
@synthesize appIds = _appIds;

- (id)initWithResponse:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.userID     = [dictionary objectForKey:ID_KEY];
		self.email      = [dictionary objectForKey:EMAIL_KEY];
        
		NSArray *teams	= [dictionary objectForKey:TEAM_KEY];
        NSMutableArray *tempTeamIds = [NSMutableArray array];
        for (id team in teams) {
            [tempTeamIds addObject:[team objectForKey:@"id"]];
        }
        self.teamIds    = tempTeamIds;
        
        NSArray *apps   = [dictionary objectForKey:TEAM_KEY];
        NSMutableArray *tempAppIds = [NSMutableArray array];
        for (id app in apps) {
            [tempAppIds addObject:[[app objectForKey:APP_KEY] objectForKey:ID_KEY]];
        }
		self.appIds      = tempAppIds;
	}
	return self;
}

- (id)initWithDictionaryFromUser:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.userID     = [dictionary objectForKey:ID_KEY];
		self.email      = [dictionary objectForKey:EMAIL_KEY];
		self.teamIds	= [dictionary objectForKey:TEAM_IDS_KEY];
		self.appIds     = [dictionary objectForKey:APP_IDS_KEY];
	}
	return self;
}

- (NSDictionary *)userDictionary {
	NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithCapacity:4];
	[userDict setObject:self.userID forKey:ID_KEY];
	[userDict setObject:self.email forKey:EMAIL_KEY];
	[userDict setObject:self.teamIds forKey:TEAM_IDS_KEY];
	[userDict setObject:self.appIds forKey:APP_IDS_KEY];
	
	return [userDict copy];
}

+ (BOOL)loggedIn {
//	NSLog(@"output = %@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY]);
	return (BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY];
}




@end
