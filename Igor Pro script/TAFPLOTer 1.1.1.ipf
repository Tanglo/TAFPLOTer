////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Author Details:
//	Lee D Walsh
//	Prince of Wales Medical Research Institute
//	Cnr Barker St and Easy St
//	Randwick, NSW 2031
//	Sydney, Australia
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Version 1.1
//	- added variable x-axis functionality
//	- added variable y-axis (scaling) functionality
//	- corrected bug where extract ledgend appears
// 	- now sorting occurs after normalisation of data to stop the sort being spoiled by normalisation

//Version 1.1.1
//	- corrected bug in colouring
//	- corrected bug in colouring of end freqency dots

#pragma rtGlobals=1		// Use modern global access method.
#pragma version=1.1.1		//software version
#pragma IgorVersion=5.0	// written for Igor 5 or above

//Function: 		BlankTemplate
//Purpose:		Is run when the "Create Blank Template" button is pushed.  It collects the user input required to run "CreateBlankTEmplate" and then runs it appropriately.
//Parameters:	ctrlName - Not used (required by button functions)
//Returns:		1 if sucessful, else 0
Function BlankTemplate(ctrlName) : ButtonControl
	String ctrlName
	
	Variable newDataBool
	String folderName,newFolderName,newData, folderList
	setDataFolder root:
	folderList = DataFolderDir(1)								//get listing of data folders in root:
	folderList = ReplaceString("FOLDERS:",folderList,"")			//removed heading "FOLDERS:" from list
	folderList = ReplaceString(",",folderList,";")					//change list delimiter from "," to ";"
	folderList = "NewFolder;"+folderList							//add new folder option to start of list
	Prompt newData,"Create new data folder?",popup,"yes;no"
	Prompt folderName, "Select folder",popup,folderList
	Prompt newFolderName,"New folder name"
	DoPrompt "Create blank template",newData,folderName,newFolderName
	
	If(V_flag==0)
		If(!CmpStr(newData,"yes"))
			newDataBool = 1
		Else
			newDataBool = 0
		EndIf
		If(!CmpStr(folderName,"NewFolder"))
			If(CreateBlankTemplate(newDataBool,newFolderName))
				Return 1
			Else
				Return 0
			EndIf
		Else
			If(CreateBlankTemplate(newDataBool,folderName))
				Return 1
			Else
				Return 0
			EndIf
		EndIf
	EndIf
End

//Function: 		CreateBlankTemplate
//Purpose:		Creates or overrite and existing data folder, changes to that data folder and creates a blank template so that the user can paste data in manually
//Parameters:	newDataBool - if non zero a new data folder is created for template, if zero then existing data is overwritten
//				folderName - name of data folder to create for new template, or to overwrite
//Returns:		1 if operation sucessful, or 0 is operation fails
Function CreateBlankTemplate(newDataBool, folderName)
	Variable newDataBool
	String folderName
	
//	String previousDataFolder = GetDataFolder(1)
	SetDataFolder root:
	If(newDataBool)
		If(!DataFolderExists(folderName))
			NewDataFolder $folderName
			SetDataFolder $folderName
		Else
			printf "Error: Cannot create new data folder for \"%s\" because a folder of this name already exists",folderName
			Return 0
		EndIf
	Else
		If(DataFolderExists(folderName))
			SetDataFolder root:$foldername
		Else
			printf "Error: Cannot navigate to data folder \"%s\" because it does not exist", folderName
			Return 0
		EndIf
	EndIf
	Make /o /n=0 unit,set,dt2,dti,fi,dtp,fp,dte,fe,Ftoni
	Return 1
End

