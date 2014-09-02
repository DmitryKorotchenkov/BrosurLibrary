//
// Created by Dmitry Korotchenkov on 05/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "BLPath.h"


@implementation BLPath

// must be overridden
-(CGPathRef)getCGPath {
    [self doesNotRecognizeSelector:_cmd];
    return NULL;
}

@end