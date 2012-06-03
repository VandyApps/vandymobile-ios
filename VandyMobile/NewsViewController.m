//
//  NewsViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NewsViewController.h"
#import "AFNetworking.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

@synthesize tableView = _tableView;
@synthesize backgroundImageView = _backgroundImageView;
@synthesize tweets = _tweets;

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
	
	// Get twitter URL
	NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=VandyMobile&include_rts=0"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFJSONRequestOperation *operation;
	operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
																success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {
																	NSLog(@"Response: %@", jsonObject);
																	self.tweets = jsonObject;
                                                                    
                                                                    // My attempt at fixing this mess of data. Not working right now. Scott - 6/2/12
                                                                    self.tweets = [[NSOrderedSet orderedSetWithArray:self.tweets] array];
                                                                    NSDictionary *head = [self.tweets objectAtIndex:0];
                                                                    for (NSDictionary *tweet in self.tweets) {
                                                                        if ([[tweet objectForKey:@"text"] isEqualToString:[head objectForKey:@"text"]] && [self.tweets indexOfObject:tweet] != 0) {
                                                                            self.tweets = [self.tweets subarrayWithRange:NSMakeRange(0, [self.tweets indexOfObject:tweet])];
                                                                        }
                                                                    }
                                                                    
																	[self.tableView reloadData];
																} 
																failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
																	NSLog(@"Error fetching meetings!");
																	NSLog(@"%@",error);
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
        NSDictionary *tweet = [self.tweets objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [tweet objectForKey:@"text"];
        
        NSString *url = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
//        NSLog(@"url = %@", url);
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
	}

    return cell;
}

#pragma mark - TableViewDelegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
