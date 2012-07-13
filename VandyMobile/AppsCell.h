//
//  AppsCell.h
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;

- (void)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;


@end
