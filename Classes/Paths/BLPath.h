//
// Created by Dmitry Korotchenkov on 05/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>


@interface BLPath : NSObject

// must be overridden
- (CGPathRef)getCGPath;

@end