C MEMBER SFGBOX
C-----------------------------------------------------------------------
C
C DESC ROUTINE FOR DEFINING GRID BOXES FOR MARO FUNCTION
C DESC PPINIT COMMAND :  @DEFINE GBOX
C
      SUBROUTINE SFGBOX (LARRAY,ARRAY,DISP,PRPARM,PRNOTE,NFLD,
     *   IRUNCK,ISTAT)
C
C
      REAL XGBOX/4HGBOX/
      REAL XNO/4HNO  /
      REAL XYES/4HYES /
      REAL NEW/4HNEW /,OLD/4HOLD /,QUES/4H????/
      REAL SLASH/4H/   /,CKNULL(2)/4H,,  ,4HNULL/
      REAL LPAREN/4H(    /,RPAREN/4H)   /
      REAL*8 OPTN(4)
C
      DIMENSION ARRAY(LARRAY)
      DIMENSION CHAR(5),CHK(5)
      INCLUDE 'scommon/dimgbox'
C
C
      INCLUDE 'uio'
      INCLUDE 'scommon/sudbgx'
      INCLUDE 'scommon/sugnlx'
      INCLUDE 'scommon/sgboxx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppinit_define/RCS/sfgbox.f,v $
     . $',                                                             '
     .$Id: sfgbox.f,v 1.1 1995/09/17 19:11:01 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA NOPTN/3/
      DATA OPTN/8HADJ     ,8HMDR     ,8HMDRT    ,8H        /
C
C
      IF (ISTRCE.GT.0) WRITE (IOSDBG,790)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
C  SET DEBUG LEVEL
      LDEBUG=ISBUG(XGBOX)
C
      ISTAT=0
C
      LCHAR=5
      LCHK=5
      TDISP=DISP
C
C  SET VALUE FOR MISSING PARAMETER
      UNSD=-999.
      UNDEF=-997.
C
      NUMERR=0
      NUMWRN=0
      ILPFND=0
      IRPFND=0
      ISTRT=-1
      NUMFLD=0
      MINFLD=6
      MAXFLD=7
      INWFLG=0
      NOPFLD=0
      NXTFLD=0
      NPIFLD=0
      NPCFLD=NFLD
      IENDIN=0
C
C
C  CHECK NUMBER OF LINES LEFT ON PAGE
      IF (ISLEFT(5).GT.0) CALL SUPAGE
C
C  PRINT CARD
      CALL SUPCRD
C
C  PRINT HEADER LINE
      WRITE (LP,800)
      CALL SULINE (LP,2)
      WRITE (LP,810)
      CALL SULINE (LP,2)
C
      IF (LDEBUG.EQ.0) GO TO 10
C
C  PRINT OPTIONS
      XRUNCK=QUES
      IF (IRUNCK.EQ.0) XRUNCK=XNO
      IF (IRUNCK.EQ.1) XRUNCK=XYES
      WRITE (LP,820) TDISP,PRPARM,PRNOTE,XRUNCK
      CALL SULINE (LP,2)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF PREPROCESSOR PARAMETRIC DATA BASE ALLOCATED
C
10    IDPPP=1
      CALL SUDALC (0,0,0,0,IDPPP,0,0,0,0,0,NUMERR,IERR)
      IF (IERR.EQ.0) GO TO 20
         WRITE (LP,860)
         CALL SUERRS (LP,2,NUMERR)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF GENERAL USER PARAMETER COMMON BLOCK FILLED
C
20    IF (IUGFIL.GT.0) GO TO 35
C
C  READ USER DEFINED DEFAULTS
      CALL SUGTUG (LARRAY,ARRAY,IERR)
      IF (IERR.NE.0) GO TO 30
         IUGFIL=1
         GO TO 35
30    WRITE (LP,870)
      CALL SUERRS (LP,2,NUMERR)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK IF GRID BOX COMMON BLOCK FILLED
C
35    IF (IBXFIL.GT.0) GO TO 40
C
C  READ GRID BOX PARAMETER ARRAYS
      CALL SUGTBX (LARRAY,ARRAY,IERR)
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK FIELDS FOR DEFINE GRID BOX OPTIONS
40    IF (INWFLG.EQ.0) GO TO 50
         INULL=1
         GO TO 120
50    INULL=0
      NULREP=0
      CALL UFIELD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,LCHAR,CHAR,
     *   LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
      IF (NFLD.NE.-1) GO TO 60
         IENDIN=1
         GO TO 100
