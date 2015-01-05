//
//  MSStartViewController.m
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//
#import "MSStartViewController.h"
#import "MSConstants.h"
#import "MSSettingsViewController.h"
#import "MSPlayViewController.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@implementation MSStartViewController
{
    CGFloat _widthOfDisplay;
    
    __weak IBOutlet UILabel *scoreLabel;
    
    
}


+(MSStartViewController*)startViewController{
    
    
    return [[UIStoryboard storyboardWithName:@"MSStart" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
    
}

-(id)init{
    
    self = [super init];
    if(!self) return nil;
    
    return self;
}

-(void)start{
    
    NSMutableDictionary *ud =  [[NSUserDefaults standardUserDefaults] objectForKey:@"settings"];
    
    MSPlayViewController *_playViewController = [[MSPlayViewController alloc]initGameWithFieldType:[ud objectForKey:@"fieldType"] amountOfBombs:[[ud objectForKey:@"numberOfBombs"] intValue]];
    
    [self presentViewController:_playViewController animated:YES completion:nil];
    
}

- (IBAction)tappedStartBtn:(id)sender {
    
    [self start];
    
}

- (IBAction)tappedSettingsBtn:(id)sender {
    
    [self presentViewController:[MSSettingsViewController settingsViewController] animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self printScoreLabel];
    
    //NSLog(@"bestscoretype %@",[[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] objectForKey:@"currentFieldType"]);
    
}


-(void)printScoreLabel{
    
    //現在のfieldTypeとnumberOfBombsでscoreLabelを変更
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"];
    
    
    NSString *currentFieldType = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] objectForKey:@"currentFieldType"];
    
//    [scoreLabel setText:[NSString stringWithFormat:@"%.1f",[[[[NSUserDefaults standardUserDefaults] objectForKey:@"bestScore"] objectForKey:currentFieldType] floatValue]]];
    
    [scoreLabel setText:[NSString stringWithFormat:@"%.1f",[[[dict objectForKey:@"bestScore"] objectForKey:currentFieldType] floatValue]]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
