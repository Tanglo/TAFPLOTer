//
//  DRHMotorUnitData.h
//  TAFPlotter
//
//  Created by Lee Walsh on 9/01/2014.
//  Copyright (c) 2014 Lee Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRHMotorUnitData : NSObject <NSCoding>{
    NSNumber *unitNumber;
    NSNumber *unitSet;
    NSString *unitType;
    NSNumber *onsetTime;
    NSNumber *peakTime;
    NSNumber *endTime;
    NSNumber *inspTime;
    NSNumber *onsetFreq;
    NSNumber *peakFreq;
    NSNumber *endFreq;
    NSNumber *tonicFreq;
    
    NSNumber *normOnsetTime;
    NSNumber *normPeakTime;
    NSNumber *normEndTime;
}
@property NSNumber *unitNumber;
@property NSNumber *unitSet;
@property NSString *unitType;
@property NSNumber *onsetTime;
@property NSNumber *peakTime;
@property NSNumber *endTime;
@property NSNumber *inspTime;
@property NSNumber *onsetFreq;
@property NSNumber *peakFreq;
@property NSNumber *endFreq;
@property NSNumber *tonicFreq;

@property NSNumber *normOnsetTime;
@property NSNumber *normPeakTime;
@property NSNumber *normEndTime;

-(DRHMotorUnitData *)initWith:(NSDictionary *)unitData;
+(DRHMotorUnitData *)unitWith:(NSDictionary *)unitData;
-(DRHMotorUnitData *)initBlank;
+(DRHMotorUnitData *)blankUnit;

@end
