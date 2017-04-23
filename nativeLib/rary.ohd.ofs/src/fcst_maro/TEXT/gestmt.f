C MEMBER GESTMT
C  (from old member PPGESTMT)
C
C @PROCESS LVL(77)
C
C                             LAST UPDATE: 01/07/94.12:03:07 BY $WC21DT
C
C
      SUBROUTINE GESTMT(NGBOX, ISTATC, GBOXPY, WQWGT, NADJ, NQPCP,
     * NQGRD, NQSEQ, PG24)
C
C.....THIS IS THE GRID POINT PRECIPITATION ESTIMATION SUBROUTINE. THIS
C.....SUBROUTINE ESTIMATES MISSING PRECIPITATION FOR THE WGRFC GRID
C.....POINT PRECIPITATION NETWORK. ESTIMATIONS ARE MADE FOR EACH GRID
C.....POINT FOR WHICH NO OBSERVATION IS AVAILABLE.
C
C.....ESTIMATION ALGORITHM...
C
C.....AROUND THE GRID POINT BEING ESTIMATED FOR, DEFINE 4 QUADRANTS,
C.....USING THE ACCEPTED TRIGONOMETRIC QUADRANT NUMBERING SCHEME.
C.....QUADRANTS 1 AND 3 CONSIST OF 10 ROWS OF 9 GRID POINTS EACH,
C.....WHILE QUADRANTS 2 AND 4 CONSIST OF 9 ROWS OF 10 GRID POINTS
C.....EACH.  USING THE APPROPRIATE PROXIMITY FUNCTION CONSTANTS
C.....CONTAINED IN ARRAYS INQD1 AND INQD2, SEARCH EACH QUADRANT FOR THE
C.....'NUMQDT' CLOSEST PRECIPITATION OBSERVATIONS IN EACH QUADRANT.
C.....MULTIPLY THE PRECIPITATION BY ITS 'WEIGHT' (SEE NEXT PARAGRAPH)
C.....TO GET ITS 'EFFECTIVE PRECIPITATION'. THE PRECIPITATION VALUES IN
C.....EACH QUADRANT IN THE ESTIMATION IS THE ACCUMULATED EFFECTIVE
C.....PRECIPITATION IN THAT QUADRANT.
C
C.....NOTE ON WEIGHTS --- THE PRECIPITATION WEIGHT IS DEFINED AS
C.....WEIGHT = (1.0/WATE(N)**2) WHERE WATE IS WATE1 OR WATE2 AS
C.....APPROPRIATE, AND N IS THE POSITION IN THE PROXIMITY FUNCTION
C.....ARRAY WHERE THE PRECIPITATION IS FOUND. WATE IS THE DISTANCE
C.....IN NAUTICAL MILES FROM THE GRID POINT.
C
C.....THE ESTIMATED PRECIPITATION IS THE SUM OF THE EFFECTIVE
C.....PRECIPITATION VALUES IN EACH QUADRANT DIVIDED BY THE SUM OF THE
C.....WEIGHTS...EXCEPT THAT IF THERE IS ONLY A SINGLE PRECIPITATION
C.....REPORT AVAILABLE...OR THERE IS ONLY PRECIPITATION AVAILABLE IN
C.....A SINGLE QUADRANT...OR THERE IS ONLY PRECIPITATION AVAILABLE IN
C.....TWO ADJACENT QUADRANTS...DO NOT DIVIDE BY THE SUM OF THE WEIGHTS.
C
C.....HERE IS THE ARGUMENT LIST:
C
C.....NGBOX  - A BEGINNING ADDRESS POINTER FOR THE GBOX PARAMETRIC
C.....         ARRAY (THE ADJACENCY MATRIX). THIS POINTER IS INITIALLY
C.....         SET TO ZERO, AND IS SET TO 1 AFTER THE GBOX PARAMETRIC
C.....         ARRAY IS READ IN, AND PLACED BEGINNING IN THE FIRST
C.....         AVAILABLE ADDRESS OF THE WORK ARRAY . THIS
C.....         ADDRESS IS LATER PASSED TO OTHER ROUTINES.
C.....ISTATC - THE STATUS CODE RETURNED FROM THE PARAMETRIC ARRAY
C.....         ROUTINE FOR THE GBOX PARAMETRIC ARRAY.
C.....                = 0   NORMAL RETURN.
C.....            NOT = 0   ERROR RETURN CODE FROM RPPREC.
C.....GBOXPY - STORAGE LOCATION TO STORE THE GBOX PARAMETRIC ARRAY.
C.....         THIS IS A TEMPORARY LOCATION.
C.....WQWGT  - THE DISTANCE WEIGHT PICKED OUT FOR THE QUADRANTS AT THE
C.....         SAME TIME THE PRECIPITATION (NQPCP) IS PICKED.
C.....NADJ   - PERMANENT LOCATION OF ADJACENCY MATRIX. THE CONTENTS OF
C.....         GBOXPY IS MOVED TO THE BEGINNING ADDRESS INDICATED BY
C.....         NADJ AT THE CONCLUSION OF THE SUBROUTINE.
C.....NQPCP  - THE PRECIPITATION PICKED OUT FOR THE QUADRANTS.
C.....NQGRD  - THE GRID ADDRESSES PICKED OUT FOR THE QUADRANTS.
C.....NQSEQ  - A SEQUENCE NUMBER THAT SPECIFIES THE ORDER IN WHICH THE
C.....         PRECIP (NQPCP) AND GRID ADDRESS (NQGRD) WERE PICKED OUT.
C.....PG24   - THE 24-HOUR PRECIPITATION ARRAY.
C
C.....THIS SUBROUTINE HAS BEEN ADAPTED FROM THE WGRFC GRID POINT
C.....ESTIMATION SUBROUTINE CALLED 'ESTMT'. SUBROUTINE ESTMT IS A PART
C.....OF THE WGRFC RAINFALL PROCESSING/RUNOFF COMPUTATION PROGRAM CALLED
C.....'ONECL' (ONE CALL).
C
C.....ADAPTATION DONE BY
C
C.....JERRY M. NUNN       WGRFC FT. WORTH, TEXAS       SEPTEMBER 1986
C
C.....THE GRID POINT PROCESSING SOFTWARE WAS ORIGINALLY DEVELOPED
C.....IN OCTOBER 1975 BY...
C
C.....DAVID SMITH...JERRY M. NUNN...PHIL PASTERIS.
C
C.....02/05/90   FIXED DO-LOOP WHERE GBOX PARAMETRIC ARRAY WAS BEING
C.....           COPIED TO ADJACENCY MATRIX.  THE DO-LOOP COUNTERS
C.....           WERE NOT BEING INCREMENTED.
C.....           JERRY M. NUNN       WGRFC
C
C.....02/09/90   FIXED ARRAY POINTERS THAT WERE BEING USED AS POINTERS
C.....           TO THE STORAGE LOCATIONS OF PRECIPITATION AND GRIDD
C.....           ADDRESSES FOUND AS PART OF THE GRID BOX SEARCH. THE
C.....           SEARCH WAS TURNING UP ZEROS IN QUADRANTS II AND IV.
C.....           JERRY M. NUNN       WGRFC
C
C.....07/11/91   EXTENSIVE CODE MODIFICATIONS MADE TO SUPPORT A MORE
C.....           EFFICIENT METHOD OF MAKING PRECIPITATION ESTIMATIONS.
C.....           JERRY M. NUNN       WGRFC
C
C.....06/08/92   MINOR CODE MODIFICATIONS MADE TO CORRECT A PROBLEM
C.....           THAT WAS CAUSING ABNORMAL PROGRAM TERMINATION WHEN
C.....           NO MDR PROCESSING WAS SPECIFIED.
C.....           JERRY M. NUNN       WGRFC
C
      INCLUDE 'gcommon/explicit'
