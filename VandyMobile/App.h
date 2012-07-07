//
//  App.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface App : NSObject

@property (nonatomic, copy) NSString *team;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *OS;
@property (nonatomic, copy) NSString *description;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
