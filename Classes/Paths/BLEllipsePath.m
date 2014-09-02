//
// Created by Dmitry Korotchenkov on 05/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "BLEllipsePath.h"


@interface BLEllipsePath ()
@property(nonatomic) CGRect rect;
@end

@implementation BLEllipsePath

+(BLEllipsePath *)createInRect:(CGRect)rect  {
    BLEllipsePath *path = [[self alloc] init];
    [path setEllipseInRect:rect];
    return path;
}

-(void)setEllipseInRect:(CGRect)rect {
    self.rect = rect;
}

- (CGPathRef)getCGPath {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddEllipseInRect(path, NULL, self.rect);
    return path;
}


@end