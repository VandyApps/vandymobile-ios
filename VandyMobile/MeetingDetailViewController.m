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
#import <EventKit/EventKit.h>
#import "Sizer.h"

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
@synthesize backgroundView = _backgroundView;
@synthesize belowTextViewContainerView = _belowTextViewContainerView;

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
    self.backgroundView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NewNavBar4"] forBarMetrics:UIBarMetricsDefault];
    

    
    // Move buttons to match
    
    // Round corners of description label (QuartzCore)
    self.descriptionLabel.layer.cornerRadius = 11;
    self.descriptionLabel.clipsToBounds = YES;
    self.descriptionLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descriptionLabel.layer.borderWidth = .75;

    
    // Zoom MapView to coordinates
    if (CLLocationCoordinate2DIsValid(self.meeting.loc)) {
        // Round corners of map view (QuartzCore)
        self.mapView.layer.cornerRadius = 11;
        self.mapView.clipsToBounds = YES;
        self.mapView.layer.borderColor = [[UIColor grayColor] CGColor];
        self.mapView.layer.borderWidth = .75;
        
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = self.meeting.loc.latitude;
        zoomLocation.longitude= self.meeting.loc.longitude;
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.75*METERS_PER_MILE, 0.75*METERS_PER_MILE);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:YES];
        self.mapView.userInteractionEnabled = NO;

    } else {
        self.mapView.hidden = YES;
    }
    
    // Set annotation in MapView
    VMAnnotation *anno = [[VMAnnotation alloc] init];
    [anno setCoordinate:self.meeting.loc]; 
//    [anno setTitle:@"Test Title"];
//    [anno setSubtitle:@"Test Subtitle"];
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
    if ([self.meeting.hasFood doubleValue] == 0) {
        self.foodLabel.hidden = YES;
    }
    
    // Set description text
    self.descriptionLabel.text = self.meeting.description;
    
    // Share button
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
																					  target:self 
																					  action:@selector(sharePressed)];
	[self.navigationItem setRightBarButtonItem:shareButton animated:NO];
    
    // Description Sizer
    self.descriptionLabel.frame = [Sizer sizeTextView:self.descriptionLabel withMaxHeight:126];
    CGFloat newYOrigin = self.descriptionLabel.frame.origin.y + self.descriptionLabel.frame.size.height + 8;
    self.belowTextViewContainerView.frame = CGRectMake(self.belowTextViewContainerView.frame.origin.x,
                                                       newYOrigin,
                                                       self.belowTextViewContainerView.frame.size.width,
                                                       self.belowTextViewContainerView.frame.size.height) ;
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *navSubviews = [self.navigationController.navigationBar subviews];
//    NSLog(@"%@", navSubviews);
    for (UIView * subview in navSubviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview != [navSubviews objectAtIndex:0]) {
            [subview removeFromSuperview];
        }
    }
}

- (IBAction)sharePressed {
}

- (IBAction)addToCalendarPressed {
    
    // New event
    EKEventStore *eventDB = [[EKEventStore alloc] init];
    EKEvent *myEvent = [EKEvent eventWithEventStore:eventDB];
    
    // Name is topic
    myEvent.title = self.meeting.topic;

    // Starts at date, hour is pre-allocated
    myEvent.startDate = self.meeting.dateUnformatted;
    myEvent.endDate = [NSDate dateWithTimeInterval:3600 sinceDate:self.meeting.dateUnformatted];
    
    // Not all day
    myEvent.allDay = NO;
    
    // Notes are meeting description
    myEvent.notes = self.meeting.description;
    
    // Create the calendar
    [myEvent setCalendar:[eventDB defaultCalendarForNewEvents]];
    
    NSError *err;
    
    [eventDB saveEvent:myEvent span:EKSpanThisEvent error:&err]; 
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"Event added!"
                          message:[NSString stringWithFormat:@"%@ added to calendar.", myEvent.title]
                          delegate:nil
                          cancelButtonTitle:@"Okay"
                          otherButtonTitles:nil];
    [alert show];
	
}

- (IBAction)checkInPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@":-(" message:@"Feature not yet supported." delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
    
    [alert show];
}

- (IBAction)showOnMapPressed:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Load Maps?" message:@"Showing the map will exit VandyMobile and load Maps. Are you sure you want to proceed?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Show Maps", @"Show Directions", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        return;
    }
    
    NSString *googleMapsURLString;
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    if (buttonIndex == 2) {
        googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/maps?dq=Current Location,q=%1.6f,%1.6f", self.meeting.loc.latitude, self.meeting.loc.longitude];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not working. :(" message:@"Cry more." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
    else {
        googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%1.6f,%1.6f", self.meeting.loc.latitude, self.meeting.loc.longitude];
    }

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
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
    [self setBackgroundView:nil];
    [self setBelowTextViewContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
