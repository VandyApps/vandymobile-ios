//
//  VMFormCell.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VMFormCell.h"

@implementation VMFormCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
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
//    
//}

- (void)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	self.backgroundColor = [UIColor clearColor];
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	self.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
	self.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14.0];
	
	UIView *goldenColor = [[UIView alloc] init];
	goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
	self.selectedBackgroundView = goldenColor;
}
@end
