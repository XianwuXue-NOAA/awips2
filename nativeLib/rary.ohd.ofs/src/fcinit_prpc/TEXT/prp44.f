C MEMBER PRP44
C  (from old member FCPRP44)
C-----------------------------------------------------------------------
C
C                             LAST UPDATE: 06/23/95.16:29:55 BY $WC30RE
C
C @PROCESS LVL(77)
C
      SUBROUTINE PRP44 (P)

C     THIS IS THE PRINT PARAMETER ROUTINE FOR SSARR ROUTING.

C     THIS ROUTINE ORIGINALLY WRITTEN BY
C        RAY FUKUNAGA - NWRFC   SEPTEMBER 1993

C     DEFINITION OF VARIABLES
C     IVERSN = I4     VERSION NUMBER OF OPERATION
C     CTITLE = C72    GENERAL NAME OR TITLE FOR OPERATION

C     START INFLOW TIME SERIES USED TO CONSERVE INFLOW HYDROGRAPH VOLUME
C     CIDINS = C8     START INFLOW TIME SERIES IDENTIFIER
C     CODINS = C4     START INFLOW DATA TYPE CODE 
C     CODINS MAY BE CODED AS 'NONE' IN THE CASE THAT ONLY THE END INFLOW
C     TIME SERIES IS SPECIFIED TO DESCRIBE THE INFLOW HYDROGRAPH
C     IN THIS CASE THE INITIAL START INFLOW MUST COME FROM THE
C     CARRYOVER ARRAY

C     END INFLOW TIME SERIES
C     CIDINE = C8     END INFLOW TIME SERIES IDENTIFIER
C     CODINE = C4     END INFLOW DATA TYPE CODE 

C     START OUTFLOW TIME SERIES USED TO CONSERVE OUTFLOW ROUTED
C     HYDROGRAPH VOLUME
C     CIDOTS = C8     START OUTFLOW TIME SERIES IDENTIFIER
C     CODOTS = C4     START OUTFLOW DATA TYPE CODE 
C     CODOTS MAY BE CODED AS 'NONE' IN THE CASE THAT ONLY THE END OUTFLOW
C     TIME SERIES IS SPECIFIED TO DESCRIBE THE OUTFLOW HYDROGRAPH

C     END OUTFLOW TIME SERIES IS THE ROUTED HYDROGRAPH
C     CIDOTE = C8     END OUTFLOW TIME SERIES IDENTIFIER
C     CODOTE = C4     END OUTFLOW DATA TYPE CODE 

C     NPHASE = I4     NUMBER OF ROUTING PHASES (MUST BE > 0)
C     RN     = R4     N VALUE OF KTS/Q**N COMPUTATION
C     RKTS   = R4     KTS VALUE IN HOURS IF N IS NONZERO
C     NPQTST = I4     NUMBER OF POINTS IN THE DISCHARGE-TIME OF
C                     STORAGE TABLE (MAX 50 POINTS)
C     NCOMP  = I4     COMPUTATIONAL TIME INTERVAL
C     QTABLE = R4(1)  DISCHARGE POINTS IN DISCHARGE-TIME OF STORAGE
C                     TABLE
C     TSTORE = R4     TIME OF STORAGE CALCULATED
C     TSTBLE = R4(1)  TIME OF STORAGE POINTS IN DISCHARGE-TIME OF
C                     STORAGE TABLE

C    POSITION     CONTENTS OF P ARRAY
C      1           VERSION NUMBER OF OPERATION
C      2-19        GENERAL NAME OR TITLE

C     USED TO CONSERVE INFLOW HYDROGRAPH VOLUME
C     20-21        START INFLOW TIME SERIES IDENTIFIER
C     22           START INFLOW DATA TYPE CODE 

C     INFLOW HYDROGRAPH
C     23-24        END INFLOW TIME SERIES IDENTIFIER
C     25           END INFLOW DATA TYPE CODE 

C     USED TO CONSERVE ROUTED HYDROGRAPH VOLUME
C     26-27        START OUTFLOW TIME SERIES IDENTIFIER
C     28           START OUTFLOW DATA TYPE CODE 

C     ROUTED OUTFLOW HYDROGRAPH
C     29-30        END OUTFLOW TIME SERIES IDENTIFIER
C     31           END OUTFLOW DATA TYPE CODE 

