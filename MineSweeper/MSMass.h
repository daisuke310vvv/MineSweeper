//
//  MSMass.h
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSMass : UIButton
@property(nonatomic,copy)NSString *massType;
@property(nonatomic,copy)NSNumber *number;
@property(nonatomic,assign)BOOL isDisplayed;
@property(nonatomic,assign)BOOL isChecked;
-(void)setMassImageWithName:(NSString*)name;
-(void)setMassImageWithNumber:(int)number;
@end
