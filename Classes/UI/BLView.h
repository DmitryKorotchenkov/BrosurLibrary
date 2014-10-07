//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BLGradientColor;


@interface BLView : UIView

@property (nonatomic, strong) BLGradientColor *backgroundGradient;

// array of BLDrawingObject's
@property (nonatomic, strong) NSArray *drawingObjects;

@end