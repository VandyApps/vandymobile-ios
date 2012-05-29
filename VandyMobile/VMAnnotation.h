//
//  VMAnnotation.h
//  VandyMobile
//
//  Created by Scott Andrus on 5/28/12.
//  Copyright (c) 2012 Vanderbilt University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface VMAnnotation : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) NSString *title;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (void)setSubtitle:(NSString *)subtitle;
- (void)setTitle:(NSString *)title;

@end
