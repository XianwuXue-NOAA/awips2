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
#include <Xm/TextF.h>


#include "YscalesInp.h"

Widget Ymax_minDS = (Widget) NULL;
Widget Ymax_minFO = (Widget) NULL;
Widget YmaxLB = (Widget) NULL;
Widget YmaxText = (Widget) NULL;
Widget YminLB = (Widget) NULL;
Widget YminText = (Widget) NULL;
Widget YmaxminOKBttn = (Widget) NULL;
Widget YmaxminCancelBttn = (Widget) NULL;



void create_Ymax_minDS (Widget parent)
{
	Widget children[6];      /* Children to manage */
	Arg al[64];                    /* Arg List */
	register int ac = 0;           /* Arg Count */
	XmString xmstrings[16];    /* temporary storage for XmStrings */

	XtSetArg(al[ac], XmNallowShellResize, TRUE); ac++;
	XtSetArg(al[ac], XmNminWidth, 200); ac++;
	XtSetArg(al[ac], XmNminHeight, 125); ac++;
	XtSetArg(al[ac], XmNmaxWidth, 200); ac++;
	XtSetArg(al[ac], XmNmaxHeight, 125); ac++;
	Ymax_minDS = XmCreateDialogShell ( parent, "Ymax_minDS", al, ac );
	ac = 0;
	xmstrings[0] = XmStringCreateLtoR ( "Select YMax/YMin ", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNdialogTitle, xmstrings[0]); ac++;
	XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
	Ymax_minFO = XmCreateForm ( Ymax_minDS, "Ymax_minFO", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "\nYmax:\n", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	YmaxLB = XmCreateLabel ( Ymax_minFO, "YmaxLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	YmaxText = XmCreateTextField ( Ymax_minFO, "YmaxText", al, ac );
	xmstrings[0] = XmStringCreateLtoR ( "Ymin:", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	YminLB = XmCreateLabel ( Ymax_minFO, "YminLB", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	YminText = XmCreateTextField ( Ymax_minFO, "YminText", al, ac );
	xmstrings[0] = XmStringCreateLtoR ( "     OK      ", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	YmaxminOKBttn = XmCreatePushButton ( Ymax_minFO, "YmaxminOKBttn", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );
	xmstrings[0] = XmStringCreateLtoR ( "  Cancel  ", (XmStringCharSet)XmFONTLIST_DEFAULT_TAG );
	XtSetArg(al[ac], XmNlabelString, xmstrings[0]); ac++;
	YmaxminCancelBttn = XmCreatePushButton ( Ymax_minFO, "YmaxminCancelBttn", al, ac );
	ac = 0;
	XmStringFree ( xmstrings [ 0 ] );


	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -30); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -50); ac++;
	XtSetValues ( YmaxLB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 0); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -29); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 50); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -190); ac++;
	XtSetValues ( YmaxText,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 40); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -70); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 0); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -50); ac++;
	XtSetValues ( YminLB,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 40); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNbottomOffset, -70); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 50); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_OPPOSITE_FORM); ac++;
	XtSetArg(al[ac], XmNrightOffset, -190); ac++;
	XtSetValues ( YminText,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 80); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 10); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( YmaxminOKBttn,al, ac );
	ac = 0;

	XtSetArg(al[ac], XmNtopAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNtopOffset, 80); ac++;
	XtSetArg(al[ac], XmNbottomAttachment, XmATTACH_NONE); ac++;
	XtSetArg(al[ac], XmNleftAttachment, XmATTACH_FORM); ac++;
	XtSetArg(al[ac], XmNleftOffset, 110); ac++;
	XtSetArg(al[ac], XmNrightAttachment, XmATTACH_NONE); ac++;
	XtSetValues ( YmaxminCancelBttn,al, ac );
	ac = 0;
	children[ac++] = YmaxLB;
	children[ac++] = YmaxText;
	children[ac++] = YminLB;
	children[ac++] = YminText;
	children[ac++] = YmaxminOKBttn;
	children[ac++] = YmaxminCancelBttn;
	XtManageChildren(children, ac);
	ac = 0;

/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob72/rfc/ifp/src/PlotTS/RCS/YscalesInp.c,v $";
 static char rcs_id2[] = "$Id: YscalesInp.c,v 1.2 2002/05/16 12:40:17 dws Exp $";}
/*  ===================================================  */

}
