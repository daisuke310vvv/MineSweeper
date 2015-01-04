//
//  MSPlayViewController.h
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSPlayViewController : UIViewController
-(id)initGameWithFieldType:(NSString*)type amountOfBombs:(int)amount;
@end