//Function: 		ControlImportData
//Purpose:		Is run when the "Import Data" button is pushed.  It collects the user input required to run "ImportData" and then runs it appropriately.
//Parameters:	ctrlName - Not used (required by button functions)
//Returns:		1 if sucessful, else 0
Function ControlImportData(ctrlName) : ButtonControl
	String ctrlName
	
	Variable refnum = -1
	Variable newDataBool
	String path,folderList,newData,folderName,newFolderName
	Open /D/R/M="Select a file to import" refnum
	path = S_filename
	
	setDataFolder root:
	folderList = DataFolderDir(1)								//get listing of data folders in root:
	folderList = ReplaceString("FOLDERS:",folderList,"")			//removed heading "FOLDERS:" from list
	folderList = ReplaceString(",",folderList,";")					//change list delimiter from "," to ";"
	folderList = "NewFolder;"+folderList							//add new folder option to start of list
	Prompt newData,"Create new data folder?",popup,"yes;no"
	Prompt folderName, "Select folder",popup,folderList
	Prompt newFolderName,"New folder name"
	Prompt path,"File to import"
	DoPrompt "Import data from text file",newData,folderName,newFolderName,path
	
	If(V_flag == 0)
		If(!CmpStr(newData,"yes"))
			newDataBool = 1
		Else
			newDataBool = 0
		EndIf
		If(!CmpStr(folderName,"NewFolder"))
			If(ImportData(newDataBool,newFolderName,path))
				Return 1
			Else
				Return 0
			EndIf
		Else
			If(ImportData(newDataBool,folderName,path))
				Return 1
			Else
				Return 0
			EndIf
		EndIf	
	EndIf
End

//Function: 		ImportData
//Purpose:		Imports delimited text data from a file.  Calls CreateBlankTemplate in order to prepare
//Parameters:	newDataBool - if non zero a new data folder is created for template, if zero then existing data is overwritten
//				folderName - name of data folder to create for new template, or to overwrite
//				path - windows path to data to be imported, e.g. "c:\path\file.txt"
//Returns:		1 if operation sucessful, or 0 is operation fails
Function ImportData(newDataBool, folderName,path)
	Variable newDataBool
	String folderName,path
	
	if(CreateBlankTemplate(newDataBool,folderName)) //newDataBool,folderName))		//prepares for importation of data
		LoadWave /J/O/Q/W path
		Return 1
	Else
		Return 0
	EndIf
End
	
//Function: 		Run
//Purpose:		Displays the User Control Panel, provides a simple method to start TAFPLTer from the command line
//Parameters:	none
//Returns:		1 if operation sucessful
Function Run()
	// If the panel is already created, just bring it to the front.
	DoWindow/F UserControlPanel
	if (V_Flag != 0)
		return 0
	endif
	Execute "UserControlPanel()"
	Return 1
End

//Window: 		UserControlPanel
//Purpose:		Defines the User control Panel from which TAFPLOTer is operated
Window UserControlPanel() : Panel
	PauseUpdate; Silent 1 // building window...
	NewPanel/W=(800,100,1010,180)/K=1 as "TAFPLOTer"
	Button CreateBlankTemplateButton,pos={5,5},size={200,20},proc=BlankTemplate,title="Create Blank Template"
	Button ImportDataButton,pos={5,30},size={200,20},proc=ControlImportData,title="Import Data"
	Button GraphDataButton,pos={5,55},size={200,20},proc=GraphData,title="Graph Data"
EndMacro

//Function: 		GraphData
//Purpose:		Produces the TAFPLOT for a existing data folder.  The original data is copied to a subfolder called GraphData and the original data is preserved
//Parameters:	ctrlName - unused (required for Buttons)
//Returns:		nil
Function GraphData(ctrlName) : ButtonControl
	String ctrlName
	
	String folderList,folderName
	Variable BW,minFreq=10,maxFreq=30,numColours,xMin=-1,xMax=2,yMax
	setDataFolder root:
	folderList = DataFolderDir(1)								//get listing of data folders in root:
	folderList = ReplaceString("FOLDERS:",folderList,"")			//removed heading "FOLDERS:" from list
	folderList = ReplaceString(",",folderList,";")					//change list delimiter from "," to ";"
	Prompt folderName, "Select folder",popup,folderList
	Prompt yMax,"Total number of units (scaling)"
