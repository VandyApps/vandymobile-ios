//
//  AppsAPIClient.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppsAPIClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"


#define AppsAPIBaseURLString @"http://foo:bar@70.138.50.84"
#define AppsAPIToken @"1234abcd"

@implementation AppsAPIClient

+ (id)sharedInstance {
	static AppsAPIClient *__sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__sharedInstance = [[AppsAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AppsAPIBaseURLString]];
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
