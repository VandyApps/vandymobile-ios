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
	VMMeetingSection_CheckboxFields,
    VMMeetingSection_SpeakerFields,
	VMMeetingSection_Count,
};

/* Rows in Date Section */
enum VMDateSectionRows {
	VMDateSection_Date,
	VMDateSection_RowCount,
};

/* Rows in Checkbox section */
enum VMCheckboxSectionRows {
	VMCheckboxSection_hasFood,
	VMCheckboxSection_RowCount,
	};

/* Rows in Speaker Section */
enum VMSpeakerSectionRows {
    VMSpeakerSection_Speaker,
    VMSpeakerSection_Topic,
	VMSpeakerSection_Description,
	VMSpeakerSection_RowCount,
};

/* TextField/Checkbox tags */
enum VMAddMeetingTags {
	VMAddMeetingTags_DateLabel = 0,
	VMAddMeetingTags_hasFoodCheckboxField,
	VMAddMeetingTags_SpeakerTextField,
	VMAddMeetingTags_TopicTextField,
	VMAddMeetingTags_DescriptionTextField,
};


@interface AddMeetingViewController ()

@end

@implementation AddMeetingViewController

@synthesize dateCell = _dateCell;
@synthesize hasFoodCell = _hasFoodCell;
@synthesize speakerCell = _speakerCell;
@synthesize topicCell = _topicCell;
@synthesize descriptionCell = _descriptionCell;
@synthesize datePickerView = _datePickerView;
@synthesize datePickerOpen = _datePickerOpen;
@synthesize dateFormatter = _dateFormatter;
@synthesize addMeetingButton = _addMeetingButton;
@synthesize completionBlock = _completionBlock;




- (id)initWithCompletionBlock:(void(^)(void))completionBlock {
    self = [super initWithStyle:UITableViewStyleGrouped];
	self.completionBlock = completionBlock;
    return self;
}

