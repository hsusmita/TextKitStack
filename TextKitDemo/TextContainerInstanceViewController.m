//
//  TextContainerInstanceViewController.m
//  TextKitDemo
//
//  Created by sah-fueled on 04/07/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import "TextContainerInstanceViewController.h"

@interface TextContainerInstanceViewController ()

@end

@implementation TextContainerInstanceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(preferredContentSizeChanged:)
                                               name:UIContentSizeCategoryDidChangeNotification
                                             object:nil];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) preferredContentSizeChanged:(NSNotification *) notification{
  NSLog(@"changed size");
  NSDictionary *dict = notification.userInfo;
  for(id key in [dict allKeys])
  NSLog(@"%@ %@",key,[dict objectForKey:key]);
  
}
@end
