//
//  VMTextInputCell.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMTextInputCell.h"

@implementation VMTextInputCell

@synthesize titleLabel;
@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor            = [UIColor clearColor];
		
        self.titleLabel                 = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 90, 15)];
        self.titleLabel.textColor       = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.font            = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self addSubview:self.titleLabel];
        
        
        self.textField                  = [[UITextField alloc] initWithFrame:CGRectMake(115, 5, 180, 35)];
		[self.textField setBorderStyle:UITextBorderStyleRoundedRect];
		[self addSubview:self.textField];
		
        
        UIGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self addGestureRecognizer:tapRecognizer];
        
    }
    return self;
}

- (id)cellContent {
	return self.textField.text;
}
								  

- (void)dealloc {
}

- (void)onTap:(UIGestureRecognizer *)recognizer {
    [self.textField becomeFirstResponder];
}

+ (VMTextInputCell *)textFieldCellWithTitle:(NSString *)title forDelegate:(id)target withTag:(NSInteger)tag{
    VMTextInputCell *cell   = [[VMTextInputCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    cell.titleLabel.text    = title;
    cell.textField.delegate = target;
	cell.textField.tag		= tag;
    return cell;
}

@end
