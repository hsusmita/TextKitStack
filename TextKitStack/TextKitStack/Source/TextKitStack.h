//
//  TextKitStack.h
//  TextKitStack
//
//  Created by hsusmita on 01/09/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *RLHighlightedBackgroundCornerRadius;
extern NSString *RLHighlightedBackgroundColorAttributeName;
extern NSString *RLTapResponderAttributeName;
extern NSString *RLHighlightedForegroundColorAttributeName;

typedef void (^PatternTapResponder)(NSString *tappedString);

@interface TextKitStack : NSObject


@property (nonatomic, strong) NSTextStorage *textStorage;

- (CGRect)rectFittingTextForContainerSize:(CGSize)size
                          forNumberOfLine:(NSInteger)numberOfLines
                                  forFont:(UIFont *)font;

- (CGRect)boundingRectForCompleteText;
- (void)drawTextForTextOffset:(CGPoint)textOffset;
- (void)updateTextContainerSize:(CGSize)size;
- (void)updateTextStorage:(NSAttributedString *)attributedText;
- (NSUInteger)characterIndexAtLocation:(CGPoint)location;
- (NSRange)rangeContainingIndex:(NSInteger)index;
- (void)applyAttributes:(NSDictionary *)dictionay forRange:(NSRange)range;
- (void)removeAttributes:(NSArray *)attributes forRange:(NSRange)range;

@end

@protocol TextKitStackProtocol <NSObject>

- (NSLayoutManager *)layoutManager;

@end
