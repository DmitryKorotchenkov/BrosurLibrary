//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLParsedViewDescription.h"
#import "BLGradientColor.h"


@implementation BLParsedViewDescription

- (instancetype)initWithType:(NSString *)type backgroundColor:(UIColor *)backgroundColor backgroundGradientColor:(BLGradientColor *)backgroundGradientColor frame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.type = type;
        self.backgroundColor = backgroundColor;
        self.backgroundGradientColor = backgroundGradientColor;
        self.frame = frame;
    }

    return self;
}

+ (instancetype)descriptionWithType:(NSString *)type backgroundColor:(UIColor *)backgroundColor backgroundGradientColor:(BLGradientColor *)backgroundGradientColor frame:(CGRect)frame {
    return [[self alloc] initWithType:type backgroundColor:backgroundColor backgroundGradientColor:backgroundGradientColor frame:frame];
}


@end