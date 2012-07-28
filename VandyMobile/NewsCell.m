//
//  NewsCell.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/24/12.
//
//

#import "NewsCell.h"
#import "UIView+Frame.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewsCell
@synthesize backgroundImageView;
@synthesize timestampLabel;
@synthesize bodyTextLabel;
@synthesize profilePictureLabel;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.boundsSet = NO;
        //[self layoutSubviews];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.boundsSet = NO;
    }
    return self;
}


//- (void)layoutSubviews;
//{
//    // By default the cell bounds fill the table width, but its subviews (containing the opaque background and cell borders) are drawn with padding.
//    
//    CGRect bounds = [self bounds];
//    // Make sure any standard layout happens.
//    [super layoutSubviews];
//    // Debugging output.
//    NSLog(@"Subviews = %@", [self subviews]);
//    for (UIView *subview in [self subviews])
//    {
//        if ([subview isEqual:self.contentView] && !self.boundsSet) {
//            
//            bounds.origin.x += 10;
//            bounds.size.width -= 20;
//                
//            self.boundsSet = YES;
//
//            [self setBounds:bounds];
//        }
//    }
//
//
//}


- (void)configureCellForTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	
	UIView *goldenColor = [[UIView alloc] init];
	goldenColor.backgroundColor = [UIColor colorWithRed:0.925 green:0.824 blue:0.545 alpha:1]; /*#ecd28b*/
    goldenColor.layer.cornerRadius = 12;
    goldenColor.layer.borderWidth = .5;
    goldenColor.layer.borderColor = [[UIColor lightGrayColor] CGColor];
	self.selectedBackgroundView = goldenColor;
    
    
    //goldenColor.layer.borderWidth = 1;

//
//    UIView *heatherGray = [[UIView alloc] init];
//	heatherGray.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:.6] /*#f0f0f0*/;
//    heatherGray.opaque = YES;
//    heatherGray.alpha = .6;
//	self.backgroundView = heatherGray;
//    
//    self.layer.frame = CGRectMake(self.layer.frame.origin.x + 10, self.layer.frame.origin.y, self.frame.size.width - 20, self.frame.size.height);
//    self.layer.cornerRadius = 5;
//    self.layer.borderWidth = 2;
    
	self.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:.6] /*#f0f0f0*/;
    self.opaque = YES;
    self.alpha = .6;

}


@end
