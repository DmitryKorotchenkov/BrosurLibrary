//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BLParsedViewDescription;


@interface BLParser : NSObject
- (BLParsedViewDescription *)parse:(NSDictionary *)dictionary;
@end