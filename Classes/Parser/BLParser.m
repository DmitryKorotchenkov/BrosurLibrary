//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLParser.h"
#import "BLParsedViewDescription.h"
#import "BLGradientColor.h"
#import "BLParsedTextViewDescription.h"
#import "BLEllipsePath.h"
#import "BLPointsPath.h"
#import "BLDrawingObject.h"


@implementation BLParser

- (BLParsedViewDescription *)parse:(NSDictionary *)dictionary {
    NSString *type = dictionary[@"type"];
    UIColor *backgroundColor = [self getColorFromString:dictionary[@"background"]];
    BLGradientColor *backgroundGradient = [self getGradient:dictionary[@"backgroundGradient"]];
    CGRect frame = [self getFrame:dictionary[@"frame"]];

    BLParsedViewDescription *viewDescription;
    if ([type isEqualToString:@"textView"]) {
        BLParsedTextViewDescription *textViewDescription = [BLParsedTextViewDescription descriptionWithType:type
                                                                                            backgroundColor:backgroundColor
                                                                                    backgroundGradientColor:backgroundGradient
                                                                                                      frame:frame];

        textViewDescription.attributedText = [self getText:dictionary[@"text"]];
        textViewDescription.clippingPaths = [self getClippingPaths:dictionary[@"clippingPaths"]];
        viewDescription = textViewDescription;

    } else {
        viewDescription = [BLParsedViewDescription descriptionWithType:type
                                                       backgroundColor:backgroundColor
                                               backgroundGradientColor:backgroundGradient
                                                                 frame:frame];
    }
    viewDescription.drawingObjects = [self getDrawingObjects:dictionary[@"drawing"]];
    NSArray *subviews = dictionary[@"subviews"];
    if (subviews && [subviews isKindOfClass:[NSArray class]] && subviews.count) {
        NSMutableArray *array = [NSMutableArray new];
        for (NSDictionary *subviewDescription in subviews) {
            BLParsedViewDescription *object = [self parse:subviewDescription];
            if (object) {
                [array addObject:object];
            }
        }
        viewDescription.subviewsDescription = [NSArray arrayWithArray:array];
    }
    return viewDescription;
}

#pragma mark get textView properties

- (NSAttributedString *)getText:(NSArray *)array {
    NSMutableAttributedString *string = [NSMutableAttributedString new];
    if (array && [array isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dictionary in array) {
            NSString *text = dictionary[@"text"];
            UIColor *color = [self getColorFromString:dictionary[@"color"]];
            if (text && color) {
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:text attributes:@{
                        NSForegroundColorAttributeName : color
                }]];
            }
        }
    }

    return string;
}

- (NSArray *)getClippingPaths:(NSDictionary *)dictionary {
    NSMutableArray *array = [NSMutableArray new];
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]]) {
        NSArray *ellipses = dictionary[@"ellipses"];
        if (ellipses && [ellipses isKindOfClass:[NSArray class]]) {
            for (NSDictionary *frameDictionary in ellipses) {
                [array addObject:[BLEllipsePath createInRect:[self getFrame:frameDictionary]]];
            }
        }
        NSArray *lines = dictionary[@"lines"];
        if (lines && [lines isKindOfClass:[NSArray class]]) {
            for (NSString *lineDescription in lines) {
                BLPointsPath *path = [[BLPointsPath alloc] init];
                NSArray *points = [lineDescription componentsSeparatedByString:@"-"];
                for (NSString *point in points) {
                    NSArray *pointPair = [point componentsSeparatedByString:@":"];
                    if (pointPair.count == 2) {
                        CGFloat xValue = [self getFloat:pointPair[0]];
                        CGFloat yValue = [self getFloat:pointPair[1]];
                        [path addPoint:CGPointMake(xValue, yValue)];
                    }
                }
                [array addObject:path];
            }
        }

    }
    return array;
}

#pragma mark get view properties

- (BLGradientColor *)getGradient:(NSDictionary *)gradientDescription {
    if (!gradientDescription || ![gradientDescription isKindOfClass:[NSDictionary class]])
        return nil;

    UIColor *startColor = [self getColorFromString:gradientDescription[@"startColor"]];
    UIColor *endColor = [self getColorFromString:gradientDescription[@"endColor"]];
    CGPoint startPoint = [self getPoint:gradientDescription[@"startPoint"]];
    CGPoint endPoint = [self getPoint:gradientDescription[@"endPoint"]];
    return [BLGradientColor colorWithStartColor:startColor
                                       endColor:endColor
                                     startPoint:startPoint
                                       endPoint:endPoint];
}

