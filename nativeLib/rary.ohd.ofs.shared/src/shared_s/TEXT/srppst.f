C MODULE SRPPST
C-----------------------------------------------------------------------
C
C  ROUTINE TO PRINT MESSAGES BASED ON STATUS CODE FROM RPPREC.
C
      SUBROUTINE SRPPST (XID,TYPE,IREC,LARRAY,NFILL,IRECNX,ISTAT)
C
C  IF ISTAT IS POSITIVE, MESSAGE WILL BE PRINTED AS AN ERROR.
C  IF ISTAT IS NEGATIVE, MESSAGE WILL BE PRINTED AS A WARNING.
C
      CHARACTER*4 TYPE
      CHARACTER*8 XID
      CHARACTER*8 TPMSG/'????????'/
C
      INCLUDE 'uiox'
      INCLUDE 'scommon/sudbgx'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/shared_s/RCS/srppst.f,v $
     . $',                                                             '
     .$Id: srppst.f,v 1.3 2001/06/13 13:29:11 dws Exp $
     . $' /
C    ===================================================================
C
C
      IF (ISTRCE.GT.1) THEN
         WRITE (IOSDBG,*) 'ENTER SRPPST'
         CALL SULINE (IOSDBG,1)
         ENDIF
C
      IASTAT=IABS(ISTAT)
C
C  CHECK FOR STATUS CODE OF ZERO
      IF (IASTAT.EQ.0) THEN
         WRITE (LP,30) ISTAT
         CALL SULINE (LP,2)
         GO TO 10
         ENDIF
C
C  SET TYPE OF MESSAGE
      IF (ISTAT.GT.0) TPMSG='ERROR'
      IF (ISTAT.LT.0) TPMSG='WARNING'
      CALL ULENTH (TPMSG,LEN(TPMSG),LTPMSG)
C
C  CHECK FOR BLANK IDENTIFIER
      CALL SUBLID (XID,IERR)
C
C  SYSTEM ERROR READING FILE
      IF (IASTAT.EQ.1) THEN
         WRITE (LP,40) TPMSG(1:LTPMSG),TYPE,XID
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         GO TO 10
         ENDIF
C
C  PARAMETER RECORD NOT FOUND OR NO PARAMTER RECORDS DEFINED FOR TYPE
      IF (IASTAT.EQ.2) THEN
         WRITE (LP,50) TPMSG(1:LTPMSG),TYPE,XID,TYPE
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         IF (IREC.GT.0.OR.ISDBUG.GT.0) THEN
            WRITE (LP,60) IREC
            CALL SULINE (LP,1)
            ENDIF
         GO TO 10
         ENDIF
C
C  PARAMETER ARRAY TOO SMALL
      IF (IASTAT.EQ.3) THEN
         WRITE (LP,70) TPMSG(1:LTPMSG),TYPE,XID
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         WRITE (LP,80) LARRAY,NFILL
         CALL SULINE (LP,1)
         GO TO 10
         ENDIF
C
C  INVALID PARAMETER TYPE
      IF (IASTAT.EQ.4) THEN
         WRITE (LP,90) TPMSG(1:LTPMSG),TYPE,XID
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         GO TO 10
         ENDIF
C
C  POINTER OUT OF RANGE
      IF (IASTAT.EQ.5) THEN
         WRITE (LP,100) TPMSG(1:LTPMSG),IREC,XID,TYPE
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         GO TO 10
         ENDIF
C
C  LAST RECORD IN FILE FOR TYPE IS DELETED
      IF (IASTAT.EQ.6) THEN
         WRITE (LP,110) TPMSG(1:LTPMSG),TYPE
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         GO TO 10
         ENDIF
C
C  RECORD IN INDEX DOES NOT MATCH RECORD IN FILE
      IF (IASTAT.EQ.7) THEN
         WRITE (LP,120) TPMSG(1:LTPMSG),XID,TYPE
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         GO TO 10
         ENDIF
C
C  RECORD IN INDEX DOES NOT MATCH RECORD IN FILE
      IF (IASTAT.EQ.8) THEN
         WRITE (LP,130) TPMSG(1:LTPMSG),XID,TYPE,IABS(IREC)
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         GO TO 10
         ENDIF
C
C  RECORD IN INDEX DOES NOT MATCH RECORD IN FILE
      IF (IASTAT.EQ.9) THEN
         WRITE (LP,140) TPMSG(1:LTPMSG),TYPE,IABS(IREC)
         IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
         IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
         GO TO 10
         ENDIF
C
C  INVALID STATUS CODE
      WRITE (LP,150) TPMSG(1:LTPMSG),ISTAT
      IF (ISTAT.GT.0) CALL SUERRS (LP,2,-1)
      IF (ISTAT.LT.0) CALL SUWRNS (LP,2,-1)
C
10    IF (ISTRCE.GT.1) THEN
         WRITE (IOSDBG,*) 'EXIT SRPPST'
         CALL SULINE (ISDBUG,1)
         ENDIF
C
      RETURN
C
C- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
C
30    FORMAT ('0*** NOTE - IN SRPPST - RPPREC STATUS CODE=',I2)
40    FORMAT ('0*** ',A,' - IN RPPREC - SYSTEM ERROR WHILE ',
     *   'READING PARAMETER TYPE ',A,' FOR IDENTIFIER ',A,' FROM ',
     *   'FILE.')
50    FORMAT ('0*** ',A,' - IN RPPREC - ',A,' PARAMETER RECORD ',
     *   'NOT FOUND FOR IDENTIFIER ',A,' OR NO PARAMETER RECORDS ',
     *   'DEFINED FOR TYPE ',A,'.')
60    FORMAT (25X,'PARAMETER RECORD LOCATION POINTER=',I5)
70    FORMAT ('0*** ',A,' - IN RPPREC - PARAMETER ARRAY TOO SMALL ',
     *   'TO HOLD ENTIRE ',A,' PARAMETER RECORD FOR IDENTIFIER ',A,
     *   '.')
80    FORMAT (25X,'NUMBER OF WORDS IN PARAMETER ARRAY=',I5,5X,
     *   'NUMBER OF WORDS IN PARAMETER RECORD=',I5)
90    FORMAT ('0*** ',A,' - IN RPPREC - PARAMETER TYPE ',A,
     *   ' SPECIFIED FOR IDENTIFIER ',A,' IS NOT DEFINED.')
100   FORMAT ('0*** ',A,' - IN RPPREC - POINTER TO PARAMETER ',
     *   'RECORD (',I5,') FOR IDENTIFIER ',A,' AND TYPE ',A,
     *   ' IS OUT OF ALLOWABLE RANGE.')
110   FORMAT ('0*** ',A,' - IN RPPREC - LAST RECORD IN FILE FOR ',
     *   'PARAMETER TYPE ',A,' IS DELETED.')
120   FORMAT ('0*** ',A,' - IN RPPREC - IDENTIFIER (',A,') AND ',
     *   'TYPE (',A,') IN INDEX DO NOT MATCH THAT IN PARAMETER ',
     *   'RECORD.')
130   FORMAT ('0*** ',A,' - IN RPPREC - IDENTIFIER (',A,') AND ',
     *   'TYPE (',A,') NOT FOUND AT SPECIFIED RECORD NUMBER (',I5,').')
140   FORMAT ('0*** ',A,' - IN RPPREC - DELETED PARAMETER RECORD ',
     *   'FOUND FOR TYPE ',A,' AT SPECIFIED RECORD NUMBER (',I5,').')
150   FORMAT ('0*** ',A,' - IN SRPPST - STATUS CODE NOT ',
     *   'RECOGNIZED: ',I3)
C
      END