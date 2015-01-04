//
//  MSMassManager.m
//  MineSweeper
//
//  Created by SatoDaisuke on 12/31/14.
//  Copyright (c) 2014 SatoDaisuke. All rights reserved.
//

#import "MSMassManager.h"
#import "MSMass.h"

@interface MSMassManager()
@property(nonatomic,readwrite)NSMutableArray *masses;
@end

@implementation MSMassManager

static MSMassManager *_sharedInstacne = nil;

+(MSMassManager*)sharedManager{
    
    if(!_sharedInstacne){
        _sharedInstacne = MSMassManager.new;
    }
    
    return _sharedInstacne;
}

-(id)init{
    
    self = [super init];
    if(!self) return nil;
    
    self.masses = @[].mutableCopy;
    
    
    return self;
}


//-(CGPoint)getPointWithMass:(MSMass*)mass{
//    
//    
//    
//    
//    return p;
//}

-(void)addMass:(MSMass*)mass{
    
    if(!mass) return;
    
    [self.masses addObject:mass];
}


-(void)resetMasses{
    
    self.masses = nil;
    self.masses = @[].mutableCopy;
}

@end
