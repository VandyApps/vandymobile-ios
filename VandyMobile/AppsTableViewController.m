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
	[self pullAppsFromServer];
}

- (void)viewDidUnload {
	[self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        App *app = [self.results objectAtIndex:indexPath.row];
        cell.textLabel.text = app.name;
        cell.detailTextLabel.text = app.team;
        
		//        CGSize size = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"112-group.png"]].frame.size;
		//        
		//        UIImage *image;
		//        if ([meeting.hasFood boolValue]) {
		//            if ([meeting.hasSpeaker boolValue]) {
		//                image = [UIImage imageNamed:@"bullhorn-food-combo"];
		//            }
		//            else {
		//                image = [UIImage imageNamed:@"125-food.png"];
		//            }
		//        } else if ([meeting.hasSpeaker boolValue]) {
		//            image = [UIImage imageNamed:@"124-bullhorn.png"];
		//        } else {
		//            image = [UIImage imageNamed:@"112-group.png"];
		//        }
		//        
		//        cell.imageView.image = image;
		//        cell.imageView.frame = CGRectMake(cell.imageView.frame.origin.x, cell.imageView.frame.origin.y, size.width, size.height);
		
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
        
        UIView *goldenColor = [[UIView alloc] init];
        goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
        cell.selectedBackgroundView = goldenColor;
	}
	
	return cell;
}

@end
