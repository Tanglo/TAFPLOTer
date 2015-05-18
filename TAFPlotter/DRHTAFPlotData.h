//
//  DRHTAFPlotData.h
//  TAFPlotter
//
//  Created by Lee Walsh on 9/01/2014.
//  Copyright (c) 2014 Lee Walsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DRHTAFPlotDocument;

@interface DRHTAFPlotData : NSObject <NSCoding>{
    DRHTAFPlotDocument *document;
    NSMutableArray *dataArray;
    NSMutableArray *normalisedDataArray;
    
    NSNumber *minFreq;
    NSNumber *maxFreq;
    NSNumber *xAxisMin;
    NSNumber *xAxisMax;
}
@property DRHTAFPlotDocument *document;
@property NSNumber *minFreq;
@property NSNumber *maxFreq;
@property NSNumber *xAxisMin;
@property NSNumber *xAxisMax;

-(NSInteger)count;
-(NSArray *)dataArray;

-(void)decodeDataFromCSV:(NSString *)dataString;
-(void)sortMotorUnits;
-(void)calculateParameters;
//-(void)normaliseData;

@end
