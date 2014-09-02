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

+ (NSString *)asda {
    return @"{\"type\":\"view\",\"frame\":{\"x\":0,\"y\":0,\"w\":320,\"h\":480},\"background\":\"0xAAAAAAFF\",\"subviews\":[{\"type\":\"textView\",\"text\":[{\"color\":\"0xFF0000FF\",\"text\":\"abcd \"},{\"color\":\"0x000000FF\",\"text\":\"abcd d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d   d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d d \"}],\"clippingPaths\":{\"ellipses\":[{\"x\":100,\"y\":300,\"w\":100,\"h\":100},{\"x\":100,\"y\":170,\"w\":100,\"h\":100}],\"lines\":[\"20:20-200:40-220:100-100:100-50:80\"]},\"background\":\"0xBBBBBBFF\",\"frame\":{\"x\":20,\"y\":20,\"w\":300,\"h\":400}},{\"type\":\"view\",\"frame\":{\"x\":0,\"y\":0,\"w\":280,\"h\":20},\"backgroundGradient\":{\"startColor\":\"0x00FF00FF\",\"endColor\":\"0xFF0000FF\",\"startPoint\":{\"x\":0,\"y\":0},\"endPoint\":{\"x\":0,\"y\":20}}},{\"type\":\"view\",\"frame\":{\"x\":0,\"y\":20,\"w\":20,\"h\":240},\"backgroundGradient\":{\"startColor\":\"0x00FF00FF\",\"endColor\":\"0xFF0000FF\",\"startPoint\":{\"x\":0,\"y\":0},\"endPoint\":{\"x\":20,\"y\":0}}},{\"type\":\"view\",\"frame\":{\"x\":260,\"y\":20,\"w\":20,\"h\":240},\"backgroundGradient\":{\"startColor\":\"0x00FF00FF\",\"endColor\":\"0xFF0000FF\",\"startPoint\":{\"x\":20,\"y\":0},\"endPoint\":{\"x\":0,\"y\":0}}},{\"type\":\"view\",\"frame\":{\"x\":0,\"y\":260,\"w\":280,\"h\":20},\"backgroundGradient\":{\"startColor\":\"0x00FF00FF\",\"endColor\":\"0xFF0000FF\",\"startPoint\":{\"x\":0,\"y\":0},\"endPoint\":{\"x\":0,\"y\":20}}}]}";
}

+ (BLView *)qweqwr {
    NSData *data = [[self asda] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    BLParser *parser = [BLParser new];
    BLParsedViewDescription *description = [parser parse:dictionary];
    NSLog(@"%@", dictionary);
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