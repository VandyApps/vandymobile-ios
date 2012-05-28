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

@interface MeetingsTableViewController ()

@end

@implementation MeetingsTableViewController
@synthesize tableView = _tableView;
@synthesize loadMeetings = _loadMeetings;
@synthesize results = _results;

#pragma mark - View Life Cycle

- (void)viewDidLoad
{
    self.title = [self.tabBarItem title];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
    // Prepare failure subview
    UILabel *noMeetingsMessage = [[UILabel alloc] initWithFrame:self.view.frame];
    noMeetingsMessage.lineBreakMode = UILineBreakModeWordWrap;
    noMeetingsMessage.text = @"No meetings could be loaded.";
    noMeetingsMessage.textAlignment = UITextAlignmentCenter;
    
    
    // Remove subview from view if it's there.
    if ([self.view.subviews containsObject:noMeetingsMessage]) {
        [noMeetingsMessage removeFromSuperview];
    }
    
    [self.loadMeetings startAnimating];
    
	[[MeetingsAPIClient sharedInstance] getPath:@"meetings.json" parameters:nil
										success:^(AFHTTPRequestOperation *operation, id response) {
											NSLog(@"Response: %@", response);
											NSMutableArray *results = [NSMutableArray array];
											for (id meetingDictionary in response) {
												Meeting *meeting = [[Meeting alloc] initWithDictionary:meetingDictionary];
												[results addObject:meeting];
											}
											self.results = results;
                                            [[NSUserDefaults standardUserDefaults] setObject:self.results forKey:@"meetings"];
                                            [[NSUserDefaults standardUserDefaults] synchronize];
											[self.tableView reloadData];
                                            [self.loadMeetings stopAnimating];
                                            [self.loadMeetings removeFromSuperview];
										}
										failure:^(AFHTTPRequestOperation *operation, NSError *error) {
											NSLog(@"Error fetching meetings!");
											NSLog(@"%@",error);
                                            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"meetings"]) {
                                                NSLog(@"Loading meetings from User Defaults...");
                                                self.results = [[NSUserDefaults standardUserDefaults] objectForKey:@"meetings"];
                                                NSLog(@"...Done!");
                                            }
                                            else {
                                                NSLog(@"No meetings to load!");
                                                
                                                [self.view addSubview:noMeetingsMessage];
                                            }
                                            [self.loadMeetings stopAnimating];
                                            [self.loadMeetings removeFromSuperview];
										}];
    

}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [self setLoadMeetings:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	}
	
	Meeting *meeting = [self.results objectAtIndex:indexPath.row];
	cell.textLabel.text = meeting.topic;
	if([meeting.topic isEqualToString:@""]) {
		cell.textLabel.text = @"Work day";
	}
	cell.detailTextLabel.text = meeting.date;
	
	UIImage *image;
	if ([meeting.hasSpeaker boolValue]) {
		image = [UIImage imageNamed:@"124-bullhorn.png"];
	} else if ([meeting.hasFood boolValue]) {
		image = [UIImage imageNamed:@"125-food.png"];
	} else {
		image = [UIImage imageNamed:@"112-group.png"];
	}
	
	cell.imageView.image = image;
	
	return cell;
}

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