C
      INTEGER*2 NQPCP(1), NQGRD(1), NQSEQ(1), PG24(1), PX24, NSQUAD(4)
C
      DIMENSION PBOXID(2), DBNAME(2), IADJ(8), GBOXPY(1), NADJ(1)
      DIMENSION GBOXID(2), SNAME(2), NBOX(9), WQWGT(1)
      DIMENSION NXQ1(90), NYQ1(90), NXQ2(90), NYQ2(90)
      DIMENSION NXQ3(90), NYQ3(90), NXQ4(90), NYQ4(90)
      DIMENSION NEWBOX(3), WATE1(90), WATE2(90)
C
      INCLUDE 'common/where'
      INCLUDE 'common/ionum'
      INCLUDE 'gcommon/gsize'
      INCLUDE 'gcommon/gdate'
      INCLUDE 'gcommon/gopt'
      INCLUDE 'gcommon/gdispl'
      INCLUDE 'common/pudbug'
      INCLUDE 'common/errdat'
      INCLUDE 'gcommon/boxtrc'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_maro/RCS/gestmt.f,v $
     . $',                                                             '
     .$Id: gestmt.f,v 1.1 1995/09/17 19:01:37 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA SNAME, GBOXID, GBOX /4HGEST, 4HMT  , 2*4H    , 4HGBOX/
      DATA GEST, IQWDIM /4HGEST, 90/
C
C.....THE NEXT EIGHT DATA STATEMENTS ARE TABLES OF X AND Y OFFSETS
C.....FOR EACH QUADRANT...ARRANGED IN THE ORDER IN WHICH THE OFFSETS
C.....ARE TO BE PICKED.  IT IS WITH THESE OFFSETS AND THE GRID BOX OF
C.....THE GRID POINT BEING ESTIMATED THAT SURROUNDING GRID ADDRESSES
C.....ARE COMPUTED...AND THEIR OBSERVED PRECIPITATION USED.
C
C.....NXQ1 AND NYQ1 ARE THE X AND Y OFFSETS FOR QUADRANT 1.
C
      DATA NXQ1 / -1, -1, -2, -2, -1, -3, -2, -3, -1, -3,
     *            -2, -4, -4, -3, -4, -1, -2, -5, -5, -4,
     *            -3, -5, -1, -6, -2, -5, -4, -6, -6, -3,
     *            -5, -6, -1, -4, -7, -7, -2, -7, -3, -6,
     *            -5, -7, -4, -8, -1, -8, -2, -6, -8, -7,
     *            -5, -3, -8, -4, -9, -7, -9, -6, -1, -8,
     *            -9, -2, -5, -3, -9, -7, -8, -4, -6, -9,
     *            -1, -5, -2, -8, -7, -9, -3, -6, -4, -8,
     *            -9, -5, -7, -6, -9, -8, -7, -9, -8, -9/
