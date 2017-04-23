C MEMBER EACDRV
C  (from old member EEACDRV)
C
      SUBROUTINE EACDRV(PESP,MPESP,IDLOOP,KNTYR,A,MA,D,LW,MAXW,NYRS,
     1 IHZERO)
C
C   THIS SUBROUTINE IS THE DRIVER FOR THE ACCUMULATOR PORTION OF
C   THE PROGRAM,
C
C   THIS SUBROUTINE WAS ORIGINALLY WRITTEN BY GERALD N. DAY .
C
      LOGICAL LBUG
      INCLUDE 'common/esprun'
      INCLUDE 'common/etime'
      INCLUDE 'common/eacc'
      INCLUDE 'common/eswtch'
      INCLUDE 'common/espseg'
      INCLUDE 'common/fdbug'
      INCLUDE 'common/ionum'
      INCLUDE 'common/where'
      INCLUDE 'common/evar'
      INCLUDE 'common/emod'
C
      DIMENSION SBNAME(2),OLDOPN(2),VARNAM(2),PESP(1),A(1),D(1),
     1 TSID(2)
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_esp/RCS/eacdrv.f,v $
     . $',                                                             '
     .$Id: eacdrv.f,v 1.1 1995/09/17 19:18:19 dws Exp $
     . $' /
C    ===================================================================
C
C
      DATA SBNAME/4HEACD,4HRV  /,DEBUG/4HEACC/
      DATA OBS/4HOBS /,SIM/4HSIM /
C
      IOLDOP=IOPNUM
      IOPNUM=0
      DO 10 I=1,2
      OLDOPN(I)=OPNAME(I)
   10 OPNAME(I)=SBNAME(I)
C
      IF(ITRACE.GE.1) WRITE(IODBUG,900)
  900 FORMAT(1H0,17H** EACDRV ENTERED)
C
      IF(LPESP.EQ.0) GO TO 999
C
      LBUG=.FALSE.
      IF(IFBUG(DEBUG).EQ.0) GO TO 15
      LBUG=.TRUE.
C
C
      WRITE(IODBUG,901)
  901 FORMAT(1H ,10X,6HPESP =)
      WRITE(IODBUG,902) (PESP(I),I=1,LPESP)
  902 FORMAT(1H ,10X,10F10.2)
      WRITE(IODBUG,905) NUMWIN
  905 FORMAT(1H ,10X,8HNUMWIN =,I5/1H ,10X,6HJVAR =)
      WRITE(IODBUG,910) JVAR
  910 FORMAT(1H ,10X,10I5)
C
   15 CONTINUE
C
      ICO=IEPASS
      IF(IEPASS.EQ.4) ICO=1
C
      LP=0
   20 NVAR=PESP(LP+1)
      IF(NVAR.EQ.0) GO TO 999
      NVAL=NVPV(NVAR)
      NEXVAR=PESP(LP+2)
C
      NWIND=0
      DO 25 J=1,NUMWIN
      IF(JVAR(J,NVAR).NE.0) GO TO 25
      NWIND=NWIND+1
   25 CONTINUE
      IF(NWIND.EQ.0) GO TO 500
C
      KODE=PESP(LP+5)
      KOD=IABS(KODE)
      VALUE=PESP(LP+6)
      IF(ICRIT.EQ.0) GO TO 30
      IF(NVAR.NE.IOVAR.OR.KOD.NE.KODSEG) GO TO 30
      VALUE=VALSEG
   30 LA=PESP(LP+7)
C
C
C   CALCULATE LOCATION OF TS IN ACCUMULATOR ARRAY FOR FIRST WINDOW
C
      LENUSE=0
      DO 400 I=1,2
      LTS=9*I+3+LP
      TSIND=PESP(LTS+5)
      IF(TSIND.NE.OBS) GO TO 100
C
C   OBS TIME SERIES
C
      LENWIN=LENOBS*NVAL
      GO TO (350,350,40,60), IEPASS
C
C   CONDITIONAL PASS
C
   40 IP=1+LENUSE
      IF(IHYR.GT.IBHYR) IP=(IHYR-IBHYR)*NVAL+1+LENUSE
      GO TO 80
