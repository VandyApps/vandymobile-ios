//
//  AppsCell.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "AppsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "Sizer.h"
#import "UIView+Frame.h"

@implementation AppsCell
@synthesize cellImage = _cellImage;
@synthesize cellImageContainerView = _cellImageContainerView;
@synthesize mainLabel = _mainLabel;
@synthesize subLabel = _subLabel;
@synthesize labelsContainerView = _labelsContainerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath withMainFont:(UIFont *)font {
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (!font) {
        font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
    }
    self.mainLabel.font = font;
	self.subLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:13.0];
    
    self.mainLabel.lineBreakMode = UILineBreakModeWordWrap;
    self.mainLabel.numberOfLines = 0;
	
	UIView *goldenColor = [[UIView alloc] init];
	goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
	self.selectedBackgroundView = goldenColor;
    
    UIView *heatherGray = [[UIView alloc] init];
	heatherGray.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:.6] /*#f0f0f0*/;
    heatherGray.opaque = YES;
    heatherGray.alpha = .6;
	self.backgroundView = heatherGray;
    
    self.cellImage.layer.cornerRadius = 7;
    self.cellImage.clipsToBounds = YES;
    self.cellImage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.cellImage.layer.borderWidth = .5;
    [self addShadowToView:self.cellImageContainerView];
    
    CGFloat oldHeight = self.mainLabel.height;
    self.mainLabel.height = [Sizer sizeText:self.mainLabel.text withConstraint:CGSizeMake(self.mainLabel.width, MAXFLOAT) font:self.mainLabel.font andMinimumHeight:21];
    
    self.labelsContainerView.height += self.mainLabel.height - oldHeight;
    
    self.subLabel.top = self.mainLabel.bottom + 2;
    
    oldHeight = self.subLabel.height;
    self.subLabel.height = [Sizer sizeText:self.subLabel.text withConstraint:CGSizeMake(self.subLabel.width, MAXFLOAT) font:self.subLabel.font andMinimumHeight:21];
    
    self.labelsContainerView.height += self.subLabel.height - oldHeight;
    
//    self.labelsContainerView.layer.borderWidth = 2;
//    self.labelsContainerView.layer.borderColor = [[UIColor redColor] CGColor];
    
    self.labelsContainerView.centerY = self.cellImageContainerView.centerY;
}

//+ (CGFloat)cellHeightForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
//    int numberOfRowsInSection = [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section];
//    if (numberOfRowsInSection == 1) {
//        return 58;
//    } else {
//        BOOL first  = indexPath.row == 0;
//        BOOL last   = indexPath.row == numberOfRowsInSection - 1;
//
//        if (first) {
//            return 54;
//        } else if (last) {
//            return 53;
//        } else { //middle
//            return 48;
//        }
//    }
//}

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
