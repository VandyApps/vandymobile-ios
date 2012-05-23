//
//  Meeting.h
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Meeting : NSObject

@property (copy,nonatomic) NSString *day;
@property (copy,nonatomic) NSString *date;
@property (copy,nonatomic) NSString *time; 
@property (retain,nonatomic) NSNumber *hasFood;
@property (retain,nonatomic) NSNumber *hasSpeaker;
@property (copy,nonatomic) NSString *speakerName;
@property (copy,nonatomic) NSString *topic;


- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
