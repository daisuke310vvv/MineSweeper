//
//  MSPlayViewController.m
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//

#import "MSPlayViewController.h"
#import "MSMass.h"
#import "MSMassManager.h"
#import "MSStartViewController.h"

//TODO: pchに変更
#import "MSConstants.h"
#import <Social/Social.h>

#import "GADBannerView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface MSPlayViewController () <GADBannerViewDelegate>
{
    
    
    //画面の横幅
    CGFloat _widthOfDisplay;
    
    /* ----------------------------------------------------- */
    // タイム
    /* ----------------------------------------------------- */
    NSTimer *_countTimer;
    
    UILabel *_timeLabel;
    float _time;
    
    UIView *_countView;
    UILabel *_countLabel;
    int _timeCount;
    /* ----------------------------------------------------- */
    
    
    int _amountOfBombs;
    int _numberOfColsInField;
    int _boxLength; //一マスの横(縦)幅
    
    BOOL selectCheck; //YES : MINE CHECKボタンタップ
    BOOL isEnd; //ゲームオーバーでないかどうか
    
    
    UIView *_resultView; //結果画像
    
    NSMutableArray *masses; //すべてのマスを管理
    
    GADBannerView *_bannerView;
}

@end

@implementation MSPlayViewController

//5x5,9x9,12x12
-(id)initGameWithFieldType:(NSString*)type amountOfBombs:(int)amount{
    
    
    self = [super init];
    if(!self) return nil;
    
    
    if([type isEqualToString:MSFieldType5x5])
        _numberOfColsInField= 5;
    else if([type isEqualToString:MSFieldType9x9])
        _numberOfColsInField= 9;
    else if([type isEqualToString:MSFieldType12x12])
        _numberOfColsInField= 12;
    
    _amountOfBombs = amount;
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _widthOfDisplay = [UIScreen mainScreen].bounds.size.width;
    
    [self setTimeLabel];
    [self setButton];
    
    self.view.backgroundColor = RGB(245, 245, 245);
    
    selectCheck = NO;
    isEnd = NO;
    
    [self initGame];
    
    [self startCount];
    
    _bannerView = [[GADBannerView alloc]initWithAdSize:kGADAdSizeMediumRectangle];
    _bannerView.adUnitID = MSGADAdUnitID;
    _bannerView.rootViewController = self;
    _bannerView.delegate = self;
    
    [_bannerView loadRequest:[GADRequest request]];
    
}

