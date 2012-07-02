//
//  Meeting.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"

#define DAY_KEY @"day"
#define DATE_KEY @"date"
#define TIME_KEY @"date"
#define HAS_FOOD_KEY @"food"
#define HAS_SPEAKER_KEY @"speaker"
#define SPEAKER_KEY @"speaker_name"
#define TOPIC_KEY @"topic"
#define DESCRIPTION_KEY @"description"


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
@synthesize dateUnformatted = _dateUnformatted;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		self.day = [dictionary objectForKey:DAY_KEY];
		self.date = [self convertDateToFormattedStringWithJSONString:[dictionary objectForKey:DATE_KEY]];
		self.time = [self convertTimeToStringWithJSONString:[dictionary objectForKey:TIME_KEY]];
		self.hasFood = [NSNumber numberWithInt:[[dictionary objectForKey:HAS_FOOD_KEY] boolValue]];
		self.hasSpeaker = [NSNumber numberWithInt:[[dictionary objectForKey:HAS_SPEAKER_KEY]boolValue]];
		self.speakerName = [dictionary objectForKey:SPEAKER_KEY];
		self.topic = [dictionary objectForKey:TOPIC_KEY];
        self.dateUnformatted = [dictionary objectForKey:@"date"];
        
        // Protection on coordinate.
        if ([dictionary objectForKey:@"xcoordinate"] && [dictionary objectForKey:@"ycoordinate"]) {
            self.loc = CLLocationCoordinate2DMake([[dictionary objectForKey:@"xcoordinate"] doubleValue], [[dictionary objectForKey:@"ycoordinate"] doubleValue]);
        }
        
        self.description = [dictionary objectForKey:DESCRIPTION_KEY];

	}
	return self;
}

- (NSDictionary *)meetingDictionary {
	NSMutableDictionary *meetingDict = [NSMutableDictionary dictionaryWithCapacity:4];
	[meetingDict setObject:self.day forKey:DAY_KEY];
	[meetingDict setObject:self.speakerName forKey:SPEAKER_KEY];
	[meetingDict setObject:self.topic forKey:TOPIC_KEY];
	[meetingDict setObject:self.description forKey:DESCRIPTION_KEY];
	
	return [meetingDict copy];
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
