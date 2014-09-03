//
// Created by Dmitry Korotchenkov on 02/09/14.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@class BLGradientColor;
@class UIColor;

// abstract class
@interface BLDrawingObject : NSObject

// if gradientColor is provided then strokeColor and fillColor will be ignored
@property (nonatomic, strong) BLGradientColor *gradientColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic) CGFloat width;

- (void)drawInContext:(CGContextRef)context;

- (BOOL)needDrawGradient;
@end

@interface BLDrawingObjectCircle :BLDrawingObject

@property (nonatomic) CGRect rect;

- (instancetype)initWithRect:(CGRect)rect width:(CGFloat)width;

+ (instancetype)circleWithRect:(CGRect)rect width:(CGFloat)width;


@end

@interface BLDrawingObjectLine :BLDrawingObject

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;

- (instancetype)initWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(CGFloat)width;

+ (instancetype)lineWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint width:(CGFloat)width;


@end

@interface BLDrawingObjectFlexible :BLDrawingObject

// NSValue's with CGPoint
@property (nonatomic, strong) NSArray *points;

- (instancetype)initWithWidth:(CGFloat)width points:(NSArray *)points;

+ (instancetype)flexibleWithWidth:(CGFloat)width points:(NSArray *)points;


@end