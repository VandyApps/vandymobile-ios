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
#import "AppsCell.h"
#import "Sizer.h"

@interface GithubRepoTableViewController ()

@end

@implementation GithubRepoTableViewController

@synthesize app = _app;
@synthesize results = _results;
@synthesize images = _images;
@synthesize repoURL = _repoURL;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSMutableDictionary *)images {
    if (!_images) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}

- (void)setImages:(NSMutableDictionary *)images {
    if (_images != images) {
        _images = images;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self pullCommits];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VandyMobileBackgroundCanvas"]];
    self.tableView.backgroundView = backgroundView;
    
//    NSMutableSet *names;
//    for (GitCommit *commit in self.results) {
//        if (![self.images objectForKey:commit.avatarURL]) {
//            [self downloadPhotoForUrl:commit.avatarURL andImageView:nil];
//        }
//        [names addObject:commit.author];
//    }
//    if (self.images.count == names.count) {
//        [self.tableView reloadData];
//    }
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

#pragma mark Image Downloading Methods

- (void)downloadPhotoForUrl:(NSString *)url andImageView:(UIImageView *)imageView {
    
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
    }
    
    // Download photo
//    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    [loading startAnimating];
//    UIBarButtonItem * temp = self.navigationItem.leftBarButtonItem;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loading];
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSString *urlstring = url;
        NSData *imgUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageWithData:imgUrl];
            [self.images setObject:[UIImage imageWithData:imgUrl] forKey:url];
//            [loading stopAnimating];
//            self.navigationItem.leftBarButtonItem = temp;
        });
    });
    dispatch_release(downloadQueue);
    
    
}

#pragma mark - APICalls

- (void)pullCommits {
	// Get the Github url.
    NSURL *url = [NSURL URLWithString:self.repoURL];
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
	
	AppsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
	if(!cell) {
		cell = [[AppsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
	}
    
    // Load the top-level objects from the custom cell XIB.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AppsCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    cell = [topLevelObjects objectAtIndex:0];
    
    GitCommit *commit = [self.results objectAtIndex:indexPath.row];
    if (commit) {
        if (![self.images objectForKey:commit.avatarURL]) {
            [self downloadPhotoForUrl:commit.avatarURL andImageView:cell.cellImage];
        } else cell.cellImage.image = [self.images objectForKey:commit.avatarURL];
        
        cell.mainLabel.text = commit.commitMessage;
        
        cell.subLabel.text = commit.author;
        
        [cell configureCellForTableView:self.tableView atIndexPath:indexPath withMainFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
        cell.labelsContainerView.centerY = cell.centerY;
    }
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppsCell *cell = (AppsCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    //    CGFloat newHeight = [Sizer sizeText:cell.subLabel.text withConstraint:CGSizeMake(cell.subLabel.width, MAXFLOAT) font:[UIFont fontWithName:@"Helvetica" size:14] andMinimumHeight:21];
    CGFloat newHeight = cell.subLabel.height - 21;
    newHeight += cell.mainLabel.height - 21;
    newHeight += 67;
    
    cell.cellImageContainerView.centerY = newHeight / 2;
    cell.labelsContainerView.centerY = newHeight / 2;
    
    return newHeight;
}

#pragma mark - Table view delegate


@end