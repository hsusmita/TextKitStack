//
//  TextKitStack.m
//  TextKitStack
//
//  Created by hsusmita on 01/09/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

#import "TextKitStack.h"
#import "CustomLayoutManager.h"

NSString *RLTapResponderAttributeName = @"TapResponder";
NSString *RLHighlightedForegroundColorAttributeName = @"HighlightedForegroundColor";

NSString *RLHighlightedBackgroundCornerRadius = @"HighlightedBackgroundCornerRadius";
NSString *RLHighlightedBackgroundColorAttributeName = @"HighlightedBackgroundColor";

@interface TextKitStack()

@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, assign) CGPoint currentTextOffset;
@property (nonatomic, strong) NSLayoutManager *layoutManager;

@end

@implementation TextKitStack

- (instancetype)init {
  self = [super init];
  if (self) {
  
  }
  
  return self;
}

- (NSTextStorage *)textStorage {
  if (!_textStorage) {
    [_textStorage removeLayoutManager:_layoutManager];
    _textStorage = [[NSTextStorage alloc] init];
    [_textStorage addLayoutManager:self.layoutManager];
    [self.layoutManager setTextStorage:_textStorage];
  }
  return _textStorage;
}

- (NSTextContainer *)textContainer {
  if (!_textContainer) {
    _textContainer = [[NSTextContainer alloc] init];
    _textContainer.lineFragmentPadding = 0;
    _textContainer.widthTracksTextView = YES;
    [_textContainer setLayoutManager:self.layoutManager];
  }
  return _textContainer;
}

- (NSLayoutManager *)layoutManager {
  if (!_layoutManager) {
    _layoutManager = [[CustomLayoutManager alloc] init];
    [_layoutManager addTextContainer:self.textContainer];
  }
  return _layoutManager;
}

- (void)updateTextContainerSize:(CGSize)size {
  CGSize containerSize = size;
  self.textContainer.size = containerSize;
}

- (NSUInteger)characterIndexAtLocation:(CGPoint)location {
  NSUInteger chracterIndex = NSNotFound;
  if (self.textStorage.string.length > 0) {
    NSUInteger glyphIndex = [self glyphIndexForLocation:location];
    // If the touch is in white space after the last glyph on the line we don't
    // count it as a hit on the text
    NSRange lineRange;
    CGRect lineRect = [self.layoutManager lineFragmentUsedRectForGlyphAtIndex:glyphIndex
                                                               effectiveRange:&lineRange];
    lineRect.size.height = 60;  //Adjustment to increase tap area
    if (CGRectContainsPoint(lineRect, location)) {
      chracterIndex = [self.layoutManager characterIndexForGlyphAtIndex:glyphIndex];
    }
  }
  return chracterIndex;
}

- (NSUInteger)glyphIndexForLocation:(CGPoint)location {
  // Get offset of the text in the view
  CGPoint textOffset;
//  NSRange glyphRange = [self.layoutManager
//                        glyphRangeForTextContainer:self.textContainer];
//  textOffset = [self textOffsetForGlyphRange:glyphRange];
  textOffset = self.currentTextOffset;
  // Get the touch location and use text offset to convert to text cotainer coords
  location.x -= textOffset.x;
  location.y -= textOffset.y;
  
  return  [self.layoutManager glyphIndexForPoint:location
                                 inTextContainer:self.textContainer];
}


- (CGRect)boundingRectForCompleteText {
  NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
  return [self.layoutManager boundingRectForGlyphRange:glyphRange
                                                    inTextContainer:self.textContainer];
}


- (CGRect)rectFittingTextForContainerSize:(CGSize)size
                          forNumberOfLine:(NSInteger)numberOfLines
                                  forFont:(UIFont *)font {
  self.textContainer.size = size;
  self.textContainer.maximumNumberOfLines = numberOfLines;
  
  CGRect textBounds = [self.layoutManager boundingRectForGlyphRange:NSMakeRange(0, self.layoutManager.numberOfGlyphs)
                                                    inTextContainer:self.textContainer];
  NSInteger totalLines = textBounds.size.height / font.lineHeight;
  
  if (numberOfLines > 0 && (numberOfLines < totalLines)) {
    textBounds.size.height -= (totalLines - numberOfLines) * font.lineHeight;
  }else if (numberOfLines > 0 && (numberOfLines > totalLines)) {
    textBounds.size.height += (numberOfLines - totalLines) * font.lineHeight;
  }
  textBounds.size.width = ceilf(textBounds.size.width);
  textBounds.size.height = ceilf(textBounds.size.height);
  self.textContainer.size = textBounds.size;
  return textBounds;
}

- (void)drawTextForTextOffset:(CGPoint)textOffset {
  // Don't call super implementation. Might want to uncomment this out when
  // debugging layout and rendering problems.
  //   [super drawTextInRect:rect];
  
  self.currentTextOffset = textOffset;
  //Draw after truncation process is complete
    NSRange glyphRange = [_layoutManager glyphRangeForTextContainer:_textContainer];
  //
  //  CGPoint textOffset = [self textOffsetForGlyphRange:glyphRange];
    [_layoutManager drawBackgroundForGlyphRange:glyphRange atPoint:textOffset];
    [_layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
}

- (void)updateTextStorage:(NSAttributedString *)attributedText {
//  self.rangeAttributeDictionary = [NSMutableDictionary new];
  if (attributedText == nil) {
    NSAttributedString *emptyString = [[NSAttributedString alloc]initWithString:@""];
    [self.textStorage setAttributedString:emptyString];
  }else {
    [self.textStorage setAttributedString:attributedText];
  }
  
//  [self.patternDescriptorDictionary enumerateKeysAndObjectsUsingBlock:^(id key, PatternDescriptor *descriptor, BOOL *stop) {
//    [self addAttributesForPatternDescriptor:descriptor];
//  }];
}


- (NSRange)rangeContainingIndex:(NSInteger)index {
  return [self.layoutManager rangeOfNominallySpacedGlyphsContainingIndex:index];
}

- (void)applyAttributes:(NSDictionary *)dictionay forRange:(NSRange)range {
  [self.textStorage setAttributes:dictionay range:range];
}

- (void)removeAttributes:(NSArray *)attributes forRange:(NSRange)range {
  [attributes enumerateObjectsUsingBlock:^(NSString *attributeName, NSUInteger idx, BOOL *stop) {
    [self.textStorage removeAttribute:attributeName range:range];
  }];
}
@end