- (UIColor *)getColorFromString:(NSString *)string {
    if (!string)
        return [UIColor clearColor];

    if ([[string uppercaseString] hasPrefix:@"0X"]) {
        string = [string substringFromIndex:2];
    }
    if (string.length != 8)
        return [UIColor clearColor];

    NSString *redString = [string substringWithRange:NSMakeRange(0, 2)];
    NSString *greenString = [string substringWithRange:NSMakeRange(2, 2)];
    NSString *blueString = [string substringWithRange:NSMakeRange(4, 2)];
    NSString *alphaString = [string substringWithRange:NSMakeRange(6, 2)];

    unsigned int r, g, b, a;
    [[NSScanner scannerWithString:redString] scanHexInt:&r];
    [[NSScanner scannerWithString:greenString] scanHexInt:&g];
    [[NSScanner scannerWithString:blueString] scanHexInt:&b];
    [[NSScanner scannerWithString:alphaString] scanHexInt:&a];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:((float) a / 255.0f)];
}

- (NSArray *)getDrawingObjects:(NSArray *)array {
    if (array.count) {
        NSMutableArray *returnArray = [NSMutableArray new];
        for (NSDictionary *drawingObject in array) {
            BLDrawingObject *object;
            NSString *type = [drawingObject[@"type"] lowercaseString];
            CGFloat width = [self getFloat:drawingObject[@"width"]];
            if ([type isEqualToString:@"ellipse"]) {
                BLDrawingObjectEllipse *ellipse = [BLDrawingObjectEllipse ellipseWithRect:[self getFrame:drawingObject[@"rect"]]];
                ellipse.width = width;
                object = ellipse;
            } else if ([type isEqualToString:@"line"]) {
                object = [BLDrawingObjectLine lineWithStartPoint:[self getPoint:drawingObject[@"startPoint"]]
                                                        endPoint:[self getPoint:drawingObject[@"endPoint"]]
                                                           width:width];

            } else if ([type isEqualToString:@"flexible"]) {
                NSArray *points = drawingObject[@"points"];
                NSMutableArray *parsedPoints = [NSMutableArray new];
                for (NSDictionary *point in point) {
                    CGPoint cgPoint = [self getPoint:point];
                    [parsedPoints addObject:[NSValue valueWithCGPoint:cgPoint]];
                }
                object = [BLDrawingObjectFlexible flexibleWithWidth:width points:parsedPoints];
            }
            if (object) {
                object.gradientColor = [self getGradient:drawingObject[@"gradientColor"]];
                object.fillColor = [self getColorFromString:drawingObject[@"fillColor"]];
                object.strokeColor = [self getColorFromString:drawingObject[@"strokeColor"]];
                [returnArray addObject:object];
            }
        }
        if (returnArray.count) {
            return [NSArray arrayWithArray:returnArray];
        }
    }
    return nil;
}

- (CGRect)getFrame:(NSDictionary *)frameDescription {
    if (!frameDescription || ![frameDescription isKindOfClass:[NSDictionary class]])
        return CGRectZero;

    CGFloat xValue = [self getFloat:frameDescription[@"x"]];
    CGFloat yValue = [self getFloat:frameDescription[@"y"]];
    CGFloat wValue = [self getFloat:frameDescription[@"w"]];
    CGFloat hValue = [self getFloat:frameDescription[@"h"]];
    return CGRectMake(xValue, yValue, wValue, hValue);
}

- (CGPoint)getPoint:(NSDictionary *)pointDescription {
    if (!pointDescription || ![pointDescription isKindOfClass:[NSDictionary class]])
        return CGPointZero;

    CGFloat xValue = [self getFloat:pointDescription[@"x"]];
    CGFloat yValue = [self getFloat:pointDescription[@"y"]];
    return CGPointMake(xValue, yValue);
}

- (CGFloat)getFloat:(id)value {
    if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *) value floatValue];
    } else if ([value isKindOfClass:[NSString class]]) {
        return [(NSString *) value floatValue];
    } else {
        return 0;
    }
}


@end