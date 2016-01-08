//
//  TouchSession.m
//  TextKitStack
//
//  Created by hsusmita on 07/09/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

#import "TouchSession.h"
#import "TextKitStack.h"

@interface TouchSession()

@property (nonatomic, assign) NSRange selectedRange;
@property (nonatomic, strong) TextKitStack *textKitStack;
@property (nonatomic, strong) NSMutableAttributedString *currentAttributedString;

@end

@implementation TouchSession

- (instancetype)initWithTextKitStack:(TextKitStack *)textKitStack {
  self = [super init];
  if (self) {
    self.textKitStack = textKitStack;
  }
  return self;
}

- (void)beginSession {
  NSRange rangeOfTappedText;
  if (self.touchIndex < self.textKitStack.textStorage.length) {
    rangeOfTappedText = [self.textKitStack rangeContainingIndex:self.touchIndex];
  }
  
  if (rangeOfTappedText.location != NSNotFound &&
      [self shouldHandleTouch] &&
      self.selectedRange.location == NSNotFound) {
      //Set global variable
      self.selectedRange = rangeOfTappedText;
      self.currentAttributedString = [[NSMutableAttributedString alloc]initWithAttributedString:self.textKitStack.textStorage];
      [self addHighlightingForIndex:rangeOfTappedText.location];
    }
}

- (void)endSession {
  if (self.selectedRange.location != NSNotFound) {
    [self removeHighlightingForIndex:self.touchIndex];
    [self performActionAtIndex:self.touchIndex];
    //Clear global Variable
    self.selectedRange = NSMakeRange(NSNotFound, 0);
    self.currentAttributedString = nil;
  }
}

- (void)performActionAtIndex:(NSInteger)index {
  NSRange patternRange;
  if (index < self.textKitStack.textStorage.length) {
    PatternTapResponder tapResponder = [self.textKitStack.textStorage attribute:RLTapResponderAttributeName
                                                           atIndex:index
                                                    effectiveRange:&patternRange];
    if (tapResponder) {
      tapResponder([self.textKitStack.textStorage.string substringWithRange:patternRange]);
    }
  }
}


- (void)cancelSession {
  if ([self patternTouchInProgress]) {
    [self removeHighlightingForIndex:self.selectedRange.location];
    
    //Clear global Variable
    self.selectedRange = NSMakeRange(NSNotFound, 0);
    self.currentAttributedString = nil;
  }
}

- (BOOL)patternTouchInProgress {
  return self.selectedRange.location != NSNotFound;
}
- (BOOL)shouldHandleTouch {
  if (self.touchIndex > self.textKitStack.textStorage.length) return NO;
  NSRange range;
  NSDictionary *dictionary = [self.textKitStack.textStorage attributesAtIndex:self.touchIndex effectiveRange:&range];
  BOOL touchAttributesSet = (dictionary && ([dictionary.allKeys containsObject:RLTapResponderAttributeName] ||
                                            [dictionary.allKeys containsObject:RLHighlightedBackgroundColorAttributeName] ||
                                            [dictionary.allKeys containsObject:RLHighlightedForegroundColorAttributeName]));
  
  return touchAttributesSet;
}

- (void)addHighlightingForIndex:(NSInteger)index {
  if (index > self.textKitStack.textStorage.length) return;
  UIColor *backgroundcolor = nil;
  UIColor *foregroundcolor = nil;
  NSRange patternRange;
  
  if (index < self.textKitStack.textStorage.length) {
    backgroundcolor = [self.textKitStack.textStorage attribute:RLHighlightedBackgroundColorAttributeName
                                          atIndex:index
                                   effectiveRange:&patternRange];
    foregroundcolor = [self.textKitStack.textStorage attribute:RLHighlightedForegroundColorAttributeName
                                          atIndex:index
                                   effectiveRange:&patternRange];
    
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc]initWithDictionary:[self.textKitStack.textStorage attributesAtIndex:self.touchIndex effectiveRange:nil]];
    if (backgroundcolor) {
      [attributes setObject:backgroundcolor forKey:NSBackgroundColorAttributeName];
    }
    if (foregroundcolor) {
      [attributes setObject:foregroundcolor forKey:NSForegroundColorAttributeName];
    }
    
    [self.textKitStack applyAttributes:attributes forRange:patternRange];
  }
  //  [self redrawTextForRange:patternRange];
}

- (void)removeHighlightingForIndex:(NSInteger)index {
  if (self.selectedRange.location != NSNotFound && self.textKitStack.textStorage.length > index) {
    UIColor *backgroundcolor = nil;
    UIColor *foregroundcolor = nil;
    NSRange patternRange;
    
    if (index < self.textKitStack.textStorage.length) {
      backgroundcolor = [self.currentAttributedString attribute:NSBackgroundColorAttributeName
                                                        atIndex:index
                                                 effectiveRange:&patternRange];
      foregroundcolor = [self.currentAttributedString attribute:NSForegroundColorAttributeName
                                                        atIndex:index
                                                 effectiveRange:&patternRange];
      NSMutableDictionary *attributes = [[NSMutableDictionary alloc]initWithDictionary:[self.currentAttributedString attributesAtIndex:self.touchIndex effectiveRange:nil]];
      if (backgroundcolor) {
        [attributes setObject:backgroundcolor forKey:NSBackgroundColorAttributeName];
      }else {
        [attributes removeObjectForKey:NSBackgroundColorAttributeName];
      }

      if (foregroundcolor) {
        [attributes setObject:foregroundcolor forKey:NSForegroundColorAttributeName];
      }else {
        [attributes removeObjectForKey:NSForegroundColorAttributeName];
      }
      [self.textKitStack applyAttributes:attributes forRange:patternRange];
    }
//    [self redrawTextForRange:patternRange];
  }
}


@end
