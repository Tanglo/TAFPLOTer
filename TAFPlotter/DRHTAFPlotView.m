//
//  DRHTAFPlotView.m
//  TAFPlotter
//
//  Created by Lee Walsh on 14/01/2014.
//  Copyright (c) 2014 Lee Walsh. All rights reserved.
//

#import "DRHTAFPlotView.h"
#import "DRHMotorUnitData.h"
#import "DRHTAFPlotDocument.h"
#import "DRHTAFPlotData.h"

@implementation DRHTAFPlotView

@synthesize blackBackground,useColour,freqBands,showLegend,legendSize;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        blackBackground = YES;
        useColour = YES;
        freqBands = 5;
        freqBandColours = [NSMutableArray array];
        freqBandValues = [NSMutableArray array];
        showLegend = YES;
        legendSize = [NSNumber numberWithDouble:1.0];
        
        margin = 50.0;
        legendRect = NSMakeRect(0, 0, 0, 0);
        //xAxisRect;
        //plotRect;
        
        strokeWidth = 3.0;
        fontSize = 25.0;
        //NSString *A = @"A";
        NSDictionary *attr = [NSDictionary dictionaryWithObject:[NSFont fontWithName:@"Arial" size:fontSize] forKey:NSFontAttributeName];
        fontHeight = [@"A" sizeWithAttributes:attr].height;
        fontPadding = 5;
        legendTextWidth = [@"100.0 - 100.0 Hz" sizeWithAttributes:attr].width;
        
        plotLineWidth = 10.0;
        plotLinePadding = 5.0;
        plotTimePerDrawWidth = 1.0;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
    //Calculate instance variables
    xAxisRect = NSMakeRect(margin, margin + 2*fontHeight + 2*fontPadding, [self frame].size.width - 2*margin, -1);
    plotRect.origin.x = margin;
    plotRect.origin.y = xAxisRect.origin.y;         //plus some padding?
    plotRect.size.width = 700;
    plotRect.size.height = [[[document TAFPlotData]dataArray] count] * (plotLineWidth + plotLinePadding);
    plotTimePerDrawWidth = ([[[document TAFPlotData]xAxisMax]doubleValue] - [[[document TAFPlotData]xAxisMin]doubleValue]) / xAxisRect.size.width;
    CGFloat freqBandwidth = ([[[document TAFPlotData] maxFreq] doubleValue] - [[[document TAFPlotData] minFreq]doubleValue]) / (freqBands);
    CGFloat colourBandwidth = (300.0/360.0) / (freqBands-1);
    [freqBandValues removeAllObjects];
    [freqBandColours removeAllObjects];
    for (NSInteger i=0 ; i<freqBands ; i++) {
        [freqBandValues addObject:[NSNumber numberWithDouble:i*freqBandwidth + [[[document TAFPlotData] minFreq]doubleValue]]];
        [freqBandColours addObject:[NSColor colorWithCalibratedHue:i*colourBandwidth saturation:1.0 brightness:1.0 alpha:1.0]];
//        NSLog(@"Colour hue in deg.: %lf",i*colourBandwidth*360);
    }
    [freqBandValues addObject:[NSNumber numberWithDouble:freqBands * freqBandwidth]];
//    NSLog(@"Num. freq. Values: %ld",[freqBandValues count]);
//    NSLog(@"Num. freq. colours: %ld",[freqBandColours count]);
    
    //Determine frame size
    NSRect frame = NSMakeRect(0.0, 0.0, plotRect.size.width, plotRect.size.height);
