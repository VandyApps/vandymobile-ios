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
        font = [UIFont fontWithName:@"Helvetica" size:14];
    }
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
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

@end
