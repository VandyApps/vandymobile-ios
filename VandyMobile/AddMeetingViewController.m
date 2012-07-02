//
//  AddMeetingViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddMeetingViewController.h"

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


- (void)viewDidLoad
{
    [super viewDidLoad];
	[self setupCells];
}

- (void)viewDidUnload
{
	[self setTableView:nil];
    [super viewDidUnload];
	

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
