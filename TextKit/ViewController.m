//
//  ViewController.m
//  TextKit
//
//  Created by sah-fueled on 10/12/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSLayoutManagerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSLayoutManager *manager;
@property (weak, nonatomic) IBOutlet UILabel *label;


@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]
                                         initWithTarget:self
                                         action:@selector(singleTapRecognized:)];
    singleTap.numberOfTapsRequired = 1;
    [self.textView addGestureRecognizer:singleTap];
    [self showLetterPressEffect];
//  [self findLastCharacter];

}

-(void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
//  NSString *text = [self.textView text];
//  UIFont *font = [self.textView font];
//
//  CGRect rect = [text boundingRectWithSize:CGSizeMake(300.0, INT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:font.fontName size:(font.pointSize+2)],NSFontAttributeName, nil] context:nil];
//
//  NSLog(@"%f-%f, %f X %f",rect.origin.x, rect.origin.y,rect.size.width, rect.size.height);
//  rect.origin = self.textView.frame.origin;
//  [self.textView setFrame:rect];
//  self.textView.backgroundColor = [UIColor whiteColor];

}

- (void) singleTapRecognized:(UITapGestureRecognizer *) tap{
  CGPoint point = [tap locationInView:self.textView];
  point.x -= self.textView.textContainerInset.left;
  point.y -= self.textView.textContainerInset.top;
  [self getCharacterAtTapPoint:point];
  [self getWordAtTapPoint:point];
//  NSLog(@"point: x = %f y = %f",point.x,point.y);
  //  NSRange range = NSMakeRange(index, 50);
//  CGRect fragment = [self.textView.layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&range];
//  NSLog(@"Fragment = %f %f %fx%f",fragment.origin.x,fragment.origin.y,fragment.size.width,fragment.size.height);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) showLetterPressEffect{
  NSDictionary *attributes = @{NSForegroundColorAttributeName : [UIColor greenColor],
                               NSBackgroundColorAttributeName : [UIColor whiteColor],
                               NSTextEffectAttributeName : NSTextEffectLetterpressStyle};
  NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"Get Character At Tap Point" attributes:attributes];
  [self.label setAttributedText:string];
  
}

- (void) findLastCharacter{
  NSLayoutManager *layoutManager = self.textView.layoutManager;
  NSUInteger characterIndex = self.textView.textStorage.length - 1;
  NSUInteger glyphIndex = [layoutManager glyphIndexForCharacterAtIndex:characterIndex];
  CGRect rect = [layoutManager lineFragmentRectForGlyphAtIndex:glyphIndex effectiveRange:NULL];
  CGPoint glyphLocation = [layoutManager locationForGlyphAtIndex:glyphIndex];
  glyphLocation.x += CGRectGetMinX(rect);
  glyphLocation.y += CGRectGetMinY(rect);
  NSLog(@"position : x = %f y = %f",glyphLocation.x,glyphLocation.y);
}

- (void) getCharacterAtTapPoint:(CGPoint) point{
  CGFloat x = 1.0;
  
  int index = [self.textView.layoutManager characterIndexForPoint:point
                                                  inTextContainer:self.textView.textContainer
                         fractionOfDistanceBetweenInsertionPoints:&x];
  NSLog(@"Index = %d",index);
  NSLog(@"You have tapped on character = %c", [ self.textView.text characterAtIndex:index]);

}
- (void) getWordAtTapPoint:(CGPoint) point{
  CGFloat x = 1.0;

  int index = [self.textView.layoutManager characterIndexForPoint:point
                                                  inTextContainer:self.textView.textContainer
                         fractionOfDistanceBetweenInsertionPoints:&x];
  if([self.textView.text  characterAtIndex:index] == ' '){
    NSLog(@"You have tapped on space");
    return;
  }
  
  int initialIndex = 0;
  int finalIndex = 0;
  for(int i = index - 1; i > 0 ; i-- ){
    if([self.textView.text  characterAtIndex:i] == ' '){
      initialIndex = i;
      break;
    }

  }
  
  for(int i = index ; i < self.textView.text.length ; i++ ){
    if([self.textView.text  characterAtIndex:i] == ' '){
      finalIndex = i;
      break;
    }
  }
  NSLog(@"You have tapped on word = %@",[self.textView.text substringWithRange:NSMakeRange(initialIndex, finalIndex - initialIndex)]);
}
@end