//	Prompt BW, "Specify Legend Bandwidth"
	Prompt minFreq,"Minimum Legend Frequncy"
	Prompt maxFreq,"Maximum Legend Frequncy"
	Prompt xMin,"x-axis Minimum"
	Prompt xMax,"x-axis Maximum"
	DoPrompt "Graph Data", folderName,yMax,minFreq,maxFreq,xMin,xMax
	If(V_flag == 0)
		FormatData(folderName,xMIn,xMax,yMax)
		ColourData(folderName,minFreq,maxFreq)
		folderName = "root:"+folderName+":GraphData"
		SetDataFolder $folderName
	//	DoWindow /F PlotData
		PlotData(folderName,xMin,xMax)
		SetDataFolder root:
	EndIf
End

//Function: 		FormatData
//Purpose:		Creates a subbfolder called GraphData and copies the data into this folder.  This data is then foramtted appropriately in preperation for graphing
//Parameters:	folderName - the name of the data folder being graphed
//Returns:		1 if operation sucessful
Function FormatData(folderName,xMin,xMax,yMax)
	String folderName
	Variable xMin,xMax,yMax
	
	Variable i
	SetDataFolder root:$folderName
	Wave unit,set,fi,fe,dti,dte,dt2,fp,dtp,Ftoni
	NewDataFolder /O GraphData
	WaveStats /M=1/Q unit
	Make /O/N=(3*V_npnts) :GraphData:dt2,:GraphData:durationNorm,:GraphData:fi,:GraphData:dtpNorm,:GraphData:fp,:GraphData:fe,:GraphData:Ftoni,:GraphData:unit,:GraphData:set,:GraphData:tonicLines,:GraphData:dtiNorm,:GraphData:dteNorm
	Wave graphDt2=:GraphData:dt2,graphDurationNorm=:GraphData:durationNorm,graphFi=:GraphData:fi,graphDtpNorm=:GraphData:dtpNorm,graphFp=:GraphData:fp,graphFe=:GraphData:fe,graphFtoni=:GraphData:Ftoni,graphUnit=:GraphData:unit,graphSet=:GraphData:set,graphTonicLines=:GraphData:tonicLines,graphDtiNorm=:GraphData:dtiNorm,graphDteNorm=:GraphData:dteNorm
	Make /o/n=2 :GraphData:yAxis
	Wave yAxis=:GraphData:yAxis

	yAxis[0] = 0
	yAxis[1] = yMax
//	SortUnits(V_npnts)
	Make /O/N=(v_npnts) dtiNorm, dteNorm,dtpNorm		//normalise dti and dte to dt2 and preserve original data
	dtiNorm = dti/dt2
	dteNorm = dte/dt2
	dtpNorm = dtp/dt2
	SortUnits(V_npnts)
	
	for(i=0;i<V_nPnts;i+=1)
		graphUnit[i*3] = unit[i]
		graphUnit[i*3+1] = unit[i]
		graphUnit[i*3+2] = NaN
		graphSet[i*3] = set[i]
		graphSet[i*3+1] = set[i]
		graphSet[i*3+2] = NaN
		graphFtoni[i*3] = Ftoni[i]
		graphFtoni[i*3+1] = NaN
		graphFtoni[i*3+2] = NaN
		graphFe[i*3] = fe[i]
		graphFe[i*3+1] = NaN
		graphFe[i*3+2] = NaN
		graphFp[i*3] = fp[i]
		graphFp[i*3+1] = NaN
		graphFp[i*3+2] = NaN
		graphDtpNorm[i*3] = dtpNorm[i]
		graphDtpNorm[i*3+1] = NaN
		graphDtpNorm[i*3+2] = NaN
		graphFi[i*3] = fi[i]
		graphFi[i*3+1] = NaN
		graphFi[i*3+2] = NaN
		graphDtiNorm[i*3] = dtiNorm[i]
		graphDtiNorm[i*3+1] = NaN
		graphDtiNorm[i*3+2] = NaN
		graphDteNorm[i*3] = dteNorm[i]
		graphDteNorm[i*3+1] = NaN
		graphDteNorm[i*3+2] = NaN
		graphDurationNorm[i*3] = dtiNorm[i]
		graphDurationNorm[i*3+1] = dteNorm[i]
		graphDurationNorm[i*3+2] = NaN
		graphDt2[i*3] = dt2[i]
		graphDt2[i*3+1] = NaN
		graphDt2[i*3+2] = NaN
		if(FToni[i] != 0)							//if a tonic unit setup to plot tonic line
			graphTonicLines[i*3]=xMin//00
			graphTonicLines[i*3+1]=xMax//00
		else
			graphTonicLines[i*3] = NaN
			graphTonicLines[i*3+1] = NaN
		endif
		graphTonicLines[i*3+2] = NaN
	endfor
