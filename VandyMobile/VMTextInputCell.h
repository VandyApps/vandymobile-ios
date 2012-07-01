//
//  VMTextInputCell.h
//  VandyMobile
//
//  Created by Graham Gaylor on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VMFormCell.h"

@interface VMTextInputCell : VMFormCell

@property (nonatomic, retain) UILabel       *titleLabel;
@property (nonatomic, retain) UITextField   *textField;

+ (VMTextInputCell *)textFieldCellWithTitle:(NSString *)title forDelegate:(id)target;

@end
