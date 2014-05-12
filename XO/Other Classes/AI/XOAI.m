//
//  XOAI.m
//  XO
//
//  Created by Misha on 11.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import "XOAI.h"
#import "XOGameModel.h"
#import "Constants.h"
@interface XOAI ()
@end
@implementation XOAI
@synthesize createMove;
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (void)moveWithTimer:(int)maxTime
{
    NSInteger interval = 1+arc4random()%(maxTime?maxTime:1);
    [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(move:) userInfo:nil repeats:NO];
}
- (void)move:(NSTimer *)timer
{
    [[XOGameModel sharedInstance] willChangeValueForIndexPath:[self makeMove]];
}
- (void)dealloc
{
    
}
- (NSIndexPath *)makeMove
{
    XOAIGameMode mode = [XOGameModel sharedInstance].aiGameMode;
    switch (mode) {
        case XOAIGameModeEasy:
            return [self getEasyMove:[XOGameModel sharedInstance].matrix];
        case XOAIGameModeMedium:
            return [self getMediumMove:[XOGameModel sharedInstance].matrix];
        default:
            return nil;
    }
}
- (NSIndexPath*)getEasyMove:(XOObjectiveMatrix *)matrix
{
    NSIndexPath *result = [NSIndexPath new];
    NSMutableArray *emptyItems = [NSMutableArray new];
    
    for (int i = 0; i<matrix.count; i++) {
        for (int j = 0; j<matrix.count; j++) {
            if ([matrix.value[j][i] intValue] == XOPlayerNone) {
                [emptyItems addObject:[NSIndexPath indexPathForItem:i inSection:j]];
            }
        }
    }
    if (emptyItems.count >0)
    {
        int random = arc4random()%(emptyItems.count);
        result = [emptyItems objectAtIndex:random];
        NSLog(@"%@", result);
        return result;
    }
    result = nil;
    return result;
}
- (NSIndexPath *)getMediumMove:(XOObjectiveMatrix *)matrix
{
    NSIndexPath *winMove = [self checkForWin:matrix];
    if (winMove) {
        return winMove;
    }
    NSIndexPath *protectMove = [self checkForProtect:matrix];
    if (protectMove) {
        return protectMove;
    }
    return /*nil;*/[self getEasyMove:matrix];
}
- (NSIndexPath *)checkForProtect:(XOObjectiveMatrix *)matrix
{
    return [self checkForWin:matrix];
}


- (NSIndexPath *)indexPathFromI:(int)i J:(int)j
{
    return [NSIndexPath indexPathForItem:i inSection:j];
}

- (NSIndexPath *)checkForWin:(XOObjectiveMatrix *)matrix
{
    int size = [XOGameModel sharedInstance].dimension;
    XOPlayer aiSide = [XOGameModel sharedInstance].me*-1;
    int countInRowToWin = [XOGameModel sharedInstance].dimension;
    
    // Horizontal
    for (int i = 0; i < size; i++) {
        int jStart = -1;
        int jEnd = -1;
        
        for (int j = 0; j < size; j++) {
            if ([matrix.value[i][j] intValue] == aiSide) {
                if (jStart < 0)
                    jStart = j;
                jEnd = j;
            }
            else {
                if ((jStart >= 0 && jEnd >=0 )&& (jEnd - jStart + 1 == countInRowToWin - 1)) {
                    // Can AI do move to left of finding block?
                    if (jStart > 0)
                        if ([matrix.value[i][jStart - 1] intValue] == XOPlayerNone)
                            return [self indexPathFromI:i J:jStart - 1];
                    
                    // Can AI do move to right of finding block?
                    if (jEnd < size - 1)
                        if ([matrix.value[i][jEnd + 1] intValue] == XOPlayerNone)
                            return [self indexPathFromI:i J:jEnd + 1];
                }
                
                jStart = -1;
                jEnd = -1;
            }
        }
    }
    
    // Vertical
    for (int j = 0; j < size; j++) {
        int iStart = -1;
        int iEnd = -1;
        
        for (int i = 0; i < size; i++) {
            if ([matrix.value[i][j] intValue] == aiSide) {
                if (iStart < 0)
                    iStart = i;
                iEnd = i;
            }
            else {
                if (iStart >= 0 && iEnd >=0 && iEnd - iStart + 1 == countInRowToWin - 1) {
                    // Can AI do move above of finding block?
                    if (iStart > 0)
                        if ([matrix.value[iStart - 1][j] intValue] == XOPlayerNone)
                            return [self indexPathFromI:iStart - 1 J:j];
                    
                    // Can AI do move below of finding block?
                    if (iEnd < size - 1)
                        if ([matrix.value[iEnd + 1] [j] intValue] == XOPlayerNone)
                            return [self indexPathFromI:iEnd + 1 J:j];
                }
                
                iStart = -1;
                iEnd = -1;
            }
        }
    }
    
    // Diagonal: from left top to right bottom
    for (int i = 0; i <= size - countInRowToWin + 1; i++) {
        for (int j = 0; j <= size - countInRowToWin + 1; j++) {
            if (abs(j-i) <= size - countInRowToWin) {
                
                BOOL isBlock = true;
                for (int shift = 0; shift < countInRowToWin - 1; shift++) {
                    isBlock = isBlock && [matrix.value[i + shift][j + shift] intValue] == aiSide;
                    if (!isBlock)
                        break;
                }
                
                if (isBlock) {
                    int iStart = i; int jStart = j;
                    int iEnd = i + countInRowToWin - 2; int jEnd = j + countInRowToWin - 2;
                    
                    // Can AI do move above left of finding block?
                    if (iStart > 0 && jStart > 0)
                        if ([matrix.value[iStart - 1][jStart - 1] intValue] == XOPlayerNone)
                            return [self indexPathFromI:iStart - 1 J:jStart - 1];
                    
                    // Can AI do move below right of finding block?
                    if (iEnd < size - 1 && jEnd < size - 1)
                        if ([matrix.value[iEnd + 1][jEnd + 1] intValue] == XOPlayerNone)
                            return [self indexPathFromI:iEnd + 1 J:jEnd + 1];
                }
            }
        }
    }
    
    // Diagonal: from right top to left bottom
    for (int i = 0; i <= size - countInRowToWin + 1; i++)
        for (int j = size - 1; j >= countInRowToWin - 2; j--) {{
            if (abs(i + j - size + 1) <= size - countInRowToWin) {
                
                BOOL isBlock = true;
                for (int shift = 0; shift < countInRowToWin - 1; shift++) {
                    isBlock = isBlock && [matrix.value[i + shift][j - shift] intValue] == aiSide;
                    if (!isBlock)
                        break;
                }
                
                if (isBlock) {
                    int iStart = i; int jStart = j;
                    int iEnd = i + countInRowToWin - 2; int jEnd = j - countInRowToWin + 2;
                    
                    // Can AI do move above right of finding block?
                    if (iStart > 0 && jStart < size - 1)
                        if ([matrix.value[iStart - 1][jStart + 1] intValue] == XOPlayerNone)
                            return [self indexPathFromI:iStart - 1 J:jStart + 1];
                    
                    // Can AI do move below left of finding block?
                    if (iEnd < size - 1 && jEnd > 0)
                        if ([matrix.value[iEnd + 1][jEnd - 1] intValue] == XOPlayerNone)
                            return [self indexPathFromI:iEnd + 1 J:jEnd - 1];
                }
            }
        }
        }
    
    return nil;
}

@end