60    IF (LDEBUG.GT.0)
     * CALL UPRFLD (NFLD,ISTRT,LENGTH,ITYPE,NREP,INTEGR,REAL,LCHAR,
     *   CHAR,LLPAR,LRPAR,LASK,LATSGN,LAMPS,LEQUAL,IERR)
C
C  CHECK FOR NULL FIELD
      IF (IERR.NE.1) GO TO 80
         IF (LDEBUG.GT.0) WRITE (IOSDBG,950) NFLD
         IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
         IF (TDISP.EQ.NEW) GO TO 70
            NUMFLD=NUMFLD+1
            IF (NFLD.EQ.1) CALL SUPCRD
            GO TO 40
70       INULL=1
         GO TO 220
C
80    IF (LDEBUG.GT.0) WRITE (IOSDBG,980) CHAR
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
C  CHECK FOR DEBUG
      CALL SUIDCK (4HCMDS,CHAR,NFLD,0,ICMD,IERR)
      IF (ICMD.NE.1) GO TO 90
         CALL SBDBUG (NFLD,ISTRT,IERR)
         LDEBUG=ISBUG(XGBOX)
         GO TO 50
C
90    IF (NXTFLD.GT.0) GO TO 110
C
C  CHECK FOR PAIRED PARENTHESES
100   CALL SUPFND (ILPFND,IRPFND,NPIFLD,NPCFLD)
C
110   IF (IENDIN.EQ.1) GO TO 190
C
C  CHECK IF DISP IS NEW AND ALL FIELDS FOUND
120   IF (INWFLG.EQ.0) GO TO 130
         IF (NUMFLD.NE.MINFLD) GO TO 210
            INWFLG=0
            IF (IENDIN.EQ.1) GO TO 730
            GO TO 40
C
C  CHECK FOR REPEATED NULL FIELD
130   IF (CHAR(1).NE.CKNULL(1).AND.CHAR(1).NE.CKNULL(2)) GO TO 160
         IF (LDEBUG.GT.0) WRITE (LP,910) NREP
         IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
         IF (NREP.GT.0.AND.NREP+NUMFLD.LE.MINFLD) GO TO 140
            WRITE (LP,920) NREP,NUMFLD,MINFLD
            CALL SUERRS (LP,2,NUMERR)
            NREP=MAXFLD-NUMFLD
140      IF (TDISP.EQ.OLD) GO TO 150
            NULREP=NREP
            INWFLG=1
            NOPFLD=0
            NXTFLD=0
            INULL=1
            GO TO 210
150      NUMFLD=NUMFLD+NREP
         GO TO 40
C
C  CHECK FOR COMMAND
160   IF (LATSGN.NE.1) GO TO 170
         IENDIN=1
         GO TO 100
C
C  CHECK FOR PARENTHESIS IN FIELD
170   IF (CHAR(1).EQ.LPAREN.AND.LENGTH.EQ.1) GO TO 210
      IF (CHAR(1).EQ.RPAREN.AND.LENGTH.EQ.1) GO TO 210
      IF (LLPAR.GT.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LLPAR-1,IERR)
      IF (LLPAR.EQ.0) CALL UFPACK (LCHK,CHK,ISTRT,1,LENGTH,IERR)
C
C  CHECK FOR END OF INPUT
      IF (CHK(1).NE.SLASH) GO TO 180
         IENDIN=1
         GO TO 100
C
C  IF FIRST FIELD, CONTENTS HAS BEEN CHECKED FOR KEYWORD
180   IF (NUMFLD.EQ.0) GO TO 210
C
C  CHECK FOR KEYWORD
      CALL SUIDCK (4HDEFN,CHK,NFLD,0,IKEYWD,IERR)
      IF (IERR.NE.2) GO TO 210
190      CALL SUPFND (ILPFND,IRPFND,NPIFLD,NPCFLD)
         IF (TDISP.EQ.NEW.AND.NUMFLD.LT.MINFLD) GO TO 200
            GO TO 730
200      INWFLG=1
         NOPFLD=0
         NXTFLD=0
         IENDIN=1
         IF (PRNOTE.EQ.XNO) GO TO 40
            WRITE (LP,1000)
            CALL SULINE (LP,2)
            GO TO 40
