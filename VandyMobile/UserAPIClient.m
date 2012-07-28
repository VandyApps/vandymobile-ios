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


#define UserAPIBaseURLString @"http://70.138.50.84"
#define UserAPIToken @"1234abcd"

@implementation UserAPIClient

+ (id)sharedInstance {
	static UserAPIClient *__sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__sharedInstance = [[UserAPIClient alloc] initWithBaseURL:[NSURL URLWithString:UserAPIBaseURLString]];
	});
	return __sharedInstance;
}


- (id)initWithBaseURL:(NSURL *)url {
	self = [super initWithBaseURL:url];
	if (self) {
		//custom settings
		[self setDefaultHeader:@"x-api-token" value:UserAPIToken];
		
		[self registerHTTPOperationClass:[AFJSONRequestOperation class]]; // what is this doing?
	}
	
	return self;
}

- (void)authorizeUser:(NSString *)user withPassword:(NSString *)password withCompletionBlock:(void(^)(id))completionBlock {
	NSString *postPath = [UserAPIBaseURLString stringByAppendingString:@"/sessions.json"];
	NSDictionary *loginDict = [NSDictionary dictionaryWithObjectsAndKeys:user,@"login", password, @"password", nil];
	
	
	[self setParameterEncoding:AFJSONParameterEncoding];
	
	[self postPath:postPath parameters:loginDict
		   success:^(AFHTTPRequestOperation *operation, id responseObject) {
//			   NSLog(@"response = %@", responseObject);
			   [SVProgressHUD dismissWithSuccess:@"Logged In"];
			   completionBlock(responseObject);
		   } 
		   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			   NSLog(@"error = %@", error);
			   [SVProgressHUD dismissWithError:@"Couldn't Login"];
		   }];
}


@end
