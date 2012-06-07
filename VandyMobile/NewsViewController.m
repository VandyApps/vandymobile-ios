//
//  NewsViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
#import "NewsDetailViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize tableView = _tableView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize tweets = _tweets;
@synthesize segControl = _segControl;

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
    
    // UI Customization
    // Create resizable UINavigationBar image
    UIImage *navImage = [UIImage imageNamed:@"NewNavBar4"];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.backgroundImageView.image = [UIImage imageNamed:@"VandyMobileBackgroundV3"];
    
//    // Customize Segmented Control
//    UIImage *segmentSelected = 
//    [[UIImage imageNamed:@"NewSegControl2-sel.png"] 
//     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15)];
//    UIImage *segmentUnselected = 
//    [[UIImage imageNamed:@"NewSegControl2-uns.png"] 
//     resizableImageWithCapInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
//    UIImage *segmentSelectedUnselected = 
//    [UIImage imageNamed:@"NewSegControl2-sel-uns.png"];
//    UIImage *segUnselectedSelected = 
//    [UIImage imageNamed:@"NewSegControl2-uns-sel.png"];
//    UIImage *segmentUnselectedUnselected = 
//    [UIImage imageNamed:@"NewSegControl2-uns-uns.png"];
//    
//    [[UISegmentedControl appearance] setBackgroundImage:segmentUnselected 
//                                               forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UISegmentedControl appearance] setBackgroundImage:segmentSelected 
//                                               forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    
//    [[UISegmentedControl appearance] setDividerImage:segmentUnselectedUnselected 
//                                 forLeftSegmentState:UIControlStateNormal 
//                                   rightSegmentState:UIControlStateNormal 
//                                          barMetrics:UIBarMetricsDefault];
//    [[UISegmentedControl appearance] setDividerImage:segmentSelectedUnselected 
//                                 forLeftSegmentState:UIControlStateSelected 
//                                   rightSegmentState:UIControlStateNormal 
//                                          barMetrics:UIBarMetricsDefault];
//    [[UISegmentedControl appearance] 
//     setDividerImage:segUnselectedSelected 
//     forLeftSegmentState:UIControlStateNormal 
//     rightSegmentState:UIControlStateSelected 
//     barMetrics:UIBarMetricsDefault];
	
	// Get twitter URL
	NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=VandyMobile"];
    [SVProgressHUD showWithStatus:@"Loading news..."];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFJSONRequestOperation *operation;
	operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
																success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {
																	//NSLog(@"Response: %@", jsonObject);
																	self.tweets = jsonObject;
																	[self.tableView reloadData];
                                                                    [SVProgressHUD dismissWithSuccess:@"Done!"];
																} 
																failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
																	NSLog(@"Error fetching meetings!");
																	NSLog(@"%@",error);
                                                                    [SVProgressHUD dismissWithError:@"Download failed!"];
																}];

	[operation start];
}

- (void)viewDidAppear:(BOOL)animated {
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

- (void)viewDidUnload
{
	[self setTableView:nil];
    [self setBackgroundImageView:nil];
    [self setSegControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


#pragma mark - TableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.tweets count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
        NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [tweet objectForKey:@"text"];
        
        NSString *url = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
        [cell.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"08-chat.png"]];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 0;
        cell.detailTextLabel.text = [tweet objectForKey:@"created_at"];
        
        UIView *goldenColor = [[UIView alloc] init];
        goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
        cell.selectedBackgroundView = goldenColor;


    return cell;
}

#pragma mark - TableViewDelegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Deselect the row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Create new NewsDVC
    NewsDetailViewController *newsDVC = [[NewsDetailViewController alloc] init];
    
    // Grab the meeting at the index path
    NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
    
    // Prepare meetingDVC
    newsDVC.title = @"Tweet";
    newsDVC.tweet = tweet;
    [self.navigationController pushViewController:newsDVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellText = [[self.tweets objectAtIndex:indexPath.row] objectForKey:@"text"];
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    if (labelSize.height < 15) {
        return 50;
    } else {
        return labelSize.height + 35;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
