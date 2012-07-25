//
//  VMMeetingsTableViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeetingsTableViewController.h"
#import "AFNetworking.h"
#import "MeetingsAPIClient.h"
#import "Meeting.h"
#import "MeetingDetailViewController.h"
#import "AddMeetingViewController.h"
#import "JSONKit.h"
#import "VMCell.h"
#import "User.h"

@interface MeetingsTableViewController ()

@end

@implementation MeetingsTableViewController
@synthesize tableView = _tableView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize nextMeetingImageView = _nextMeetingImageView;
@synthesize nextMeetingTopic = _nextMeetingTopic;
@synthesize nextMeetingTime = _nextMeetingTime;
@synthesize nextMeetingButton = _nextMeetingButton;
@synthesize nextMeetingCheckInButton = _nextMeetingCheckInButton;
@synthesize nextMeetingMapButton = _nextMeetingMapButton;
@synthesize nextMeetingLabel = _nextMeetingLabel;
@synthesize nextMeeting = _nextMeeting;
@synthesize results = _results;


#pragma mark - Notifications

- (void)setupNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleUserLoggedIn)
												 name:@"loggedIn" 
											   object:self];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleUserLoggedOut)
												 name:@"loggedOut" 
											   object:self];
}

- (void)handleUserLoggedIn {
	[self addNextMeetingCell];
}

- (void)handleUserLoggedOut {
	[self addNextMeetingCell];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    //self.title = [self.tabBarItem title];
    [super viewDidLoad];
	
	[self setupNotifications];
    
    // Create resizable UINavigationBar image
    UIImage *navImage = [UIImage imageNamed:@"NewNavBar4"];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
	
	// Creates refresh meetings button in navbar
    [self setupRefreshMeetingsButton];
	
    // Customize backgrounds
    self.backgroundImageView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    
    // Hide meeting until data is loaded
    self.nextMeetingImageView.hidden = YES;
    self.nextMeetingCheckInButton.hidden = YES;
    self.nextMeetingMapButton.hidden = YES;
    self.nextMeetingLabel.hidden = YES;
    self.tableView.hidden = YES;
    
	[self pullMeetingsFromCache];
    [self pullMeetingsFromServer];

}

- (void)setupCreateMeetingButton {
	// Create add meeting button
	UIBarButtonItem *addMeetingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																						  target:self 
																						  action:@selector(createMeeting)];
	[self.navigationItem setRightBarButtonItem:addMeetingButton animated:NO];
}

- (void)setupRefreshMeetingsButton {
	// Create add meeting button
	UIBarButtonItem *addMeetingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
																					  target:self 
																					  action:@selector(pullMeetingsFromServer)];
	[self.navigationItem setRightBarButtonItem:addMeetingButton animated:NO];
}


- (void)pullMeetingsFromServer {
	// Status indicator. Takes place of network spinner and if no meetings are loaded
	[SVProgressHUD showWithStatus:@"Loading meetings..." maskType:SVProgressHUDMaskTypeNone];
	[[MeetingsAPIClient sharedInstance] getPath:@"meetings.json" parameters:nil
                                        success:^(AFHTTPRequestOperation *operation, id response) {
											//											NSLog(@"Response: %@", response);
											NSMutableArray *results = [NSMutableArray array];
											for (id meetingDictionary in response) {
												Meeting *meeting = [[Meeting alloc] initWithDictionary:meetingDictionary];
												[results addObject:meeting];
//												NSLog(@"meeting = %@", meeting);
											}
											self.results = results;
											[self addNextMeetingCell];
											
											[self.tableView reloadData];
											[SVProgressHUD dismissWithSuccess:@"Done!"];
                                            self.tableView.hidden = NO;
										}
										failure:^(AFHTTPRequestOperation *operation, NSError *error) {
											[SVProgressHUD dismissWithError:@"Error updating meetings" afterDelay:3];
											NSLog(@"%@",error);
										}];
}

