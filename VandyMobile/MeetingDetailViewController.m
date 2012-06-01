//
//  MeetingDetailViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 5/28/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "MeetingDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "VMAnnotation.h"

@interface MeetingDetailViewController ()

@end

@implementation MeetingDetailViewController

@synthesize meeting = _meeting;

@synthesize mapView = _mapView;
@synthesize speakerLabel = _speakerLabel;
@synthesize dateLabel = _dateLabel;
@synthesize timeLabel = _timeLabel;
@synthesize foodLabel = _foodLabel;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize checkInButton = _checkInButton;
@synthesize addToCalendarButton = _addToCalendarButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // UI Customization
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"VandyMobileBackgroundV2"]];
    
    // Round corners of description label (QuartzCore)
    self.descriptionLabel.layer.cornerRadius = 11;
    self.descriptionLabel.clipsToBounds = YES;
    self.descriptionLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descriptionLabel.layer.borderWidth = .5;
    
    // Round corners of map view (QuartzCore)
    self.mapView.layer.cornerRadius = 11;
    self.mapView.clipsToBounds = YES;
    self.mapView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.mapView.layer.borderWidth = .5;
    
    // Zoom MapView to coordinates
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 36.143566;
    zoomLocation.longitude= -86.805906;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.75*METERS_PER_MILE, 0.75*METERS_PER_MILE);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES]; 
    
    // Set annotation in MapView
    VMAnnotation *anno = [[VMAnnotation alloc] init];
    [anno setCoordinate:CLLocationCoordinate2DMake(36.143566, -86.805906)]; 
    [anno setTitle:@"Test Title"];
    [anno setSubtitle:@"Test Subtitle"];
    [self.mapView addAnnotation:anno];
    
    // Set speaker name, or "General Meeting" if no speaker
    if (self.meeting.hasSpeaker) {
        self.speakerLabel.text = self.meeting.speakerName;
    } else {
        self.speakerLabel.text = @"General Meeting";
    }
    
    // Set date, time, and food served
    self.dateLabel.text = self.meeting.date;
    self.timeLabel.text = self.meeting.time;
    if (!self.meeting.hasFood) {
        self.foodLabel.hidden = YES;
    }
    
    // Set description text
    self.descriptionLabel.text = self.meeting.topic;
}


- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setSpeakerLabel:nil];
    [self setDateLabel:nil];
    [self setTimeLabel:nil];
    [self setFoodLabel:nil];
    [self setDescriptionLabel:nil];
    [self setCheckInButton:nil];
    [self setCheckInButton:nil];
    [self setAddToCalendarButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
