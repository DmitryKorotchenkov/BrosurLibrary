//
// Created by Dmitry Korotchenkov on 30/07/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import <CoreText/CoreText.h>
#import "BLTextView.h"
#import "BLPointsPath.h"
#import "BLEllipsePath.h"

@implementation BLTextView

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawText:context];

}

- (void)drawText:(CGContextRef)context {
//    // Flip the coordinate system
    if (! self.text)
        return;

    CGContextSaveGState(context);
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Create a path to render text in
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);


    NSMutableArray *clippingPaths = [NSMutableArray new];
    for (BLPath *clipPath in self.clippingPaths) {
        CGPathRef cgPath = clipPath.getCGPath;

        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformTranslate(transform, 0, self.bounds.size.height);
        transform = CGAffineTransformScale(transform, 1.0, -1.0);
        CGPathRef newPath = CGPathCreateCopyByTransformingPath(cgPath, &transform);

        CFStringRef keys[] = {kCTFramePathClippingPathAttributeName};
        CFTypeRef values[] = {newPath};
        CFDictionaryRef clippingPathDict = CFDictionaryCreate(NULL,
                (const void **) &keys, (const void **) &values,
                sizeof(keys) / sizeof(keys[0]),
                &kCFTypeDictionaryKeyCallBacks,
                &kCFTypeDictionaryValueCallBacks);
        [clippingPaths addObject:(__bridge NSDictionary *) clippingPathDict];
        CGPathRelease(cgPath);
        CGPathRelease(newPath);
    }

    // Create an options dictionary, to pass in to CTFramesetter
    NSDictionary *optionsDict = @{(__bridge NSString *) kCTFrameClippingPathsAttributeName : clippingPaths};

    // Finally create the framesetter and render text
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) self.text); //3
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [self.text length]), path, (__bridge CFDictionaryRef) optionsDict);


    CTFrameDraw(frame, context);

    // Clean up
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    CGContextRestoreGState(context);
}

#pragma mark getters for undefined properties

- (UIColor *)textColor {
    if (!_textColor) {
        _textColor = [UIColor blackColor];
    }
    return _textColor;
}


@end