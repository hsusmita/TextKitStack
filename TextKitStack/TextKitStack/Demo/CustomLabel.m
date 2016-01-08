//
//  CustomLabel.m
//  TextKitStack
//
//  Created by hsusmita on 07/09/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

#import "CustomLabel.h"
#import "TouchSession.h"
#import "CustomLayoutManager.h"

@interface CustomLabel()

@property (nonatomic, strong) TextKitStack *textKitStack;
@property (nonatomic, strong) TouchSession *touchSession;

@end

@implementation CustomLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawTextInRect:(CGRect)rect {
  [self.textKitStack updateTextContainerSize:rect.size];
  [self.textKitStack drawTextForTextOffset:[self textOffset]];
}

- (CGPoint)textOffset {
  CGPoint textOffset = CGPointZero;
  
  CGRect textBounds = [self.textKitStack boundingRectForCompleteText];
  CGFloat paddingHeight = (self.bounds.size.height - textBounds.size.height) / 2.0f;
  if (paddingHeight > 0)
    textOffset.y = paddingHeight;
  
  return textOffset;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.textKitStack = [TextKitStack new];
  self.touchSession = [[TouchSession alloc]initWithTextKitStack:self.textKitStack];
  [self initialTextConfiguration];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  [self.textKitStack updateTextContainerSize:self.bounds.size];
}

#pragma mark - custom setter methods

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  CGSize size = CGSizeZero;
  size.width = MIN(frame.size.width, self.preferredMaxLayoutWidth);
  [self.textKitStack updateTextContainerSize:size];
}

- (void)setBounds:(CGRect)bounds {
  [super setBounds:bounds];
  CGSize size = CGSizeZero;
  size.width = MIN(bounds.size.width, self.preferredMaxLayoutWidth);
  [self.textKitStack updateTextContainerSize:size];
}

- (void)setPreferredMaxLayoutWidth:(CGFloat)preferredMaxLayoutWidth {
  [super setPreferredMaxLayoutWidth:preferredMaxLayoutWidth];
  CGSize size = CGSizeZero;
  size.width = MIN(self.bounds.size.width, self.preferredMaxLayoutWidth);
  [self.textKitStack updateTextContainerSize:size];
}

- (void)setText:(NSString *)text {
  [super setText:text];
  NSString *finalText = (text!= nil) ? text : @"";
  NSAttributedString *attributedText =[[NSAttributedString alloc]initWithString:finalText
                                                                     attributes:[self attributesFromProperties]];
  [self.textKitStack updateTextStorage:attributedText];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
  [super setAttributedText:attributedText];
  [self.textKitStack updateTextStorage:attributedText];
}

#pragma mark - Helpers

- (void)initialTextConfiguration {
  NSAttributedString *currentText;
  if (self.attributedText.length > 0) {
//    currentText = [self.attributedText wordWrappedAttributedString];
  }else if (self.text.length > 0){
    currentText = [[NSAttributedString alloc]initWithString:self.text
                                                 attributes:[self attributesFromProperties]];
  }
  [self.textKitStack updateTextStorage:currentText];
}

- (NSDictionary *)attributesFromProperties {
  // Setup shadow attributes
  NSShadow *shadow = shadow = [[NSShadow alloc] init];
  if (self.shadowColor) {
    shadow.shadowColor = self.shadowColor;
    shadow.shadowOffset = self.shadowOffset;
  }
  else {
    shadow.shadowOffset = CGSizeMake(0, -1);
    shadow.shadowColor = nil;
  }
  
  // Setup colour attributes
  UIColor *colour = self.textColor;
  if (!self.isEnabled)
    colour = [UIColor lightGrayColor];
  else if (self.isHighlighted && self.highlightedTextColor)
    colour = self.highlightedTextColor;
  
  // Setup paragraph attributes
  NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
  paragraph.alignment = self.textAlignment;
  
  // Create the dictionary
  NSDictionary *attributes = @{NSFontAttributeName : self.font,
                               NSForegroundColorAttributeName : colour,
                               NSShadowAttributeName : shadow,
                               NSParagraphStyleAttributeName : paragraph,
                               };
  return attributes;
}

- (CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
  CGRect requiredRect = [self.textKitStack rectFittingTextForContainerSize:bounds.size
                                              forNumberOfLine:numberOfLines forFont:self.font];
  return requiredRect;
}

#pragma mark - Override UIView methods

+ (BOOL)requiresConstraintBasedLayout {
  return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  CGPoint touchLocation = [[touches anyObject] locationInView:self];
  NSInteger index = [self.textKitStack characterIndexAtLocation:touchLocation];
  self.touchSession.touchIndex = index;
  if ([self.touchSession shouldHandleTouch]) {
    [self.touchSession beginSession];
    [self setNeedsDisplay];
  }else {
    [super touchesBegan:touches withEvent:event];
  }
  NSLog(@"index = %ld",(long)index);

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  [self.touchSession cancelSession];
  [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if ([self.touchSession shouldHandleTouch]) {

    [self performSelector:@selector(handleTouchEnd)
               withObject:nil
               afterDelay:0.05];

  }else {
    [super touchesEnded:touches withEvent:event];
  }
}

- (void)handleTouchEnd {
  [self.touchSession endSession];
  [self setNeedsDisplay];
}

@end
