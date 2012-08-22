//
//  VMMeetingsTableViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MeetingsTableViewController.h"
#import "AFNetworking.h"
#import "VMAPIClient.h"
#import "Meeting.h"
#import "MeetingDetailViewController.h"
#import "AddMeetingViewController.h"
#import "JSONKit.h"
#import "VMCell.h"
#import "User.h"
#import <QuartzCore/QuartzCore.h>
#import "FirstTimeViewController.h"
#import "UIViewController+Overview.h"
#import "SectionHeaderView.h"
#import "UIView+Frame.h"

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
@synthesize nextMeetingMapButtonContainerView = _nextMeetingMapButtonContainerView;
@synthesize nextMeetingLabel = _nextMeetingLabel;
@synthesize nextMeeting = _nextMeeting;
@synthesize results = _results;
@synthesize sectionedResults = _sectionedResults;
@synthesize hasShownIntro = _hasShownIntro;

#pragma mark - Notifications

- (void)setupNotifications {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleUserLoggedIn)
												 name:@"loggedIn" 
											   object:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleUserLoggedOut)
												 name:@"loggedOut" 
											   object:nil];
}

- (void)handleUserLoggedIn {
//	[self addNextMeetingCell];
}

- (void)handleUserLoggedOut {
//	[self addNextMeetingCell];
}

- (void)setupNextMeetingHeaderView {
    [self addShadowToView:self.nextMeetingButton withOpacity:.9];
    self.nextMeetingButton.layer.shouldRasterize = YES;
//    self.nextMeetingButton.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1];
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
    
    [self setupNextMeetingHeaderView];
	
    // Customize backgrounds
    self.backgroundImageView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    
    // Hide meeting until data is loaded
    self.nextMeetingImageView.hidden = YES;
    self.nextMeetingCheckInButton.hidden = YES;
    self.nextMeetingMapButton.hidden = YES;
    self.nextMeetingLabel.hidden = YES;
    self.tableView.hidden = YES;
//
//    self.nextMeetingMapButton.layer.borderColor = [[UIColor grayColor] CGColor];
//    self.nextMeetingMapButton.layer.borderWidth = .8;
//    self.nextMeetingMapButton.layer.cornerRadius = 3;
//    self.nextMeetingMapButton.clipsToBounds = YES;
//
    
	[self pullMeetingsFromCacheWithFailureCallBack:^{
        [SVProgressHUD showWithStatus:@"Loading meetings..." maskType:SVProgressHUDMaskTypeNone];
    }];
    [self pullMeetingsFromServer]; 
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)showIntro {
    FirstTimeViewController *ftvc = [[FirstTimeViewController alloc] initWithNibName:@"FirstTimeViewController" bundle:nil andNumberOfSlides:6];
    [self.tabBarController presentOverviewController:ftvc withOpacity:.7 animated:YES];
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
																					  action:@selector(refreshMeetingsTapped)];
	[self.navigationItem setRightBarButtonItem:addMeetingButton animated:NO];
}

- (void)refreshMeetingsTapped {
    [SVProgressHUD show];
    [self pullMeetingsFromServer];
}


- (void)pullMeetingsFromServer {
	// Status indicator. Takes place of network spinner and if no meetings are loaded
	[[VMAPIClient sharedInstance] getPath:@"meetings.json" parameters:nil
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
											
                                            [self sortMeetings];
                                            [self.tableView reloadData];
											[SVProgressHUD dismissWithSuccess:@"Done!"];
                                            self.tableView.hidden = NO;
                                            
                                            if (!self.hasShownIntro) {
                                                [self showIntro];
                                                self.hasShownIntro = YES;
                                                UIButton *button = [UIButton buttonWithType:UIButtonTypeInfoLight];
                                                button.imageEdgeInsets = UIEdgeInsetsMake(0, 7, 0, -7);
                                                button.showsTouchWhenHighlighted = NO;
                                                [button addTarget:self action:@selector(showIntro) forControlEvents:UIControlEventTouchUpInside];
                                                [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:button]];
                                                
                                            }
										}
										failure:^(AFHTTPRequestOperation *operation, NSError *error) {
											[SVProgressHUD dismissWithError:@"Error updating meetings" afterDelay:3];
											NSLog(@"%@",error);
										}];
    

}