C     32           1 OR 2 INFLOW TIME SERIES SPECIFIED FLAG
C                  = 1, ONLY THE END INFLOW TIME SERIES IS SPECIFIED
C                  = 2, BOTH THE START AND END INFLOW TIME SERIES ARE
C                       SPECIFIED
C     33           1 OR 2 OUTFLOW TIME SERIES SPECIFIED FLAG
C                  = 1, ONLY THE END OUTFLOW TIME SERIES IS SPECIFIED
C                  = 2, BOTH THE START AND END OUTFLOW TIME SERIES ARE
C                       SPECIFIED
C     34           NUMBER OF ROUTING PHASES (MUST BE > 0)
C     35           N VALUE OF KTS/Q**N COMPUTATION
C                  IF N=0, THE TIME OF STORAGE IS EXTRACTED FROM THE
C                           DISCHARGE-TIME OF STORAGE TABLE
C     36           KTS VALUE IN HOURS IF N IS NONZERO
C     37           THE NUMBER OF POINTS ON THE DISCHARGE-TIME OF
C                  STORAGE TABLE IF N=0 (=0 IF N IS NONZERO)
C     38           COMPUTATIONAL TIME INTERVAL (HOURS)
C     39+          THE POINTS OF THE DISCHARGE-TIME OF STORAGE TABLE
C
C
C     THEREFORE THE NUMBER OF ELEMENTS REQUIRED IN THE P ARRAY IS
C        38 +
C         2 * NUMBER OF POINTS OF THE DISCHARGE-TIME OF STORAGE TABLE

C     POSITION     CONTENTS OF C ARRAY
C      1           INITIAL START INFLOW
C      2+          PHASE FLOW VALUES FROM REACH



      PARAMETER (MAXPH = 99)
      PARAMETER (MAXTBL = 50)

      CHARACTER *72 CTITLE
      CHARACTER * 8 CIDINS,CIDINE,CIDOTS,CIDOTE
      CHARACTER * 4 CODINS,CODINE,CODOTS,CODOTE

      DIMENSION RTITLE(18)
      DIMENSION RIDINS(2),RIDINE(2),RIDOTS(2),RIDOTE(2)
      DIMENSION P(*)

      EQUIVALENCE (CTITLE,RTITLE)
      EQUIVALENCE (CIDINS,RIDINS),(CIDINE,RIDINE)
      EQUIVALENCE (CIDOTS,RIDOTS),(CIDOTE,RIDOTE)
      EQUIVALENCE (CODINS,RODINS),(CODINE,RODINE)
      EQUIVALENCE (CODOTS,RODOTS),(CODOTE,RODOTE)

      INTEGER      PINT1
      REAL         PREAL(19)
      CHARACTER*4  PCHAR(19)
      EQUIVALENCE (PREAL(1),PCHAR(1))

C     COMMON BLOCKS

      COMMON/FDBUG/IODBUG,ITRACE,IDBALL,NDEBUG,IDEBUG(20)
      COMMON/IONUM/IN,IPR,IPU
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcinit_prpc/RCS/prp44.f,v $
     . $',                                                             '
     .$Id: prp44.f,v 1.2 1996/03/21 15:22:47 page Exp $
     . $' /
C    ===================================================================
C

C     CARD 1 - GENERAL USER SUPPLIED INFORMATION
C     CARD 2 - TIME SERIES DEFINITION
C        FIELD 1 - START INFLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 2 - START INFLOW DATA TYPE CODE (SINS) - 4 CHAR
C        FIELD 3 - END INFLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 4 - END INFLOW DATA TYPE CODE (SINE) - 4 CHAR
C        FIELD 5 - START OUTFLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 6 - START OUTFLOW DATA TYPE CODE (SOTS) - 4 CHAR
C        FIELD 7 - END OUTFLOW TIME SERIES IDENTIFIER - 8 CHAR
C        FIELD 8 - END OUTFLOW DATA TYPE CODE (SOTE) - 4 CHAR
C     CARD 3 - SSARR ROUTING CHARACTERISTICS
C        FIELD 1 - NUMBER OF ROUTING PHASES (MUST BE > 0)
C        FIELD 2 - N VALUE OF KTS/Q**N COMPUTATION
C                - IF N=0, THE TIME OF STORAGE IS EXTRACTED FROM THE
C                - DISCHARGE-TIME OF STORAGE TABLE
C        FIELD 3 - KTS VALUE IN HOURS IF N IS NONZERO
C        FIELD 4 - THE NUMBER OF POINTS ON THE DISCHARGE-TIME OF
C                  STORAGE TABLE
C        FIELD 5 - THE COMPUTATIONAL TIME INTERVAL
C                  MUST BE = INFLOW & OUTFLOW TIME INTERVAL
C     CARD 4+ - DISCHARGE-TIME OF STORAGE TABLE
C             - PAIRINGS OF DISCHARGE-TIME OF STORAGE POINTS
C             - ONLY ONE PAIR PER LINE AND A TOTAL MAXIMUM OF 50
C               POINTS ALLOWED
C             - MUST BE IN ASCENDING DISCHARGE ORDER
C             - THESE CARDS NECESSARY ONLY IF N=0
C               STORAGE IS EXTRACTED FROM THE DISCHARGE-TIME
C        FIELD 1 - DISCHARGE (CFS)
C        FIELD 2 - TIME OF STORAGE (HRS)
C
C     CARD 5  - INITIAL INFLOW
C     CARD 6+ - INITIAL PHASE FLOW VALUES



