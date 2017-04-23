C MODULE PVCNTL
C-----------------------------------------------------------------------
C
C  MAIN ROUTINE FOR DUMSHEF COMMAND.
C
      SUBROUTINE PVCNTL (UNRC,UNWC,UNWD,UNWTTY,IG,IUNFLG)
C
      INCLUDE 'uiox'
      INCLUDE 'ufreei'
      INCLUDE 'udebug'
C
      CHARACTER*4 XDTYP
      CHARACTER*8 RTNNAM,STAID
      INTEGER    UNRC,UNWC,UNWD,UNWTTY
      INTEGER    TYPS(64),LOCA(64)
      PARAMETER (MSSTA=500)
      DIMENSION LSSTA(MSSTA*2),LSMSF(MSSTA)
      PARAMETER (MSTYP=64)
      DIMENSION LSTYP(MSTYP),LSMTF(MSTYP)
      PARAMETER (LIDIR=1000)
      DIMENSION IDI4(LIDIR)
      INTEGER*2 IDI2(LIDIR)
      REAL      IDR4(LIDIR)
      PARAMETER (LINFSTA=3,MINFSTA=5000)
      DIMENSION INFSTA(LINFSTA,MINFSTA)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/ppdutil_dmpsh/RCS/pvcntl.f,v $
     . $',                                                             '
     .$Id: pvcntl.f,v 1.6 2002/02/11 20:51:00 dws Exp $
     . $' /
C    ===================================================================
C
C
      LDEBUG=0
C
      RTNNAM='PVCNTL'
      CALL PVSUBB (RTNNAM,ICOND)
C
      IF (NFIELD.LE.1) GO TO 70
C
C  SAVE CURRENT UNIT NUMBERS AND TRACE INDICATOR
      ICDSV=ICD
      LPESV=LPE
      IPDTSV=IPDTR
      IOGDSV=IOGDB
C
C  RESET UNIT NUMBERS AND TRACE INDICATOR
      ICD=UNRC
      LCDPUN=ICDPUN
      ICDPUN=UNWD
      LPE=UNWC
      IF (IG.EQ.1) THEN
         IPDTR=1
         IOGDB=LPE
         ENDIF
C
      ICOND=0
C
C  GET DATES
      CALL PVGDC (UNWC,UNWTTY,JULDB,INTHRB,JULDE,JULHB,JULHE,ICOND)
CCC      WRITE (LP,*) 'JULDB=',JULDB,' JULDE=',JULDE
      JULDBO=JULDB
C
C  GET STATIONS TO BE PROCESSED
      CALL PVGSL (UNWC,UNWTTY,LSSTA,LSMSF,MSSTA,NOFS,ICOND)
C
C  GET DATA TYPES TO BE PROCESSED
      CALL PVGTL (UNWC,UNWTTY,LSTYP,LSMTF,MSTYP,NOFT,ICOND)
C
      NINFSTA=0
      NXSTA=0
      NXTYP=0
C
10    ICOND=0
C
C  GET STATION INFORMATION
      ISORT=1
      CALL PVGNS (ISORT,NINFSTA,MINFSTA,LINFSTA,INFSTA,
     *   NXSTA,STAID,NUMID,IPGENL,NOFTY,TYPS,LOCA,ICOND)
      IF (ICOND.EQ.1) GO TO 60
      IF (ICOND.EQ.2) GO TO 65
C
C  CHECK IF STATION TO BE PROCESSED
      CALL PVVNS (STAID,LSSTA,LSMSF,NOFS,IMFS,ICOND)
      IF (ICOND.NE.0) GO TO 60
C
CCC      WRITE (LP,*) '**NOTE** PROCESSING STATION ',STAID,'.'
C
C  PROCESS NEXT DATA TYPE FOR THIS STATION
30    ICOND=0
      CALL PVLNT (NXTYP,NOFTY,TYPS,IDTYP,ICOND)
      IF (LDEBUG.GT.0) WRITE (LP,*) 'STAID=',STAID,' NXTYP=',NXTYP,
     *   ' NOFTY=',NOFTY,' ICOND=',ICOND
      IF (ICOND.NE.0) GO TO 60
C
C  CHECK IF DATA TYPE TO BE PROCESSED
      CALL PVVNT (IDTYP,LSTYP,LSMTF,NOFT,IMFT,ICOND)
      IF (ICOND.NE.0) GO TO 60
C
C  CHECK IF TO OUTPUT MISSING DATA
      IMF=0
      IF (IMFS.EQ.1.OR.IMFS.EQ.3) IMF=1
      IF (IMFT.EQ.1.OR.IMFT.EQ.3) IMF=1
C
C  CHECK IF TO OUTPUT ESTIMATED DATA
      IEF=0
      IF (IMFS.EQ.2.OR.IMFS.EQ.3) IEF=1
      IF (IMFT.EQ.2.OR.IMFT.EQ.3) IEF=1
C
      CALL UMEMOV (IDTYP,XDTYP,1)
      JULDB=JULDBO
      IF (XDTYP(3:4).EQ.'06'.OR.
     *    XDTYP(3:4).EQ.'03'.OR.
     *    XDTYP(3:4).EQ.'01') THEN
         IF (INTHRB.NE.0) JULDB=JULDBO+1
         ENDIF
C
      WRITE (LP,*) '**NOTE** PROCESSING DATA TYPE ',XDTYP,
     *   ' FOR STATION ',STAID,'.'
CCC      WRITE (LP,*) 'JULDB=',JULDB,' JULDE=',JULDE
C
C  CALL ROUTINE FOR EACH TYPE OF DATA
      CALL PVPP24 (UNWD,STAID,IDTYP,JULDB,JULDE,IUNFLG,IMF,IEF,ICOND,
     *            IDI2,IDR4,IDI4,LIDIR)
      CALL PVPP0X (UNWD,STAID,IDTYP,JULDB,JULDE,IUNFLG,IMF,ICOND,
     *            IDI2,IDR4,IDI4,LIDIR)
      CALL PVTA0X (UNWD,STAID,IDTYP,JULDB,JULDE,IUNFLG,IMF,ICOND,
     *            IDI2,IDR4,IDI4,LIDIR)
      CALL PVTM24 (UNWD,STAID,IDTYP,JULDB,JULDE,IUNFLG,IMF,ICOND,
     *            IDI2,IDR4,LIDIR)
      CALL PVTF24 (UNWD,STAID,IDTYP,JULDB,JULDE,IUNFLG,IMF,ICOND,
     *            IDI2,IDR4,IDI4,LIDIR)
      CALL PVEA24 (UNWD,STAID,IDTYP,JULDB,JULDE,IUNFLG,IMF,ICOND,
     *            IDI2,IDR4,LIDIR)
      CALL PVRRS (UNWD,STAID,IDTYP,JULHB,JULHE,IUNFLG,ICOND)
C
C  CHECK IF MORE DATA TYPES FOR STATION
60    IF (NXTYP.GT.0) GO TO 30
C
C  CHECK IF MORE STATIONS
      IF (NXSTA.GT.0) GO TO 10
C
C  RESET UNIT NUMBERS AND TRACE INDICATOR TO ORIGINALS
65    LPE=LPESV
      ICDPUN=LCDPUN
      ICD=ICDSV
      IPDTR=IPDTSV
      IOGDB=IOGDSV
C
70    CALL PVSUBE (RTNNAM,ICOND)
C
      RETURN
C
      END