C
C  PRINT CARD
210   IF (NFLD.EQ.1.AND.NUMFLD.GT.0.AND.INWFLG.EQ.0) CALL SUPCRD
C
220   IF (NUMFLD.LE.MINFLD-1) GO TO 270
C
C  CHECK FOR OPTIONAL FIELDS
      IF (NUMFLD.GT.MAXFLD) GO TO 260
         IF (NOPFLD.GT.0.AND.CHAR(1).EQ.LPAREN.AND.LENGTH.EQ.1)
     *      GO TO 270
         IF (NOPFLD.GT.0.AND.CHAR(1).EQ.RPAREN.AND.LENGTH.EQ.1)
     *      GO TO 270
            DO 230 IOPTN=1,NOPTN
               CALL SUCOMP (2,CHK,OPTN(IOPTN),IMATCH)
               IF (IMATCH.EQ.1) GO TO 240
230            CONTINUE
         IF (NXTFLD.GT.0) GO TO 270
            WRITE (LP,880) NUMFLD,NFLD,CHAR
            CALL SUERRS (LP,2,NUMERR)
            GO TO 40
240      NOPFLD=0
         NXTFLD=0
         CALL SUPFND (ILPFND,IRPFND,NPIFLD,NPCFLD)
250      GO TO (490,640,640),IOPTN
            WRITE (LP,1080) IOPTN
            CALL SUERRS (LP,2,NUMERR)
            GO TO 40
C
260      WRITE (LP,900) NUMFLD,MAXFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 40
C
C  CHECK FOR PARENTHESES IN FIELD
270   IF (NOPFLD.EQ.0) CALL SUPFND (ILPFND,IRPFND,NPIFLD,NPCFLD)
      IF (LLPAR.GT.0) ILPFND=1
      IF (LRPAR.GT.0) IRPFND=1
C
      IF (LDEBUG.GT.0) WRITE (IOSDBG,830) NUMFLD,MINFLD,MAXFLD,NUMERR,
     *   NOPFLD,NXTFLD,CHK
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
C  CHECK IF FIELD WITH MORE THAN ONE POSSIBLE PARAMETER
      IF (NOPFLD.GT.0) GO TO (490),NOPFLD
C
C  CHECK IF MAXIMUM NUMBER OF FIELDS EXPECTED EXCEEDED
280   NUMFLD=NUMFLD+1
      IF (TDISP.EQ.OLD.AND.INULL.EQ.1) GO TO 40
C
      GO TO (290,320,370,420,450,490,640),NUMFLD
         WRITE (LP,890) CHAR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C    CHECK PARAMETER TYPE
C
290   IF (CHK(1).EQ.XGBOX) GO TO 300
         WRITE (LP,1050) CHK(1)
         CALL SUERRS (LP,2,NUMERR)
         GO TO 315
300   TYPE=CHK(1)
      IF (LDEBUG.GT.0) WRITE (IOSDBG,930) TYPE
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
C  CHECK IF UNITS SPECIFIED
      IF (LLPAR.EQ.0) GO TO 315
      IEND=LRPAR-1
      IF (LRPAR.GT.0) GO TO 310
         WRITE (LP,960) NUMFLD,NFLD
         CALL SULINE (LP,2)
         LRPAR=LENGTH-1
310   CALL UFPACK (LCHK,CHK,ISTRT,LLPAR+1,IEND,IERR)
      WRITE (LP,940) CHK(1),NFLD
      CALL SULINE (LP,2)
C
315   NUMADJ=0
      IBXMDR=0
      IOFLD1=0
      IOFLD2=0
      GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  GET GRID BOX IDENTIFIER
C
320   CALL SUBSTR (CHAR,1,8,GBOXID,1)
      IF (LDEBUG.GT.0) WRITE (IOSDBG,1220) GBOXID
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
C  CHECK IF GRID BOX EXISTS
      IPRERR=0
      IPTR=0
      INCLUDE 'scommon/callsrgbox'
      IF (IERR.GT.0) GO TO 325
      IF (LDEBUG.EQ.0) GO TO 325
      INCLUDE 'scommon/callspgbox'
325   IF (IERR.EQ.0.OR.IERR.EQ.2) GO TO 330
         NUMERR=NUMERR+1
         GO TO 40
C
C  GRID BOX EXIST AND DISP IS NEW
330   IF (IERR.EQ.0.AND.TDISP.EQ.NEW) GO TO 340
         GO TO 350
