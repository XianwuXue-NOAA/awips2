/*
** Generated by X-Designer
*/
/*
**LIBS: -lXm -lXt -lX11
*/

#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>

#include <Xm/Xm.h>
#include <Xm/DialogS.h>
#include <Xm/Form.h>
#include <Xm/Label.h>
#include <Xm/List.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/ScrollBar.h>
#include <Xm/Text.h>
#include <Xm/TextF.h>
#include <Xm/ToggleB.h>
#include <Xm/CascadeBG.h>
#include <Xm/LabelG.h>
#include <Xm/ToggleBG.h>


Widget reviewqcDS = (Widget) NULL;
Widget reviewqcFO = (Widget) NULL;
Widget obstablesOM = (Widget) NULL;
Widget obstablesLB = (Widget) NULL;
Widget obstablesCB = (Widget) NULL;
Widget obstablesPDM = (Widget) NULL;
Widget agriculturePB = (Widget) NULL;
Widget dischargePB = (Widget) NULL;
Widget evaporationPB = (Widget) NULL;
Widget fishcountPB = (Widget) NULL;
Widget gatedamPB = (Widget) NULL;
Widget groundPB = (Widget) NULL;
Widget heightPB = (Widget) NULL;
Widget icePB = (Widget) NULL;
Widget lakePB = (Widget) NULL;
Widget moisturePB = (Widget) NULL;
Widget powerPB = (Widget) NULL;
Widget precipPCPB = (Widget) NULL;
Widget precipPPPB = (Widget) NULL;
Widget precipOPB = (Widget) NULL;
Widget pressurePB = (Widget) NULL;
Widget radiationPB = (Widget) NULL;
Widget snowPB = (Widget) NULL;
Widget temperaturePB = (Widget) NULL;
Widget waterqualityPB = (Widget) NULL;
Widget weatherPB = (Widget) NULL;
Widget windPB = (Widget) NULL;
Widget yuniquePB = (Widget) NULL;
Widget qclistLB = (Widget) NULL;
Widget qclistSL = (Widget) NULL;
Widget qclistHSB = (Widget) NULL;
Widget qclistVSB = (Widget) NULL;
Widget qclistLS = (Widget) NULL;
Widget reviewfilterLB = (Widget) NULL;
Widget filterlocationTB = (Widget) NULL;
Widget listlocTX = (Widget) NULL;
Widget lastLB = (Widget) NULL;
Widget daysTX = (Widget) NULL;
Widget daysLB = (Widget) NULL;
Widget reviewsortLB = (Widget) NULL;
Widget review_closePB = (Widget) NULL;
Widget review_graphPB = (Widget) NULL;
Widget review_tablePB = (Widget) NULL;
Widget iqdescriptionLA = (Widget) NULL;
Widget iqdescriptionTE = (Widget) NULL;
Widget review_setmissingPB = (Widget) NULL;
Widget review_deletePB = (Widget) NULL;
Widget reviewsortRB = (Widget) NULL;
Widget sortlocationTB = (Widget) NULL;
Widget sorttimeTB = (Widget) NULL;
Widget sort_shef_qualTB = (Widget) NULL;
Widget sort_quality_codeTB = (Widget) NULL;



