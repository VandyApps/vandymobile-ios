//
//  MeetingsAPIClient.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeetingsAPIClient.h"
#import "AFNetworking.h"

#define MeetingsAPIBaseURLString @"http://70.138.50.84/"
#define MeetingsAPIToken @"1234abcd"

@implementation MeetingsAPIClient

+ (id)sharedInstance {
	static MeetingsAPIClient *__sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__sharedInstance = [[MeetingsAPIClient alloc] initWithBaseURL:[NSURL URLWithString:MeetingsAPIBaseURLString]];
	});
	return __sharedInstance;
}

 
 - (id)initWithBaseURL:(NSURL *)url {
	 self = [super initWithBaseURL:url];
	 if (self) {
		 //custom settings
		 [self setDefaultHeader:@"x-api-token" value:MeetingsAPIToken];
		 
		 [self registerHTTPOperationClass:[AFJSONRequestOperation class]]; // what is this doing?
	 }
	 
	 return self;
 }


@end
