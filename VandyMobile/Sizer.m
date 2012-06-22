//
//  Sizer.m
//  VandyMobile
//
//  Created by Scott Andrus on 6/16/12.
//
//

#import "Sizer.h"

@implementation Sizer

+ (void)sizeTextView:(UITextView *)textView {
    // Resize stuff
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:15];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [textView.text sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    float height;
    if (labelSize.height < 15) {
        height = 30;
    } else {
        height = labelSize.height + 10;
    }
    textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, height);
//    self.commentFrame.frame = CGRectMake(self.commentFrame.frame.origin.x, self.commentFrame.frame.origin.y, self.commentFrame.frame.size.width, height+30);
//    self.timestampLabel.frame = CGRectMake(self.timestampLabel.frame.origin.x, self.newsText.frame.origin.y + height, self.timestampLabel.frame.size.width, self.timestampLabel.frame.size.height);
}

@end
