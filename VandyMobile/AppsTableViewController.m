//
//  AppsTableViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppsTableViewController.h"
#import "SVProgressHUD.h"
#import "AppsAPIClient.h"
#import "App.h"
#import "VMFormCell.h"
#import "AppsDetailViewController.h"


@interface AppsTableViewController ()

@end

@implementation AppsTableViewController
@synthesize tableView = _tableView;
@synthesize results = _results;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Lifecycle Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Create resizable UINavigationBar image
    UIImage *navImage = [UIImage imageNamed:@"NewNavBar4"];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];

	[self pullAppsFromServer];
}

- (void)viewDidUnload {
	[self setTableView:nil];
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

#pragma mark APIClient Methods

- (void)pullAppsFromServer {
	// Status indicator. Takes place of network spinner and if no meetings are loaded
	[SVProgressHUD showWithStatus:@"Loading apps..." maskType:SVProgressHUDMaskTypeNone];
	[[AppsAPIClient sharedInstance] getPath:@"apps.json" parameters:nil
                                        success:^(AFHTTPRequestOperation *operation, id response) {
											//											NSLog(@"Response: %@", response);
											NSMutableArray *results = [NSMutableArray array];
											for (id appDictionary in response) {
												App *app = [[App alloc] initWithDictionary:appDictionary];
												[results addObject:app];
											}
											self.results = results;
											[self.tableView reloadData];
											[SVProgressHUD dismissWithSuccess:@"Done!"];
										}
										failure:^(AFHTTPRequestOperation *operation, NSError *error) {
											NSLog(@"%@",error);
											[SVProgressHUD dismissWithError:@"Error loading apps!"];
										}];

}

#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	
	VMFormCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[VMFormCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        App *app = [self.results objectAtIndex:indexPath.row];
        cell.textLabel.text = app.name;
        cell.detailTextLabel.text = app.team;
		[cell configureCellForTableView:self.tableView atIndexPath:indexPath];    
	}
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Deselect the row
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Create new MeetingDVC
    AppsDetailViewController *appsDVC = [[AppsDetailViewController alloc] init];
    
    // Grab the meeting at the index path
    App *app = [self.results objectAtIndex:indexPath.row];
    
    // Prepare meetingDVC
    appsDVC.title = app.name;
    appsDVC.app = app;
    [self.navigationController pushViewController:appsDVC animated:YES];
    
}


@end