- (void)pullMeetingsFromCache {
	NSString *path = @"http://70.138.50.84/meetings.json";
	NSURLRequest *request = [[MeetingsAPIClient sharedInstance] requestWithMethod:@"POST" path:path parameters:nil];
	NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
	NSData *responseData = response.data;
	id meetingObject = [[JSONDecoder decoder] objectWithData:responseData];

	NSMutableArray *results = [NSMutableArray array];
	for (id meetingDictionary in meetingObject) {
		Meeting *meeting = [[Meeting alloc] initWithDictionary:meetingDictionary];
		[results addObject:meeting];
	}
	self.results = results;
	[self addNextMeetingCell];
	[self.tableView setHidden:NO];
	[self.tableView reloadData];
}


- (void)addNextMeetingCell {
    // Grab the next meeting
	self.nextMeeting = [self.results objectAtIndex:0];
	NSMutableArray *temp = [self.results mutableCopy];
    
    // Remove it from the meeting list
	[temp removeObject:self.nextMeeting];
	self.results = temp;
    
    // Create fake "cell"
	self.nextMeetingTopic.text = self.nextMeeting.topic;
	self.nextMeetingTime.text = [self checkMeetingDateOfMeeting:self.nextMeeting];
    self.nextMeetingImageView.image = [UIImage imageNamed:@"NextMeetingCanvasV2"];
    // Unhide labels / "cell" components
    self.nextMeetingImageView.hidden = NO;
    self.nextMeetingMapButton.hidden = NO;
    
//	if ([User loggedIn]) {
//		self.nextMeetingCheckInButton.hidden = NO;
//	} else {
//		self.nextMeetingCheckInButton.hidden = YES;
//	}
    
    self.nextMeetingLabel.hidden = NO;
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setBackgroundImageView:nil];
    [self setNextMeetingImageView:nil];
    [self setNextMeetingTopic:nil];
    [self setNextMeetingTime:nil];
    [self setNextMeetingButton:nil];
    [self setNextMeetingCheckInButton:nil];
    [self setNextMeetingMapButton:nil];
    [self setNextMeetingLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillAppear:(BOOL)animated {
    
    // Set the logo on the navigation bar
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewNavBarText"]];
    if ([[self.navigationController.navigationBar subviews] count] > 2) {
        NSArray *navSubviews = [self.navigationController.navigationBar subviews];
        
        for (UIView * subview in navSubviews) {
            if ([subview isKindOfClass:[UIImageView class]] && subview != [navSubviews objectAtIndex:0]) {
                [subview removeFromSuperview];
            }
        }
    }
    [self.navigationController.navigationBar addSubview:logo];
}

- (Meeting *)nextMeeting {
    if (!_nextMeeting) {
        _nextMeeting = [[Meeting alloc] init];
    }
    return _nextMeeting;
}

- (void)createMeeting {
	AddMeetingViewController *addMeetingVC = [[AddMeetingViewController alloc] initWithCompletionBlock:^ {
		[self pullMeetingsFromServer];
	}];
    
    // Non-modal
    [self.navigationController pushViewController:addMeetingVC animated:YES];
    
    // Modal
//	[self.navigationController presentModalViewController:addMeetingVC animated:YES];
}

#pragma mark - TableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.results count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	
	VMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[VMCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	Meeting *meeting = [self.results objectAtIndex:indexPath.row];
	cell.textLabel.text = meeting.topic;
	if([meeting.topic isEqualToString:@""]) {
		cell.textLabel.text = @"Working Meeting";
	}
	
	cell.detailTextLabel.text = [self checkMeetingDateOfMeeting:meeting];
	
	[cell configureCellForTableView:self.tableView atIndexPath:indexPath];   
	
	return cell;
}

- (UITableViewCell *)setImageOfCell:(UITableViewCell *)cell forAssociatedMeeting:(Meeting *)meeting {
// Code to set cell image (broken)
    
    CGSize size = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"112-group.png"]].frame.size;
    
    UIImage *image;
    if ([meeting.hasFood boolValue]) {
        if ([meeting.hasSpeaker boolValue]) {
            image = [UIImage imageNamed:@"bullhorn-food-combo"];
        }
        else {
            image = [UIImage imageNamed:@"125-food.png"];
        }
    } else if ([meeting.hasSpeaker boolValue]) {
        image = [UIImage imageNamed:@"124-bullhorn.png"];
    } else {
        image = [UIImage imageNamed:@"112-group.png"];
    }
    
    cell.imageView.image = image;
    cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, size.width, size.height);
    return cell;
}

