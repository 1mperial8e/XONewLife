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
#import "XOGameModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MPManager.h"
#import "GameManager.h"

@interface XOGameFieldViewController () <GameDelegate>
{
    SystemSoundID mySound;
}
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
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"step" ofType:@"wav"];
    NSURL *fileURL = [NSURL URLWithString:soundPath];
    if (fileURL != nil)
    {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)fileURL, &mySound);
    }
    [MPManager sharedInstance].delegate=self;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    TTBananasView *view = (TTBananasView *)tap.view;
    NSLog(@"%i", view.tag);
}

- (void)dealloc
{
    AudioServicesDisposeSystemSoundID(mySound);
}

- (void) playSound{
    if ([GameManager sharedInstance].sound==YES) {
        AudioServicesPlaySystemSound(mySound);
    }
}

#pragma mark - GameDelegate methods

- (void)didReceiveMessage:(NSString *)symbol :(NSString *)coords{
    [self playSound];
}

#pragma mark - CollectionView Data Sourse
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self exp2:[XOGameModel sharedInstance].gameColumns];
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
    if ([XOGameModel sharedInstance].xTurn && !cell.mode) {
        cell.mode = 1;
        [XOGameModel sharedInstance].xTurn = NO;
    } else if (!cell.mode) {
        cell.mode = -1;
        [XOGameModel sharedInstance].xTurn = YES;
    }
    [[MPManager sharedInstance] sendPlayerMyMessage:[NSString stringWithFormat:@"x%i", (int)indexPath]];
    [self playSound];
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
- (int)exp2:(int)integer
{
    return integer*integer;
}
@end
