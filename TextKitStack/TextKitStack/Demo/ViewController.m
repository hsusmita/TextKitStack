//
//  ViewController.m
//  TextKitStack
//
//  Created by hsusmita on 01/09/15.
//  Copyright (c) 2015 hsusmita.com. All rights reserved.
//

#import "ViewController.h"
#import "CustomLabel.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet CustomLabel *customLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:self.customLabel.text
                                                           attributes:@{RLHighlightedBackgroundCornerRadius:@5,NSFontAttributeName:self.customLabel.font}];
  [str addAttribute:RLHighlightedBackgroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 10)];
  self.customLabel.attributedText = str;
  // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
