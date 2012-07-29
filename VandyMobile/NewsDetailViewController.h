//
//  NewsDetailViewController.h
//  VandyMobile
//
//  Created by Scott Andrus on 6/6/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsCell.h"

@interface NewsDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentFrame;
@property (weak, nonatomic) IBOutlet UILabel *newsText;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;



@property (strong, nonatomic) NSDictionary *tweet;

@end
