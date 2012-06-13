//
//  AddMeetingViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddMeetingViewController.h"
#import "TextInputCell.h"
#import "SVProgressHUD.h"

@interface AddMeetingViewController ()

@end

@implementation AddMeetingViewController
@synthesize tableView = _tableView;
@synthesize formFields = _formFields;

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
    // Do any additional setup after loading the view from its nib.
	self.formFields = [NSArray arrayWithObjects:@"Day", @"Date", @"X-Coordinate", @"Y-Coordinate", @"Speaker", @"Topic", nil];
}

- (void)viewDidUnload
{
	[self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.formFields count] + 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"textInputCell";
	
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if(!cell) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"TextInputCell" owner:self options:nil];
		
		for (id currentObject in topLevelObjects) {
			if ([currentObject isKindOfClass:[TextInputCell class]]) {
				cell = (TextInputCell *)currentObject;
				break;
			}
		}

	}
	if (indexPath.row != [self.formFields count]) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[[(TextInputCell *)cell title] setText:[self.formFields objectAtIndex:indexPath.row]];
	} else {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.textLabel.text = @"Add Meeting";
	}
    return cell;

}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [self.formFields count]) {
		[SVProgressHUD showWithStatus:@"Creating Meeting"];
		[self.navigationController popViewControllerAnimated:YES]; 
		[SVProgressHUD dismiss];
	}

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
