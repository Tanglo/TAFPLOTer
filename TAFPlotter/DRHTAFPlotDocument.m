//
//  DRHDocument.m
//  TAFPlotter
//
//  Created by Lee Walsh on 9/01/2014.
//  Copyright (c) 2014 Lee Walsh. All rights reserved.
//

#import "DRHTAFPlotDocument.h"
#import "DRHTAFPlotData.h"
#import "DRHMotorUnitData.h"
#import "DRHTAFPlotView.h"

@implementation DRHTAFPlotDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        TAFPlotData = [[DRHTAFPlotData alloc]init];
        [TAFPlotData setDocument:self];
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"DRHTAFPlotDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [self addObserver:self forKeyPath:@"TAFPlotView.blackBackground" options:0 context:nil];
    [self addObserver:self forKeyPath:@"TAFPlotData.minFreq" options:0 context:nil];
    [self addObserver:self forKeyPath:@"TAFPlotData.maxFreq" options:0 context:nil];
    [self addObserver:self forKeyPath:@"TAFPlotData.xAxisMin" options:0 context:nil];
    [self addObserver:self forKeyPath:@"TAFPlotData.xAxisMax" options:0 context:nil];
    [self addObserver:self forKeyPath:@"TAFPlotView.useColour" options:0 context:nil];
    [self addObserver:self forKeyPath:@"TAFPlotView.freqBands" options:0 context:nil];
    [self addObserver:self forKeyPath:@"TAFPlotView.showLegend" options:0 context:nil];
    [self addObserver:self forKeyPath:@"TAFPlotView.legendSize" options:0 context:nil];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    return nil;
    
    return [NSKeyedArchiver archivedDataWithRootObject:TAFPlotData];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
//    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
//    @throw exception;
//    return YES;
    
    DRHTAFPlotData *newData;
    @try {
       newData = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        if (outError) {
            NSDictionary *d = [NSDictionary dictionaryWithObject:@"The data is corrupted" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:d];
        }
        return NO;
    }
    TAFPlotData = newData;
    return YES;
}

#pragma mark NSTableDataSource methods
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [[TAFPlotData dataArray] count];
}

-(id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Unit"]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] unitNumber];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Set"]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] unitSet];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Type"]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] unitType];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Onset time"]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] onsetTime];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Peak time"]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] peakTime];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"End time"]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] endTime];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Insp. time"]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] inspTime];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Onset freq."]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] onsetFreq];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Peak freq."]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] peakFreq];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"End freq."]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] endFreq];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Tonic freq."]) {
        return [[[TAFPlotData dataArray] objectAtIndex:row] tonicFreq];
    }
    return @"-";
}

-(void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Unit"]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setUnitNumber:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Set"]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setUnitSet:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Type"]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setUnitType:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Onset time"]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setOnsetTime:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Peak time"]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setPeakTime:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"End time"]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setEndTime:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Insp. time"]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setInspTime:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Onset freq."]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setOnsetFreq:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Peak freq."]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setPeakFreq:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"End freq."]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setEndFreq:object];
    } else if ([[[tableColumn headerCell]stringValue]isEqualToString:@"Tonic freq."]) {
        [[[TAFPlotData dataArray] objectAtIndex:row] setTonicFreq:object];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    //NSLog(@"A key value has changed.");
    [TAFPlotView setNeedsDisplay:YES];
}

-(DRHTAFPlotData *)TAFPlotData{
    return TAFPlotData;
}

-(DRHTAFPlotView *)TAFPlotView{
    return TAFPlotView;
}

-(NSTableView *)dataTable{
    return dataTable;
}

-(IBAction)importData:(id)sender{
//    NSLog(@"Importing data");
    BOOL okToImport = YES;
    if ([TAFPlotData count] > 0) {
        NSAlert *overwriteAlert = [NSAlert alertWithMessageText:@"Overwrite exisiting data?" defaultButton:@"No" alternateButton:@"Yes" otherButton:nil informativeTextWithFormat:@"Selecting Yes will override the exisiting TAFPlot with the imported data"];
        if ([overwriteAlert runModal] == NSAlertDefaultReturn)
            okToImport = NO;
    }
    if (okToImport)
        [self importCSVfile];
}

-(void)importCSVfile{
//    NSLog(@"Importing .csv file");
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    NSArray* fileTypes = [NSArray arrayWithObject:[NSString stringWithFormat:@"csv"]];
    [panel setAllowedFileTypes:fileTypes];
    [panel beginWithCompletionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            NSStringEncoding fileEncoding;
            NSError *theError;
            NSString *csvData = [NSString stringWithContentsOfURL:[panel URL] usedEncoding:&fileEncoding error:&theError];
            if (csvData != nil) {
//                NSLog(@"Decode data");
                [TAFPlotData decodeDataFromCSV:csvData];
                [TAFPlotData calculateParameters];
                //[TAFPlotData normaliseData];
                [dataTable reloadData];
                [TAFPlotView setNeedsDisplay:YES];
                
            } else {
                NSAlert *errorAlert = [NSAlert alertWithError:theError];
                [errorAlert runModal];
            }
        }
    }];
}

@end
