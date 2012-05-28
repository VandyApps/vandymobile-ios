//
//  MeetingDetailViewController.h
//  VandyMobile
//
//  Created by Scott Andrus on 5/28/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Meeting.h"

@interface MeetingDetailViewController : UIViewController

//@property (strong, nonatomic) NSDate *created;
//@property (strong, nonatomic) NSDate *date;
//@property (strong, nonatomic) NSString *dayOfWeek;
//@property BOOL food;
//@property BOOL speaker;
//@property (strong, nonatomic) NSString *speakerName;
//@property (strong, nonatomic) NSString *topic;
//@property (strong, nonatomic) NSString *updatedAt;

@property (strong, nonatomic) Meeting *meeting;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *speakerLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *foodLabel;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *checkInButton;
@property (weak, nonatomic) IBOutlet UIButton *addToCalendarButton;

@end
