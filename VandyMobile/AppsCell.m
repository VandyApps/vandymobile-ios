//
//  AppsCell.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "AppsCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation AppsCell
@synthesize cellImage = _cellImage;
@synthesize cellImageContainerView = _cellImageContainerView;
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
	//self.backgroundColor = [UIColor clearColor];
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.mainLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	self.subLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
	
	UIView *goldenColor = [[UIView alloc] init];
	goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
	self.selectedBackgroundView = goldenColor;
    
    self.cellImage.layer.cornerRadius = 7;
    self.cellImage.clipsToBounds = YES;
    self.cellImage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.cellImage.layer.borderWidth = .5;
    [self addShadowToView:self.cellImageContainerView];
}

- (id)addShadowToView:(UIView *)view {
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = .6;
    view.layer.shadowRadius = 2.0;
    view.layer.shadowOffset = CGSizeMake(-1, 1);
    
    return view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
