//
//  GithubRepoTableViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/28/12.
//
//

#import "GithubRepoTableViewController.h"
#import "VMCell.h"
#import "AFNetworking.h"
#import "GitCommit.h"
#import "UIView+Frame.h"

@interface GithubRepoTableViewController ()

@end

@implementation GithubRepoTableViewController

@synthesize app = _app;
@synthesize results = _results;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pullCommits];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VandyMobileBackgroundCanvas"]];
    self.tableView.backgroundView = backgroundView;
    
//    self.tableView.
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - APICalls

- (void)pullCommits {
	// Get the Github url.
	NSURL *url = [NSURL URLWithString:@"https://api.github.com/repos/VandyMobile/vandymobile-ios/commits"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFJSONRequestOperation *operation;
	operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
																success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {
                                                                    //																	NSLog(@"Response: %@", jsonObject);
                                                                    NSMutableArray *results = [NSMutableArray array];
                                                                    for (id commitDictionary in jsonObject) {
                                                                        GitCommit *commit = [[GitCommit alloc] initWithDictionary:commitDictionary];
                                                                        [results addObject:commit];
                                                                    }
                                                                    self.results = results;
                                                                    [self.tableView reloadData];
																}
																failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
																	NSLog(@"Error fetching meetings!");
																	NSLog(@"%@",error);
																}];
	
	[operation start];
    
    
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifier = @"cellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(!cell) {
		cell = [[VMCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
    GitCommit *commit = [self.results objectAtIndex:indexPath.row];
    
    cell.textLabel.text = commit.commitMessage;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    
    cell.detailTextLabel.text = commit.author;
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
//    return cell.textLabel.height + cell.detailTextLabel.height + 16;
    return 85;
}

#pragma mark - Table view delegate


@end