C        1         2         3         4         5         6         7
C23456789012345678901234567890123456789012345678901234567890123456789012
C        SSARR ROUTING - VERSION XXXX
C        SSARR ROUT - HILLS CREEK ROUTED TO LOOKOUT POINT
C
C        ------------------------------------------------
C
C                                             ID     CODE
C        START INFLOW TIME SERIES          XXXXXXXX  XXXX
C        END   INFLOW TIME SERIES          XXXXXXXX  XXXX
C        START OUTFLOW TIME SERIES         XXXXXXXX  XXXX
C        END   OUTFLOW TIME SERIES         XXXXXXXX  XXXX

C     CHECK TRACE LEVEL
      CALL FPRBUG ('PRP44   ',1,44,IBUG)

C     PRINT HEADING THEN TITLE FROM P ARRAY
      IVERSN = 1
        DO 23 II=2,19
   23   PREAL(II) = P(II)
      WRITE(IPR,501) IVERSN,(PCHAR(II),II=2,19)
 501  FORMAT(//,10X,'SSARR ROUTING - VERSION ',I4,/,
     +          10X,18A4,/)

        II = 0
        DO 24 JJ=20,31
        II = II+1
   24   PREAL(II) = P(JJ)
      WRITE(IPR,502) (PCHAR(II),II=1,12)
 502  FORMAT(///,
     +     10X,47('-'),//,
     +     10X,T47,'ID     CODE',/,
     +     10X,'START INFLOW TIME SERIES',9X,2A4,2X,A4,/,
     +     10X,'END   INFLOW TIME SERIES',9X,2A4,2X,A4,/,
     +     10X,'START OUTFLOW TIME SERIES',8X,2A4,2X,A4,/,
     +     10X,'END   OUTFLOW TIME SERIES',8X,2A4,2X,A4,/,
     +     10X,47('-'))


      PINT1 = P(34)
      WRITE(IPR,803) PINT1
 803  FORMAT(//,10X,'# OF ROUTING PHASES',/,
     +          10X,'-------------------',/,
     +          10X,'      ',I4,/,
     +       //,10X,'TIME OF STORAGE (HOURS) PER PHASE',/,
     +          10X,'---------------------------------')

      IF (P(35) .EQ. 0.) THEN
C        TIME OF STORAGE FUNCTION OF DISCHARGE
         WRITE(IPR,8040)
 8040    FORMAT(10X,'TIME OF STORAGE = FUNCTION (DISCHARGE)',/,
     +          10X,'      DISCHARGE VS. TIME STORAGE',/,
     +          10X,'        (CFS)          (HOURS)')
         DO 804 I=1,NINT(P(37))
            WRITE(IPR,8041) P(I*2+37),P(I*2+38)
 8041       FORMAT(10X,'      ',F9.1,6X,F9.1)
 804     CONTINUE
      ELSE
C        TIME OF STORAGE EQUATION
         WRITE(IPR,8140) P(36),P(35)
 8140    FORMAT(10X,'TIME OF STORAGE = ',F6.2,
     +              ' / (DISCHARGE (IN CFS) ** ',
     +          F6.2,')')
      ENDIF

      IF (ITRACE.GE.1) WRITE(IODBUG,199)
 199  FORMAT('PRP44:  EXITED:')

      RETURN
      END