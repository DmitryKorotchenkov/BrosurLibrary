//
// Created by Dmitry Korotchenkov on 08/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLParsedViewDescription.h"


@interface BLParsedTextViewDescription : BLParsedViewDescription

@property (nonatomic, strong) NSAttributedString *attributedText;

@property (nonatomic, strong) NSArray *clippingPaths;

@end