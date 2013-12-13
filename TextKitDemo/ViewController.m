//
//  ViewController.m
//  TextKitDemo
//
//  Created by sah-fueled on 04/07/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import "ViewController.h"
#import "TextContainerInstanceViewController.h"

@interface ViewController () <UITextViewDelegate,UIPageViewControllerDataSource>

@property (nonatomic) NSInteger numberOfPages;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSTextStorage *textStorage;
@property (strong, nonatomic) NSLayoutManager *layoutManager;

@end

@implementation ViewController

//- (void)setDemo:(Demo*)demo{
//
//  [super setDemo:demo];
//  
//  self.textStorage = [[NSTextStorage alloc]initWithAttributedString:self.demo.attributedText];
//  [self.textStorage addLayoutManager:self.layoutManager];
//}one

- (void)viewDidLoad
{
    [super viewDidLoad];


//  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
  CGRect textRect = CGRectInset(self.view.bounds, 8.0, 0.0);
  self.numberOfPages = 5;
  NSLog(@"In view will appear : count = %d",[[self.layoutManager textContainers] count]);
  if([self.layoutManager.textContainers count] == 0){
    for(NSUInteger i = 0; i < self.numberOfPages; i++){
      NSTextContainer *textContainer = [[NSTextContainer alloc]init];
      textContainer.size = textRect.size;
      
      [self.layoutManager addTextContainer:textContainer];
    }
  }
  
  UIViewController *currentViewController = [self viewControllerForPageNumber:0];
  if(currentViewController != nil){
    [self.pageViewController setViewControllers:@[currentViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO completion:nil];
  }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createExclusionPath{
//  UIBezierPath *exclusion = ButterflyBezierPath;
//  textContainer.exclusionPaths = @[exclusion];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
  [textView resignFirstResponder];
}

#pragma mark -  UIPageViewControllerDataSource methods

- (UIViewController*) viewControllerForPageNumber:(NSInteger)pageNumber{

  if(pageNumber > self.numberOfPages){
    return nil;
  }
  UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
  TextContainerInstanceViewController *viewController = [mainStoryBoard instantiateViewControllerWithIdentifier:@"TextContainerVC"];
  CGRect textRect = CGRectInset(self.view.bounds, 8.0, 0.0);
  NSLog(@"count = %d",[[self.layoutManager textContainers] count]);
  NSLog(@"viewControllerForPageNumber page Number = %d",pageNumber);
  NSTextContainer *container = [[self.layoutManager textContainers] objectAtIndex:pageNumber];
  
  viewController.view.backgroundColor = [UIColor whiteColor];
  UITextView *textView = [[UITextView alloc]initWithFrame:textRect textContainer:container];
  textView.backgroundColor = [UIColor clearColor];
  
  [viewController.view addSubview:textView];
  viewController.textView = textView;
  viewController.pageNumber = pageNumber;
  
  return viewController;
}

- (void)awakeFromNib{
  [super awakeFromNib];
  self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                           navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                         options:@{UIPageViewControllerOptionInterPageSpacingKey:@2.0}];
  self.pageViewController.dataSource = self;
  self.pageViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  
  [self addChildViewController:self.pageViewController];
  [self.view addSubview:self.pageViewController.view];
  self.layoutManager = [[NSLayoutManager alloc]init];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
  NSUInteger currentPageNumber = ((TextContainerInstanceViewController *) viewController).pageNumber;
  if(currentPageNumber >= self.numberOfPages-1){
    return nil;
  }
  NSLog(@"Next Page = %d",currentPageNumber+1);
  return [self viewControllerForPageNumber:currentPageNumber + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
  NSUInteger currentPageNumber = ((TextContainerInstanceViewController *) viewController).pageNumber;
  if(currentPageNumber == 0){
    return nil;
  }
  NSLog(@"Previous Page = %d",currentPageNumber-1);
  return [self viewControllerForPageNumber:currentPageNumber - 1];
}
@end
