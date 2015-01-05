//
//  MSConstants.m
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//

#import "MSConstants.h"

#pragma mark - Mass type
NSString *const MSMassTypeBomb      = @"MSMassTypeBomb";
NSString *const MSMassTypeBlank     = @"MSMassTypeBlank";
NSString *const MSMassTypeNumber    = @"MSMassTypeNumber";

NSString *const MSFieldType5x5      = @"MSFieldType5x5";
NSString *const MSFieldType9x9      = @"MSFieldType9x9";
NSString *const MSFieldType12x12    = @"MSFieldType12x12";

int const MSSIZE_OF_IPHONE_5     = 320;
int const MSSIZE_OF_IPHONE_6     = 375;
int const MSSIZE_OF_IPHONE_6P    = 414;

NSString *const MSMassImageNameDefault              = @"mineDefault";
NSString *const MSMassImageNameBlank                = @"mineBlank";
NSString *const MSMassImageNameBomb                 = @"mineBomb";
NSString *const MSMassImageNameCheck                = @"mineCheck";
NSString *const MSMassImageNameSelectableCheck      = @"mineSelectableCheck";
NSString *const MSMassImageNameOne                  = @"mineOne";
NSString *const MSMassImageNameTwo                  = @"mineTwo";
NSString *const MSMassImageNameThree                = @"mineThree";
NSString *const MSMassImageNameFour                 = @"mineFour";
NSString *const MSMassImageNameFive                 = @"mineFive";
NSString *const MSMassImageNameSix                  = @"mineSix";
NSString *const MSMassImageNameSeven                = @"mineSeven";
NSString *const MSMassImageNameEight                = @"mineEight";

NSString *const MSButtonImageNameHome               = @"homeBtn";
NSString *const MSButtonImageNameRetry              = @"retryBtn";
NSString *const MSButtonImageNameMineCheck          = @"mineCheckBtn";
NSString *const MSButtonImageNameFacebook          = @"facebookBtn";
NSString *const MSButtonImageNameTwitter          = @"twitterBtn";

NSString *const MSImageNameHomeMines         = @"homeMines";
NSString *const MSImageNameBackBtn       = @"backItem";
NSString *const MSImageNameSelectedItem      = @"selectedItem";
NSString *const MSImageNameUnselectedItem    = @"unselectedItem";

NSString *const MSBestScoreTypeField5x5_type1       = @"MSBestScoreTypeFieldType5x5_type1";
NSString *const MSBestScoreTypeField5x5_type2       = @"MSBestScoreTypeFieldType5x5_type2";
NSString *const MSBestScoreTypeField5x5_type3       = @"MSBestScoreTypeFieldType5x5_type3";
NSString *const MSBestScoreTypeField9x9_type1       = @"MSBestScoreTypeFieldType9x9_type1";
NSString *const MSBestScoreTypeField9x9_type2       = @"MSBestScoreTypeFieldType9x9_type2";
NSString *const MSBestScoreTypeField9x9_type3       = @"MSBestScoreTypeFieldType9x9_type3";
NSString *const MSBestScoreTypeField12x12_type1     = @"MSBestScoreTypeFieldType12x12_type1";
NSString *const MSBestScoreTypeField12x12_type2     = @"MSBestScoreTypeFieldType12x12_type2";
NSString *const MSBestScoreTypeField12x12_type3     = @"MSBestScoreTypeFieldType12x12_type3";

//TODO: Ad ID 設定 for App Store
extern NSString *const MSGADAdUnitID    = @"XXXX";

extern NSString *const MSIMobilePublisherID     = @"XXXX";
extern NSString *const MSIMobileMediaID         = @"XXXX";
extern NSString *const MSIMobileSpotID          = @"XXXX";