340   WRITE (LP,840) GBOXID
      CALL SUERRS (LP,2,NUMERR)
      GO TO 40
C
C  GRID BOX DOES NOT EXIST AND DISP IS OLD
350   IF (IERR.GT.0.AND.TDISP.EQ.OLD) GO TO 360
         GO TO 40
360   WRITE (LP,850) GBOXID
      CALL SUWRNS (LP,2,NUMWRN)
      TDISP=NEW
C
      GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  GRID BOX NUMBER
C
C  CHECK FOR NULL FIELD
370   IF (INULL.EQ.0) GO TO 380
         IF (TDISP.EQ.OLD) GO TO 690
            WRITE (LP,1010) NUMFLD,NFLD
            CALL SUERRS (LP,2,NUMERR)
            GO TO 690
C
C  CHECK IF INTEGER VALUE
380   IF (ITYPE.EQ.0) GO TO 390
         WRITE (LP,1070) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK FOR VALID VALUE
390   IF (INTEGR.GE.1.AND.INTEGR.LE.99) GO TO 400
         WRITE (LP,1090) INTEGR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK IF GRID BOX ALREADY USED
400   IF (IGBOX(INTEGR).EQ.0) GO TO 410
         WRITE (LP,1100) INTEGR
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  SET GRID BOX NUMBER
410   NUGBOX=INTEGR
      IF (LDEBUG.GT.0) WRITE (IOSDBG,1230) NUGBOX
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
      GO TO 690
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  GRID BOX LATITUDE - INPUT AS WHOLE DEGREES
C
420   IF (TDISP.EQ.NEW) BOXLOC(1)=UNDEF
      IF (INULL.EQ.0) GO TO 430
         IF (TDISP.EQ.OLD) GO TO 690
         WRITE (LP,1010) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK IF INTEGER VALUE
430   IF (ITYPE.EQ.0) GO TO 435
         WRITE (LP,1070) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK IF FALLS WHITHIN USER SPECIFIED LIMITS
435   IF (IUGFIL.EQ.0) GO TO 440
         IF (REAL.GE.ULLMTS(2).AND.REAL.LE.ULLMTS(1)) GO TO 440
            WRITE (LP,1110) REAL,ULLMTS(2),ULLMTS(1)
            CALL SUERRS (LP,2,NUMERR)
            GO TO 690
C
440   BOXLOC(1)=REAL
      IF (LDEBUG.GT.0) WRITE (IOSDBG,1240) BOXLOC(1)
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
      GO TO 690
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  GRID BOX LONGITUDE - INPUT AS WHOLE DEGREES
C
450   IF (TDISP.EQ.NEW) BOXLOC(2)=UNDEF
      IF (INULL.EQ.0) GO TO 460
         IF (TDISP.EQ.OLD) GO TO 480
         WRITE (LP,1010) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK IF INTEGER VALUE
460   IF (ITYPE.EQ.0) GO TO 465
         WRITE (LP,1070) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK IF FALLS WHITHIN USER SPECIFIED LIMITS
465   IF (IUGFIL.EQ.0) GO TO 470
         IF (REAL.GE.ULLMTS(3).AND.REAL.LE.ULLMTS(4)) GO TO 470
            WRITE (LP,1120) REAL,ULLMTS(3),ULLMTS(4)
            CALL SUERRS (LP,2,NUMERR)
            GO TO 690
C
470   BOXLOC(2)=REAL
      IF (LDEBUG.GT.0) WRITE (IOSDBG,1250) BOXLOC(2)
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
C  CHECK IF ANOTHER BOX IS AT THIS LOCATION
      DO 485 I=1,99
         IF (IGBOX(I).EQ.0) GO TO 485
            IF (GBOXLT(I).NE.BOXLOC(1).OR.GBOXLN(I).NE.BOXLOC(2))
     *         GO TO 485
               WRITE (LP,1125) I,BOXLOC
               CALL SUERRS (LP,2,NUMERR)
               GO TO 480
485      CONTINUE
C
480   GO TO 690
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  ADJACENT BOXES
C
C  CHECK WHICH FIELD TO BE PROCESSED
490   NGOTO=NXTFLD+1
      GO TO (500,560),NGOTO
