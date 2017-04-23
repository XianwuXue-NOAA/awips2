/*
** Generated by X-Designer
*/
/*
**LIBS: -lXm -lXt -lX11
*/

#include <stdlib.h>
#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>

#include <Xm/Xm.h>
#include <Xm/DialogS.h>
#include <Xm/Form.h>
#include <Xm/Label.h>
#include <Xm/PushB.h>
#include <Xm/Scale.h>
#include <Xm/Separator.h>


#include "display_control_endtime.h"

Widget accum_endtimeControlDS = (Widget) NULL;
Widget accum_endtimeControlFO = (Widget) NULL;
Widget accum_endtimeSC = (Widget) NULL;
Widget accum_endtimeLA = (Widget) NULL;
Widget accum_endtimeSP = (Widget) NULL;
Widget accum_endtimeOkPB = (Widget) NULL;
Widget accum_endtimeCancelPB = (Widget) NULL;
Widget accum_endtimeHelpPB = (Widget) NULL;



void create_accum_endtimeControlDS (Widget parent)
{
	Widget children[6];      /* Children to manage */
	Arg al[64];                    /* Arg List */
	register int ac = 0;           /* Arg Count */
	XmString xmstrings[16];    /* temporary storage for XmStrings */

	XtSetArg(al[ac], XmNallowShellResize, TRUE); ac++;
	XtSetArg(al[ac], XmNtitle, "Accumulation Endtime"); ac++;
	XtSetArg(al[ac], XmNminWidth, 250); ac++;
	XtSetArg(al[ac], XmNminHeight, 125); ac++;
	XtSetArg(al[ac], XmNmaxWidth, 250); ac++;
	XtSetArg(al[ac], XmNmaxHeight, 125); ac++;
	XtSetArg(al[ac], XmNbaseWidth, 250); ac++;
	XtSetArg(al[ac], XmNbaseHeight, 125); ac++;
	accum_endtimeControlDS = XmCreateDialogShell ( parent, "accum_endtimeControlDS", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNwidth, 250); ac++;
	XtSetArg(al[ac], XmNheight, 125); ac++;
	XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
	accum_endtimeControlFO = XmCreateForm ( accum_endtimeControlDS, "accum_endtimeControlFO", al, ac );
	ac = 0;
	XtSetArg(al[ac], XmNshowValue, TRUE); ac++;
	XtSetArg(al[ac], XmNminimum, 0); ac++;
	XtSetArg(al[ac], XmNmaximum, 23); ac++;
	XtSetArg(al[ac], XmNvalue, 12); ac++;
	XtSetArg(al[ac], XmNorientation, XmHORIZONTAL); ac++;
	XtSetArg(al[ac], XmNprocessingDirection, XmMAX_ON_RIGHT); ac++;
	accum_endtimeSC = XmCreateScale ( accum_endtimeControlFO, "accum_endtimeSC", al, ac );
	ac = 0;
	xmstrings[0] = XmStringCreateLtoR ( "Accumulation Endtime", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	accum_endtimeLA = XmCreateLabel ( accum_endtimeControlFO, "accum_endtimeLA", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	accum_endtimeSP = XmCreateSeparator ( accum_endtimeControlFO, "accum_endtimeSP", al, ac );
	XtSetArg(al[ac], XmNwidth, 65); ac++;
	XtSetArg(al[ac], XmNheight, 30); ac++;
	xmstrings[0] = XmStringCreateLtoR ( "Ok", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	accum_endtimeOkPB = XmCreatePushButton ( accum_endtimeControlFO, "accum_endtimeOkPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNx, 92); ac++;
	XtSetArg(al[ac], XmNy, 87); ac++;
	XtSetArg(al[ac], XmNwidth, 65); ac++;
	XtSetArg(al[ac], XmNheight, 30); ac++;
	xmstrings[0] = XmStringCreateLtoR ( "Cancel", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	accum_endtimeCancelPB = XmCreatePushButton ( accum_endtimeControlFO, "accum_endtimeCancelPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	XtSetArg(al[ac], XmNwidth, 65); ac++;
	XtSetArg(al[ac], XmNheight, 30); ac++;
	xmstrings[0] = XmStringCreateLtoR ( "Help", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	accum_endtimeHelpPB = XmCreatePushButton ( accum_endtimeControlFO, "accum_endtimeHelpPB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );


	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 7); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -42); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 2); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -249); ac++;
	XtSetValues ( accum_endtimeSC,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 43); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 0); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( accum_endtimeLA,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 71); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -82); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 3); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -245); ac++;
	XtSetValues ( accum_endtimeSP,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 87); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 3); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( accum_endtimeOkPB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 87); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 92); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( accum_endtimeCancelPB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 87); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 178); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( accum_endtimeHelpPB,al, ac );
	ac = 0;
	children[ac++] = accum_endtimeSC;
	children[ac++] = accum_endtimeLA;
	children[ac++] = accum_endtimeSP;
	children[ac++] = accum_endtimeOkPB;
	children[ac++] = accum_endtimeCancelPB;
	children[ac++] = accum_endtimeHelpPB;
	XtManageChildren(children, ac);
	ac = 0;
}
