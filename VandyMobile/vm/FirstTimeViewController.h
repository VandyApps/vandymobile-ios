//
//  FirstTimeViewController.h
//
//  Created by Scott Andrus on 8/1/12.
//

#import <UIKit/UIKit.h>
#import "UIViewController+Overview.h"


@interface FirstTimeViewController : UIViewController <UIScrollViewDelegate, OverviewDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;
@property (retain, nonatomic) IBOutlet UIImageView *firstImageView;
@property (weak, nonatomic) IBOutlet UIView *logoContainerView;

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIViewController * delegate;
@property BOOL viewLoaded;
@property NSInteger numberOfSlides;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andNumberOfSlides:(NSInteger)numberOfSlides;

@end