C
C   BASE PERIOD PASS
C
   60 IP=1+LENUSE
      IF(IHYR.LT.IBHYR) IP=(IBHYR-IHYR)*NVAL+1+LENUSE
C
   80 LENUSE=NWIND*LENWIN+LENUSE
      GO TO 200
C
  100 IF(TSIND.NE.SIM) GO TO 400
C
C   SIMULATED TIME SERIES
C
      LENWIN=NYRS*NVAL
      GO TO (120,140,160,360), IEPASS
C
C   HISTORICAL PASS
C
  120 IP=LENUSE+1
      GO TO 180
C
C   ADJUSTED PASS
C
  140 IP=LENUSE+NWIND*JHSS*NYRS*NVAL + 1
      GO TO 180
C
C   CONDITIONAL PASS
C
  160 IP=LENUSE+(JHSS+JASS)*NWIND*NYRS*NVAL + 1
C
  180 LENUSE=NWIND*LENSIM*NVAL+LENUSE
C
C
  200 LOCA=LA+IP+(KNTYR-1)*NVAL-1
C
C   CALL ACCUMULATOR ROUTINES FOR ALL WINDOWS FOR EACH TIME SERIES
C
      TSID(1)=PESP(LTS+1)
      TSID(2)=PESP(LTS+2)
      DTYPE=PESP(LTS+3)
C
C   GET NUMBER OF VALUES PER DT AND TIME SCALE
C
      CALL FDCODE(DTYPE,ISUNA,IDIMS,MSG,NPDT,ITSCAL,NADD,IERR)
      IF(IERR.EQ.0) GO TO 210
      WRITE(IPR,600)
  600 FORMAT(1H0,10X,33H**ERROR** IN FDCODE-EACDRV QUITS.)
      CALL ERROR
      GO TO 999
C
  210 IDT=PESP(LTS+4)
      LD=PESP(LTS+6)
      IVALUE=PESP(LTS+6)*100.-LD*100.+.01
      IF(IVALUE.EQ.0) IVALUE=1
      CO=PESP(LTS+6+ICO)
C
      DO 300 J=1,NUMWIN
      IF(JVAR(J,NVAR).NE.0) GO TO 300
C
      CARRY=CO
C
      IF(LBUG) WRITE(IODBUG,920)IEPASS,TSID,DTYPE,IDT,J,LD,LOCA,NVAR,
     1 IDLOOP,NYRS,KNTYR,CARRY,IFLAG,KODE,VALUE,IHZERO
  920 FORMAT(1H0,10X,44HIEPASS,TSID,DTYPE,IDT,J,LD,LOCA,NVAR,IDLOOP,,
     1 41HNYRS,KNTYR,CARRY,IFLAG,KODE,VALUE,IHZERO=/11X,I5,2X,2A4,2X,A4,
     2 5I5,I10,2I5,F10.2,2I5,F10.2,I5)
C
      CALL EACTIM(D(1),LD,A,LOCA,NVAR,IDLOOP,J,NVAL,NYRS,KNTYR,TSID,
     1 DTYPE,IDT,NPDT,ITSCAL,IVALUE,CARRY,KODE,VALUE,IHZERO,D(LW),MAXW,
     2 IFLAG)
C
      IF(IFLAG.EQ.1) PESP(LTS+6+ICO)=CARRY
C
      LOCA=LOCA+LENWIN
  300 CONTINUE
C
      GO TO 400
C
C   SKIP SPACE IN A ARRAY USED FOR OBS. TIME SERIES
C
  350 LENUSE=NWIND*LENWIN+LENUSE
      GO TO 400
C
C   SKIP SPACE IN A ARRAY USED FOR SIM. TIME SERIES
C
  360 LENUSE=NWIND*LENSIM*NVAL+LENUSE
C
  400 CONTINUE
C
  500 IF(NEXVAR.GT.LPESP) GO TO 999
      LP=NEXVAR-1
C
      GO TO 20
  999 CONTINUE
      IOPNUM=IOLDOP
      OPNAME(1)=OLDOPN(1)
      OPNAME(2)=OLDOPN(2)
      RETURN
      END