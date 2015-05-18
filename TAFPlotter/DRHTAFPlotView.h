//
//  DRHTAFPlotView.h
//  TAFPlotter
//
//  Created by Lee Walsh on 14/01/2014.
//  Copyright (c) 2014 Lee Walsh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DRHTAFPlotDocument;

@interface DRHTAFPlotView : NSView{
    IBOutlet DRHTAFPlotDocument *document;
    
    BOOL blackBackground;
    BOOL useColour;
    NSInteger freqBands;
    NSMutableArray *freqBandColours;
    NSMutableArray *freqBandValues;
    BOOL showLegend;
    NSNumber *legendSize;
    
    CGFloat margin;
    NSRect legendRect;
    NSRect xAxisRect;
    NSRect plotRect;
    
    CGFloat strokeWidth;
    CGFloat fontSize;
    CGFloat fontHeight;
    CGFloat fontPadding;
    CGFloat legendTextWidth;
    
    CGFloat plotLineWidth;
    CGFloat plotLinePadding;
    CGFloat plotTimePerDrawWidth;
}
@property BOOL blackBackground;
@property BOOL useColour;
@property NSInteger freqBands;
@property BOOL showLegend;
@property NSNumber *legendSize;

-(CGFloat)xDrawPosFromTime:(CGFloat)time;
-(NSColor *)colourForFrequency:(CGFloat)frequency;
-(void)drawLegendWith:(NSColor *)fgColour;

@end
