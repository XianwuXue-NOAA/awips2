//------------------------------------------------------------------------------
// SetMax :: copy - Calls copy constructor of Method
//------------------------------------------------------------------------------
// Copyright:	See the COPYRIGHT file.
//------------------------------------------------------------------------------
// Notes:
//
//------------------------------------------------------------------------------
// History:
// 
// 05 May 1998	Daniel Weiler, RTi
//					Created initial version.
// 16 Feb 2006  JRV, RTi        Generalized the method for different component
//                              types.  (It Was Reservoir only.)
//------------------------------------------------------------------------------
// Variables:	I/O	Description		
//
//
//------------------------------------------------------------------------------
#include "SetMax.h"

SetMax* SetMax :: copy( Component* owner )
{
	SetMax* meth = NULL;
	meth = new SetMax( *this, (Component*)owner );
	return( meth );

/*  ==============  Statements containing RCS keywords:  */
/*  ===================================================  */


/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob81/ohd/ofs/src/resj_topology/RCS/SetMax_copy.cxx,v $";
 static char rcs_id2[] = "$Id: SetMax_copy.cxx,v 1.2 2006/10/26 15:33:26 hsu Exp $";}
/*  ===================================================  */

}