-(void)setButton{
    
    int sideSpace = 10;
    int centerSpace = 10;
    int lengthOfHomeAndRetryBtn = (self.view.frame.size.width - (sideSpace * 2) - centerSpace)/2;
    
    
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setBackgroundImage:[UIImage imageNamed:MSButtonImageNameHome] forState:UIControlStateNormal];
    [homeBtn addTarget:self action:@selector(tappedHomeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *mineCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mineCheckBtn setBackgroundImage:[UIImage imageNamed:MSButtonImageNameMineCheck] forState:UIControlStateNormal];
    [mineCheckBtn addTarget:self action:@selector(tappedMineCheckBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [retryBtn setBackgroundImage:[UIImage imageNamed:MSButtonImageNameRetry] forState:UIControlStateNormal];
    [retryBtn addTarget:self action:@selector(tappedRetryBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    if(_widthOfDisplay == MSSIZE_OF_IPHONE_5){
        
        [mineCheckBtn setFrame:CGRectMake(homeBtn.frame.origin.x + centerSpace,
                                     self.view.frame.size.height - 50 - 130,
                                     self.view.frame.size.width - sideSpace * 2, 60)];
        
        [homeBtn setFrame:CGRectMake(self.view.frame.origin.x + sideSpace,
                                     self.view.frame.size.height - 50 - 60,
                                     lengthOfHomeAndRetryBtn, 60)];
        
        [retryBtn setFrame:CGRectMake(self.view.frame.origin.x  + homeBtn.frame.size.width + sideSpace + centerSpace,
                                     self.view.frame.size.height - 50 - 60,
                                     lengthOfHomeAndRetryBtn, 60)];
        
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6){
        
        [mineCheckBtn setFrame:CGRectMake(homeBtn.frame.origin.x + centerSpace,
                                     self.view.frame.size.height - 50 - 160,
                                     self.view.frame.size.width - sideSpace * 2, 60)];
        
        [homeBtn setFrame:CGRectMake(self.view.frame.origin.x + sideSpace,
                                     self.view.frame.size.height - 50 - 80,
                                     lengthOfHomeAndRetryBtn, 60)];
        
        [retryBtn setFrame:CGRectMake(self.view.frame.origin.x  + homeBtn.frame.size.width + sideSpace + centerSpace,
                                     self.view.frame.size.height - 50 - 80,
                                     lengthOfHomeAndRetryBtn, 60)];
        
        
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6P){
        
        [mineCheckBtn setFrame:CGRectMake(homeBtn.frame.origin.x + centerSpace,
                                     self.view.frame.size.height - 50 - 180,
                                     self.view.frame.size.width - sideSpace * 2, 90)];
        
        [homeBtn setFrame:CGRectMake(self.view.frame.origin.x + sideSpace,
                                     self.view.frame.size.height - 50 - 80,
                                     lengthOfHomeAndRetryBtn, 90)];
        
        [retryBtn setFrame:CGRectMake(self.view.frame.origin.x  + homeBtn.frame.size.width + sideSpace + centerSpace,
                                     self.view.frame.size.height - 50 - 80,
                                     lengthOfHomeAndRetryBtn, 90)];
        
    }else{
        
        [mineCheckBtn setFrame:CGRectMake(homeBtn.frame.origin.x + centerSpace,
                                     self.view.frame.size.height -10 - 180,
                                     self.view.frame.size.width - sideSpace * 2, 90)];
        
        [homeBtn setFrame:CGRectMake(self.view.frame.origin.x + sideSpace,
                                     self.view.frame.size.height -10 - 80,
                                     lengthOfHomeAndRetryBtn, 90)];
        
        [retryBtn setFrame:CGRectMake(self.view.frame.origin.x  + homeBtn.frame.size.width + sideSpace + centerSpace,
                                     self.view.frame.size.height -10 - 80,
                                     lengthOfHomeAndRetryBtn, 90)];
        
    }
    
    
    [self.view addSubview:homeBtn];
    [self.view addSubview:mineCheckBtn];
    [self.view addSubview:retryBtn];
}

-(void)initGame{
    
    isEnd = NO;
    _time = 0.0;
    
    NSArray *numbers = [self createBombNumbers];
    
    masses = @[].mutableCopy;
    
    int space = 10;
    _boxLength = (self.view.frame.size.width - space * 2) / _numberOfColsInField;
    
    //マス生成配置
    //地雷割り当て
    for(int i = 0;i<_numberOfColsInField;i++){
        for(int j = 0;j<_numberOfColsInField;j++){
            
            MSMass *mass = [MSMass buttonWithType:UIButtonTypeCustom];
            mass.frame = CGRectMake((self.view.frame.size.width - _numberOfColsInField * _boxLength)/2 + _boxLength * j,
                                                                   (self.view.frame.size.height - _numberOfColsInField* _boxLength)/2 + _boxLength * i - 70,
                                                                   _boxLength,
                                                                   _boxLength
                                                                   );
            //TODO: 【fix】初期空白
            mass.massType = MSMassTypeBlank;
            mass.isDisplayed = NO;
            mass.isChecked = NO;
            mass.adjustsImageWhenDisabled = NO;
            mass.adjustsImageWhenHighlighted = NO;
            
            if(_numberOfColsInField == 5){
                [mass.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:24]];
            }else if(_numberOfColsInField == 9){
                [mass.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:14]];
            }else{
                [mass.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:12]];
            }
            
            [mass addTarget:self action:@selector(tappedMass:) forControlEvents:UIControlEventTouchUpInside];
            [mass setMassImageWithName:MSMassImageNameDefault];
            
            for(NSNumber *n in numbers){
                if([n intValue] == ((i+1) + (j) * _numberOfColsInField)){ //地雷
                    mass.massType = MSMassTypeBomb;
                }
            }
            
            //[[MSMassManager sharedManager] addMass:mass];
            [masses addObject:mass];
            [self.view addSubview:mass];
        }
    }
    
    //数字割り当て
    //注目マスの8方向のマスを見てMSMassTypeBombの数をカウントし、その数を割り当てる
    for(int i = 0;i<_numberOfColsInField;i++){
        for(int j = 0;j<_numberOfColsInField;j++){
            
            int bombCount = 0;
            NSArray *surroundMasses = [self surroundMassesWithX:i Y:j];
            
            //周りの地雷の数をカウント
            for(MSMass *m in surroundMasses){
                
                if([m.massType isEqualToString:MSMassTypeBomb])
                    bombCount++;
                
            }
            
            //注目マス
            MSMass *focusedMass = masses[i + (j*_numberOfColsInField)];
            
            //マスのタイプが地雷以外
            if(![focusedMass.massType isEqualToString:MSMassTypeBomb]){
                
                if(bombCount == 0){
                    focusedMass.number = @(bombCount);
                    focusedMass.massType = MSMassTypeBlank;
                }else{
                    focusedMass.number = @(bombCount);
                    focusedMass.massType = MSMassTypeNumber;
                }
                
            }
            
            
        }
    }
    
}

#pragma mark - button methods
-(void)tappedMass:(MSMass*)mass{
    
    [self flipMass:mass];
    
}

-(void)tappedHomeBtn:(UIButton*)button{
    
    
    [self presentViewController:[MSStartViewController startViewController] animated:YES completion:nil];
    
}
-(void)tappedMineCheckBtn:(UIButton*)button{
    
    [self mineCheck];
    
}
-(void)tappedRetryBtn:(UIButton*)button{
    
    [self retry];
}
-(void)tappedFacebookBtn:(UIButton*)button{
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share Error"
                                                        message:@"This iPhone doesn't have a facebook account."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *text = [NSString stringWithFormat:@"【   MINE SWEEPER   】\n*** CLEAR! (%.1fsec) ***\nFIELD : %dx%d\nBOMBS : %d\n\n",_time,_numberOfColsInField,_numberOfColsInField,_amountOfBombs];
    NSURL *URL = [NSURL URLWithString:@"https://itunes.apple.com/jp/app/mine-sweeper/id955311550?ls=1&mt=8"];
    NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation([UIImage imageNamed:@"logo_minesweeper"])];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [controller setInitialText:text];
    [controller addURL:URL];
    [controller addImage:[[UIImage alloc] initWithData:imageData]];
    controller.completionHandler =^(SLComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    
    [self presentViewController:controller animated:YES completion:nil];
    
}

-(void)tappedTwitterBtn:(UIButton*)button{
    
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet Error"
                                                        message:@"This iPhone doesn't have a twitter account."
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    
    NSString *text = [NSString stringWithFormat:@"【   MINE SWEEPER   】\n*** CLEAR! (%.1fsec) ***\nFIELD : %dx%d\nBOMBS : %d\n\n",_time,_numberOfColsInField,_numberOfColsInField,_amountOfBombs];
    NSURL *URL = [NSURL URLWithString:@"https://itunes.apple.com/jp/app/mine-sweeper/id955311550?ls=1&mt=8"];
    NSData *imageData = [[NSData alloc]initWithData:UIImagePNGRepresentation([UIImage imageNamed:@"logo_minesweeper"])];
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:text];
    [controller addURL:URL];
    [controller addImage:[[UIImage alloc] initWithData:imageData]];
    controller.completionHandler =^(SLComposeViewControllerResult result){
        [self dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:controller animated:YES completion:nil];
    
    
}

-(void)mineCheck{
    
    if(!isEnd){
        
        //すべてのマスからisDisplayedがNOのマスを画像切替え
        if(selectCheck == NO){
            selectCheck = YES;
            //        for(MSMass *m in [MSMassManager sharedManager].masses){
            for(MSMass *m in masses){
                
                if(!m.isDisplayed && !m.isChecked){
                    [m setMassImageWithName:MSMassImageNameSelectableCheck];
                }
                
            }
        }else{
            
            selectCheck = NO;
            //        for(MSMass *m in [MSMassManager sharedManager].masses){
            for(MSMass *m in masses){
                
                if(!m.isDisplayed && !m.isChecked){
                    [m setMassImageWithName:MSMassImageNameDefault];
                }
                
            }
            
        }
        
    }
    
}
-(void)retry{
    
    if(_countTimer){
        _time = 0.0;
        [_timeLabel setText:[NSString stringWithFormat:@"%.1f",_time]];
        [_countTimer invalidate];
    }
    
    if(_resultView){
        [_resultView removeFromSuperview];
        _resultView = nil;
    }
    
    
//    for(MSMass *m in [MSMassManager sharedManager].masses){
    for(MSMass *m in masses){
        [m removeFromSuperview];
    }
    //[[MSMassManager sharedManager] resetMasses];
    [masses removeAllObjects];
    
    selectCheck = NO;
    
    [self initGame];
    [self startCount];
    
    
}


#pragma mark - start count
-(void)startCount{
    
    _timeCount = 3;
    
    _countView = [[UIView alloc]initWithFrame:self.view.frame];
    _countView.backgroundColor = [RGB(0, 0, 0) colorWithAlphaComponent:0.5];
    
    _countLabel = [[UILabel alloc]init];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.text = [NSString stringWithFormat:@"%d",_timeCount];
    _countLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:50];
    _countLabel.textColor = [UIColor whiteColor];
    
    
    if(_widthOfDisplay == MSSIZE_OF_IPHONE_5){
        
        _countLabel.frame = CGRectMake((_countView.frame.size.width - 100)/2, CGRectGetMidY(_countView.frame) - + 200, 100, 60);
        
        
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6){
        
    _countLabel.frame = CGRectMake((_countView.frame.size.width - 100)/2, CGRectGetMidY(_countView.frame) - + 200, 100, 60);
        
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6P){
        
    _countLabel.frame = CGRectMake((_countView.frame.size.width - 100)/2, CGRectGetMidY(_countView.frame) - + 200, 100, 60);
        
    }else{
        
    _countLabel.frame = CGRectMake((_countView.frame.size.width - 100)/2, CGRectGetMidY(_countView.frame) - + 200, 100, 60);
    }
    
    _bannerView.frame = CGRectMake((_countView.frame.size.width - _bannerView.frame.size.width)/2,
                                   (_countView.frame.size.height - _bannerView.frame.size.height)/2,
                                   _bannerView.frame.size.width,
                                   _bannerView.frame.size.height);
    
    
    [_countView addSubview:_countLabel];
    [_countView addSubview:_bannerView];
    [self.view addSubview:_countView];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
}

