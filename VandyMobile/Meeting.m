//
//  Meeting.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

@synthesize day = _day;
@synthesize date = _date;
@synthesize time = _time;
@synthesize hasFood = _hasFood;
@synthesize hasSpeaker = _hasSpeaker;
@synthesize speakerName = _speakerName;
@synthesize topic = _topic;
@synthesize loc = _loc;
@synthesize description = _description;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.day = [dictionary objectForKey:@"day"];
		self.date = [self convertDateToFormattedStringWithJSONString:[dictionary objectForKey:@"date"]];
		self.time = [self convertTimeToStringWithJSONString:[dictionary objectForKey:@"date"]];
		self.hasFood = [NSNumber numberWithInt:[[dictionary objectForKey:@"food"] boolValue]];
		self.hasSpeaker = [NSNumber numberWithInt:[[dictionary objectForKey:@"speaker"]boolValue]];
		self.speakerName = [dictionary objectForKey:@"speaker_name"];
		self.topic = [dictionary objectForKey:@"topic"];
        
        // Protection on coordinate.
        if ([dictionary objectForKey:@"xcoordinate"] && [dictionary objectForKey:@"ycoordinate"]) {
            self.loc = CLLocationCoordinate2DMake([[dictionary objectForKey:@"xcoordinate"] doubleValue], [[dictionary objectForKey:@"ycoordinate"] doubleValue]);
        }
        
        self.description = [dictionary objectForKey:@"description"];

	}
	return self;
}

- (NSString *)convertDateToFormattedStringWithJSONString:(NSString *)dateString {
	//Converts JSON date to a formatted date string
	NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];	
	
	NSDate *date = [dateFormatter dateFromString:dateString];
	
	[dateFormatter setDateStyle:NSDateFormatterLongStyle];
	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	NSTimeInterval timeInterval = [date timeIntervalSinceReferenceDate];
	NSDate *dateFromInterval = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
	
	NSString *formattedDateString = [dateFormatter stringFromDate:dateFromInterval];
//	NSLog(@"formattedDateString: %@", formattedDateString);
	return formattedDateString;
}

- (NSString *)convertTimeToStringWithJSONString:(NSString *)dateString {
	//Converts JSON date to a time string
	NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
	[timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[timeFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"]; //neccessary to keep time correct ??

	NSDate *date = [timeFormatter dateFromString:dateString];
	
	NSTimeInterval timeInterval = [date timeIntervalSinceReferenceDate];
	NSDate *dateFromInterval = [NSDate dateWithTimeIntervalSinceReferenceDate:timeInterval];
	
	[timeFormatter setDateFormat: @"HH:mm:ss"];
	[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *timeString = [timeFormatter stringFromDate:dateFromInterval];
//	NSLog(@"Time = %@", timeString);
	return timeString;
}

@end
