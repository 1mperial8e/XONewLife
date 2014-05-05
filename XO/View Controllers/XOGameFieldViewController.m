//
//  TTGameFieldViewController.m
//  Tic tac toe
//
//  Created by Misha on 30.04.14.
//  Copyright (c) 2014 mobilesoft365. All rights reserved.
//

#import "XOGameFieldViewController.h"
#import "TTBananasView.h"
#import "XOCollectionViewCell.h"
@interface XOGameFieldViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL player2;
@end

@implementation XOGameFieldViewController
@synthesize player2;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSArray *views = [self.view subviews];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        for (UIView *view in views) {
            [view addGestureRecognizer:tap];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tap:(UITapGestureRecognizer *)tap
{
    TTBananasView *view = (TTBananasView *)tap.view;
    NSLog(@"%i", view.tag);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - CollectionView Data Sourse
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    CGRect bounds = cell.bounds;
    bounds.size = CGSizeMake(collectionView.frame.size.width/3, collectionView.frame.size.height/3);
    cell.bounds = bounds;
    //NSLog(@"%@", NSStringFromCGRect(cell.frame));
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}
#pragma mark - CollectionView Delegate
- (BOOL) collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XOCollectionViewCell *cell = (XOCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (player2 && !cell.mode) {
        cell.mode = 1;
        player2 = NO;
    } else if (!cell.mode) {
        cell.mode = -1;
        player2 = YES;
    }
    return YES;
}
- (BOOL) collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
#pragma mark - Private
- (void)clearGameField
{
    [_collectionView reloadData];
}
@end
