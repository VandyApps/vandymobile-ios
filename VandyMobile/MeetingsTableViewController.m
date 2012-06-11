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

@interface MeetingsTableViewController ()

@end

@implementation MeetingsTableViewController
@synthesize tableView = _tableView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize nextMeetingImageView = _nextMeetingImageView;
@synthesize nextMeetingTopic = _nextMeetingTopic;
@synthesize nextMeetingTime = _nextMeetingTime;
@synthesize nextMeetingButton = _nextMeetingButton;
@synthesize nextMeeting = _nextMeeting;
@synthesize results = _results;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    //self.title = [self.tabBarItem title];
    [super viewDidLoad];
    
    // Create resizable UINavigationBar image
    UIImage *navImage = [UIImage imageNamed:@"NewNavBar4"];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
	
	// Create add meeting button
	UIBarButtonItem *addMeetingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																					  target:self 
																					  action:@selector(addMeeting)];
	[self.navigationItem setRightBarButtonItem:addMeetingButton animated:NO];
    
	// Status indicator. Takes place of network spinner and if no meetings are loaded
	[SVProgressHUD showWithStatus:@"Loading meetings..." maskType:SVProgressHUDMaskTypeNone];
    
    self.tableView.rowHeight = 50;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    self.nextMeetingImageView.image = [UIImage imageNamed:@"NextMeetingCanvasV2"];
    
	[[MeetingsAPIClient sharedInstance] getPath:@"meetings.json" parameters:nil
                                        success:^(AFHTTPRequestOperation *operation, id response) {
//											NSLog(@"Response: %@", response);
											NSMutableArray *results = [NSMutableArray array];
											for (id meetingDictionary in response) {
												Meeting *meeting = [[Meeting alloc] initWithDictionary:meetingDictionary];
												[results addObject:meeting];
											}
											self.results = results;
                                            [self sortDates];
											[self addNextMeetingCell];
                                                                                       
											[self.tableView reloadData];
											[SVProgressHUD dismissWithSuccess:@"Done!"];
										}
										failure:^(AFHTTPRequestOperation *operation, NSError *error) {
											NSLog(@"Error fetching meetings!");
											NSLog(@"%@",error);
											[SVProgressHUD dismissWithError:@"Error loading meetings!"];
                                                NSLog(@"Loading meetings from User Defaults...");
                                                self.results = [[NSUserDefaults standardUserDefaults] objectForKey:@"meetings"];
                                                NSLog(@"...Done!");
										}];
    
}

- (void)sortDates {
	// Sort array by date
	NSMutableArray *copy = [self.results mutableCopy];
	self.results = [copy sortedArrayUsingComparator:^(id a, id b) {
		NSDate *first = [(Meeting*)a dateUnformatted];
		NSDate *second = [(Meeting*)b dateUnformatted];
		return [first compare:second];
	}];
}

- (void)addNextMeetingCell {
	self.nextMeeting = [self.results objectAtIndex:0];
	NSMutableArray *temp = [self.results mutableCopy];
	[temp removeObject:self.nextMeeting];
	self.results = temp;
	self.nextMeetingTopic.text = self.nextMeeting.topic;
	//NSDate *nextMeetingDate = self.nextMeeting.dateUnformatted;
	//NSTimeInterval interval = [nextMeetingDate timeIntervalSince1970] - [[NSDate date] timeIntervalSince1970];
	
	//if ((double)interval < 86400) {
	//    self.nextMeetingTime.text = [NSString stringWithFormat:@"Today at %@", self.nextMeeting.time];
	//}
	self.nextMeetingTime.text = [NSString stringWithFormat:@"%@ at %@", self.nextMeeting.date, self.nextMeeting.time];
    self.nextMeetingButton.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setBackgroundImageView:nil];
    [self setNextMeetingImageView:nil];
    [self setNextMeetingTopic:nil];
    [self setNextMeetingTime:nil];
    [self setNextMeetingButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillAppear:(BOOL)animated {
    // Set the background image for *all* UINavigationBars
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewNavBarText"]];
    if ([[self.navigationController.navigationBar subviews] count] > 2) {
        
        NSArray *navSubviews = [self.navigationController.navigationBar subviews];
        
        //        NSLog(@"%@", navSubviews);
        
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

- (void)addMeeting {
	AddMeetingViewController *addMeetingVC = [[AddMeetingViewController alloc] initWithNibName:@"AddMeetingViewController" bundle:nil];
	[self.navigationController pushViewController:addMeetingVC animated:YES];
}

#pragma mark - TableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.results count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        Meeting *meeting = [self.results objectAtIndex:indexPath.row];
        cell.textLabel.text = meeting.topic;
        if([meeting.topic isEqualToString:@""]) {
            cell.textLabel.text = @"Work day";
        }
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", meeting.date, meeting.time];
        
        CGRect myFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"125-food"]].frame;
        
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
        cell.imageView.frame = myFrame;
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
        
        UIView *goldenColor = [[UIView alloc] init];
        goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
        cell.selectedBackgroundView = goldenColor;
	}
	
	return cell;
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
