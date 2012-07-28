//
//  AppsDetailViewController.m
//  VandyMobile
//
//  Created by Scott Andrus on 7/12/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "AppsDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Sizer.h"
#import "UIView+Frame.h"
#import "UIImage+Color.h"

@interface AppsDetailViewController ()

@end

@implementation AppsDetailViewController
@synthesize app;
@synthesize appIconImage;
@synthesize appIconImageContainerView;
@synthesize descriptionTextView;
@synthesize belowTextViewContainerView;
@synthesize envelopeImageView;
@synthesize labelsContainerView;
@synthesize teamLabel;
@synthesize nameLabel;
@synthesize taglineLabel;
@synthesize appStoreButton;
@synthesize teamButton;
@synthesize backgroundView;

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
    
    // UI Customization
    self.backgroundView.image = [UIImage imageNamed:@"VandyMobileBackgroundCanvas"];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"NewNavBar4"] forBarMetrics:UIBarMetricsDefault];
    
    self.appIconImage.layer.cornerRadius = 10;
    self.appIconImage.clipsToBounds = YES;
    self.appIconImage.layer.borderColor = [[UIColor grayColor] CGColor];
    self.appIconImage.layer.borderWidth = 1;
    
    self.descriptionTextView.layer.cornerRadius = 14;
    self.descriptionTextView.clipsToBounds = YES;
    self.descriptionTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    self.descriptionTextView.layer.borderWidth = .5;
    
    self.appStoreButton.opaque = YES;
    self.appStoreButton.alpha = .8;
    self.appStoreButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.appStoreButton.layer.borderWidth = 2;
    self.appStoreButton.layer.cornerRadius = 5;
    
    
    // Set labels
    self.teamLabel.text = app.team;
    self.nameLabel.text = app.name;
    self.taglineLabel.text = app.tagline;
    self.descriptionTextView.text = app.description;
    //self.labelsContainerView.centerY = self.appIconImage.centerY;
    
    // Sizing code
    self.descriptionTextView.height = [Sizer sizeText:self.descriptionTextView.text withConstraint:CGSizeMake(self.descriptionTextView.width, 140) font:self.descriptionTextView.font andMinimumHeight:50];
    self.belowTextViewContainerView.top = self.descriptionTextView.bottom + 1;
    
    
    self.teamButton.opaque = YES;
	self.teamButton.backgroundColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.01 alpha:.8] /*#333333*/;
    self.teamButton.layer.borderWidth = 2;
    self.teamButton.layer.cornerRadius = 5;
    self.teamButton.layer.borderColor = [[UIColor colorWithRed:1 green:1 blue:1 alpha:1] CGColor];

    self.envelopeImageView.image = [UIImage imageNamed:@"18-envelope" withColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1]];

    [self downloadPhoto];
    
    [self addShadowToView:self.appIconImageContainerView];
}

- (void)viewWillAppear:(BOOL)animated {
    
    // Code to manage Nav Bar logo
    
    NSArray *navSubviews = [self.navigationController.navigationBar subviews];
    //    NSLog(@"%@", navSubviews);
    for (UIView * subview in navSubviews) {
        if ([subview isKindOfClass:[UIImageView class]] && subview != [navSubviews objectAtIndex:0]) {
            [subview removeFromSuperview];
        }
    }
}

- (void)downloadPhoto {
    // Download photo
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loading startAnimating];
    UIBarButtonItem * temp = self.navigationItem.rightBarButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loading];
    
    dispatch_queue_t downloadQueue = dispatch_queue_create("image downloader", NULL);
    dispatch_async(downloadQueue, ^{
        
        NSData *imgUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.app.imagePath]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.appIconImage setImage:[UIImage imageWithData:imgUrl]];
            [loading stopAnimating];
            self.navigationItem.rightBarButtonItem = temp;
        });
    });
    dispatch_release(downloadQueue);
    
}

- (id)addShadowToView:(UIView *)view {
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOpacity = .6;
    view.layer.shadowRadius = 2.0;
    view.layer.shadowOffset = CGSizeMake(-1, 1);
    
    return view;
}

- (IBAction)devTeamButtonPressed {
//    NSString *to = @"contact@vandymobile.org";
//    NSString *subject = app.name;
//    
//    NSString *mail = [NSString stringWithFormat:@"mailto:%@?&subject=%@", to, subject];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[mail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:[NSString stringWithFormat:@"%@ App", app.name]];
        
        NSArray *toRecipients = [NSArray arrayWithObjects:@"contact@vandymobile.com", @"president@vandymobile.com", nil];
        [mailer setToRecipients:toRecipients];
        
        //UIImage *myImage = [UIImage imageNamed:@"mobiletuts-logo.png"];
        //NSData *imageData = UIImagePNGRepresentation(myImage);
        //[mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"mobiletutsImage"];
        
        NSString *emailBody = @"Hi there!";
        [mailer setMessageBody:emailBody isHTML:NO];
        
        mailer.modalPresentationStyle = UIModalPresentationPageSheet;
        
        [self presentModalViewController:mailer animated:YES];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)appStoreButtonPressed {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.app.itunesPath]];
}

- (void)viewDidUnload
{
    [self setBackgroundView:nil];
    [self setAppIconImage:nil];
    [self setDescriptionTextView:nil];
    [self setTeamButton:nil];
    [self setAppStoreButton:nil];
    [self setTeamLabel:nil];
    [self setNameLabel:nil];
    [self setTaglineLabel:nil];
    [self setBelowTextViewContainerView:nil];
    [self setAppIconImageContainerView:nil];
    [self setEnvelopeImageView:nil];
    [self setLabelsContainerView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
