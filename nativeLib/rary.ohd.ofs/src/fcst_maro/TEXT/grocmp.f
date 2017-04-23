C MEMBER GROCMP
C  (from old member PPGROCMP)
C
      SUBROUTINE GROCMP(A, DUR, B, C, C2, Y, BI, SM, SK, POW, IR,
     * API, RAIN, RI1, RI2, RO)
C
C.....THIS SUBROUTINE COMPUTES THE RUNOFF AFTER THE INTERIM EQUATIONS
C.....OF "Y" AND "C" HAVE BEEN SOLVED.
C
C.....THIS SUBROUTINE WAS DEVELOPED FROM WGRFC PROGRAM ONECL.
C
C.....HERE ARE THE ARGUMENTS TO ?GROCMP:
C
C.....A      - RAINFALL-RUNOFF RELATION CONSTANT FROM RFRO ARRAY.
C.....DUR    - RAINFALL DURATION.
C.....B      - RAINFALL-RUNOFF EQUATION INTERIM CONSTANT.
C.....C      - INTERIM EQUATION SOLUTION FROM GCYINT.
C.....C2     - RAINFALL-RUNOFF EQUATION INTERIM CONSTANT.
C.....Y      - INTERIM EQUATION SOLUTION FROM GCYINT.
C.....BI     - RAINFALL-RUNOFF RELATION CONSTANT.
C.....SM     - RAINFALL-RUNOFF RELATION CONSTANT.
C.....SK     - RAINFALL-RUNOFF RELATION CONSTANT.
C.....POW    - RAINFALL-RUNOFF RELATION CONSTANT.
C.....IR     - RAINFALL-RUNOFF RELATION NUMBER.
C.....API    - GRID POINT API.
C.....RAIN   - GRID POINT RAINFALL.
C.....RI1    - RAINFALL-RUNOFF EQUATION INTERIM CONSTANT.
C.....RI2    - RAINFALL-RUNOFF EQUATION INTERIM CONSTANT.
C.....RO     - GRID POINT RUNOFF TO BE COMPUTED.
C
C.....GROCMP WRITTEN BY:
C
C.....JERRY M. NUNN       WGRFC FT. WORTH, TEXAS       NOVEMBER, 1986
C
      INCLUDE 'common/pudbug'
C
C    ================================= RCS keyword statements ==========
      CHARACTER*68     RCSKW1,RCSKW2
      DATA             RCSKW1,RCSKW2 /                                 '
     .$Source: /fs/hseb/ob72/rfc/ofs/src/fcst_maro/RCS/grocmp.f,v $
     . $',                                                             '
     .$Id: grocmp.f,v 1.1 1995/09/17 19:02:28 dws Exp $
     . $' /
C    ===================================================================
C
C
  900 FORMAT(1H0, '*** ENTER GROCMP ***')
  901 FORMAT(1X, '*** EXIT GROCMP ***')
C
      DATA GRNF /4hGRNF/
C
      IF(IPTRCE .GE. 8) WRITE(IOPDBG,900)
C
C.....COMPUTE RI1 AND RI2.
C
      RI1 = (A + B*Y)*C**API
      RI2 = (RAIN*(RAIN/(RAIN + 1.0))**RI1)
C
C.....IF THE RAINFALL-RUNOFF RELATION NUMBER IS GREATER THAN 10, THEN
C.....MAKE NO FURTHER COMPUTATIONS. THE RUNOFF IS RI2, AS IT IS
C.....COMPUTED NOW.
C
      IF(IR .GT. 10) GOTO 100
C
C.....FOR THE OTHER RAINFALL-RUNOFF RELATIONS, MAKE ANOTHER SERIES OF
C.....COMPUTATIONS.
C
      C2 = ((RI1 + 1.0)*DUR)/(6.0 + SM*RI2**POW)
      RO = RI2*SK**C2
      GOTO 101
C
C.....THE RUNOFF IS THE VALUE OF RI2.
C
  100 RO = RI2
  101 IF(IPTRCE .GE. 8) WRITE(IOPDBG,901)
C
      RETURN
      END