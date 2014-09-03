//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "BLView.h"
#import "BLGradientColor.h"
#import "BLDrawingObject.h"


@implementation BLView

- (id)init {
    self = [super init];
    if (self) {
        BLDrawingObjectCircle *circle = [BLDrawingObjectCircle circleWithRect:CGRectMake(50, 50, 100, 100) width:10];

        CGFloat startX = CGRectGetMinX(circle.rect);
        CGFloat startY = CGRectGetMinY(circle.rect);
        CGFloat endX = CGRectGetMaxX(circle.rect);
        CGFloat endY = CGRectGetMaxY(circle.rect);
//        circle.gradientColor = [BLGradientColor colorWithStartColor:[UIColor redColor] endColor:[UIColor blueColor] startPoint:CGPointMake(startX, startY) endPoint:CGPointMake(endX, endY)];
        circle.fillColor = [UIColor redColor];
        circle.strokeColor = [UIColor greenColor];

        self.drawingObjects = @[circle];
    }

    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.backgroundGradient) {
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};

        CGFloat startComponents[4];
        CGFloat endComponents[4];
        [self.backgroundGradient.startColor getRed:&startComponents[0] green:&startComponents[1] blue:&startComponents[2] alpha:&startComponents[3]];
        [self.backgroundGradient.endColor getRed:&endComponents[0] green:&endComponents[1] blue:&endComponents[2] alpha:&endComponents[3]];

        CGFloat components[8] = {startComponents[0], startComponents[1], startComponents[2], startComponents[3],
                endComponents[0], endComponents[1], endComponents[2], endComponents[3]};

        CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);

        CGContextDrawLinearGradient(context, myGradient, self.backgroundGradient.startPoint, self.backgroundGradient.endPoint, 0);
        CGColorSpaceRelease(myColorspace);
        CGGradientRelease(myGradient);
    }

    for (BLDrawingObject *object in self.drawingObjects) {
        [object drawInContext:context];
    }
}


@end