- (void)setupCells {
    if (!self.dateCell) {
        self.dateCell											= [VMDatePickerCell textFieldCellWithTitle:@"Date"];
		self.dateCell.dateLabel.text							= [self.dateFormatter stringFromDate:[NSDate date]];
		[self switchDateFormatters];
		self.dateCell.formattedDate								= [self.dateFormatter stringFromDate:self.datePickerView.date];
		[self switchDateFormatters];
		self.dateCell.delegate									= self;
        self.dateCell.dateLabel.tag								= VMAddMeetingTags_DateLabel;
    }
	
	if (!self.hasFoodCell) {
        self.hasFoodCell										= [[VMCheckboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hasFoodCell"];
		[self.hasFoodCell.textLabel setText:@"Food"];
		self.hasFoodCell.checkBox.tag							= VMAddMeetingTags_hasFoodCheckboxField;
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
	self.addMeetingButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonSystemItemAdd target:self action:@selector(addMeetingTapped)];
	self.navigationItem.rightBarButtonItem = self.addMeetingButton;
	
}


- (void)addMeetingTapped {
	Meeting *meeting = [[Meeting alloc] init];
	NSArray *dateComponents = [self.dateCell.dateLabel.text componentsSeparatedByString:@","];
	[meeting setDay:[dateComponents objectAtIndex:0]];
	[meeting setDate:self.dateCell.formattedDate];
	[meeting setHasFood:[NSNumber numberWithBool:self.hasFoodCell.checkBox.isOn]];
	[meeting setHasSpeaker:[NSNumber numberWithBool:![self.speakerCell.textField.text isEqualToString:@""]]];
	[meeting setSpeakerName:self.speakerCell.textField.text];
	[meeting setTopic:self.topicCell.textField.text];
	[meeting setDescription:self.descriptionCell.textField.text];
		
	[[MeetingsAPIClient sharedInstance] addMeetingtoServer:meeting withCompletionBlock:self.completionBlock];
	[self.navigationController popViewControllerAnimated:YES];
	[SVProgressHUD showWithStatus:@"Adding Meeting..."];
}

- (void)setupDateFormatter {
	self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setDateStyle:NSDateFormatterFullStyle];
	[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];	
}

- (void)switchDateFormatters {
	if (self.dateFormatter.dateStyle == NSDateFormatterShortStyle) {
		[self.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
		[self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];	
	} else {
		[self.dateFormatter setDateStyle:NSDateFormatterFullStyle];
		[self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	}
}

- (void)setupDatePickerView {
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGSize pickerSize = [self.datePickerView sizeThatFits:CGSizeZero];
	CGRect startRect = CGRectMake(0.0,
								  screenRect.origin.y + screenRect.size.height,
								  pickerSize.width, pickerSize.height);
	
	self.datePickerView = [[UIDatePicker alloc] initWithFrame:startRect];
	self.datePickerOpen = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupAddMeetingButton];
	[self setupDateFormatter];
	[self setupDatePickerView];
	[self setupCells];

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
//	if (self.datePickerView.superview == nil) {
	

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
		
		UIBarButtonItem *doneButton= [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
		self.navigationItem.rightBarButtonItem = doneButton;
	
	self.datePickerOpen = YES;
//	}
}

- (void)donePressed {
	[self dismissDatePicker];
}

- (void)dismissDatePicker {
	CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
	CGRect endFrame = self.datePickerView.frame;
	endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
	
	// start the slide down animation
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	
	// we need to perform some post operations after the animation is complete
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
	
	self.datePickerView.frame = endFrame;
	[UIView commitAnimations];
	
	// grow the table back again in vertical size to make room for the date picker
	CGRect newFrame = self.tableView.frame;
	newFrame.size.height += self.datePickerView.frame.size.height;
	self.tableView.frame = newFrame;
	
	// remove the "Done" button in the nav bar
	self.navigationItem.rightBarButtonItem = nil;
	
	// deselect the current table row
	NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self.dateCell setSelected:NO];
	
	// add back "Add" tool bar button
	self.navigationItem.rightBarButtonItem = self.addMeetingButton;
	
	self.datePickerOpen = NO;

}

- (void)pickerChanged:(id)sender {
	self.dateCell.dateLabel.text = [self.dateFormatter stringFromDate:self.datePickerView.date];
	[self switchDateFormatters];
	self.dateCell.formattedDate = [self.dateFormatter stringFromDate:self.datePickerView.date];
	[self switchDateFormatters];
}

#pragma mark - TextField Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    int tag = textField.tag;
    
    switch (tag) {
//        case VMAddMeetingTags_DayTextField:
//            [self.dateCell.dateLabel becomeFirstResponder];
//			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:VMDateSection_Date inSection:VMMeetingSection_DateFields] 
//								  atScrollPosition:UITableViewRowAnimationNone animated:YES];
            break;
//        case VMAddMeetingTags_DateTextField:
//            [self.speakerCell.textField becomeFirstResponder];
//			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:VMSpeakerSection_Speaker inSection:VMMeetingSection_SpeakerFields] 
//								  atScrollPosition:UITableViewRowAnimationNone animated:YES];
//            break;
        case VMAddMeetingTags_SpeakerTextField:
            [self.topicCell.textField becomeFirstResponder];
//			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:VMSpeakerSection_Topic inSection:VMMeetingSection_SpeakerFields] 
//								  atScrollPosition:UITableViewRowAnimationNone animated:YES];
            break;
        case VMAddMeetingTags_TopicTextField:
			[self.descriptionCell.textField becomeFirstResponder];
//			[self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:VMSpeakerSection_Description inSection:VMMeetingSection_SpeakerFields] 
//								  atScrollPosition:UITableViewRowAnimationNone animated:YES];
            break;
        case VMAddMeetingTags_DescriptionTextField:
            break;
        default:
            break;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
//	CGPoint contentOffset = self.tableView.contentOffset;
//	contentOffset.y += 10*textField.tag;
	
	CGPoint contentOffset = CGPointMake(0, 35*textField.tag);
//	NSLog(@"content offset = %f", contentOffset.y);
	[self.tableView setContentOffset:contentOffset animated:NO];
	if (self.datePickerOpen) {
		[self dismissDatePicker];
	}

}
		 
 - (void)dismissKeyboard {
	 [self.view endEditing:YES];
 }


#pragma mark - TableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
        case VMMeetingSection_DateFields:
//			NSLog(@"%d",VMDateSection_RowCount);
            return VMDateSection_RowCount;
			
		case VMMeetingSection_CheckboxFields:
//			NSLog(@"%d",VMCheckboxSection_RowCount);
			return VMCheckboxSection_RowCount;
            
        case VMMeetingSection_SpeakerFields:
//			NSLog(@"%d",VMSpeakerSection_RowCount);
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
        case VMDateSection_Date:
            return self.dateCell;
        default:
            break;
    }
    
    return nil;
}

- (VMFormCell *)cellForCheckboxFieldAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case VMCheckboxSection_hasFood:
            return self.hasFoodCell;  
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
		case VMMeetingSection_CheckboxFields:
			cell = [self cellForCheckboxFieldAtIndexPath:indexPath];
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

@end
