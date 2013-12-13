//
//  CollectionCell.h
//  TextKit
//
//  Created by sah-fueled on 11/12/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell

@property (strong, nonatomic)  UITextView *textView;

- (void) update;

@end
