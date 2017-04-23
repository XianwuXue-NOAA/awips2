C MEMBER PDEPSR
C  (from old member PDEDTPSR)
C-----------------------------------------------------------------------
C
C @PROCESS LVL(77)
C
       SUBROUTINE PDEPSR (JULDA,INTHR,JULHR,IUNIT)
C
C          ROUTINE:  PDEPSR
C
C             VERSION:  1.0.0
C
C                DATE:  9-11-84
C
C              AUTHOR:  DATA SCIENCES INC
C
C***********************************************************************
C
C          DESCRIPTION:
C
C    THIS ROUTINE EDITS A SINGLE DATA VALUE FOR STRANGER STATION
C    DATA FOR A SPECIFIC DAY AND HOUR.
C
C***********************************************************************
C
C          ARGUMENT LIST:
C
C         NAME    TYPE  I/O   DIM   DESCRIPTION
C
C       JULDA      I     I     1     JULIAN DAY OF EDIT
C       INTHR      I     I     1     INTERNAL HOUR
C       JULHR      I     I     1     JULIAN HOUR
C       IUNIT      A     I     1     UNITS OF DATA
C
C***********************************************************************
C
C          COMMON:
C
      INCLUDE 'uio'
      INCLUDE 'udebug'
      INCLUDE 'ufreei'
      INCLUDE 'udatas'
      INCLUDE 'hclcommon/hdflts'
C
C***********************************************************************
C
C          DIMENSION AND TYPE DECLARATIONS:
C
      DIMENSION RLATLN(2),NCARD(2),LEND(2),IDATES(1)
      INTEGER*2 IPNTRS(1),MSNG,IDATA(1000)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppdutil/RCS/pdepsr.f,v $
     . $',                                                             '
     .$Id: pdepsr.f,v 1.1 1995/09/17 19:09:26 dws Exp $
     . $' /
C    ===================================================================
C
C
C***********************************************************************
C
C          DATA:
C
      DATA LEND/4HENDP,4HPSR /,LETX/4HX   /,LET0/4H0   /,IPSR/4HPPSR/
C
C***********************************************************************
C
C
C
C  DEBUG
C
      IF (IPDTR.GT.0) WRITE (IOGDB,10)
10    FORMAT (' *** ENTER PDEPSR')
C
      IWRIT=0
      IREV=1
      JERR=0
      ID=1
      LDATA=1000
C
C  CONVERT DATE FOR MESSAGES
C
      CALL MDYH2(JULDA,INTHR,IMO,IDAY,IYR,IHR,ITZ,IDSAV,TIME(3))
      IYR=MOD(IYR,100)
C
C  NEXT CARD FOR LAT/LON
C
      CALL RWCARD(ISTAT)
      IF (ISTAT.NE.0) GO TO 370
      IF=1
      IF (IBUF(1).EQ.LETX) GO TO 30
      WRITE (LPE,20)
20    FORMAT (' **ERROR** IN PDEPSR - INVALID CHARACTER IN FIELD FOR',
     1      ' STRANGER STATION LAT/LON.')
      GO TO 210
30    CONTINUE
C
C  CONVERT TO A REAL NUMBER FOR CONVERSION
C
      MTCHLL=0
      IF (IBUF(8).EQ.IBLNK) IBUF(8)=LET0
      CALL UFIXED(IBUF,RLAT,2,4,2,ID,IERR)
      CALL UFIXED(IBUF,RLON,5,8,2,ID,IERR)
      IF (IPDDB.GT.0) WRITE (IOGDB,40) RLAT,RLON
40    FORMAT (' RLAT=',F8.4,' RLON=',F8.4)
      IF (IERR.EQ.0) GO TO 50
      WRITE (LPE,20)
      GO TO 210
50    CONTINUE
C
C MOVE LAT/LON INTO ONE WORD FOR POSTING
C
      RLATLN(1)=RLAT
      RLATLN(2)=RLON
