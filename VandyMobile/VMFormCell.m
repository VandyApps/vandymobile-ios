//
//  VMFormCell.m
//  VandyMobile
//
//  Created by Graham Gaylor on 6/24/12.
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

+ (CGFloat)cellHeightForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
    int numberOfRowsInSection = [tableView.dataSource tableView:tableView numberOfRowsInSection:indexPath.section];
    if (numberOfRowsInSection == 1) {
        return 58;
    } else {    
        BOOL first  = indexPath.row == 0;
        BOOL last   = indexPath.row == numberOfRowsInSection - 1;
        
        if (first) {
            return 54;
        } else if (last) {
            return 53;
        } else { //middle
            return 48;
        }
    }
}

- (id)cellContent {
	return nil;
}



@end
