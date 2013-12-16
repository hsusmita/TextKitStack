//
//  TextViewController.m
//  TextKit
//
//  Created by sah-fueled on 11/12/13.
//  Copyright (c) 2013 fueled.co. All rights reserved.
//

#import "TextViewController.h"
#import "CollectionCell.h"
#import "TextModel.h"

#define kTotalCells 7
#define kCollectionCell @"collectionCell"

@interface TextViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NSLayoutManagerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation TextViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleContainerChanged)
                                               name:CONTAINER_COUNT_CHANGED_NOTIFICATION
                                             object:nil];
}

- (void) handleContainerChanged{
    NSLog(@"container changed");
    [self.collectionView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return [TextModel sharedModel].containerCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  [[TextModel sharedModel] setContainerSelectedAtIndex:indexPath.row];
  CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCell
                                            forIndexPath:indexPath];
  [cell update];
  return cell;
}

@end
