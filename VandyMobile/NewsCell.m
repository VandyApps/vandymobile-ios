//
//  NewsCell.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/24/12.
//
//

#import "NewsCell.h"

@implementation NewsCell
@synthesize backgroundImageView;
@synthesize timestampLabel;
@synthesize bodyTextLabel;
@synthesize profilePictureLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	//self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	self.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
	//self.selectedBackgroundView = goldenColor;
    
    //UIView *heatherGray = [[UIView alloc] init];
	self.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:.6] /*#f0f0f0*/;
    self.opaque = YES;
    self.alpha = .6;
//	self.backgroundView = heatherGray;
    
//    self.cellImage.layer.cornerRadius = 7;
//    self.cellImage.clipsToBounds = YES;
//    self.cellImage.layer.borderColor = [[UIColor grayColor] CGColor];
//    self.cellImage.layer.borderWidth = .5;
//    [self addShadowToView:self.cellImageContainerView];
//    
//    self.cellImage.centerY = self.centerY;
    
}


@end
