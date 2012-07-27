//
//  CustomCellBackgroundView.h
//
//  Created by Mike Akers on 11/21/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
    CustomCellBackgroundViewPositionTop,
    CustomCellBackgroundViewPositionMiddle,
    CustomCellBackgroundViewPositionBottom,
    CustomCellBackgroundViewPositionSingle
} CustomCellBackgroundViewPosition;

@interface CustomCellBackgroundView : UIView {
    UIColor *borderColor;
    UIColor *fillColor;
    CustomCellBackgroundViewPosition position;
}

@property(nonatomic, retain) UIColor *borderColor, *fillColor;
@property(nonatomic) CustomCellBackgroundViewPosition position;
@end