C
C  CHECK IF OPTIONAL FIELD PREVIOUSLY PROCESSED
500   IF (IOFLD1.EQ.0) GO TO 510
         WRITE (LP,1160)
         CALL SUWRNS (LP,2,NUMWRN)
         NUMADJ=0
C
510   IOFLD1=1
C
C  CHECK FOR NULL FIELD
      IF (INULL.EQ.0) GO TO 520
         WRITE (LP,1020) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK FOR CHARACTER DATA
520   IF (ITYPE.EQ.2) GO TO 530
         WRITE (LP,1060) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK FOR PARENTHESES IN FIELD
530   IF (CHAR(1).NE.RPAREN) GO TO 540
         NOPFLD=0
         NXTFLD=0
         WRITE (LP,1170) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
540   IF (LLPAR.EQ.0) CHK(1)=CHAR(1)
      IF (LLPAR.GT.0) CALL SUBSTR (CHAR,1,LLPAR-1,CHK,1)
      CALL SUBSTR (OPTN(1),1,4,XCHK,1)
      IF (CHK(1).EQ.XCHK) GO TO 550
         WRITE (LP,1180) CHK(1),NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
550   NOPFLD=1
      NXTFLD=1
      IF (LLPAR.EQ.0.OR.LLPAR.EQ.LENGTH) GO TO 690
C
C  CHECK FOR SPECIAL CHARACTERS
560   IF (CHAR(1).EQ.LPAREN.AND.LENGTH.EQ.1) GO TO 690
      IF (ITYPE.NE.2) GO TO 580
         IF (LRPAR.NE.1) GO TO 570
         IF (NUMADJ.GT.0) GO TO 690
            WRITE (LP,1190)
            CALL SUERRS (LP,2,NUMERR)
            NOPFLD=0
            NXTFLD=0
            GO TO 690
570      IF (LRPAR.EQ.0.OR.LRPAR.EQ.LENGTH) GO TO 580
            WRITE (LP,1060) NUMFLD,NFLD
            CALL SUERRS (LP,2,NUMERR)
            NXTFLD=1
            GO TO 690
580   IF (LLPAR.EQ.0) IBEG=1
      IF (LLPAR.GT.0) IBEG=LLPAR+1
      IF (LASK.GT.0) IBEG=LASK+1
      IEND=LENGTH
      IF (LRPAR.EQ.0) GO TO 590
         IEND=LRPAR-1
         NOPFLD=0
         NXTFLD=0
590   CALL UFINFX (NADJBX,ISTRT,IBEG,IEND,IERR)
C
C  CHECK FOR MAXIMUM ADJACENT GRID BOXES
600   NUMADJ=NUMADJ+1
      IF (NUMADJ.LE.8) GO TO 610
         WRITE (LP,1140) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 625
C
C  CHECK FOR VALID GRID BOX NUMBER
610   IF (NADJBX.GE.0.AND.NADJBX.LE.99) GO TO 612
         WRITE (LP,1200) NUMADJ,NADJBX
         CALL SUERRS (LP,2,NUMERR)
         NXTFLD=1
         GO TO 625
C
C  CHECK IF GRID BOX NUMBER ALREADY SPECIFIED
612   IF (NUMADJ.EQ.1) GO TO 620
      IF (NADJBX.EQ.0) GO TO 620
      NUM=NUMADJ-1
      DO 614 I=1,NUM
         IF (IBXADJ(I).EQ.0) GO TO 614
         IF (NADJBX.NE.IBXADJ(I)) GO TO 614
            WRITE (LP,1205) NUMADJ,NADJBX
            CALL SUERRS (LP,2,NUMERR)
614      CONTINUE
C
C  SET GRID BOX
620   IBXADJ(NUMADJ)=NADJBX
      IF (LDEBUG.GT.0) WRITE (IOSDBG,1280) NUMADJ,IBXADJ(NUMADJ)
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
C
C  CHECK FOR REPEATED VALUES
625   IF (NREP.LE.1) GO TO 630
         NREP=NREP-1
         GO TO 600
C
630   NXTFLD=1
      IF (LRPAR.EQ.0) GO TO 690
         NOPFLD=0
         NXTFLD=0
         GO TO 690
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  MDR USAGE OPTION
C
640   CALL SUBSTR (OPTN(2),1,4,XCHK,1)
      CALL SUBSTR (OPTN(3),1,4,XCHK2,1)