C
      DATA NYQ1 /  0,  1,  0,  1,  2,  0,  2,  1,  3,  2,
     *             3,  0,  1,  3,  2,  4,  4,  0,  1,  3,
     *             4,  2,  5,  0,  5,  3,  4,  1,  2,  5,
     *             4,  3,  6,  5,  0,  1,  6,  2,  6,  4,
     *             5,  3,  6,  0,  7,  1,  7,  5,  2,  4,
     *             6,  7,  3,  7,  0,  5,  1,  6,  8,  4,
     *             2,  8,  7,  8,  3,  6,  5,  8,  7,  4,
     *             9,  8,  9,  6,  7,  5,  9,  8,  9,  7,
     *             6,  9,  8,  9,  7,  8,  9,  8,  9,  9/
C
C.....NXQ2 AND NYQ2 ARE THE X AND Y OFFSETS FOR QUADRANT 2.
C
      DATA NXQ2 /  0,  1,  0,  2,  1,  2,  3,  0,  1,  3,
     *             2,  4,  3,  0,  4,  1,  2,  5,  4,  3,
     *             5,  0,  1,  2,  5,  4,  6,  6,  3,  5,
     *             0,  6,  1,  4,  7,  2,  7,  3,  6,  5,
     *             7,  4,  0,  1,  8,  2,  6,  8,  7,  5,
     *             3,  8,  4,  7,  9,  6,  0,  1,  8,  9,
     *             2,  5,  3,  9,  7,  8,  4,  6,  9,  0,
     *             1,  5,  2,  8,  7,  9,  3,  6,  4,  8,
     *             9,  5,  7,  6,  9,  8,  7,  9,  8,  9/
C
      DATA NYQ2 /  1,  1,  2,  1,  2,  2,  1,  3,  3,  2,
     *             3,  1,  3,  4,  2,  4,  4,  1,  3,  4,
     *             2,  5,  5,  5,  3,  4,  1,  2,  5,  4,
     *             6,  3,  6,  5,  1,  6,  2,  6,  4,  5,
     *             3,  6,  7,  7,  1,  7,  5,  2,  4,  6,
     *             7,  3,  7,  5,  1,  6,  8,  8,  4,  2,
     *             8,  7,  8,  3,  6,  5,  8,  7,  4,  9,
     *             9,  8,  9,  6,  7,  5,  9,  8,  9,  7,
     *             6,  9,  8,  9,  7,  8,  9,  8,  9,  9/
C
C.....NXQ3 AND NYQ3 ARE THE X AND Y OFFSETS FOR QUADRANT 3.
C
      DATA NXQ3 /  1,  1,  2,  2,  1,  3,  2,  3,  1,  3,
     *             2,  4,  4,  3,  4,  1,  2,  5,  5,  4,
     *             3,  5,  1,  6,  2,  5,  4,  6,  6,  3,
     *             5,  6,  1,  4,  7,  7,  2,  7,  3,  6,
     *             5,  7,  4,  8,  1,  8,  2,  6,  8,  7,
     *             5,  3,  8,  4,  9,  7,  9,  6,  1,  8,
     *             9,  2,  5,  3,  9,  7,  8,  4,  6,  9,
     *             1,  5,  2,  8,  7,  9,  3,  6,  4,  8,
     *             9,  5,  7,  6,  9,  8,  7,  9,  8,  9/
C
      DATA NYQ3 /  0, -1,  0, -1, -2,  0, -2, -1, -3, -2,
     *            -3,  0, -1, -3, -2, -4, -4,  0, -1, -3,
     *            -4, -2, -5,  0, -5, -3, -4, -1, -2, -5,
     *            -4, -3, -6, -5,  0, -1, -6, -2, -6, -4,
     *            -5, -3, -6,  0, -7, -1, -7, -5, -2, -4,
     *            -6, -7, -3, -7,  0, -5, -1, -6, -8, -4,
     *            -2, -8, -7, -8, -3, -6, -5, -8, -7, -4,
     *            -9, -8, -9, -6, -7, -5, -9, -8, -9, -7,
     *            -6, -9, -8, -9, -7, -8, -9, -8, -9, -9/
C
C.....NXQ4 AND NYQ4 ARE THE X AND Y OFFSETS FOR QUADRANT 4.
C
      DATA NXQ4 /  0, -1,  0, -2, -1, -2, -3,  0, -1, -3,
     *            -2, -4, -3,  0, -4, -1, -2, -5, -4, -3,
     *            -5,  0, -1, -2, -5, -4, -6, -6, -3, -5,
     *             0, -6, -1, -4, -7, -2, -7, -3, -6, -5,
     *            -7, -4,  0, -1, -8, -2, -6, -8, -7, -5,
     *            -3, -8, -4, -7, -9, -6,  0, -1, -8, -9,
     *            -2, -5, -3, -9, -7, -8, -4, -6, -9,  0,
     *            -1, -5, -2, -8, -7, -9, -3, -6, -4, -8,
     *            -9, -5, -7, -6, -9, -8, -7, -9, -8, -9/
C
      DATA NYQ4 / -1, -1, -2, -1, -2, -2, -1, -3, -3, -2,
     *            -3, -1, -3, -4, -2, -4, -4, -1, -3, -4,
     *            -2, -5, -5, -5, -3, -4, -1, -2, -5, -4,
     *            -6, -3, -6, -5, -1, -6, -2, -6, -4, -5,
     *            -3, -6, -7, -7, -1, -7, -5, -2, -4, -6,
     *            -7, -3, -7, -5, -1, -6, -8, -8, -4, -2,
     *            -8, -7, -8, -3, -6, -5, -8, -7, -4, -9,
     *            -9, -8, -9, -6, -7, -5, -9, -8, -9, -7,
     *            -6, -9, -8, -9, -7, -8, -9, -8, -9, -9/
