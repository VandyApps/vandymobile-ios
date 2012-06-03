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
	
	// Get twitter URL
	NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json?screen_name=VandyMobile&include_rts=1"];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	AFJSONRequestOperation *operation;
	operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request 
																success:^(NSURLRequest *request, NSHTTPURLResponse *response, id jsonObject) {
																	NSLog(@"Response: %@", jsonObject);
																	self.tweets = jsonObject;
																	[self.tableView reloadData];
																} 
																failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id jsonObject) {
																	NSLog(@"Error fetching meetings!");
																	NSLog(@"%@",error);
																}];

	[operation start];
}

- (void)viewDidUnload
{
	[self setTableView:nil];
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
	NSLog(@"url = %@", url);
	[cell.imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"08-chat.png"]];
	return cell;
}

#pragma mark - TableViewDelegate Methods


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100.0;
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