-(void)countDown:(NSTimer*)timer{
    
    _timeCount--;
    
    _countLabel.text = [NSString stringWithFormat:@"%d",_timeCount];
    
    if(_timeCount == 0){
        [timer invalidate];
        [self startPlay];
    }
    
}

-(void)startPlay{
    
    _countTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(count:) userInfo:nil repeats:YES];
    
    [_countView removeFromSuperview];
    _countView = nil;
    
    
}

-(void)count:(NSTimer*)timer{
    
    if(isEnd)
        [timer invalidate];
    
    _time += 0.1;
    _timeLabel.text = [NSString stringWithFormat:@"%.1f",_time];
    
}

-(void)setTimeLabel{
    
    _time = 0.0;
    
   UILabel *label = [[UILabel alloc]init];
   label.text = [NSString stringWithFormat:@"TIME"];
   label.textColor = RGB(100, 100,100);
   label.textAlignment = NSTextAlignmentLeft;
    
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.text = [NSString stringWithFormat:@"%.1f",_time];
    _timeLabel.textColor = RGB(100,100,100);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    if(_widthOfDisplay == MSSIZE_OF_IPHONE_5){
        
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18];
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18];
        
        _timeLabel.frame = CGRectMake(self.view.frame.size.width - 200 - 16, self.view.frame.origin.y + 20, 200, 50);
        label.frame = CGRectMake(self.view.frame.origin.x + 16, self.view.frame.origin.y + 20, 100, 50);
        
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6){
        
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20];
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20];
        
        _timeLabel.frame = CGRectMake(self.view.frame.size.width - 200 - 16, self.view.frame.origin.y + 20, 200, 100);
        label.frame = CGRectMake(self.view.frame.origin.x + 16, self.view.frame.origin.y + 20, 100, 100);
        
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6P){
        
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20];
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:20];
        
        _timeLabel.frame = CGRectMake(self.view.frame.size.width - 200 - 16, self.view.frame.origin.y + 30, 200, 100);
        label.frame = CGRectMake(self.view.frame.origin.x + 16, self.view.frame.origin.y + 30, 200, 100);
        
    }else{
        
        label.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:32];
        _timeLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:32];
        
        _timeLabel.frame = CGRectMake(self.view.frame.size.width - 200 - 10, self.view.frame.origin.y + 30, 200, 40);
        label.frame = CGRectMake(self.view.frame.origin.x + 10, self.view.frame.origin.y + 30, 200, 40);
        //NSLog(@"%f",_widthOfDisplay);
        
    }
    
    
    [self.view addSubview:label];
    [self.view addSubview:_timeLabel];
}

