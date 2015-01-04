//
//  MSMass.m
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//

#import "MSMass.h"
#import "MSConstants.h"

@implementation MSMass
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)setMassImageWithName:(NSString*)name{
    
    NSString *imageName = @"";
    
    if([name isEqualToString:MSMassImageNameDefault])
        imageName = MSMassImageNameDefault;
    
    else if([name isEqualToString:MSMassImageNameBlank])
       imageName = MSMassImageNameBlank;
    
    else if([name isEqualToString:MSMassImageNameBomb])
        imageName = MSMassImageNameBomb;
    
    else if([name isEqualToString:MSMassImageNameCheck])
        imageName = MSMassImageNameCheck;
    
    else if([name isEqualToString:MSMassImageNameSelectableCheck])
        imageName = MSMassImageNameSelectableCheck;
    
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}

-(void)setMassImageWithNumber:(int)number{
    
    NSString *imageName = @"";
    
    switch (number) {
        case 1:
            imageName = MSMassImageNameOne;
            break;
        case 2:
            imageName = MSMassImageNameTwo;
            break;
        case 3:
            imageName = MSMassImageNameThree;
            break;
        case 4:
            imageName = MSMassImageNameFour;
            break;
        case 5:
            imageName = MSMassImageNameFive;
            break;
        case 6:
            imageName = MSMassImageNameSix;
            break;
        case 7:
            imageName = MSMassImageNameSeven;
            break;
        case 8:
            imageName = MSMassImageNameEight;
            break;
            
        default:
            break;
    }
    
    
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    
}

@end
