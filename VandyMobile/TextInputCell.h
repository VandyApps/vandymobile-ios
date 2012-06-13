//
//  TextInputCell.h
//  
//
//  Created by Graham Gaylor on 6/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextInputCell : UITableViewCell {
	IBOutlet UILabel *title;
	IBOutlet UITextField *text;
}

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UITextField *text;

@property (strong, nonatomic) NSString *string;


@end
