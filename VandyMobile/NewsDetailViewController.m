//
//  NewsDetailViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 6/6/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "NewsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Sizer.h"
#import "UIView+Frame.h"

@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize backgroundImageView;
@synthesize commentFrame;
@synthesize newsText;
@synthesize timestampLabel;
@synthesize profileImageView;
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
    
    self.commentFrame.layer.cornerRadius = 8;
    self.commentFrame.layer.borderColor = [[UIColor grayColor] CGColor];
    self.commentFrame.layer.borderWidth = .5;
    
    // Resize stuff
    // Size it!
    
    CGFloat oldHeight = self.newsText.height;
    CGFloat newHeight = [Sizer sizeText:self.newsText.text withConstraint:CGSizeMake(self.newsText.width, MAXFLOAT) font:self.newsText.font andMinimumHeight:50];
    
    self.newsText.height = newHeight;
    
    self.timestampLabel.top += newHeight - oldHeight;
    self.commentFrame.height += newHeight - oldHeight;
    
    self.commentFrame.backgroundColor = [UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] /*#f0f0f0*/;
    self.commentFrame.opaque = YES;
    
    [self downloadPhotoForTweet:tweet andImageView:self.profileImageView];
    
    // Round imageview
    self.profileImageView.layer.cornerRadius = 5;
    self.profileImageView.layer.borderWidth = .5;
    self.profileImageView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.profileImageView.clipsToBounds = YES;
    
    [self addShadowToView:self.commentFrame];
    
    
}

- (id)addShadowToView:(UIView *)view {
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = .8;
    view.layer.shadowRadius = 3.0;
    view.layer.shadowOffset = CGSizeMake(0.0, 3.5);
    //view.layer.shadowPath = [UIBezierPath bezierPathWithRect:view.layer.frame].CGPath;
    
    return view;
}

- (void)downloadPhotoForTweet:(NSDictionary *)tweet andImageView:(UIImageView *)imageView {
    // Download photo
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loading startAnimating];
    UIBarButtonItem * temp = self.navigationItem.leftBarButtonItem;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loading];
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSString *urlstring = @"http://i.imgur.com/0dumt.png";//[[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
        NSData *imgUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlstring]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            imageView.image = [UIImage imageWithData:imgUrl];
            [loading stopAnimating];
            self.navigationItem.leftBarButtonItem = temp;
        });
    });
    dispatch_release(downloadQueue);
    //return imageView.image;
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
    [self setProfileImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
