//
//  TeamTableViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/30/12.
//
//

#import "TeamTableViewController.h"
#import "VMAPIClient.h"
#import "VMCell.h"
#import "JSONKit.h"
#import "User.h"


#define USERS_KEY   @"users"
#define EMAIL_KEY   @"email"
#define NAME_KEY    @"name"

@interface TeamTableViewController ()

@end

@implementation TeamTableViewController

@synthesize teammates = _teammates;
@synthesize teamNames = _teamNames;

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
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VandyMobileBackgroundCanvas"]];
    self.tableView.backgroundView = backgroundView;

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
    NSArray *navSubviews = [self.navigationController.navigationBar subviews];
    //    NSLog(@"%@", navSubviews);
    for (UIView * subview in navSubviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview != [navSubviews objectAtIndex:0]) {
            [subview removeFromSuperview];
        }
    }
}

#pragma mark APIClient Methods

//- (void)pullTeamsFromServer {
//    NSMutableArray *results = [NSMutableArray array];
//    NSMutableArray *names = [NSMutableArray array];
//    for (int i=0; i < [self.teamIds count]; i++) {
//        NSString *path = [NSString stringWithFormat:@"teams/%d.json", (int)[(NSNumber *)[self.teamIds objectAtIndex:i] intValue]];
//        [[MeetingsAPIClient sharedInstance] getPath:path parameters:nil
//                                            success:^(AFHTTPRequestOperation *operation, id response) {
////                                                NSLog(@"Response: %@", response);
//                                                NSArray *usersArray = [response objectForKey:USERS_KEY];
//                                                NSLog(@"usersArray = %@", usersArray);
//                                                [results addObject:usersArray];
//                                                [names addObject:[response objectForKey:NAME_KEY]];
//                                                if (i == [self.teamIds count] -1) {
//                                                    self.teams = results;
//                                                    self.teamNames = names;
//                                                    [self.tableView reloadData];
//                                                    NSLog(@"Team Names %@", self.teamNames);
//                                                }
//                                            }
//                                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                                                NSLog(@"%@",error);
//                                            }];
//
//    }
//       
//    
//}
//
//- (void)pullTeamsFromCache {
//    NSMutableArray *results = [NSMutableArray array];
//    for (int i = 0; i < [self.teamIds count]; i++) {
//        NSString *path = [NSString stringWithFormat:@"http://70.138.50.84/teams/%d.json", (int)[(NSNumber *)[self.teamIds objectAtIndex:i] intValue]];
//        NSString *staticPath = path;
//        NSURLRequest *request = [[MeetingsAPIClient sharedInstance] requestWithMethod:@"GET" path:staticPath parameters:nil];
//        NSCachedURLResponse *response = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
//        if (response) {
//            NSData *responseData = response.data;
//            id teamsObject = [[JSONDecoder decoder] objectWithData:responseData];
//            
//            NSArray *usersArray = [teamsObject objectForKey:USERS_KEY];
//            NSLog(@"usersArray = %@", usersArray);
//            [results addObject:usersArray];
//            if (i == [self.teamIds count] -1) {
//                self.teams = results;
//                [self.tableView reloadData];
//            }
//        }
//
//    }
//}

#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.teamNames count] > 0) {
        return [[self.teammates objectAtIndex:section] count];
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.teamNames count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self.teamNames count] > 0) {
        return [self.teamNames objectAtIndex:section];
    }
    
    return @"Section";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(!cell) {
		cell = [[VMCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
    
    if ([self.teamNames count] > 0) {
        NSDictionary *userDict = [[self.teammates objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = [userDict objectForKey:EMAIL_KEY];
    }

    
	return cell;
}


@end
