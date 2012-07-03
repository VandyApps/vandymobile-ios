//
//  Meeting.h
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Meeting : NSObject

@property (copy,nonatomic) NSString *day;
@property (copy,nonatomic) NSString *date;
@property (strong, nonatomic) NSDate *dateUnformatted;
@property (copy,nonatomic) NSString *time; 
@property (retain,nonatomic) NSNumber *hasFood;
@property (retain,nonatomic) NSNumber *hasSpeaker;
@property (copy,nonatomic) NSString *speakerName;
@property (copy,nonatomic) NSString *topic;
@property (nonatomic) CLLocationCoordinate2D loc;
@property (copy, nonatomic) NSString *description;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)meetingDictionary;

@end
