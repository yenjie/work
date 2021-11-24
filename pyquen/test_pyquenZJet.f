*------------------------------------------------------------------------------
*
* Filename             : TEST_PYQUEN.F
*
*==============================================================================
*
* Description : Example program to simulate partonic rescattering and energy
*               loss in quark-gluon plasma in AA collisions with PYQUEN-code   
*               (should be compiled with pyquen1_5.f and latest pythia 
*               (pythia6401.f or later versions)
*                
*==============================================================================
 
      IMPLICIT DOUBLE PRECISION(A-H, O-Z)
      IMPLICIT INTEGER(I-N)
      INTEGER PYK,PYCHGE,PYCOMP   
      external pydata  
      external pyp,pyr,pyk     
      common /pyjets/ n,npad,k(4000,5),p(4000,5),v(4000,5)
      common /pydat1/ mstu(200),paru(200),mstj(200),parj(200)         
      common /pysubs/ msel,mselpd,msub(500),kfin(2,-40:40),ckin(200)
      common /pypars/ mstp(200),parp(200),msti(200),pari(200)
      common /pyqpar/ T0,tau0,nf,ienglu,ianglu  
      common /plfpar/ bgen
      COMMON/PYDAT3/MDCY(500,3),MDME(8000,2),BRAT(8000),KFDP(8000,5)
      COMMON/PYDATR/MRPY(6),RRPY(100)
      INTEGER MRPY
      DOUBLE PRECISION RRPY

      character firstchar
      character*80 label,value,buffer
      CHARACTER(LEN=100) filename,outfile
      INTEGER NJOB,ios,pos,quenching
      
* printout of PYQUEN version
* input: 1 - printout, 0 - no printout
* output: first (Av), second (Bv) and third (Cv) digits of version
      call PYQVER(1,Av,Bv,Cv)

* set initial beam parameters 
      energy=5020.d0                 ! c.m.s energy per nucleon pair 
      A=207.d0                       ! atomic weigth         
      ifb=1                          ! flag for fixed impact parameter
      bfix=0.d0                      ! impact parameter in [fm] 
c      ifb=1                          ! flag for distribution of impact parameter between bmin and bmax   
      bmin=0.d0                      ! minimum impact parameter in [fm]
      bmax=30.d0                     ! maximum impact parameter in [fm]
 
* set of input PYQUEN parameters: 
* ienglu=0 - radiative and collisional loss, ienglu=1 - only radiative loss, 
* ienglu=2 - only collisional loss;  
* ianglu=0 - small-angular radiation, ianglu=1 - wide angular radiation, 
* inanglu=2 - collinear radiation 
      ienglu=0                       ! set type of partonic energy loss
      ianglu=1                       ! set angular spectrum of gluon radiation    
      T0=1.d0                        ! initial QGP temperature 
      tau0=0.1d0                     ! proper time of QGP formation 
      nf=0                           ! number of active quark flavours in QGP 

* set of input PYTHIA parameters 
      msel=0                        ! QCD-dijet production 
      MSUB(30)=1
      MSUB(15)=1
	  MDME(174,1)=0          !Z decay into d dbar', 
	  MDME(175,1)=0          !Z decay into u ubar', 
	  MDME(176,1)=0          !Z decay into s sbar', 
	  MDME(177,1)=0          !Z decay into c cbar', 
	  MDME(178,1)=0          !Z decay into b bbar', 
	  MDME(179,1)=0          !Z decay into t tbar', 
	  MDME(182,1)=0          !Z decay into e- e+', 
	  MDME(183,1)=0          !Z decay into nu_e nu_ebar', 
	  MDME(184,1)=1          !Z decay into mu- mu+', 
	  MDME(185,1)=0          !Z decay into nu_mu nu_mubar', 
	  MDME(186,1)=0          !Z decay into tau- tau+', 
	  MDME(187,1)=0          !Z decay into nu_tau nu_taubar',
      paru(14)=1.d0                 ! tolerance parameter to adjust fragmentation 
      mstu(21)=1                    ! avoid stopping run 
      ckin(3)=150.d0                 ! minimum pt in initial hard sub-process 
      mstp(51)=7                    ! CTEQ5M pdf 
      mstp(81)=0                    ! pp multiple scattering off 
      mstp(111)=0                   ! hadronization off 

* set original test values for mean pt and event multiplicity 
      pta0=0.77d0 
      dna0=207.d0   
* set initial test values and its rms 
      ptam=0.d0 
      ptrms=0.d0        
      dnam=0.d0  
      dnrms=0.d0  

* set number of generated events 
      ntot=10000
      OUTFILE='output'
      quenching=1

      if (iargc().eq.0) then
          write(*,*)'No parameter file given, '// 
     &'will run with default settings.'
       else
          call getarg(1,filename)
          write(*,*)'Reading parameters from ',filename
          open(unit=1,file=filename,status='old',err=110)
          do 120 i=1,1000
          read(1, '(A)', iostat=ios) buffer
            if(ios.ne.0) goto 130
            firstchar = buffer(1:1)
            if (firstchar.eq.'#') goto 120
          pos=scan(buffer,' ')
          label=buffer(1:pos)
          value=buffer(pos+1:)
          if(label.eq."NEVENT")then
            read(value,*,iostat=ios) ntot
          elseif(label.eq."NJOB")then
            read(value,*,iostat=ios) njob
          elseif(label.eq."OUTFILE")then
            read(value,'(a)',iostat=ios) outfile
          elseif(label.eq."WIDE")then
            read(value,*,iostat=ios) ianglu
          elseif(label.eq."BMIN")then
            read(value,*,iostat=ios) bmin
          elseif(label.eq."BMAX")then
            read(value,*,iostat=ios) bmax
          elseif(label.eq."PTHAT")then
            read(value,*,iostat=ios) PTHAT

         endif
120      continue

110      write(*,*)
     &          'Unable to open parameter file, will exit the run.'
          call exit(1)
130      close(1,status='keep')
          write(*,*)'...done'

   
      endif

      ckin(3)=PTHAT                 ! minimum pt in initial hard sub-process 


      write(*,*) "Bmin=",bmin," BMax=",bmax

      IF(NJOB.GT.0)THEN
       MRPY(1)=NJOB*1000
       MRPY(2)=0
      ENDIF


* initialization of pythia configuration 
      call pyinit('CMS','p','p',energy)     
      logfid=7
      OPEN(unit=logfid,file=outfile,status='unknown')

      MSTU(11)=logfid
      do ne=1,ntot                  ! cycle on events 
c       mstj(41)=0                   ! vacuum showering off 
       call pyevnt                  ! generate single partonic jet event         
       if (quenching.gt.0) then
          call pyquen(A,ifb,bfix,bmin,bmax)      ! set parton rescattering and energy loss        
       endif
       call pyexec                  ! hadronization done 
       call pyhepc(1)            
       write(6,*) '# event ',ne, ' ', ianglu
       write(logfid,*) '# event ',ne
       call pylist(1)
       call pyedit(2)               ! remove unstable particles and partons 
       write(logfid,*) 'end'
       do ip=1,n                    ! cycle on n particles        
        pt=pyp(ip,10)               ! transverse momentum pt 
* add current test value of pt and its rms 
	ptam=ptam+pt  
	ptrms=ptrms+(pt-pta0)**2
       end do 
       
       write(6,*) 'Impact parameter',bgen,'fm'       

* add current test value of event multiplicity and its rms 
       dnam=dnam+n          
       dnrms=dnrms+(n-dna0)**2 
      end do 

* test calculating and printing of original "true" numbers 
* and generated one's (with statistical errors) 
      ptam=ptam/dnam 
      ptrms=dsqrt(ptrms)/dnam
      dnam=dnam/ntot
      dnrms=dsqrt(dnrms)/ntot 
*      write(6,1) dna0
*1     format(2x,'True mean multiplicity =',d10.3) 
*      write(6,2) dnam, dnrms 
*2     format(2x,'Generated mean multiplicity      =',d10.3,3x,
*     > '+-  ',d9.2) 
*      write(6,5) pta0
*5     format(2x,'True mean transverse momentum =',d9.2)   
*      write(6,6) ptam, ptrms 
*6     format(2x,'Generated mean transverse momentum      =',d9.2,3x,
*     > '+-  ',d9.2)    
               
      end
*******************************************************************************