End

//Function: 		SortUnits
//Purpose:		Sorts the unit data first by unit set and then sort each set by onset time (dti)
//Parameters:	nPnts - the number of units, i.e. the length of the data waves
//Returns:		1 if operation sucessful
Function SortUnits(nPnts)
	Variable nPnts
	
	Wave unit,set,fi,fe,dtiNorm,dteNorm,dt2,fp,dtpNorm,Ftoni,dti,dte,dtp
	Variable numSets,i
	Sort /R set,unit,set,fi,fe,dtiNorm,dteNorm,dt2,fp,dtpNorm,Ftoni,dti,dte,dtp	//sort all waves by set
	Make /O/N=200 temp						//maximum number of sets is 200 (0-99 are phasic and 100-199 are tonic)
	numSets = CountSets(set,temp,nPnts)
	for(i=0;i<numSets;i+=1)
		CocktailSort(temp[i],temp[i+1]-1)
//		QuickSort(temp[i],temp[i+1]-1)
//		BubbleSort(temp[i],temp[i+1]-1)
	endfor
	KillWaves temp
End

//Function: 		CountSets
//Purpose:		Counts the number of sets in the data which has already been sorted by set.  It also provides the index where each set starts
//Parameters:	set - sorted set wave
//				temp - modified to contain the starting point of each set, it is referenced by set number (NOT set label).  I.e. the starting index of the second set will be located in temp[2]
//				nPnts - the number of points in set
//Returns:		Count - the number of unit sets found
Function CountSets(set,temp,nPnts)
	Wave set,temp
	Variable nPnts
	
	Variable current = set[0],count=1,i
	Make /O/n=200 temp
	temp[0][0] = 0
	for(i=1;i<nPnts;i+=1)
		if(current!=set[i])						//find start of next set
			current = set[i]
			temp[count]=i					//start of next set is at this index
			count+=1
		EndIf
	endfor
	temp[count]=nPnts						//point after end of last set
	Return count
End

//Function: 		Swap
//Purpose:		swaps data in all waves from index a to index b.  Used for Sorting
//Parameters:	a - first index
//				b - second index
//Returns:		1 if operation sucessful
Function SwapData(a,b)
	Variable a,b
	Variable temp
	
	Wave unit,set,fi,fe,dtiNorm,dteNorm,dt2,fp,dtpNorm,Ftoni,dti,dte,dtp
	temp=unit[a]
	unit[a]=unit[b]
	unit[b]=temp
	temp=set[a]
	set[a]=set[b]
	set[b]=temp
	temp=fi[a]
	fi[a]=fi[b]
	fi[b]=temp
	temp=fe[a]
	fe[a]=fe[b]
	fe[b]=temp
	temp=dtiNorm[a]
	dtiNorm[a]=dtiNorm[b]
	dtiNorm[b]=temp
	temp=dteNorm[a]
	dteNorm[a]=dteNorm[b]
	dteNorm[b]=temp
	temp=dt2[a]
	dt2[a]=dt2[b]
	dt2[b]=temp
	temp=fp[a]
	fp[a]=fp[b]
	fp[b]=temp
	temp=dtpNorm[a]
	dtpNorm[a]=dtpNorm[b]
	dtpNorm[b]=temp
	temp=Ftoni[a]
	Ftoni[a]=Ftoni[b]
	Ftoni[b]=temp
	temp=dti[a]
	dti[a]=dti[b]
	dti[b]=temp
	temp=dte[a]
	dte[a]=dte[b]
	dte[b]=temp
	temp=dtp[a]
	dtp[a]=dtp[b]
	dtp[b]=temp
	
	Return 1
