//
//  AddMeetingViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddMeetingViewController.h"
#import "Meeting.h"
#import "MeetingsAPIClient.h"
#import "SVProgressHUD.h"

/* TableView Sections */
enum VMMeetingSections {
    VMMeetingSection_DateFields = 0,
    VMMeetingSection_SpeakerFields,
	VMMeetingSection_Count,
};

/* Rows in Date Section */
enum VMDateSectionRows {
    VMDateSection_Day,
	VMDateSection_Date,
	VMDateSection_RowCount,

};

/* Rows in Speaker Section */
enum VMSpeakerSectionRows {
    VMSpeakerSection_Speaker,
    VMSpeakerSection_Topic,
	VMSpeakerSection_Description,
	VMSpeakerSection_RowCount,
};

/* TextField tags */
enum VMAddMeetingTags {
    VMAddMeetingTags_DayTextField = 0,
	VMAddMeetingTags_DateTextField,
	VMAddMeetingTags_SpeakerTextField,
	VMAddMeetingTags_TopicTextField,
	VMAddMeetingTags_DescriptionTextField,
};


@interface AddMeetingViewController ()

@end

@implementation AddMeetingViewController

@synthesize dayCell = _dayCell;
@synthesize dateCell = _dateCell;
@synthesize speakerCell = _speakerCell;
@synthesize topicCell = _topicCell;
@synthesize descriptionCell = _descriptionCell;
@synthesize datePickerView = _datePickerView;
@synthesize dateFormatter = _dateFormatter;
@synthesize donePickingButton = _donePickingButton;



- (id)init {
    self = [super initWithStyle:UITableViewStyleGrouped];
    return self;
}

- (void)setupCells {
    if (!self.dayCell) {
        self.dayCell											= [VMTextInputCell textFieldCellWithTitle:@"Day" forDelegate:self]; 
        self.dayCell.textField.autocorrectionType				= UITextAutocorrectionTypeNo;
        self.dayCell.textField.autocapitalizationType			= UITextAutocapitalizationTypeNone;
        self.dayCell.textField.tag								= VMAddMeetingTags_DayTextField;
    }
    
    if (!self.dateCell) {
        self.dateCell											= [VMTextInputCell textFieldCellWithTitle:@"Date" forDelegate:self];
        self.dateCell.textField.autocorrectionType				= UITextAutocorrectionTypeNo;
        self.dateCell.textField.autocapitalizationType			= UITextAutocapitalizationTypeNone;
        self.dateCell.textField.tag								= VMAddMeetingTags_DateTextField;
    }
    
    if (!self.speakerCell) {
        self.speakerCell										= [VMTextInputCell textFieldCellWithTitle:@"Speaker" forDelegate:self];
        self.speakerCell.textField.autocorrectionType			= UITextAutocorrectionTypeNo;
        self.speakerCell.textField.autocapitalizationType		= UITextAutocapitalizationTypeNone;
        self.speakerCell.textField.tag							= VMAddMeetingTags_SpeakerTextField;
    }
    
    if (!self.topicCell) {
        self.topicCell											= [VMTextInputCell textFieldCellWithTitle:@"Topic" forDelegate:self];
        self.topicCell.textField.autocorrectionType				= UITextAutocorrectionTypeNo;
        self.topicCell.textField.autocapitalizationType			= UITextAutocapitalizationTypeNone;
        self.topicCell.textField.tag							= VMAddMeetingTags_TopicTextField;
    }
	
	if (!self.descriptionCell) {
        self.descriptionCell									= [VMTextInputCell textFieldCellWithTitle:@"Description" forDelegate:self];
        self.descriptionCell.textField.autocorrectionType		= UITextAutocorrectionTypeNo;
        self.descriptionCell.textField.autocapitalizationType	= UITextAutocapitalizationTypeNone;
        self.descriptionCell.textField.tag						= VMAddMeetingTags_DescriptionTextField;
    }
}

- (void)setupAddMeetingButton {
	UIButton *addMeetingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[addMeetingButton addTarget:self action:@selector(addMeetingTapped) forControlEvents:UIControlEventTouchUpInside];
	[addMeetingButton setTitle:@"Add Meeting" forState:UIControlStateNormal];
	addMeetingButton.frame = CGRectMake(80.0, 280.0, 160.0, 40.0);
	
	[self.view addSubview:addMeetingButton];
	[self.view bringSubviewToFront:addMeetingButton];
}

- (void)addMeetingTapped {
	Meeting *meeting = [[Meeting alloc] init];
	[meeting setDay:self.dayCell.textField.text];
	[meeting setDate:self.dateCell.textField.text];
	[meeting setSpeakerName:self.speakerCell.textField.text];
	[meeting setTopic:self.topicCell.textField.text];
	[meeting setDescription:self.descriptionCell.textField.text];
	
	[[MeetingsAPIClient sharedInstance] addMeetingtoServer:meeting];
	[self.navigationController popViewControllerAnimated:YES];
	[SVProgressHUD showWithStatus:@"Adding Meeting..."];
}

- (void)setupDateFormatter {
	self.dateFormatter = [[NSDateFormatter alloc] init];
//	[self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
//	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
	[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
	[self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];	
	

}

- (void)setupDatePickerView {
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGSize pickerSize = [self.datePickerView sizeThatFits:CGSizeZero];
	CGRect startRect = CGRectMake(0.0,
								  screenRect.origin.y + screenRect.size.height,
								  pickerSize.width, pickerSize.height);
	
	self.datePickerView = [[UIDatePicker alloc] initWithFrame:startRect];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupCells];
	[self setupAddMeetingButton];
	[self setupDateFormatter];
	[self setupDatePickerView];	
}

