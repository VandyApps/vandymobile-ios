//
//  Meeting.h
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 {
 content = "this is a test";
 "created_at" = "2012-05-20T04:40:34Z";
 id = 2;
 name = Graham;
 title = test2;
 "updated_at" = "2012-05-20T04:40:34Z";
 },
*/

@interface Meeting : NSObject

@property (copy,nonatomic) NSString *day;
@property (copy,nonatomic) NSString *date;
@property (copy,nonatomic) NSString *time; 
@property bool hasFood;
@property bool hasSpeaker;
@property (copy,nonatomic) NSString *speakerName;
@property (copy,nonatomic) NSString *speakerTopic;


- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
