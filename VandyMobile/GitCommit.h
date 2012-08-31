//
//  GitCommit.h
//  VandyMobile
//
//  Created by Graham Gaylor on 7/27/12.
//
//

#import <Foundation/Foundation.h>

@interface GitCommit : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *avatarURL;
@property (nonatomic, copy) NSDate *commitDate;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *commitMessage;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@end