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

@property (nonatomic, strong) UILabel       *titleLabel;
@property (nonatomic, strong) UITextField   *textField;

+ (VMTextInputCell *)textFieldCellWithTitle:(NSString *)title forDelegate:(id)target;

@end
