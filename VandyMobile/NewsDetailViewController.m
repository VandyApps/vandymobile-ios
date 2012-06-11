//
//  NewsDetailViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 6/6/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize backgroundImageView;
@synthesize commentFrame;
@synthesize newsText;
@synthesize timestampLabel;
@synthesize tweet;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.backgroundImageView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    self.newsText.text = [self.tweet objectForKey:@"text"];
    self.timestampLabel.textColor = [UIColor colorWithRed:0.639 green:0.639 blue:0.639 alpha:1] /*#a3a3a3*/;
    self.timestampLabel.text = [self.tweet objectForKey:@"created_at"];
    self.commentFrame.layer.cornerRadius = 11;
    self.commentFrame.clipsToBounds = YES;
    self.commentFrame.layer.borderColor = [[UIColor grayColor] CGColor];
    self.commentFrame.layer.borderWidth = .5;
    self.commentFrame.backgroundColor = [UIColor whiteColor];
    
    // Resize stuff
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [self.newsText.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    float height;
    if (labelSize.height < 15) {
        height = 30;
    } else {
        height = labelSize.height + 10;
    }
    self.newsText.frame = CGRectMake(self.newsText.frame.origin.x, self.newsText.frame.origin.y, self.newsText.frame.size.width, height);
    self.commentFrame.frame = CGRectMake(self.commentFrame.frame.origin.x, self.commentFrame.frame.origin.y, self.commentFrame.frame.size.width, height+30);
    self.timestampLabel.frame = CGRectMake(self.timestampLabel.frame.origin.x, self.newsText.frame.origin.y + height, self.timestampLabel.frame.size.width, self.timestampLabel.frame.size.height);
}

- (void)viewWillAppear:(BOOL)animated {
    NSArray *navSubviews = [self.navigationController.navigationBar subviews];
    //    NSLog(@"%@", navSubviews);
    for (UIView * subview in navSubviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview != [navSubviews objectAtIndex:0]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)viewDidUnload
{
    [self setBackgroundImageView:nil];
    [self setCommentFrame:nil];
    [self setNewsText:nil];
    [self setTimestampLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