- (void)viewDidUnload
{
	[self setTableView:nil];
    [super viewDidUnload];
}

#pragma mark - DatePicker Methods

- (void)openDatePicker {
//	self.datePicker.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
	
	// check if our date picker is already on screen
	if (self.datePickerView.superview == nil) {
		[self.view.window addSubview: self.datePickerView];
		
		// size up the picker view to our screen and compute the start/end frame origin for our slide up animation
		//
		// compute the start frame
		CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
		CGSize pickerSize = [self.datePickerView sizeThatFits:CGSizeZero];
		CGRect startRect = CGRectMake(0.0,
									  screenRect.origin.y + screenRect.size.height,
									  pickerSize.width, pickerSize.height);
		self.datePickerView.frame = startRect;
		
		// compute the end frame
		CGRect pickerRect = CGRectMake(0.0,
									   screenRect.origin.y + screenRect.size.height - pickerSize.height,
									   pickerSize.width,
									   pickerSize.height);
		// start the slide up animation
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		
		// we need to perform some post operations after the animation is complete
		[UIView setAnimationDelegate:self];
		
		self.datePickerView.frame = pickerRect;
		
		// shrink the table vertical size to make room for the date picker
		CGRect newFrame = self.tableView.frame;
//		newFrame.size.height -= self.datePickerView.frame.size.height;
		self.tableView.frame = newFrame;
		[UIView commitAnimations];
		
		[self.datePickerView addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
		
		UIBarButtonItem *doneButton= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonSystemItemDone target:self action:nil];;
		self.navigationItem.rightBarButtonItem = doneButton;
	}
}

- (void)dismissDatePicker {
	[self.datePickerView removeFromSuperview];
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)pickerChanged:(id)sender
{
	self.dateCell.textField.text = [self.dateFormatter stringFromDate:self.datePickerView.date];
}

#pragma mark - TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    int tag = textField.tag;
    
    switch (tag) {
        case VMAddMeetingTags_DayTextField:
            [self.dateCell.textField becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:VMDateSection_Date inSection:VMMeetingSection_DateFields] 
								  atScrollPosition:UITableViewRowAnimationNone animated:YES];
            break;
        case VMAddMeetingTags_DateTextField:
            [self.speakerCell.textField becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:VMSpeakerSection_Speaker inSection:VMMeetingSection_SpeakerFields] 
								  atScrollPosition:UITableViewRowAnimationNone animated:YES];
            break;
        case VMAddMeetingTags_SpeakerTextField:
            [self.topicCell.textField becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:VMSpeakerSection_Topic inSection:VMMeetingSection_SpeakerFields] 
								  atScrollPosition:UITableViewRowAnimationNone animated:YES];
            break;
        case VMAddMeetingTags_TopicTextField:
			[self.descriptionCell.textField becomeFirstResponder];
			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:VMSpeakerSection_Description inSection:VMMeetingSection_SpeakerFields] 
								  atScrollPosition:UITableViewRowAnimationNone animated:YES];
            break;
        case VMAddMeetingTags_DescriptionTextField:
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	CGPoint contentOffset = self.tableView.contentOffset;
	contentOffset.y += 35;// Adjust this value as you need
	[self.tableView setContentOffset:contentOffset animated:YES];
	
	if (textField.tag == VMAddMeetingTags_DateTextField) {
		[self.dateCell.textField resignFirstResponder];
		[self openDatePicker];
		self.dateCell.selectionStyle = UITableViewCellSelectionStyleBlue;
		[self.dateCell setSelected:YES];
	} else {
		[self dismissDatePicker];
		[self.dateCell setSelected:NO];
	}
}
		 
 - (void)dismissKeyboard {
	 if ([self.dayCell.textField isFirstResponder]) {
		 [self.dayCell.textField resignFirstResponder];
	 }
	 if ([self.dateCell.textField isFirstResponder]) {
		 [self.dateCell.textField resignFirstResponder];
	 }
	 if ([self.speakerCell.textField isFirstResponder]) {
		 [self.speakerCell.textField resignFirstResponder];
	 }
	 if ([self.topicCell.textField isFirstResponder]) {
		 [self.descriptionCell.textField resignFirstResponder];
	 }
 }


#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
        case VMMeetingSection_DateFields:
			NSLog(@"%d",VMDateSection_RowCount);
            return VMDateSection_RowCount;
            
        case VMMeetingSection_SpeakerFields:
			NSLog(@"%d",VMSpeakerSection_RowCount);
            return VMSpeakerSection_RowCount;
			
        default:
            //currently, all other sections have a single row
            return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return VMMeetingSection_Count;
}

- (VMFormCell *)cellForDateFieldAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case VMDateSection_Day:
            return self.dayCell;  
        case VMDateSection_Date:
            return self.dateCell;
        default:
            break;
    }
    
    return nil;
}

- (VMFormCell *)cellForSpeakerFieldAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
		case VMSpeakerSection_Speaker:
			return self.speakerCell;  
		case VMSpeakerSection_Topic:
			return self.topicCell;
		case VMSpeakerSection_Description:
			return self.descriptionCell;
        default:
            break;
    }
    
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	VMFormCell *cell = nil;
    switch (indexPath.section) {
		case VMMeetingSection_DateFields:
			cell = [self cellForDateFieldAtIndexPath:indexPath];            
            break;
        case VMMeetingSection_SpeakerFields:
            cell = [self cellForSpeakerFieldAtIndexPath:indexPath];
            break;			
        default:
            [[NSException exceptionWithName:@"Unhandled table view section" 
                                     reason:[NSString stringWithFormat:@"The section %d did not have a cell handler.", indexPath.section]
                                   userInfo:nil] raise];
            break;
    }
	
    return cell;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
