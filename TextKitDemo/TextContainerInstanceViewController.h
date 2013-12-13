//
//  TextContainerInstanceViewController.h
//  TextKitDemo
//
//  Created by sah-fueled on 04/07/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextContainerInstanceViewController : UIViewController

@property (nonatomic) NSInteger pageNumber;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