//    frame.size.height = 0;
//    frame.size.height += [[[document TAFPlotData]dataArray] count] * (plotLineWidth + plotLinePadding);
    frame.size.height += 2*margin;
    frame.size.height += 2*fontHeight +2*fontPadding;
    frame.size.width += 2*margin;
    [self setFrame:frame];
    
    //Draw background
    NSColor *bgColour,*fgColour;
    if (blackBackground){
        bgColour = [NSColor blackColor];
        fgColour = [NSColor whiteColor];
    } else {
        bgColour = [NSColor whiteColor];
        fgColour = [NSColor blackColor];
    }
    [bgColour setFill];
    NSBezierPath *background = [NSBezierPath bezierPathWithRect:[self frame]];
    [background fill];
    
    //Draw x-axis
    NSBezierPath *xAxisPath = [NSBezierPath bezierPath];
    [xAxisPath setLineWidth:strokeWidth];
    [xAxisPath moveToPoint:xAxisRect.origin];
    [xAxisPath lineToPoint:NSMakePoint(xAxisRect.origin.x + xAxisRect.size.width, xAxisRect.origin.y)];
    [fgColour setStroke];
    [xAxisPath stroke];
    NSPoint xAxisInspStartPoint = NSMakePoint([self xDrawPosFromTime:0.0], xAxisRect.origin.y);
    NSPoint xAxisInspEndPoint = NSMakePoint([self xDrawPosFromTime:1.0], xAxisRect.origin.y);
    NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Arial" size:fontSize],NSFontAttributeName,fgColour,NSForegroundColorAttributeName,nil];
    [@"0%" drawAtPoint:NSMakePoint(xAxisInspStartPoint.x-[@"0%" sizeWithAttributes:attr].width/2.0, xAxisInspStartPoint.y-fontHeight - fontPadding) withAttributes:attr];
    [@"100%" drawAtPoint:NSMakePoint(xAxisInspEndPoint.x-[@"100%" sizeWithAttributes:attr].width/2.0, xAxisInspEndPoint.y-fontHeight - fontPadding) withAttributes:attr];
    
    [@"Inspiratory time" drawAtPoint:NSMakePoint(xAxisRect.origin.x + xAxisRect.size.width/2.0 - [@"Inspiratory time" sizeWithAttributes:attr].width/2.0,xAxisRect.origin.y - 2*fontHeight - 2*fontPadding) withAttributes:attr];
    
    
    //Draw data
//    CGFloat inspWidth = xAxisInspEndPoint.x - xAxisInspStartPoint.x;
    CGFloat currentYPos = xAxisInspStartPoint.y + plotLineWidth + plotLinePadding;
    for (DRHMotorUnitData *currentUnit in [[document TAFPlotData] dataArray]) {
        if ([currentUnit tonicFreq]) {
            NSBezierPath *tonicLine = [NSBezierPath bezierPath];
            [tonicLine setLineWidth:plotLineWidth/4.0];
            [tonicLine moveToPoint:NSMakePoint(xAxisRect.origin.x, currentYPos)];
            [tonicLine lineToPoint:NSMakePoint(xAxisRect.origin.x+xAxisRect.size.width, currentYPos)];
            if (useColour)
                [[self colourForFrequency:[[currentUnit tonicFreq]doubleValue]] setStroke];
            else
                [fgColour setStroke];
            [tonicLine stroke];
        }
        if (![[currentUnit unitType] isEqualToString:@""]) {
//            NSLog(@"Drawing %@ unit: %ld",[currentUnit unitType],[[[document TAFPlotData] dataArray] indexOfObject:currentUnit]);
            NSBezierPath *mainTAFLine = [NSBezierPath bezierPath];
            [mainTAFLine setLineWidth:plotLineWidth];
            NSPoint currentStartPoint = NSMakePoint([self xDrawPosFromTime:[[currentUnit normOnsetTime]doubleValue]], currentYPos);
            NSPoint currentEndPoint = NSMakePoint([self xDrawPosFromTime:[[currentUnit normEndTime]doubleValue]], currentYPos);
            [mainTAFLine moveToPoint:currentStartPoint];
            [mainTAFLine lineToPoint:currentEndPoint];
            if (useColour)
                [[self colourForFrequency:[[currentUnit peakFreq]doubleValue]] setStroke];
            else
                [fgColour setStroke];
            [mainTAFLine stroke];
            
            if (![[[currentUnit unitType] lowercaseString] isEqualToString:@"tonic"]) {
                NSBezierPath *onsetDot = [NSBezierPath bezierPath];
                [onsetDot setLineCapStyle:NSRoundLineCapStyle];
                [onsetDot setLineWidth:plotLineWidth];
                [onsetDot moveToPoint:currentStartPoint];
                [onsetDot lineToPoint:currentStartPoint];
                if (useColour)
                    [[self colourForFrequency:[[currentUnit onsetFreq]doubleValue]] setStroke];
                else
                    [fgColour setStroke];
                [onsetDot stroke];
                
                NSBezierPath *endDot = [NSBezierPath bezierPath];
                [endDot setLineCapStyle:NSRoundLineCapStyle];
                [endDot setLineWidth:plotLineWidth];
                [endDot moveToPoint:currentEndPoint];
                [endDot lineToPoint:currentEndPoint];
                if (useColour)
                    [[self colourForFrequency:[[currentUnit endFreq]doubleValue]] setStroke];
                else
                    [fgColour setStroke];
                [endDot stroke];
            
                NSBezierPath *peakColouredDot = [NSBezierPath bezierPath];
                [peakColouredDot setLineCapStyle:NSRoundLineCapStyle];
                [peakColouredDot setLineWidth:plotLineWidth*2];
                [peakColouredDot moveToPoint:NSMakePoint([self xDrawPosFromTime:[[currentUnit normPeakTime]doubleValue]], currentYPos)];
                [peakColouredDot lineToPoint:NSMakePoint([self xDrawPosFromTime:[[currentUnit normPeakTime]doubleValue]], currentYPos)];
                if (useColour)
                    [[self colourForFrequency:[[currentUnit peakFreq]doubleValue]] setStroke];
                else
                    [fgColour setStroke];
                [peakColouredDot stroke];
                NSBezierPath *peakBlackDot = [NSBezierPath bezierPath];
                [peakBlackDot setLineCapStyle:NSRoundLineCapStyle];
                [peakBlackDot setLineWidth:plotLineWidth*1.5];
                [peakBlackDot moveToPoint:NSMakePoint([self xDrawPosFromTime:[[currentUnit normPeakTime]doubleValue]], currentYPos)];
                [peakBlackDot lineToPoint:NSMakePoint([self xDrawPosFromTime:[[currentUnit normPeakTime]doubleValue]], currentYPos)];
                [[NSColor blackColor] set];
                [peakBlackDot stroke];
            }
        }
        currentYPos += plotLineWidth + plotLinePadding;
    }
    
    
    //Draw inspiratory time lines
    NSBezierPath *inspLinesPath = [NSBezierPath bezierPath];
    [inspLinesPath setLineWidth:strokeWidth];
    CGFloat dashArray[2];
    dashArray[0] = 10.0;
    dashArray[1] = 7.5;
    [inspLinesPath setLineDash:dashArray count:2 phase:0.0];
    [inspLinesPath moveToPoint:xAxisInspStartPoint];
    [inspLinesPath lineToPoint:NSMakePoint(xAxisInspStartPoint.x, xAxisInspStartPoint.y+plotRect.size.height)];
    [inspLinesPath moveToPoint:xAxisInspEndPoint];
    [inspLinesPath lineToPoint:NSMakePoint(xAxisInspEndPoint.x, xAxisInspEndPoint.y+plotRect.size.height)];
    [fgColour setStroke];
    [inspLinesPath stroke];
    
    
    //Draw legend
    if (showLegend) {
        [self drawLegendWith:fgColour];
    }
    
}