End

//Function: 		CocktailSort
//Purpose:		Perfoms a cocktail sort of part of all waves acording to the dti wave
//Parameters:	top - start of part section to be sorted (inclusive)
//				bottom - end of section to be sorted (inclusive)
//Returns:		1 if operation sucessful
Function CocktailSort(bottom,top)//top,bottom)
	Variable bottom,top//,bottom
	
	Wave dtiNorm
	Variable i,swapped = 1			//tracks when to end
	do
		if(swapped == 0)			//implement while(swapped == true)
			break
		endif
		swapped = 0
		for(i=bottom;i<top;i+=1)
			if(dtiNorm[i] > dtiNorm[i+1])
				SwapData(i,i+1)
				swapped = 1
			endif
		endfor
		top -= 1
		for(i=top;i>bottom;i-=1)
			if(dtiNorm[i] < dtiNorm[i-1])
				SwapData(i,i-1)
				swapped = 1
			endif
		endfor
		bottom += 1
	While(1)
	Return 1
End

//Function: 		ColourData
//Purpose:		Responsible for creating the data used to colour the graph appropriately
//Parameters:	folderName - the folder of the data set being graphed
//				minFreq - the < Freq value for the legend
//				maxFreq - the > Freq value for the legend
//Returns:		1 if operation sucessful
Function ColourData(folderName,minFreq,maxFreq)
	String folderName
	Variable minFreq,maxFreq
	
	folderName = "root:"+folderName+":GraphData"
	SetDataFolder $foldername
	Wave fp,Ftoni,fi,fe
	Variable i=0,nPnts = numPnts(fp),BW=(maxFreq-minFreq)/4
	Make /O/N=(nPnts) order,colour,colourTonic,colourOnset,colourEnd
	Variable red=1,orange=7,yellow=15,green=27,blue=53,purple=68		//graph with rainbow colours
	Make /O/N=5 Thresholds
	for(i=0;i<4;i+=1)													//specify colour thresholds
		Thresholds[i] = minFreq+BW*i
	endfor
	Thresholds[4] = maxFreq
	
	for(i=0;i<nPnts;i+=1)
//		if (mod(i,3)==2)												//generate and order wave which is used to plots data against
//			order[i] = nan;
//		else
			order[i] = round(i/3);
//		endif
		
		if(fp[i]<=Thresholds[0])
			colour[i]=purple
			colour[i+1]=purple
		elseif(fp[i]<=Thresholds[1])
			colour[i]=blue
			colour[i+1]=blue
		elseif(fp[i]<=Thresholds[2])
			colour[i]=green
			colour[i+1]=green
		elseif(fp[i]<=Thresholds[3])
			colour[i]=yellow
			colour[i+1]=yellow
		elseif(fp[i]<=Thresholds[4])
			colour[i]=orange
			colour[i+1]=orange
		elseif(fp[i]>Thresholds[4])
			colour[i]=red
			colour[i+1]=red
		else
			colour[i] = NaN
		endif
		
		if(Ftoni[i]==0)
			colourTonic[i]=NaN
		elseif(Ftoni[i]<=Thresholds[0])
			colourTonic[i]=purple
//			colourTonic[i+1]=purple
		elseif(FToni[i]<=Thresholds[1])
			colourTonic[i]=blue
//			colourTonic[i+1]=blue
		elseif(FToni[i]<=Thresholds[2])
			colourTonic[i]=green
//			colourTonic[i+1]=green
		elseif(FToni[i]<=Thresholds[3])
			colourTonic[i]=yellow
