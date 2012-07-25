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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
