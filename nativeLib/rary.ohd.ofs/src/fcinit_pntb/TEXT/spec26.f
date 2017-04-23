C MODULE SPEC26
C---------------------------------------------------------------------
C
C  READS ALL INPUT FOR SPECIFIC SECTION OF OPERATION 26 PIN ROUTINE.
C
      SUBROUTINE SPEC26 (WORK,IUSEW,LEFTW,ISUIN,NPARSU,NTSSU,NCOSU,
     *   OKSPEC)
C
C  ARGS:
C     WORK - ARRAY TO HOLD ENCODED SPECIFIC INFORMATION
C    IUSEW - NO. OF WORDS ALREADY USED IN WORK ARRAY
C    LEFTW - NO. OF WORDS REMAINING IN WORK ARRAY
C   NPARSU - NO. OF WORDS NEEDED TO HOLD SPECIFIC PARM INFO
C    NTSSU - NO. OF WORDS NEEDED TO HOLD SPECIFIC TS INFO
C    NCOSU - NO. OF WORDS NEEDED TO HOLD SPECIFIC CARRYOVER INFO
C   OKSPEC - LOGICAL VARIABLE TELLING WHETHER ANY MISTAKES OCCURRED IN
C            SPECIFIC SECTION INPUT.
C
      INCLUDE 'common/ionum'
      INCLUDE 'common/read26'
      INCLUDE 'common/fld26'
      INCLUDE 'common/err26'
      INCLUDE 'common/warn26'
      INCLUDE 'common/comn26'
      INCLUDE 'common/suid26'
      INCLUDE 'common/suin26'
      INCLUDE 'common/mult26'
      INCLUDE 'common/rc26'
C
      DIMENSION LINE(20),ENDSP(2),TNAME(3),LEVEL(27),WORK(1),SUNO(27)
C
      LOGICAL OKSPEC
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_pntb/RCS/spec26.f,v $
     . $',                                                             '
     .$Id: spec26.f,v 1.7 2001/06/13 10:12:30 mgm Exp $
     . $' /
C    ===================================================================
C
C
C      DATA BLANK/4H    /
      DATA ENDSP/4HENDS,4HPEC /
      DATA SUNO/4HSU01,4HSU02,4HSU03,4HSU04,4HSU05,4HSU06,4HSU07,4HSU08,
     &4HSU09,4HSU10,4HSU11,4HSU12,4HSU13,4HSU14,4HSU15,4HSU16,
     &4HSU17,4HSU18,4HSU19,4HSU20,4HSU21,4HSU22,4HSU23,4HSU24,
     &4HSU25,4HSU26,4HSU27/
C
C  INITIALIZE COUNTERS AND LOCAL VARIABLES
C
      OKSPEC = .TRUE.
      USEDUP = .FALSE.
      NSUIN = 0
      NPARSU = 0
      NTSSU = 0
C
C  SIX TIME-SERIES REQUIRING ID SPACE HAVE BEEN STORED BY GTS26
C
      NTSPAC = 6
C
      NCOSU = 0
      NUMERR = 0
      NUMWRN = 0
      NPACK = 3
      IERR = 0
      DO 1 I=1,27
      LEVEL(I) = 0
    1 CONTINUE
C
      DO 2 I=1,10
      NMDEF(I) = 0
      NRC26(I) = 0
    2 CONTINUE
C
      NPARXX = 0
      NTSXX = 0
      NTSPXX = 0
      NCOXX = 0
      NXTPTR = 0
C
C  SET SECTION VALUE TO INDICATE END OF INPUT FOR UFLD26.
C  SET OFFSET FOR START OF INFO IN SPECIFIC SECTION
C
      ISECT = 2
      NSUOFF = IUSEW
C
C  CHECK FOR INPUT OF 'SPECIFIC' KEYWORD. JUST SET 'NO INPUT' VALUES IF
C  'SPECIFIC' NOT ENTERED.
C
      IF (LSPEC.LE.0) GO TO  8
C
C  ALSO, AN 'ENDSPEC' STATEMENT MUST HAVE BEEN FOUND IN THE INPUT STREAM
C  FOR DEFINITION OF THIS OPERATION
C
      IF (NSPEC.GT.0) GO TO 4