60    CONTINUE
C
C  GET VALUE
C
      IF=IF+1
      CALL UFIXED(IBUF,VAL,IFSTRT(IF),IFSTOP(IF),2,ID,IERR)
      IF (IERR.EQ.0) GO TO 80
      WRITE (LPE,70)
70    FORMAT (' **ERROR** IN PDEPSR - INVALID CHARACTER IN VALUE FIELD.'
     *   )
      IWRIT=1
80    CONTINUE
      IF (IWRIT.NE.0) GO TO 230
      JDAY=JULDA
C
C  SET JULIAN HOUR TO INTERNAL HOUR TO EDIT PPSR
C
      JHR=INTHR
C
C  THIS REPORT SHOULD ALREADY EXIST IN ORDER TO EDIT
C
      IF (JHR.GT.0) JDAY=JULDA+1
      CALL RPDDLY(IPSR,JDAY,0,1,INPTRS,LPFILL,LDATA,IDATA,LDFILL,
     1            NUMSTA,MSNG,1,IDATES,ISTAT)
      IF (NUMSTA.EQ.0) GO TO 310
      IF (ISTAT.EQ.0) GO TO 90
      GO TO (330,330,330,250,270,370) , ISTAT
90    CONTINUE
C
C  MOVE LAT/LON FROM RECORD FOR COMPARISION
C
      J=1
      DO 130 I=1,NUMSTA
       XLAT=IDATA(J)
       XLAT=XLAT/10
       XLON=IDATA(J+1)
       XLON=XLON/10
       IF (IPDDB.GT.0) WRITE (IOGDB,100) XLAT,XLON
100   FORMAT (' IN PDEPSR - COORDINATES FOR LAT/LON= ',2(F7.2,1X))
C
C  CONVERT POLAR STEROGRAPHIC COORDINATES TO LAT/LON
C
       CALL SBLLGD(FLON,FLAT,1,XLON,XLAT,0,ISTAT)
       IF (ISTAT.NE.0) GO TO 350
       IF (IPDDB.GT.0) WRITE (IOGDB,110) FLAT,FLON
110   FORMAT (' BACK FROM CONVERSION LAT/LON= ',2(F8.4,2X))
C
C  COMPARE THIS LAT/LON PAIR WITH INPUT PAIR
C
       DIFF=RLAT-FLAT
       R=ABS(DIFF)
       DIFF2=RLON-FLON
       R2=ABS(DIFF2)
       IF (R.LE.(.0099).AND.R.GE.(.0001).AND.R2.LE.(.0099).AND.R2.GE.
     1 (.0001)) MTCHLL=1
       IF (IPDDB.GT.0) WRITE (IOGDB,120) MTCHLL
120   FORMAT (' MTCHLL SET TO ',I3)
C
C  MATCH ?? - CHECK ENCODED VALUE AND HOUR - NO MATCH GET NEXT PAIR
C
       IF (MTCHLL.EQ.1) GO TO 150
       J=J+3
130   CONTINUE
C
C  NO MATCH
C
      WRITE (LPE,140)
140   FORMAT (' **WARNING** THIS REPORT NOT FOUND IN RECORD. NO EDIT ',
     1       'WILL OCCUR.')
      GO TO 210
150   CONTINUE
C
C  ENCODE DATA VALUE FOR REPORT HOUR
C
      CALL PDGTPP(IDATA(J+2),VALUE,IH,IVV)
      IF (IPDDB.GT.0) WRITE (IOGDB,160) IDATA(J+2),VALUE,IH
160   FORMAT (' IN PDEPSR - DATA,ENCODED VALUE,HOUR= ',I7,F5.2,1X,I3)
C
C  THE ENCODED HOUR (IH) MUST CORRESPOND TO THE PROPER ZTIME HOUR
C  ONLY THOSE REPORT WITH MATCHING HOURS MAY BE EDITED
C
C
      IF (IH.EQ.JHR) GO TO 180
