//
//  DRHDocument.h
//  TAFPlotter
//
//  Created by Lee Walsh on 9/01/2014.
//  Copyright (c) 2014 Lee Walsh. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DRHTAFPlotData;
@class DRHTAFPlotView;

@interface DRHTAFPlotDocument : NSDocument <NSTableViewDataSource> {
    DRHTAFPlotData *TAFPlotData;
    IBOutlet DRHTAFPlotView *TAFPlotView;
    
    IBOutlet NSTableView *dataTable;
}
-(DRHTAFPlotData *)TAFPlotData;
-(DRHTAFPlotData *)TAFPlotView;
-(NSTableView *)dataTable;

-(IBAction)importData:(id)sender;
-(void)importCSVfile;

@end