-(CGFloat)xDrawPosFromTime:(CGFloat)time{
    return (time - [[[document TAFPlotData] xAxisMin]doubleValue]) / plotTimePerDrawWidth + xAxisRect.origin.x;
}

-(NSColor *)colourForFrequency:(CGFloat)frequency{
    for (NSInteger i=0; i<freqBands ; i++) {
        if ([[freqBandValues objectAtIndex:i] doubleValue] <= frequency && [[freqBandValues objectAtIndex:i+1]doubleValue] > frequency)
            return [freqBandColours objectAtIndex:i];
    }
    return nil;
}

-(void)drawLegendWith:(NSColor *)fgColour{
    CGFloat legendWidth = (legendTextWidth + fontPadding + fontHeight) * [legendSize doubleValue];
    CGFloat legendHeight = (fontHeight+fontPadding) * freqBands * [legendSize doubleValue];
    legendRect = NSMakeRect(plotRect.origin.x + plotRect.size.width - legendWidth, plotRect.origin.y + plotRect.size.height-legendHeight, legendWidth, legendHeight);
//    NSBezierPath *legendPath = [NSBezierPath bezierPathWithRect:legendRect];
//    [[NSColor whiteColor] setFill];
//    [legendPath fill];
    CGFloat legendFontHeight = fontHeight*[legendSize doubleValue];
    CGFloat legendPadding = fontPadding*[legendSize doubleValue];
    CGFloat currentYPos = legendRect.origin.y + legendFontHeight/2 + legendPadding;
    CGFloat boxXPos = legendRect.origin.x+legendPadding;
    CGFloat textXPos = boxXPos + legendFontHeight + 2*legendPadding;
    for (NSInteger i=0 ; i<freqBands ; i++) {
        NSBezierPath *currentBox = [NSBezierPath bezierPathWithRect:NSMakeRect(boxXPos, currentYPos-legendFontHeight/2, legendFontHeight, legendFontHeight)];
        [[freqBandColours objectAtIndex:i] setFill];
        [currentBox fill];
        
        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Arial" size:fontSize*[legendSize doubleValue]],NSFontAttributeName,fgColour,NSForegroundColorAttributeName,nil];
        NSString *currentText = [NSString stringWithFormat:@"%.1lf - %.1lf Hz",[[freqBandValues objectAtIndex:i]doubleValue],[[freqBandValues objectAtIndex:i+1]doubleValue]];
        [currentText drawAtPoint:NSMakePoint(textXPos, currentYPos-legendFontHeight/2) withAttributes:attr];
        
        currentYPos += legendPadding + legendFontHeight;
    }
}


@end
