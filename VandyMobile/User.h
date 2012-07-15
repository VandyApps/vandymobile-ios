//
//  User.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSNumber *userID;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *team;
@property (nonatomic, copy) NSString *app;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)userDictionary;



@end
