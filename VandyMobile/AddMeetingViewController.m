//
//  AddMeetingViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddMeetingViewController.h"
#import "VMTextInputCell.h"
#import "SVProgressHUD.h"
#import "MeetingsAPIClient.h"
#import "Meeting.h"

@interface AddMeetingViewController ()

@end

@implementation AddMeetingViewController
@synthesize tableView = _tableView;
@synthesize formFields = _formFields;
@synthesize keyboardTools = _keyboardTools;
@synthesize currentTextFieldTag = _currentTextFieldTag;

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
	[self setupKeyboardTools];
	_currentTextFieldTag = 1;
}

- (void)viewDidUnload
{
	[self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Custom Keyboard


- (void)nextTextField {
	/* Tags start at 1 */
	_currentTextFieldTag++;
	if (self.currentTextFieldTag > [self.formFields count]) {
		self.currentTextFieldTag = [self.formFields count];
		return;
	}
	// Try to find next responder
	UIResponder* nextResponder = [self.tableView viewWithTag:self.currentTextFieldTag];
	if (nextResponder) {
		// Found next responder, so set it.
		[nextResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[self.tableView resignFirstResponder];
	}
	
	CGPoint nextOffset = self.tableView.contentOffset;
	nextOffset.y = nextOffset.y + 45;
	[self.tableView setContentOffset:nextOffset animated:YES];
}

- (void)prevTextField {
	/* Tags start at 1 */
	_currentTextFieldTag--;
	if (self.currentTextFieldTag < 1) {
		self.currentTextFieldTag = 1;
		return;
	}
	// Try to find next responder
	UIResponder* prevResponder = [self.tableView viewWithTag:self.currentTextFieldTag];
	if (prevResponder) {
		// Found next responder, so set it.
		[prevResponder becomeFirstResponder];
	} else {
		// Not found, so remove keyboard.
		[self.tableView resignFirstResponder];
	}
	CGPoint nextOffset = self.tableView.contentOffset;
	nextOffset.y = nextOffset.y - 45;
	[self.tableView setContentOffset:nextOffset animated:YES];

}

- (void)done {
	UIResponder* currentResponder = [self.tableView viewWithTag:self.currentTextFieldTag];
	[currentResponder resignFirstResponder];
}

- (void)setupKeyboardTools {
	self.keyboardTools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
	UIBarButtonItem *prevInput = [[UIBarButtonItem alloc] initWithTitle:@"Prev" 
																  style:UIBarButtonItemStyleBordered 
																 target:self 
																 action:@selector(prevTextField)];
	
	UIBarButtonItem *nextInput = [[UIBarButtonItem alloc] initWithTitle:@"Next" 
																  style:UIBarButtonItemStyleBordered 
																 target:self 
																 action:@selector(nextTextField)];
	
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																  style:UIBarButtonItemStyleBordered 
																 target:self 
																 action:@selector(done)];
	
	
	NSArray *tools = [NSArray arrayWithObjects:prevInput, nextInput, done, nil];
	
	[self.keyboardTools setItems:tools];
	
	
}


#pragma mark - UITableViewDatasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.formFields count] + 1;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row < [self.formFields count]) {
		static NSString *cellIdentifier = @"VMTextInputCell";
		VMTextInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
		if (!cell) {
			cell = [VMTextInputCell textFieldCellWithTitle:[self.formFields objectAtIndex:indexPath.row] 
											   forDelegate:self 
												   withTag:indexPath.row + 1];
		}

		[cell.textField setInputAccessoryView:self.keyboardTools];
		return cell;

	}
	if (indexPath.row == [self.formFields count]) {
		VMFormCell *cell = [[VMFormCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
		cell.textLabel.text = @"Add Meeting";
		return cell;
	}

    return nil;

}



#pragma mark - UITableViewDelegate Methods

- (void)createMeeting {
	[SVProgressHUD showWithStatus:@"Creating Meeting"];
	NSMutableArray *meetingContent = [NSMutableArray arrayWithCapacity:[self.formFields count]];
	for (int i=0; i<[self.formFields count]-1; i++) {
		VMFormCell *cell = (VMFormCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
		[meetingContent addObject:[cell cellContent]];
	}
	NSLog(@"meeting = %@", meetingContent);
	Meeting *newMeeting = [[Meeting alloc] initWithDictionary:[NSDictionary dictionary]];
	[[MeetingsAPIClient sharedInstance] createMeeting:newMeeting];
	[self.navigationController popViewControllerAnimated:YES]; 
	[SVProgressHUD dismiss];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == [self.formFields count]) {
		[self createMeeting];
	}
	NSLog(@"indexPath = %@", indexPath);

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
