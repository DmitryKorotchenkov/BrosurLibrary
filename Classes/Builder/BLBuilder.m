//
// Created by Dmitry Korotchenkov on 07/08/14.
// Copyright (c) 2014 Progress Engine. All rights reserved.
//

#import "BLBuilder.h"
#import "BLParser.h"
#import "BLParsedViewDescription.h"
#import "BLView.h"
#import "BLTextView.h"
#import "BLParsedTextViewDescription.h"


@implementation BLBuilder

+(BLView *)createViewWithJSON:(NSString *)json {
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    BLParser *parser = [BLParser new];
    BLParsedViewDescription *description = [parser parse:dictionary];
    return [self createView:description];
}

+ (BLView *)createView:(BLParsedViewDescription *)description {

    BLView *view;
    if ([description isKindOfClass:[BLParsedTextViewDescription class]]) {
        BLTextView *textView = [[BLTextView alloc] init];
        BLParsedTextViewDescription *castedDescription = (BLParsedTextViewDescription *) description;
        textView.text = castedDescription.attributedText;
        textView.clippingPaths = castedDescription.clippingPaths;
        view = textView;
    } else {
        view = [[BLView alloc] init];
    }
    view.drawingObjects = description.drawingObjects;

    view.backgroundColor = description.backgroundColor;
    if (description.backgroundGradientColor) {
        view.backgroundGradient = description.backgroundGradientColor;
    }
    view.frame = description.frame;
    for (BLParsedViewDescription *subviewDescription in description.subviewsDescription) {
        BLView *subview = [self createView:subviewDescription];
        [view addSubview:subview];
    }
    return view;
}

@end