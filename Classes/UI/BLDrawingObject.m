//
// Created by Dmitry Korotchenkov on 02/09/14.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "BLDrawingObject.h"
#import "BLGradientColor.h"


@implementation BLDrawingObject

- (void)drawInContext:(CGContextRef)context {
    CGContextSaveGState(context);

    [self addPathForDrawingToContext:context];
    CGContextSetLineWidth(context, self.width);
    CGContextSetShouldAntialias(context, YES);

    if (self.needDrawGradient) {
        CGGradientRef myGradient;
        CGColorSpaceRef myColorspace;
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};

        CGFloat startComponents[4];
        CGFloat endComponents[4];
        [self.gradientColor.startColor getRed:&startComponents[0] green:&startComponents[1] blue:&startComponents[2] alpha:&startComponents[3]];
        [self.gradientColor.endColor getRed:&endComponents[0] green:&endComponents[1] blue:&endComponents[2] alpha:&endComponents[3]];

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
        if (self.strokeColor) {
            CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
        }
        if (self.fillColor) {
            CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        }
        if (self.strokeColor && self.fillColor) {
            CGContextDrawPath(context, kCGPathFillStroke);
        } else {
            if (self.strokeColor) {
                CGContextStrokePath(context);
            } else if (self.fillColor) {
                CGContextFillPath(context);
            }
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

@implementation BLDrawingObjectEllipse

- (instancetype)initWithRect:(CGRect)rect {
    self = [super init];
    if (self) {
        self.rect = rect;
        self.width = 0;
    }

    return self;
}

+ (instancetype)ellipseWithRect:(CGRect)rect {
    return [[self alloc] initWithRect:rect];
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
    return [[self alloc] initWithStartPoint:startPoint endPoint:endPoint width:width];
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
    return [[self alloc] initWithWidth:width points:points];
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
}

@end

@implementation BLDrawingObjectText

- (instancetype)initWithText:(NSString *)text font:(UIFont *)font {
    self = [super init];
    if (self) {
        self.text = text;
        self.font = font;
    }

    return self;
}

+ (instancetype)textWithText:(NSString *)text font:(UIFont *)font {
    return [[self alloc] initWithText:text font:font];
}


- (CGSize)size {
    NSDictionary *attrs = @{NSFontAttributeName : self.font};
    return [self.text sizeWithAttributes:attrs];
}

- (void)drawInContext:(CGContextRef)context {
    UIColor *color = self.textColor ?: [UIColor blueColor];
    NSDictionary *attrs = @{NSFontAttributeName : self.font, NSForegroundColorAttributeName : color};
    [self.text drawAtPoint:self.point withAttributes:attrs];
}

@end