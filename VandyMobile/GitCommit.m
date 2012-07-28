//
//  GitCommit.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/27/12.
//
//

#import "GitCommit.h"

#define AUTHOR_KEY          @"author"
#define AVATAR_URL_KEY      @"avatar_url"
#define USERNAME_KEY        @"login"
#define COMMIT_KEY          @"commit"
#define DATE_KEY            @"date"
#define COMMIT_MESSAGE_KEY  @"message"


@implementation GitCommit

@synthesize author = _author;
@synthesize avatarURL = _avatarURL;
@synthesize commitDate = _commitDate;
@synthesize email = _email;
@synthesize commitMessage = _commitMessage;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.author			= [[dictionary objectForKey:AUTHOR_KEY] objectForKey:USERNAME_KEY];
        self.avatarURL      = [[dictionary objectForKey:AUTHOR_KEY] objectForKey:AVATAR_URL_KEY];
        self.commitDate     = [[dictionary objectForKey:COMMIT_KEY] objectForKey:DATE_KEY];
        self.commitMessage  = [[dictionary objectForKey:COMMIT_KEY] objectForKey:COMMIT_MESSAGE_KEY];
	}
	return self;
}

@end