- (void)pullMeetingsFromCacheWithFailureCallBack:(void(^)(void))callBack {
	NSString *path = @"http://foo:bar@70.138.50.84/meetings.json";
	NSURLRequest *request = [[VMAPIClient sharedInstance] requestWithMethod:@"GET" path:path parameters:nil];
	NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
	if (response) {
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
        [self sortMeetings];
        [self.tableView reloadData];
	} else {
        /* If nothing is cached */
        callBack();
    }
    
}

- (void)sortMeetings {
    self.sectionedResults = [NSArray arrayWithObjects:[NSMutableOrderedSet orderedSet], [NSMutableOrderedSet orderedSet], [NSMutableOrderedSet orderedSet], [NSMutableOrderedSet orderedSet], nil];
    
    for (Meeting *meeting in self.results) {
        [self sortMeeting:meeting inResults:self.sectionedResults];
    }
    NSMutableArray *remover = [self.sectionedResults mutableCopy];
    for (NSMutableOrderedSet *section in self.sectionedResults) {
        if (section.count == 0) {
            [remover removeObject:section];
        }
    }
    self.sectionedResults = [remover copy];
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
    
    [self addShadowToView:self.nextMeetingMapButtonContainerView withOpacity:.95];
}

- (void)addShadowToView:(UIView *)view withOpacity:(CGFloat)opacity {
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    if (opacity > 1) opacity = 1;
    else if (opacity < 0) opacity = 0;
    view.layer.shadowOpacity = opacity;
    view.layer.shadowRadius = 2.0;
    view.layer.shadowOffset = CGSizeMake(-1, 1);
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
    [self setNextMeetingMapButtonContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)viewWillAppear:(BOOL)animated {
    
    // Set the logo on the navigation bar
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VandyMobileTextNeue"]];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionedResults.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [[self.sectionedResults objectAtIndex:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return @"Today";
//            break;
//        case 1:
//            return @"Tomorrow";
//            break;
//        case 2:
//            return @"This week";
//            break;
//        case 3:
//            return @"Later";
//            break;
//        default:
//            break;
//    }
//    return @"ERROR";
    return [self timeframeOfMeeting:[[self.sectionedResults objectAtIndex:section] firstObject]];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
	return 25;
}

- (UIView *)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    
//    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 360, 25)] ;
    SectionHeaderView *container = [[SectionHeaderView alloc] init];
    
    // Load the top-level objects from the custom cell XIB.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SectionHeaderView" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    container = [topLevelObjects objectAtIndex:0];
    
    container.layer.borderColor = [UIColor grayColor].CGColor;
    container.layer.borderWidth = 0.5f;
    
    
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,0,360, 25)] ;
//    headerLabel.backgroundColor = [UIColor clearColor];
//    headerLabel.font = [UIFont boldSystemFontOfSize:19.0f];
//    headerLabel.shadowOffset = CGSizeMake(1, 1);
//    headerLabel.textColor = [UIColor whiteColor];
//    headerLabel.shadowColor = [UIColor darkGrayColor];
    NSString *title = [self tableView:self.tableView titleForHeaderInSection:section];
    container.label.text = title;
