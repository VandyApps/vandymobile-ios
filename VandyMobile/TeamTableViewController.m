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
#import "JSONKit.h"


#define USERS_KEY   @"users"
#define EMAIL_KEY   @"email"

@interface TeamTableViewController ()

@end

@implementation TeamTableViewController

@synthesize teams = _teams;
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
	
    self.teamIds = [NSArray arrayWithObject:[NSNumber numberWithInt:1]];
    [self pullTeamsFromServer];
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
    NSMutableArray *results = [NSMutableArray array];
    for (int i=0; i < [self.teamIds count]; i++) {
        NSString *path = [NSString stringWithFormat:@"teams/%d.json", (int)[(NSNumber *)[self.teamIds objectAtIndex:i] intValue]];
        [[MeetingsAPIClient sharedInstance] getPath:path parameters:nil
                                            success:^(AFHTTPRequestOperation *operation, id response) {
//                                                NSLog(@"Response: %@", response);
                                                NSArray *usersArray = [response objectForKey:USERS_KEY];
                                                NSLog(@"usersArray = %@", usersArray);
                                                [results addObject:usersArray];
                                                if (i == [self.teamIds count] -1) {
                                                    self.teams = results;
                                                    [self.tableView reloadData];
                                                }
                                            }
                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                NSLog(@"%@",error);
                                            }];

    }
       
    
}

- (void)pullTeamsFromCache {
    NSMutableArray *results = [NSMutableArray array];
    for (int i = 0; i < [self.teamIds count]; i++) {
        NSString *path = [NSString stringWithFormat:@"http://70.138.50.84/teams/%d.json", (int)[(NSNumber *)[self.teamIds objectAtIndex:i] intValue]];
        NSString *staticPath = path;
        NSURLRequest *request = [[MeetingsAPIClient sharedInstance] requestWithMethod:@"GET" path:staticPath parameters:nil];
        NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
        if (response) {
            NSData *responseData = response.data;
            id teamsObject = [[JSONDecoder decoder] objectWithData:responseData];
            
            NSArray *usersArray = [teamsObject objectForKey:USERS_KEY];
            NSLog(@"usersArray = %@", usersArray);
            [results addObject:usersArray];
            if (i == [self.teamIds count] -1) {
                self.teams = results;
                [self.tableView reloadData];
            }
        }

    }
}

#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self.teams objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return [self.teams count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(!cell) {
		cell = [[VMCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
    
    NSDictionary *userDict = [[self.teams objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = [userDict objectForKey:EMAIL_KEY];
    
	return cell;
}


@end