//			colourTonic[i+1]=yellow
		elseif(FToni[i]<=Thresholds[4])
			colourTonic[i]=orange
//			colourTonic[i+1]=orange
		elseif(Ftoni[i]>Thresholds[4] )
			colourTonic[i]=red
//			colourTonic[i+1]=red
		else
			colourTonic[i]=nan
		endif;
		
		if(fi[i]<=Thresholds[0])
			colourOnset[i]=purple
//			colourOnset[i+1]=purple
		elseif(fi[i]<=Thresholds[1])
			colourOnset[i]=blue
//			colourOnset[i+1]=blue
		elseif(fi[i]<=Thresholds[2])
			colourOnset[i]=green
//			colourOnset[i+1]=green 
		elseif(fi[i]<=Thresholds[3])
			colourOnset[i]=yellow
//			colourOnset[i+1]=yellow
		elseif(fi[i]<=Thresholds[4])
			colourOnset[i]=orange
//			colourOnset[i+1]=orange
		elseif(fi[i]>Thresholds[4] )
			colourOnset[i]=red	
//			colourOnset[i+1]=red
		else
			colourOnset[i]=nan;
		endif;
		
		if(fe[i]<=Thresholds[0])
			colourEnd[i]=purple
//			colourEnd[i+1]=purple
		elseif(fe[i]<=Thresholds[1])
			colourEnd[i]=blue
//			colourEnd[i+1]=blue
		elseif(fe[i]<=Thresholds[2])
			colourEnd[i]=green
//			colourEnd[i+1]=green 
		elseif(fe[i]<=Thresholds[3])
			colourEnd[i]=yellow
//			colourEnd[i+1]=yellow
		elseif(fe[i]<=Thresholds[4])
			colourEnd[i]=orange;
//			colourEnd[i+1]=orange;
		elseif(fe[i]>Thresholds[4] )
			colourEnd[i]=red	
//			colourEnd[i+1]=red
		else
			colourEnd[i]=nan;
		endif;
	endfor
//	KillWaves Thresholds
end

Function PlotData(folderName,xMin,xMax)
	String folderName
	Variable xMin,xMax
	
	Wave set,unit,Ftoni,fe,fp,dtpNorm,fi,durationNorm,dt2,colourEnd,colourOnset,colourTonic,colour,order,tonicLines,yAxis
	PauseUpdate; Silent 1		// building window...
	SetDataFolder $folderName
//	String fldrSav0= GetDataFolder(1)
//	SetDataFolder root:Classification:
	Display /W=(92.25,35.75,529.5,584.75) order vs tonicLines //order vs lines
	AppendToGraph order vs durationNorm
	AppendToGraph order vs dtpNorm
	Make /O/N=1 one,two,three,four,five,six
	one[0]=xMax +1
	two[0]=xMax +1
	three[0]=xMax +1
	four[0]=xMax +1
	five[0]=xMax +1
	six[0]=xMax +1
	AppendToGraph unit vs one
	AppendToGraph unit vs two
	AppendToGraph unit vs three
	AppendToGraph unit vs four
	AppendToGraph unit vs five
	AppendToGraph unit vs six
	AppendToGraph order vs dtiNorm
	AppendToGraph order vs dteNorm
	AppendToGraph order vs dtpNorm
