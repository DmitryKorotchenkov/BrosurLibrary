//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGradientColor.h"


@implementation BLGradientColor

- (instancetype)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    self = [super init];
    if (self) {
        self.startColor = startColor;
        self.endColor = endColor;
        self.startPoint = startPoint;
        self.endPoint = endPoint;
    }

    return self;
}

+ (instancetype)colorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint {
    return [[self alloc] initWithStartColor:startColor endColor:endColor startPoint:startPoint endPoint:endPoint];
}

@end