C
C  CHECK IF NULL FIELD
      IF (INULL.EQ.0) GO TO 650
         IF (TDISP.EQ.OLD) GO TO 690
         CHAR(1)=XCHK2
         IF (PRNOTE.EQ.XNO) GO TO 660
            WRITE (LP,1040) NUMFLD,NPCFLD,CHAR(1)
            CALL SULINE (LP,2)
            GO TO 660
C
C  CHECK IF CHARACTER DATA
650   IF (ITYPE.EQ.2) GO TO 660
         WRITE (LP,1060) NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK FOR VALID VALUE
660   IF (CHAR(1).EQ.XCHK.OR.CHAR(1).EQ.XCHK2) GO TO 670
         WRITE (LP,1130) CHAR(1),NUMFLD,NFLD
         CALL SUERRS (LP,2,NUMERR)
         GO TO 690
C
C  CHECK IF MDR TO BE USED
670   IBXMDR=0
      IF (CHAR(1).EQ.XCHK) IBXMDR=1
      IF (LDEBUG.GT.0) WRITE (IOSDBG,1260) IBXMDR,CHAR(1)
      IF (LDEBUG.GT.0) CALL SULINE (IOSDBG,1)
      GO TO 690
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK FOR REPEATED NULL FIELDS
C
690   IF (NULREP.EQ.0) GO TO 700
         NULREP=NULREP-1
         IF (NULREP.NE.0) GO TO 280
            INWFLG=0
C
700   NPIFLD=NUMFLD
      NPCFLD=NFLD
C
C  CHECK FOR END OF INPUT
      IF (INWFLG.EQ.1) GO TO 40
      IF (IENDIN.EQ.1) GO TO 730
         GO TO 40
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  CHECK NUMBER OF FIELDS PROCESSED
730   IF (NUMFLD.GE.1) GO TO 740
         WRITE (LP,1330)
         CALL SUWRNS (LP,2,NUMWRN)
         GO TO 780
C
C  CHECK NUMBER OF ADJACENT GRID BOXES PROCESSED
740   IF (NUMADJ.EQ.8) GO TO 750
         WRITE (LP,1150) NUMADJ
         CALL SUERRS (LP,2,NUMERR)
C
C  WRITE GBOX PARAMETERS IF NO ERRORS ENCOUNTERED
750   IF (NUMERR.EQ.0) GO TO 760
         WRITE (LP,1290) GBOXID,NUMERR
         CALL SULINE (LP,2)
         ISTAT=1
         GO TO 780
C
C  CHECK IF RUNCHECK OPTION SPECIFIED
760   IF (IRUNCK.EQ.1) GO TO 780
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
C  WRITE GBOX PARAMETERS TO FILE
C
      IVGBOX=1
      WDISP=TDISP
      CALL SWGBOX (IVGBOX,GBOXID,NUGBOX,BOXLOC,IBXADJ,IBXMDR,
     *   UNUSED,UNSD,LARRAY,ARRAY,IPTR,WDISP,IERR)
      IF (IERR.EQ.0) GO TO 770
         ISTAT=1
         GO TO 780
C
770   IF (PRPARM.EQ.XNO) GO TO 775
C
C  READ GBOX PARAMETERS
      IPTR=0
      IPRERR=1
      INCLUDE 'scommon/callsrgbox'
      IF (IERR.GT.0) GO TO 780
C
C  PRINT GBOX PARAMETERS
      INCLUDE 'scommon/callspgbox'
C
C  ADD BOX TO COMMON BLOCK
775   IGBOX(NUGBOX)=1
      GBOXLT(NUGBOX)=BOXLOC(1)
      GBOXLN(NUGBOX)=BOXLOC(2)
      IGBOXM(NUGBOX)=IBXMDR
C
C  CHECK IF ANOTHER GRID BOX TO BE DEFINED
780   IF (CHK(1).NE.XGBOX) GO TO 785
         CALL SUPCRD
         NUMFLD=0
         NUMERR=0
         NUMWRN=0
         INWFLG=0
         NOPFLD=0
         NXTFLD=0
         NPIFLD=0
         GO TO 210
C
785   IF (ISTRCE.GT.0) WRITE (IOSDBG,1340)
      IF (ISTRCE.GT.0) CALL SULINE (IOSDBG,1)
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
790   FORMAT (' *** ENTER SFGBOX')
800   FORMAT (1H )
810   FORMAT ('0*--> DEFINE GRID BOX PARAMETERS')
820   FORMAT ('0DEFINE OPTIONS IN EFFECT :  DISP=',A4,3X,'PRPARM=',A4,
     *   3X,'PRNOTE=',A4,3X,'RUNCHECK=',A4)
