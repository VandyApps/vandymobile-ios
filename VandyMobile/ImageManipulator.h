//
//  ImageManipulator.h
//  VandyMobile
//
//  Created by Scott Andrus on 7/25/12.
//  https://gist.github.com/62684
//

#import <Foundation/Foundation.h>

@interface ImageManipulator : NSObject

+ (UIImage *)makeRoundCornerImage:(UIImage*)img withCornerWidth:(int) cornerWidth andCornerHeight:(int)cornerHeight;

@end
