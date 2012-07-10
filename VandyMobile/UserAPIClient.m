//
//  UserAPIClient.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserAPIClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"


#define AppsAPIBaseURLString @"http://70.138.50.84"
#define AppsAPIToken @"1234abcd"

@implementation UserAPIClient

+ (id)sharedInstance {
	static UserAPIClient *__sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__sharedInstance = [[UserAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AppsAPIBaseURLString]];
	});
	return __sharedInstance;
}


- (id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		//custom settings
		[self setDefaultHeader:@"x-api-token" value:AppsAPIToken];
		
		[self registerHTTPOperationClass:[AFJSONRequestOperation class]]; // what is this doing?
	}
	
	return self;
}


@end
