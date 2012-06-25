//
//  VMFormCell.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VMFormCell : UITableViewCell

+ (CGFloat)cellHeightForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (id)cellContent;

@end
