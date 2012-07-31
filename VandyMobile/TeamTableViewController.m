//
//  TeamTableViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/30/12.
//
//

#import "TeamTableViewController.h"
#import "MeetingsAPIClient.h"
#import "VMCell.h"

@interface TeamTableViewController ()

@end

@implementation TeamTableViewController

@synthesize results = _results;
@synthesize teamIds = _teamIds;

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
	
	[self pullTeamsFromServer];
	[self setupRefreshAppsButton];
}

- (void)setupRefreshAppsButton {
	// Create add meeting button
	UIBarButtonItem *addMeetingButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(pullAppsFromServer)];
	[self.navigationItem setRightBarButtonItem:addMeetingButton animated:NO];
}

- (void)viewDidUnload {
	[self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    // Set the background image for *all* UINavigationBars
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VandyMobileTextNeue"]];
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

- (void)pullTeamsFromServer {
    NSString *path = [NSString stringWithFormat:@"teams.json/%d", (int)[self.teamIds objectAtIndex:0]];
	[[MeetingsAPIClient sharedInstance] getPath:@"teams.json/1" parameters:nil
                                    success:^(AFHTTPRequestOperation *operation, id response) {
                                        NSLog(@"Response: %@", response);
                                    }
                                    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                        NSLog(@"%@",error);
                                    }];
    
    
}
//
//- (void)pullAppsFromCache {
//	NSString *path = @"http://70.138.50.84/apps.json";
//	NSURLRequest *request = [[AppsAPIClient sharedInstance] requestWithMethod:@"POST" path:path parameters:nil];
//	NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
//	if (response) {
//		NSData *responseData = response.data;
//		id appsObject = [[JSONDecoder decoder] objectWithData:responseData];
//		
//		NSMutableArray *results = [NSMutableArray array];
//		for (id appDictionary in appsObject) {
//			NSLog(@"%@", appDictionary);
//			App *app = [[App alloc] initWithDictionary:appDictionary];
//			[results addObject:app];
//		}
//		self.results = results;
//		[self.tableView reloadData];
//	}
//}

#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(!cell) {
		cell = [[VMCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
    cell.textLabel.text = @"test cell";
    
	return cell;
}


@end