C
C.....WATE1 AND WATE2 ARE GRID POINT WEIGHTS. THESE ARE DISTANCES OUT
C.....FROM ANY GRID POINT IN NAUTICAL MILES. HOWEVER, THE FIRST 2
C.....ELEMENTS OF WATE1 AND THE FIRST ELEMENT OF WATE2 HAVE BEEN
C.....CHANGED SO THEIR DISTANCES WILL BE GREATER THAN 10 MILES.
C.....OTHERWISE, THE ESTIMATING ROUTINE WOULD ASSIGN ESTIMATED RAINFALL
C.....AMOUNTS GREATER THAN AN OBSERVED AMOUNT.
C
      DATA WATE1 /10.0010, 10.0520, 10.3608, 11.8722, 12.8621, 15.4602,
     *   15.6559, 16.5450, 18.4128, 19.4395, 20.4622, 20.6136, 21.4392,
     *   23.4838, 23.7444, 24.1260, 25.7243, 25.7670, 26.4321, 27.1550,
     *   28.1873, 28.3340, 29.9088, 30.9204, 31.2123, 31.2476, 31.3118,
     *   31.4768, 33.0900, 33.2716, 34.9206, 35.6166, 35.7274, 35.9569,
     *   36.0738, 36.5519, 36.8256, 37.9499, 38.5864, 38.8790, 39.1397,
     *   40.1720, 40.9245, 41.2272, 41.5668, 41.6461, 42.5144, 42.7089,
     *   42.8784, 43.0909, 43.7473, 44.0484, 44.8570, 46.1103, 46.3806,
     *   46.5757, 46.7534, 46.9677, 47.4193, 47.4888, 47.8543, 48.2520,
     *   48.6331, 49.6089, 49.6350, 50.5095, 50.6721, 51.4485, 51.5491,
     *   52.0256, 53.2805, 53.7212, 54.0230, 54.3100, 54.7956, 54.9467,
     *   55.2383, 56.3746, 56.8962, 58.3174, 58.3185, 58.5953, 59.3578,
     *   61.3867, 62.0677, 62.6236, 64.1372, 66.1301, 67.1710, 70.4515 /
C
      DATA WATE2 /10.0075, 10.0520, 11.7846, 11.8722, 12.8621, 15.6559,
     *   16.5450, 17.6769, 18.4128, 19.4395, 20.4622, 21.4392, 23.4838,
     *   23.5692, 23.7444, 24.1260, 25.7243, 26.4321, 27.1550, 28.1873,
     *   28.3340, 29.4615, 29.9088, 31.2123, 31.2476, 31.3118, 31.4768,
     *   33.0900, 33.2716, 34.9206, 35.3538, 35.6166, 35.7274, 35.9569,
     *   36.5519, 36.8256, 37.9499, 38.5864, 38.8790, 39.1397, 40.1720,
     *   40.9245, 41.2461, 41.5668, 41.6461, 42.5144, 42.7089, 42.8784,
     *   43.0909, 43.7473, 44.0484, 44.8570, 46.1103, 46.5757, 46.7534,
     *   46.9677, 47.1384, 47.4193, 47.4888, 47.8543, 48.2520, 48.6331,
     *   49.6089, 49.6350, 50.5095, 50.6721, 51.4485, 51.5491, 52.0256,
     *   53.0307, 53.2805, 53.7212, 54.0230, 54.3100, 54.7956, 54.9467,
     *   55.2383, 56.3746, 56.8962, 58.3174, 58.3185, 58.5953, 59.3578,
     *   61.3867, 62.0677, 62.6234, 64.1372, 66.1301, 67.1710, 70.4515 /
