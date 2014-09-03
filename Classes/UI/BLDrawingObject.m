//
// Created by Dmitry Korotchenkov on 02/09/14.
//

#import <UIKit/UIKit.h>
#import "BLDrawingObject.h"
#import "BLGradientColor.h"


@implementation BLDrawingObject

- (void)drawInContext:(CGContextRef)context {
    CGContextSaveGState(context);

    [self addPathForDrawingToContext:context];

    if (self.needDrawGradient) {
        CGGradientRef myGradient;
        CGColorSpaceRef myColorspace;
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};

        UIColor *startColor = self.gradientColor.startColor;
        UIColor *endColor = self.gradientColor.endColor;
        CGFloat const *startComponents = CGColorGetComponents([startColor CGColor]);
        CGFloat const *endComponents = CGColorGetComponents([endColor CGColor]);

        CGFloat components[8] = {startComponents[0], startComponents[1], startComponents[2], startComponents[3],
                endComponents[0], endComponents[1], endComponents[2], endComponents[3]
        };

        myColorspace = CGColorSpaceCreateDeviceRGB();
        myGradient = CGGradientCreateWithColorComponents(myColorspace, components, locations, num_locations);

        CGContextClip(context);

        CGContextDrawLinearGradient(context, myGradient, self.gradientColor.startPoint, self.gradientColor.endPoint, 0);
        CGColorSpaceRelease(myColorspace);
        CGGradientRelease(myGradient);
    } else {
        if (self.fillColor) {
            CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
            CGContextFillPath(context);
        }
        if (self.strokeColor) {
            CGContextSetStrokeColorWithColor(context, self.fillColor.CGColor);
            CGContextStrokePath(context);
        }
    }

    CGContextRestoreGState(context);
}

- (BOOL)needDrawGradient {
    return self.gradientColor != nil;
}

- (void)addPathForDrawingToContext:(CGContextRef)pContext {

}

@end

@implementation BLDrawingObjectCircle

- (instancetype)initWithRect:(CGRect)rect width:(CGFloat)width {
    self = [super init];
    if (self) {
        self.rect = rect;
        self.width = width;
    }

    return self;
}

+ (instancetype)circleWithRect:(CGRect)rect width:(CGFloat)width {
    return [[self alloc] initWithRect:rect width:width];
}


- (void)addPathForDrawingToContext:(CGContextRef)context {
    CGContextAddEllipseInRect(context, self.rect);
}

@end

@implementation BLDrawingObjectLine

- (instancetype)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(CGFloat)width {
    self = [super init];
    if (self) {
        self.startPoint = startPoint;
        self.endPoint = endPoint;
        self.width = width;
    }

    return self;
}

+ (instancetype)lineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(CGFloat)width {
    return [[[self alloc] initWithStartPoint:startPoint endPoint:endPoint width:width] autorelease];
}


- (void)addPathForDrawingToContext:(CGContextRef)context {
    if (self.needDrawGradient) {
        double halfWidth = self.width / 2;

        double slope, cosy, siny;

        slope = atan2((self.startPoint.y - self.endPoint.y), (self.startPoint.x - self.endPoint.x));
        cosy = cos(slope);
        siny = sin(slope);
        CGContextMoveToPoint(context, self.startPoint.x - halfWidth * siny, self.startPoint.y + halfWidth * cosy);
        CGContextAddLineToPoint(context, self.endPoint.x - halfWidth * siny, self.endPoint.y + halfWidth * cosy);
        CGContextAddLineToPoint(context, self.endPoint.x + halfWidth * siny, self.endPoint.y - halfWidth * cosy);
        CGContextAddLineToPoint(context, self.startPoint.x + halfWidth * siny, self.startPoint.y - halfWidth * cosy);
        CGContextAddLineToPoint(context, self.startPoint.x - halfWidth * siny, self.startPoint.y + halfWidth * cosy);
    } else {
        CGContextMoveToPoint(context, self.startPoint.x, self.startPoint.y);
        CGContextAddLineToPoint(context, self.endPoint.x, self.endPoint.y);
        CGContextSetLineWidth(context, self.width);
    }
}

@end

@implementation BLDrawingObjectFlexible

- (instancetype)initWithWidth:(CGFloat)width points:(NSArray *)points {
    self = [super init];
    if (self) {
        self.width = width;
        self.points = points;
    }

    return self;
}

+ (instancetype)flexibleWithWidth:(CGFloat)width points:(NSArray *)points {
    return [[[self alloc] initWithWidth:width points:points] autorelease];
}


- (void)addPathForDrawingToContext:(CGContextRef)context {
    for (NSUInteger i = 0; i < self.points.count; i++) {
        CGPoint point = [(NSValue *) self.points[i] CGPointValue];
        if (i == 0) {
            CGContextMoveToPoint(context, point.x, point.y);
        } else {
            CGContextAddLineToPoint(context, point.x, point.y);
        }
    }
    CGContextClosePath(context);
    if (self.width) {
        CGContextSetLineWidth(context, self.width);
    }
}

@end