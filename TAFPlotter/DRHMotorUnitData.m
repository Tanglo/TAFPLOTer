//
//  DRHMotorUnitData.m
//  TAFPlotter
//
//  Created by Lee Walsh on 9/01/2014.
//  Copyright (c) 2014 Lee Walsh. All rights reserved.
//

#import "DRHMotorUnitData.h"

@implementation DRHMotorUnitData

@synthesize unitNumber,unitSet,unitType,onsetTime,peakTime,endTime,inspTime,onsetFreq,peakFreq,endFreq,tonicFreq;
@synthesize normOnsetTime,normPeakTime,normEndTime;

-(DRHMotorUnitData *)initWith:(NSDictionary *)unitData{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        unitNumber = [unitData objectForKey:@"unitNumber"];
        unitSet = [unitData objectForKey:@"unitSet"];
        unitType = [unitData objectForKey:@"unitType"];
        onsetTime = [unitData objectForKey:@"onsetTime"];
        peakTime = [unitData objectForKey:@"peakTime"];
        endTime = [unitData objectForKey:@"endTime"];
        inspTime = [unitData objectForKey:@"inspTime"];
        onsetFreq = [unitData objectForKey:@"onsetFreq"];
        peakFreq = [unitData objectForKey:@"peakFreq"];
        endFreq = [unitData objectForKey:@"endFreq"];
        tonicFreq = [unitData objectForKey:@"tonicFreq"];
        
        normOnsetTime = [NSNumber numberWithDouble:[onsetTime doubleValue] / [inspTime doubleValue]];
        normPeakTime = [NSNumber numberWithDouble:[peakTime doubleValue] / [inspTime doubleValue]];
        normEndTime = [NSNumber numberWithDouble:[endTime doubleValue] / [inspTime doubleValue]];
        
        if (inspTime == nil) {
            unitType = @"";
            tonicFreq = nil;
        }
        if ([tonicFreq doubleValue] == 0.0)
             tonicFreq = nil;
    }
    return self;
}

+(DRHMotorUnitData *)unitWith:(NSDictionary *)unitData{
    return [[self alloc]initWith:unitData];
}

-(DRHMotorUnitData *)initBlank{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        unitNumber = nil;
        unitSet = nil;
        unitType = @"";
        onsetTime = nil;
        peakTime = nil;
        endTime = nil;
        inspTime = nil;
        onsetFreq = nil;
        peakFreq = nil;
        endFreq = nil;
        tonicFreq = nil;
        
        normOnsetTime = nil;
        normPeakTime = nil;
        normEndTime = nil;
    }
    return self;
}

+(DRHMotorUnitData *)blankUnit{
    return [[self alloc]initBlank];
}


#pragma NSCoding
-(id)initWithCoder:(NSCoder *)coder{
    self = [super init];
    unitNumber = [coder decodeObjectForKey:@"unitNumber"];
    unitSet = [coder decodeObjectForKey:@"unitSet"];
    unitType = [coder decodeObjectForKey:@"unitType"];
    onsetTime  = [coder decodeObjectForKey:@"onsetTime"];
    peakTime  = [coder decodeObjectForKey:@"peakTime"];
    endTime   = [coder decodeObjectForKey:@"endTime"];
    inspTime  = [coder decodeObjectForKey:@"inspTime"];
    onsetFreq  = [coder decodeObjectForKey:@"onsetFreq"];
    peakFreq  = [coder decodeObjectForKey:@"peakFreq"];
    endFreq   = [coder decodeObjectForKey:@"endFreq"];
    tonicFreq  = [coder decodeObjectForKey:@"tonicFreq"];
    
    normOnsetTime = [coder decodeObjectForKey:@"normOnsetTime"];
    normPeakTime = [coder decodeObjectForKey:@"normPeakTime"];
    normEndTime = [coder decodeObjectForKey:@"normEndTime"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:unitNumber forKey:@"unitNumber"];
    [coder encodeObject:unitSet forKey:@"unitSet"];
    [coder encodeObject:unitType forKey:@"unitType"];
    [coder encodeObject:onsetTime forKey:@"onsetTime"];
    [coder encodeObject:peakTime forKey:@"peakTime"];
    [coder encodeObject:endTime forKey:@"endTime"];
    [coder encodeObject:inspTime forKey:@"inspTime"];
    [coder encodeObject:onsetFreq forKey:@"onsetFreq"];
    [coder encodeObject:peakFreq forKey:@"peakFreq"];
    [coder encodeObject:endFreq forKey:@"endFreq"];
    [coder encodeObject:tonicFreq forKey:@"tonicFreq"];
    
    [coder encodeObject:normOnsetTime forKey:@"normOnsetTime"];
    [coder encodeObject:normPeakTime forKey:@"normPeakTime"];
    [coder encodeObject:normEndTime forKey:@"normEndTime"];
}
@end
