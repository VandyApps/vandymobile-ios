//
//  VMAPIClient.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMAPIClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"


#define VMAPIBaseURLString @"http://foo:bar@vandymobile.herokuapp.com"
#define VMAPIToken @"1234abcd"

@implementation VMAPIClient

+ (id)sharedInstance {
	static VMAPIClient *__sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		__sharedInstance = [[VMAPIClient alloc] initWithBaseURL:[NSURL URLWithString:VMAPIBaseURLString]];
	});
	return __sharedInstance;
}

 
- (id)initWithBaseURL:(NSURL *)url {
	 self = [super initWithBaseURL:url];
	 if (self) {
		 //custom settings
		 [self setDefaultHeader:@"x-api-token" value:VMAPIToken];
		 
		 [self registerHTTPOperationClass:[AFJSONRequestOperation class]]; // what is this doing?
	 }
	 
	 return self;
}

- (void)addMeetingtoServer:(Meeting *)meeting withCompletionBlock:(void(^)(void))completionBlock {
	NSString *postPath = [VMAPIBaseURLString stringByAppendingString:@"/meetings.json"];
	NSDictionary *meetingDict = [meeting meetingDictionary];
	

	[self setParameterEncoding:AFJSONParameterEncoding];
	
	[self postPath:postPath parameters:meetingDict
		   success:^(AFHTTPRequestOperation *operation, id responseObject) {
//			   NSLog(@"response = %@", responseObject);
			   [SVProgressHUD dismissWithSuccess:@"Meeting added!"];
			   completionBlock();
		   } 
		   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			   NSLog(@"error = %@", error);
			   [SVProgressHUD dismissWithError:@"Couldn't add meeting. Try again later"];
		   }];
}

- (void)authorizeUser:(NSString *)user withPassword:(NSString *)password withCompletionBlock:(void(^)(id))completionBlock {
	NSString *postPath = [VMAPIBaseURLString stringByAppendingString:@"/sessions.json"];
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
			   [SVProgressHUD dismissWithError:@"Couldn't Log In"];
		   }];
}


@end
