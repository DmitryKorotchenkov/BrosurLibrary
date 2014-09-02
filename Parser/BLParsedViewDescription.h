//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class UIColor;
@class BLGradientColor;


@interface BLParsedViewDescription : NSObject

@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) BLGradientColor *backgroundGradientColor;
@property (nonatomic) CGRect frame;

@property (nonatomic, strong) NSArray *subviewsDescription;

- (instancetype)initWithType:(NSString *)type backgroundColor:(UIColor *)backgroundColor backgroundGradientColor:(BLGradientColor *)backgroundGradientColor frame:(CGRect)frame;

+ (instancetype)descriptionWithType:(NSString *)type backgroundColor:(UIColor *)backgroundColor backgroundGradientColor:(BLGradientColor *)backgroundGradientColor frame:(CGRect)frame;


@end