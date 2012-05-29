//
//  VMAnnotation.m
//  VandyMobile
//
//  Created by Scott Andrus on 5/28/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import "VMAnnotation.h"

@implementation VMAnnotation

@synthesize coordinate = _coordinate;
@synthesize subtitle = _subtitle;
@synthesize title = _title;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
}

- (void)setTitle:(NSString *)title {
    _title = title;
}

@end
