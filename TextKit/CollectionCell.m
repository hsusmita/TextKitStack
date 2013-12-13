//
//  CollectionCell.m
//  TextKit
//
//  Created by sah-fueled on 11/12/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import "CollectionCell.h"
#import "TextModel.h"

@interface CollectionCell()

@end

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (id) initWithCoder:(NSCoder *)aDecoder{
  self = [super initWithCoder:aDecoder];
  if(self){

  }
  return self;
}

- (void) initialize{
  [self setBackgroundColor:[UIColor whiteColor]];
  [[TextModel sharedModel] setContainerSize:CGSizeMake(self.frame.size.width - 20 , self.frame.size.height - 30)];
  self.textView =
  [[UITextView alloc]initWithFrame:CGRectMake(10,
                                              10,
                                              self.frame.size.width - 20,
                                              self.frame.size.height - 20)
                     textContainer:[[TextModel sharedModel] selectedContainer]
   ];
  [self addSubview:self.textView];
  [self.textView setScrollEnabled : NO];
//  NSLog(@"container = %@ %@",self.textView.textContainer,[[TextModel sharedModel] selectedContainer]);
  [self.textView setBackgroundColor:[UIColor cyanColor]];

}

- (void) update{
  if([self isInvalid]){
    [self.textView removeFromSuperview];
    [self initialize];
  }
  
}

- (BOOL) isInvalid{
  return(![self.textView.textContainer isEqual:[[TextModel sharedModel] selectedContainer]]);
}


@end