C
      WRITE(IPR,901)
  901 FORMAT('0**ERROR**'/16X,'NO ''ENDSPEC'' KEYWORD HAS BEEN ',
     .'FOUND IN THE INPUT STREAM.'/16X,'THIS KEYWORD IS NECESSARY TO ',
     .'PROCESS THE SPECIFIC SUBSECTION'/16X,'OF THE ''RES-SNGL'' '
     .,' OPERATION.')
      OKSPEC = .FALSE.
      CALL ERROR
      GO TO 9999
C
    4 CONTINUE
C
C------------------------------------------------------------------
C  RESERVE FIRST 5 WORDS OF SPECIFIC SECTION. THESE WILL BE REFILLED
C  LATER WITH THE NO. OF S/U'S INPUT, AND THE NO. OF WORDS TO STORE
C  PARMS, TIME-SERIES (AND NO. OF ID'S) AND CO INFO.
C
    8 CONTINUE
      DO 9 I=1,5
         CALL FLWK26 (WORK,IUSEW,LEFTW,-999.0,501)
    9    CONTINUE
C
C  IF NO 'SPECIFIC' HAS BEEN ENTERED, JUST RESET USE VALUES IN WORK
C
      IF (LSPEC .LE. 0) GO TO 5000
C
C--------------------------------------------------------------------
C  NOW LOOK FOR VALID S/U IDENTIFIERS OR AN ENDSPEC KEYWORD
C
      ISSTRT = LSPEC+1
      NSPEC2 = NSPEC - 1
      CALL POSN26(MUNI26,ISSTRT)
      NCARD = 0
   10 IF (NCARD.GE.NSPEC2) GO TO 5000
C
C  INCREMENT NO. OF WORDS NEEDED TO STORE PARM, TS, AND CO INFO IN FINAL
C  PO FORMAT
C
      NPARSU = NPARSU + NPARXX
      NTSSU = NTSSU + NTSXX
      NTSPAC = NTSPAC + NTSPXX
      NCOSU = NCOSU + NCOXX
C
      NPMENT = NPMENT + NPARXX
C
C  REFILL POINTER TO THIS S/U IN WORK, AND REFILL THE LOCATIONS HOLDING
C  VALUES FOR  NO. OF WORDS NEEDED TO STORE PARMS, TS'S ANC CO VALUES.
C
      IF (NXTPTR.EQ.0) GO TO 20
      SUNLOC = IUSEW + 1.01
      CALL RFIL26(WORK,NXTPTR,SUNLOC)
C
      PARXX = NPARXX + 0.01
      TSXX = NTSXX + 0.01
      COXX = NCOXX + 0.01
C
      CALL RFIL26(WORK,NXTPTR+2,PARXX)
      CALL RFIL26(WORK,NXTPTR+4,TSXX)
      CALL RFIL26(WORK,NXTPTR+6,COXX)
C
   20 CONTINUE
      NUMFLD = 0
   25 CALL UFLD26(NUMFLD,IERF)
      IF (IERF.GT.0) GO TO 9000
C
C  GET S/U ID AND LEVEL NUMBER
C
      CALL IDWP26(TNAME,NPACK,INAME,INTVAL,IERID)
      IGO = IERID + 1
      GO TO (60,30,90,20), IGO
C
C  NO VALID S/U ID FOUND, SEE IF ENDSPEC FOUND
   30 IF (IUSAME(TNAME,ENDSP,2).EQ.1) GO TO 5000
C     NAME NOT ALLOWED AS S/U IDENTIFIER
         IF (IERR .NE. 99) CALL STER26(7,1)
         GO TO 10
C
C  CHECK IF LEVEL OF S/U DEFINITION IS 1 GREATER THAN PREVIOUS
C  DEFINITION.
   60 IDIF = INTVAL - LEVEL(INAME)
      IF (IDIF.EQ.1) GO TO 70
         CALL STER26(52,IBGN)
         GO TO 90
C
C  UPDATE LEVEL OF DEFINITION OF S/U
   70 LEVEL(INAME) = LEVEL(INAME) + 1
C
      IF (NSUIN.LT.50) GO TO 80
C     CAN'T HOLD MORE THAN 50 DEFINITIONS OF S/U'S
         CALL STER26(505,1)
         GO TO 90
C
C  COMPUTE AND STORE THE S/U CODE NUMBER IN WORK ARRAY AND /SUIN26/
   80 NSUIN = NSUIN + 1
CCC      SULEVL = INTVAL + .01
      SULEVL = INTVAL
      DEFCDE(NSUIN) = SUCODE(INAME) + SULEVL
      IF (IBUG.GE.1) WRITE (IPR,*) 'IN SPEC26 - NSUIN=',NSUIN,
     *   ' DEFCDE(NSUIN)=',DEFCDE(NSUIN)
      CALL FLWK26 (WORK,IUSEW,LEFTW,DEFCDE(NSUIN),501)
C
C  RESERVE NEXT WORD IN WORK FOR POINTER TO START OF NEXT S/U, AND
C  RESERVE LOCATIONS FOR HOLDING LOCATIONS AND NO. OF WORDS TO STORE
C  PARMS, TS'SND CO VALUES.
C
      CALL FLWK26(WORK,IUSEW,LEFTW,-999.0,501)
      NXTPTR = IUSEW
      DO 87 I=1,6
         CALL FLWK26(WORK,IUSEW,LEFTW,0.01,501)
   87    CONTINUE
C
C  SET LOCATIONS FOR STORING STARTS OF PARM, TS, AND CO INFO FOR THE
C  SCHEME.
C
      LOCPXX = NXTPTR + 1
      LOCTXX = NXTPTR + 3
      LOCCXX = NXTPTR + 5
C
C-----------------------------------------------------------------
C  NOW GO TO PROPER ROUTINE TO GET PARM, TS AND CO INFO FOR THE
C  S/U
C
   90 CONTINUE
      LPOSXX = LSPEC + NCARD + 1
      IGOTO=INAME
      GO TO (100,200,300,400,500,600,700,800,900,1000,1100,1200,
     . 1300,1400,1500,1600,1700,1800,1900,2000,2100,2200,2300,2400,
     . 2500,2600,2700,25), IGOTO
C
C------------------------------------------------------------
C  'PASSFLOW' FOUND
C
  100 CONTINUE
      ASU=SUNO(1)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0126(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C------------------------------------
C  'SETQ' FOUND'
C
  200 CONTINUE
      ASU=SUNO(2)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0226(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C-------------------------------------
C  'SETH' FOUND
C
  300 CONTINUE
      ASU=SUNO(3)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0326(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------------
C  'RULECURVE' FOUND
C
  400 CONTINUE
      ASU=SUNO(4)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0426(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------------
C  'FILLSPILL' FOUND
C
  500 CONTINUE
      ASU=SUNO(5)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0526(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------
C  'SPILLWAY' FOUND
C
  600 CONTINUE
      ASU=SUNO(6)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0626(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------
C  'POOLQ' FOUND
C
  700 CONTINUE
      ASU=SUNO(7)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0726(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------
C  ' STPOOLQ' FOUND
C
  800 CONTINUE
      ASU=SUNO(8)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0826(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------
C  'MINQ' FOUND
C
  900 CONTINUE
      ASU=SUNO(9)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU0926(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------
C  'MINH' FOUND
C
 1000 CONTINUE
      ASU=SUNO(10)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1026(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C---------------------------------
C  'INDSRCHGE' FOUND
C
 1100 CONTINUE
      ASU=SUNO(11)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1126(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C---------------------------------
C  'FLASHBDS' FOUND
C
 1200 CONTINUE
      ASU=SUNO(12)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1226(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C---------------------------------
C  'POWERGEN' FOUND
C
 1300 CONTINUE
      ASU=SUNO(13)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1326(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C---------------------------------
C  'RULEADJ' FOUND
C
 1400 CONTINUE
      ASU=SUNO(14)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1426(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------
C  'SUMINF' FOUND
C
 1500 CONTINUE
      ASU=SUNO(15)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1526(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------
C  'RAINEVAP' FOUND
C
 1600 CONTINUE
      ASU=SUNO(16)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1626(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------
C  'ADJUST' FOUND
C
 1700 CONTINUE
      ASU=SUNO(17)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1726(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C-------------------------------
C  'BACKFLOW' FOUND
C
 1800 CONTINUE
      ASU=SUNO(18)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU1826(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C-------------------------------
C  'CONV24' FOUND. THIS UTILITY HAS BEEN REMOVED, SO JUST RETURN TO THE
C   TOP.
C
 1900 CONTINUE
      ASU=SUNO(19)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      GO TO 10
C
C-------------------------------
C  'MAXQ' FOUND
C
 2000 CONTINUE
      ASU=SUNO(20)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU2026(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C-------------------------------
C  'ENTERISC' FOUND
C
 2100 CONTINUE
      ASU=SUNO(21)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU2126(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C----------------------------------
C  'SETMIN' FOUND
C
 2200 CONTINUE
      ASU=SUNO(22)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU2226(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C---------------------------------
C  'SETMAX' FOUND
C
 2300 CONTINUE
      ASU=SUNO(23)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU2326(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C---------------------------------
C  'GOFLASH' FOUND
C
 2400 CONTINUE
      ASU=SUNO(24)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU2426(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C------------------------------------
C     'WATERUSE' FOUND'
C
 2500 CONTINUE
C      ASU=SUNO(25)
C      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
C      CALL SU2526(WORK,IUSEW,LEFTW,IERR)
C
C      IF (IERR.NE.99) GO TO 10
C      NUMFLD = -1
      GO TO 25
C
C------------------------------------
C     'SETDQ' FOUND'
C
 2600 CONTINUE
      ASU=SUNO(26)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU2626(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C------------------------------------
C     'SETDH' FOUND'
C
 2700 CONTINUE
      ASU=SUNO(27)
      IF (IBUG .GE. 2) WRITE(IPR,890) ASU
      CALL SU2726(WORK,IUSEW,LEFTW,IERR)
C
      IF (IERR.NE.99) GO TO 10
      NUMFLD = -1
      GO TO 25
C
C--------------------------------------------------------------
C  DONE PROCESSING ALL INPUT FOR SPECIFIC SUBSECTION
C
C  REFILL FIRST 5 POSITIONS IN SPECIFIC SUBSECTION OF WORK ARRAY WITH
C  THE NO. OF S/U'S INPUT, AND THE NO. OF WORDS NEEDED TO STORE THE
C  PARMS, TIME-SERIES (AND NO. OF TS ID'S), AND CO VALUES IN PO FORMAT.
C
 5000 CONTINUE
      SUIN = NSUIN + 0.01
      CALL RFIL26(WORK,NSUOFF+1,SUIN)
C
      PARSU = NPARSU + 0.01
      CALL RFIL26(WORK,NSUOFF+2,PARSU)
C
      TSSU = NTSSU + 0.01
      CALL RFIL26(WORK,NSUOFF+3,TSSU)
C
      TSPACE = NTSPAC + 0.01
      CALL RFIL26(WORK,NSUOFF+4,TSPACE)
C
      COSU = NCOSU + 0.01
      CALL RFIL26(WORK,NSUOFF+5,COSU)
      GO TO 9999
C
C--------------------------------------------------------------------
C  ERROR IN UFLD26
C
 9000 CONTINUE
      IF (IERF.EQ.1) CALL STER26(19,1)
      IF (IERF.EQ.2) CALL STER26(20,1)
      IF (IERF.EQ.3) CALL STER26(21,1)
      IF (IERF.EQ.4) CALL STER26( 1,1)
C
      IF (NCARD.LT.NSPEC2) GO TO 10
C
      USEDUP = .TRUE.
C
 9999 CONTINUE
      ISUIN = NSUIN
      IF (NUMERR.EQ.0.AND.NUMWRN.EQ.0.AND.IBUG.LT.2) RETURN
      IF (LSPEC .LE. 0) RETURN
C
C  POSITION TO START OF SPECIFIC SECTION INPUT AND PRINT INPUT WITH
C  LINE NUMBERS.
C
      WRITE(IPR,920)
  920 FORMAT(1H1,' *** SPECIFIC SECTION INPUT FOR THIS OPERATION ',
     .'DEFINITION ***'//)
C
      ISSTRT = LSPEC+1
      CALL POSN26(MUNI26,ISSTRT)
C
      NSPEC2 = NSPEC - 1
      IF (NSPEC2.GT.0) GO TO 5
      CALL STER26(86,1)
      GO TO 9999
C
    5 CONTINUE
      DO  6 I=1,NSPEC2
      READ(MUNI26,891) LINE
      WRITE(IPR,892) I,LINE
    6 CONTINUE
C
  890 FORMAT(1X,'** RES-SNGL  ',A4,'26  ENTERED')
  891 FORMAT(20A4)
  892 FORMAT(1H ,'(',I3,')',1X,20A4)
      CALL WNOT26
      CALL EROT26
      IF (NUMERR.GT.0) OKSPEC = .FALSE.
      NUMWRN = 0
      NUMERR = 0
C
      RETURN
      END