- (IBAction)nextMeetingButtonPressed:(UIButton *)sender {
    // Create new MeetingDVC
    MeetingDetailViewController *meetingDVC = [[MeetingDetailViewController alloc] init];
    
    // Prepare meetingDVC with next meeting
    meetingDVC.title = self.nextMeeting.topic;
    meetingDVC.meeting = self.nextMeeting;
    [self.navigationController pushViewController:meetingDVC animated:YES];
}

- (NSString *)checkMeetingDateOfMeeting:(Meeting *)meeting {
    
    NSDate *now = [NSDate date];
    
    // Get the date's weekday
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSWeekdayCalendarUnit) fromDate:meeting.dateUnformatted];
    NSInteger weekday = [weekdayComponents weekday];
    NSString *dayOfWeek;
    
    // Discover what weekday it is
    if (weekday == 1) dayOfWeek = @"Sunday";
    else if (weekday == 2) dayOfWeek = @"Monday";
    else if (weekday == 3) dayOfWeek = @"Tuesday";
    else if (weekday == 4) dayOfWeek = @"Wednesday";
    else if (weekday == 5) dayOfWeek = @"Thursday";
    else if (weekday == 6) dayOfWeek = @"Friday";
    else if (weekday == 7) dayOfWeek = @"Saturday";
    else dayOfWeek = @"error";
    
    NSDateComponents *currentComponents = [gregorian components:(NSWeekdayCalendarUnit) fromDate:now];
    NSInteger currentDay = [currentComponents weekday];
    
    // If date is now
    if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 2)) {
        self.nextMeetingCheckInButton.hidden = NO;
    }
    // If date is today
    if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24) && currentDay == weekday) {
        return [NSString stringWithFormat:@"%@ %@", @"Today at", meeting.time];
    }
    
    // If date is tomorrow
    else if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24 * 2) && currentDay + 1 == weekday) {
        return [NSString stringWithFormat:@"%@ %@", @"Tomorrow at", meeting.time];
    }
    
    // If date is in the next week
    else if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24 * 7)) {
        return [NSString stringWithFormat:@"%@ at %@", dayOfWeek, meeting.time];
    }
    else {
        return [NSString stringWithFormat:@"%@, %@", meeting.date, meeting.time];
    }

}

- (IBAction)nextMeetingMapPressed {
    
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
        googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/maps?dq=Current Location,q=%1.6f,%1.6f", self.nextMeeting.loc.latitude, self.nextMeeting.loc.longitude];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not working. :(" message:@"Cry more." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
    else {
        googleMapsURLString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%1.6f,%1.6f", self.nextMeeting.loc.latitude, self.nextMeeting.loc.longitude];
    }
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:googleMapsURLString]];
}

#pragma mark - TableViewDelegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    // Deselect the row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Create new MeetingDVC
    MeetingDetailViewController *meetingDVC = [[MeetingDetailViewController alloc] init];
    
    // Grab the meeting at the index path
    Meeting *meeting = [self.results objectAtIndex:indexPath.row];
    
    // Prepare meetingDVC
    meetingDVC.title = meeting.topic;
    meetingDVC.meeting = meeting;
    [self.navigationController pushViewController:meetingDVC animated:YES];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
