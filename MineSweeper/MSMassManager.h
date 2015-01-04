//
//  MSMassManager.h
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MSMass;

@interface MSMassManager : NSObject
+(MSMassManager*)sharedManager;

//全てのマスを配列で管理
//外部にはreadonly
@property(nonatomic,readonly)NSMutableArray *masses;

//指定したマスから二次元配列のxとyで返す
//-(CGPoint)getPointWithMass:(MSMass*)mass;
-(void)addMass:(MSMass*)mass;

-(void)resetMasses;

@end
