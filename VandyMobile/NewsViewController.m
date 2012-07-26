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
#import "Sizer.h"
#import "NewsCell.h"

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
    //self.tableView.backgroundView.hidden = YES;
    self.backgroundImageView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    
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

- (void)viewDidDisappear:(BOOL)animated {
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tweets.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section != 0) {
        return 5;
    } else return 10;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	
	NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[NewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.section];
            
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"NewsCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
        
        // Set text
        cell.bodyTextLabel.text = [tweet objectForKey:@"text"];
        cell.timestampLabel.text = [tweet objectForKey:@"created_at"];
        
        // Clips to bounds
        cell.clipsToBounds = YES;
        
        // Size it!
        
        CGFloat oldHeight = cell.bodyTextLabel.frame.size.height;
        CGFloat newHeight = [Sizer sizeText:cell.bodyTextLabel.text withConstraint:CGSizeMake(cell.bodyTextLabel.frame.size.width, MAXFLOAT) andFont:cell.bodyTextLabel.font];
        
        cell.bodyTextLabel.frame = CGRectMake(cell.bodyTextLabel.frame.origin.x, cell.bodyTextLabel.frame.origin.y, cell.bodyTextLabel.frame.size.width, newHeight);
        
        cell.timestampLabel.frame = CGRectMake(cell.timestampLabel.frame.origin.x, cell.timestampLabel.frame.origin.y + newHeight - oldHeight, cell.timestampLabel.frame.size.width, cell.timestampLabel.frame.size.height);
        
        //cell.bodyTextLabel.layer.borderWidth = 2;
        
        // Set selection color
//        UIView *goldenColor = [[UIView alloc] init];
//        goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
//        cell.selectedBackgroundView = goldenColor;
        
        // Background color
        cell.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] /*#f0f0f0*/;
        
        // Round imageview
        cell.profilePictureLabel.layer.cornerRadius = 5;
        cell.profilePictureLabel.layer.borderWidth = .5;
        cell.profilePictureLabel.layer.borderColor = [[UIColor grayColor] CGColor];
        cell.profilePictureLabel.clipsToBounds = YES;
        
        cell = [self addShadowToView:cell];
        cell.layer.cornerRadius = .2;
        cell.clipsToBounds = YES;
        
    }
    return cell;
}

- (id)addShadowToView:(UIView *)view {
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = .7;
    view.layer.shadowRadius = 1.0;
    view.layer.shadowOffset = CGSizeMake(0, 1.0);
    return view;
}

#pragma mark - TableViewDelegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Deselect the row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Create new NewsDVC
    NewsDetailViewController *newsDVC = [[NewsDetailViewController alloc] init];
    
    // Grab the meeting at the index path
    NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.section];
    
    // Prepare meetingDVC
    newsDVC.title = @"Tweet";
    newsDVC.tweet = tweet;
    [self.navigationController pushViewController:newsDVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellText = [[self.tweets objectAtIndex:indexPath.section] objectForKey:@"text"];
    return 90 + [Sizer sizeText:cellText withConstraint:CGSizeMake(220, MAXFLOAT) andFont:[UIFont fontWithName:@"Helvetica" size:13]] - 49;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