C
C  THIS REPORT WILL NOT BE EDITED
C
      WRITE (LPE,170) IH,JHR
170   FORMAT (' **WARNING** STRANGER STATION RECORD REPORT HOUR ',I3,
     1       ' DOES NOT MATCH EDIT HOUR ',I3,' REPORT WILL NOT BE ',
     2        'EDITED.')
      GO TO 210
180   CONTINUE
      CALL WPDSS(JDAY,JHR,RLATLN,VAL,IUNIT,IREV,ISTAT)
      IF (ISTAT.EQ.0.OR.ISTAT.EQ.20) GO TO 190
      GO TO (250,270,290,370) , ISTAT
190   CONTINUE
      WRITE (LP,200) RLAT,RLON,IMO,IDAY,IYR,IHR,TIME(3),VAL
200   FORMAT (' STRANGER STATION ',F5.2,1X,F6.2,' EDITED FOR ',
     *    2(I2,'/'),I2,' HR ',I2,1X,A3,' VALUE ',F6.2)
      IWRIT=0
210   CONTINUE
C
C  MORE VALUES FOR THIS DAY OR END OF EDIT
C
      CALL RWCARD(ISTAT)
      IF (ISTAT.NE.0) GO TO 370
      IF=1
      IF (IBUF(1).EQ.LETX) GO TO 30
      NUM=IFSTOP(IF)-IFSTRT(IF)+1
      IF (NUM.GT.8) NUM=8
      CALL UPACK1(IBUF(IFSTRT(IF)),NCARD,NUM)
      CALL UNAMCP(NCARD,LEND,JERR)
      IF (JERR.EQ.0) GO TO 390
      WRITE (LPE,220)
220   FORMAT (' **ERROR** INVALID END CARD FOR STRANGER STATION EDIT. ',
     1       ' END ASSUMED.')
      GO TO 390
230   CONTINUE
      WRITE (LPE,240) RLAT,RLON,IMO,IDAY,IYR,IHR,TIME(3)
240   FORMAT (' **WARNING** STRANGER STATION ',F5.2,1X,F6.2,' NOT EDIT',
     1       'ED FOR ',2(I2,'/'),I2,1X,A3,' DUE TO INPUT ERROR.')
      IWRIT=0
      GO TO 210
C
250   CONTINUE
      WRITE (LPE,260)
260   FORMAT (' **ERROR** IN PDEPSR - DATE NOT CONTINUOUS. NO VALUES ',
     1        'EDITED FOR THIS STRANGER STATION.')
      GO TO 230
C
270   CONTINUE
      WRITE (LPE,280)
280   FORMAT (' **ERROR** IN PDEPSR - PPSR NOT DEFINED ON PPDB.')
      GO TO 210
C
290   CONTINUE
      WRITE (LPE,300) IUNIT
300   FORMAT (' **ERROR** IN PDEPSR - INVALID UNITS ',A4)
      GO TO 230
310   CONTINUE
      WRITE (LPE,320)
320   FORMAT (' **ERROR** IN PDEPSR - NO DATA AVAILABLE FOR DATE ',
     *   'REQUESTED.')
      GO TO 230
330   CONTINUE
      WRITE (LPE,340)
340   FORMAT (' **ERROR** IN PDEPSR - WORK ARRAYS TOO SMALL.')
      GO TO 230
350   CONTINUE
      WRITE (LPE,360)
360   FORMAT (' **ERROR** IN PDEPSR - LAT/LON CONVERSION ERROR.')
      GO TO 230
C
370   CONTINUE
      WRITE (LPE,380)
380   FORMAT (' **ERROR** IN PDEPSR - SYSTEM ERROR.')
      GO TO 410
390   CONTINUE
C
C  DEBUG
C
      IF (IPDDB.GT.0) WRITE (IOGDB,400)
400   FORMAT (' *** EXIT PDEPSR')
C
410   RETURN
C
      END