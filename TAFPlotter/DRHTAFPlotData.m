//
//  DRHTAFPlotData.m
//  TAFPlotter
//
//  Created by Lee Walsh on 9/01/2014.
//  Copyright (c) 2014 Lee Walsh. All rights reserved.
//

#import "DRHTAFPlotData.h"
#import "DRHMotorUnitData.h"
#import "DRHTAFPlotDocument.h"

@implementation DRHTAFPlotData

@synthesize document;
@synthesize minFreq,maxFreq,xAxisMin,xAxisMax;

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        dataArray = [NSMutableArray array];
        normalisedDataArray = [NSMutableArray array];
        
        minFreq = [NSNumber numberWithDouble:0.0];
        maxFreq = [NSNumber numberWithDouble:1000.0];
        xAxisMin = [NSNumber numberWithDouble:-1.0];
        xAxisMax = [NSNumber numberWithDouble:2.0];;
    }
    return self;
}

#pragma mark Getters
-(NSInteger)count{
    return [dataArray count];
}

-(NSArray *)dataArray{
    return dataArray;
}

-(void)decodeDataFromCSV:(NSString *)dataString{
//    NSLog(@"Decoding data from CSV string");
    //    NSLog(@".csv string:\n%@",dataString);
    BOOL fileFormatOK = YES;
    NSScanner *dataStringScanner = [NSScanner scannerWithString:dataString];
    [dataStringScanner scanUpToString:@"\r" intoString:NULL];       //exclude first line
    while (![dataStringScanner isAtEnd]) {
        NSMutableDictionary *unitData = [NSMutableDictionary dictionary];
        NSInteger newInteger;
        NSString *newString;
        CGFloat newDouble;
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanInteger:&newInteger])                 //scan it
                [unitData setObject:[NSNumber numberWithInteger:newInteger] forKey:@"unitNumber"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanInteger:&newInteger])                 //scan it
                [unitData setObject:[NSNumber numberWithInteger:newInteger] forKey:@"unitSet"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanUpToString:@"," intoString:&newString])             //scan it
                [unitData setObject:newString forKey:@"unitType"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanDouble:&newDouble])                 //scan it
                [unitData setObject:[NSNumber numberWithDouble:newDouble] forKey:@"onsetTime"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanDouble:&newDouble])                 //scan it
                [unitData setObject:[NSNumber numberWithDouble:newDouble] forKey:@"peakTime"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanDouble:&newDouble])                 //scan it
                [unitData setObject:[NSNumber numberWithDouble:newDouble] forKey:@"endTime"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanDouble:&newDouble])                 //scan it
                [unitData setObject:[NSNumber numberWithDouble:newDouble] forKey:@"inspTime"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanDouble:&newDouble])                 //scan it
                [unitData setObject:[NSNumber numberWithDouble:newDouble] forKey:@"onsetFreq"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanDouble:&newDouble])                 //scan it
                [unitData setObject:[NSNumber numberWithDouble:newDouble] forKey:@"peakFreq"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanDouble:&newDouble])                 //scan it
                [unitData setObject:[NSNumber numberWithDouble:newDouble] forKey:@"endFreq"];
            if (![dataStringScanner scanString:@"," intoString:NULL]) {          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }
        }
        
        if (![dataStringScanner scanString:@"," intoString:NULL]) {             //if a value is present
            if ([dataStringScanner scanDouble:&newDouble])                 //scan it
                [unitData setObject:[NSNumber numberWithDouble:newDouble] forKey:@"tonicFreq"];
/*            if (![dataStringScanner scanString:@"\r" intoString:NULL]){          //check that a comma follows
                fileFormatOK = NO;                                              //if not, formatting error
                break;
            }*/
        }
        
//        NSLog(@"Unit data: %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@",[unitData objectForKey:@"unitNumber"],[unitData objectForKey:@"unitSet"],[unitData objectForKey:@"unitType"],[unitData objectForKey:@"onsetTime"],[unitData objectForKey:@"peakTime"],[unitData objectForKey:@"endTime"],[unitData objectForKey:@"inspTime"],[unitData objectForKey:@"onsetFreq"],[unitData objectForKey:@"peakFreq"],[unitData objectForKey:@"endFreq"],[unitData objectForKey:@"tonicFreq"]);
        [dataArray addObject:[DRHMotorUnitData unitWith:unitData]];
        //NSLog(@"NUmber of motor units: %ld",[dataArray count]);
    }
    [self sortMotorUnits];
}

