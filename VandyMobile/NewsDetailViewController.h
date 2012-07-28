//
//  NewsDetailViewController.h
//  VandyMobile
//
//  Created by Scott Andrus on 6/6/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *commentFrame;
@property (weak, nonatomic) IBOutlet UITextView *newsText;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (strong, nonatomic) NSDictionary *tweet;

@end
