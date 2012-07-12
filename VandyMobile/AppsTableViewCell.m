//
//  AppsTableViewCell.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "AppsTableViewCell.h"

@implementation AppsTableViewCell
@synthesize cellImage = _cellImage;
@synthesize mainLabel = _mainLabel;
@synthesize subLabel = _subLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	self.backgroundColor = [UIColor clearColor];
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	self.subLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
	
	UIView *goldenColor = [[UIView alloc] init];
	goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
	self.selectedBackgroundView = goldenColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
