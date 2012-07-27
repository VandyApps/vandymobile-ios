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

+ (CGFloat)sizeText:(NSString *)text withConstraint:(CGSize)constraintSize font:(UIFont *)font andMinimumHeight:(CGFloat)minHeight {
    
    // Resize stuff
    if (!font) {
        // If no font, default to Helvetica 14
        font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    
    // Grab label size
    CGSize labelSize = [text sizeWithFont:font constrainedToSize:constraintSize];
    
    float height = labelSize.height;
    
    NSScanner *theScanner = [NSScanner scannerWithString:text];
    while (![theScanner isAtEnd]) {
        [theScanner scanUpToString:@"\n\n" intoString:nil];
        //height += 10;
    }
    
    if (labelSize.height > constraintSize.height) {
        height = constraintSize.height;
    } else if (labelSize.height < minHeight) {
        height = minHeight;
    }
    
    return height;
}

@end
