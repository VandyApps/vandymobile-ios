//
//  Sizer.m
//  VandyMobile
//
//  Created by Scott Andrus on 6/16/12.
//
//

#import "Sizer.h"

@implementation Sizer

+ (CGRect)sizeTextView:(UITextView *)textView {
    // Resize stuff
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [textView.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    float height;
    
    if (labelSize.height > 121) {
        height = 121;
    } else {
        height = labelSize.height + 10;
    }
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, height);
    return textView.frame;
}

@end
