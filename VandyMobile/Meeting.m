//
//  Meeting.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

@synthesize name = _name;
@synthesize title = _title;
@synthesize content = _content;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.name = [dictionary objectForKey:@"name"];
		self.title = [dictionary objectForKey:@"title"];
		self.content = [dictionary objectForKey:@"content"];
	}
	return self;
}

@end