#pragma mark - flip mass
-(void)flipMass:(MSMass*)mass{
    
    //地雷チェックをしない場合かつ地雷チェックしているマスの場合はなにもせずにスルー
    if(!selectCheck && mass.isChecked)
        return;
    
    //地雷チェックをする場合
    if(selectCheck){
        
        //地雷チェックをしている、していないのフラグ
        selectCheck = NO;
        
        if(!mass.isChecked){ //地雷チェックをセット
            
            mass.isChecked = YES;
            [mass setMassImageWithName:MSMassImageNameCheck];
            
        }else{ //地雷チェックを解除
            
            mass.isChecked = NO;
            [mass setMassImageWithName:MSMassImageNameDefault];
            
        }
        
        //その他のマスを通常のマスの画像に戻す
        for(MSMass *m in masses){
            
            if(![m isEqual:mass] && !m.isDisplayed && !m.isChecked)
                [m setMassImageWithName:MSMassImageNameDefault];
            
        }
        
        
        return;
    }
    
    //マスがまだ表示されていない場合
    if(!mass.isDisplayed){
        
        mass.isDisplayed = YES;
        mass.enabled = NO;
        
        if([mass.massType isEqualToString:MSMassTypeBomb]){
            
            //NSLog(@"ゲームオーバー！");
            isEnd = YES;
            [mass setMassImageWithName:MSMassImageNameBomb];
            mass.tintColor = [UIColor clearColor];
            mass.backgroundColor = [UIColor clearColor];
            [self gameOver];
            
            return;
            
        }else if([mass.massType isEqualToString:MSMassTypeNumber]){
            
            //NSLog(@"数字");
            [mass setMassImageWithNumber:[mass.number intValue]];
            [mass setTitle:[NSString stringWithFormat:@"%d",[mass.number intValue]] forState:UIControlStateNormal];
            
        }else{ //空白
            //NSLog(@"空白");
            [mass setBackgroundImage:[UIImage imageNamed:@"mineBlank.png"] forState:UIControlStateNormal];
            //空白の場合、そのマスの周りのマスを見る。
            //もし周りのマスで空白があった場合、そのマスもflipする
            [self checkSurroundMassesFrom:mass];
            
        }
        
    }
    
    
    //クリアかどうかの判定
    //すべてのマスの中でdisplayしていないマスの数が地雷数と同等であればクリア
    if([self getNumberOfLeftMassNotDisplayed] == _amountOfBombs)
        [self gameClear];
    
}