//	SetDataFolder fldrSav0
	ModifyGraph margin(left)=28,gfSize=14,wbRGB=(0,0,0),gbRGB=(0,0,0)
	ModifyGraph mode(order#2)=3,mode(unit#1)=3,mode(unit#2)=3,mode(unit)=3
	ModifyGraph mode(unit#3)=3,mode(unit#4)=3,mode(unit#5)=3
	ModifyGraph mode(order#3)=2,mode(order#4)=2,mode(order#5)=3
	ModifyGraph marker(order#2)=19,marker(unit)=16,marker(unit#1)=16
	ModifyGraph marker(unit#2)=16,marker(unit#3)=16,marker(unit#4)=16
	ModifyGraph marker(unit#5)=16,marker(order#5)=19
	ModifyGraph lSize(order#1)=5,lSize(unit)=3,lSize(order#3)=5,lSize(order#4)=5
	ModifyGraph rgb(order#2)=(0,0,0),rgb(unit)=(29440,0,58880),rgb(unit#1)=(0,32768,65280)
	ModifyGraph rgb(unit#2)=(0,65280,0),rgb(unit#3)=(65280,65280,0)
	ModifyGraph rgb(unit#4)=(65280,32768,0),rgb(order#3)=(65280,0,26112),rgb(order#4)=(65280,16384,35840)
	ModifyGraph rgb(order#5)=(0,0,0)
	ModifyGraph msize(order#2)=5,msize(unit)=5,msize(unit#1)=5,msize(unit#2)=5
	ModifyGraph msize(unit#3)=5,msize(unit#4)=5,msize(unit#5)=5
	ModifyGraph msize(order#5)=4.15
	ModifyGraph opaque(order#5)=1
	ModifyGraph zColor(order)={colourTonic,1,68,Rainbow},zColor(order#1)={colour,1,68,Rainbow}
	ModifyGraph zColor(order#2)={colour,1,68,Rainbow},zColor(order#3)={colourOnset,0,68,Rainbow}
	ModifyGraph zColor(order#4)={colourEnd,0,68,Rainbow}
	ModifyGraph axRGB(bottom)=(65535,65535,65535)
	ModifyGraph tlblRGB(bottom)=(65535,65535,65535)
	ModifyGraph alblRGB(bottom)=(65535,65535,65535)
	ModifyGraph margin(top)=113
	WaveStats /Q order
	Make /O/N=(V_Npnts+v_numNaNs) lineZero,lineOne
	lineZero=0
	lineOne=1
//	AppendToGraph order vs lineOne
//	AppendToGraph order vs lineZero
	AppendToGraph yAxis vs lineOne
	AppendToGraph yAxis vs lineZero
	ModifyGraph lstyle(yAxis)=3,lsize(yAxis)=2,rgb(yAxis)=(65535,65535,65535)
	ModifyGraph lstyle(yAxis#1)=3,lsize(yAxis#1)=2,rgb(yAxis#1)=(65535,65535,65535)
	SetAxis/N=1 left 0,yAxis[1] //V_Max //94
	SetAxis/N=1 bottom xMin,xMax //-1,2//00,200
	String legendText
	Wave Thresholds
	sprintf legendText "\\K(65535,65535,65535)\\Z12\\s(unit) <%.1f Hz\r\\s(unit#1) %.1f - %.1f Hz\r\\s(unit#2) %.1f - %.1f Hz\r\\s(unit#3) %.1f - %.1f Hz\r\\s(unit#4) %.1f - %.1f Hz\r\\s(unit#5) >%.1f Hz",Thresholds[0], Thresholds[0],Thresholds[1],Thresholds[1],Thresholds[2],Thresholds[2],Thresholds[3],Thresholds[3],Thresholds[4],Thresholds[4]
	Legend/N=text1/J/F=0/B=2/A=MC/X=40/Y=65 legendText //"\\K(65535,65535,65535)\\Z12\\s(unit) <10 Hz\r\\s(unit#1) 10-15 Hz\r\\s(unit#2) 15-20 Hz"
//	AppendText "\\s(unit#3) 20-25 Hz\r\\s(unit#4) 25-30 Hz\r\\s(unit#5) >30 Hz"
	ShowTools
//	SetDrawLayer UserFront
//	SetDrawEnv linethick= 2,linefgc= (65535,65535,65535),dash= 11
//	DrawLine 0.338297872340425,1.01156989564633,0.338297872340425,0.17373205780849
//	SetDrawEnv linethick= 2,linefgc= (65535,65535,65535),dash= 11
//	DrawLine 0.665957446808511,1.01029601029601,0.665957446808511,0.176319176319176
EndMacro