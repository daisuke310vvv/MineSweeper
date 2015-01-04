//
//  MSSettingsViewController.m
//  MineSweeper
//
//  Created by SatoDaisuke on 1/3/15.
//  Copyright (c) 2015 SatoDaisuke. All rights reserved.
//

#import "MSSettingsViewController.h"
#import "MSConstants.h"
#import "MSStartViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@implementation MSSettingsViewController
{
    
    CGFloat _widthOfDisplay;
    
    int _numberOfField;
    int _numberOfBombs;
    
    NSString *fieldType;
    
    IBOutletCollection(UILabel) NSArray *bombLabels;
    
    IBOutletCollection(UIImageView) NSArray *fieldImageViews;
    
    IBOutletCollection(UIImageView) NSArray *bombImageViews;
    
    int _selectedFieldNumber;
    int _selectedBombsNumber;
    
}

- (IBAction)tappedFieldSelectBtn:(UIButton *)sender {
    
    //タップしたtagに応じてbombsのラベルを変更
    
    NSLog(@"%d",_numberOfField);
    
    //更新前の_numberOfField
    int bombTemp = 0;
    if(_numberOfField == 5 || _numberOfField == 10 || _numberOfField == 15){
        bombTemp  = (int)(_numberOfBombs / 5);
    }else if(_numberOfField == 9 || _numberOfField == 18 || _numberOfField == 27){
        bombTemp  = (int)(_numberOfBombs / 9);
    }else{
        bombTemp  = (int)(_numberOfBombs / 12);
    }
    
    
    if(sender.tag == 0){ //5x5
        _numberOfField = 5;
        fieldType = MSFieldType5x5;
    }else if(sender.tag == 1){ //9x9
        _numberOfField = 9;
        fieldType = MSFieldType9x9;
    }else{ //12x12
        _numberOfField = 12;
        fieldType = MSFieldType12x12;
    }
    
    _numberOfBombs = bombTemp * _numberOfField;
    
    //FIELD Image Viewの色(画像)変更
    for(UIImageView *im in fieldImageViews){
        
        if(im.tag == sender.tag)
            [im setImage:[UIImage imageNamed:MSImageNameSelectedItem]];
        else
            [im setImage:[UIImage imageNamed:MSImageNameUnselectedItem]];
        
    }
    
    
    for(int i = 0;i<3;i++)
        [bombLabels[i] setText:[NSString stringWithFormat:@"%d",(int)_numberOfField * (i+1)]];
    
}

- (IBAction)tappedBombsSelectBtn:(UIButton *)sender {
    
    _selectedBombsNumber = (int)sender.tag;
    
    if(sender.tag == 0){ //5x5
        _numberOfBombs = _numberOfField * 1;
    }else if(sender.tag == 1){ //9x9
        _numberOfBombs = _numberOfField * 2;
    }else{ //12x12
        _numberOfBombs = _numberOfField * 3;
    }
    
    //bomb Image Viewの色(画像)変更
    for(UIImageView *im in bombImageViews){
        
        if(im.tag == sender.tag)
            [im setImage:[UIImage imageNamed:MSImageNameSelectedItem]];
        else
            [im setImage:[UIImage imageNamed:MSImageNameUnselectedItem]];
        
    }
    
}

- (IBAction)tappedBackBtn:(id)sender {
    
    [self saveSettings];
    [self backToHome];
    
}

-(void)backToHome{
    
    
    [self presentViewController:[MSStartViewController startViewController] animated:YES completion:nil];
    
}

-(void)saveSettings{
    
    //NSUserDefaults
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"settings"]){
        
        [[NSUserDefaults standardUserDefaults] setObject:@{@"fieldType":fieldType,@"numberOfBombs":@(_numberOfBombs)} forKey:@"settings"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    NSMutableDictionary *ud = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] mutableCopy];
    
    if([fieldType isEqualToString:MSFieldType5x5]){
        
        if(_numberOfBombs == 5){
            
            [ud setValue:MSBestScoreTypeField5x5_type1 forKey:@"currentFieldType"];
            
        }else if(_numberOfBombs == 10){
            
            [ud setValue:MSBestScoreTypeField5x5_type2 forKey:@"currentFieldType"];
            
        }else{
            
            [ud setValue:MSBestScoreTypeField5x5_type3 forKey:@"currentFieldType"];
            
        }
        
    }else if([fieldType isEqualToString:MSFieldType9x9]){
        
        if(_numberOfBombs == 9){
            
            [ud setValue:MSBestScoreTypeField9x9_type1 forKey:@"currentFieldType"];
            
        }else if(_numberOfBombs == 18){
            
            [ud setValue:MSBestScoreTypeField9x9_type2 forKey:@"currentFieldType"];
            
        }else{
            
            [ud setValue:MSBestScoreTypeField9x9_type3 forKey:@"currentFieldType"];
            
        }
        
    }else{
        
        if(_numberOfBombs == 12){
            
            [ud setValue:MSBestScoreTypeField12x12_type1 forKey:@"currentFieldType"];
            
        }else if(_numberOfBombs == 24){
            
            [ud setValue:MSBestScoreTypeField12x12_type2 forKey:@"currentFieldType"];
            
        }else{
            
            [ud setValue:MSBestScoreTypeField12x12_type3 forKey:@"currentFieldType"];
            
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:ud forKey:@"bestScore"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+(MSSettingsViewController*)settingsViewController{
    
    return [[UIStoryboard storyboardWithName:@"MSSettings" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}

-(void)awakeFromNib{
    
    NSMutableDictionary *settings = [[NSUserDefaults standardUserDefaults] objectForKey:@"settings"];
    
    fieldType = [settings objectForKey:@"fieldType"];
    _numberOfBombs = [[settings objectForKey:@"numberOfBombs"] intValue];
    
    
}

-(void)setSettings{
    
    //TODO: リファクタリング
    int num = 0;
    int bombNum = 0;
    int bomb = 0;
    if([fieldType isEqualToString:MSFieldType5x5]){
        num = 0;
        bombNum = _numberOfBombs / 5 - 1;
        bomb = _numberOfBombs / (bombNum + 1);
        _numberOfField = 5;
    }else if([fieldType isEqualToString:MSFieldType9x9]){
        num = 1;
        bombNum = _numberOfBombs / 9 - 1;
        bomb = _numberOfBombs / (bombNum + 1);
        _numberOfField = 9;
    }else{
        num = 2;
        bombNum = _numberOfBombs / 12 - 1;
        bomb = _numberOfBombs / (bombNum + 1);
        _numberOfField = 12;
    }
    
    //FIELD Image Viewの色(画像)変更
    for(UIImageView *im in fieldImageViews){
        
        if(im.tag == num)
            [im setImage:[UIImage imageNamed:MSImageNameSelectedItem]];
        else
            [im setImage:[UIImage imageNamed:MSImageNameUnselectedItem]];
        
    }
    
    //bomb Image Viewの色(画像)変更
    for(UIImageView *im in bombImageViews){
        
        if(im.tag == bombNum)
            [im setImage:[UIImage imageNamed:MSImageNameSelectedItem]];
        else
            [im setImage:[UIImage imageNamed:MSImageNameUnselectedItem]];
        
    }
    
    for(int i = 0;i<3;i++)
        [bombLabels[i] setText:[NSString stringWithFormat:@"%d",(int)bomb * (i+1)]];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setSettings];
    
//    _widthOfDisplay = [UIScreen mainScreen].bounds.size.width;
//    self.view.backgroundColor = RGB(245, 245, 245);
//    
//    
//    [self setLabels];
//    
//    [self setButtons];
}

@end
