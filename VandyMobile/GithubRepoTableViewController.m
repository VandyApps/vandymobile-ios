//
//  GithubRepoTableViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 7/26/12.
//
//

#import "GithubRepoTableViewController.h"
#import "VMCell.h"
#import "AFNetworking.h"

@interface GithubRepoTableViewController ()

@end

@implementation GithubRepoTableViewController
@synthesize tableView = _tableView;
@synthesize results = _results;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self pullCommits];
}

- (void)viewDidUnload {
	[self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - APICalls

- (void)pullCommits {
	// Get twitter URL
	NSURL *url = [NSURL URLWithString:@"https://api.github.com/repos/VandyMobile/vandymobile-ios/commits"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFJSONRequestOperation *operation;
	operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request
																success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {
																	NSLog(@"Response: %@", jsonObject);
																}
																failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
																	NSLog(@"Error fetching meetings!");
																	NSLog(@"%@",error);
																}];
	
	[operation start];


}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *cellIdentifier = @"cellIdentifier";
	
	VMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(!cell) {
		cell = [[VMCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
	
	return cell;
}


#pragma mark - Table view delegate


@end
