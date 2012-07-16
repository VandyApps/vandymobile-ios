//
//  MeetingsAPIClient.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeetingsAPIClient.h"
#import "AFNetworking.h"
#import "JSONKit.h"
#import "SVProgressHUD.h"


#define MeetingsAPIBaseURLString @"http://70.138.50.84"
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

- (void)addMeetingtoServer:(Meeting *)meeting withCompletionBlock:(void(^)(void))completionBlock {
	NSString *postPath = [MeetingsAPIBaseURLString stringByAppendingString:@"/meetings.json"];
	NSDictionary *meetingDict = [meeting meetingDictionary];
	

	[self setParameterEncoding:AFJSONParameterEncoding];
	
	[self postPath:postPath parameters:meetingDict
		   success:^(AFHTTPRequestOperation *operation, id responseObject) {
			   NSLog(@"response = %@", responseObject);
			   [SVProgressHUD dismissWithSuccess:@"Meeting added!"];
			   completionBlock();
			   [[NSNotificationCenter defaultCenter] postNotificationName:@"MeetingAdded" object:self];
		   } 
		   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			   NSLog(@"error = %@", error);
			   [SVProgressHUD dismissWithError:@"Couldn't add meeting. Try again later"];
		   }];
}


@end