-(void)sortMotorUnits{
    NSSortDescriptor *normOnsetTimeDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"normOnsetTime" ascending:YES];
    NSArray *sortDescriptors = @[normOnsetTimeDescriptor];
    [dataArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *inspPhasic = [NSMutableArray array];
    NSMutableArray *inspTonic = [NSMutableArray array];
    NSMutableArray *expPhasic = [NSMutableArray array];
    NSMutableArray *expTonic = [NSMutableArray array];
    NSMutableArray *tonic = [NSMutableArray array];
    
    for (DRHMotorUnitData *currentUnit in dataArray) {
        if ([[[currentUnit unitType] lowercaseString] isEqualToString:@"inspiratory phasic"]) {
            [inspPhasic addObject:currentUnit];
        } else if ([[[currentUnit unitType] lowercaseString] isEqualToString:@"inspiratory tonic"]) {
            [inspTonic addObject:currentUnit];
        } else if ([[[currentUnit unitType] lowercaseString] isEqualToString:@"expiratory phasic"]) {
            [expPhasic addObject:currentUnit];
        } else if ([[[currentUnit unitType] lowercaseString] isEqualToString:@"expiratory tonic"]) {
            [expTonic addObject:currentUnit];
        } else if ([[[currentUnit unitType] lowercaseString] isEqualToString:@"tonic"]) {
            [tonic addObject:currentUnit];
        }
    }
//    NSLog(@"Count: %ld, total: %ld",[dataArray count],[inspPhasic count]+[inspTonic count]+[expPhasic count]+[expTonic count]+[tonic count]);
    [dataArray removeAllObjects];
    if ([tonic count]>0) {
        [dataArray addObjectsFromArray:tonic];
        [dataArray addObject:[DRHMotorUnitData blankUnit]];
    }
    if ([expTonic count]>0) {
        [dataArray addObjectsFromArray:expTonic];
        [dataArray addObject:[DRHMotorUnitData blankUnit]];
    }
    if ([expPhasic count]>0) {
        [dataArray addObjectsFromArray:expPhasic];
        [dataArray addObject:[DRHMotorUnitData blankUnit]];
    }
    if ([inspTonic count]>0) {
        [dataArray addObjectsFromArray:inspTonic];
        [dataArray addObject:[DRHMotorUnitData blankUnit]];
    }
    if ([inspPhasic count]>0) {
        [dataArray addObjectsFromArray:inspPhasic];
        [dataArray addObject:[DRHMotorUnitData blankUnit]];
    }
}

-(void)calculateParameters{
    NSNumber *lowestFreq = [NSNumber numberWithDouble:1000.0];
    NSNumber *highestFreq = [NSNumber numberWithDouble:0.0];
    NSNumber *firstUnitStartTime = [NSNumber numberWithDouble:1000.0];
    NSNumber *lastUnitEndTime = [NSNumber numberWithDouble:0.0];
    for (DRHMotorUnitData *currentUnit in dataArray) {
        if ([[currentUnit onsetFreq] isLessThan:lowestFreq]) {
            lowestFreq = [currentUnit onsetFreq];
        }
        if ([[currentUnit peakFreq] isLessThan:lowestFreq]) {
            lowestFreq = [currentUnit peakFreq];
        }
        if ([[currentUnit endFreq] isLessThan:lowestFreq]) {
            lowestFreq = [currentUnit endFreq];
        }
        if ([[currentUnit tonicFreq] isLessThan:lowestFreq]) {
            lowestFreq = [currentUnit tonicFreq];
        }
        
        if ([[currentUnit onsetFreq] isGreaterThan:highestFreq]) {
            highestFreq = [currentUnit onsetFreq];
        }
        if ([[currentUnit peakFreq] isGreaterThan:highestFreq]) {
            highestFreq = [currentUnit peakFreq];
        }
        if ([[currentUnit endFreq] isGreaterThan:highestFreq]) {
            highestFreq = [currentUnit endFreq];
        }
        if ([[currentUnit tonicFreq] isGreaterThan:highestFreq]) {
            highestFreq = [currentUnit tonicFreq];
        }
        
        if ([[currentUnit normOnsetTime] isLessThan:firstUnitStartTime]) {
            firstUnitStartTime = [currentUnit normOnsetTime];
        }
        if ([[currentUnit normEndTime] isGreaterThan:lastUnitEndTime]) {
            lastUnitEndTime = [currentUnit normEndTime];
        }
    }
    [self willChangeValueForKey:@"minFreq"];
    [self willChangeValueForKey:@"maxFreq"];
    [self willChangeValueForKey:@"xAxisMin"];
    [self willChangeValueForKey:@"xAxisMax"];
    minFreq = lowestFreq;
    maxFreq = highestFreq;
    xAxisMin = firstUnitStartTime;
    xAxisMax = lastUnitEndTime;
    [self didChangeValueForKey:@"minFreq"];
    [self didChangeValueForKey:@"maxFreq"];
    [self didChangeValueForKey:@"xAxisMin"];
    [self didChangeValueForKey:@"xAxisMax"];
}


#pragma NSCoding
-(id)initWithCoder:(NSCoder *)coder{
    self = [super init];
    dataArray = [coder decodeObjectForKey:@"dataArray"];
    normalisedDataArray = [coder decodeObjectForKey:@"normalisedDataArray"];
    minFreq = [coder decodeObjectForKey:@"minFreq"];
    maxFreq = [coder decodeObjectForKey:@"maxFreq"];
    xAxisMin = [coder decodeObjectForKey:@"xAxisMin"];
    xAxisMax = [coder decodeObjectForKey:@"xAxisMax"];
    return self;
}

-(void)encodeWithCoder:(NSCoder *)coder{
    [coder encodeObject:dataArray forKey:@"dataArray"];
    [coder encodeObject:normalisedDataArray forKey:@"normalisedDataArray"];
    [coder encodeObject:minFreq forKey:@"minFreq"];
    [coder encodeObject:maxFreq forKey:@"maxFreq"];
    [coder encodeObject:xAxisMin forKey:@"xAxisMin"];
    [coder encodeObject:xAxisMax forKey:@"xAxisMax"];
}

@end
