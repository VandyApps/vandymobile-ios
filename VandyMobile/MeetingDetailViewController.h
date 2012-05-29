//
//  MeetingDetailViewController.h
//  VandyMobile
//
//  Created by Scott Andrus on 5/28/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Meeting.h"

#define METERS_PER_MILE 1609.344

@interface MeetingDetailViewController : UIViewController <MKMapViewDelegate>

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
