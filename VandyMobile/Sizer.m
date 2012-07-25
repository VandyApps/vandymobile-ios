//
//  Sizer.m
//  VandyMobile
//
//  Created by Scott Andrus on 6/16/12.
//
//

#import "Sizer.h"

@implementation Sizer

+ (CGRect)sizeTextView:(UITextView *)textView withMaxHeight:(CGFloat)maxHeight andFont:(UIFont *)font {
    
    // Resize stuff
    if (!font) {
        // If no font, default to Helvetica 14
        font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    
    // Constraint is the max float
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    
    // Grab label size
    CGSize labelSize = [textView.text sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];

    float height;
    
    if (labelSize.height > maxHeight - 40) {
        height = maxHeight;
        [textView setUserInteractionEnabled:YES];
    } else if (labelSize.height < 50) {
        height = 50;
        [textView setUserInteractionEnabled:NO];
    } else {
        height = labelSize.height + 6;
        [textView setUserInteractionEnabled:NO];
    }
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, height);
    return textView.frame;
}

+ (CGFloat)sizeText:(NSString *)text withMaxHeight:(CGFloat)maxHeight andFont:(UIFont *)font andWidth:(CGFloat)width {
    
    // Resize stuff
    if (!font) {
        // If no font, default to Helvetica 14
        font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    
    // Constraint is the max float
    //CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    
    // Grab label size
    CGSize labelSize = [text sizeWithFont:font forWidth:width lineBreakMode:NSLineBreakByWordWrapping];

    float height;
    
    
    NSScanner *theScanner = [NSScanner scannerWithString:text];
    while (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"\n" intoString:nil];
        height += 10;
    }
    
    if (labelSize.height > maxHeight - 40) {
        height = maxHeight;
    } else if (labelSize.height < 45) {
        height = 110;
    } else {
        height = labelSize.height + 65;
    }
    
//    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 678, 0)];
//    textView.font = font;
//    textView.text = text;
//    [textView sizeToFit];

    
//    CGFloat newHeight = textView.contentSize.height;
    
    
    return height;
}

@end
