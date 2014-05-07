//
//  XOOMatrix.h
//  XO
//
//  Created by Misha on 06.05.14.
//  Copyright (c) 2014 mobilez365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XOOMatrix : NSObject
@property (nonatomic) int dimension;
@property (nonatomic) int *vectorValue;
@property (nonatomic, strong) NSArray *value;
@property (nonatomic) int minComb;
@end