-(void)checkSurroundMassesFrom:(MSMass*)mass{
    
//    NSInteger n = [[MSMassManager sharedManager].masses indexOfObject:mass];
    NSInteger n = [masses indexOfObject:mass];
    
    int x = n % _numberOfColsInField;
    int y = (int)(n /_numberOfColsInField);
    
    
    NSArray *checkMasses = [self surroundMassesWithX:x Y:y];
    
    for(MSMass *m in checkMasses){
        
        if([m.massType isEqualToString:MSMassTypeBlank]){
            [self flipMass:m];
        }else if([m.massType isEqualToString:MSMassTypeNumber]){
            [self flipMass:m];
        }
        
    }
    
    
}

#pragma mark - game clear and over
-(void)gameClear{
    
    //NSLog(@"game clear");
    isEnd = YES;
    
    [self updateBestScore];
    
    //結果画面表示
    [self addResultView];
    
    
    //すべての地雷マスを表示
//    for(MSMass *m in [MSMassManager sharedManager].masses){
    for(MSMass *m in masses){
       
        if(!m.isDisplayed)
       //     [m setBackgroundImage:[UIImage imageNamed:@"bombMass.png"] forState:UIControlStateNormal];
            [m setMassImageWithName:MSMassImageNameBomb];
        
        
    }
    
}

