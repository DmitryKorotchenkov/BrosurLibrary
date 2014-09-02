//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIColor;


@interface BLGradientColor : NSObject

@property (nonatomic, strong) UIColor *startColor;
@property (nonatomic, strong) UIColor *endColor;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

- (instancetype)initWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

+ (instancetype)colorWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint;

@end