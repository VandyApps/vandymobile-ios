//
//  User.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "User.h"

#define USER_KEY	@"user"

#define USERID_KEY	@"id"
#define EMAIL_KEY	@"email"
#define TEAM_KEY	@"teams"
#define APP_KEY		@"app"
#define NAME_KEY	@"name"

@implementation User

@synthesize userID = _userID;
@synthesize email = _email;
@synthesize team = _team;
@synthesize app = _app;

- (id)initWithResponse:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.userID = [dictionary objectForKey:USERID_KEY];
		self.email	= [dictionary objectForKey:EMAIL_KEY];
		self.team	= [[[dictionary objectForKey:TEAM_KEY] objectAtIndex:0] objectForKey:NAME_KEY];
		self.app	= [[[[dictionary objectForKey:TEAM_KEY] objectAtIndex:0] objectForKey:APP_KEY] objectForKey:NAME_KEY];
	}
	return self;
}

- (id)initWithDictionaryFromUser:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.userID = [dictionary objectForKey:USERID_KEY];
		self.email	= [dictionary objectForKey:EMAIL_KEY];
		self.team	= [dictionary objectForKey:TEAM_KEY];
		self.app	= [dictionary objectForKey:APP_KEY];
	}
	return self;
}

- (NSDictionary *)userDictionary {
	NSMutableDictionary *userDict = [NSMutableDictionary dictionaryWithCapacity:4];
	[userDict setObject:self.userID forKey:USERID_KEY];
	[userDict setObject:self.email forKey:EMAIL_KEY];
	[userDict setObject:self.team forKey:TEAM_KEY];
	[userDict setObject:self.app forKey:APP_KEY];
	
	return [userDict copy];
}

+ (BOOL)loggedIn {
	NSLog(@"output = %@", [[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY]);
	return (BOOL)[[NSUserDefaults standardUserDefaults] objectForKey:USER_KEY];
}


@end
