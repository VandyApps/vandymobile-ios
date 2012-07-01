//
//  AddMeetingViewController.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddMeetingViewController.h"

enum VMMeetingSections {
    VMMeetingSection_DateFields = 0,
    VMMeetingSection_SpeakerFields,
	VMMeetingSection_Count,
};

enum VMDateSectionRows {
    VMDateSection_Day,
	VMDateSection_Date,
	VMDateSection_RowCount,


};

enum VMSpeakerSectionRows {
    VMSpeakerSection_Speaker,
    VMSpeakerSection_Topic,
	VMSpeakerSection_Description,
	VMSpeakerSection_RowCount,

};


@interface AddMeetingViewController ()

@end

@implementation AddMeetingViewController

@synthesize tableView = _tableView;
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
        self.dayCell.textField.tag								= 0;
    }
    
    if (!self.dateCell) {
        self.dateCell											= [VMTextInputCell textFieldCellWithTitle:@"Date" forDelegate:self];
        self.dateCell.textField.autocorrectionType				= UITextAutocorrectionTypeNo;
        self.dateCell.textField.autocapitalizationType			= UITextAutocapitalizationTypeNone;
        self.dateCell.textField.tag								= 1;
    }
    
    if (!self.speakerCell) {
        self.speakerCell										= [VMTextInputCell textFieldCellWithTitle:@"Speaker" forDelegate:self];
        self.speakerCell.textField.autocorrectionType			= UITextAutocorrectionTypeNo;
        self.speakerCell.textField.autocapitalizationType		= UITextAutocapitalizationTypeNone;
        self.speakerCell.textField.tag							= 2;
    }
    
    if (!self.topicCell) {
        self.topicCell											= [VMTextInputCell textFieldCellWithTitle:@"Topic" forDelegate:self];
        self.topicCell.textField.autocorrectionType				= UITextAutocorrectionTypeNo;
        self.topicCell.textField.autocapitalizationType			= UITextAutocapitalizationTypeNone;
        self.topicCell.textField.tag							= 3;
    }
	
	if (!self.descriptionCell) {
        self.descriptionCell									= [VMTextInputCell textFieldCellWithTitle:@"Description" forDelegate:self];
        self.descriptionCell.textField.autocorrectionType		= UITextAutocorrectionTypeNo;
        self.descriptionCell.textField.autocapitalizationType	= UITextAutocapitalizationTypeNone;
        self.descriptionCell.textField.tag						= 4;
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