//    [container addSubview:headerLabel];
    [self addShadowToView:container withOpacity:.8];
    return container;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	
	VMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[VMCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
    
//	Meeting *meeting = [self.results objectAtIndex:indexPath.row];
    Meeting *meeting = [[self.sectionedResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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
//    UIImageView *goldenColor = [[UIImageView alloc] init];
//	goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
//    goldenColor.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//	self.nextMeetingImageView = goldenColor;
    
    // Create new MeetingDVC
    MeetingDetailViewController *meetingDVC = [[MeetingDetailViewController alloc] init];
    
    // Prepare meetingDVC with next meeting
    meetingDVC.title = self.nextMeeting.topic;
    meetingDVC.meeting = self.nextMeeting;
    [self.navigationController pushViewController:meetingDVC animated:YES];
}

- (NSString *)checkMeetingDateOfMeeting:(Meeting *)meeting {
    NSDictionary *dict = [self dateInfoFromMeeting:meeting];
    NSDate *now = [dict objectForKey:@"now"];
    NSString *dayOfWeek = [dict objectForKey:@"englishWeekday"];
    NSInteger weekday = [[dict objectForKey:@"meetingWeekday"] integerValue];
    NSInteger currentDay = [[dict objectForKey:@"currentWeekday"] integerValue];
    
    // If date is now
    if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 2)) {
        self.nextMeetingCheckInButton.hidden = YES;
        self.nextMeetingMapButton.hidden = YES;
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
        return [NSString stringWithFormat:@"%@ at %@", meeting.date, meeting.time];
    }

}

- (NSString *)timeframeOfMeeting:(Meeting *)meeting {
    NSDictionary *dict = [self dateInfoFromMeeting:meeting];
    NSDate *now = [dict objectForKey:@"now"];
    NSInteger weekday = [[dict objectForKey:@"meetingWeekday"] integerValue];
    NSInteger currentDay = [[dict objectForKey:@"currentWeekday"] integerValue];
    
    NSInteger index;
    
    // If date is today
    if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24) && currentDay == weekday) {
        index = 0;
    }
    // If date is tomorrow
    else if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24 * 2) && currentDay + 1 == weekday) {
        index = 1;
    }
    // If date is in the next week
    else if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24 * 7)) {
        index = 2;
    }
    else {
        index = 3;
    }
    
    switch (index) {
        case 0:
            return @"Today";
            break;
        case 1:
            return @"Tomorrow";
            break;
        case 2:
            return @"This week";
            break;
        case 3:
            return @"Later";
            break;
        default:
            break;
    }
    return @"ERROR";
}

- (void)sortMeeting:(Meeting *)meeting inResults:(NSArray *)sectionedResults {
    
    NSDictionary *dict = [self dateInfoFromMeeting:meeting];
    NSDate *now = [dict objectForKey:@"now"];
    NSInteger weekday = [[dict objectForKey:@"meetingWeekday"] integerValue];
    NSInteger currentDay = [[dict objectForKey:@"currentWeekday"] integerValue];
    
    NSInteger index;
    
    // If date is today
    if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24) && currentDay == weekday) {
        index = 0;
    }
    // If date is tomorrow
    else if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24 * 2) && currentDay + 1 == weekday) {
        index = 1;
    }
    // If date is in the next week
    else if ([meeting.dateUnformatted timeIntervalSinceDate:now] < (60 * 60 * 24 * 7)) {
        index = 2;
    }
    else {
        index = 3;
    }
    
    BOOL shouldAdd = YES;
    for (NSMutableOrderedSet *section in sectionedResults) {
        if (([sectionedResults indexOfObjectIdenticalTo:section] == index)) {
            for (Meeting *otherMeeting in section) {
                if ([otherMeeting.dateUnformatted isEqualToDate:meeting.dateUnformatted]) {
                    shouldAdd = NO;
                }
            }
            if (shouldAdd) {
                [[sectionedResults objectAtIndex:index] addObject:meeting];
            }
        }
        else if ([section containsObject:meeting]) {
            [section removeObject:meeting];
        }
    }
}

- (NSDictionary *)dateInfoFromMeeting:(Meeting *)meeting {
    
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
    
    return [NSDictionary dictionaryWithObjectsAndKeys:dayOfWeek, @"englishWeekday", [NSNumber numberWithInt:weekday], @"meetingWeekday", [NSNumber numberWithInt:currentDay], @"currentWeekday", now, @"now", nil];
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
    Meeting *meeting = [[self.sectionedResults objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
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