830   FORMAT (' NUMFLD=',I2,3X,'MINFLD=',I2,3X,'MAXFLD=',I2,3X,
     *   'NUMERR=',I2,3X,'NOPFLD=',I2,3X,'NXTFLD=',I2,3X,'CHK=',5A4)
840   FORMAT ('0*** ERROR - DISPOSITION OF NEW WAS SPECIFIED FOR ',
     *   'GRID BOX ',2A4,' BUT GBOX PARAMETERS ALREADY EXIST.')
850   FORMAT ('0*** WARNING - GBOX PARAMETERS FOR GRID BOX ',2A4,
     *   ' DO NOT EXIST. DISP ASSUMED TO BE NEW.')
860   FORMAT ('0*** ERROR - PREPROCESSOR PARAMETRIC DATA BASE FILES ',
     *   'ARE NOT ALLOCATED. INPUT DATA WILL BE CHECKED FOR ERRORS.')
870   FORMAT ('0*** ERROR - GBOX PARAMETERS CANNOT BE DEFINED BECAUSE ',
     *   'GENERAL USER PARAMETERS NOT DEFINED.')
880   FORMAT ('0*** ERROR - INVALID DEFINE GBOX OPTION ',
     *   'IN INPUT FIELD ',I2,' (CARD FIELD ',I2,') : ',5A4)
890   FORMAT ('0*** ERROR - PROCESSING OPTION : ',5A4)
900   FORMAT ('0*** ERROR - FIELD ',I2,' EXCEEDS MAXIMUM ALLOWABLE ',
     *   'FIELDS (',I2,').')
910   FORMAT (' NUMBER OF NULL FIELDS TO BE REPEATED = ',I2)
920   FORMAT ('0*** ERROR - ',I3,' IS AN INVALID NUMBER OF NULL ',
     *   'TO BE REPEATED. CURRENT FIELD IS ',I2,'. MAXIMUM REQUIRED ',
     *   'FIELDS ALLOWED IS ',I2,'.')
930   FORMAT (' PARAMETER TYPE = ',A4)
940   FORMAT ('0*** NOTE - UNITS CODE (',A4,') FOUND IN CARD FIELD ',
     *   I2,' NOT USED FOR DEFINING GBOX PARAMETERS.')
950   FORMAT (' BLANK STRING FOUND IN FIELD ',I2)
960   FORMAT ('0*** NOTE - RIGHT PARENTHESES ASSUMED IN INPUT FIELD ',
     *   I2,' (CARD FIELD ' ,I2,').')
970   FORMAT ('0*** NOTE - RIGHT PARENTHESES ASSUMED IN INPUT FIELD ',
     *   I2,'+ (CARD FIELD ' ,I2,').')
980   FORMAT (' INPUT FIELD = ',5A4)
990   FORMAT ('0*** ERROR - THE KEYWORD  ',2A4,'  WAS FOUND WHEN ',
     *   'ANOTHER GBOX FIELD WAS EXPECTED.')
1000  FORMAT ('0*** NOTE - REMAINING GBOX PARAMETERS WILL ',
     *   'BE FILLED WITH DEFAULT VALUES.')
1010  FORMAT ('0*** ERROR - NO VALUE FOUND FOR REQUIRED INPUT FIELD ',
     *   I2,' (CARD FIELD ',I2,').')
1020  FORMAT ('0*** ERROR - NO VALUE FOUND FOR OPTIONAL INPUT FIELD ',
     *   I2,' (CARD FIELD ',I2,').')
1030  FORMAT ('0*** NOTE - NO VALUE FOUND FOR REQUIRED INPUT FIELD ',
     *   I2,' (CARD FIELD ',I2,'). DEFAULT VALUE (',I4,
     *   ') WILL BE USED.')
1040  FORMAT ('0*** NOTE - NO VALUE FOUND FOR REQUIRED INPUT FIELD ',
     *   I2,' (CARD FIELD ',I2,'). DEFAULT VALUE (',A4,
     *   ') WILL BE USED.')