C
  901 FORMAT(1X,  '*** GESTMT ENTERED ***')
  902 FORMAT(1X,  '*** EXIT GESTMT ***')
  903 FORMAT(1X,  '** FATAL ERROR **  UNABLE TO READ GBOX PARAMETRIC REC
     *ORD FOR GRID BOX ', I4, '. STATUS CODE = ', I4, '.', /, 4X, 'MARO
     *FUNCTION HALTED.')
  904 FORMAT(1X,  '*** PG24(', I4, ') = ', I6, ' ***')
  905 FORMAT(3X,  'ESTIMATION DATA FOR PRECIP IN GRID POINT ', I4)
  906 FORMAT(3X, 'SEQ. GRID PRECIP    SEQ. GRID PRECIP    SEQ. GRID PREC
     *IP    SEQ. GRID PRECIP    SEQ. GRID PRECIP')
  907 FORMAT(4X, I2, 2X, I4, 2X, I5, 5X, I2, 2X, I4, 2X, I5, 5X, I2, 2X,
     * I4, 2X, I5, 5X, I2, 2X, I4, 2X, I5, 5X, I2, 2X, I4, 2X, I5)
  908 FORMAT(1X,  '*** PRECIPITATION ESTIMATION WILL BE DONE ON GRID POI
     *NT ', I4, ' ***')
  909 FORMAT(1X,  '*** DEGREE BOX NO.', I4, 'IDENTIFIER ', 2A4, ' READ
     *IN ***', /, 6X, 'BASE LATITUDE AND LONGITUDE ARE ', 2F7.2, /,
     * 6X, 'ADJACENT DEGREE BOXES ARE ', 8I4, 3X, 'MDR FLAG IS ', I2,
     * //)
  910 FORMAT(1X,  '*** DEGREE BOX NO. ', I3, ' HAS ITS PARAMETRIC DATA S
     *TORED IN LOCATIONS ', I4, ' THRU ', I4, ' OF THE HOLDING ARRAY ***
     *')
  911 FORMAT(1X,  '*** IPTRCE = ', I4, ' ***')
  912 FORMAT(3X, 'QUADRANT NO. ', I2, ' - THERE ARE ', I2, ' OBSERVED PR
     *ECIP AMOUNTS (ARRAY ADDRESSES ', I4, ' THRU ', I4, ')')
  913 FORMAT(3X, 'OBSERVED PRECIPITATION DATA OUTPUT FOR QUADRANT NO. ',
     * I2, /, 5X, 'SEQ.', 2X, 'GRID', 2X, 'PRECIP', 3X, 'WEIGHT', 5X,
     * 'SEQ.', 2X, 'GRID', 2X, 'PRECIP', 3X, 'WEIGHT', 5X, 'SEQ.', 2X,
     * 'GRID', 2X, 'PRECIP', 3X, 'WEIGHT', 5X, 'SEQ.', 2X, 'GRID', 2X,
     * 'PRECIP', 3X, 'WEIGHT')
  914 FORMAT(6X, I2, 3X, I4, 3X, I5, 2X, F7.4, 6X, I2, 3X, I4, 3X, I5,
     * 2X, F7.4, 6X, I2, 3X, I4, 3X, I5, 2X, F7.4, 6X, I2, 3X, I4, 3X,
     * I5, 2X, F7.4)
  915 FORMAT(3X, 'QUADRANT NO. ', I2, ' - THERE ARE ', I2, ' OBSERVED PR
     *ECIP AMOUNTS.')
  916 FORMAT(3X, '*** NO OBSERVED PRECIPITATION FOUND IN QUADRANT NO. ',
     * I2, ' ***')
C
      INCLUDE 'gcommon/setwhere'
C
C.....SET VALUES FOR THE AMOUNT OF STORAGE LOCATIONS TO FILL IN EACH
C.....QUADRANT...PLUS THE TOTAL NUMBER OF STORAGE LOCATIONS REQUIRED
C.....WHEN ALL FOUR QUADRANTS HAVE BEEN PROCESSED.
C
      NQFILL = NUMQDT
      NQTOT  = 4*NUMQDT
      KQ = 1
      KR = KQ + NQFILL
      KS = KR + NQFILL
      KT = KS + NQFILL
C
      IF(IPTRCE .GT. 0) WRITE(IOPDBG,901)
      ITRTMP = IPTRCE
C
      NGBUG = IPBUG(GBOX)
C
C.....SET VALUES OF CONSTANTS.
C
      LPARAY = 17
      NREC   =  0
      NEXT   =  0
      NGBOX  =  0
      PBOXID(1) = GBOXID(1)
      PBOXID(2) = GBOXID(2)
      IP = NSQUAR*NSQUAR - NSQUAR
C
C.....NOW GO THRU EACH GRID BOX...ESTIMATING MISSING PRECIPITATION AT
C.....THOSE GRID POINTS WITH NO OBSERVED PRECIPITATION.
C
C.....IX IS THE BEGINNING ADDRESS IN THE GBOX PARAMETRIC ARRAY THAT
C.....HOLDS THE PARAMETRIC DATA FOR THE GRID BOX CURRENTLY BEING
C.....PROCESSED BY THE PROGRAM.
C
      IX = 1
C
      DO 760 JPBOX = 1, NGRBOX
C
      MX = JPBOX*LPARAY
      NX =(JPBOX-1)*LPARAY + 1
C
      IF(NGBUG .EQ. 1) WRITE(IOPDBG,910) JPBOX, IX, MX
C
C.....SEE IF THE ESTIMATIONS IN THIS BOX ARE TO BE CHECKED. IF SO,
C.....THEN KICK UP THE TRACE LEVEL TO LEVEL(2).
C
C.....SET IBTCON TO 1 IF THE TRACE FOR THIS DEGREE BOX HAS BEEN
C.....SPECIFIED. OTHERWISE SET IBTCON TO 0.
C
      DO 120 KP = 1, 20
      IF(NTRBOX(KP) .EQ. JPBOX) GOTO 140
  120 CONTINUE
      GOTO 160
C
  140 IPTRCE = LEVEL(2)
      IBTCON = 1
      GOTO 180
C
  160 IPTRCE = LEVEL(1)
      IBTCON = 0
C
C.....CHECK DEBUG OUTPUT. IF DEBUG OUTPUT IS ON, THEN CHECK IF THIS
C.....PARTICULAR DEGREE BOX IS TO HAVE DEBUG OUTPUT.
C
  180 IF(IPBOXA .EQ. 1) IBTCON = 1
      NESBUG = IPBUG(GEST)
      IF(IBTCON .EQ. 0) NESBUG = 0
C
C.....READ...FROM THE PREPROCESSOR PARAMETRIC DATA BASE...THE PARAMETRIC
C.....RECORD FOR THE GRID BOXES. THIS CONTAINS THE BOXES THAT SURROUND
C.....THE GRID BOX. USE GBOXPY FOR WORKSPACE.
C
C.....READ THE ADJACENCY TABLE FROM THE PARAMETRIC RECORD GBOX.  EACH
C.....PARAMETER RECORD CONTAINS THE ADJACENT DEGREE BOXES FOR THE
C.....GRID BOX PRESENTED IN THE PARAMETER RECORD. THE ORDER OF THE
C.....BOXES IS CLOCKWISE BEGINNING WITH THE BOX TO THE NORTH.
C.....FOR EXAMPLE, CONSIDER BOX 27, THE 27TH LOGICAL RECORD IN
C.....PARAMETRIC ARRAY GBOX. IT CONTAINS THE NUMBERS
C.....
C..... 27  17  18  28  42  41  40  26  16
C.....
C.....FROM THIS, THE ADJACENCY OF DEGREE BOX 27 CAN BE DETERMINED. THE
C.....SECOND FIELD, 17, SHOWS THAT BOX 17 IS NORTH OF BOX 27. CONTINUING
C.....CLOCKWISE FROM BOX 17 WE CAN CONSTRUCT THE FOLLOWING
C.....DIAGRAM.
C.....
C.....             !    !
C.....          16 ! 17 ! 18
C.....             !    !
C.....         ----+----+----
C.....             !    !
C.....          26 ! 27 ! 28
C.....             !    !
C.....         ----+----+----
C.....             !    !
C.....          40 ! 41 ! 42
C.....             !    !
C.....
C.....THIS ADJACENCY MATRIX IS NEEDED SINCE THE ESTIMATION SEARCH WILL
C.....IN ALMOST ALL CASES FORCE THE SEARCH IN AT LEAST 1 QUADRANT TO
C.....RUN OVER INTO AN ADJACENT DEGREE BOX. THE SEARCH HAS GONE INTO
C.....AN ADJACENT BOX WHEN THE X COORDINATE OR THE Y COORDINATE REACHES
C.....A NUMBER THAT IS GREATER THAN 10 OR LESS THAN ZERO.
C.....
C.....SPECIAL NOTE --- LIMITING THE SEARCH TO 50 MILES MAXIMUM SAVES
C.....US FROM SOME COMPLICATED PROGRAMMING. IF THE MAXIMUM SEARCH
C.....DISTANCE WERE TO EXCEED ABOUT 55 MILES, THIS WOULD FORCE THE
C.....ALGORITHM TO CONSIDER NOT ONLY ADJACENT DEGREE BOXES, BUT THOSE
C.....DEGREE BOXES ADJACENT TO AN ADJACENT DEGREE BOX. THEN THE PROBLEM
C.....OF DEFINING AND PROCESSING A SECOND ORDER ADJACENCY MATRIX WOULD
C.....HAVE TO BE CONTENDED WITH.
C
C.....CALL THE RPPREC ROUTINE TO GET THE CONTENTS OF THE GBOX
C.....PARAMETRIC ARRAY.
C
      CALL RPPREC(PBOXID, GBOX, NREC, LPARAY, GBOXPY(IX), NDUM, NEXT,
     * ISTATC)
C
      IF(ISTATC .EQ. 0) GOTO 200
      WRITE(IPR,903) JPBOX, ISTATC
      CALL ERROR
      CALL KILLFN(8HMARO    )
      GOTO 999
C
  200 IF(NGBUG .EQ. 0) GOTO 240
C
      JDGBNO = GBOXPY(IX+3)
      DBNAME(1) = GBOXPY(IX+1)
      DBNAME(2) = GBOXPY(IX+2)
      RBLATT = GBOXPY(IX+6)
      RBLONG = GBOXPY(IX+7)
C
      DO 220 NP = 1, 8
      IADJ(NP) = GBOXPY(IX+7+NP)
  220 CONTINUE
C
      MDRUSF = GBOXPY(IX+16)
C
      WRITE(IOPDBG,909) JDGBNO, DBNAME, RBLATT, RBLONG, IADJ, MDRUSF
C
C.....GET THE RECORD NUMBER OF THE NEXT RECORD TO READ...SO IT WILL BE
C.....AVAILABLE WHEN WE ARE READY FOR IT.
C
  240 NREC   = NEXT
      PBOXID(1) = GBOXID(1)
      PBOXID(2) = GBOXID(2)
C
C.....FILL UP THE NBOX ARRAY WITH PART OF THE WORK AREA DATA FROM THE
C.....PARAMETRIC ARRAY READ IN RPPREC.
C
      NP = 1
      KP = 3
      NBOX(NP) = GBOXPY(NX + KP)
      NP = NP + 1
C
      DO 260 KP = 8, 15
      NBOX(NP) = GBOXPY(NX + KP)
      NP = NP + 1
  260 CONTINUE
C
      IX = IX + LPARAY
C
C.....EXAMINE NSQUAR*NSQUAR GRID POINTS IN EACH DEGREE BOX. JX DEFINES
C.....THE EAST-WEST SEARCH PROGRESSION...WHILE KX DEFINES THE
C.....NORTH-SOUTH SEARCH PROGRESSION.
C
      DO 740 LX = 1, NSQUAR
C
C.....THE ACTUAL VERTICAL ADDRESS OFFSET IN THE GRID SYSTEM IS ALWAYS
C.....1 LESS THAN THE LOOP COUNTER.
C
      K = LX - 1
C
      DO 720 JX = 1, NSQUAR
C
C.....THE ACTUAL HORIZONTAL ADDRESS OFFSET IN THE GRID SYSTEM IS ALWAYS
C.....1 LESS THAN THE LOOP COUNTER.
C
      J = JX - 1
C
C.....COMPUTE THE GRID POINT ADDRESS BEING LOOKED AT RIGHT NOW.
C
      NPGRID = JPBOX*100 + K*10 + J
C
C.....CHECK IF THERE IS AN OBSERVATION AT THE GRID POINT. IF AN
C.....OBSERVATION ALREADY EXISTS FOR THIS GRID POINT...DO NOT BOTHER
C.....WITH AN ESTIMATION.
C
      IF(PG24(NPGRID) .GE. 0) GOTO 700
C
C.....NOW INITIALIZE THE QUADRANT PRECIP AND GRID ADDRESS ARRAYS.
C
      DO 270 NP = 1, NQTOT
      WQWGT(NP) = 0.0
      NQPCP(NP) = MSGGRD
      NQGRD(NP) = -1
      NQSEQ(NP) = 0
  270 CONTINUE
C
      IF(NESBUG .EQ. 1) WRITE(IOPDBG,908) NPGRID
C
C.....GO INTO THE ESTIMATION ROUTINES. SEARCH EACH QUADRANT BEGINNING
C.....WITH THE CLOSEST GRID POINT, FOR OBSERVED PRECIPITATION. STORE
C.....THE OBSERVED PRECIPITATION AND ITS WEIGHT FOR THE COMPUTATION OF
C.....THE PRECIPITATION ESTIMATE.
C
      DO 620 NQUAD = 1, 4
C
      LQ = (NQUAD-1)*NQFILL + 1
C
      GOTO (280, 360, 440, 520), NQUAD
C
C.....QUADRANT NO. 1
C
  280 NEWBOX(1) =  4
      NEWBOX(2) =  2
      NEWBOX(3) =  3
C
      LP        =  1
      NPCPNF    =  0
  300 IF(ICONVC .EQ. 0) GOTO 320
      IF(WATE1(LP) .LE. CNVDIS) GOTO 320
      GOTO 580
  320 NXOFF     =  NXQ1(LP)
      NYOFF     =  NYQ1(LP)
      NXGRID = NFGRD(JPBOX, J, K, NXOFF, NYOFF, NEWBOX, NBOX)
      IF(NXGRID .LT. 100) GOTO 340
      IF(PG24(NXGRID) .LT. 0) GOTO 340
C
C.....STORE THE SEQUENCE COUNT...PRECIP...GRID ADDRESS...AND WEIGHT.
C.....THE SEQUENCE NUMBER AND GRID ADDRESS ARE STORED FOR DISPLAY
C.....PURPOSES ONLY.
C
      NQSEQ(LQ) = LP
      NQPCP(LQ) = PG24(NXGRID)
      NQGRD(LQ) = NXGRID
      WQWGT(LQ) = WATE1(LP)
      LQ = LQ + 1
      NPCPNF = NPCPNF + 1
      IF(LQ .GT. IQWDIM) GOTO 580
      IF(NPCPNF .GE. NUMQDT) GOTO 580
  340 LP = LP + 1
      IF(LP .LE. IQWDIM) GOTO 300
      GOTO 580
C
C.....QUADRANT NO. 2
C
  360 NEWBOX(1) =  8
      NEWBOX(2) =  2
      NEWBOX(3) =  9
C
      LP        =  1
      NPCPNF    =  0
  380 IF(ICONVC .EQ. 0) GOTO 400
      IF(WATE2(LP) .LE. CNVDIS) GOTO 400
      GOTO 580
  400 NXOFF     =  NXQ2(LP)
      NYOFF     =  NYQ2(LP)
      NXGRID = NFGRD(JPBOX, J, K, NXOFF, NYOFF, NEWBOX, NBOX)
      IF(NXGRID .LT. 100) GOTO 420
      IF(PG24(NXGRID) .LT. 0) GOTO 420
C
C.....STORE THE SEQUENCE COUNT...PRECIP...GRID ADDRESS...AND WEIGHT.
C.....THE SEQUENCE NUMBER AND GRID ADDRESS ARE STORED FOR DISPLAY
C.....PURPOSES ONLY.
C
      NQSEQ(LQ) = LP
      NQPCP(LQ) = PG24(NXGRID)
      NQGRD(LQ) = NXGRID
      WQWGT(LQ) = WATE2(LP)
      LQ = LQ + 1
      NPCPNF = NPCPNF + 1
      IF(LQ .GT. IQWDIM) GOTO 580
      IF(NPCPNF .GE. NUMQDT) GOTO 580
  420 LP = LP + 1
      IF(LP .LE. IQWDIM) GOTO 380
      GOTO 580
C
C.....QUADRANT NO. 3
C
  440 NEWBOX(1) =  8
      NEWBOX(2) =  6
      NEWBOX(3) =  7
C
      LP        =  1
      NPCPNF    =  0
  460 IF(ICONVC .EQ. 0) GOTO 480
      IF(WATE1(LP) .LE. CNVDIS) GOTO 480
      GOTO 580
  480 NXOFF     =  NXQ3(LP)
      NYOFF     =  NYQ3(LP)
      NXGRID = NFGRD(JPBOX, J, K, NXOFF, NYOFF, NEWBOX, NBOX)
      IF(NXGRID .LT. 100) GOTO 500
      IF(PG24(NXGRID) .LT. 0) GOTO 500
C
C.....STORE THE SEQUENCE COUNT...PRECIP...GRID ADDRESS...AND WEIGHT.
C.....THE SEQUENCE NUMBER AND GRID ADDRESS ARE STORED FOR DISPLAY
C.....PURPOSES ONLY.
C
      NQSEQ(LQ) = LP
      NQPCP(LQ) = PG24(NXGRID)
      NQGRD(LQ) = NXGRID
      WQWGT(LQ) = WATE1(LP)
      LQ = LQ + 1
      NPCPNF = NPCPNF + 1
      IF(LQ .GT. IQWDIM) GOTO 580
      IF(NPCPNF .GE. NUMQDT) GOTO 580
  500 LP = LP + 1
      IF(LP .LE. IQWDIM) GOTO 460
      GOTO 580
C
C.....QUADRANT NO. 4
C
  520 NEWBOX(1) =  4
      NEWBOX(2) =  6
      NEWBOX(3) =  5
C
      LP        =  1
      NPCPNF    =  0
  530 IF(ICONVC .EQ. 0) GOTO 540
      IF(WATE2(LP) .LE. CNVDIS) GOTO 540
      GOTO 580
  540 NXOFF     =  NXQ4(LP)
      NYOFF     =  NYQ4(LP)
      NXGRID = NFGRD(JPBOX, J, K, NXOFF, NYOFF, NEWBOX, NBOX)
      IF(NXGRID .LT. 100) GOTO 560
      IF(PG24(NXGRID) .LT. 0) GOTO 560
C
C.....STORE THE SEQUENCE COUNT...PRECIP...GRID ADDRESS...AND WEIGHT.
C.....THE SEQUENCE NUMBER AND GRID ADDRESS ARE STORED FOR DISPLAY
C.....PURPOSES ONLY.
C
      NQSEQ(LQ) = LP
      NQPCP(LQ) = PG24(NXGRID)
      NQGRD(LQ) = NXGRID
      WQWGT(LQ) = WATE2(LP)
      LQ = LQ + 1
      NPCPNF = NPCPNF + 1
      IF(LQ .GT. IQWDIM) GOTO 580
      IF(NPCPNF .GE. NUMQDT) GOTO 580
  560 LP = LP + 1
      IF(LP .LE. IQWDIM) GOTO 530
C
  580 LQ = LQ - 1
      NSQUAD(NQUAD) = NPCPNF
C
      IF(NESBUG .LE. 0) GOTO 620
      MP = LQ - NUMQDT + 1
      WRITE(IOPDBG,913) NQUAD
C
      IF(NPCPNF .GT. 0) GOTO 600
      WRITE(IOPDBG,916) NQUAD
      GOTO 620
C
  600 WRITE(IOPDBG,914) (NQSEQ(NP), NQGRD(NP), NQPCP(NP),
     * WQWGT(NP), NP = MP, LQ)
C
  620 CONTINUE
C
C.....WHEN THE WORKING ARRAYS ARE FILLED IN EACH QUADRANT...MAKE
C.....THE PRECIPITATION ESTIMATE.
C
C.....DUMP OUT THE PRECIPITATION PICKED UP IF THE TRACE LEVEL IS
C.....HIGH ENOUGH.
C
      IF(NESBUG .NE. 1) GOTO 680
C
      LQUAD = 0
      WRITE(IOPDBG,905) NPGRID
C
  640 LQUAD = LQUAD + 1
      IF(LQUAD .GT. 4) GOTO 680
C
      KP = (LQUAD-1)*NQFILL + 1
      JP = KP + NSQUAD(LQUAD) - 1
C
      IF(JP .GE. KP) GOTO 660
      WRITE(IOPDBG,915) LQUAD, NSQUAD(LQUAD)
      GOTO 640
C
  660 WRITE(IOPDBG,912) LQUAD, NSQUAD(LQUAD), KP, JP
      IF(JP .LT. KP) GOTO 640
C
      WRITE(IOPDBG,906)
      WRITE(IOPDBG,907) (NQSEQ(NP), NQGRD(NP), NQPCP(NP), NP = KP, JP)
      IF(LQUAD .GE. 4) GOTO 680
      GOTO 640
C
  680 CALL GPPEST(NQFILL, WQWGT(KQ), WQWGT(KR), WQWGT(KS), WQWGT(KT),
     * NQPCP(KQ), NQPCP(KR), NQPCP(KS), NQPCP(KT), NSQUAD, PX24)
C
C.....STORE THE PRECIPITATION ESTIMATE.
C
      PG24(NPGRID) = PX24
C
  700 IF(NESBUG .EQ. 1) WRITE(IOPDBG,904) NPGRID, PG24(NPGRID)
C
  720 CONTINUE
  740 CONTINUE
  760 CONTINUE
C
C.....AFTER ALL ESTIMATIONS ARE COMPLETE...ZERO OUT ANY UNESTIMATED
C.....PRECIPITATION.
C
      DO 780 NPGRID = 1, NGRID
      IF(PG24(NPGRID) .EQ. MSGGRD) PG24(NPGRID) = 0
  780 CONTINUE
C
C.....MOVE THE ADJACENCY MATRIX TO THE FRONT OF IEWORK. IT IS NOW
C.....LOCATED IN THE MIDDLE. THIS IS TO FREE UP THE UNUSED SPACE.
C
      MP = NSQUAR*NSQUAR
      IP = LPARAY*MP
C
      DO 800 KP = 1, IP
      NADJ(KP) = GBOXPY(KP)
  800 CONTINUE
C
      NGBOX = 1
C
  999 IPTRCE = ITRTMP
      IF(IPTRCE .GT. 0) WRITE(IOPDBG,902)
      IF(IPTRCE .GT. 0) WRITE(IOPDBG,911) IPTRCE
      RETURN
      END