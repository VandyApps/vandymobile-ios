//
//  FirstTimeViewController.m
//
//  Created by Scott Andrus on 8/1/12.
//

#import "FirstTimeViewController.h"
#import "UIView+Frame.h"
#import <QuartzCore/QuartzCore.h>

#define kSlideIdentifier @"IntroSlide"
#define kNumberOfSlides 6

@interface FirstTimeViewController ()

@end

@implementation FirstTimeViewController
@synthesize contentScrollView;
@synthesize pageControl;
@synthesize firstImageView;
@synthesize logoContainerView;

@synthesize backgroundImageView = _backgroundImageView;
@synthesize delegate = _delegate;
@synthesize numberOfSlides = _numberOfSlides;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andNumberOfSlides:(NSInteger)numberOfSlides {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.numberOfSlides = numberOfSlides;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.contentScrollView.delegate = self;
    
    if (!self.numberOfSlides) {
        self.numberOfSlides = kNumberOfSlides;
    }
    [self sizeScrollView];
    
    [self createSlidesWithAmount:self.numberOfSlides];
    
    self.pageControl.numberOfPages = self.numberOfSlides;
    
    // UI
    self.logoContainerView.backgroundColor = [UIColor colorWithRed:0.881 green:0.881 blue:0.881 alpha:.5] /*#f0f0f0*/;
    self.logoContainerView.layer.cornerRadius = 8;
    self.logoContainerView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    self.logoContainerView.layer.borderWidth = .5;
    [self addShadowToView:((UIImageView *)self.logoContainerView.subviews.lastObject)];
    
}

- (id)addShadowToView:(UIView *)view {
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = .6;
    view.layer.shadowRadius = 2.0;
    view.layer.shadowOffset = CGSizeMake(-1, 1);
    
    return view;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewLoaded = YES;
}

- (void)viewDidUnload
{
    [self setContentScrollView:nil];
    [self setPageControl:nil];
    [self setFirstImageView:nil];
    [self setLogoContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (self.viewLoaded) {
        return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    } else return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.backgroundImageView.hidden = NO;
    }
    else {
        self.backgroundImageView.hidden = YES;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self sizeScrollView];
    for (UIImageView *slide in self.contentScrollView.subviews) {
        if (slide != self.firstImageView) {
            [slide removeFromSuperview];
        }
    }
    [self createSlidesWithAmount:self.numberOfSlides];
}

- (void)sizeScrollView {
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width * self.numberOfSlides, self.contentScrollView.height);
}

#pragma mark - OverviewDelegate Methods
- (void)setBGImage:(UIImageView *)backgroundImageView {
    self.backgroundImageView = backgroundImageView;
}

- (void)setModalDelegate:(id)delegate {
    self.delegate = delegate;
}

- (void)createSlidesWithAmount:(NSInteger)numberOfSlides {
    // Set the first image
    self.firstImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", kSlideIdentifier, @"1"]];
    
    // Temp pointer
    UIImageView *currentImageView;
    
    // For the number of slides from the second image on
    for (size_t i = 1; i < numberOfSlides; ++i) {
        // If the specified image exists, set it as so.
        if ([UIImage imageNamed:[NSString stringWithFormat:@"%@%ld", kSlideIdentifier, i+1]]) {
            currentImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%ld", kSlideIdentifier, i+1]]];
        }
        // Else just set it to the first image
        else currentImageView = [[UIImageView alloc] initWithImage:firstImageView.image];
        
        currentImageView.autoresizingMask = firstImageView.autoresizingMask;
        currentImageView.contentMode = firstImageView.contentMode;
        
        // Set it at the proper position in the scroll view
        [self.contentScrollView addSubview:currentImageView];
        currentImageView.frame = self.firstImageView.frame;
        currentImageView.left = i * self.contentScrollView.width + firstImageView.left;
    }
    
    // Nullify that pointer
    currentImageView = nil;
}

- (IBAction)getStartedPressed {
    [self.delegate dismissModalViewControllerAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.contentScrollView.width;
    int page = floor((self.contentScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}

@end
