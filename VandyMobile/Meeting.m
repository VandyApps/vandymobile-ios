//
//  Meeting.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"

#define DAY_KEY @"day"
#define X_COORDINATE_KEY @"xcoordinate"
#define Y_COORDINATE_KEY @"ycoordinate"
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
@synthesize meetingDescription = _meetingDescription;
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
        id messyDate = [dictionary objectForKey:DATE_KEY];
        
        // Protection on coordinate.
        if ([[dictionary objectForKey:@"xcoordinate"] isKindOfClass:[NSNumber class]] && [[dictionary objectForKey:@"ycoordinate"] isKindOfClass:[NSNumber class]]) {
            NSNumber *latWrapper = [dictionary objectForKey:@"xcoordinate"];
            NSNumber *longWrapper = [dictionary objectForKey:@"ycoordinate"];
            CLLocationDegrees latitude = [latWrapper doubleValue];
            CLLocationDegrees longitude = [longWrapper doubleValue];
            self.loc = CLLocationCoordinate2DMake(latitude, longitude);
        } else self.loc = CLLocationCoordinate2DMake(0, 0);
        
        // Format date properly
        self.meetingDescription = [dictionary objectForKey:DESCRIPTION_KEY];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        
        NSDate *date = [dateFormatter dateFromString:messyDate];
        self.dateUnformatted = date;

	}
	return self;
}

- (NSString *)description {
	return [[self meetingDictionary] description];
}

- (NSDictionary *)meetingDictionary {
	NSMutableDictionary *meetingDict = [NSMutableDictionary dictionaryWithCapacity:4];
	[meetingDict setObject:self.day forKey:DAY_KEY];
	[meetingDict setObject:[NSNumber numberWithFloat:36.143566] forKey:X_COORDINATE_KEY];
	[meetingDict setObject:[NSNumber numberWithFloat:-86.805906] forKey:Y_COORDINATE_KEY];
	[meetingDict setObject:self.date forKey:DATE_KEY];
	[meetingDict setObject:self.hasFood forKey:HAS_FOOD_KEY];
	[meetingDict setObject:self.hasSpeaker forKey:HAS_SPEAKER_KEY];
	[meetingDict setObject:self.speakerName forKey:SPEAKER_KEY];
	[meetingDict setObject:self.topic forKey:TOPIC_KEY];
	[meetingDict setObject:self.meetingDescription forKey:DESCRIPTION_KEY];
	
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
