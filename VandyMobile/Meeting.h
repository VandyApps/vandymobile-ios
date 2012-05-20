//
//  Meeting.h
//  VandyMobile
//
//  Created by Graham Gaylor on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 {
 content = "this is a test";
 "created_at" = "2012-05-20T04:40:34Z";
 id = 2;
 name = Graham;
 title = test2;
 "updated_at" = "2012-05-20T04:40:34Z";
 },
*/

@interface Meeting : NSObject

@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *content;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