-(void)gameOver{
    
    _resultView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 10,
                                                          (self.view.frame.size.height - _numberOfColsInField * _boxLength)/2  - 70,
                                                         self.view.frame.size.width - 10*2,
                                                         self.view.frame.size.width - 10*2)];
    _resultView.backgroundColor = [RGB(245, 245, 245) colorWithAlphaComponent:0.7];
    
    //ゲームオーバーラベル
    UILabel *clearLabel = [[UILabel alloc]init];
    clearLabel.text = @"GAME OVER";
    clearLabel.textAlignment = NSTextAlignmentCenter;
    
    if(_widthOfDisplay == MSSIZE_OF_IPHONE_5){
        clearLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:32];
        clearLabel.frame = CGRectMake((_resultView.frame.size.width - 300)/2, _resultView.frame.origin.y + 10, 300, 100);
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6){
        clearLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:46];
        clearLabel.frame = CGRectMake((_resultView.frame.size.width - 300)/2, 10, 300, 100);
    }else{
        clearLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:40];
        clearLabel.frame = CGRectMake((_resultView.frame.size.width - 300)/2, 10, 300, 100);
    }
    
    [_resultView addSubview:clearLabel];
    [self.view addSubview:_resultView];
    
}

-(void)addResultView{
    
    
    _resultView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x + 10,
                                                          (self.view.frame.size.height - _numberOfColsInField * _boxLength)/2  - 70,
                                                         self.view.frame.size.width - 10*2,
                                                         self.view.frame.size.width - 10*2)];
    _resultView.backgroundColor = [RGB(245, 245, 245) colorWithAlphaComponent:0.7];
    _resultView.layer.cornerRadius = 15.f;
    
    //ゲームクリアラベル
    UILabel *clearLabel = [[UILabel alloc]init];
    clearLabel.text = @"GAME CLEAR";
    clearLabel.textColor = RGB(100, 100, 100);
    clearLabel.textAlignment = NSTextAlignmentCenter;
    
    //FacebookBtn
    UIButton *facebookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookBtn setBackgroundImage:[UIImage imageNamed:MSButtonImageNameFacebook] forState:UIControlStateNormal];
    [facebookBtn addTarget:self action:@selector(tappedFacebookBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //TweetBtn
    UIButton *twitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitterBtn setBackgroundImage:[UIImage imageNamed:MSButtonImageNameTwitter] forState:UIControlStateNormal];
    [twitterBtn addTarget:self action:@selector(tappedTwitterBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    int lengthOfFbAndTwBtn = (_resultView.frame.size.width - 10)/2;
    
    
    if(_widthOfDisplay == MSSIZE_OF_IPHONE_5){
        
        clearLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:28];
        clearLabel.frame = CGRectMake((_resultView.frame.size.width - 300)/2, _resultView.frame.origin.y + 10, 300, 100);
        
        [facebookBtn setFrame:CGRectMake(self.view.frame.origin.x,
                                     (self.view.frame.size.height - 60)/2 - 60,
                                     lengthOfFbAndTwBtn, 60)];
        
        [twitterBtn setFrame:CGRectMake(self.view.frame.origin.x  + facebookBtn.frame.size.width + 10,
                                     (self.view.frame.size.height - 60)/2 - 60,
                                     lengthOfFbAndTwBtn, 60)];
        
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6){
        
        clearLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:40];
        clearLabel.frame = CGRectMake((_resultView.frame.size.width - 300)/2, 10, 300, 220);
        
        [facebookBtn setFrame:CGRectMake(self.view.frame.origin.x,
                                     (self.view.frame.size.height - 60)/2 - 60,
                                     lengthOfFbAndTwBtn, 60)];
        
        [twitterBtn setFrame:CGRectMake(self.view.frame.origin.x  + facebookBtn.frame.size.width + 10,
                                     (self.view.frame.size.height - 60)/2 - 60,
                                     lengthOfFbAndTwBtn, 60)];
        
    }else if(_widthOfDisplay == MSSIZE_OF_IPHONE_6P){
        
        clearLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:40];
        clearLabel.frame = CGRectMake((_resultView.frame.size.width - 300)/2, 150, 300, 50);
        [facebookBtn setFrame:CGRectMake(self.view.frame.origin.x,
                                     (self.view.frame.size.height - 60)/2 - 60,
                                     lengthOfFbAndTwBtn, 80)];
        
        [twitterBtn setFrame:CGRectMake(self.view.frame.origin.x  + facebookBtn.frame.size.width + 10,
                                     (self.view.frame.size.height - 60)/2 - 60,
                                     lengthOfFbAndTwBtn, 80)];
        
    }else{
        
        clearLabel.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:64];
        clearLabel.frame = CGRectMake((_resultView.frame.size.width - 400)/2, 200, 400, 80);
        
        [facebookBtn setFrame:CGRectMake(self.view.frame.origin.x,
                                     (self.view.frame.size.height - 150)/2 - 60,
                                     lengthOfFbAndTwBtn, 150)];
        
        [twitterBtn setFrame:CGRectMake(self.view.frame.origin.x  + facebookBtn.frame.size.width + 10,
                                     (self.view.frame.size.height - 150)/2 - 60,
                                     lengthOfFbAndTwBtn, 150)];
        
    }
    
    //[_resultView addSubview:tweetBtn];
    [_resultView addSubview:facebookBtn];
    [_resultView addSubview:twitterBtn];
    [_resultView addSubview:clearLabel];
    
    [self.view addSubview:_resultView];
    
}