void create_reviewqcDS (parent)
Widget parent;
{
	Widget children[22];      /* Children to manage */
	Arg al[64];                    /* Arg List */
	register int ac = 0;           /* Arg Count */
	XtPointer tmp_value;             /* ditto */
	XmString xmstrings[16];    /* temporary storage for XmStrings */

	XtSetArg(al[ac], XmNwidth, 1030); ac++;
	XtSetArg(al[ac], XmNallowShellResize, TRUE); ac++;
	XtSetArg(al[ac], XmNtitle, "Questionable and Bad Data"); ac++;
	XtSetArg(al[ac], XmNminWidth, 1100); ac++;
	XtSetArg(al[ac], XmNminHeight, 500); ac++;
	XtSetArg(al[ac], XmNmaxWidth, 1100); ac++;
	XtSetArg(al[ac], XmNmaxHeight, 500); ac++;
	XtSetArg(al[ac], XmNbaseWidth, 1100); ac++;
	XtSetArg(al[ac], XmNbaseHeight, 500); ac++;
	reviewqcDS = XmCreateDialogShell ( parent, (char *) "reviewqcDS", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNmarginWidth, 10); ac++;
	XtSetArg(al[ac], XmNmarginHeight, 10); ac++;
	XtSetArg(al[ac], XmNnoResize, FALSE); ac++;
	XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
	XtSetArg(al[ac], XmNhorizontalSpacing, 10); ac++;
	XtSetArg(al[ac], XmNverticalSpacing, 10); ac++;
	reviewqcFO = XmCreateForm ( reviewqcDS, (char *) "reviewqcFO", al, ac );
	ac = 0;
#if       ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20))
	xmstrings[0] = XmStringGenerate((XtPointer) " ", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL);
#else  /* ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20)) */
	xmstrings[0] = XmStringCreateLtoR(" ", (XmStringCharSet) XmFONTLIST_DEFAULT_TAG);
#endif /* ((XmVERSION > 1) && (XmREVISION == 1) && (XmUPDATE_LEVEL < 20)) */
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	obstablesOM = XmCreateOptionMenu ( reviewqcFO, (char *) "obstablesOM", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	obstablesLB = XmOptionLabelGadget ( obstablesOM );
	obstablesCB = XmOptionButtonGadget ( obstablesOM );
	XtSetArg(al[ac], XmNspacing, 0); ac++;
	obstablesPDM = XmCreatePulldownMenu ( obstablesOM, (char *) "obstablesPDM", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Agriculture", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	agriculturePB = XmCreatePushButton ( obstablesPDM, (char *) "agriculturePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Discharge", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	dischargePB = XmCreatePushButton ( obstablesPDM, (char *) "dischargePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Evaporation", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	evaporationPB = XmCreatePushButton ( obstablesPDM, (char *) "evaporationPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "FishCount", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	fishcountPB = XmCreatePushButton ( obstablesPDM, (char *) "fishcountPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Gate Dam", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	gatedamPB = XmCreatePushButton ( obstablesPDM, (char *) "gatedamPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Ground", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	groundPB = XmCreatePushButton ( obstablesPDM, (char *) "groundPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Height (Stage)", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	heightPB = XmCreatePushButton ( obstablesPDM, (char *) "heightPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Ice", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	icePB = XmCreatePushButton ( obstablesPDM, (char *) "icePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Lake", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	lakePB = XmCreatePushButton ( obstablesPDM, (char *) "lakePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Moisture", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	moisturePB = XmCreatePushButton ( obstablesPDM, (char *) "moisturePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Power", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	powerPB = XmCreatePushButton ( obstablesPDM, (char *) "powerPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Precipitation (PC)", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	precipPCPB = XmCreatePushButton ( obstablesPDM, (char *) "precipPCPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Precipitation (PP)", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	precipPPPB = XmCreatePushButton ( obstablesPDM, (char *) "precipPPPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Precipitation (Other)", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	precipOPB = XmCreatePushButton ( obstablesPDM, (char *) "precipOPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Pressure", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	pressurePB = XmCreatePushButton ( obstablesPDM, (char *) "pressurePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Radiation", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	radiationPB = XmCreatePushButton ( obstablesPDM, (char *) "radiationPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Snow", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	snowPB = XmCreatePushButton ( obstablesPDM, (char *) "snowPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Temperature", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	temperaturePB = XmCreatePushButton ( obstablesPDM, (char *) "temperaturePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "WaterQuality", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	waterqualityPB = XmCreatePushButton ( obstablesPDM, (char *) "waterqualityPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Weather", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	weatherPB = XmCreatePushButton ( obstablesPDM, (char *) "weatherPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Wind", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	windPB = XmCreatePushButton ( obstablesPDM, (char *) "windPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "YUnique", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	yuniquePB = XmCreatePushButton ( obstablesPDM, (char *) "yuniquePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Location    Name                         PE      Dur  TS   Ext      Value       Observation Time      RV   SQ    QC     Product         Time             Posted", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_BEGINNING); ac++;
	qclistLB = XmCreateLabel ( reviewqcFO, (char *) "qclistLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNselectionPolicy, XmEXTENDED_SELECT); ac++;
	XtSetArg(al[ac], XmNlistSizePolicy, XmRESIZE_IF_POSSIBLE); ac++;
	qclistLS = XmCreateScrolledList ( reviewqcFO, (char *) "qclistLS", al, ac );
	ac = 0;
	qclistSL = XtParent ( qclistLS );

	XtSetArg(al[ac], XmNhorizontalScrollBar, &qclistHSB); ac++;
	XtSetArg(al[ac], XmNverticalScrollBar, &qclistVSB); ac++;
	XtGetValues(qclistSL, al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Filter By: ", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	reviewfilterLB = XmCreateLabel ( reviewqcFO, (char *) "reviewfilterLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Location", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	filterlocationTB = XmCreateToggleButton ( reviewqcFO, (char *) "filterlocationTB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 8); ac++;
	listlocTX = XmCreateText ( reviewqcFO, (char *) "listlocTX", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Last", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	lastLB = XmCreateLabel ( reviewqcFO, (char *) "lastLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 2); ac++;
	daysTX = XmCreateText ( reviewqcFO, (char *) "daysTX", al, ac );
	ac = 0;
	XmTextSetString(daysTX, "1");
	xmstrings[0] = XmStringGenerate ( (XtPointer) "days", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_BEGINNING); ac++;
	daysLB = XmCreateLabel ( reviewqcFO, (char *) "daysLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Sort By:", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_END); ac++;
	reviewsortLB = XmCreateLabel ( reviewqcFO, (char *) "reviewsortLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Close", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	review_closePB = XmCreatePushButton ( reviewqcFO, (char *) "review_closePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Graphical Time Series", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	review_graphPB = XmCreatePushButton ( reviewqcFO, (char *) "review_graphPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Tabular Time Series", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	review_tablePB = XmCreatePushButton ( reviewqcFO, (char *) "review_tablePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "QC Description", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	iqdescriptionLA = XmCreateLabel ( reviewqcFO, (char *) "iqdescriptionLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNmaxLength, 200); ac++;
	iqdescriptionTE = XmCreateTextField ( reviewqcFO, (char *) "iqdescriptionTE", al, ac );
	ac = 0;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Set Missing", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	review_setmissingPB = XmCreatePushButton ( reviewqcFO, (char *) "review_setmissingPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Delete Selected", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	review_deletePB = XmCreatePushButton ( reviewqcFO, (char *) "review_deletePB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNwidth, 450); ac++;
	XtSetArg(al[ac], XmNspacing, 11); ac++;
	XtSetArg(al[ac], XmNmarginWidth, 5); ac++;
	XtSetArg(al[ac], XmNmarginHeight, 2); ac++;
	XtSetArg(al[ac], XmNorientation, XmHORIZONTAL); ac++;
	reviewsortRB = XmCreateRadioBox ( reviewqcFO, (char *) "reviewsortRB", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNx, 5); ac++;
	XtSetArg(al[ac], XmNy, 2); ac++;
	XtSetArg(al[ac], XmNwidth, 76); ac++;
	XtSetArg(al[ac], XmNheight, 25); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Location", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	sortlocationTB = XmCreateToggleButtonGadget ( reviewsortRB, (char *) "sortlocationTB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNx, 114); ac++;
	XtSetArg(al[ac], XmNy, 2); ac++;
	XtSetArg(al[ac], XmNwidth, 75); ac++;
	XtSetArg(al[ac], XmNheight, 16); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Time", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	sorttimeTB = XmCreateToggleButtonGadget ( reviewsortRB, (char *) "sorttimeTB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNwidth, 83); ac++;
	XtSetArg(al[ac], XmNheight, 16); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Shef Quality", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	sort_shef_qualTB = XmCreateToggleButtonGadget ( reviewsortRB, (char *) "sort_shef_qualTB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNx, 332); ac++;
	XtSetArg(al[ac], XmNy, 2); ac++;
	XtSetArg(al[ac], XmNwidth, 52); ac++;
	XtSetArg(al[ac], XmNheight, 1); ac++;
	xmstrings[0] = XmStringGenerate ( (XtPointer) "Quality Code", XmFONTLIST_DEFAULT_TAG, XmCHARSET_TEXT, NULL );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNalignment, XmALIGNMENT_BEGINNING); ac++;
	sort_quality_codeTB = XmCreateToggleButtonGadget ( reviewsortRB, (char *) "sort_quality_codeTB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );


	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -40); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 271); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -455); ac++;
	XtSetValues ( obstablesOM, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 45); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -63); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -1080); ac++;
	XtSetValues ( qclistLB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 75); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -378); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 6); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -1080); ac++;
	XtSetValues ( qclistSL, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -40); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -80); ac++;
	XtSetValues ( reviewfilterLB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -40); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 80); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -175); ac++;
	XtSetValues ( filterlocationTB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -40); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 175); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -268); ac++;
	XtSetValues ( listlocTX, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -40); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 460); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -510); ac++;
	XtSetValues ( lastLB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -40); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 510); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -550); ac++;
	XtSetValues ( daysTX, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -40); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 550); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -590); ac++;
	XtSetValues ( daysLB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 5); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -38); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 590); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -643); ac++;
	XtSetValues ( reviewsortLB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 460); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -490); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 760); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -870); ac++;
	XtSetValues ( review_closePB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 460); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -490); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 205); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -400); ac++;
	XtSetValues ( review_graphPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 460); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -490); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -185); ac++;
	XtSetValues ( review_tablePB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 415); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -450); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 5); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -130); ac++;
	XtSetValues ( iqdescriptionLA, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 410); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -450); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 130); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -1080); ac++;
	XtSetValues ( iqdescriptionTE, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 460); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -490); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 420); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -560); ac++;
	XtSetValues ( review_setmissingPB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 460); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -490); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 580); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -740); ac++;
	XtSetValues ( review_deletePB, al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 11); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -36); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 644); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -1080); ac++;
	XtSetValues ( reviewsortRB, al, ac );
	ac = 0;
	if ((children[ac] = agriculturePB) != (Widget) 0) { ac++; }
	if ((children[ac] = dischargePB) != (Widget) 0) { ac++; }
	if ((children[ac] = evaporationPB) != (Widget) 0) { ac++; }
	if ((children[ac] = fishcountPB) != (Widget) 0) { ac++; }
	if ((children[ac] = gatedamPB) != (Widget) 0) { ac++; }
	if ((children[ac] = groundPB) != (Widget) 0) { ac++; }
	if ((children[ac] = heightPB) != (Widget) 0) { ac++; }
	if ((children[ac] = icePB) != (Widget) 0) { ac++; }
	if ((children[ac] = lakePB) != (Widget) 0) { ac++; }
	if ((children[ac] = moisturePB) != (Widget) 0) { ac++; }
	if ((children[ac] = powerPB) != (Widget) 0) { ac++; }
	if ((children[ac] = precipPCPB) != (Widget) 0) { ac++; }
	if ((children[ac] = precipPPPB) != (Widget) 0) { ac++; }
	if ((children[ac] = precipOPB) != (Widget) 0) { ac++; }
	if ((children[ac] = pressurePB) != (Widget) 0) { ac++; }
	if ((children[ac] = radiationPB) != (Widget) 0) { ac++; }
	if ((children[ac] = snowPB) != (Widget) 0) { ac++; }
	if ((children[ac] = temperaturePB) != (Widget) 0) { ac++; }
	if ((children[ac] = waterqualityPB) != (Widget) 0) { ac++; }
	if ((children[ac] = weatherPB) != (Widget) 0) { ac++; }
	if ((children[ac] = windPB) != (Widget) 0) { ac++; }
	if ((children[ac] = yuniquePB) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
	XtSetArg(al[ac], XmNsubMenuId, obstablesPDM); ac++;
	XtSetValues(obstablesCB, al, ac );
	ac = 0;
	if (qclistLS != (Widget) 0) { XtManageChild(qclistLS); }
	if ((children[ac] = sortlocationTB) != (Widget) 0) { ac++; }
	if ((children[ac] = sorttimeTB) != (Widget) 0) { ac++; }
	if ((children[ac] = sort_shef_qualTB) != (Widget) 0) { ac++; }
	if ((children[ac] = sort_quality_codeTB) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
	if ((children[ac] = obstablesOM) != (Widget) 0) { ac++; }
	if ((children[ac] = qclistLB) != (Widget) 0) { ac++; }
	if ((children[ac] = reviewfilterLB) != (Widget) 0) { ac++; }
	if ((children[ac] = filterlocationTB) != (Widget) 0) { ac++; }
	if ((children[ac] = listlocTX) != (Widget) 0) { ac++; }
	if ((children[ac] = lastLB) != (Widget) 0) { ac++; }
	if ((children[ac] = daysTX) != (Widget) 0) { ac++; }
	if ((children[ac] = daysLB) != (Widget) 0) { ac++; }
	if ((children[ac] = reviewsortLB) != (Widget) 0) { ac++; }
	if ((children[ac] = review_closePB) != (Widget) 0) { ac++; }
	if ((children[ac] = review_graphPB) != (Widget) 0) { ac++; }
	if ((children[ac] = review_tablePB) != (Widget) 0) { ac++; }
	if ((children[ac] = iqdescriptionLA) != (Widget) 0) { ac++; }
	if ((children[ac] = iqdescriptionTE) != (Widget) 0) { ac++; }
	if ((children[ac] = review_setmissingPB) != (Widget) 0) { ac++; }
	if ((children[ac] = review_deletePB) != (Widget) 0) { ac++; }
	if ((children[ac] = reviewsortRB) != (Widget) 0) { ac++; }
	if (ac > 0) { XtManageChildren(children, ac); }
	ac = 0;
}
