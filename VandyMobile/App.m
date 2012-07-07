//
//  App.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "App.h"

#define TEAM_KEY @"team"
#define NAME_KEY @"name"
#define OS_KEY @"OS"
#define DESCRIPTION_KEY @"description"

@implementation App

@synthesize team = _team;
@synthesize name = _name;
@synthesize OS = _OS;
@synthesize description = _description;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.team			= [[dictionary objectForKey:TEAM_KEY] objectForKey:NAME_KEY];
		self.name			= [dictionary objectForKey:NAME_KEY];
		self.OS				= [dictionary objectForKey:OS_KEY];
		self.description	= [dictionary objectForKey:DESCRIPTION_KEY];
	}
	return self;
}

@end