-(void)updateBestScore{
    
    NSString *currentFieldType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] objectForKey:@"currentFieldType"];
    
    NSMutableDictionary *bestScoreDict = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] objectForKey:@"bestScore"] mutableCopy];
    
    float currentScore = [[bestScoreDict objectForKey:currentFieldType] floatValue];
    
    if(currentScore > _time || currentScore == 0){ //記録更新
        currentScore = _time;
    }
    
    
    [bestScoreDict setValue:@(currentScore) forKey:currentFieldType];
    
    [[NSUserDefaults standardUserDefaults] setObject:@{
                                                       @"currentFieldType":currentFieldType,
                                                       @"bestScore":bestScoreDict}
                                              forKey:@"bestScore"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(int)getNumberOfLeftMassNotDisplayed{
    
    int count = 0;
//    for(MSMass *m in [MSMassManager sharedManager].masses){
    for(MSMass *m in masses){
       
        if(!m.isDisplayed)
            count++;
    }
    
    //NSLog(@"left masses count %d",count);
    return count;
    
}

//TODO: リファクタリング
-(NSArray*)createBombNumbers{
    
    NSMutableArray *numbers = @[].mutableCopy;
    
    while(numbers.count != _amountOfBombs){
        
        int r = (arc4random() % (_numberOfColsInField* _numberOfColsInField))+ 1;
        
        BOOL isAlreadyChosenNumber = NO;
        //生成された数がすで選ばれているかどうか
        for(NSNumber *n in numbers){
            if([n intValue] == r)
                isAlreadyChosenNumber = YES;
        }
        
        if(!isAlreadyChosenNumber){
            [numbers addObject:@(r)];
        }
    }
    
    return numbers.copy;
}



//TODO: 【fix】ハードコード(5)
-(NSArray*)surroundMassesWithX:(int)x Y:(int)y{
    
    
    NSArray *surroundMasses;
    
    if(x == 0 && y == 0){               //左上
        
        
        MSMass *rc = masses[(x+1) + (y)*_numberOfColsInField];
        
        MSMass *cd = masses[(x) + (y+1)*_numberOfColsInField];
        MSMass *rd = masses[(x+1) + (y+1)*_numberOfColsInField];
        
        surroundMasses = @[rc,cd,rd].copy;
        
    }else if(x ==_numberOfColsInField-1 && y == 0){         //右上
        
        MSMass *lc = masses[(x-1) + (y)*_numberOfColsInField];
        
        MSMass *ld = masses[(x-1) + (y+1)*_numberOfColsInField];
        MSMass *cd = masses[(x) + (y+1)*_numberOfColsInField];
        
        surroundMasses = @[lc,ld,cd].copy;
        
    }else if(x == 0 && y ==_numberOfColsInField-1){         //左下
        
        MSMass *cu = masses[(x) + (y-1)*_numberOfColsInField];
        MSMass *ru = masses[(x+1) + (y-1)*_numberOfColsInField];
        
        MSMass *rc = masses[(x+1) + (y)*_numberOfColsInField];
        
        surroundMasses = @[cu,ru,rc].copy;
        
    }else if(x == _numberOfColsInField- 1 && y == _numberOfColsInField- 1){         //右下
        
        MSMass *lu = masses[(x-1) + (y-1)*_numberOfColsInField];
        MSMass *cu = masses[(x) + (y-1)*_numberOfColsInField];
        
        MSMass *lc = masses[(x-1) + (y)*_numberOfColsInField];
        
        surroundMasses = @[lu,cu,lc].copy;
        
    }else if(x > 0 && x <_numberOfColsInField-1 && y == 0){ //上辺
        
        MSMass *lc = masses[(x-1) + (y)*_numberOfColsInField];
        MSMass *rc = masses[(x+1) + (y)*_numberOfColsInField];
        
        MSMass *ld = masses[(x-1) + (y+1)*_numberOfColsInField];
        MSMass *cd = masses[(x) + (y+1)*_numberOfColsInField];
        MSMass *rd = masses[(x+1) + (y+1)*_numberOfColsInField];
        
        surroundMasses = @[lc,rc,ld,cd,rd].copy;
        
    }else if(x == 0 && y > 0 && y <_numberOfColsInField-1){ //左辺
        
        MSMass *cu = masses[(x) + (y-1)*_numberOfColsInField];
        MSMass *ru = masses[(x+1) + (y-1)*_numberOfColsInField];
        
        MSMass *rc = masses[(x+1) + (y)*_numberOfColsInField];
        
        MSMass *cd = masses[(x) + (y+1)*_numberOfColsInField];
        MSMass *rd = masses[(x+1) + (y+1)*_numberOfColsInField];
        
        surroundMasses = @[cu,ru,rc,cd,rd].copy;
        
    }else if(x ==_numberOfColsInField-1 && y > 0 && y <_numberOfColsInField-1){ //右辺
        
        MSMass *lu = masses[(x-1) + (y-1)*_numberOfColsInField];
        MSMass *cu = masses[(x) + (y-1)*_numberOfColsInField];
        
        MSMass *lc = masses[(x-1) + (y)*_numberOfColsInField];
        
        MSMass *ld = masses[(x-1) + (y+1)*_numberOfColsInField];
        MSMass *cd = masses[(x) + (y+1)*_numberOfColsInField];
        
        surroundMasses = @[lu,cu,lc,ld,cd].copy;
        
    }else if(x > 0 && x <_numberOfColsInField-1 && y ==_numberOfColsInField-1){ //下辺
        
        MSMass *lu = masses[(x-1) + (y-1)*_numberOfColsInField];
        MSMass *cu = masses[(x) + (y-1)*_numberOfColsInField];
        MSMass *ru = masses[(x+1) + (y-1)*_numberOfColsInField];
        
        MSMass *lc = masses[(x-1) + (y)*_numberOfColsInField];
        MSMass *rc = masses[(x+1) + (y)*_numberOfColsInField];
        
        surroundMasses = @[lu,cu,ru,lc,rc].copy;
        
    }else{                              //その他
        
        
        MSMass *lu = masses[(x-1) + (y-1)*_numberOfColsInField];
        MSMass *cu = masses[(x) + (y-1)*_numberOfColsInField];
        MSMass *ru = masses[(x+1) + (y-1)*_numberOfColsInField];
        
        MSMass *lc = masses[(x-1) + (y)*_numberOfColsInField];
        MSMass *rc = masses[(x+1) + (y)*_numberOfColsInField];
        
        MSMass *ld = masses[(x-1) + (y+1)*_numberOfColsInField];
        MSMass *cd = masses[(x) + (y+1)*_numberOfColsInField];
        MSMass *rd = masses[(x+1) + (y+1)*_numberOfColsInField];
        
        surroundMasses = @[lu,cu,ru,lc,rc,ld,cd,rd].copy;
        
    }
    
    
    
    return surroundMasses;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GADBannerViewDelegate
-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    
   //NSLog(@"did fail to received ad with error %@",error);
    
}

@end