1050  FORMAT ('0*** ERROR - INVALID DEFINE GBOX PARAMETER TYPE : ',A4)
1060  FORMAT ('0*** ERROR - NON-CHARACTER DATA EXPECTED IN INPUT ',
     *   'FIELD ',I2,' (CARD FIELD ',I2,').')
1070  FORMAT ('0*** ERROR - INTEGER DATA EXPECTED IN INPUT ',
     *   'FIELD ',I2,' (CARD FIELD ',I2,').')
1080  FORMAT ('0*** ERROR - PROCESSING DEFINE GBOX OPTION ',
     *   'NUMBER ',I2,'.')
1090  FORMAT ('0*** ERROR - GRID BOX NUMBER (',I2,
     *   ') IS INVALID. VALID VALUES ARE 1 THRU 99.')
1100  FORMAT ('0*** ERROR - GRID BOX NUMBER (',I2,
     *   ') IS CURRENTLY BEING USED.')
1110  FORMAT ('0*** ERROR - GRID BOX LATITUDE (',F5.0,') DOES NOT ',
     *   'FALL WITHIN USER DEFINED LIMITS (',F9.2,' TO ',F9.2,').')
1120  FORMAT ('0*** ERROR - GRID BOX LONGITUDE (',F5.0,') DOES NOT ',
     *   'FALL WITHIN USER DEFINED LIMITS (',F9.2,' TO ',F9.2,').')
1125  FORMAT ('0*** ERROR - GRID BOX NUMBER ',I2,' IS ALREADY LOCATED ',
     *   'AT LATITUDE ',F5.0,' AND LONGITUDE ',F5.0,'.')
1130  FORMAT ('0*** ERROR - INVALID MDR USAGE ',
     *   'OPTION (',A4,') IN INPUT FIELD ',I2,' (CARD FIELD ',I2,').')
1140  FORMAT ('0*** ERROR - MAXIMUM NUMBER OF ADJACENT GRID BOXES ',
     *   '(8) EXCEEDED IN INPUT FIELD ',I2,'+ (CARD FIELD ',I2,').')
1150  FORMAT ('0*** ERROR - NUMBER OF ADJACENT BOXES ',
     *   '(',I2,') DOES NOT EQUAL 8.')
1160  FORMAT ('0*** WARNING - BOXES ADJACENT TO THIS BOX HAVE ',
     *   'ALREADY BEEN DEFINED.')
1170  FORMAT ('0*** ERROR - NO BOXES ADJACENT TO THIS BOX ',
     *   'FOUND IN INPUT FIELD ',I2,' (CARD FIELD ',I2,').')
1180  FORMAT ('0*** ERROR - PROCESSING TEMPERATURE CORRECTION ',
     *   'FACTOR INDICATOR (',A4,') IN INPUT FIELD ',I2,' (CARD FIELD ',
     *   I2,').')
1190  FORMAT ('0*** ERROR - NO BOXES ADJACENT TO THIS BOX FOUND.')
1200  FORMAT ('0*** ERROR - ADJACENT GRID BOX NUMBER ',I2,' MUST BE ',
     *   'GREATER THAN 0 AND LESS THAN 100. VALUE INPUT IS ',I3,'.')
1205  FORMAT ('0*** ERROR - ADJACENT GRID BOX NUMBER ',I2,' (',I2,
     *   ') ALREADY SPECIFIED.')
1220  FORMAT (' GRID BOX IDENTIFIER SET TO : ',2A4)
1230  FORMAT (' GRID BOX NUMBER SET TO : ',I2)
1240  FORMAT (' GRID BOX LATITUDE SET TO : ',F9.2)
1250  FORMAT (' GRID BOX LONGITUDE SET TO : ',F9.2)
1260  FORMAT (' MDR USAGE INDICATOR SET TO : ',I6,2X,'(',A4,')')
1280  FORMAT (' ADJACENT GRID BOX ',I2,' SET TO : ',I2)
1290  FORMAT ('0*** NOTE - GBOX PARAMETERS FOR GRID BOX ',2A4,
     *   ' NOT WRITTEN BECAUSE ',I2,' ERRORS ENCOUNTERED.')
1320  FORMAT ('0*** WARNING - CONTENTS OF CARD FIELD ',I2,' IS NOT A ',
     *   'KEYWORD : ',5A4)
1330  FORMAT ('0*** WARNING - NO GBOX PARAMETER VALUES FOUND.')
1340  FORMAT (' *** EXIT SFGBOX')
C
      END