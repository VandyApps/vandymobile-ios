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
#define TAGLINE_KEY @"tagline"
#define IMAGEPATH_KEY @"image_url"
#define ITUNESPATH_KEY @"app_url"

@implementation App

@synthesize team = _team;
@synthesize name = _name;
@synthesize OS = _OS;
@synthesize description = _description;
@synthesize tagline = _tagline;
@synthesize imagePath = _imagePath;
@synthesize itunesPath = _itunesPath;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.team			= [[dictionary objectForKey:TEAM_KEY] objectForKey:NAME_KEY];
		self.name			= [dictionary objectForKey:NAME_KEY];
		self.OS				= [dictionary objectForKey:OS_KEY];
		self.description	= [dictionary objectForKey:DESCRIPTION_KEY];
        self.tagline        = [dictionary objectForKey:TAGLINE_KEY];
        self.imagePath      = [dictionary objectForKey:IMAGEPATH_KEY];
        self.itunesPath     = [dictionary objectForKey:ITUNESPATH_KEY];
	}
	return self;
}

@end
