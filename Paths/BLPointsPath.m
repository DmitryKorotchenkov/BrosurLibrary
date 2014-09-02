//
// Created by Dmitry Korotchenkov on 05/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "BLPointsPath.h"

@interface BLPointsPath ()

@property(nonatomic, strong) NSMutableArray *points;

@end

@implementation BLPointsPath

- (id)init {
    self = [super init];
    if (self) {
        self.points = [NSMutableArray new];
    }

    return self;
}


- (void)addPoint:(CGPoint)point {
    [_points addObject:[NSValue valueWithCGPoint:point]];
}

- (void)enumeratePoints:(void (^)(CGPoint point, NSUInteger idx))block {
    [self.points enumerateObjectsUsingBlock:^(NSValue *obj, NSUInteger idx, BOOL *stop) {
        block(obj.CGPointValue, idx);
    }];
}

- (CGPathRef)getCGPath {
    CGMutablePathRef path = CGPathCreateMutable();
    [self enumeratePoints:^(CGPoint point, NSUInteger idx) {
        if (idx == 0) {
            CGPathMoveToPoint(path, NULL, point.x, point.y);
        } else {
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
        }

    }];
    CGPathCloseSubpath(path);
    return path;
}


@end