//
//  VMFormCell.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMFormCell : UITableViewCell

//@property (nonatomic, retain) UIImageView   *backgroundImage;

//+ (CGFloat)cellHeightForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;

@end
