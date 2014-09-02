//
// Created by Dmitry Korotchenkov on 30/07/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BLView.h"


@interface BLTextView : BLView

@property(nonatomic, copy) NSAttributedString *text;
@property(nonatomic, strong) NSArray *clippingPaths;

@property (nonatomic, strong) UIColor *textColor;

@end