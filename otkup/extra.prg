procedure amb
clear screen
setcolor(DEF_GREEN)
*set color to i
@ 00, 00 say center( "Unos zaduzenja ambalazom")
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1


select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif


select 3
if NET_USE ( 'AMB', .F. )
   set index to amb_sds,amb_dat,amb_ss
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'COMPANY', .F. )
else
  clos all
  RETURN   
endif		  

MAX=1000
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]

ox = 1

do while .T.
do red_screen with "Unos zaduzenja ambalazom"
//  restore screen from screen1
current = 1
do r_mes with ox
zad = 1
tek = 1
do rfill_kom with otk_sifra
do red_screen with "Unos zaduzenja ambalazom"
  //restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'000'
	 do zad_amb with komintent
	 case tek = 0
   setcolor(DEFAULT)
	 exit
	 otherwise
	 go rec[tek]
	 komintent=sifra_k
	 do zad_amb with komintent
  endcase
enddo
close all
ox = 1
clear screen
   setcolor(DEFAULT)
return




procedure zad_amb
parameters komi
clear screen
do red_screen with "Unos zaduzenja ambalazom"
  //restore screen from screen1
  select AMB
  dat=date()
akolc=0.00
akolr=0.00
dok=space(6)
status='Z'
@ 10,25 say 'Za datum : ' get dat
@ 12,25 say 'Dokument : ' get dok
read
seek komi+dtos(dat)+rtrim(dok)
if found()
akolc=amb_kol
akolr=amb_raz
dok=amb_doc
? CHR(7)
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "ZA OVOG KOMINTENTA ZA DANAS JE VEC UNETO ZADUZENJE !" )
inkey(0)
if lastkey()=27
return
endif
ENDIF
//@ 12,25 say 'Dokument : ' get dok
@ 14,25 say 'Amb. uzeta: ' get akolc picture '999999.99'
@ 16,25 say 'Amb. vrac.: ' get akolr picture '999999.99'
*@ 12,25 say 'Kolicina : ' get kolc picture '99999999'
*@ 14,25 say 'Razlika  : ' get kolr picture '99999999'
read
correct='D'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "Korektni podaci (D/N) ?" )
@ 22, 55 get correct picture '!'
read
	if correct='D'
seek komi+dtos(dat)+rtrim(dok)
if found()
    do req_rec_lock
	else
	do new_rec
endif
replace amb_sif with komi, amb_datum with dat, amb_kol with akolc,;
        amb_doc with dok,amb_raz with akolr
		else
seek komi+dtos(dat)+rtrim(dok)
    do req_rec_lock
		delete
     endif
/////*
do red_screen with "Unos zaduzenja ambalazom"
stampa='N'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa D/N)" )
@ 23, 60 get stampa picture '!'
read
if stampa='D'
set device to print
//for n=1 to 2

@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow()+1,1 say rtrim(COMPANY->co_line1)+' '+rtrim(COMPANY->co_line2)
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow(),60 say rtrim(COMPANY->co_line2)+' '+dtoc(dat)
//@ prow(),60 say 'Pozega '+dtoc(date())

@ prow()+2,1 say CENTER('MAGACINSKI IZLAZ BROJ '+dok)
@ prow()  ,1 say CENTER('MAGACINSKI IZLAZ BROJ '+dok)
@ prow()+2,1 say rtrim(MESTA->naziv_m)    &&+'  '+&file1->ime_k
@ prow()+1,0 say replicate ('-',79)
@ prow()+1,1 say '  A M B A L A Z A         '+space(3)+' Ulaz             Izlaz'
@ prow()+1,1 say '                  '+space(3)+str(akolr,12)
@ prow() ,40 say str(akolc,12)
@ prow()+2,1 say ' Magacioner     	                                Otkupljivac'
@ prow()+2,1 say ' ___________     	                                ___________'

@ prow()+10,1 say '   '
@ prow()+15,1 say '   '
//next
//eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
endif
/////*/
return



procedure amb_raz
clear screen
setcolor(DEF_RED)
*set color to i
@ 00, 00 say center( "Unos razduzenja ambalazom")
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1


select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif


select 3
if NET_USE ( 'AMB', .F. )
   set index to amb_sds,amb_dat
else
  clos all
  RETURN   
endif

MAX=1000
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]

ox = 1

do while .T.
  restore screen from screen1
current = 1
do r_mes with ox
zad = 1
tek = 1
do rfill_kom with otk_sifra
  restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'000'
	 do raz_amb with komintent
	 case tek = 0
	 exit
	 otherwise
	 go rec[tek]
	 komintent=sifra_k
	 do raz_amb with komintent
  endcase
enddo
close all
ox = 1
clear screen
return




procedure raz_amb
parameters kom,dat,dok
clear screen
  restore screen from screen1
@ 6,25 say  'AMBALAZA'
  select AMB
*  dat=date()
kolc=0.00
kolr=0.00
*dok=space(6)
status='R'
@ 10,25 say 'Za datum : ' get dat
read
seek kom+dtos(dat)+status
if found()
kolc=amb_kol
kolr=amb_raz
dok=amb_doc
? CHR(7)
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "ZA OVOG KOMINTENTA ZA DANAS JE VEC UNETO RAZDUZENJE !" )
inkey(0)
if lastkey()=27
return
endif
ENDIF
@ 12,25 say 'Kolicina : ' get kolc picture '99999999'
@ 14,25 say 'Razlika  : ' get kolr picture '99999999'
@ 16,25 say 'Dokument : ' get dok
read
correct='D'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "Korektni podaci (D/N) ?" )
@ 22, 55 get correct picture '!'
read
	if correct='D'
seek kom+dtos(dat)+status
if found()
    do req_rec_lock
	else
	do new_rec
endif
replace amb_sif with kom, amb_datum with dat, amb_kol with kolc,;
        amb_doc with dok, amb_stat with status,amb_raz with kolr
     endif
return

*************************************
**KNJIZENJE AMBALAZE
*************************************
procedure knj_amb
clear screen
*set color to i
@ 00, 00 say center( "Pregled knjizenja")  
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1

select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'AMB', .F. )
   set index to amb_dat
else
  clos all
  RETURN   
endif

MAX=1000
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]
ox = 1
do while .T.
do red_screen with "Pregled knjizenja"
 // restore screen from screen1
current = 1
do w_mes with ox
if ox<100
zad = 1
tek = 1
do w_kom with otk_sifra
do red_screen with "Unos zaduzenja ambalazom"
  //restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra
	 do l_amb with komintent
	 case tek = 0
	 exit
	 otherwise
	 go rec[tek]
	 komintent=sifra_k
	 do l_amb1 with komintent
  endcase
  else
  do amb_sum
  exit
  endif
  enddo
  close all
  return


  procedure l_amb
  parameters komint
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak... ESC - Izlaz" )
store date() to datum1,datum2
amb_r=0
amb_z=0
//   datum1 = ctod( '01.01.' + substr( str( year( date() ), 4, 0 ), 3 ) )
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
**set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_amb
*clos all
return
endif
@ 1,1 to 1,79
@ 2,1 say '  Datum:     Dokument:           Zaduzenje:        Razduzenje:     Razlika:'
@ 3,1 to 3,79
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while  amb_datum<=datum2 .and. !eof()
if  substr(amb_sif,1,3)!=komint
skip 
loop
endif

//if amb_kol>0.00
	@ row()+1,1 say amb_datum
	@ row(),15 say amb_doc
	@ row(),30 say amb_kol picture '@E 999,999'
	amb_z=amb_z+amb_kol
	@ row(),50 say amb_raz picture '@E 999,999'
	@ row(),65 say amb_kol-amb_raz picture '@E 999,999'
	amb_r=amb_r+amb_raz
//endif

if row()=19
inkey(0)
	 if lastkey()=27
		  return
	  endif
@ 4,1 clear to 19,79
@ 3,1 to 3,79
endif

skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA: '
	@ row(),30 say amb_z picture '@E 999,999'
	@ row(),50 say amb_r picture '@E 999,999'
@ row()+1,0 say 'SALDO: '
	@ row(),40 say amb_z-amb_r picture '@E 999,999'
inkey(0)
return

  procedure l_amb1
  parameters komint
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak... ESC - Izlaz" )
store date() to datum1,datum2
amb_r=0
amb_z=0
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
**set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_amb_poj
*clos all
return
endif
@ 1,1 to 1,79
@ 2,1 say '  Datum:     Dokument:           Zaduzenje:            Razduzenje:'
@ 3,1 to 3,79
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while  amb_datum<=datum2 .and. !eof()
if  amb_sif!=komint
skip 
loop
endif

//if amb_kol>0.00
	@ row()+1,1 say amb_datum
	@ row(),15 say amb_doc
	@ row(),30 say amb_kol picture '@E 999,999'
	amb_z=amb_z+amb_kol
	@ row(),50 say amb_raz picture '@E 999,999'
	@ row(),65 say amb_kol-amb_raz picture '@E 999,999'
	amb_r=amb_r+amb_raz
//endif

if row()=19
inkey(0)
	 if lastkey()=27
		  return
	  endif
@ 4,1 clear to 19,79
@ 3,1 to 3,79
endif

skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA: '
	@ row(),30 say amb_z picture '@E 999,999'
	@ row(),50 say amb_r picture '@E 999,999'
@ row()+1,0 say 'SALDO: '
	@ row(),40 say amb_z-amb_r picture '@E 999,999'
inkey(0)
return

  procedure amb_sum
  parameters komint
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak... ESC - Izlaz" )
store date() to datum1,datum2
amb_r=0
amb_z=0
   datum1 = ctod( '01.01.' + substr( str( year( date() ), 4, 0 ), 3 ) )
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
**set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_amb_sum
*clos all
return
endif
@ 1,1 to 1,79
@ 2,1 say '  Datum:     Dokument:           Zaduzenje:            Razduzenje:'
@ 3,1 to 3,79
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while  amb_datum<=datum2 .and. !eof()

	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz


skip
enddo
@ row()+1,0 say 'SVEGA: '
	@ row(),35 say amb_z picture '@E 999,999'
	@ row(),55 say amb_r picture '@E 999,999'
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SALDO: '
	@ row(),45 say amb_z-amb_r picture '@E 999,999'
inkey(0)
return

*********************************************
**STAMPA KNJIZENJA

procedure prt_amb
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)

@ prow()+1,10 say 'Pregled ambalaze za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,30 say 'Za otkupno mesto '+kart[tekuci]
@ prow()+1,0 say replicate('-',79)
@ prow()+1,1 say '                           Zaduzenje:            Razduzenje:      Razlika:'
@ prow()+1,0 say replicate('-',79)
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while   amb_datum<=datum2 .and. !eof()
if  substr(amb_sif,1,3)!=komint
skip 
loop
endif

*if amb_kol<>0.00
	@ prow()+1,1 say amb_datum
	@ prow(),15 say amb_doc
	@ prow(),30 say amb_kol picture '@E 999,999'
	amb_z=amb_z+amb_kol
	@ prow(),50 say amb_raz picture '@E 999,999'
	@ prow(),65 say amb_kol-amb_raz picture '@E 999,999'
	amb_r=amb_r+amb_raz
*endif

if prow()>=65
@ prow()+1,0 say replicate('-',79)
eject
endif

skip
enddo
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA: '
	@ prow(),30 say amb_z picture '@E 999,999'
	@ prow(),50 say amb_r picture '@E 999,999'
@ prow()+1,0 say 'SALDO: '
	@ prow(),40 say amb_z-amb_r picture '@E 999,999'
	eject
	cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return
****************************************************
procedure prt_amb_poj
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)

@ prow()+1,10 say 'Pregled ambalaze za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,20 say komm[tek]
@ prow()+1,0 say replicate('-',79)
@ prow()+1,1 say '                           Zaduzenje:            Razduzenje:      Razlika:'
@ prow()+1,0 say replicate('-',79)
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while   amb_datum<=datum2 .and. !eof()
if  amb_sif!=komint
skip 
loop
endif

*if amb_kol>0.00
	@ prow()+1,1 say amb_datum
	@ prow(),15 say amb_doc
	@ prow(),30 say amb_kol picture '@E 999,999'
	amb_z=amb_z+amb_kol
	@ prow(),50 say amb_raz picture '@E 999,999'
	@ prow(),65 say amb_kol-amb_raz picture '@E 999,999'
	amb_r=amb_r+amb_raz
*endif

if prow()>=65
@ prow()+1,0 say replicate('-',79)
eject
endif

skip
enddo
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA: '
	@ prow(),30 say amb_z picture '@E 999,999'
	@ prow(),50 say amb_r picture '@E 999,999'
@ prow()+1,0 say 'SALDO: '
	@ prow(),40 say amb_z-amb_r picture '@E 999,999'
	eject
	cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return


procedure prt_amb_sum
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)

@ prow()+1,10 say 'Pregled ambalaze za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,30 say 'Za sva otkupna mesta '
@ prow()+1,0 say replicate('-',79)
@ prow()+1,1 say '                           Zaduzenje:            Razduzenje:      Razlika:'
@ prow()+1,0 say replicate('-',79)
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while   amb_datum<=datum2 .and. !eof()

	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz


skip
enddo
@ prow()+1,0 say 'SVEGA: '
	@ prow(),30 say amb_z picture '@E 999,999'
	@ prow(),50 say amb_r picture '@E 999,999'
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SALDO: '
	@ prow(),40 say amb_z-amb_r picture '@E 999,999'
	eject
	cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

*************************************************************
**AMBALAZA
*************************************************************

*sva mesta 
procedure amb_pomestu
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'AMB', .F. )
   set index to amb_dat
else
  clos all
  RETURN   
endif
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
amb_z=0.00
amb_r=0.00
uk_amb=0.00
zamb_z=0.00
zamb_r=0.00
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do pr_ambb
clos all
return
endif

		@ 1,1 to 1,79
@ row(),42 say 'Zaduzenje:'
@ row(),55 say 'Razduzenje:'
@ row(),70 say 'Saldo:'
@ row()+1,0 to row()+1,79
save screen to scr
select MESTA
	go top
do while !eof()

	
*********************************
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while  amb_datum<=datum2 .and. !eof()
if  substr(amb_sif,1,3)!=MESTA->SIFRA_M 
skip 
loop
endif

//if amb_kol<>0.00
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
//endif


skip
enddo



*********************************

@ row()+1,1 say MESTA->NAZIV_M
*@ row(),27 say ukupno picture '@E 999,999.99'
@ row(),40 say amb_z picture '@E 999,999'
@ row(),52 say amb_r picture '@E 999,999'
@ row(),70 say amb_z-amb_r picture '@E 999,999'
uk_amb=uk_amb+(amb_z-amb_r)
zamb_z=zamb_z+amb_z
zamb_r=zamb_r+amb_r
amb_z=0.00
amb_r=0.00

if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
@ 4,1 clear to 20,79
		@ 1,1 to 1,79
@ row(),42 say 'Zaduzenje:'
@ row(),55 say 'Razduzenje:'
@ row(),70 say 'Saldo:'
@ row()+1,0 to row()+1,79
endif

select MESTA
	skip
enddo


*
*	skip
*enddo


@ row()+1,0 to row()+1,79
@ row(),0 say 'SVEGA:'
@ row(),40 say zamb_z picture '@E 999,999'
@ row(),52 say zamb_r picture '@E 999,999'
@ row(),70 say uk_amb picture '@E 999,999'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "ESC - Izlaz" )
inkey(0)
return
**********************************
*STAMPA KUMULATIVA
**********************************
procedure pr_ambb
amb_z=0.00
amb_r=0.00
zamb_z=0.00
zamb_r=0.00
uk_amb=0.00
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,5 say 'Izvestaj o ambalazi od '+' '+dtoc(datum1)+' do '+dtoc(datum2)+' '+'za sva otkupna mesta'
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say 'Otkupno mesto:'
*@ prow()+1,10 say 'Datum:'
@ prow(),42 say 'Zaduzenje:'
@ prow(),55 say 'Razduzenje:'
@ prow(),70 say 'Saldo:'
@ prow()+1,0 say replicate ('-',80)
select MESTA
	go top
do while !eof()
*********************************
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while  amb_datum<=datum2 .and. !eof()
if  substr(amb_sif,1,3)!=MESTA->SIFRA_M 
skip 
loop
endif

*if amb_kol<>0.00
*   if amb_stat='Z'
	amb_z=amb_z+amb_kol
*	else
	amb_r=amb_r+amb_raz
*    endif
*endif


skip
enddo
*********************************
@ prow()+1,1 say MESTA->NAZIV_M
@ prow(),40 say amb_z picture '@E 999,999'
@ prow(),52 say amb_r picture '@E 999,999'
@ prow(),70 say amb_z-amb_r picture '@E 999,999'
uk_amb=uk_amb+(amb_z-amb_r)
zamb_z=zamb_z+amb_z
zamb_r=zamb_r+amb_r

amb_z=0.00
amb_r=0.00
		if prow()>=60
		eject
		@ prow()+2,1 say '  '
		endif
select MESTA
	skip
enddo

@ prow()+1,0 say replicate ('-',80)
@ prow()+1,0 say 'SVEGA:'
@ prow(),40 say zamb_z picture '@E 999,999'
@ prow(),52 say zamb_r picture '@E 999,999'
@ prow(),70 say uk_amb picture '@E 999,999'
@ prow()+1,0 say replicate ('-',80)
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

procedure e_kom
clear screen
setcolor(DEF_GREEN)
MAX=1000
declare kart [ 100 ]
declare rec_no[ 100 ]
declare komint [ MAX ]
declare xkomx [ MAX ]
declare rec[ MAX ]
declare xrec[ MAX ]
last_sif=0
*set color to i
@ 00, 00 say center( "Unos i ispravka proizvodjaca")
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
*@ 2, 25 say 'Mesto:'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_no,kom_name
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'TMPK5', .T. )
set index to tmp5, tmpKS5
file1='tmpk5'
ind2='tmp5'
ind1='tmpKS5'
zap
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'KOMX', .F. )
   set index to komx
else
  clos all
  RETURN   
endif

do u_mesta
do red_screen with "Unos i ispravka proizvodjaca"
    //restore screen from screen1
	 m_PR = space( 60 )
	 m_PR_MES = space( 20 )
zad = 1
tek = 1
do fill_komint with otk_sifra
do while .T.
do red_screen with "Unos i ispravka proizvodjaca"
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
  //restore screen from screen1
  tek = achoice(3,15,19,65,komint,.T.,'',tek,tek-1)
  do case
     case tek = zad
          do new_kom
     case tek = 0
          close all
          clear screen
   setcolor(DEFAULT)
          return
     otherwise       
          do edit_kom
  endcase
enddo
close all
clear screen
return

procedure fill_komint
select KOM
go top
zad = 1
select &file1
zap
set index to &ind1, &ind2
reindex
//zap
append from kom for substr(sifra_k,1,3)=otk_sifra
set order to 2
go top
do while !eof()
   komint [ zad ] = ime_k+' '+mesto_k
    rec [ zad ] = recno()
   zad = zad + 1
   skip
enddo

komint [ zad ] = '*** Unos ****'
set order to 1

		return

procedure xfill_komint
parameters desc  
new_dt_call = pcount() != 0
select KOM
go top
zad = 1
*seek desc
*if found()
*do while ime_k=desc .and. !eof()
do while !eof()
	if substr(sifra_k,1,3)!=otk_sifra
	skip
	loop
	endif
//  komint [ zad ] = ime_k+' '+mesto_k+' '+sifra_k
  komint [ zad ] = ime_k+'  '+sifra_k
   rec [ zad ] = recno()
   if new_dt_call 
   if ime_k = m_PR
         tek = zad
   endif
   endif
   zad = zad + 1
   skip
enddo
*   endif

komint [ zad ] = '*** Unos podataka ****'
for i = zad + 1 to MAX
    komint [ i ] = ''
next
return

procedure fill_komx
parameters X_PR
xkom= len(rtrim(x_pR))
select 4
go top
xzad = 1
set softseek on
seek rtrim(x_pr)
if found()
do while (ime_k)=rtrim(X_PR) .and. !eof()
   xkomx [ xzad ] = ime_k+' '+mesto_k
    xrec [ xzad ] = recno()
   xzad = xzad + 1
   skip
enddo
endif

komint [ zad ] = '*** Kraj ****'

		return

procedure new_kom
zad_sif=val(otk_sifra)
z_sif=0
clear screen
@ 00, 00 say center( "Unos podataka o proizvodjacima")
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
save screen to ekran
do red_screen with "Unos podataka o proizvodjacima"
select &file1
   go bottom
z_sif=val(sifra_k)
		 if empty(z_sif)
		 z_sif=zad_sif*1000
         m_SIFRA=ltrim(str(z_sif+1))
		 else
         m_SIFRA=ltrim(str(z_sif+1))
		 endif
	 m_PR = space( 60 )
	 m_PR_MES = space( 20 )
	 w_ugo=space(20)
	 w_pov=0
	 w_tr=space(30)
	 w_jmbg=space(13)
	 w_pdv='D'
	 w_kat=' '
  @  6, 20  say "Sifra       :" + m_sifra
  @  8, 20  say "Prezime i ime    :" get m_PR picture '@!'
  read

do fill_komx with m_PR
xtek = 1
do while .T.
do red_screen with "Unos podataka o proizvodjacima"
  //restore screen from screen1
  xtek = achoice(3,15,19,65,xkomx,.T.,'',xtek,xtek-1)

  do case
//     case xtek = zad
//          exit
     case xtek = 0
          exit
     otherwise       
         do new_komx with xtek
		 return
  endcase

  enddo

  //restore screen from screen1
  do red_screen with "Unos podataka o proizvodjacima"
  @  10, 20  say "JMBG             :" get w_jmbg  
  @  12, 20  say "Poreska izjava   :" get m_PR_MES picture '@!'
  @  14, 20  say "Ugovor           :" get w_ugo 
  @  16, 20  say "Povrsina parcele :" get w_pov picture '@E 999,999.99'
  @  18, 20  say "Tekuci racun     :" get w_tr 
  @  20, 20  say "PDV              :" get w_pdv
  @  20, 40  say "Kategorija       :" get w_kat

  read
   indx= ASCAN(komint, m_PR)
   if indx != 0   && find !!!!
   ? chr(7)
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'Komintent sa istim imenom postoji ! ESC-> Izlaz' )
inkey(0)
endif
if lastkey()=27
return
endif
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
if ok = 'D' .and. !empty( m_PR )
   if zad >= MAX
      ?? chr(7)
      @ 22, 0 say centermsg( 'Maximum ' + str( MAX-1,3,0) + ' proizvodjaca dozvoljeno!' )
      @ 23, 0 say centermsg( 'Pritisnite bilo koju tipku za nastavak' )
      inkey(0)
      return
   endif
   indx= ASCAN(komint, m_PR)

   if indx = 0   && no match
      @ 22, 0 say centermsg( 'Dodavanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
	  select KOM
      do new_rec
        replace SIFRA_K with m_SIFRA,ime_K with m_PR,mesto_k with m_PR_MES, ugo with w_ugo, pov with w_pov, tr with w_tr, jmbg with w_jmbg, pdd with w_pdv, kat with w_kat

		commit
	  do fill_komint with m_pr
   else
      tek = indx
      do edit_kom
   endif
endif
return

procedure new_komx
parameters xx
clear screen
@ 00, 00 say center( "Izmena podataka o proizvodjacima" )
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
select KOMX
go xrec[ xx ]
         m_PR = ime_k
		m_PR_MES=mesto_k
	 w_ugo=ugo
	 w_pov=pov
	 w_tr=tr
	 w_jmbg=jmbg
	 w_pdv=pdd
	 w_kat=kat
  @  6, 20  say "Sifra       :" + m_sifra
  @  8, 20  say "Prezime i ime    :" get m_PR picture '@!'
  @  10, 20  say "JMBG             :" get w_jmbg  
  @  12, 20  say "Poreska izjava   :" get m_PR_MES picture '@!'
  @  14, 20  say "Ugovor           :" get w_ugo 
  @  16, 20  say "Povrsina parcele :" get w_pov picture '@E 999,999.99'
  @  18, 20  say "Tekuci racun     :" get w_tr 
  @  20, 20  say "PDV              :" get w_pdv
  @  20, 40  say "Kategorija       :" get w_kat
  read
if lastkey()=27
return
endif
save screen to ekran1
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
if ok = 'D'
select KOM
   do new_rec
        replace SIFRA_K with m_SIFRA,ime_K with m_PR,mesto_k with m_PR_MES, ugo with w_ugo, pov with w_pov, tr with w_tr, jmbg with w_jmbg, pdd with w_pdv, kat with w_kat
   endif
    do fill_komint with m_PR
return


procedure e_kom_old
clear screen
setcolor(DEF_GREEN)
MAX=1000
declare kart [ 100 ]
declare rec_no[ 100 ]
declare komint [ MAX ]
declare rec[ MAX ]
last_sif=0
*set color to i
@ 00, 00 say center( "Unos i ispravka proizvodjaca")
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
*@ 2, 25 say 'Mesto:'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_no,kom_name
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'TMPK5', .T. )
set index to tmp5, tmpKS5
file1='tmpk5'
ind2='tmp5'
ind1='tmpKS5'
zap
else
  clos all
  RETURN   
endif

do u_mesta
    restore screen from screen1
	 m_PR = space( 60 )
	 m_PR_MES = space( 20 )
zad = 1
tek = 1
do fill_komint with otk_sifra
do while .T.
  restore screen from screen1
  tek = achoice(3,15,19,65,komint,.T.,'',tek,tek-1)
  do case
     case tek = zad
          do new_kom
     case tek = 0
          close all
          clear screen
   setcolor(DEFAULT)
          return
     otherwise       
          do edit_kom
  endcase
enddo
close all
clear screen
return

procedure fill_komint_old
select KOM
go top
zad = 1
select &file1
zap
set index to &ind1, &ind2
reindex
//zap
append from kom for substr(sifra_k,1,3)=otk_sifra
set order to 2
go top
do while !eof()
   komint [ zad ] = ime_k+' '+mesto_k
    rec [ zad ] = recno()
   zad = zad + 1
   skip
enddo

komint [ zad ] = '*** Unos ****'
set order to 1

		return

procedure xfill_komint_old
parameters desc  
new_dt_call = pcount() != 0
select KOM
go top
zad = 1
*seek desc
*if found()
*do while ime_k=desc .and. !eof()
do while !eof()
	if substr(sifra_k,1,3)!=otk_sifra
	skip
	loop
	endif
*//   komint [ zad ] = ime_k+' '+mesto_k+' '+sifra_k
  komint [ zad ] = ime_k+'  '+sifra_k
   rec [ zad ] = recno()
   if new_dt_call 
   if ime_k = m_PR
         tek = zad
   endif
   endif
   zad = zad + 1
   skip
enddo
*   endif

komint [ zad ] = '*** Unos podataka ****'
for i = zad + 1 to MAX
    komint [ i ] = ''
next
return


procedure new_kom_old
zad_sif=val(otk_sifra)
z_sif=0
clear screen
@ 00, 00 say center( "Unos podataka o proizvodjacima")
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
save screen to ekran
select &file1
   go bottom
z_sif=val(sifra_k)
		 if empty(z_sif)
		 z_sif=zad_sif*1000
         m_SIFRA=ltrim(str(z_sif+1))
		 else
         m_SIFRA=ltrim(str(z_sif+1))
		 endif
	 m_PR = space( 60 )
	 m_PR_MES = space( 20 )
	 w_ugo=space(20)
	 w_pov=0
	 w_tr=space(30)
	 w_jmbg=space(13)
	 w_pdv='D'
	 w_kat=' '
  @  6, 12  say "Sifra       :" + m_sifra
  @  8, 12  say "Prezime i ime    :" get m_PR picture '@!'
  @  10, 12  say "JMBG             :" get w_jmbg  
  @  12, 12  say "Poreska izjava   :" get m_PR_MES picture '@!'
  @  14, 12  say "Ugovor           :" get w_ugo 
  @  16, 12  say "Povrsina parcele :" get w_pov picture '@E 999,999.99'
  @  18, 12  say "Tekuci racun     :" get w_tr 
  @  20, 12  say "PDV              :" get w_pdv
  @  20, 40  say "Kategorija       :" get w_kat

  read
   indx= ASCAN(komint, m_PR)
   if indx != 0   && find !!!!
   ? chr(7)
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'Komintent sa istim imenom postoji ! ESC-> Izlaz' )
inkey(0)
endif
if lastkey()=27
return
endif
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
if ok = 'D' .and. !empty( m_PR )
   if zad >= MAX
      ?? chr(7)
      @ 22, 0 say centermsg( 'Maximum ' + str( MAX-1,3,0) + ' proizvodjaca dozvoljeno!' )
      @ 23, 0 say centermsg( 'Pritisnite bilo koju tipku za nastavak' )
      inkey(0)
      return
   endif
   indx= ASCAN(komint, m_PR)

   if indx = 0   && no match
      @ 22, 0 say centermsg( 'Dodavanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
	  select KOM
      do new_rec
        replace SIFRA_K with m_SIFRA,ime_K with m_PR,mesto_k with m_PR_MES, ugo with w_ugo, pov with w_pov, tr with w_tr, jmbg with w_jmbg, pdd with w_pdv, kat with w_kat

		commit
	  do fill_komint with m_pr
   else
      tek = indx
      do edit_kom
   endif
endif
return


procedure edit_kom
clear screen
*set color to i
@ 00, 00 say center( "Izmena podataka o proizvodjacima" )
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
select &file1
go rec[ tek ]
         m_PR = ime_k
        tmp_doc = m_PR
		m_PR_MES=mesto_k
	 w_ugo=ugo
	 w_pov=pov
	 w_tr=tr
	 w_jmbg=jmbg
	 w_pdv=pdd
	 w_kat=kat
	 w_priz=priz
  @  6, 20  say "Sifra       :" + sifra_k
  @  8, 20  say "Prezime i ime    :" get m_PR picture '@!'
  @  10, 20  say "JMBG             :" get w_jmbg  
  @  12, 20  say "Poreska izjava   :" get m_PR_MES picture '@!'
  @  14, 20  say "Ugovor           :" get w_ugo 
  @  14, 50  say "Priznanica       :" get w_priz
  @  16, 20  say "Povrsina parcele :" get w_pov picture '@E 999,999.99'
  @  18, 20  say "Tekuci racun     :" get w_tr 
  @  20, 20  say "PDV              :" get w_pdv
  @  20, 50  say "Kategorija       :" get w_kat
  read
if lastkey()=27
return
endif
save screen to ekran1
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
*if ok = 'N'
*  do ispr_doc
*endif
if ok = 'D'
select KOM
seek &file1->sifra_k
if found()
   do req_rec_lock	
        replace ime_K with m_PR,mesto_k with m_PR_MES, ugo with w_ugo, pov with w_pov, tr with w_tr, jmbg with w_jmbg, pdd with w_pdv, kat with w_kat
   endif
      do fill_komint with m_PR
   if tmp_doc !=ime_k
      do fill_komint with m_PR
   else
      komint [ tek ] = ime_k
   endif
else
//   @ 22, 0 say centermsg( 'Da li ste sigurni da zelite' )
//   @ 23, 0 say centermsg( 'da obrisete gornje podatke? (D/N)' )
//   sure = 'N'
//   @ 23, 65 get sure picture '!'
//     read
//   if sure = 'D'
//      @ 22, 0 say centermsg( 'Brisanje u toku,' )
//      @ 23, 0 say centermsg( 'momenat...' )
//      delete
//      do fill_komint
//   endif
endif
return

procedure u_mesta
select MESTA
do fill_kart
current=1
*  restore screen from screen1
  current = achoice(3,30,19,50,kart,.T.,'',current,current-1)
  do case
     case current != 0 &&last
	 go rec_no[current]
	 otk_sifra=sifra_m
     case current = 0
          return
  endcase
return

procedure fill_kart
parameters desc  
new_dt_call = pcount() != 0
select mesta
go top
last = 1
do while !eof()
   kart [ last ] = naziv_m
   rec_no [ last ] = recno()
   if new_dt_call 
   if naziv_m = m_PR
         current = last
   endif
   endif
   last = last + 1
   skip
enddo

for i = last + 1 to 100
    kart [ i ] = ''
next
return

procedure zaduz
clear screen
public zbx
public naziv
@ 00, 00 say center( "Unos zaduzenja robom")
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'ROBA', .F. )
   set index to r_name,r_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'ZADUZ', .F. )
   set index to zad_doc,zad_sd,zad_rd,zad_ds,zad_xx,zad_ddc
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'TMPK4', .T. )
FILE1='TMPK4'
set index to tmp4
ind1='tmp4'
zap
else
  clos all
  RETURN   
endif

select 6
if net_use( "CHANGES", .F. )
   set index to ch_dokum, ch_sd, ch_ds, ch_dob
else
   close all
   return
endif

select 7
if NET_USE ( 'COMPANY', .F. )
else
  clos all
  RETURN   
endif

MAX=1000
declare roba [ MAX ]
declare roba_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]

ox = 1

current = 1
do while .T.
*do r_mes with ox
*******
*parameters pcx
	 zbx='   '
last=100
select MESTA
*do fill_rms with pcx
do fill_rms with ox
*tekuci=pcx
tekuci=ox
do red_screen with "Unos zaduzenja robom"
  //restore screen from screen1
  tekuci = achoice(3,30,19,50,kart,.T.,'',tekuci,tekuci-1)
  do case
     case tekuci != 0 
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
     ox=tekuci
	 naziv=naziv_m
     case tekuci = last
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
     ox=tekuci
	 case tekuci = 0
	 clos all
	 return
  endcase
******
zad = 1
tek = 1
//do rfill_kom with otk_sifra
do fill_komm with otk_sifra

do while .T.
//  restore screen from screen1
do red_screen with "Unos zaduzenja robom"
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
if lastkey()=27
return
endif
	 komintent=otk_sifra+'000'
	 case tek = 0
          close all
          clear screen
          return
	 exit
	 otherwise
//select KOM
select &file1
	 go rec[tek]
	 komintent=sifra_k
	 zbx=ugo
  endcase
la = 1
curr = 1
do rfill_roba with la
do red_screen with "Unos zaduzenja robom"
  //restore screen from screen1
  curr = achoice(3,20,19,60,roba,.T.,'',curr,curr-1)
  do case
     case curr !=0
	 go roba_no[curr]
	 roba_o=sifra_r
	 do zad_r with komintent,roba_o
	 loop
     case curr = 0
          close all
          clear screen
          return
  endcase
enddo
enddo
close all
ox = 1
clear screen
return

procedure rfill_roba
parameters desc  
select ROBA
go top
la = 1
do while !eof()
   roba [ la ] = naziv_r
    roba_no [ la ] = recno()
   la = la + 1
   skip
enddo

roba [ la ] = '*** Kraj podataka ****'
for i = la + 1 to MAX
    roba [ i ] = ''
next
return



procedure zad_r
parameters kom,voc
clear screen
do red_screen with "Unos zaduzenja robom"
  //restore screen from screen1
dat=date()
kolc=0.00
wcena=ROBA->cena_r
dok=space(10)
select ZADUZ
//@ 4,25 say substr(komintent,2,5)+' '+rtrim(komm[tek])
@ 4,25 say zbx+' '+rtrim(komm[tek])
@ 6,25 say roba[curr]
@ 8,25 say 'Dokument : ' get dok
@ 10,25 say 'Za datum : ' get dat
read
   m_dokum = 'NI' + dok+voc
seek kom+voc+dok
if found()
kolc=kol_zad
dok=doc_zad
wcena=cena
? CHR(7)
tone(300,10)
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "PO OVOM DOKUMENTU JE VEC UNETO ZADUZENJE !" )
inkey(0)
if lastkey()=27
return
endif
ENDIF
@ 12,25 say 'Kolicina : ' get kolc picture '999999999.99'
@ 14,25 say 'Cena     : ' get wcena picture '999999999.99'
read
correct='D'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "Korektni podaci (D/N) ?" )
@ 22, 55 get correct picture '!'
read
	if correct='D'
seek kom+voc+dok
if found()
    do req_rec_lock
	else
	do new_rec
endif
replace sifra_zad with kom, datum_zad with dat, kol_zad with kolc, sifra_zar with voc, doc_zad with dok, cena with wcena
else
seek kom+voc+dok
if found()
    do req_rec_lock
	delete
	endif
     endif
///OVDE CHANGES


     okx = 'D'
     @ 23, 0 say centermsg( ' Stampa otpremnice (D/N)' )
     @ 23, 65 get okx picture '!'
     read
     if okx='D'
	 ukupno=0
	 select ROBA
	 set order to 2
	 n=1
	 set device to print
	 for z=1 to 2
	 ukupno=0
     @ prow() +1,0 say chr(27) + chr(67)+chr(0)+chr(6)
     @ prow() ,0 say chr(27) + chr(71)
     @ prow() ,0 say chr(27) + chr(119)+'1'
	 @ prow()+6,35 say 'OTPREMNICA BROJ: '+dok
     @ prow() +1,0 say chr(27) + chr(119)+'0'
     @ prow() +1,0 say chr(27) + chr(72)
	 @ prow(),10 say 'Otkupno mesto: '+naziv
	 @ prow()+1,10 say 'KUPAC: '+rtrim(komm[tek])+' Veza ugovor br. '+zbx 
//	 @ prow()+1,10 say 'KUPAC: '+zbx+' '+rtrim(komm[tek])
	 @ prow()+1,10 say 'JMBG: '+&file1->jmbg

	 @ prow()+2,10 say 'Datum: '+dtoc(dat)
	 @ prow()+1,0 say replicate('-',80)
	 @ prow()+1,0 say 'RB    Naziv                 JM       Kolicina           Cena             Iznos'
	 @ prow()+1,0 say replicate('-',80)
	select ZADUZ
	 set order to 6
seek dok
	if found()
	do while rtrim(doc_zad)=rtrim(dok) .and. !eof()
	select ROBA
	seek ZADUZ->sifra_zar
	 @ prow()+1,0 say n picture '99'
	 @ prow(),5 say rtrim(ROBA->naziv_r)
	 @ prow(),30 say rtrim(ROBA->jm)
	 @ prow(),35 say ZADUZ->kol_zad  picture '@E 999,999.99'
//	 @ prow(),50 say round(ROBA->cena_r*(ROBA->pdv+100)*.01,3) picture '@E 99,999.999'
	 @ prow(),50 say round(ZAduz->cena*(ROBA->pdv+100)*.01,3) picture '@E 99,999.999'
	 @ prow(),68 say ZADUZ->kol_zad*round(zaduz->cena*(ROBA->pdv+100)*.01,3) picture '@E 9,999,999.99'
	 ukupno=ukupno+ZADUZ->kol_zad*round(zaduz->cena*(ROBA->pdv+100)*.01,3)
	 n=n+1
	select ZADUZ
	 skip
	 enddo
	 endif
	 @ prow()+1,0 say replicate('-',80)
	 @ prow()+1,60 say 'SVEGA:'
	 @ prow(),68 say ukupno picture '@E 9,999,999.99'

	 @ prow()+2,1 say 'U cenu uracunat PDV. '  && po stopi od '+str(ROBA->pdv,2)+'%'
	 @ prow()+1,1 say 'Placanje: kompenzacija za malinu I klase roda 2015. predate najblizem otkupnom '
	 @ prow()+1,1 say 'mestu, najkasnije do 15.07.2015. godine.'
	 @ prow()+1,1 say 'Ukupno zaduzenje u EUR __________________'
	 @ prow()+4,0 say '  '
	 eject
	 n=1
	 next
     @ prow() +1,0 say chr(27) + chr(67)+chr(0)+chr(12)

//@ prow() +1,0 say chr(27) + chr(87) + chr(48)
	 endif
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
	 set device to screen



return
							  





procedure r_mes
parameters pcx
last=100
select MESTA
do fill_rms with pcx
tekuci=pcx
do red_screen with "Unos zaduzenja ambalazom"
  //restore screen from screen1
  tekuci = achoice(3,30,19,50,kart,.T.,'',tekuci,tekuci-1)
  do case
     case tekuci != 0 
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
     ox=tekuci
     case tekuci = last
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
     ox=tekuci
	 case tekuci = 0
	 return
  endcase
return

procedure fill_rms
parameters desc  
select mesta
go top
last = 1
do while !eof()
   kart [ last ] = naziv_m
   rec_no [ last ] = recno()
   if last=desc
         tekuci = last
   endif
   last = last + 1
   skip
enddo

for i = last + 1 to 100
    kart [ i ] = ''
next
return

procedure rfill_kom
parameters desc  
select KOM
go top
zad = 1
do while !eof()
	if substr(sifra_k,1,3)!=otk_sifra
	skip
	loop
	endif
   komm [ zad ] = rtrim(ime_k)+' '+rtrim(mesto_k)
   rec [ zad ] = recno()
   zad = zad + 1
   skip
enddo

komm [ zad ] = '*** Zaduzenje otkupnog mesta ****'
for i = zad + 1 to MAX
    komm [ i ] = ''
next
return


////Stara otpremnica

	 /*
//     &&&&ODAVDE
	if correct='D'

        select CHANGES
	seek m_dokum
     if found()
	 do req_rec_lock
        replace CH_DATUM with dat, CH_SIFRA with voc, CH_KOL with -kolc, CH_STATUS with 'I',;  
                CH_CENA with ROBA->cena_r, CH_DOKUM with 'NI'+dok , CH_DOB with substr(kom,1,3)
				else 
				do new_rec
        replace CH_DATUM with dat, CH_SIFRA with voc, CH_KOL with -kolc, CH_STATUS with 'I',;  
                CH_CENA with ROBA->cena_r, CH_DOKUM with 'NI'+dok , CH_DOB with substr(kom,1,3)
      endif
	  else
        select CHANGES
	seek 'NI'+dok
     if found()
	do while ch_dokum= 'NI'+dok
	if ch_sifra=voc
	 do req_rec_lock
	 delete
      endif
	  skip 
	  enddo

      endif
      endif

     &&&&DOVDE
	   */



     okx = 'D'
     @ 23, 0 say centermsg( ' Stampa otpremnice (D/N)' )
     @ 23, 65 get okx picture '!'
     read
     if okx='D'
	 ukupno=0
	 select ROBA
	 set order to 2
	 n=1
	 set device to print
	 for z=1 to 2
	 ukupno=0
     @ prow() +1,0 say chr(27) + chr(67)+chr(0)+chr(6)
     @ prow() ,0 say chr(27) + chr(71)
     @ prow() ,0 say chr(27) + chr(119)+'1'
//	 @ prow()+1,1 say rtrim(COMPANY->co_line1)
	 @ prow()+6,35 say 'OTPREMNICA BROJ: '+dok
     @ prow() +1,0 say chr(27) + chr(119)+'0'
     @ prow() +1,0 say chr(27) + chr(72)
//     @ prow()+1, 1 say chr(27) + chr(15)
//	 @ prow()+1,1 say rtrim(COMPANY->co_line3)
//     @ prow() ,0 say chr(27) + chr(119)+'1'
	 @ prow(),10 say 'Otkupno mesto: '+naziv
//     @ prow() ,0 say chr(27) + chr(119)+'0'
	 @ prow()+1,10 say 'KUPAC: '+zbx+' '+rtrim(komm[tek])
//	 @ prow()+1,1 say 'Telefoni: 816-530, 811-617'
	 @ prow()+1,10 say 'JMBG: '+&file1->jmbg
//	 @ prow()+1,1 say 'PIB 100859717'

//	 @ prow()+1,50 say rtrim(COMPANY->co_line3)+' '+ dtoc(dat)
	 @ prow()+2,10 say 'Datum: '+dtoc(dat)
	 @ prow()+1,0 say replicate('-',80)
	 @ prow()+1,0 say 'RB    Naziv                 JM       Kolicina           Cena             Iznos'
	 @ prow()+1,0 say replicate('-',80)
	select CHANGES
	seek 'NI'+dok
//   do while CH_DOKUM = rtrim(m_dokum)
	do while ch_dokum= 'NI'+dok .and. !eof()
	select ROBA
	seek CHANGES->ch_sifra
	 @ prow()+1,0 say n picture '99'
	 @ prow(),5 say rtrim(ROBA->naziv_r)
	 @ prow(),30 say rtrim(ROBA->jm)
	 @ prow(),35 say CHANGES->ch_kol  picture '@E 999,999.99'
	 @ prow(),50 say round(ROBA->cena_r*(ROBA->pdv+100)*.01,3) picture '@E 99,999.999'
	 @ prow(),68 say CHANGES->ch_kol*round(ROBA->cena_r*(ROBA->pdv+100)*.01,3) picture '@E 9,999,999.99'
	 ukupno=ukupno+CHANGES->ch_kol*round(ROBA->cena_r*(ROBA->pdv+100)*.01,3)
	 n=n+1
	select CHANGES
	 skip
	 enddo
	 @ prow()+1,0 say replicate('-',80)
	 @ prow()+1,60 say 'SVEGA:'
	 @ prow(),68 say ukupno picture '@E 9,999,999.99'

//  @ prow()+1, 1 say chr(27) + chr(83)+'1'
	 @ prow()+2,1 say 'U cenu uracunat PDV. '  && po stopi od '+str(ROBA->pdv,2)+'%'
	 @ prow()+1,1 say 'Placanje: kompenzacija za malinu I klase roda 2010. predate najblizem otkupnom mestu,'
	 @ prow()+1,1 say 'najkasnije do 15.07.2010. godine.'
	 @ prow()+1,1 say 'Ukupno zaduzenje u EUR __________________'
//  @ prow()+1, 1 say chr(27) + chr(84)
//	 @ prow()+2,2 say 'Prevoznik:'
//	 @ prow()+3,10 say 'Robu izdao:'
//	 @ prow() ,65 say 'Robu primio:'
//	 @ prow()+2,2 say '___________'
//	 @ prow()+2,10 say '___________'
//	 @ prow() ,65 say '___________'
//	 @ prow()+1,60 say 'L.k.br.___________'
//	 @ prow()+1,60 say 'Telefon___________'
	 @ prow()+4,0 say '  '
	 eject
	 next
     @ prow() +1,0 say chr(27) + chr(67)+chr(0)+chr(12)

//@ prow() +1,0 say chr(27) + chr(87) + chr(48)
	 endif
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
	 set device to screen

procedure e_mesta
setcolor(DEF_MAGENTA)
MAX_DOCUMENTS=1000
declare kartents [ MAX_DOCUMENTS ]
declare rec_no[ MAX_DOCUMENTS ]
last_sif=0
*set color to i
@ 00, 00 say center( "Unos otkupnih mesta")
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 8 clear to 20, 72
@ 2, 8 to 20, 72 double
*@ 2, 25 say 'Mesto:'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif
do red_screen with "Unos otkupnih mesta"
  restore screen from screen1
	 m_PR_IME = space( 20 )
	 m_PR_OTK = space( 30 )
	 m_PR_TEL = space( 15 )
last = 1
current = 1
do fill_kartents
do while .T.
do red_screen with "Unos otkupnih mesta"
@ 2, 8 clear to 20, 72
@ 2, 8 to 20, 72 double
  //restore screen from screen1
  current = achoice(3,10,19,70,kartents,.T.,'',current,current-1)
  do case
     case current = last
	  do new_kart
     case current = 0
	  close all
	  clear screen
   setcolor(DEFAULT)
	  return
     otherwise       
	  do edit_kart
  endcase
enddo
//close all
clear screen
return


procedure fill_kartents
parameters desc  
new_dt_call = pcount() != 0
select mesta
go top
last = 1
do while !eof()
   kartents [ last ] = naziv_m+' '+otk_m+'  '+otk_tel
*   kartents1 [ last ] = otk_m
   rec_no [ last ] = recno()
   if new_dt_call 
   if naziv_m = m_PR_IME
	 current = last
   endif
   endif
   last = last + 1
   skip
enddo

kartents [ last ] = '*** Unos podataka ****'
for i = last + 1 to MAX_DOCUMENTS
    kartents [ i ] = ''
next
return


procedure new_kart
clear screen
*set color to i
@ 00, 00 say center( "Unos otkupnih mesta")
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
save screen to ekran
	 m_PR_IME = space( 20 )
	 m_PR_OTK = space( 30 )
	 m_PR_TEL = space( 15 )
select mesta
   set index to m_no,m_name
do while  !eof()
last_sif=val(sifra_m)
skip
enddo

set index to m_name,m_no
		 if empty(last_sif)
		 last_sif=100
		 endif
	 m_SIFRA=ltrim(str(last_sif+1))
		 m_PR_IME = space( 20 )
  @  10, 12  say "Sifra       :" + m_sifra
  @  12, 12  say "Mesto       :" get m_PR_IME picture '@!'
  @  14, 12  say "Otkupljivac :" get m_PR_OTK picture '@!'
  @  16, 12  say "Telefon :" get m_PR_TEL picture '@!'
  read
   indx= ASCAN(kartents, m_PR_IME)
   if indx != 0   && find !!!!
   ? chr(7)
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'Mesto sa istim imenom postoji ! ESC-> Izlaz' )
inkey(0)
endif
if lastkey()=27
return
endif
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
if ok = 'D' .and. !empty( m_PR_IME )
   if last >= MAX_DOCUMENTS
      ?? chr(7)
      @ 22, 0 say centermsg( 'Maximum ' + str( MAX_DOCUMENTS-1,3,0) + ' pacijenata dozvoljeno!' )
      @ 23, 0 say centermsg( 'Pritisnite bilo koju tipku za nastavak' )
      inkey(0)
      return
   endif
   indx= ASCAN(kartents, m_PR_IME)

   if indx = 0   && no match
      @ 22, 0 say centermsg( 'Dodavanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
      do new_rec
	replace SIFRA_m with m_SIFRA,naziv_m with m_PR_IME,otk_m with m_PR_OTK,otk_tel with m_PR_TEL
	  do fill_kartents with m_pr_ime        
   else
      current = indx
      do edit_kart
   endif
endif
return


procedure edit_kart
clear screen
*set color to i
@ 00, 00 say center( "Izmena podataka o mestima" )
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
go rec_no[ current ]
	 m_PR_IME = naziv_m
	 m_PR_OTK = otk_m
	 m_PR_TEL = otk_tel
	tmp_doc = m_PR_IME
  @  10, 12  say "Sifra       :" + sifra_m
  @  12, 12  say "Mesto :" get m_PR_IME picture '@!'
  @  14, 12  say "Otkupljivac :" get m_PR_OTK picture '@!'
  @  16, 12  say "Telefon :" get m_PR_TEL picture '@!'
  read
if lastkey()=27
return
endif
save screen to ekran1
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
*if ok = 'N'
*  do ispr_doc
*endif
if ok = 'D'
   do req_rec_lock      
	replace naziv_m with m_PR_IME 
	replace otk_m with m_PR_OTK
	replace otk_tel with m_PR_TEL
      do fill_kartents with m_PR_IME
   if tmp_doc !=naziv_m
      do fill_kartents with m_PR_IME
   else
      kartents [ current ] = naziv_m
   endif
else
   @ 22, 0 say centermsg( 'Da li ste sigurni da zelite' )
   @ 23, 0 say centermsg( 'da obrisete gornje podatke? (D/N)' )
   sure = 'N'
   @ 23, 65 get sure picture '!'
     read
   if sure = 'D'
      @ 22, 0 say centermsg( 'Brisanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
      delete
      do fill_kartents
   endif
endif
return
**********************************************************
procedure preg_otk
clear screen
*set color to i
@ 00, 00 say center( "Pregled otkupa voca")  
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'VOCE', .F. )
   set index to v_name,v_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'OTKUP', .F. )
   set index to otk_sd,otk_vd, otk_ss
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'AMB', .F. )
   set index to amb_dat
else
  clos all
  RETURN   
endif

select 9
if NET_USE ( 'TMPK1', .T. )
file1='tmpK1'
ind1='tmp1'
set index to tmp1
zap
else
  clos all
  RETURN   
endif

select 7
if NET_USE ( 'COMPANY', .F. )
else
  clos all
  RETURN   
endif
/*
////OVO
select 6
if xNET_USE ( 'TMPK1', .T. )
file1='tmpK1'
ind1='tmp1'
set index to tmp1
zap
//wait 'tmpk1'
else
select 6
if xNET_USE ( 'TMPK2', .T. )
file1='tmpK2'
ind1='tmp2'
set index to tmp2
zap
//wait 'tmpk2'
else
select 6
if xNET_USE ( 'TMPK3', .T. )
file1='tmpK3'
ind1='tmp3'
set index to tmp3
zap
//wait 'tmpk3'
else
select 6
if xNET_USE ( 'TMPK4', .T. )
file1='tmpK4'
ind1='tmp4'
set index to tmp4
zap
//wait 'tmpk4'
else
select 6
if xNET_USE ( 'TMPK5', .T. )
file1='tmpK5'
ind1='tmp5'
set index to tmp5
zap
//wait 'tmpk5'
else
clos all
return
endif

endif

endif

endif

endif

/////DOVDE
*/


MAX=1000
declare voce [ MAX ]
declare voce_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]
zad = 1
tek = 1
ox = 1
//do while .T.
do red_screen with "Pregled otkupa voca"
//  restore screen from screen1
current = 1
do izb_mes with ox
if ox<100
zad = 1
tek = 1
  endif
//do izb_kom with otk_sifra
do fill_komm with otk_sifra
do while .T.
do red_screen with "Pregled otkupa voca"
  //restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'000'
	 case tek = 0
	 clos all
	 return
//	 exit
	 otherwise
//	 select KOM
	 select &file1
	 go rec[tek]
	 komintent=sifra_k
  endcase
//  endif
la = 1
curr = 1
do izb_v with la
do red_screen with "Pregled otkupa voca"
  //restore screen from screen1
  curr = achoice(3,20,19,60,voce,.T.,'',curr,curr-1)
  do case
     case curr =la
	 voce_o='xxx'
	 do pregled_o with komintent,voce_o
	 loop
     case curr !=0       
	 go voce_no[curr]
	 voce_o=sifra_v
	 do pregled_o with komintent,voce_o
*        loop
//     exit
     case curr = 0
	  close all
	  clear screen
	  exit
		  return
  endcase
enddo
//close all
ox = 1
clear screen
return

procedure izb_v
parameters desc  
select VOCE
go top
la = 1
do while !eof()
   voce [ la ] = naziv_v
    voce_no [ la ] = recno()
   la = la + 1
   skip
enddo

voce [ la ] = '*** Za svo voce ****'
for i = la + 1 to MAX
    voce [ i ] = ''
next
return


procedure izb_mes
parameters pcx
last=100
select MESTA
do izb_mss with pcx
tekuci=pcx
*  restore screen from screen1
  tekuci = achoice(3,30,19,50,kart,.T.,'',tekuci,tekuci-1)
  do case
     case tekuci = last
*        go rec_no[tekuci]
	 otk_sifra='999999'
	 komintent=otk_sifra
     ox=101
     case tekuci != 0 
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
     ox=tekuci
	 case tekuci = 0
	 otk_sifra='xxx'
//	 clos all
	 return
  endcase
return

procedure izb_mss
parameters desc  
select mesta
go top
last = 1
do while !eof()
   kart [ last ] = naziv_m
   rec_no [ last ] = recno()
   if last=desc
	 tekuci = last
   endif
   last = last + 1
   skip
 enddo

kart [ last ] = '*** Za sva mesta ****'
for i = last + 1 to 100
    kart [ i ] = ''
next
return

procedure izb_kom
parameters desc  
select KOM
go top
zad = 1
do while !eof()
	if substr(sifra_k,1,3)!=otk_sifra
	skip
	loop
	endif
   komm [ zad ] = ime_k+' '+mesto_k
   rec [ zad ] = recno()
   zad = zad + 1
   skip
enddo

komm [ zad ] = '*** Za otkupno mesto ****'
for i = zad + 1 to MAX
    komm [ i ] = ''
next
return

procedure pregled_o
parameters k_par,v_par
 if subst(k_par,4,6)='000' .and. v_par='xxx' && jedno mesto svo voce
 do jed_m_svo_v
	return
 endif
 if subst(k_par,4,6)='999' .and. v_par!='xxx' && sva mesta jedno voce
 do sva_m_jed_v
	return
 endif
 if subst(k_par,4,6)='999' .and. v_par='xxx' && sva mesta svo voce
 do sva_m_svo_v
 return
 endif
 if subst(k_par,4,6)!='000' .and. v_par!='xxx' && jedan kom jedno voce
do jed_kom_jed_v
	return
 endif
 if subst(k_par,4,6)!='000' .and. v_par='xxx' && jedan kom svo voce
do jed_kom_svo_v
	return
 endif

 if subst(k_par,4,6)='000' .and. v_par!='xxx' && jedno mesto jedno voce
do jednom_jedno_voce
	return
 endif
  return

//// 'jedan kom svo voce'

procedure jed_kom_svo_v
select OTKUP
   set index to otk_vd,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
amb_z=0.00
amb_r=0.00
raz=0.00
drg=0 
treca=0
g_kol=0
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/PoDokumentu (E/P/D)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do pr_kom_allvoce
//clos all
return
endif
if stampa='D'
do print_allvoce
//clos all
return
endif
save screen to scr
select KOM
   set index to kom_no,kom_name
seek k_par
if found()
@ 2,0 say center(ime_k)
@ 3,0 to 3,79

@ 4,25 say 'Prepod. :'
@ 4,39 say 'I klasa:'
@ 4,52 say 'II klasa:'
@ 4,67 say 'III klasa:'
@ 5,0 to 5,79

select VOCE
   set index to v_no,v_name
//seek v_par
go top
do while !eof()

@ row()+1,0 say naziv_v
select OTKUP
go top
set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
*********************************
*********************************
select OTKUP
//@ row()+1,1 say datum_otk 
//@ row(),12 say doc_otk 
//@ row(),24 say kol_otk picture '@E 999,999.99'
//@ row(),37 say raz_otk picture '@E 999,999.99'
//@ row(),49 say kol_otkii picture '@E 999,999.99'
//@ row(),60 say kol4 picture '@E 999,999.99'
//@ row(),67 say (kol_otk*VOCE->cena_v+raz_otk*VOCE->druga+kol_otkii*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
//@ row(),70 say (kol_otk+raz_otk)/xamb picture '@E 999.999'
//@ row(),70 say amb_z-amb_r picture '@E 999,999'
g_kol=0
		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
		@ 2,1 clear to 19,79
		@ 1,1 to 1,79
		endif
skip
enddo
//@ row(),0 say 'SVEGA:'
@ row(),24 say ukupno picture '@E 999,999.99'
@ row(),37 say raz picture '@E 999,999.99'
@ row(),49 say drg picture '@E 999,999.99'
@ row(),60 say treca picture '@E 999,999.99'
@ row()+1,0 to row()+1,79
ukupno=0.00
svega=0.00
amb_z=0.00
amb_r=0.00
raz=0.00
drg=0 
treca=0
select voce
skip
enddo
//@ row(),67 say (ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
		@ 1,1 to 1,79
		@ 2,1 clear to 19,79
		endif

@ row()+1,0 to row()+1,79
//svega=svega+(ukupno+raz+drg+treca)*VOCE->cena_v*(1+VOCE->pdv/100)
endif
@ row(),0 say 'SALDO:'
@ row(),33 say ukupno+raz+drg+treca picture '@E 9,999,999.99'
//@ row(),52 say svega picture '@E 99,999,999.99'
*@ row(),70 say uk_amb picture '@E 999,999'
//@ row()+1,0 say 'PROSEK:'
//@ row(),65 say (ukupno+raz+drg+treca)/amb_r picture '@E 999.999'
select KOM
   set index to kom_name,kom_no
select VOCE
   set index to v_name,v_no
inkey(0)
return
//////////////////
procedure pr_kom_allvoce
set device to print
select OTKUP
   set index to otk_vd,otk_sd
ukupno=0.00
raz=0.00
drg=0 
treca=0
first=0
second=0
third=0
fourth=0

select KOM
   set index to kom_no,kom_name
seek k_par
if found()
@ prow()+1,0 say center('Saldo otkupa voca za period od '+dtoc(datum1)+'-'+dtoc(datum2))
@ prow()+2,0 say center(rtrim(MESTA->naziv_m)+'  '+ime_k)

@ prow()+2,25 say 'Prepod. :'
@ prow(),39 say 'I klasa:'
@ prow(),52 say 'II klasa:'
@ prow(),67 say 'III klasa:'
@ prow()+1,0 say replicate ('-',80)

select VOCE
   set index to v_no,v_name
//seek v_par
go top
do while !eof()

@ prow()+1,0 say naziv_v
select OTKUP
go top
set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
		if prow()>=65
		eject
		endif
skip
enddo
//@ row(),0 say 'SVEGA:'
@ prow(),24 say ukupno picture '@E 999,999.99'
@ prow(),37 say raz picture '@E 999,999.99'
@ prow(),49 say drg picture '@E 999,999.99'
@ prow(),60 say treca picture '@E 999,999.99'
@ prow()+1,0 say replicate ('-',80)
first=first+ukupno
second=second+raz
third=third+drg
fourth=fourth+treca

ukupno=0.00
raz=0.00
drg=0 
treca=0

select voce
skip
enddo

endif
@ prow()+1,0 say 'SALDO:'
@ prow(),24 say first picture '@E 999,999.99'
@ prow(),37 say second picture '@E 999,999.99'
@ prow(),49 say third picture '@E 999,999.99'
@ prow(),60 say fourth picture '@E 999,999.99'
@ prow()+1,0 say 'ZBIR:'
@ prow(),24 say first+second+third+fourth picture '@E 9,999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return


procedure print_allvoce
set device to print
select OTKUP
   set index to otk_vd,otk_sd
ukupno=0.00
raz=0.00
drg=0 
treca=0
first=0
second=0
third=0
fourth=0

select KOM
   set index to kom_no,kom_name
seek k_par
if found()
@ prow()+1,0 say center('Saldo otkupa voca za period od '+dtoc(datum1)+'-'+dtoc(datum2))
@ prow()+2,0 say center(rtrim(MESTA->naziv_m)+'  '+ime_k)

@ prow()+2,25 say 'Prepod. :'
@ prow(),39 say 'I klasa:'
@ prow(),52 say 'II klasa:'
@ prow(),67 say 'III klasa:'
@ prow()+1,0 say replicate ('-',80)

select VOCE
   set index to v_no,v_name
//seek v_par
go top
do while !eof()

@ prow()+1,0 say naziv_v
select OTKUP
go top
set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
@ prow()+1,1 say datum_otk 
@ prow(),12 say doc_otk 
@ prow(),24 say kol_otk picture '@E 999,999.99'
@ prow(),37 say raz_otk picture '@E 999,999.99'
@ prow(),49 say kol_otkii picture '@E 999,999.99'
@ prow(),60 say kol4 picture '@E 999,999.99'
//@ row(),67 say (kol_otk*VOCE->cena_v+raz_otk*VOCE->druga+kol_otkii*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
//@ row(),70 say (kol_otk+raz_otk)/xamb picture '@E 999.999'
//@ row(),70 say amb_z-amb_r picture '@E 999,999'
		if prow()>=65
		eject
		endif
skip
enddo
//@ row(),0 say 'SVEGA:'
@ prow(),24 say ukupno picture '@E 999,999.99'
@ prow(),37 say raz picture '@E 999,999.99'
@ prow(),49 say drg picture '@E 999,999.99'
@ prow(),60 say treca picture '@E 999,999.99'
@ prow()+1,0 say replicate ('-',80)
first=first+ukupno
second=second+raz
third=third+drg
fourth=fourth+treca

ukupno=0.00
raz=0.00
drg=0 
treca=0

select voce
skip
enddo

endif
@ prow()+1,0 say 'SALDO:'
@ prow(),24 say first picture '@E 999,999.99'
@ prow(),37 say second picture '@E 999,999.99'
@ prow(),49 say third picture '@E 999,999.99'
@ prow(),60 say fourth picture '@E 999,999.99'
@ prow()+1,0 say 'ZBIR:'
@ prow(),24 say first+second+third+fourth picture '@E 999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return


* jedan komintent - jedno voce
*********************************************
procedure jed_kom_jed_v
select OTKUP
   set index to otk_vd,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
amb_z=0.00
amb_r=0.00
raz=0.00
drg=0 
treca=0
g_kol=0
vr1=0
vr2=0
vr3=0
vr4=0

@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do pr_kom_voce
//clos all
return
endif
save screen to scr
select KOM
   set index to kom_no,kom_name
seek k_par
if found()
@ 2,0 say center(ime_k)
@ 3,0 to 3,79

select VOCE
   set index to v_no,v_name
seek v_par
*@ row()+1,0 say naziv_v
@ 4,1 say naziv_v
@ 4,25 say 'Prepod. :'
@ 4,39 say 'I klasa:'
@ 4,52 say 'II klasa:'
@ 4,67 say 'III klasa:'
@ 5,0 to 5,79

select OTKUP
go top
set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
vr1=vr1+kol_otk*cena1
vr2=vr2+raz_otk*cena2
vr3=vr3+kol_otkii*cena3
vr4=vr4+treca*cena4

*********************************
  select AMB
  xamb=0
seek DTOS(OTKUP->DATUM_OTK)
if found()
do while  amb_datum=OTKUP->datum_otk .and. !eof()
if  amb_sif!=KOM->sifra_k
skip 
loop
endif
g_kol=amb_kol
	amb_z=amb_z+amb_kol   &&+amb_raz
	amb_r=amb_r+amb_raz   &&amb_kol+amb_raz
	xamb=amb_raz
skip
enddo
endif
*********************************
select OTKUP
@ row()+1,1 say datum_otk 
@ row(),12 say doc_otk 
@ row(),24 say kol_otk picture '@E 999,999.99'
@ row(),37 say raz_otk picture '@E 999,999.99'
@ row(),49 say kol_otkii picture '@E 999,999.99'
@ row(),60 say kol4 picture '@E 999,999.99'
//@ row(),67 say (kol_otk*VOCE->cena_v+raz_otk*VOCE->druga+kol_otkii*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
//@ row(),70 say (kol_otk+raz_otk)/xamb picture '@E 999.999'
//@ row(),70 say amb_z-amb_r picture '@E 999,999'
g_kol=0
		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
		@ 2,1 clear to 19,79
		@ 1,1 to 1,79
		endif
skip
enddo
@ row()+1,0 to row()+1,79
@ row(),0 say 'SVEGA:'
@ row(),24 say ukupno picture '@E 999,999.99'
@ row(),37 say raz picture '@E 999,999.99'
@ row(),49 say drg picture '@E 999,999.99'
@ row(),60 say treca picture '@E 999,999.99'
//@ row(),67 say (ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
		@ 1,1 to 1,79
		@ 2,1 clear to 19,79
		endif

@ row()+1,0 to row()+1,79
//svega=svega+(ukupno+raz+drg+treca)*VOCE->cena_v*(1+VOCE->pdv/100)
endif
@ row(),0 say 'SALDO:'
@ row(),33 say ukupno+raz+drg+treca picture '@E 9,999,999.99'
//@ row(),52 say svega picture '@E 99,999,999.99'
*@ row(),70 say uk_amb picture '@E 999,999'
@ row()+1,0 say 'PROSEK:'
@ row(),65 say (ukupno+raz+drg+treca)/amb_r picture '@E 999.999'
if KOM->pdd='D'
@ row()+1,0 say 'VREDNOST:'
//@ row(),67 say (ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ row(),67 say (vr1+vr2+vr3+vr4)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
else
@ row(),67 say (vr1+vr2+vr3+vr4) picture '@E 99,999,999.99'
//@ row(),67 say (ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca) picture '@E 99,999,999.99'
endif


select KOM
   set index to kom_name,kom_no
select VOCE
   set index to v_name,v_no
inkey(0)
return


*************************************
***STAMPA KOMINTENT - VOCE
*************************************
procedure pr_kom_voce
select OTKUP
   set index to otk_vd,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa u toku..." )
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)

ukupno=0.00
svega=0.00
amb_z=0.00
amb_r=0.00
drg=0
raz=0.00
g_kol=0
treca=0
select KOM
   set index to kom_no,kom_name
seek k_par
if found()
w_c=sifra_k
@ prow()+1,5 say 'Izvestaj o otkupu od '+' '+dtoc(datum1)+' do '+dtoc(datum2)
@ prow()+1,0 say replicate ('-',79)
@ prow()+1,35 say rtrim(ime_k)+' '+mesto_k
@ prow()+1,0 say replicate ('-',79)

select VOCE
   set index to v_no,v_name
seek v_par
@ prow()+1,0 say naziv_v
@ prow(),10 say 'Kolicina:'
@ prow(),27 say 'Cena:'
//@ prow(),37 say 'I klasa:'
@ prow(),50 say 'Vrednost:'
//@ prow(),62 say 'II klasa:'
//@ prow(),75 say 'Cena II'
//@ prow(),84 say 'III klasa:'
//@ prow(),99 say 'Cena III'
@ prow(),70 say 'Prosek:'
@ prow()+1,0 say replicate ('-',79)

select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
*********************************
  select AMB
	xamb=0
seek DTOS(OTKUP->DATUM_OTK)
do while  amb_datum=OTKUP->datum_otk .and. !eof()
if  amb_sif!=KOM->sifra_k
skip 
loop
endif
g_kol=amb_kol

	amb_z=amb_z+amb_kol   &&+amb_raz
	amb_r=amb_r+amb_raz   &&amb_kol+amb_raz
	xamb=amb_raz


skip
enddo
*********************************
select OTKUP
@ prow()+1,1 say datum_otk
@ prow(),12 say doc_otk
@ prow()+1,1 say 'Prep.'
@ prow(),12 say kol_otk picture '@E 999,999.99'
@ prow(),27 say cena1 picture '@E 999.99'
@ prow(),47 say kol_otk*cena1 picture '@E 999,999.99'
@ prow()+1,1 say 'I klasa'
@ prow(),12 say raz_otk picture '@E 999,999.99'
@ prow(),27 say cena2 picture '@E 999.99'
@ prow(),47 say raz_otk*cena2 picture '@E 999,999.99'
@ prow()+1,1 say 'II klasa'
@ prow(),12 say kol_otkii picture '@E 999,999.99'
@ prow(),27 say cena3 picture '@E 999.99'
@ prow(),47 say kol_otkii*cena3 picture '@E 999,999.99'
//@ prow()+1,1 say 'III klasa'
//@ prow(),12 say kol4 picture '@E 999,999.99'
//@ prow(),27 say cena4 picture '@E 999.99'
//@ prow(),47 say kol4*cena4 picture '@E 999,999.99'
//@ prow(),70 say (kol_otk*VOCE->cena_v+raz_otk*VOCE->druga+kol_otkii*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ prow(),70 say (kol_otk+raz_otk+kol_otkii+kol4)/xamb picture '@E 999.999'
svega=svega+kol_otk*cena1+raz_otk*cena2+kol_otkii*cena3+kol4*cena4
g_kol=0
skip
enddo
@ prow()+1,0 say replicate ('-',79)

//svega=svega+(ukupno+raz)*VOCE->cena_v*(1+VOCE->pdv/100)
endif


   @ prow()+1,0 say 'SVEGA:'
   @ prow()+1,0 say 'Prep.:'
@ prow(),15 say ukupno picture '@E 9,999,999.99'
   @ prow()+1,0 say 'I klasa:'
@ prow(),15 say raz picture '@E 9,999,999.99'
   @ prow()+1,0 say 'II klasa:'
@ prow(),15 say drg picture '@E 9,999,999.99'
   @ prow()+1,0 say 'III klasa:'
@ prow(),15 say treca picture '@E 9,999,999.99'
//@ prow(),70 say (ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ prow()+1,0 say replicate ('-',79)
   @ prow()+1,0 say 'SALDO:'
@ prow(),15 say ukupno+raz+drg+treca picture '@E 9,999,999.99'
if KOM->pdd='D'
//@ row()+1,0 say 'VREDNOST:'
@ prow(),45 say svega picture '@E 99,999,999.99'
@ prow()+1,45 say svega*VOCE->pdv/100 picture '@E 99,999,999.99'
@ prow()+1,45 say svega*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
else
@ prow(),45 say svega picture '@E 99,999,999.99'
endif
//   @ prow()+1,0 say 'PROSEK:'
@ prow(),70 say (ukupno+raz+drg+treca)/amb_r picture '@E 999.999'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
select KOM
   set index to kom_name,kom_no
select VOCE
   set index to v_name,v_no
return

* jedno mesto - svo voce

procedure jed_m_svo_v
select OTKUP
   set index to otk_ss,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
drg=0
raz=0.00
xx1=0
xx2=0
xx3=0
xx4=0
treca=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
@ 1,1 to 1,79
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Stampa po datumu (E/P/D)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do pr_jm_jv
return
endif
if stampa='D'
do pr_jm_datum
return
endif

select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ 2,0 say center(naziv_m)
@ 4,25 say 'Prepod. :'
@ 4,39 say 'I klasa:'
@ 4,52 say 'II klasa:'
@ 4,67 say 'III klasa:'
@ 5,0 to 5,79
save screen to scr
select VOCE
go top
do while !eof()
//@ row()+1,0 say naziv_v
select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
 do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii	 
treca=treca+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
skip
enddo
@ row()+1,1 say Voce->naziv_v
@ row(),24 say ukupno picture '@E 999,999.99'
@ row(),37 say raz picture '@E 999,999.99'
@ row(),49 say drg picture '@E 999,999.99'
@ row(),67 say treca picture '@E 999,999.99'
//@ row(),67 say (ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ row()+1,0 to row()+1,79
//svega=svega+ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca*(1+VOCE->pdv/100)
xx1=xx1+ukupno
xx2=xx2+raz
xx3=xx3+drg
xx4=xx4+treca
ukupno=0.00
drg=0
raz=0.00
treca=0
if row()>=19
inkey(0)
restore screen from scr
@ 5,0 to 5,79
//@ 1,1 to 1,79
//@ 2,1 clear to 19,79
endif
select VOCE
skip
enddo
endif
select MESTA
   set index to m_name,m_no
@ row()+1,0 say 'SVEGA:'
@ row(),24 say xx1 picture '@E 999,999.99'
@ row(),37 say xx2 picture '@E 999,999.99'
@ row(),49 say xx3 picture '@E 999,999.99'
@ row(),67 say xx4 picture '@E 999,999.99'
inkey(0)
return

procedure pr_jm_jv
set device to print
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ prow()+1,1 say center('Otkupno mesto: '+naziv_m)
@ prow()+2,25 say 'Prepod. :'
@ prow(),39 say 'I klasa:'
@ prow(),52 say 'II klasa:'
@ prow(),67 say 'III klasa:'
@ prow()+1,0 say replicate ('-',80)
save screen to scr
select VOCE
go top
do while !eof()
//@ row()+1,0 say naziv_v
select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
skip
enddo
@ prow()+1,1 say Voce->naziv_v
@ prow(),24 say ukupno picture '@E 999,999.99'
@ prow(),37 say raz picture '@E 999,999.99'
@ prow(),49 say drg picture '@E 999,999.99'
@ prow(),67 say treca picture '@E 999,999.99'
//@ prow(),67 say (ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ prow()+1,0 to row()+1,79
//svega=svega+ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca*(1+VOCE->pdv/100)
xx1=xx1+ukupno
xx2=xx2+raz
xx3=xx3+drg
xx4=xx4+treca
ukupno=0.00
drg=0
raz=0.00
treca=0
if prow()>=65
eject
endif
select VOCE
skip
enddo
endif
select MESTA
   set index to m_name,m_no
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,0 say 'SVEGA:'
@ prow(),24 say xx1 picture '@E 999,999.99'
@ prow(),37 say xx2 picture '@E 999,999.99'
@ prow(),49 say xx3 picture '@E 999,999.99'
@ prow(),67 say xx4 picture '@E 999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

**************************************
*sva mesta svo voce
**********************************
procedure sva_m_svo_v
stampa='P'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Zbirno/Pojedinacno/Po datumu (Z/P/D)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do sva_mesta
return
endif
if stampa='D'
do all_mesta_datum
return
endif

select OTKUP
   set index to otk_ss,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
amb_r=0.00
drg=0
raz=0.00
treca=0
g_kol=0
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
@ 4,25 say 'Voce :'
//@ 4,39 say 'I klasa:'
//@ 4,52 say 'II klasa:'
@ 4,63 say 'Vrednost:'
@ 3,0 to 3,79
save screen to scr
select VOCE
   go top
do while !eof()
    @ row()+1,0 say naziv_v
select MESTA
	go top
do while !eof()
w_c=sifra_m
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
	
	skip
enddo
select MESTA
	skip
enddo
@ row(),20 say ukupno+raz+drg+treca picture '@E 99,999,999.99'
@ row(),60 say (ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca+treca*Voce->cetvrta)*(1+VOCE->pdv/100) picture '@E 999,999,999.99'
@ row()+1,0 to row()+1,79
svega=svega+(ukupno*VOCE->cena_v+raz*VOCE->druga+drg*VOCE->treca+treca*Voce->cetvrta)*(1+VOCE->pdv/100)
amb_r=amb_r+ukupno+raz+drg+treca
ukupno=0.00
drg=0
raz=0.00
if row()>=19
inkey(0)
@ 1,1 to 1,79
@ 2,1 clear to 19,79
endif
select VOCE
skip
enddo
@ row()+1,0 say 'SVEGA:'
@ row(),20 say amb_r picture '@E 99,999,999.99'
@ row(),60 say svega picture '@E 999,999,999.99'
inkey(0)
return
******************************************
*SVA MESTA  - JEDNO VOCE
******************************************

*sva mesta jedno voce
procedure sva_m_jed_v
//w_do='K'
//@ 22, 0 to 24, 79
//@ 23, 0 say centermsg( "Kumulativno/Pojedinacno (K/P)" )
//@ 23, 60 get w_do picture '!'
//read
//if w_do='K'
//do s_m_j_v_kum
//clos all
//return
//endif
select OTKUP
   set index to otk_ss,otk_sd,otk_vd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
uk1=0.00
uk2=0.00
uk3=0.00			 
uk4=0
sv1=0.00
sv2=0.00
sv3=0.00
sv4=0
ukupno=0.00
svega=0.00
raz=0.0
@ 1,1 to 1,79
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do stampa_sva_m_jed_voce
clos all
return
endif

select VOCE
   set index to v_no,v_name
seek v_par
		@ 1,1 to 1,79
@ row(),10 say naziv_v
@ 2,20 say 'Prepod.:'
@ 2,34 say 'I Klasa:'
@ 2,48 say 'II Klasa:'
@ 2,64 say 'III klasa:'
@ 3,0 to 3,79
save screen to scr
select MESTA
	go top
do while !eof()
w_c=sifra_m
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
uk1=uk1+kol_otk
uk2=uk2+raz_otk
uk3=uk3+kol_otkii
uk4=uk4+kol4
	skip
enddo

select MESTA

		@ row()+1,1 say rtrim(MESTA->NAZIV_M)
		@ row(),20 say uk1 picture '@E 9,999,999.99'
		@ row(),34 say uk2 picture '@E 9,999,999.99'
		@ row(),48 say uk3 picture '@E 9,999,999.99'
		@ row(),64 say uk4 picture '@E 9,999,999.99'
//		@ row(),64 say uk1+uk2+uk3 picture '@E 9,999,999.99'
sv1=sv1+uk1
sv2=sv2+uk2
sv3=sv3+uk3
sv4=sv4+uk4

uk1=0.00
uk2=0.00
uk3=0.00
uk4=0.00
		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
		@ 1,1 to 1,79
		@ 2,1 clear to 19,79
		endif
skip
enddo
if row()>=19
inkey(0)
@ 1,0 to 1,79
@ 2,0 clear to 19,79
endif
@ row()+1,0 to row()+1,79
@ row()+1,0 say 'SVEGA:'
		@ row(),20 say sv1 picture '@E 9,999,999.99'
		@ row(),34 say sv2 picture '@E 9,999,999.99'
		@ row(),48 say sv3 picture '@E 9,999,999.99'
		@ row(),64 say sv4 picture '@E 9,999,999.99'
		@ row()+1,1 say 'UKUPNO:'
		@ row(),20 say sv1+sv2+sv3+sv4 picture '@E 9,999,999.99'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "ESC - Izlaz" )
inkey(0)
return


**********************************************************
**STAMPA
**********************************************************

*sva mesta jedno voce
procedure stampa_sva_m_jed_voce
select OTKUP
   set index to otk_ss,otk_vd,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa u toku..." )
uk1=0.00
uk2=0.00
uk3=0.00
uk4=0
sv1=0.00
sv2=0.00
sv3=0.00
sv4=0
ukupno=0.00
svega=0.00
raz=0.0
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
select VOCE
   set index to v_no,v_name
seek v_par
@ prow()+1,10 say 'Izvestaj o otkupu za period od '+' '+dtoc(datum1)+' do '+dtoc(datum2)
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,35 say naziv_v
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say 'Otkupno mesto:'
@ prow(),20 say 'Prepod.:'
@ prow(),34 say 'I Klasa:'
@ prow(),48 say 'II Klasa:'
@ prow(),64 say 'III klasa:'
@ prow()+1,0 say replicate ('-',80)
select MESTA
	go top
do while !eof()
w_c=sifra_m
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
uk1=uk1+kol_otk
uk2=uk2+raz_otk
uk3=uk3+kol_otkii
uk4=uk4+kol4

	skip
enddo
		@ prow()+1,1 say rtrim(MESTA->NAZIV_M)
		@ prow(),20 say uk1 picture '@E 9,999,999.99'
		@ prow(),34 say uk2 picture '@E 9,999,999.99'
		@ prow(),48 say uk3 picture '@E 9,999,999.99'
		@ prow(),64 say uk4 picture '@E 9,999,999.99'
//		@ prow(),64 say uk1+uk2+uk3 picture '@E 9,999,999.99'
sv1=sv1+uk1
sv2=sv2+uk2
sv3=sv3+uk3
sv4=sv4+uk4

uk1=0.00
uk2=0.00
uk3=0.00
uk4=0.00

if prow()>=60
eject
endif
select MESTA
	skip
enddo
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,0 say 'SVEGA:'
		@ prow(),20 say sv1 picture '@E 9,999,999.99'
		@ prow(),34 say sv2 picture '@E 9,999,999.99'
		@ prow(),48 say sv3 picture '@E 9,999,999.99'
		@ prow(),64 say sv4 picture '@E 9,999,999.99'
		@ prow()+1,0 say 'UKUPNO:'
		@ prow(),64 say sv1+sv2+sv3+sv4 picture '@E 9,999,999.99'
@ prow()+1,0 say ' '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return


*********************************
*JEDNO MESTO _ JEDNO VOCE
*********************************
procedure old_jednom_jedno_voce
select KOM 
set index to kom_no
select OTKUP
   set index to otk_ss,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
*store date() to datum1,datum2
ukupno=0.00
ukupno1=0.00
svega=0.00
uk_raz=0.00
third=0
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do stampa_jednom_jedno_voce
//clos all
return
endif
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ 2,5 say naziv_m +'   -    '
select VOCE
   set index to v_no
seek v_par
if found()
@ 2,40 say naziv_v
@ 3,0 to 3,79
@ 4,5 say 'Datum:'
@ 4,30 say 'Prepod.:'
@ 4,40 say 'I Klasa:'
@ 4,50 say 'II Klasa:'
@ 4,60 say 'III Klasa:'
@ 4,70 say 'Dokument:'
@ 5,0 to 5,79
save screen to scr
endif
*set color to 
select OTKUP
set relation to sifra_otk into KOM
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
@ row()+1,1 say substr(dtoc(datum_otk),1,5)
@ row(),8 say substr(KOM->ime_k,1,20)   &&&rtrim(sifra_otk)
@ row(),30 say kol_otk picture '@E 99,999.99'
@ row(),40 say raz_otk picture '@E 99,999.99'
@ row(),50 say kol_otkII picture '@E 99,999.99'
@ row(),60 say kol4 picture '@E 99,999.99'
@ row(),72 say doc_otk
//@ row(),60 say (kol_otk+raz_otk)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 9,999,999.99'

if row()>=19
inkey(0)
if lastkey()=27
return
endif
@ 1,1 to 1,79
@ 2,1 clear to 19,79
@ 2,5 say MESTA->naziv_m +'   -    '
@ 2,40 say VOCE->naziv_v
@ 3,0 to 3,79
@ 4,5 say 'Datum:'
@ 4,40 say 'I Klasa:'
@ 4,50 say 'II Klasa:'
@ 4,60 say 'III Klasa:'
@ 4,70 say 'Dokument:'
@ 5,0 to 5,79
endif

ukupno=ukupno+kol_otk
uk_raz=uk_raz+raz_otk
ukupno1=ukupno1+kol_otkii
third=third+kol4
skip
enddo
@ row()+1,0 to row()+1,79
@ row()+1,10 say 'SVEGA:'
@ row(),30 say ukupno picture '@E 999,999.99'
@ row(),40 say uk_raz picture '@E 999,999.99'
@ row(),50 say ukupno1 picture '@E 999,999.99'
@ row(),60 say third picture '@E 999,999.99'

select VOCE
   set index to v_name,v_no

select MESTA
   set index to m_name,m_no
endif
@ row()+1,0 say 'UKUPNO:'
@ row(),30 say ukupno+ukupno1+uk_raz+third picture '@E 9,999,999.99'
inkey(0)
return
********************************
procedure jednom_jedno_voce
select OTKUP
   set index to otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
uk_raz=0.00
third=0
sum=0
sumI=0
sumII=0
sumIII=0
@ 1,1 to 1,79
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/po Datumu/Otkupni list (E/P/D/O)" )
@ 23, 65 get stampa picture '!'
read
if stampa='P'
do stmp_jm_jv
//clos all
return
endif
if stampa='D'
do old_jednom_jedno_voce
//clos all
return
endif
if stampa='O'
do otk_list
return	   
endif

select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
@ 2,5 say naziv_m +'   -    '
endif
select VOCE
   set index to v_no,v_name
seek v_par
if found()
@ 2,40 say naziv_v
@ 3,0 to 3,79
@ 4,5 say 'Proizvodjac:'
@ 4,45 say 'Kolicina:'
@ 4,60 say 'Vrednost:'
@ 5,0 to 5,79
save screen to scr
endif
select KOM
set index to kom_no
go top                            
seek substr(k_par,1,3)
do while !eof() .and. substr(sifra_k,1,3)=substr(k_par,1,3)
select OTKUP
go top
set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
sum=sum+kol_otk
sumI=sumI+raz_otk
sumII=sumII+kol_otkii
sumIII=sumIII+kol4
skip
enddo
  
if   sum+sumI+sumII>0.0
@ row()+1,5 say rtrim(KOM->ime_k)
@ row(),45 say sum+sumI+sumII+sumIII picture '@E 9,999,999.99'
@ row(),60 say (sum*VOCE->cena_v+sumI*VOCE->druga+sumII*VOCE->treca+sumIII*Voce->cetvrta)*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
endif

if row()>=19
inkey(0)
@ 1,1 to 1,79
@ 2,1 clear to 19,79
@ 2,5 say MESTA->naziv_m +'   -    '
@ 2,40 say VOCE->naziv_v
@ 3,0 to 3,79
@ 4,5 say 'Proizvodjac:'
@ 4,45 say 'Kolicina:'
@ 4,60 say 'Vrednost:'
@ 5,0 to 5,79
endif

ukupno=ukupno+sum
uk_raz=uk_raz+sumI
svega=svega+sumII
third=third+sumIII
sumI=0
sumII=0
sumIII=0
sum=0
select KOM
skip
enddo

@ row()+1,0 to row()+1,79
@ row(),45 say ukupno+uk_raz+svega+third picture '@E 9,999,999.99'
@ row(),60 say (ukupno*VOCE->cena_v+uk_raz*VOCE->druga+svega*VOCE->treca+third*VOCE->cetvrta)*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
inkey(0)

return
********************************
 procedure stampa_jednom_jedno_voce
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa u toku..." )

set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
ukupno=0.00
ukupno1=0.00
svega=0.00
uk_raz=0.0
third=0


select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
w_c=sifra_m
select VOCE
   set index to v_no,v_name
seek v_par
@ prow()+1,1 say 'Izvestaj o otkupu od '+' '+dtoc(datum1)+' do '+dtoc(datum2)+' '+'za mesto '+MESTA->naziv_m
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,35 say naziv_v
 @ prow()+1,0 say replicate ('-',100)
@ prow()+1,1 say 'Datum:'
@ prow(),40 say 'Prepod.:'
@ prow(),55 say 'I Klasa:'
@ prow(),70 say 'II Klasa:'
@ prow(),85 say 'III Klasa:'
@ prow()+1,0 say replicate ('-',100)
select OTKUP
set relation to sifra_otk into KOM
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk
uk_raz=uk_raz+raz_otk
ukupno1=ukupno1+kol_otkii
third=third+kol4
		@ prow()+1,1 say substr(dtoc(datum_otk),1,5)
		@ prow(),7 say rtrim(KOM->ime_k)+' '+rtrim(KOM->mesto_k)  &&&datum_otk
		@ prow(),40 say kol_otk picture '@E 999,999.99'
		@ prow(),54 say raz_otk picture '@E 999,999.99'
		@ prow(),69 say kol_otkii picture '@E 999,999.99'
		@ prow(),84 say kol4 picture '@E 999,999.99'
		@ prow(),96 say doc_otk 

if prow()>=60
eject
endif
select OTKUP
	skip
enddo


@ prow()+1,0 say replicate ('-',100)
@ prow()+1,0 say 'SVEGA:'
@ prow(),40 say ukupno picture '@E 999,999.99'
@ prow(),54 say uk_raz picture '@E 999,999.99'
@ prow(),69 say ukupno1 picture '@E 999,999.99'
@ prow(),84 say third picture '@E 999,999.99'
@ prow()+1,0 say 'UKUPNO:'
@ prow(),40 say third+ukupno+ukupno1+uk_raz picture '@E 999,999.99'

@ prow()+1,0 say ' '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return			    
****************************************
**SVA MESTA JEDNO VOCE _ KUMULATIVNO
****************************************
*sva mesta jedno voce
procedure s_m_j_v_kum
select OTKUP
   set index to otk_vd,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
raz=0.0
zb_otk=0.00
zb_raz=0.00
amb_z=0.00
amb_r=0.00
uk_amb=0.00
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P/Z)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do pr_kum_voce
//clos all
return
endif
if stampa='Z'
do st_zbir_kum_voce
//clos all
return
endif

*@ 2,50 say 'Kolicina:'
*@ 2,65 say 'Vrednost:'
*@ 3,0 to 3,79
select VOCE
   set index to v_no,v_name
seek v_par
		@ 1,1 to 1,79
@ row(),10 say naziv_v
@ row(),28 say 'Kolicina:'
@ row(),42 say 'Razlika:'
@ row(),55 say 'Vrednost:'
@ row(),70 say 'Ambalaza:'
@ row()+1,0 to row()+1,79
save screen to scr
*select VOCE
*   go top
*do while !eof()
*    @ row()+1,0 say naziv_v
select MESTA
	go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
	if substr(sifra_otk,1,3)!=MESTA->SIFRA_M 
		skip 
		loop
	endif
ukupno=ukupno+kol_otk 
raz=raz+raz_otk
*               @ row()+1,1 say MESTA->NAZIV_M
*               @ row(),22 say datum_otk
*               @ row(),37 say kol_otk picture '@E 9,999,999.99'
*               @ row(),50 say raz_otk picture '@E 9,999,999.99'
*        @ row(),65 say (kol_otk+raz_otk)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 9,999,999.99'

		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
*restore screen from scr
		@ 1,1 to 1,79
		@ 2,1 clear to 20,79
		endif

	
	skip
enddo
*********************************
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while  amb_datum<=datum2 .and. !eof()
if  substr(amb_sif,1,3)!=MESTA->SIFRA_M 
skip 
loop
endif

*if amb_kol<>0.00
*       if amb_stat='Z'
*       amb_z=amb_z+amb_kol+amb_raz
*       else
*       amb_r=amb_r+amb_kol+amb_raz
*endif
*endif
	amb_z=amb_z+amb_kol   &&+amb_raz
	amb_r=amb_r+amb_raz   &&amb_kol+amb_raz


skip
enddo
*********************************

*if !empty(ukupno)
@ row()+1,1 say MESTA->NAZIV_M
@ row(),27 say ukupno picture '@E 9,999,999.99'
@ row(),40 say raz picture '@E 9,999,999.99'
@ row(),52 say (ukupno+raz)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ row(),70 say amb_z-amb_r picture '@E 999,999'
zb_otk=zb_otk+ukupno
zb_raz=zb_raz+raz
uk_amb=uk_amb+(amb_z-amb_r)
raz=0.00
ukupno=0.00
amb_z=0.00
amb_r=0.00
*endif
select MESTA
	skip
enddo
*@ row()+1,50 say ukupno picture '@E 9,999,999.99'
*@ row(),65 say ukupno*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
*@ row()+1,0 to row()+1,79
		*inkey(0)
svega=(ukupno+raz)*VOCE->cena_v*(1+VOCE->pdv/100)
*ukupno=0.00
		*@ 2,1 clear to 19,79
if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
*@ 1,1 to 1,79
*@ 2,1 clear to 19,79
restore screen from scr
endif
*select VOCE
*skip
*enddo
@ row()+1,0 to row()+1,79
@ row(),0 say 'SVEGA:'
@ row(),27 say zb_otk picture '@E 9,999,999.99'
@ row(),40 say zb_raz picture '@E 9,999,999.99'
@ row(),52 say (zb_otk+zb_raz)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ row(),70 say uk_amb picture '@E 999,999'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "ESC - Izlaz" )
inkey(0)
return
**********************************
*STAMPA KUMULATIVA
**********************************
procedure pr_kum_voce
amb_z=0.00
amb_r=0.00
uk_amb=0.00
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
select VOCE
   set index to v_no,v_name
seek v_par
@ prow()+1,5 say 'Izvestaj o otkupu od '+' '+dtoc(datum1)+' do '+dtoc(datum2)+' '+'za sva otkupna mesta'
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,35 say naziv_v
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say 'Otkupno mesto:'
*@ prow()+1,10 say 'Datum:'
@ prow(),28 say 'Kolicina:'
@ prow(),42 say 'Razlika:'
@ prow(),55 say 'Vrednost:'
@ prow(),70 say 'Ambalaza:'
@ prow()+1,0 say replicate ('-',80)
select MESTA
	go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
	if substr(sifra_otk,1,3)!=MESTA->SIFRA_M 
		skip 
		loop
	endif
ukupno=ukupno+kol_otk 
raz=raz+raz_otk
*               @ prow()+1,1 say MESTA->NAZIV_M
*               @ prow(),22 say datum_otk
*               @ prow(),37 say kol_otk picture '@E 9,999,999.99'
*               @ prow(),50 say raz_otk picture '@E 9,999,999.99'
*        @ prow(),65 say (kol_otk+raz_otk)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 9,999,999.99'


	
	skip
enddo
*********************************
  select AMB
set softseek on
seek DTOS(DATUM1)
set softseek off
do while  amb_datum<=datum2 .and. !eof()
if  substr(amb_sif,1,3)!=MESTA->SIFRA_M 
skip 
loop
endif

*if amb_kol<>0.00
*       if amb_stat='Z'
*       amb_z=amb_z+amb_kol+amb_raz
*       else
*       amb_r=amb_r+amb_kol+amb_raz
*endif
*endif
	amb_z=amb_z+amb_kol   &&+amb_raz
	amb_r=amb_r+amb_raz   &&amb_kol+amb_raz


skip
enddo
*********************************
*if !empty(ukupno)
@ prow()+1,1 say MESTA->NAZIV_M
@ prow(),27 say ukupno picture '@E 9,999,999.99'
@ prow(),40 say raz picture '@E 9,999,999.99'
@ prow(),52 say (ukupno+raz)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ prow(),70 say amb_z-amb_r picture '@E 999,999'
zb_otk=zb_otk+ukupno
zb_raz=zb_raz+raz
uk_amb=uk_amb+(amb_z-amb_r)
raz=0.00
amb_z=0.00
amb_r=0.00
ukupno=0.00
*endif
		if prow()>=60
		eject
		@ prow()+2,1 say '  '
		endif
select MESTA
	skip
enddo
svega=(ukupno+raz)*VOCE->cena_v*(1+VOCE->pdv/100)
		if prow()>=60
		eject
		@ prow()+2,1 say '  '
	endif

@ prow()+1,0 say replicate ('-',80)
@ prow()+1,0 say 'SVEGA:'
@ prow(),27 say zb_otk picture '@E 9,999,999.99'
@ prow(),40 say zb_raz picture '@E 9,999,999.99'
@ prow(),52 say (zb_otk+zb_raz)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ prow(),70 say uk_amb picture '@E 999,999'
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,0 say 'SALDO:'
@ prow(),31 say zb_otk+zb_raz picture '@E 99,999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

**********************************
*STAMPA KUMULATIVA
**********************************
procedure st_zbir_kum_voce
amb_z=0.00
amb_r=0.00
uk_amb=0.00
D_OTK=0.00
D_RAZ=0.00
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
select VOCE
   set index to v_no,v_name
seek v_par
@ prow()+1,5 say 'Izvestaj o otkupu od '+' '+dtoc(datum1)+' do '+dtoc(datum2)+' '+'za sva otkupna mesta'
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,35 say naziv_v

n=datum2-datum1
for q=0 to n
datt=datum1+q
@ prow()+1,0 say dtoc(datt)


@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say 'Otkupno mesto:'
*@ prow()+1,10 say 'Datum:'
@ prow(),28 say 'Kolicina:'
@ prow(),42 say 'Razlika:'
@ prow(),55 say 'Vrednost:'
@ prow(),70 say 'Ambalaza:'
@ prow()+1,0 say replicate ('-',80)

select MESTA
	go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek VOCE->SIFRA_V+DTOS(datt)
set softseek off
do while sifra_otv=VOCE->SIFRA_V .and. datum_otk=datt .and. !eof()
	if substr(sifra_otk,1,3)!=MESTA->SIFRA_M 
		skip 
		loop
	endif
ukupno=ukupno+kol_otk 
D_OTK=D_OTK+KOL_OTK
D_RAZ=D_RAZ+RAZ_OTK
raz=raz+raz_otk
*               @ prow()+1,1 say MESTA->NAZIV_M
*               @ prow(),22 say datum_otk
*               @ prow(),37 say kol_otk picture '@E 9,999,999.99'
*               @ prow(),50 say raz_otk picture '@E 9,999,999.99'
*        @ prow(),65 say (kol_otk+raz_otk)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 9,999,999.99'


	
	skip
enddo
*********************************
  select AMB
set softseek on
seek DTOS(DATt)
set softseek off
do while  amb_datum=datt .and. !eof()
if  substr(amb_sif,1,3)!=MESTA->SIFRA_M 
skip 
loop
endif

*if amb_kol>0.00
*       if amb_stat='Z'
*       amb_z=amb_z+amb_kol+amb_raz
*       else
*       amb_r=amb_r+amb_kol+amb_raz
*endif
*endif
	amb_z=amb_z+amb_kol   &&+amb_raz
	amb_r=amb_r+amb_raz   &&amb_kol+amb_raz


skip
enddo
*********************************
if !empty(ukupno)
@ prow()+1,1 say MESTA->NAZIV_M
@ prow(),27 say ukupno picture '@E 9,999,999.99'
@ prow(),40 say raz picture '@E 9,999,999.99'
@ prow(),52 say (ukupno+raz)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ prow(),70 say amb_z-amb_r picture '@E 999,999'
zb_otk=zb_otk+ukupno
zb_raz=zb_raz+raz
uk_amb=uk_amb+(amb_z-amb_r)
raz=0.00
amb_z=0.00
amb_r=0.00
ukupno=0.00
endif
		if prow()>=60
		eject
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say 'Otkupno mesto:'
*@ prow()+1,10 say 'Datum:'
@ prow(),28 say 'Kolicina:'
@ prow(),42 say 'Razlika:'
@ prow(),55 say 'Vrednost:'
@ prow(),70 say 'Ambalaza:'
@ prow()+1,0 say replicate ('-',80)
		endif
select MESTA
	skip
enddo
svega=(ukupno+raz)*VOCE->cena_v*(1+VOCE->pdv/100)
		if prow()>=60
		eject
		@ prow()+2,1 say '  '
	endif

@ prow()+1,0 say replicate ('-',80)
@ prow()+1,0 say 'ZA DAN:'
@ prow(),27 say D_OTK picture '@E 9,999,999.99'
@ prow(),40 say D_RAZ picture '@E 9,999,999.99'
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,0 say 'SVEGA:'
@ prow(),27 say zb_otk picture '@E 9,999,999.99'
@ prow(),40 say zb_raz picture '@E 9,999,999.99'
@ prow(),52 say (zb_otk+zb_raz)*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
@ prow(),70 say uk_amb picture '@E 999,999'
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,0 say 'SALDO:'
@ prow(),31 say zb_otk+zb_raz picture '@E 99,999,999.99'
@ prow()+3,0 say ' '
D_OTK=0.00
D_RAZ=0.00
next q
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

**************************************
*sva mesta svo voce po mestima
**********************************
procedure sva_mesta
select OTKUP
   set index to otk_ss,otk_sd,otk_vd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "ESC->Izlaz" )
store date() to datum1,datum2
ukupno=0.00
ukupno1=0.00
uk1=0.00
uk2=0.00
uk3=0.00
uk4=0
third=0
svega=0.00
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
if lastkey()=27
return
endif
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Malina (E/P/M)" )
@ 23, 60 get stampa picture '!'
read
if lastkey()=27
return
endif
if stampa='P'
do pr_sva_mesta
return
endif
if stampa='M'
do pr_mesto_mal
return
endif
@ 2,20 say 'Prepod.:'
@ 2,32 say 'I Klasa:'
@ 2,44 say 'II Klasa:'
@ 2,60 say 'III klasa:'
@ 3,0 to 3,79
save screen to scr
select MESTA
	go top
do while !eof()
w_c=sifra_m
    @ row()+1,0 say naziv_m
select VOCE
   go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk
uk1=uk1+raz_otk
ukupno1=ukupno1+kol_otkii
uk4=uk4+kol4
	
	skip
enddo


select VOCE
skip
enddo
		@ row(),20 say ukupno picture '@E 9,999,999.99'
		@ row(),34 say uk1 picture '@E 9,999,999.99'
		@ row(),48 say ukupno1 picture '@E 9,999,999.99'
		@ row(),64 say uk4 picture '@E 9,999,999.99'
//		@ row(),64 say ukupno+ukupno1+uk1 picture '@E 9,999,999.99'
svega=svega+ukupno
uk2=uk2+ukupno1
uk3=uk3+uk1
third=third+uk4

ukupno=0.00
ukupno1=0.00
uk1=0
uk4=0
if row()>=19
inkey(0)
@ 1,1 to 1,79
@ 2,0 clear to 19,79
endif
select MESTA
	skip
enddo
@ row()+1,0 to row()+1,79
@ row()+1,0 say 'SVEGA:'
		@ row(),20 say svega picture '@E 9,999,999.99'
		@ row(),34 say uk3 picture '@E 9,999,999.99'
		@ row(),48 say uk2 picture '@E 9,999,999.99'
		@ row(),64 say third picture '@E 9,999,999.99'
@ row()+1,0 say 'UKUPNO:'
		@ row(),64 say svega+uk2+uk3+third picture '@E 9,999,999.99'
inkey(0)
return

***STAMPA

procedure pr_sva_mesta
select OTKUP
   set index to otk_ss,otk_vd,otk_sd
ukupno=0.00
ukupno1=0.00			  
third=0
uk1=0.00
uk2=0.00
uk3=0.00
uk4=0.00
svega=0.00
set device to print
setprc(0,0)
  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,5 say 'Pregled otkupa maline za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,20 say 'Prepod.:'
@ prow(),34 say 'I Klasa:'
@ prow(),48 say 'II Klasa:'
@ prow(),64 say 'III klasa:'
@ prow()+1,0 say replicate('-',79)
select MESTA
	go top
do while !eof()
w_c=sifra_m
    @ prow()+1,0 say naziv_m
select VOCE
   go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno=ukupno+kol_otk
uk1=uk1+raz_otk
ukupno1=ukupno1+kol_otkii
third=third+kol4	
	skip
enddo


select VOCE
skip
enddo
		@ prow(),20 say ukupno picture '@E 9,999,999.99'
		@ prow(),34 say uk1 picture '@E 9,999,999.99'
		@ prow(),48 say ukupno1 picture '@E 9,999,999.99'
		@ prow(),64 say third picture '@E 9,999,999.99'
//		@ prow(),64 say ukupno+ukupno1+uk1 picture '@E 9,999,999.99'

svega=svega+ukupno
uk2=uk2+ukupno1
uk3=uk3+uk1
uk4=uk4+third
ukupno=0.00
ukupno1=0.00
uk1=0
third=0
if prow()>=65
eject
@ prow()+1,0 say replicate('-',79)
@ prow()+1,20 say 'Prepod.:'
@ prow(),34 say 'I Klasa:'
@ prow(),48 say 'II Klasa:'
@ prow(),64 say 'III klasa:'
@ prow()+1,0 say replicate('-',79)
endif
select MESTA
	skip
enddo
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA:'
		@ prow(),20 say svega picture '@E 9,999,999.99'
		@ prow(),34 say uk3 picture '@E 9,999,999.99'
		@ prow(),48 say uk2 picture '@E 9,999,999.99'
		@ prow(),64 say uk4 picture '@E 9,999,999.99'
@ prow()+1,0 say 'UKUPNO:'
		@ prow(),64 say svega+uk2+uk3+uk4 picture '@E 9,999,999.99'
		eject
		cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
		set device to screen
return
/////
//Stampa svih mesta sa malinom
//////////////////////////
procedure pr_mesto_mal
select OTKUP
   set index to otk_ss,otk_vd,otk_sd
   sum=0
   sum1=0
   sum2=0
   sum3=0

   ukupno=0.00
ukupno1=0.00
uk1=0.00
uk2=0.00
uk3=0.00
uk4=0
uk5=0
uk6=0
uk7=0
uk8=0
uk9=0
uk10=0

svega=0.00
zbir1=0
zbir2=0
zbir3=0
zbir4=0
zbir5=0
zbir6=0
zbir7=0
zbir8=0
zbir9=0
zbir10=0

mal1=0
mal2=0
mal3=0
suma1=0
suma2=0
suma3=0
set device to print
setprc(0,0)
  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,5 say 'Pregled otkupa maline za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',130)
@ prow()+1,20 say 'Ekstra:'
@ prow(),30 say 'Vred.:'
@ prow(),42 say 'I Klasa:'
@ prow(),52 say 'Vred:'
@ prow(),64 say 'II Klasa:'
@ prow(),74 say 'Vred:'
@ prow(),86 say 'III Klasa:'
@ prow(),96 say 'Vred:'
@ prow(),108 say 'Ukupno kg:'
@ prow(),118 say 'Svega DIN:'
@ prow()+1,0 say replicate('-',130)
select MESTA
	go top
do while !eof()
w_c=sifra_m
    @ prow()+1,0 say naziv_m
    @ prow(),0 say naziv_m
select VOCE
   go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

sum=sum+kol_otk
sum1=sum1+raz_otk
sum2=sum2+kol_otkii
sum3=sum3+kol4
	
	skip
enddo

	  if sum>0 .or. sum1>0 .or. sum2>0 .or. sum3>0
		@ prow()+1,0 say rtrim(VOCE->naziv_v)
		@ prow(),20 say sum picture '@E 999,999.99'
		@ prow(),30 say sum*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
		@ prow(),42 say sum1 picture '@E 999,999.99'
		@ prow(),52 say sum1*VOCE->druga*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
		@ prow(),64 say sum2 picture '@E 999,999.99'
		@ prow(),74 say sum2*VOCE->treca*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
		@ prow(),86 say sum3 picture '@E 999,999.99'
		@ prow(),96 say sum3*VOCE->cetvrta*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
		@ prow(),108 say sum+sum1+sum2+sum3 picture '@E 999,999.99'
		@ prow(),118 say (sum*VOCE->cena_v+sum1*VOCE->druga+sum2*VOCE->treca+sum3*VOCE->cetvrta)*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
	  endif
uk1=uk1+sum
uk2=uk2+sum*VOCE->cena_v*(1+VOCE->pdv/100)
uk3=uk3+sum1
uk4=uk4+sum1*VOCE->druga*(1+VOCE->pdv/100)
uk5=uk5+sum2
uk6=uk6+sum2*VOCE->treca*(1+VOCE->pdv/100)
uk7=uk7+sum3
uk8=uk8+sum3*VOCE->cetvrta*(1+VOCE->pdv/100)
uk9=uk9+sum+sum1+sum2+sum3
uk10=uk10+(sum*VOCE->cena_v+sum1*VOCE->druga+sum2*VOCE->treca+sum3*VOCE->cetvrta)*(1+VOCE->pdv/100)
		select VOCE
   sum=0
   sum1=0
   sum2=0
   sum3=0
skip
enddo


if prow()>=65
eject
@ prow()+1,0 say replicate('-',130)
@ prow()+1,20 say 'Ekstra:'
@ prow(),30 say 'Vred.:'
@ prow(),42 say 'I Klasa:'
@ prow(),52 say 'Vred:'
@ prow(),64 say 'II Klasa:'
@ prow(),74 say 'Vred:'
@ prow(),86 say 'III Klasa:'
@ prow(),96 say 'Vred:'
@ prow(),108 say 'Ukupno kg:'
@ prow(),118 say 'Svega DIN:'
@ prow()+1,0 say replicate('-',130)
endif

@ prow()+1,0 say replicate('-',130)
		@ prow()+1,0 say 'ZBIR:'
		@ prow(),20 say uk1 picture '@E 999,999.99'
		@ prow(),30 say uk2 picture '@E 9,999,999.99'
		@ prow(),42 say uk3 picture '@E 999,999.99'
		@ prow(),52 say uk4 picture '@E 9,999,999.99'
		@ prow(),64 say uk5 picture '@E 999,999.99'
		@ prow(),74 say uk6 picture '@E 9,999,999.99'
		@ prow(),86 say uk7 picture '@E 999,999.99'
		@ prow(),96 say uk8 picture '@E 9,999,999.99'
		@ prow(),108 say uk9 picture '@E 999,999.99'
		@ prow(),118 say uk10 picture '@E 9,999,999.99'
@ prow()+1,0 say replicate('-',130)
zbir1=zbir1+uk1
zbir2=zbir2+uk2
zbir3=zbir3+uk3
zbir4=zbir4+uk4
zbir5=zbir5+uk5
zbir6=zbir6+uk6
zbir7=zbir7+uk7
zbir8=zbir8+uk8
zbir9=zbir9+uk9
zbir10=zbir10+uk10
uk1=0.00
uk2=0.00
uk3=0.00
uk4=0
uk5=0
uk6=0
uk7=0
uk8=0
uk9=0
uk10=0
		@ prow()+1,0 say '  '

select MESTA
	skip
enddo
@ prow()+1,0 say replicate('-',130)
@ prow()+1,0 say 'SVEGA:'
		@ prow(),20 say zbir1 picture '@E 999,999.99'
		@ prow(),30 say zbir2 picture '@E 9,999,999.99'
		@ prow(),42 say zbir3 picture '@E 999,999.99'
		@ prow(),52 say zbir4 picture '@E 9,999,999.99'
		@ prow(),64 say zbir5 picture '@E 999,999.99'
		@ prow(),74 say zbir6 picture '@E 9,999,999.99'
		@ prow(),86 say zbir7 picture '@E 999,999.99'
		@ prow(),96 say zbir8 picture '@E 9,999,999.99'
		@ prow(),108 say zbir9 picture '@E 999,999.99'
		@ prow(),118 say zbir10 picture '@E 9,999,999.99'
		eject
		cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
		set device to screen
return

procedure old_pr_mesto_mal
select OTKUP
   set index to otk_ss,otk_vd,otk_sd
ukupno=0.00
ukupno1=0.00
uk1=0.00
uk2=0.00
uk3=0.00
svega=0.00
zbir1=0
zbir2=0
zbir3=0

mal1=0
mal2=0
mal3=0
suma1=0
suma2=0
suma3=0
set device to print
setprc(0,0)
  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,5 say 'Pregled otkupa maline za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',130)
@ prow()+1,24 say 'Cena:'
@ prow(),36 say 'I Klasa:'
@ prow(),48 say 'Vred:'
@ prow(),63 say 'Cena:'
@ prow(),73 say 'II Klasa:'
@ prow(),85 say 'Vred:'
@ prow(),101 say 'Ukupno:'
@ prow(),115 say 'Svega:'
@ prow()+1,0 say replicate('-',130)
select MESTA
	go top
do while !eof()
w_c=sifra_m
    @ prow()+1,0 say naziv_m
    @ prow(),0 say naziv_m
select VOCE
   go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno=ukupno+kol_otk
uk1=uk1+raz_otk
ukupno1=ukupno1+kol_otkii
	
	skip
enddo

	  if ukupno>0 .or. uk1>0 .or. ukupno1>0
		@ prow()+1,0 say rtrim(VOCE->naziv_v)
//		@ prow(),20 say VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 999.99'
//		@ prow(),28 say ukupno picture '@E 999,999.99'
//		@ prow(),40 say ukupno*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 9,999,999.99'

		@ prow(),20 say VOCE->druga picture '@E 999.99'
		@ prow(),32 say uk1 picture '@E 999,999.99'
		@ prow(),46 say uk1*VOCE->druga*1.05 picture '@E 9,999,999.99'
		@ prow(),61 say VOCE->treca picture '@E 999.99'
		@ prow(),69 say ukupno1 picture '@E 999,999.99'
		@ prow(),81 say ukupno1*VOCE->treca*1.05 picture '@E 9,999,999.99'
		@ prow(),96 say ukupno+ukupno1+uk1 picture '@E 9,999,999.99'
		@ prow(),111 say (ukupno*VOCE->cena_v+ukupno1*VOCE->treca+uk1*VOCE->druga)*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
	  endif
svega=svega+ukupno
uk2=uk2+uk1
uk3=uk3+ukupno1
zbir1=zbir1+ukupno*VOCE->cena_v*(1+VOCE->pdv/100)
zbir2=zbir2+uk1*VOCE->druga *1.05
zbir3=zbir3+ukupno1*VOCE->treca*1.05

mal1=mal1+ukupno
mal2=mal2+uk1
mal3=mal3+ukupno1
suma1=suma1+ukupno*VOCE->cena_v*(1+VOCE->pdv/100)
suma2=suma2+uk1*VOCE->druga*1.05
suma3=suma3+ukupno1*VOCE->treca*1.05

ukupno=0.00
ukupno1=0.00
uk1=0
		select VOCE
skip
enddo


if prow()>=65
eject
@ prow()+1,0 say replicate('-',130)
@ prow()+1,24 say 'Cena:'
@ prow(),36 say 'I Klasa:'
@ prow(),48 say 'Vred:'
@ prow(),63 say 'Cena:'
@ prow(),73 say 'II Klasa:'
@ prow(),85 say 'Vred:'
@ prow(),101 say 'Ukupno:'
@ prow(),115 say 'Svega:'
@ prow()+1,0 say replicate('-',130)
endif

@ prow()+1,0 say replicate('-',130)
		@ prow()+1,0 say 'ZBIR:'
		@ prow(),32 say uk2 picture '@E 999,999.99'
		@ prow(),46 say zbir2 picture '@E 9,999,999.99'
		@ prow(),69 say uk3 picture '@E 999,999.99'
		@ prow(),81 say zbir3 picture '@E 9,999,999.99'
		@ prow(),96 say uk1+uk2+uk3 picture '@E 9,999,999.99'
		@ prow(),111 say zbir2+zbir3 picture '@E 9,999,999.99'
@ prow()+1,0 say replicate('-',130)

uk1=0.00
uk2=0.00
uk3=0.00
zbir1=0
zbir2=0
zbir3=0
		@ prow()+1,0 say '  '

select MESTA
	skip
enddo
@ prow()+1,0 say replicate('-',130)
@ prow()+1,0 say 'SVEGA:'
		@ prow(),30 say mal2 picture '@E 9,999,999.99'
		@ prow(),42 say suma2 picture '@E 9,999,999,999.99'
		@ prow(),67 say mal3 picture '@E 999,999.99'
		@ prow(),79 say suma3 picture '@E 9,999,999.99'
		@ prow(),94 say mal1+mal2+mal3 picture '@E 9,999,999.99'
		@ prow(),107 say suma2+suma3 picture '@E 9,999,999,999.99'
		eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)		
		set device to screen
return


procedure spisak_mesta
clear
setcolor(DEF_MAGENTA)
@ 00, 00 say center( "Stampa otkupnih mesta")
@ 1, 0 clear to 20, 79
@ 1, 0 to 20, 79 double
*@ 2, 25 say 'Mesto:'
save screen to screen1
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_no
else
  clos all
  RETURN   
endif

stampa='E'
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if lastkey()=27
return
endif
if stampa='P'
do prriinntt
close all
return
endif
lis=3
  restore screen from screen1
@ 00, 00 say center( "Otkupna mesta")

do while !eof()
      @ lis, 4 say sifra_m+' '+naziv_m+' '+otk_m+' '+otk_tel

if lis>=19
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
lis=3
inkey(0)
@ 1, 0 clear to 20, 79
@ 1, 0 to 20, 79 double
endif
lis=lis+1
	  skip
enddo
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)

//close all
clear screen
   setcolor(DEFAULT)
return

procedure prriinntt
set device to print
n=1
  @ prow()+1, 1 say chr(27) + chr(15)
      @ prow()+1, 20 say 'OTKUPNA MESTA'
      @ prow()+1, 5 say replicate('-',75)

do while !eof()
//      @ prow()+1, 5 say substr(sifra_m,2,2)+'      '+naziv_m+' '+otk_m+' '+otk_tel
      @ prow()+1, 5 say str(n,4)+'      '+naziv_m+' '+otk_m+' '+otk_tel

if prow()>59
      @ prow()+1, 5 say replicate('-',75)
eject
endif
n=n+1
	  skip
enddo
      @ prow()+1, 5 say replicate('-',75)
eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
   setcolor(DEFAULT)
return

procedure spisak_sifra
clear screen
setcolor(DEF_GREEN)
MAX=1000
declare kart [ 100 ]
declare rec_no[ 100 ]
declare komint [ MAX ]
declare rec[ MAX ]
last_sif=0
@ 00, 00 say center("Pregled i stampa proizvodjaca")
@ 1, 0 , 21, 79 box background
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
*@ 2, 25 say 'Mesto:'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_no,kom_name
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'OTKUP', .F. )
   set index to otk_sd
else
  clos all
  RETURN   
endif
select 4
if NET_USE ( 'VOCE', .F. )
   set index to v_no
else
  clos all
  RETURN   
endif
select 5
if NET_USE ( 'TMPK5', .T. )
file1='tmpK5'
ind1='tmp5'
set index to tmp5
zap
else
  clos all
  RETURN   
endif

do uz_mesta
    restore screen from screen1
zad = 1


tek = 1

procedure uz_mesta
select MESTA
do fill_kart
current=1
  current = achoice(3,30,19,50,kart,.T.,'',current,current-1)
  do case
     case current != 0 &&last
	 go rec_no[current]
	 otk_sifra=sifra_m
	  do preg_kom with otk_sifra
     case current = 0
   setcolor(DEFAULT)
	  return
  endcase
return


procedure preg_kom
stampa='S'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  " )
@ 23, 0 say centermsg( "Sifra/Prezime/Tekuci/Virman (S/P/T/V)" )
@ 23, 70 get stampa picture '!'
read
if lastkey()=27
return
endif
if stampa='V'
do stampa_virmana
clos all 
return
endif
if stampa='T'
do tekuci
clos all 
return
else
if stampa='S'
select KOM
   set index to kom_name
   else
select KOM
   set index to kom_name
endif
endif


stampa='E'
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if lastkey()=27
return
endif
if stampa='P'
do stmp_kom
close all
return
endif

@ 00, 00 say center( "Pregled polj. proizvodjaca za otkupno mesto:" +" "+rtrim(MESTA->naziv_m))
@ 1, 0 clear to 20, 79
@ 1, 0 to 20, 79 double
lis=3
select KOM
do while !eof()
if substr(sifra_k,1,3)!=otk_sifra 
skip
loop
endif
      @ lis, 4 say sifra_k+'   '+ime_k
      @ lis, 60 say ugo

if lis>=19
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
lis=3
inkey(0)
@ 1, 0 clear to 20, 79
@ 1, 0 to 20, 79 double
endif
lis=lis+1
	  skip
enddo
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)

//close all
clear screen
   setcolor(DEFAULT)
return

procedure stmp_kom
set device to print
setprc(0,0)
u_pov=0
  @ prow()+1, 1 say chr(27) + chr(15)
      @ prow()+1,0 say center('Pregled poljorivrednih proizvodjaca za otkupno mesto')
	  @ prow()+2,0 say center(substr(MESTA->sifra_m,1,3)+' '+ rtrim(MESTA->naziv_m))
      @ prow()+1, 1 say replicate('_',130)
      @ prow()+1, 1 say '³       Prezime i ime                              ³'+'Poreski racun /izjava³'+'Ugovor ³'+'Povrs.   ³'+'Tekuci racun        ³'+'JMBG         ³'+'KAT³'
//      @ prow()+1, 1 say replicate('_',126)
//      @ prow()+1, 1 say '³__________________________________________________³'+'_____________________³'+'_______³'+'_________³'+'____________________³'+'_____________³'
select KOM
strana=0
do while !eof()
if substr(sifra_k,1,3)!=otk_sifra 
skip
loop
endif
      @ prow(), 1 say replicate('_',130)
      @ prow()+1, 1 say '³'+substr(KOM->ime_k,1,50)               +'³'+substr(KOM->mesto_k,1,20)+' ³'+substr(KOM->ugo,1,5)+'  ³'+str(KOM->pov,9,2)+'³'+substr(KOM->tr,1,20)+'³'+substr(KOM->JMBG,1,13)+'³ '+substr(KOM->KAT,1,1)+' ³'
      @ prow(), 1 say replicate('_',130)
//      @ prow()+1, 1 say '³__________________________________________________³'+'_____________________³'+'_______³'+'_________³'+'_______³'+'_______³'+'____________³'
if prow()>=65
strana=strana+1
eject
      @ prow()+1,0 say center('Pregled poljorivrednih proizvodjaca za otkupno mesto')
	  @ prow()+2,0 say center(substr(MESTA->sifra_m,1,3)+' '+ rtrim(MESTA->naziv_m))
      @ prow()+1, 1 say replicate('_',130)
      @ prow()+1, 1 say '³       Prezime i ime                              ³'+'Poreski racun /izjava³'+'Ugovor ³'+'Povrs.   ³'+'Tekuci racun        ³'+'JMBG         ³'
//      @ prow()+1, 1 say replicate('_',126)
//      @ prow()+1, 1 say '³__________________________________________________³'+'_____________________³'+'_______³'+'_________³'+'____________________³'+'_____________³'
endif
u_pov=u_pov+KOM->pov
select KOM
	  skip
enddo
//      @ prow()+1, 1 say '³       UKUPNO:                                    ³'+'                     ³'+'       ³'+str(u_pov,9,2)+'³'+'       ³'+'       ³'+'            ³'
//      @ prow()+1, 1 say '³__________________________________________________³'+'_____________________³'+'_______³'+'_________³'+'_______³'+'_______³'+'____________³'
//      @ prow()+1, 60 say 'Strana: '+str(strana+1,2)
eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
   setcolor(DEFAULT)
return


procedure otk_list
set device to print
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
//w_c=sifra_m+'   '
w_c=sifra_m
endif
select VOCE
   set index to v_no,v_name
seek v_par

@ prow()+1,2 say COMPANY->co_line1+'                    OTKUPNI LIST Br._______'
@ prow()+1,10 say COMPANY->co_line2
@ prow()+2,2 say center('Za period: '+dtoc(datum1)+' do '+dtoc(datum2))
@ prow()+2,10 say MESTA->naziv_m +' - '+MESTA->otk_m
@ prow()+2,0 say replicate ('-',100)
@ prow()+1,1 say 'Red. br'
@ prow(),10 say 'PROIZVOD'
@ prow(),45 say 'JM'
@ prow(),50 say 'Kolicina:'
@ prow(),70 say 'Kvalit.:'
@ prow(),80 say 'Cena:'
@ prow(),88 say 'Vrednost:'
@ prow()+1,0 say replicate ('-',100)
sum=0
sum1=0
sum2=0
sum3=0
drg=0
//select KOM
//set index to kom_name
//go top                            
//seek substr(k_par,1,3)
//do while !eof()   &&.and. substr(sifra_k,1,3)=substr(k_par,1,3)
//if substr(sifra_k,1,3) !=substr(k_par,1,3)
//skip																																	 
//loop
//endif
n=0
select OTKUP
   set index to otk_ss
go top
set softseek on
//	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
	seek w_c+v_par+DTOS(DATUM1)
set softseek off
//do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=v_par .and. datum_otk<=datum2 .and. !eof()
sum=sum+kol_otk
sum1=sum1+raz_otk
sum2=sum2+kol_otkii
sum3=sum3+kol4
skip
enddo
  
if   sum>0.0
n=n+1
@ prow()+1,1 say str(n,1,2)
@ prow(),5 say 'MALINA'
@ prow(),45 say 'kg'
@ prow(),50 say sum picture '@E 999,999.99'
@ prow(),70 say 'Eks.'
@ prow(),80 say VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 999.99'
@ prow(),87 say sum*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
endif

if   sum1>0.0
n=n+1
@ prow()+1,1 say str(n,1,2)
@ prow(),5 say 'MALINA'
@ prow(),45 say 'kg'
@ prow(),50 say sum1 picture '@E 999,999.99'
@ prow(),70 say 'I kl.'
@ prow(),80 say VOCE->druga*1.05 picture '@E 999.99'
@ prow(),87 say sum1*VOCE->druga*1.05 picture '@E 99,999,999.99'
endif

if   sum2>0.0
n=n+1
@ prow()+1,1 say str(n,1,2)
@ prow(),5 say 'MALINA'
@ prow(),45 say 'kg'
@ prow(),50 say sum2 picture '@E 999,999.99'
@ prow(),70 say 'II kl.'
@ prow(),80 say VOCE->treca*(1+VOCE->pdv/100) picture '@E 999.99'
@ prow(),87 say sum2*VOCE->treca*1.05 picture '@E 99,999,999.99'
endif
if   sum3>0.0
n=n+1
@ prow()+1,1 say str(n,1,2)
@ prow(),5 say 'MALINA'
@ prow(),45 say 'kg'
@ prow(),50 say sum3 picture '@E 999,999.99'
@ prow(),70 say 'III kl.'
@ prow(),80 say VOCE->cetvrta*(1+VOCE->pdv/100) picture '@E 999.99'
@ prow(),87 say sum3*VOCE->cetvrta*1.05 picture '@E 99,999,999.99'
endif


ukupno=ukupno+sum
uk_raz=uk_raz+sum1
drg=drg+sum2
third=third+sum3
sum=0
sum1=0
sum2=0
//select KOM
//skip
//enddo

@ prow()+1,0 say replicate ('-',100)
@ prow()+1,70 say 'ZA ISPLATU:'
@ prow(),86 say (ukupno*VOCE->cena_v+uk_raz*VOCE->druga+drg*VOCE->treca+third*VOCE->cetvrta)*(1+VOCE->pdv/100) picture '@E 999,999,999.99'
@ prow()+2, 1 say 'NAPOMENA: Ukljucen PDV 5%'
@ prow()+2,10 say 'OTKUPLJIVAC:_________________________ LK _______________'
@ prow()+2,10 say 'BLAGAJNIK  :_________________________'
select OTKUP
   set index to otk_sd,otk_vd, otk_ss
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
//clos all
return

procedure stmp_jm_jv
set device to print
select otkup
   set index to otk_vd,otk_sd, otk_ss
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ prow()+1,10 say naziv_m +'   -    '
endif
select VOCE
   set index to v_no,v_name
seek v_par
if found()
@ prow(),40 say naziv_v
@ prow()+1,0 say center('Za period od: '+dtoc(datum1)+' do: '+dtoc(datum2)) 
@ prow()+1,0 say replicate ('-',130)
@ prow()+1,5 say 'Proizvodjac:'
@ prow(),55 say 'Prepod.:'
@ prow(),70 say 'I klasa:'
@ prow(),85 say 'II klasa:'
@ prow(),100 say 'III klasa:'
@ prow(),115 say 'Ambalaza:'
@ prow()+1,0 say replicate ('-',130)
endif
sum=0
sum1=0
sum2=0					   
sum3=0
drg=0
amb=0
select KOM
set index to kom_name
go top                            
//seek substr(k_par,1,3)
do while  !eof() &&.and. substr(sifra_k,1,3)=substr(k_par,1,3)
if substr(sifra_k,1,3) !=substr(k_par,1,3)
skip																																	 
loop
endif
select OTKUP
go top
set softseek on
seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
sum=sum+kol_otk
sum1=sum1+raz_otk
sum2=sum2+kol_otkii
sum3=sum3+kol4
skip
enddo
  
if   sum+sum1+sum2>0.0
@ prow()+1,1 say rtrim(KOM->ime_k)
//@ prow(),35 say rtrim(KOM->mesto_k)
@ prow(),55 say sum picture '@E 999,999.99'
@ prow(),70 say sum1 picture '@E 999,999.99'
@ prow(),85 say sum2 picture '@E 999,999.99'
@ prow(),100 say sum3 picture '@E 999,999.99'
//@ prow(),100 say (sum*VOCE->cena_v+sum1*VOCE->druga+sum2*VOCE->treca+sum3*VOCE->cetvrta)*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
endif
amb_z=0
amb_r=0
select AMB
   set index to amb_sds
set softseek on
seek KOM->sifra_k+DTOS(DATUM1)
set softseek off
do while  amb_sif=KOM->sifra_k .and. amb_datum<=datum2 .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
	amb=amb+amb_kol-amb_raz
skip
enddo
if   sum+sum1+sum2>0.0
	@ prow(),113 say str(amb_z,5)+'-'+str(amb_r,5)+'='+str(amb_r-amb_z,5)
endif
if prow()>=65
eject
@ prow()+1,5 say MESTA->naziv_m +'   -    '
@ prow(),40 say VOCE->naziv_v
@ prow()+1,5 say 'Proizvodjac:'
@ prow(),55 say 'Prepod.:'
@ prow(),70 say 'I klasa:'
@ prow(),85 say 'II klasa:'
@ prow(),100 say 'III klasa:'
@ prow(),115 say 'Ambalaza:'
@ prow()+1,0 say replicate ('-',130)
endif

ukupno=ukupno+sum
uk_raz=uk_raz+sum1
drg=drg+sum2
third=third+sum3

sum=0
sum1=0
sum2=0			
sum3=0			
select KOM
skip
enddo

@ prow()+1,0 say replicate ('-',130)
@ prow()+1,10 say 'SVEGA:'
@ prow(),53 say ukupno picture '@E 9,999,999.99'
@ prow(),68 say uk_raz picture '@E 9,999,999.99'
@ prow(),85 say drg picture '@E 999,999.99'
@ prow(),100 say third picture '@E 999,999.99'
@ prow(),113 say str(amb,17)
@ prow()+1,10 say 'UKUPNO:'
@ prow(),53 say ukupno+uk_raz+drg+third picture '@E 9,999,999.99'
@ prow()+1,10 say 'IZNOS:'
@ prow(),100 say (ukupno*VOCE->cena_v+uk_raz*VOCE->druga+drg*VOCE->treca+third*VOCE->cetvrta)*(1+VOCE->pdv/100) picture '@E 9,999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
select OTKUP
   set index to otk_sd,otk_vd, otk_ss
//clos all
return
///////////////////////////////////////////////
procedure oxx
clear screen
@ 00, 00 say center( "Pregled proizvodjaca")  
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_no,kom_name
else
  clos all
  RETURN   
endif
select 3
if NET_USE ( 'TMPK5', .T. )
file1='tmpK5'
ind1='tmp5'
set index to tmp5
zap
else
  clos all
  RETURN   
endif
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ 1000 ] && treba
declare rec[ 1000 ]
set device to print
      @ prow()+1,0 say center('Pregled poljorivrednih proizvodjaca za otkupno mesto')

zad = 1
tek = 1
ox = 1
do red_screen with "Pregled proizvodjaca"
//  restore screen from screen1
current = 1
do izb_mes with ox
	  @ prow()+2,0 say center(rtrim(kart[tekuci]))
      @ prow()+2, 1 say replicate('_',121)
      @ prow()+1, 1 say '³       Prezime i ime                              ³'+'Poreski racun /izjava³'+'Ugovor ³'+'Povrs.   ³'+'Plan.ko³'+'Cena   ³'+'Vredn.      ³'
      @ prow()+1, 1 say '³__________________________________________________³'+'_____________________³'+'_______³'+'_________³'+'_______³'+'_______³'+'____________³'
if ox<100
zad = 1
tek = 1
  endif
do fill_komm with otk_sifra
do while .T.
do red_screen with "Pregled proizvodjaca"
  //restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'000'
	 case tek = 0
set device to screen
	 clos all
	 return
	 otherwise
	 select &file1
	 go rec[tek]
      @ prow()+1, 1 say '³'+substr(&file1->ime_k,1,50)                           +'³'+substr(&file1->mesto_k,1,20)+' ³'+&file1->ugo+'  ³'+str(&file1->pov,9,2)+'³       ³'+'       ³'+'            ³'
      @ prow()+1, 1 say '³__________________________________________________³'+'_____________________³'+'_______³'+'_________³'+'_______³'+'_______³'+'____________³'
  endcase
enddo
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

//////Tekuci
procedure tekuci
@ 1, 0 clear to 20, 79
@ 1, 0 to 20, 79 double
banka=space(3)
  @  10, 12  say "Banka       :" get banka
  read

stampa='E'
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if lastkey()=27
return
endif
if stampa='P'
do stmp_tek
close all
return
endif

@ 00, 00 say center( "Pregled tekucih racuna polj. proizvodjaca za otkupno mesto:" +" "+rtrim(MESTA->naziv_m))
@ 1, 0 clear to 20, 79
@ 1, 0 to 20, 79 double
lis=3
select KOM
   set index to kom_name
do while !eof()
if substr(sifra_k,1,3)!=otk_sifra 
skip
loop
endif
if substr(tr,1,3)!=banka
skip
loop
endif
      @ lis, 4 say sifra_k+' '+substr(ime_k,1,30)+' '+tr

if lis>=19
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
lis=3
inkey(0)
@ 1, 0 clear to 20, 79
@ 1, 0 to 20, 79 double
endif
lis=lis+1
	  skip
enddo
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)

//close all
clear screen
   setcolor(DEFAULT)
return

procedure stmp_tek
set device to print
setprc(0,0)
u_pov=0
  @ prow()+1, 1 say chr(27) + chr(15)
      @ prow()+1,0 say center('Pregled poljorivrednih proizvodjaca za otkupno mesto')
	  @ prow()+2,0 say center(substr(MESTA->sifra_m,2,2)+' '+ rtrim(MESTA->naziv_m))
      @ prow()+2, 1 say replicate('_',121)
      @ prow()+1, 1 say '³       Prezime i ime                                        Tekuci racun                                       ³'+'Iznos.      ³'
      @ prow()+1, 1 say '³__________________________________________________³'+'_________________________________________________________________________³'
*      @ prow()+1, 1 say replicate('_',79)																										   			  
select KOM
strana=0
do while !eof()
if substr(sifra_k,1,3)!=otk_sifra 
skip
loop
endif
if substr(tr,1,3)!=banka
skip
loop
endif
//select OTKUP
//	seek KOM->sifra_k

//if found()
      @ prow()+1, 1 say '³'+substr(KOM->ime_k,1,50)                           +'³'+substr(KOM->tr,1,20)+'                                        ³'+'            ³'
      @ prow()+1, 1 say '³__________________________________________________³'+'_________________________________________________________________________³'
if prow()>=65
strana=strana+1
//      @ prow()+1, 1 say replicate('_',79)
//      @ prow()+1, 60 say 'Strana: '+str(strana,2)
eject
      @ prow()+1,0 say center('Pregled poljorivrednih proizvodjaca za otkupno mesto')
	  @ prow()+2,0 say center(substr(MESTA->sifra_m,2,2)+' '+ rtrim(MESTA->naziv_m))
      @ prow()+1, 1 say '³       Prezime i ime                                        Tekuci racun                                       ³'+'Iznos.      ³'
      @ prow()+1, 1 say '³__________________________________________________³'+'_________________________________________________________________________³'
endif
//endif
u_pov=u_pov+KOM->pov
select KOM
	  skip
enddo
//      @ prow()+1, 1 say '³       UKUPNO:                                    ³'+'                     ³'+'       ³'+str(u_pov,9,2)+'³'+'       ³'+'       ³'+'            ³'
//      @ prow()+1, 1 say '³__________________________________________________³'+'_____________________³'+'_______³'+'_________³'+'_______³'+'_______³'+'____________³'
//*      @ prow()+1, 5 say replicate('_',79)
//      @ prow()+1, 60 say 'Strana: '+str(strana+1,2)
eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
   setcolor(DEFAULT)
return				  


procedure stampa_virmana
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ 1000 ] && treba
declare rec[ 1000 ]
tek=1
zad=1
do fill_komm with otk_sifra
do while .T.
  restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'000'
	 case tek = 0
set device to screen
	 clos all
	 return
	 otherwise
	 select KOM
	 go rec[tek]
	 do print_vir with KOM->ime_k, KOM->tr
  endcase
enddo


procedure print_vir
parameters imme, zirro
a = 0
   SET DEVICE TO PRINTER
   SET PRINTER ON
//parameters datt
PrintCodes(CHR(27) + CHR(67) + CHR(24))
@ 0,a+1 SAY 'EURO FRIGO'
@ 1,a+1 SAY 'POZEGA'
//@ 1,a+43 SAY v_sifra_1
//@ 2,a+1 SAY firma_3
//@ 4,a+50 SAY ziro_str
@ 5,a+1 SAY 'Uplata akontacije'
@ 6,a+1 SAY 'za malinu roda 2004.'
//@ 7,a+1 SAY v_svrha_3
//@ 7,a+43 SAY cpozivz1
//@ 7,a+50 SAY cpozivz2

@ 10,a+1 SAY imme
//@ 10,a+50 SAY ZiRo_upl 
//@ 11,a+1 SAY korist_2
//@ 12,a+1 SAY korist_3
//@ 13,a+43 SAY v_sifra_2
@ 13,a+50 SAY zirro
//@ 15,a+42 SAY dtoc(v_datum)
@ 15,a+15 SAY rtrim('Pozega')  &&+",  "+dtoc(date())
EJECT
PrintCodes(CHR(27) + CHR(64)) 
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd) 
   SET DEVICE TO SCREEN
   SET CONSOLE ON

RETURN   

///////PROMENA CENE
procedure pr_cene
clear screen
@ 00, 00 say center( "Pregled otkupa voca")  
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'VOCE', .F. )
   set index to v_name,v_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'OTKUP', .F. )
   set index to otk_sd,otk_vd, otk_ss
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'AMB', .F. )
   set index to amb_dat
else
  clos all
  RETURN   
endif

select 9
if xNET_USE ( 'TMPK5', .T. )
file1='tmpK5'
ind1='tmp5'
set index to tmp5
zap
else
clos all
return
endif

select 7
if NET_USE ( 'COMPANY',.F. )
else
  clos all
  RETURN   
endif


MAX=1000
declare voce [ MAX ]
declare voce_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]

stampa='M'
@ 21, 0 to 24, 79
@ 23, 0 say centermsg( "Mesto/Proizvodjac (M/P)" )
@ 23, 60 get stampa picture '!'
read
if lastkey()=27
return
endif
if stampa='P'
do prom_cen_cov
close all
return
endif

zad = 1
tek = 1
ox = 1
//do while .T.
do red_screen with "Promena cene"
  //restore screen from screen1
current = 1
do izb_mes with ox
if ox<100
zad = 1
tek = 1
  endif
//do while .T.
la = 1
curr = 1
do izb_v with la
do red_screen with "Promena cene"
//  restore screen from screen1
  curr = achoice(3,20,19,60,voce,.T.,'',curr,curr-1)
  do case
     case curr =la
	 voce_o='xxx'
//	 loop
     case curr !=0       
	 go voce_no[curr]
	 voce_o=sifra_v
	 do prom_cena with otk_sifra,voce_o
     case curr = 0
	  close all
	  clear screen
//	  exit
		  return
  endcase
//enddo
//close all
ox = 1
clear screen
return

procedure prom_cena
parameters w_c,vocex
xcena1=0
xcena2=0
xcena3=0
xcena4=0
select OTKUP
   set index to otk_ss
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
@ 1,1 to 1,79
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
@ 10,10  say 'Cena ekstra/prep :' get xcena1 picture '9999.999'
@ 10,40  say 'Cena I klasa:' get xcena2 picture '9999.999'
@ 12,10  say 'Cena II klasa:' get xcena3 picture '9999.999'
@ 12,40  say 'Cena III klasa:' get xcena4 picture '9999.999'

read
select OTKUP
go top
set softseek on
	seek w_c+VOCEX+DTOS(DATUM1)
set softseek off
 do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCEX .and. datum_otk<=datum2 .and. !eof()
 do req_rec_lock
replace cena1 with xcena1, cena2 with xcena2, cena3 with xcena3, cena4 with xcena4
skip
enddo
	 close all
return
/////////
procedure prom_cen_cov
zad = 1
tek = 1
ox = 1
//do while .T.
do red_screen with "Promena cene"
  //restore screen from screen1
current = 1
do w_mes with ox
if ox<100
zad = 1
tek = 1
  endif
//do while .T.
la = 1
curr = 1
do izb_v with la
do red_screen with "Promena cene"
//restore screen from screen1
  curr = achoice(3,20,19,60,voce,.T.,'',curr,curr-1)
  do case
     case curr =la
	 voce_o='xxx'
//	 loop
     case curr !=0       
	 go voce_no[curr]
	 voce_o=sifra_v
//	 do prom_cena with otk_sifra,voce_o
     case curr = 0
	  close all
	  clear screen
//	  exit
		  return
  endcase
//do izb_kom with otk_sifra
do fill_komm with otk_sifra
do while .T.
do red_screen with "Promena cene"
  //restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'000'
	 case tek = 0
	 clos all
	 return
//	 exit
	 otherwise
//	 select KOM
	 select &file1
	 go rec[tek]
	 komintent=sifra_k
	 do pr_cenn with komintent,voce_o
//	 exit
  endcase
//  endif
enddo

ox = 1
clear screen
return

procedure pr_cenn
parameters w_c, vocex
xcena1=0
xcena2=0
xcena3=0
xcena4=0
select OTKUP
   set index to otk_vd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
@ 1,1 to 1,79
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
@ 10,10  say 'Cena ekstra/prep :' get xcena1 picture '9999.999'
@ 10,40  say 'Cena I klasa:' get xcena2 picture '9999.999'
@ 12,10  say 'Cena II klasa:' get xcena3 picture '9999.999'
@ 12,40  say 'Cena III klasa:' get xcena4 picture '9999.999'

read
select OTKUP
go top
set softseek on
	seek w_c+VOCEX+DTOS(DATUM1)
set softseek off
 do while sifra_otk=komintent .and. sifra_otv=VOCEX .and. datum_otk<=datum2 .and. !eof()
 do req_rec_lock
replace cena1 with xcena1, cena2 with xcena2, cena3 with xcena3, cena4 with xcena4
skip
enddo
	 close all
return
/////////
procedure preg_mes
clear screen
*set color to i
@ 00, 00 say center( "Pregled otkupa voca")  
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'VOCE', .F. )
   set index to v_name,v_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'OTKUP', .F. )
   set index to otk_sd,otk_vd, otk_ss
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'OTKUPM', .F. )
   set index to otm_sd
else
  clos all
  RETURN   
endif

select 8
if NET_USE ( 'AMB', .F. )
   set index to amb_ss,amb_sds
else
  clos all
  RETURN   
endif

select 9
if NET_USE ( 'TMPK1', .T. )
file1='tmpK1'
ind1='tmp1'
set index to tmp1
zap
else
  clos all
  RETURN   
endif

select 7
if NET_USE ( 'COMPANY', .F. )
else
  clos all
  RETURN   
endif
/*
////OVO
select 6
if xNET_USE ( 'TMPK1', .T. )
file1='tmpK1'
ind1='tmp1'
set index to tmp1
zap
//wait 'tmpk1'
else
select 6
if xNET_USE ( 'TMPK2', .T. )
file1='tmpK2'
ind1='tmp2'
set index to tmp2
zap
//wait 'tmpk2'
else
select 6
if xNET_USE ( 'TMPK3', .T. )
file1='tmpK3'
ind1='tmp3'
set index to tmp3
zap
wait 'tmpk3'
else
select 6
if xNET_USE ( 'TMPK4', .T. )
file1='tmpK4'
ind1='tmp4'
set index to tmp4
zap
wait 'tmpk4'
else
select 6
if xNET_USE ( 'TMPK5', .T. )
file1='tmpK5'
ind1='tmp5'
set index to tmp5
zap
wait 'tmpk5'
else
clos all
return
endif

endif

endif

endif

endif

/////DOVDE
*/


MAX=1000
declare voce [ MAX ]
declare voce_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]
zad = 1
tek = 1
ox = 1
//do while .T.
do red_screen with "Pregled otkupa voca"
//  restore screen from screen1
current = 1
//do izb_mes with ox

last=100
select MESTA
do izb_mss   &&with pcx
tekuci=1
  tekuci = achoice(3,30,19,50,kart,.T.,'',tekuci,tekuci-1)
  do case
     case tekuci = last
	 otk_sifra='999999'
	 komintent=otk_sifra
	 do all_mes with komintent
     case tekuci != 0 
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
	 komintent=otk_sifra
	 do stampa_mes with komintent
     ox=tekuci
	 case tekuci = 0
	 otk_sifra='xxx'
	 clos all
	 return
  endcase


clear screen
close all
return


procedure stampa_mes
parameters k_par
select OTKUP
   set index to otk_ss,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
drg=0
raz=0.00
svega1=0
svega2=0
svega3=0
svega4=0
mxx1=0
mxx2=0
mxx3=0
mxx4=0
xx1=0
xx2=0
xx3=0
xx4=0
treca=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
amb=0
@ 1,1 to 1,79
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Mesto-datum (E/P/M)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do st_mes_voc
return
endif
if stampa='M'
do mesto_datum
return
endif

//select MESTA
//   set index to m_no,m_name
//seek substr(k_par,1,3)
//if found()
//w_c=sifra_m			   substr(k_par,1,3)
w_c=substr(k_par,1,3)
@ 2,0 say center(MESTA->naziv_m)
@ 4,25 say 'Prepod. :'
@ 4,39 say 'I klasa:'
@ 4,52 say 'II klasa:'
@ 4,67 say 'III klasa:'
@ 5,0 to 5,79
save screen to scr
select VOCE
go top
do while !eof()
select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
 do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii	 
treca=treca+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
skip
enddo
@ row()+1,1 say Voce->naziv_v
@ row(),20 say 'PR'
@ row(),24 say ukupno picture '@E 999,999.99'
@ row(),37 say raz picture '@E 999,999.99'
@ row(),49 say drg picture '@E 999,999.99'
@ row(),67 say treca picture '@E 999,999.99'
//@ row()+1,0 to row()+1,79
xx1=xx1+ukupno
xx2=xx2+raz
xx3=xx3+drg
xx4=xx4+treca
ukupno=0.00
drg=0
raz=0.00
treca=0
////Ovde otkupm
select OTKUPM
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
 do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
svega1=svega1+kol_otk 
svega2=svega2+raz_otk
svega3=svega3+kol_otkii	 
svega4=svega4+kol4
amb=amb+(ambu-ambv)
skip
enddo
@ row()+1,20 say 'OM'
@ row(),24 say svega1 picture '@E 999,999.99'
@ row(),37 say svega2 picture '@E 999,999.99'
@ row(),49 say svega3 picture '@E 999,999.99'
@ row(),67 say svega4 picture '@E 999,999.99'
@ row()+1,0 to row()+1,79
mxx1=mxx1+svega1
mxx2=mxx2+svega2
mxx3=mxx3+svega3
mxx4=mxx4+svega4
svega1=0
svega2=0
svega3=0
svega4=0
//////dovde otkupm
if row()>=19
inkey(0)
restore screen from scr
@ 5,0 to 5,79
endif
select VOCE
skip
enddo
//endif
ambx=0
  select AMB
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()
	ambx=ambx+amb_kol-amb_raz
skip
enddo

select MESTA
   set index to m_name,m_no
@ row()+1,0 say 'SVEGA:'
@ row(),20 say 'PR'
@ row(),24 say xx1 picture '@E 999,999.99'
@ row(),37 say xx2 picture '@E 999,999.99'
@ row(),49 say xx3 picture '@E 999,999.99'
@ row(),67 say xx4 picture '@E 999,999.99'
@ row()+1,20 say 'OM'
@ row(),24 say mxx1 picture '@E 999,999.99'
@ row(),37 say mxx2 picture '@E 999,999.99'
@ row(),49 say mxx3 picture '@E 999,999.99'
@ row(),67 say mxx4 picture '@E 999,999.99'

@ row()+2,0 say 'Ambalaza            PR'
@ row(),24 say ambx picture '@E 999,999.99'
@ row()+1,20 say 'OM'
@ row(),24 say amb picture '@E 999,999.99'

inkey(0)
return

procedure st_mes_voc
set device to print
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ prow()+1,1 say center('Otkupno mesto: '+naziv_m)
@ prow()+2,25 say 'Prepod. :'
@ prow(),39 say 'I klasa:'
@ prow(),52 say 'II klasa:'
@ prow(),67 say 'III klasa:'
@ prow()+1,0 say replicate ('-',80)
save screen to scr
select VOCE
go top
do while !eof()
//@ row()+1,0 say naziv_v
select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
skip
enddo
if ukupno>0 .or. raz>0 .or. drg>0 .or. treca>0
@ prow()+1,1 say rtrim(Voce->naziv_v)
@ prow(),20 say 'PR'
@ prow(),24 say ukupno picture '@E 999,999.99'
@ prow(),37 say raz picture '@E 999,999.99'
@ prow(),49 say drg picture '@E 999,999.99'
@ prow(),67 say treca picture '@E 999,999.99'
@ prow()+1,0 to row()+1,79
xx1=xx1+ukupno
xx2=xx2+raz
xx3=xx3+drg
xx4=xx4+treca
ukupno=0.00
drg=0
raz=0.00
treca=0
////Ovde otkupm
select OTKUPM
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
 do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
svega1=svega1+kol_otk 
svega2=svega2+raz_otk
svega3=svega3+kol_otkii	 
svega4=svega4+kol4
amb=amb+(ambu-ambv)
skip
enddo
@ prow()+1,20 say 'OM'
@ prow(),24 say svega1 picture '@E 9,999,999.99'
@ prow(),37 say svega2 picture '@E 9,999,999.99'
@ prow(),49 say svega3 picture '@E 9,999,999.99'
@ prow(),67 say svega4 picture '@E 9,999,999.99'
@ prow()+1,0 say replicate ('-',80)
endif
mxx1=mxx1+svega1
mxx2=mxx2+svega2
mxx3=mxx3+svega3
mxx4=mxx4+svega4
svega1=0
svega2=0
svega3=0
svega4=0
//////dovde otkupm
if prow()>=65
eject
endif
select VOCE
skip
enddo
endif
select MESTA
   set index to m_name,m_no
//@ prow()+1,0 say replicate ('-',80)
ambx=0
  select AMB
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()
	ambx=ambx+amb_kol-amb_raz
skip
enddo

@ prow()+1,0 say 'SVEGA:'
@ prow(),20 say 'PR'
@ prow(),24 say xx1 picture '@E 999,999.99'
@ prow(),37 say xx2 picture '@E 999,999.99'
@ prow(),49 say xx3 picture '@E 999,999.99'
@ prow(),67 say xx4 picture '@E 999,999.99'
@ prow()+1,20 say 'OM'
@ prow(),24 say mxx1 picture '@E 999,999.99'
@ prow(),37 say mxx2 picture '@E 999,999.99'
@ prow(),49 say mxx3 picture '@E 999,999.99'
@ prow(),67 say mxx4 picture '@E 999,999.99'
@ prow()+2,0 say 'Ambalaza            PR'
@ prow(),24 say ambx picture '@E 999,999.99'
@ prow()+1,20 say 'OM'
@ prow(),24 say amb picture '@E 999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

procedure mesto_datum
parameters w_c
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do st_mesto_datum
clos all
return
endif
@ 2,0 say center(MESTA->naziv_m)
@ 4,1 say 'Datum:'
@ 4,12 say 'Prepod. :'
@ 4,23 say 'I klasa:'
@ 4,34 say 'II klasa:'
@ 4,45 say 'III klasa:'
@ 4,56 say 'Dokum.:'
@ 4,67 say 'Am.uz.  Am.vr.:'
@ 5,0 to 5,79
save screen to scr
////Ovde otkupm
select OTKUPM
set index to otm_dd
go top
set softseek on
	seek MESTA->sifra_m+DTOS(DATUM1)
set softseek off
 do while sifra_otk=MESTA->sifra_m .and. datum_otk<=datum2 .and. !eof()
@ row()+1,1 say datum_otk
@ row(),12 say kol_otk picture '@E 999,999.99'
@ row(),23 say raz_otk picture '@E 999,999.99'
@ row(),34 say kol_otkii picture '@E 999,999.99'
@ row(),45 say kol4 picture '@E 999,999.99'
@ row(),58 say doc_otk
@ row(),70 say ambu picture '@E 9999'
@ row(),75 say ambv picture '@E 9999'

svega1=svega1+kol_otk 
svega2=svega2+raz_otk
svega3=svega3+kol_otkii	 
svega4=svega4+kol4
amb=amb+(ambu-ambv)
skip
enddo
//////dovde otkupm
if row()>=19
inkey(0)
restore screen from scr
@ 5,0 to 5,79
endif
//endif

@ row()+1,0 to row()+1,79
@ row()+1,0 say 'SVEGA:'
@ row(),12 say svega1 picture '@E 999,999.99'
@ row(),23 say svega2 picture '@E 999,999.99'
@ row(),34 say svega3 picture '@E 999,999.99'
@ row(),45 say svega4 picture '@E 999,999.99'
@ row(),67 say amb picture '@E 999,999'

inkey(0)
clos all
return

procedure st_mesto_datum
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,0 say center(MESTA->naziv_m)
@ prow()+1,1 say 'Datum :'
@ prow(),12 say 'Prepod. :'
@ prow(),23 say 'I klasa:'
@ prow(),34 say 'II klasa:'
@ prow(),45 say 'III klasa:'
@ prow(),56 say 'Vozilo:'
@ prow(),67 say 'Am.uz. Am.vr.'
//@ prow(),67 say 'Ambalaza:'
@ prow(),80 say 'Dokument:'
@ prow()+1,0 say replicate ('-',90)
////Ovde otkupm
select OTKUPM
set index to otm_dd
go top
set softseek on
	seek MESTA->sifra_m+DTOS(DATUM1)
set softseek off
 do while sifra_otk=MESTA->sifra_m .and. datum_otk<=datum2 .and. !eof()
@ prow()+1,1 say datum_otk
@ prow(),12 say kol_otk picture '@E 999,999.99'
@ prow(),23 say raz_otk picture '@E 999,999.99'
@ prow(),34 say kol_otkii picture '@E 999,999.99'
@ prow(),45 say kol4 picture '@E 999,999.99'
@ prow(),56 say Vozilo
@ prow(),70 say ambu picture '@E 9999'
@ prow(),75 say ambv picture '@E 9999'
@ prow(),81 say doc_otk

svega1=svega1+kol_otk 
svega2=svega2+raz_otk
svega3=svega3+kol_otkii	 
svega4=svega4+kol4
amb=amb+(ambu-ambv)
skip
enddo
//////dovde otkupm
if prow()>=65
eject
endif

@ prow()+1,0 say replicate ('-',90)
@ prow()+1,0 say 'SVEGA:'
@ prow(),12 say svega1 picture '@E 999,999.99'
@ prow(),23 say svega2 picture '@E 999,999.99'
@ prow(),34 say svega3 picture '@E 999,999.99'
@ prow(),45 say svega4 picture '@E 999,999.99'
@ prow(),67 say amb picture '@E 999,999'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
clos all
return


//////ALL MESTA
procedure all_mes
parameters k_par
select OTKUP
   set index to otk_ss,otk_sd
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
drg=0
raz=0.00
svega1=0
svega2=0
svega3=0
svega4=0
mxx1=0
mxx2=0
mxx3=0
mxx4=0
xx1=0
xx2=0
xx3=0
xx4=0
treca=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
amb=0
@ 1,1 to 1,79
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Ambalaza/Otkupn mesta (E/P/A/O)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do st_all_mes
return
endif
if stampa='O'
do st_otk_mes
return
endif
if stampa='A'
do amb_all_mes
return
endif
@ 2,0 say center('Za sva mesta')
@ 4,25 say 'Prepod. :'
@ 4,39 say 'I klasa:'
@ 4,52 say 'II klasa:'
@ 4,67 say 'III klasa:'
@ 5,0 to 5,79
save screen to scr
select MESTA
   set index to m_no,m_name
   do while !eof()
w_c=substr(sifra_m,1,3)

select VOCE
go top
do while !eof()
select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
 do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii	 
treca=treca+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
skip
enddo
if ukupno>0 .or. raz>0 .or. drg>0 .or. treca>0
@ row()+1,1 say Voce->naziv_v
@ row(),20 say 'PR'
@ row(),24 say ukupno picture '@E 999,999.99'
@ row(),37 say raz picture '@E 999,999.99'
@ row(),49 say drg picture '@E 999,999.99'
@ row(),67 say treca picture '@E 999,999.99'
//@ row()+1,0 to row()+1,79
xx1=xx1+ukupno
xx2=xx2+raz
xx3=xx3+drg
xx4=xx4+treca
endif
ukupno=0.00
drg=0
raz=0.00
treca=0
////Ovde otkupm
select OTKUPM
go top
set softseek on
seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
svega1=svega1+kol_otk 
svega2=svega2+raz_otk
svega3=svega3+kol_otkii	 
svega4=svega4+kol4
amb=amb+(ambu-ambv)
skip
enddo
if svega1>0 .or. svega2>0 .or. svega3>0 .or. svega4>0
@ row()+1,20 say 'OM'
@ row(),24 say svega1 picture '@E 999,999.99'
@ row(),37 say svega2 picture '@E 999,999.99'
@ row(),49 say svega3 picture '@E 999,999.99'
@ row(),67 say svega4 picture '@E 999,999.99'
@ row()+1,0 to row()+1,79
mxx1=mxx1+svega1
mxx2=mxx2+svega2
mxx3=mxx3+svega3
mxx4=mxx4+svega4
endif
svega1=0
svega2=0
svega3=0
svega4=0
//////dovde otkupm
if row()>=19
inkey(0)
restore screen from scr
@ 5,0 to 5,79
endif
select VOCE
skip
enddo
//endif
ambx=0
  select AMB
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()
	ambx=ambx+amb_kol-amb_raz
skip
enddo
select MESTA
skip
enddo

select MESTA
   set index to m_name,m_no
@ row()+1,0 say 'SVEGA:'
@ row(),20 say 'PR'
@ row(),24 say xx1 picture '@E 999,999.99'
@ row(),37 say xx2 picture '@E 999,999.99'
@ row(),49 say xx3 picture '@E 999,999.99'
@ row(),67 say xx4 picture '@E 999,999.99'
@ row()+1,20 say 'OM'
@ row(),24 say mxx1 picture '@E 999,999.99'
@ row(),37 say mxx2 picture '@E 999,999.99'
@ row(),49 say mxx3 picture '@E 999,999.99'
@ row(),67 say mxx4 picture '@E 999,999.99'

@ row()+2,0 say 'Ambalaza            PR'
@ row(),24 say ambx picture '@E 999,999.99'
@ row()+1,20 say 'OM'
@ row(),24 say amb picture '@E 999,999.99'

inkey(0)
return


procedure st_all_mes
set printer to stampa.prn
set device to print
//w_c=substr(sifra_m,1,3)
@ prow()+1,10 say 'Sva otkupna mesta za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,25 say 'Prepod. :'
@ prow(),39 say 'I klasa:'
@ prow(),52 say 'II klasa:'
@ prow(),67 say 'III klasa:'
@ prow()+1,0 say replicate ('-',80)
save screen to scr
select MESTA
   set index to m_no,m_name
   do while !eof()
w_c=substr(sifra_m,1,3)
select VOCE
go top
do while !eof()
select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
//set index to otm_ssd
 do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii	 
treca=treca+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
skip
enddo
if ukupno>0 .or. raz>0 .or. drg>0 .or. treca>0
@ prow()+1,0 say center(MESTA->Naziv_m)
//@ prow()+1,0 to 1,79
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say Voce->naziv_v
@ prow(),21 say 'PR'
@ prow(),24 say ukupno picture '@E 999,999.99'
@ prow(),37 say raz picture '@E 999,999.99'
@ prow(),50 say drg picture '@E 999,999.99'
@ prow(),63 say treca picture '@E 999,999.99'
@ prow()+2,0 say ' '
xx1=xx1+ukupno
xx2=xx2+raz
xx3=xx3+drg
xx4=xx4+treca
endif
ukupno=0.00
drg=0
raz=0.00
treca=0
////Ovde otkupm
select OTKUPM
//set index to otm_ssd
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
 //do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
svega1=svega1+kol_otk 
svega2=svega2+raz_otk
svega3=svega3+kol_otkii	 
svega4=svega4+kol4
amb=amb+(ambu-ambv)
skip
enddo
if svega1>0 .or. svega2>0 .or. svega3>0 .or. svega4>0
@ prow()+1,0 say center(MESTA->Naziv_m)
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say Voce->naziv_v
@ prow(),21 say 'OM'
@ prow(),24 say svega1 picture '@E 999,999.99'
@ prow(),37 say svega2 picture '@E 999,999.99'
@ prow(),50 say svega3 picture '@E 999,999.99'
@ prow(),63 say svega4 picture '@E 999,999.99'
//@ prow(),70 say ambu picture '@E 9999'
//@ prow(),75 say ambv picture '@E 9999'
//@ prow()+1,0 say replicate ('-',80)
@ prow()+2,0 say ' '
mxx1=mxx1+svega1
mxx2=mxx2+svega2
mxx3=mxx3+svega3
mxx4=mxx4+svega4								   
endif
svega1=0
svega2=0
svega3=0
svega4=0
//////dovde otkupm
//if prow()>=19
//inkey(0)
//restore screen from scr
//@ 5,0 to 5,79
//endif
select VOCE
skip
enddo
//endif
ambx=0
  select AMB
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()
	ambx=ambx+amb_kol-amb_raz
skip
enddo
select MESTA
skip
enddo

select MESTA
   set index to m_name,m_no
@ prow()+1,0 say 'SVEGA:'
@ prow(),20 say 'PR'
@ prow(),24 say xx1 picture '@E 9,999,999.99'
@ prow(),37 say xx2 picture '@E 9,999,999.99'
@ prow(),50 say xx3 picture '@E 9,999,999.99'
@ prow(),63 say xx4 picture '@E 9,999,999.99'
@ prow()+1,20 say 'OM'
@ prow(),24 say mxx1 picture '@E 9,999,999.99'
@ prow(),37 say mxx2 picture '@E 9,999,999.99'
@ prow(),50 say mxx3 picture '@E 9,999,999.99'
@ prow(),63 say mxx4 picture '@E 9,999,999.99'
@ prow()+2,0 say 'Ukupno:'
@ prow(),24 say xx1+xx2+xx3+xx4+mxx1+mxx2+mxx3+mxx4 picture '@E 9,999,999.99'
/*
@ prow()+2,0 say 'Ambalaza:           PR'
@ prow(),24 say ambx picture '@E 999,999.99'
@ prow()+1,20 say 'OM'
@ prow(),24 say amb picture '@E 999,999.99'
*/
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

///STAMPA OTKUPNIH MESTA
procedure st_otk_mes
set printer to stampa.prn
set device to print
//w_c=substr(sifra_m,1,3)
@ prow()+1,10 say 'Sva otkupna mesta za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,25 say 'Prepod. :'
@ prow(),39 say 'I klasa:'
@ prow(),52 say 'II klasa:'
@ prow(),67 say 'III klasa:'
@ prow()+1,0 say replicate ('-',80)
save screen to scr
select MESTA
   set index to m_no,m_name
   do while !eof()
w_c=substr(sifra_m,1,3)
select VOCE
go top
do while !eof()
/*
select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
//set index to otm_ssd
 do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii	 
treca=treca+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
skip
enddo
if ukupno>0 .or. raz>0 .or. drg>0 .or. treca>0
@ prow()+1,0 say center(MESTA->Naziv_m)
//@ prow()+1,0 to 1,79
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say Voce->naziv_v
@ prow(),21 say 'PR'
@ prow(),24 say ukupno picture '@E 999,999.99'
@ prow(),37 say raz picture '@E 999,999.99'
@ prow(),50 say drg picture '@E 999,999.99'
@ prow(),63 say treca picture '@E 999,999.99'
@ prow()+2,0 say ' '
xx1=xx1+ukupno
xx2=xx2+raz
xx3=xx3+drg
xx4=xx4+treca
endif
ukupno=0.00
drg=0
raz=0.00
treca=0
*/
////Ovde otkupm
select OTKUPM
//set index to otm_ssd
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
 //do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
svega1=svega1+kol_otk 
svega2=svega2+raz_otk
svega3=svega3+kol_otkii	 
svega4=svega4+kol4
amb=amb+(ambu-ambv)
skip
enddo
if svega1>0 .or. svega2>0 .or. svega3>0 .or. svega4>0
@ prow()+1,0 say center(MESTA->Naziv_m)
@ prow()+1,0 say replicate ('-',80)
@ prow()+1,1 say Voce->naziv_v
@ prow(),21 say 'OM'
@ prow(),24 say svega1 picture '@E 999,999.99'
@ prow(),37 say svega2 picture '@E 999,999.99'
@ prow(),50 say svega3 picture '@E 999,999.99'
@ prow(),63 say svega4 picture '@E 999,999.99'
//@ prow(),70 say ambu picture '@E 9999'
//@ prow(),75 say ambv picture '@E 9999'
//@ prow()+1,0 say replicate ('-',80)
@ prow()+2,0 say ' '
mxx1=mxx1+svega1
mxx2=mxx2+svega2
mxx3=mxx3+svega3
mxx4=mxx4+svega4								   
endif
svega1=0
svega2=0
svega3=0
svega4=0
//////dovde otkupm
//if prow()>=19
//inkey(0)
//restore screen from scr
//@ 5,0 to 5,79
//endif
select VOCE
skip
enddo
//endif
ambx=0
  select AMB
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()
	ambx=ambx+amb_kol-amb_raz
skip
enddo
select MESTA
skip
enddo

select MESTA
   set index to m_name,m_no
@ prow()+1,0 say 'SVEGA:'
/*
@ prow(),20 say 'PR'
@ prow(),24 say xx1 picture '@E 9,999,999.99'
@ prow(),37 say xx2 picture '@E 9,999,999.99'
@ prow(),50 say xx3 picture '@E 9,999,999.99'
@ prow(),63 say xx4 picture '@E 9,999,999.99'
*/
@ prow(),20 say 'OM'
@ prow(),24 say mxx1 picture '@E 9,999,999.99'
@ prow(),37 say mxx2 picture '@E 9,999,999.99'
@ prow(),50 say mxx3 picture '@E 9,999,999.99'
@ prow(),63 say mxx4 picture '@E 9,999,999.99'
@ prow()+2,0 say 'Ukupno:'
@ prow(),24 say xx1+xx2+xx3+xx4+mxx1+mxx2+mxx3+mxx4 picture '@E 9,999,999.99'
/*
@ prow()+2,0 say 'Ambalaza:           PR'
@ prow(),24 say ambx picture '@E 999,999.99'
@ prow()+1,20 say 'OM'
@ prow(),24 say amb picture '@E 999,999.99'
*/
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return
/////DOVDE OTKUPNA MESTA



procedure amb_all_mes
amb1=0
amb2=0
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_amb_mes
return
endif
samb1=0
samb2=0
@ 2,0 say center('Za sva mesta')
@ 4,25 say 'Ulaz. :'
@ 4,52 say 'Izlaz:'
@ 5,0 to 5,79
save screen to scr
////Ovde otkupm
select MESTA
   set index to m_no,m_name
   do while !eof()
select OTKUPM
   set index to otm_dd
go top
set softseek on
	seek MESTA->sifra_m+DTOS(DATUM1)
set softseek off				
 do while sifra_otk=MESTA->sifra_m .and. datum_otk<=datum2 .and. !eof()
amb1=amb1+ambu
amb2=amb2+ambv
skip
enddo
@ row()+1,0 say MESTA->naziv_m
@ row(),24 say amb2 picture '@E 999,999,999'
@ row(),49 say amb1 picture '@E 999,999,999'
samb1=samb1+amb1
samb2=samb2+amb2
amb1=0			 
amb2=0
//////dovde otkupm
if row()>=19
inkey(0)
restore screen from scr
@ 5,0 to 5,79
endif
select MESTA
skip
enddo

@ row()+1,0 say 'SVEGA:'
@ row(),24 say samb2 picture '@E 999,999,999'
@ row(),49 say samb1 picture '@E 999,999,999'

inkey(0)
return

procedure prt_amb_mes
samb1=0
samb2=0
set device to print
@ 2,0 say center('Ambalaza za sva mesta')
@ 4,25 say 'Ulaz. :'
@ 4,52 say 'Izlaz:'
@ prow()+1,0 say replicate ('-',80)
select MESTA
   set index to m_no,m_name
   do while !eof()
select OTKUPM
   set index to otm_dd
go top
set softseek on
	seek MESTA->sifra_m+DTOS(DATUM1)
set softseek off				
 do while sifra_otk=MESTA->sifra_m .and. datum_otk<=datum2 .and. !eof()
amb1=amb1+ambu
amb2=amb2+ambv
skip
enddo
@ prow()+1,0 say MESTA->naziv_m
@ prow(),24 say amb2 picture '@E 999,999,999'
@ prow(),49 say amb1 picture '@E 999,999,999'
samb1=samb1+amb1
samb2=samb2+amb2
amb1=0
amb2=0
//////dovde otkupm
if prow()>=60
eject
@ 2,0 say center('Ambalaza za sva mesta')
@ 4,25 say 'Ulaz. :'
@ 4,52 say 'Izlaz:'
@ 5,0 to 5,79
endif
select MESTA
skip
enddo

@ prow()+2,0 say 'SVEGA:'
@ prow(),24 say samb2 picture '@E 999,999,999'
@ prow(),49 say samb1 picture '@E 999,999,999'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen

return
********************************
 procedure all_mesta_datum
store date() to datum1,datum2
clear screen
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa u toku..." )
	select OTKUP
   set index to otk_ss

set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,1 say 'Izvestaj o otkupu od '+' '+dtoc(datum1)+' do '+dtoc(datum2)+' '+'ZA SVA MESTA '
@ prow()+1,0 say replicate ('-',100)
@ prow()+1,1 say 'Datum:'
@ prow(),20 say 'Prepod.:'
@ prow(),40 say 'I Klasa:'
@ prow(),55 say 'II Klasa:'
@ prow(),70 say 'III Klasa:'
@ prow(),85 say 'Svega:'
@ prow()+1,0 say replicate ('-',100)
store 0 to a1,a2,a3,a4
ukupno=0.00
ukupno1=0.00
svega=0.00
uk_raz=0.0
third=0
datx=datum2-datum1
for y=0 to datx
xdat=datum1+y
select MESTA
go top
do while !eof()
w_c=sifra_m		
select VOCE
	go top
do while !eof()
	select OTKUP
	seek w_c+VOCE->SIFRA_V+DTOS(xdat)
	if found()
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=xdat .and. !eof()
ukupno=ukupno+kol_otk
uk_raz=uk_raz+raz_otk
ukupno1=ukupno1+kol_otkii
third=third+kol4
select OTKUP
	skip
enddo
endif
select VOCE
	skip
enddo
select MESTA
	skip
enddo
if ukupno>0 .or. uk_raz>0 .or. ukupno1>0 .or. third>0
		@ prow()+1,1 say substr(dtoc(xdat),1,5)
		@ prow(),20 say ukupno picture '@E 999,999.99'
		@ prow(),40 say uk_raz picture '@E 999,999.99'
		@ prow(),55 say ukupno1 picture '@E 999,999.99'
		@ prow(),70 say third picture '@E 999,999.99'
		@ prow(),85 say ukupno+uk_raz+ukupno1+third picture '@E 999,999.99'
		a1=a1+ukupno
		a2=a2+uk_raz
		a3=a3+ukupno1
		a4=a4+third
ukupno=0.00
ukupno1=0.00
uk_raz=0.0
third=0
endif

if prow()>=60
eject
endif
next

@ prow()+1,0 say replicate ('-',100)
@ prow()+1,0 say 'SVEGA:'
@ prow(),20 say a1 picture '@E 999,999.99'
@ prow(),40 say a2 picture '@E 999,999.99'
@ prow(),55 say a3 picture '@E 999,999.99'
@ prow(),70 say a4 picture '@E 999,999.99'
@ prow()+1,0 say 'UKUPNO:'
@ prow(),40 say a1+a2+a3+a4 picture '@E 999,999.99'

@ prow()+1,0 say ' '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return			    

procedure e_roba
clear screen
setcolor(DEF_YELLOW)
MAX_DOCUMENTS=500
declare roba [ MAX_DOCUMENTS ]
declare roba1 [ MAX_DOCUMENTS ]
declare roba_no[ MAX_DOCUMENTS ]
last_sif=0

@ 00, 00 say center( "Unos robe")
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 1, 40 say 'Cena       Cena sa PDV'
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
declare M_SIFR[ 2 ]
M_SIFR[ 1 ] = 'Roba sa PDV    '
//M_SIFR[ 2 ] = 'Roba sa porezom'
M_SIFR[ 2 ] = 'Dinarski avans '
//M_SIFR[ 4 ] = 'Ostalo 1       '
//M_SIFR[ 5 ] = 'Ostalo 2       '
declare M_SIFREC[ 5 ]
M_SIFREC[ 1 ] = 1
M_SIFREC[ 2 ] = 2
M_SIFREC[ 3 ] = 3
M_SIFREC[ 4 ] = 4
M_SIFREC[ 5 ] = 5
select 1
if NET_USE ( 'ROBA', .F. )
   set index to r_name,r_no
else
  clos all
  RETURN   
endif

  restore screen from screen1
	 m_PR_IME = space( 20 )
	 m_PR_OTK = 0
last = 1
current = 1
do fill_roba
do while .T.
do red_screen with "Unos robe"
//  restore screen from screen1
  current = achoice(3,20,19,60,roba,.T.,'',current,current-1)
  do case
     case current = last
          do new_roba
     case current = 0
          close all
          clear screen
   setcolor(DEFAULT)
          return
     otherwise       
          do edit_roba
  endcase
enddo
close all
clear screen
   setcolor(DEFAULT)
return


procedure fill_roba
parameters desc  
new_dt_call = pcount() != 0
select ROBA
go top
last = 1
do while !eof()
   roba [ last ] = naziv_r+str(cena_r,10,2)+' '+str(cena_r*(1+pdv/100),10,2)
    roba_no [ last ] = recno()
   if new_dt_call 
   if naziv_r = m_PR_IME
         current = last
   endif
   endif
   last = last + 1
   skip
enddo

roba [ last ] = '*** Unos podataka ****'
for i = last + 1 to MAX_DOCUMENTS
    roba [ i ] = ''
next
return


procedure new_roba
	 m_PR_OTK = 0
	 m_PR_ODN = 0
	 m_PR_ODNM = 0
clear screen
*set color to i
@ 00, 00 say center( "Unos robe")
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
save screen to ekran
select ROBA
   set index to r_no,r_name
do while  !eof()
last_sif=val(sifra_r)
skip
enddo

set index to r_name,r_no
		 if empty(last_sif)
		 last_sif=99
		 endif
         m_SIFRA=ltrim(str(last_sif+1))
		 m_PR_IME = space( 20 )
		 w_pdv=0
		 w_jm=space(3)
  @  10, 12  say "Roba               :" get m_PR_IME picture '@!'
  @  12, 12  say "Cena               :" get m_PR_OTK picture '999999999.99999'
  @  14, 12  say "Stopa PDV          :" get w_pdv picture '99'
  @  16, 12  say "Jedinica mere      :" get w_jm
//  @  14, 12  say "Odnos Roba->malina :" get m_PR_ODN picture '99999.999'
//  @  16, 12  say "Odnos Malina->roba :" get m_PR_ODNM picture '99999.999'
  read
                       @ 9, 58, 12, 74 box shade
                       @ 8, 57 to 11, 73
                       choice = achoice( 9, 58, 11, 72, M_SIFR )
                       do case
                          case choice = 1
                               zr=1
                          case choice = 2
                               zr=3
//                          case choice = 3
//                               zr=3
//                          case choice = 4
//                               zr=4
//                          case choice = 5
//                               zr=5
					   endcase

   indx= ASCAN(roba, m_PR_IME)
   if indx != 0   && find !!!!
   ? chr(7)
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'Roba sa istim imenom postoji ! ESC-> Izlaz' )
inkey(0)
endif
if lastkey()=27
return
endif
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
if ok = 'D' .and. !empty( m_PR_IME )
   if last >= MAX_DOCUMENTS
      ?? chr(7)
      @ 22, 0 say centermsg( 'Maximum ' + str( MAX_DOCUMENTS-1,3,0) + ' pacijenata dozvoljeno!' )
      @ 23, 0 say centermsg( 'Pritisnite bilo koju tipku za nastavak' )
      inkey(0)
      return
   endif
   indx= ASCAN(roba, m_PR_IME)

   if indx = 0   && no match
      @ 22, 0 say centermsg( 'Dodavanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
      do new_rec
        replace SIFRA_r with m_SIFRA,naziv_r with m_PR_IME,;
		cena_r with m_PR_OTK,odn with m_PR_ODN, odn_mal with m_PR_ODNM, status with zr, pdv with w_pdv, jm with w_jm
	  do fill_roba with m_pr_ime	
   else
      current = indx
      do edit_roba
   endif
endif
return


procedure edit_roba
clear screen
*set color to i
@ 00, 00 say center( "Izmena podataka o robi" )
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
go  roba_no[ current ]
         m_PR_IME = naziv_r
         tmp_doc = m_PR_IME
         m_PR_OTK = cena_r
         m_PR_ODN = odn
         m_PR_ODNM = odn_mal
         m_ZAN = status
		 w_pdv=pdv
		 w_jm=jm
  @  10, 12  say "Roba               :" get m_PR_IME picture '@!'
  @  12, 12  say "Cena               :" get m_PR_OTK picture '999999999.99999'
  @  14, 12  say "Stopa PDV          :" get w_pdv picture '99'
  @  16, 12  say "Jedinica mere      :" get w_jm
//  @  14, 12  say "Odnos Roba->malina :" get m_PR_ODN picture '99999.999'
//  @  16, 12  say "Odnos Malina->roba :" get m_PR_ODNM picture '99999.999'
  read
   choice= ASCAN(m_sifrec, m_ZAN)
                       @ 9, 58, 12, 74 box shade
                       @ 8, 57 to 11, 73
  choice = achoice(9,58,13,72,m_sifr,.T.,'',choice,choice-1)
*                       choice = achoice( 9, 58, 11, 72, M_SIFR )
                       do case
                          case choice = 1
                               zr=1
                          case choice = 2
                               zr=3
//                          case choice = 3
//                               zr=3
//                          case choice = 4
//                               zr=4
//                          case choice = 5
//                               zr=5
					   endcase
if lastkey()=27
return
endif
save screen to ekran1
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
*if ok = 'N'
*  do ispr_doc
*endif
if ok = 'D'
   do req_rec_lock	
        replace naziv_r with m_PR_IME,;
		cena_r with m_PR_OTK,odn with m_PR_ODN, odn_mal with m_PR_ODNM, status with zr, pdv with w_pdv, jm with w_jm
      do fill_roba with m_PR_IME
   if tmp_doc !=naziv_r
      do fill_roba with m_PR_IME
   else
      roba [ current ] = naziv_r
   endif
else
   @ 22, 0 say centermsg( 'Da li ste sigurni da zelite' )
   @ 23, 0 say centermsg( 'da obrisete gornje podatke? (D/N)' )
   sure = 'N'
   @ 23, 65 get sure picture '!'
     read
   if sure = 'D'
      @ 22, 0 say centermsg( 'Brisanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
      delete
      do fill_roba
   endif
endif
return

*pregled zaduzenja

procedure preg_zad
clear screen
*set color to i
@ 00, 00 say center( "Pregled zaduzenja robe")  
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1

select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'ROBA', .F. )
   set index to r_name,r_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'ZADUZ', .F. )
   set index to zad_rd,zad_sd,zad_ds
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'VOCE', .F. )
   set index to v_no
else
  clos all
  RETURN   
endif

select 6
if NET_USE ( 'OTKUP', .F. )
   set index to otk_sd,otk_vd
else
  clos all
  RETURN   
endif
////ovo///
select 7
if NET_USE ( 'TMPK3', .T. )
file1='tmpk3'
ind1='tmp3'
zap
else
  clos all
  RETURN   
endif
//ovo

MAX=1000
declare ROBA [ MAX ]
declare ROBA_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]
ox = 1
do while .T.
do red_screen with "Pregled zaduzenja robe"
//  restore screen from screen1
current = 1
do w_mes with ox
if ox<100
zad = 1
tek = 1
//do w_kom with otk_sifra
do fill_komm with otk_sifra
  do red_screen with "Pregled zaduzenja robe"
  //restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'000'
*	 exit
	 case tek = 0
	 exit
	 otherwise
	 select &FILE1
	 go rec[tek]
	 komintent=sifra_k
  endcase
  endif
la = 1
curr = 1
do w_r with la
do red_screen with "Pregled zaduzenja robe"
 //restore screen from screen1
  curr = achoice(3,20,19,60,ROBA,.T.,'',curr,curr-1)
  do case
     case curr =la
	 ROBA_o='xxx'
	 do pregled_zad with komintent,ROBA_o
	 loop
     case curr !=0	 
	 go ROBA_no[curr]
	 ROBA_o=sifra_r
	 do pregled_zad with komintent,ROBA_o
*	 loop
     exit
     case curr = 0
          close all
          clear screen
          exit
		  return
  endcase
enddo
close all
ox = 1
clear screen
return

procedure w_r
parameters desc  
select ROBA
go top
la = 1
do while !eof()
   ROBA [ la ] = naziv_r
    ROBA_no [ la ] = recno()
   la = la + 1
   skip
enddo

ROBA [ la ] = '*** Za svu robu ****'
for i = la + 1 to MAX
    ROBA [ i ] = ''
next
return




procedure w_mes
parameters pcx
last=100
select MESTA
do w_mss with pcx
tekuci=pcx
*  restore screen from screen1
  tekuci = achoice(3,30,19,50,kart,.T.,'',tekuci,tekuci-1)
  do case
     case tekuci = last
*	 go rec_no[tekuci]
	 otk_sifra='999999'
	 komintent=otk_sifra
     ox=101
     case tekuci != 0 
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
     ox=tekuci
	 case tekuci = 0
	 return
  endcase
return

procedure w_mss
parameters desc  
select mesta
go top
last = 1
do while !eof()
   kart [ last ] = naziv_m
   rec_no [ last ] = recno()
   if last=desc
         tekuci = last
   endif
   last = last + 1
   skip
enddo

kart [ last ] = '*** Za sva mesta ****'
for i = last + 1 to 100
    kart [ i ] = ''
next
return

procedure w_kom
parameters desc  
select KOM
go top
zad = 1
do while !eof()
	if substr(sifra_k,1,3)!=otk_sifra
	skip
	loop
	endif
   komm [ zad ] = ime_k+' '+mesto_k
   rec [ zad ] = recno()
   zad = zad + 1
   skip
enddo

komm [ zad ] = '*** Za otkupno mesto ****'
for i = zad + 1 to MAX
    komm [ i ] = ''
next
return

procedure pregled_zad
parameters k_par,v_par
 if subst(k_par,4,6)='000' .and. v_par='xxx' && jedno mesto svo ROBA
 do jed_m_sva_r
	return
 endif
 if subst(k_par,4,6)='999' .and. v_par='xxx' && sva mesta svo ROBA
 do sva_m_sva_r
 return
 endif

 if subst(k_par,4,6)='999' .and. v_par!='xxx' && sva mesta jedna ROBA
 do sva_m_jedd_r  with v_par
 return
 endif

 if subst(k_par,4,6)!='000' .and. v_par='xxx' && jedan kom sva ROBA
do jed_k_jed_roba
	return
 endif
  if subst(k_par,4,6)!='000' .and. v_par!='xxx' && jedan kom JEDNA ROBA
do jed_kom_roba
	return
 endif
 if subst(k_par,4,6)='000' .and. v_par!='xxx' && jedno mesto jedno ROBA
do jed_mes_jed_roba
	return
 endif
  return

procedure jed_kom_roba
//wait 'Jedan kom jedna roba'
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
suma=0.00
ukupno=0.00
svega=0.00
robni=0.00
robni1=0.00
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do stmp_jkom_jr
*clos all
return
endif
save screen to scr
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
select KOM
set index to kom_no,kom_name
seek k_par
if found()
w_c=sifra_k
@ 2,0 say center(ime_k)
@ 3,0 to 3,79
@ 4,35 say 'Kolicina:'
@ 4,50 say 'Vrednost:'
@ 4,62 say 'Zad. maline (kg):'
@ row()+1,0 say replicate('-',79)
select ROBA
   set index to r_no,r_name
   seek v_par
   //do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
suma=suma+kol_zad*cena
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
if !empty(ukupno)
@ row()+1,0 say ROBA->naziv_r
@ row(),35 say ukupno picture '@E 9,999,999.99'
@ row(),50 say suma*(1+ROBA->pdv/100) picture '@E 9,999,999.99'
@ row(),65 say robni1 picture '@E 9,999,999.99'
endif
svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00
if row()>=19
inkey(0)
@ 1,1 to 1,79
@ 2,0 clear to 19,79
endif
//select ROBA
//skip
//enddo
endif
select KOM
   set index to kom_name,kom_no
select ROBA
   set index to r_name,r_no
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),50 say svega picture '@E 9,999,999.99'
@ row(),65 say robni picture '@E 9,999,999.99'
*@ 19,01 say 'ROBNO ZAD.MALINE (kg) :'
*@ 20,01 say 'ZADUZENJE MALINE (kg) :'
*@ 20,65 say svega/VOCE->cena_v picture '@E 9,999,999.99'
inkey(0)
return

procedure stmp_jkom_jr
set device to print
suma=0.00
ukupno=0.00
svega=0.00
robni=0.00
robni1=0.00
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
select KOM
set index to kom_no,kom_name
seek k_par
if found()
w_c=sifra_k
@ prow()+1,0 say '      Pregled za period '+dtoc(datum1)+'-'+dtoc(datum2)
@ prow()+2,0 say center(ime_k)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Vrednost:'
//@ 4,62 say 'Zad. maline (kg):'
@ prow()+1,0 say replicate('-',79)
select ROBA
   set index to r_no,r_name
   seek v_par
   //do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
suma=suma+kol_zad*cena
ukupno=ukupno+kol_zad
skip
enddo
if !empty(ukupno)
@ prow()+1,0 say ROBA->naziv_r
@ prow(),35 say ukupno picture '@E 9,999,999.99'
@ prow(),50 say suma*ROBA->cena_r*(1+ROBA->pdv/100) picture '@E 9,999,999.99'
//@ prow(),65 say robni1 picture '@E 9,999,999.99'
endif
svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00
endif
select KOM
   set index to kom_name,kom_no
select ROBA
   set index to r_name,r_no
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA:'
@ prow(),50 say svega picture '@E 9,999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

procedure jed_mes_jed_roba
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
suma=0.00
ukupno=0.00
svega=0.00
robni=0.00
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_jm_jr
return
endif
save screen to scr
select ZADUZ
   set index to zad_rd,zad_sd
   set order to 2
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ 2,0 say center(naziv_m)
@ 3,0 to 3,79
@ 4,35 say 'Kolicina:'
@ 4,50 say 'Vrednost:'
@ 4,62 say 'Zad. maline (kg):'
@ row()+1,0 say replicate('-',79)
select ROBA
   set index to r_no,r_name
seek v_par
@ row()+1,0 say naziv_r
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while substr(sifra_zad,1,3)=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*cena
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni=robni+kol_zad/ROBA->odn
//endif

skip
enddo

if !empty(ukupno)
@ row(),35 say ukupno picture '@E 9,999,999.99'
@ row(),50 say suma*(1+ROBA->pdv/100) picture '@E 9,999,999.99'
@ row(),65 say robni picture '@E 9,999,999.99'
endif

svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
endif
select MESTA
   set index to m_name,m_no
select ROBA
   set index to r_name,r_no
@ row()+1,0 say replicate('-',79)
*@ row()+1,0 say 'SVEGA:'
*@ row(),65 say svega picture '@E 9,999,999.99'
inkey(0)
return

* jedan komintent - sva ROBA

procedure jed_k_jed_roba
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
suma=0.00
ukupno=0.00
svega=0.00
robni=0.00
robni1=0.00
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_jkom_jr
*clos all
return
endif
save screen to scr
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
select KOM
set index to kom_no,kom_name
seek k_par
if found()
w_c=sifra_k
@ 2,0 say center(ime_k)
@ 3,0 to 3,79
@ 4,35 say 'Kolicina:'
@ 4,50 say 'Vrednost:'
@ 4,62 say 'Zad. maline (kg):'
@ row()+1,0 say replicate('-',79)
select ROBA
   set index to r_no,r_name
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
if !empty(ukupno)
@ row()+1,0 say ROBA->naziv_r
@ row(),35 say ukupno picture '@E 9,999,999.99'
@ row(),50 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ row(),65 say robni1 picture '@E 9,999,999.99'
endif
svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00
if row()>=19
inkey(0)
@ 1,1 to 1,79
@ 2,0 clear to 19,79
endif
select ROBA
skip
enddo
endif
select KOM
   set index to kom_name,kom_no
select ROBA
   set index to r_name,r_no
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),50 say svega picture '@E 99,999,999.99'
@ row(),64 say robni picture '@E 999,999,999.99'
*@ 19,01 say 'ROBNO ZAD.MALINE (kg) :'
*@ 20,01 say 'ZADUZENJE MALINE (kg) :'
*@ 20,65 say svega/VOCE->cena_v picture '@E 9,999,999.99'
inkey(0)
return

* jedno mesto - sva ROBA

procedure jed_m_sva_r
select ZADUZ
   set index to zad_rd,zad_sd
   set order to 2
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
suma=0.00
ukupno=0.00
svega=0.00
robni=0.00
robni1=0.00
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read

stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_jm_sr
*clos all
return
endif
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Zbirno/Po proizvodjacima (Z/P)" )
@ 23, 70 get stampa picture '!'
read
if stampa='P'
do proiz_ekran
return
endif
save screen to scr
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ 2,0 say center(naziv_m)
@ 3,0 to 3,79
@ 4,35 say 'Kolicina:'
@ 4,50 say 'Vrednost:'
@ 4,62 say 'Zad. maline (kg):'
@ row()+1,0 say replicate('-',79)
select ROBA
go top
do while !eof()
select ZADUZ
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while substr(sifra_zad,1,3)=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
if !empty(ukupno)
@ row()+1,0 say ROBA->naziv_r
@ row(),35 say ukupno picture '@E 9,999,999.99'
@ row(),50 say suma*(1+ROBA->pdv/100) picture '@E 9,999,999.99'
@ row(),65 say robni1 picture '@E 9,999,999.99'
endif
svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00
if row()>=19
inkey(0)
@ 1,1 to 1,79
@ 2,0 clear to 19,79
endif
select ROBA
skip
enddo
endif
select MESTA
   set index to m_name,m_no
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),50 say svega picture '@E 9,999,999.99'
@ row(),65 say robni picture '@E 9,999,999.99'
inkey(0)
return
*******************************************
procedure proiz_ekran
clear screen
select ZADUZ
   set index to zad_rd,zad_sd
select MESTA
   set index to m_no,m_name
   go rec_no[tekuci]
@ 0,10 say 'Pregled zaduzenja za period '+dtoc(datum1)+ ' - '+dtoc(datum2)+'  za '+naziv_m

@ 1,1 to 1,79
seek substr(k_par,1,3)
if found()
@ row()+1,35 say 'Kolicina:'
@ row(),50 say 'Vrednost:'
@ row(),62 say 'Zad. maline (kg):'
endif
select KOM
go top
do while !eof()
w_c=sifra_k
if substr(sifra_k,1,3)!=substr(k_par,1,3)
skip
loop
endif
@ row()+1,0 to  1,79 && say replicate('-',79)
@ row()+1,1 say KOM->IME_K
select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
if !empty(ukupno)
@ row()+1,2 say ROBA->naziv_r
@ row(),35 say ukupno picture '@E 9,999,999.99'
@ row(),50 say suma*(1+ROBA->pdv/100) picture '@E 9,999,999.99'
@ row(),65 say robni1 picture '@E 9,999,999.99'
endif
svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00

if row()>=19
inkey(0)
@ 3,1 to 3,79
@ 4,0 clear to 24,79
endif

select ROBA
skip
enddo
*@ row()+1,0 say replicate('-',79)
*@ row()+1,0 say ' '

select KOm
skip
enddo
// sad endif
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),50 say svega picture '@E 9,999,999.99'
@ row(),65 say robni picture '@E 9,999,999.99'
inkey(0)
*@ 19,01 say 'ROBNO ZAD.MALINE (kg) :'
*@ 19,65 say robni picture '@E 9,999,999.99'
*@ 20,01 say 'ZADUZENJE MALINE (kg) :'
*@ 20,65 say svega/VOCE->cena_v picture '@E 9,999,999.99'
@ prow()+3,0 say '       '
select MESTA
   set index to m_name,m_no
set device to screen
return
**********************************

*sva mesta svo ROBA
procedure sva_m_sva_r
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
   set order to 2
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
suma=0.00
ukupno=0.00
svega=0.00
robni=0.00
robni1=0.00	 
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
stampa='Z'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Zbirno/Po mestima (Z/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='Z'
do prt_sm_sr
else
do prt_sm_pojed
endif
*clos all
return
endif
save screen to scr
@ 2,0 say center('Robno zaduzenje za sva mesta - sva roba')
@ 3,0 to 3,79
@ 4,25 say 'Kolicina:'
@ 4,50 say 'Osnovica:'
@ 4,62 say 'PDV :'
@ row()+1,0 say replicate('-',79)
select ROBA
go top
do while !eof()
*set color to i
*@ row()+1,0 say naziv_r
*set color to 
select MESTA
go top
do while !eof()
w_c=sifra_m
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad

//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif

skip
enddo
select MESTA
skip
enddo
if !empty(ukupno)
@ row()+1,0 say ROBA->naziv_r
@ row(),20 say ukupno picture '@E 99,999,999.99'
@ row(),47 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ row(),65 say ROBA->pdv picture '99'
//@ row(),70 say ukupno*ROBA->cena_r*(ROBA->pdv/100) picture '@E 99,999,999.99'
//@ row(),85 say ukupno*ROBA->cena_r*(1+ROBA->pdv/100) picture '@E 99,999,999.99'

endif
svega=svega+suma*(1+ROBA->pdv/100)

suma=0.00
ukupno=0.00
robni1=0.00
if row()>=19
inkey(0)
@ 1,1 to 1,79
@ 2,0 clear to 19,79
endif
*@ 2,1 clear to 19,79
select ROBA
skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),47 say svega picture '@E 999,999,999.99'
@ row(),65 say robni picture '@E 9,999,999.99'
*@ 19,01 say 'ROBNO ZAD.MALINE (kg) :'
*@ 19,65 say robni picture '@E 9,999,999.99'
*@ 20,01 say 'ZADUZENJE MALINE (kg) :'
*@ 20,65 say svega/VOCE->cena_v picture '@E 9,999,999.99'
inkey(0)
return
*************************************************
**STAMPANI IZVESTAJI
**************************************************
procedure prt_jm_jr

set printer to stampa.prn
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
select ZADUZ
   set index to zad_rd,zad_sd
   set order to 2
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ prow()+1,10 say 'Pregled zaduzenja robom za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',100)
@ prow()+1,20 say 'Za otkupno mesto: '+naziv_m
@ prow()+1,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)

select ROBA
   set index to r_no,r_name
seek v_par
@ prow()+1,0 say naziv_r
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while substr(sifra_zad,1,3)=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni=robni+kol_zad/ROBA->odn
//endif

skip
enddo

if !empty(ukupno)
@ prow()+1,0 say ROBA->naziv_r
@ prow(),35 say ukupno picture '@E 9,999,999.99'
@ prow(),47 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),65 say ROBA->pdv picture '99'
@ prow(),70 say suma*(ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),85 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
endif

svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
endif
select MESTA
   set index to m_name,m_no
select ROBA
   set index to r_name,r_no
@ prow()+1,0 say replicate('-',100)
@ prow()+3,0 say '   '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

*****************************
procedure prt_jm_sr
select ZADUZ
   set index to zad_rd,zad_sd
   set order to 2
stampa='Z'
@ 22, 0 to 24, 79
//@ 23, 0 say centermsg( "Zbirno/Po proizvodjacima/Sa malinom (Z/P/S)" )
@ 23, 0 say centermsg( "Zbirno/Po proizvodjacima (Z/P)" )
@ 23, 70 get stampa picture '!'
read
if stampa='P'
do prrrr
return
endif
//if stampa='S'
//do st_covek
//return
//endif
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
w_c=sifra_m
if found()
@ prow()+1,10 say 'Pregled zaduzenja robom za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',100)
@ prow()+1,20 say 'Za otkupno mesto: '+substr(MESTA->sifra_m,2,2)+' '+naziv_m
@ prow()+1,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while substr(sifra_zad,1,3)=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
if !empty(ukupno)
@ prow()+1,0 say ROBA->naziv_r
@ prow(),35 say ukupno picture '@E 9,999,999.99'
@ prow(),47 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),65 say ROBA->pdv picture '99'
@ prow(),70 say suma*(ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),85 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
endif

svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00
if prow()>=65
eject
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
endif

select ROBA
skip
enddo
endif
select MESTA
   set index to m_name,m_no
@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SVEGA:'
@ prow(),85 say svega picture '@E 9,999,999.99'
//@ prow(),65 say robni picture '@E 9,999,999.99'
*@ 19,01 say 'ROBNO ZAD.MALINE (kg) :'
*@ 19,65 say robni picture '@E 9,999,999.99'
*@ 20,01 say 'ZADUZENJE MALINE (kg) :'
*@ 20,65 say svega/VOCE->cena_v picture '@E 9,999,999.99'
@ prow()+3,0 say '       '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

procedure prrrr
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
select ZADUZ
   set index to zad_rd,zad_sd
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
@ prow()+1,10 say 'Pregled zaduzenja robom za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',100)
@ prow()+1,20 say 'Za otkupno mesto: '+naziv_m
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
endif
select KOM
go top
do while !eof()
if substr(sifra_k,1,3)!=substr(k_par,1,3)
skip
loop
endif
w_c=sifra_k
@ prow()+1,1 say KOM->IME_K
@ prow()+1,0 say replicate('-',100)
select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
if !empty(ukupno)
@ prow()+1,0 say ROBA->naziv_r
@ prow(),35 say ukupno picture '@E 9,999,999.99'
@ prow(),47 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),65 say ROBA->pdv picture '99'
@ prow(),70 say suma*(ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),85 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
endif
svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00
if prow()>=65
eject
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
endif

select ROBA
skip
enddo
@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say ' '

select KOm
skip
enddo
//s endif
@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SVEGA:'
@ prow(),85 say svega picture '@E 9,999,999.99'
//@ prow(),65 say robni picture '@E 9,999,999.99'
*@ 19,01 say 'ROBNO ZAD.MALINE (kg) :'
*@ 19,65 say robni picture '@E 9,999,999.99'
*@ 20,01 say 'ZADUZENJE MALINE (kg) :'
*@ 20,65 say svega/VOCE->cena_v picture '@E 9,999,999.99'
@ prow()+3,0 say '       '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return
*******************************

procedure prt_sm_sr
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
   set order to 2
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,10 say 'Pregled zaduzenja robom za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',100)
@ prow()+1,30 say 'Za sva otkupna mesta'
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)

select ROBA
go top
do while !eof()

select MESTA
go top
do while !eof()
w_c=sifra_m
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad

if empty(ROBA->odn)
robni1=robni1+kol_zad*ROBA->odn_mal
robni=robni+kol_zad*ROBA->odn_mal
else
robni1=robni1+kol_zad/ROBA->odn
robni=robni+kol_zad/ROBA->odn
endif

skip
enddo
select MESTA
skip
enddo

if !empty(ukupno)
@ prow()+1,0 say ROBA->naziv_r
@ prow(),35 say ukupno picture '@E 9,999,999.99'
@ prow(),47 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),65 say ROBA->pdv picture '99'
@ prow(),70 say suma*(ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),85 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
endif

svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00

if prow()>=65
eject
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
endif

select ROBA
skip
enddo

@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SVEGA:'
@ prow(),85 say svega picture '@E 999,999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return
**********************************
procedure prt_sm_pojed
private usvega,urobni
store 0 to usvega,urobni
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
   set order to 2
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,10 say 'Pregled zaduzenja robom za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',100)
@ prow()+1,30 say 'Za sva otkupna mesta'
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)

select MESTA
go top
do while !eof()
w_c=sifra_m
@ prow()+1,0 say naziv_m
@ prow()+1,0 say replicate('-',79)

select ROBA
go top
do while !eof()

select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad

//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
		   *******************************
skip
enddo
if !empty(ukupno)
@ prow()+1,0 say ROBA->naziv_r
@ prow(),35 say ukupno picture '@E 9,999,999.99'
@ prow(),47 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),65 say ROBA->pdv picture '99'
@ prow(),70 say suma*(ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),85 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
endif

svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00
select ROBA
skip
enddo


if prow()>=65
eject
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
endif

@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SVEGA:'
@ prow(),85 say svega picture '@E 99,999,999.99'
@ prow()+2,0 say'  '
usvega=usvega+svega
urobni=urobni+robni
svega=0
robni=0
select MESTA
skip
enddo

@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'UKUPNO:'
@ prow(),47 say usvega picture '@E 99,999,999.99'
@ prow(),65 say urobni picture '@E 9,999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return
**********************************

procedure prt_jkom_jr
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
select MESTA
go rec_no[tekuci]
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
select KOM
set index to kom_no,kom_name
seek k_par
if found()
w_c=sifra_k
*set color to i
@ prow()+1,10 say 'Pregled zaduzenja robom za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',100)
@ prow()+1,5 say substr(MESTA->sifra_m,2,2)+' '+rtrim(MESTA->naziv_m)+'-'+substr(sifra_k,2,5)+' '+ime_k
*@ prow()+1,20 say +ime_k
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
select ROBA
   set index to r_no,r_name
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo

if !empty(ukupno)
@ prow()+1,0 say ROBA->naziv_r
@ prow(),35 say ukupno picture '@E 9,999,999.99'
@ prow(),47 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),65 say ROBA->pdv picture '99'
@ prow(),70 say suma*(ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),85 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
endif

svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00

if prow()>=65
eject
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
endif

select ROBA
skip
enddo
endif
select KOM
   set index to kom_name,kom_no
select ROBA
   set index to r_name,r_no
@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SVEGA:'
@ prow(),85 say svega picture '@E 9,999,999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

*****************************************
**SVA MESTA JEDNA ROBA
*************************************
*sva mesta svo ROBA
procedure sva_m_jedd_r
parameters jr
select ZADUZ
   set index to zad_sd,zad_ds
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
suma=0.00
ukupno=0.00
svega=0.00
robni=0.00
robni1=0.00	 
robni2=0.00	 
@ 1,1 to 1,79
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
*set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_sm_jedd_r
*clos all
return
endif
save screen to scr
@ 2,0 say center('Robno zaduzenje za sva mesta - jedna roba')
@ 3,0 to 3,79
@ 4,35 say 'Kolicina:'
@ 4,50 say 'Vrednost:'
@ 4,62 say 'Zad. maline (kg):'
@ row()+1,0 say replicate('-',79)
select ROBA
   set index to r_no
seek jr
select MESTA
go top
do while !eof()
w_c=sifra_m
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while substr(sifra_zad,1,3)=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni2=robni2+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni2=robni2+kol_zad/ROBA->odn
//endif

//robni1=robni1+kol_zad*ROBA->cena_r
robni=robni+kol_zad

skip
enddo

if !empty(ukupno)
@ row()+1,1 say MESTA->NAZIV_M
@ row(),35 say ukupno picture '@E 99,999,999.99'
@ row(),50 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
//@ row(),65 say robni1 picture '@E 99,999,999.99'
endif
svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00
if row()>=19
inkey(0)
@ 1,1 to 1,79
@ 2,0 clear to 19,79
endif

select MESTA
skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),35 say robni picture '@E 999,999,999.99'
@ row(),84 say svega picture '@E 999,999,999.99'
//@ row(),65 say robni2 picture '@E 99,999,999.99'
inkey(0)
return
****************************************
*STAMPA S MESTA JEDNO VOCE
****************************************
procedure prt_sm_jedd_r
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)

@ prow()+1,0 say center('Robno zaduzenje za sva mesta - jedna roba')
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
select ROBA
   set index to r_no
seek jr
@ prow()+1,0 say center(naziv_r)
@ prow()+1,0 say replicate('-',100)

select MESTA
go top
do while !eof()
w_c=sifra_m
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while substr(sifra_zad,1,3)=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni2=robni2+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni2=robni2+kol_zad/ROBA->odn
//endif

//robni1=robni1+kol_zad*ROBA->cena_r
//robni=robni+kol_zad*ROBA->cena_r

skip
enddo

if !empty(ukupno)
@ prow()+1,1 say MESTA->NAZIV_M
@ prow(),35 say ukupno picture '@E 9,999,999.99'
@ prow(),47 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),65 say ROBA->pdv picture '99'
@ prow(),70 say suma*(ROBA->pdv/100) picture '@E 99,999,999.99'
@ prow(),85 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
endif

svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
robni1=0.00		  
if prow()>=65
eject
@ prow()+2,0 say replicate('-',100)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Osnovica:'
@ prow(),62 say 'Stopa :'
@ prow(),72 say 'PDV:'
@ prow(),85 say 'Iznos :'
@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say center(ROBA->naziv_r)
@ prow()+1,0 say replicate('-',100)
endif

select MESTA
skip
enddo
@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SVEGA:'
@ prow(),85 say svega picture '@E 999,999,999.99'
//@ prow(),50 say robni picture '@E 99,999,999.99'
//@ prow(),65 say robni2 picture '@E 99,999,999.99'
@ prow()+2,0 say ' '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

procedure to_del
clear screen
setcolor(DEF_YELLOW)
MAX_DOCUMENTS=100
declare roba [ MAX_DOCUMENTS ]
declare roba1 [ MAX_DOCUMENTS ]
declare roba_no[ MAX_DOCUMENTS ]
last_sif=0
*set color to i
@ 00, 00 say center( "Skrivanje mesta")
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
*@ 2, 25 say 'Mesto:'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1

select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

 okx = 'S'
   @ 22, 0 say centermsg( 'Skrivanje ili povracaj' )
   @ 23, 0 say centermsg( ' (S/P)' )
   @ 23, 65 get okx picture '!'
     read

if okx='P'
do povrat
return
endif

  restore screen from screen1
	 m_PR_IME = space( 20 )
	 m_PR_OTK = 0
last = 1
current = 1
do fill_ottk
do while .T.
do red_screen with "Skrivanje mesta"
  //restore screen from screen1
  current = achoice(3,20,19,60,roba,.T.,'',current,current-1)
  do case
     case current = last
//          do new_roba
     case current = 0
          close all
		  exit
     otherwise       
          do edit_del
  endcase
enddo
close all
clear screen
   setcolor(DEFAULT)
return

procedure fill_ottk
select mesta
go top
last = 1
do while !eof()
   roba [ last ] = naziv_m+' '+otk_m+'  '+otk_tel
   roba_no [ last ] = recno()
   last = last + 1
   skip
enddo

roba [ last ] = '*** Unos podataka ****'
for i = last + 1 to MAX_DOCUMENTS
    roba [ i ] = ''
next
return

procedure edit_del
clear screen
*set color to i
@ 00, 00 say center( "Skidanje mesta sa liste" )
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
go  roba_no[ current ]
	 m_PR_IME = naziv_m
	 m_PR_OTK = otk_m
	 m_PR_TEL = otk_tel
	tmp_doc = m_PR_IME
  @  12, 12  say "Mesto :" get m_PR_IME picture '@!'
  read
if lastkey()=27
return
endif
save screen to ekran1
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da ostane ?' )
@ 23, 0 say centermsg( ' (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
if ok != 'D'
   @ 22, 0 say centermsg( 'Da li ste sigurni da zelite' )
   @ 23, 0 say centermsg( 'da obrisete gornje podatke? (D/N)' )
   sure = 'N'
   @ 23, 65 get sure picture '!'
     read
   if sure = 'D'
      @ 22, 0 say centermsg( 'Brisanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
	  do req_rec_lock
      delete
      do fill_ottk
   endif
endif
return

procedure povrat
set deleted off
current=1
last=1
do fill_erased
do while .T.
do red_screen with "Povrat mesta na listu"
  //restore screen from screen1
  current = achoice(3,20,19,60,roba,.T.,'',current,current-1)
  do case
     case current = last
     case current = 0
          clear screen
   setcolor(DEFAULT)
   exit
     otherwise       
          do edit_pov
  endcase
enddo
set deleted on
clear screen
   setcolor(DEFAULT)
return

procedure edit_pov
clear screen
*set color to i
@ 00, 00 say center( "Povrat mesta" )
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'ESC - Izlaz' )
@ 1, 0 , 21, 79 box background
go  roba_no[ current ]
	 m_PR_IME = naziv_m
	 m_PR_OTK = otk_m
	 m_PR_TEL = otk_tel
	tmp_doc = m_PR_IME
  @  12, 12  say "Mesto :" get m_PR_IME picture '@!'
  read
if lastkey()=27
return
endif
save screen to ekran1
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da vratim ?' )
@ 23, 0 say centermsg( ' (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
if ok = 'D'
      @ 22, 0 say centermsg( 'Brisanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
	  do req_rec_lock
      recall
   endif
do fill_erased
return

procedure fill_erased
select MESTA
go top
last = 1
do while !eof()
if deleted()
   roba [ last ] = naziv_m
    roba_no [ last ] = recno()
   last = last + 1
endif
   skip
enddo

roba [ last ] = '*** Kraj podataka ****'
for i = last + 1 to MAX_DOCUMENTS
    roba [ i ] = ''
next
return

procedure e_voce
clear screen
setcolor(DEF_RED)
MAX=1000
declare voce [ MAX ]
*declare voce1 [ MAX ]
declare voce_no[ MAX ]
last_sif=0

@ 00, 00 say center( "Unos voca")
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 65
@ 1, 30 say 'Prepodnevna         I klasa        II klasa'
@ 2, 4 to 20, 80 double
*@ 2, 25 say 'Mesto:'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'VOCE', .F. )
   set index to v_name,v_no
else
  clos all
  RETURN   
endif

  //restore screen from screen1
	 m_PR_IME = space( 20 )
	 m_PR_OTK = 0
last = 1
current = 1
do fill_voce
do while .T.

do voce_screen with "Unos voca"
  //restore screen from screen1
  current = achoice(3,5,19,78,voce,.T.,'',current,current-1)
  do case
     case current = last
          do new_voce
     case current = 0
          close all
          clear screen
   setcolor(DEFAULT)
          return
     otherwise       
          do edit_voce
  endcase
enddo
close all
clear screen
return


procedure fill_voce
parameters desc  
new_dt_call = pcount() != 0
select VOCE
go top
last = 1
do while !eof()
   voce [ last ] = naziv_v+'   '+str(cena_v,6,2)+'  '+str(cena_v*(1+pdv/100),6,2)+'    '+str(druga,6,2)+'  '+str(druga*(1+pdv/100),6,2)+'   '+str(treca,6,2)+'  '+str(treca*(1+pdv/100),6,2)
    voce_no [ last ] = recno()
   if new_dt_call 
   if naziv_v = m_PR_IME
         current = last
   endif
   endif
   last = last + 1
   skip
enddo

voce [ last ] = '*** Unos podataka ****'
for i = last + 1 to MAX
    voce [ i ] = ''
next
return


procedure new_voce
	 m_PR_OTK = 0
	 w_druga=0
	 w_treca=0
	 w_pdv=0
	 w_cet=0
clear screen
do red_screen with "Unos voca"
//@ 00, 00 say center( "Unos voca")

//@ 22, 0 to 24, 79
//@ 23, 0 say centermsg( 'ESC - Izlaz' )
//@ 1, 0 , 21, 79 box background
save screen to ekran
select VOCE
   set index to v_no,v_name
do while  !eof()
last_sif=val(sifra_v)
skip
enddo

set index to v_name,v_no
		 if empty(last_sif)
		 last_sif=99
		 endif
         m_SIFRA=ltrim(str(last_sif+1))
		 m_PR_IME = space( 20 )
  @  6, 20  say "Voce   :" get m_PR_IME picture '@!'
  @  8, 20  say "Cena ekstra  :" get m_PR_OTK picture '9999.999'
  @  10, 20  say "Cena I klasa :" get w_druga picture '9999.999'
  @  12, 20  say "Cena II klasa:" get w_treca picture '9999.999'
  @  14, 20  say "Cena III klasa:" get w_cet picture '9999.999'
  @  16, 20  say "PDV:" get w_pdv picture '9999.99'
  read
   indx= ASCAN(voce, m_PR_IME)
   if indx != 0   && find !!!!
   ? chr(7)
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( 'Voce sa istim imenom postoji ! ESC-> Izlaz' )
inkey(0)
endif
if lastkey()=27
return
endif
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
if ok = 'D' .and. !empty( m_PR_IME )
   if last >= MAX
      ?? chr(7)
      @ 22, 0 say centermsg( 'Maximum ' + str( MAX-1,3,0) + ' pacijenata dozvoljeno!' )
      @ 23, 0 say centermsg( 'Pritisnite bilo koju tipku za nastavak' )
      inkey(0)
      return
   endif
   indx= ASCAN(voce, m_PR_IME)

   if indx = 0   && no match
      @ 22, 0 say centermsg( 'Dodavanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
      do new_rec
        replace SIFRA_v with m_SIFRA,naziv_v with m_PR_IME,cena_v with m_PR_OTK, druga with w_druga, treca with w_treca, pdv with w_pdv, cetvrta with w_cet
	  do fill_voce with m_pr_ime	
   else
      current = indx
      do edit_voce
   endif
endif
return


procedure edit_voce
clear screen
*set color to i
do red_screen with "Izmena podataka o vocu"
//@ 00, 00 say center( "Izmena podataka o vocu" )
*set color to
//@ 22, 0 to 24, 79
//@ 23, 0 say centermsg( 'ESC - Izlaz' )
//@ 1, 0 , 21, 79 box background
go  voce_no[ current ]
         m_PR_IME = naziv_v
         tmp_doc = m_PR_IME
         m_PR_OTK = cena_v
		 w_druga=druga
		 w_treca=treca
		 w_pdv=pdv
		 w_cet=cetvrta
  @  6, 20  say "Voce   :" get m_PR_IME picture '@!'
  @  8, 20  say "Cena ekstra  :" get m_PR_OTK picture '9999.999'
  @  10, 20  say "Cena I klasa :" get w_druga picture '9999.999'
  @  12, 20  say "Cena II klasa:" get w_treca picture '9999.999'
  @  14, 20  say "Cena III klasa:" get w_cet picture '9999.999'
  @  16, 20  say "PDV:" get w_pdv picture '9999.99'
  read
if lastkey()=27
return
endif
save screen to ekran1
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( 'Da li su gornji podaci' )
@ 23, 0 say centermsg( 'korektni? (D/N)' )
ok = 'D'
@ 23, 60 get ok picture '!'
  read
*if ok = 'N'
*  do ispr_doc
*endif
if ok = 'D'
   do req_rec_lock	
        replace naziv_v with m_PR_IME,cena_v with m_PR_OTK, druga with w_druga, treca with w_treca, pdv with w_pdv, cetvrta with w_cet
      do fill_voce with m_PR_IME
   if tmp_doc !=naziv_v
      do fill_voce with m_PR_IME
   else
      voce [ current ] = naziv_v
   endif
else
   @ 22, 0 say centermsg( 'Da li ste sigurni da zelite' )
   @ 23, 0 say centermsg( 'da obrisete gornje podatke? (D/N)' )
   sure = 'N'
   @ 23, 65 get sure picture '!'
     read
   if sure = 'D'
      @ 22, 0 say centermsg( 'Brisanje u toku,' )
      @ 23, 0 say centermsg( 'momenat...' )
      delete
      do fill_voce
   endif
endif
return

procedure otkup
clear screen
*set color to i
@ 00, 00 say center( "Unos otkupa")
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'VOCE', .F. )
   set index to v_name,v_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'OTKUP', .F. )
   set index to otk_sd,otk_vd, otk_ss
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'AMB', .F. )
   set index to amb_sds,amb_dat,amb_ss
else
  clos all
  RETURN   
endif

select 6
if NET_USE ( 'TMPK', .T. )
file1='tmpk'
ind1='tmp0'
set index to tmp0
else
  clos all
  RETURN   
endif		  

select 7
if NET_USE ( 'COMPANY', .F. )
else
  clos all
  RETURN   
endif		  

select 8
if NET_USE ( 'OTKUPM', .F. )
   set index to otm_sd
else
  clos all
  RETURN   
endif


MAX=1000
declare voce [ MAX ]
declare voce_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]

ox = 1
do while .T.
do red_screen with "Unos otkupa"
 // restore screen from screen1
current = 1
do u_mes with ox
zad = 1
tek = 1
do fill_komm with otk_sifra
do while .T. && NOVO
  //restore screen from screen1
  do red_screen with "Unos otkupa"
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
*	 go rec[tek]
	 komintent=otk_sifra+'000'
	 case tek = 0
	 clos all
	 return
*	 exit
	 otherwise
*     case tek !=0 
//     select KOM
//     select TMPK
     select &file1
	 go rec[tek]
	 komintent=sifra_k
  endcase
la = 1
curr = 1
do fill_v with la
do red_screen with "Unos otkupa"
  //restore screen from screen1
  curr = achoice(3,20,19,60,voce,.T.,'',curr,curr-1)
  do case
     case curr !=0
	 go voce_no[curr]
	 voce_o=sifra_v
	 do otkk with komintent,voce_o
	 loop
     case curr = 0
          close all
          clear screen
          return
*     otherwise       
*          do 
  endcase
enddo
enddo
close all
ox = 1
clear screen
return

procedure fill_v
parameters desc  
select VOCE
go top
la = 1
do while !eof()
   voce [ la ] = naziv_v
    voce_no [ la ] = recno()
   la = la + 1
   skip
enddo

voce [ la ] = '*** Kraj podataka ****'
for i = la + 1 to MAX
    voce [ i ] = ''
next
return


procedure otkk
parameters komi,voc
MAX=1000
declare roba [ MAX ]
declare roba_no[ MAX ]
clear screen
  //restore screen from screen1
  do red_screen with "Unos otkupa"
@ 2, 8 clear to 20, 72
@ 2, 8 to 20, 72 double
gg=5
dat=date()
kolc=0.00
kolr=0.00
kolcII=0.00
kolrII=0.00
akolc=0.00
akolr=0.00
kolr4=0
dok=space(7)
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))

select OTKUP
/*
go top
declare A[reccount()]
n=1
do while !eof()
if deleted()
a[n]=a[1]
else
a[n]=doc_otk
endif


n=n+1
skip
enddo
mm=val(a[1])
for n=1 to reccount()-1
if !empty (a[n])
if mm>val(a[n])
mm=mm
else
mm=val(a[n])
endif
endif
next
mm=mm+1
dok=alltrim(str(mm))+space(6-len(alltrim(str(mm))))
*/
if file("dokum.mem")
restore from dokum additive
endif


mm=val(dok)+1
dok=alltrim(str(mm))+space(6-len(alltrim(str(mm))))
w_izn=0
//@ 4,10 say substr(KOM->sifra_k,2,5)+'  '+KOM->ime_k
@ 4,10 say rtrim(&file1->ime_k)+'  '+&file1->ugo
@ 6,25 say    voce[curr]
@ 8,10 say 'Za datum : ' get dat
@ 8,40 say 'Dokument : ' get dok valid!empty(dok)
read
if lastkey()=27
clos all
return
endif
select otkup
set order to 2
seek komi+voc+dtos(dat)
if found()
tone(300,10)
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "OVAJ PROIZVODJAC DANAS DRUGI PUT PREDAJE MALINU !" )
inkey(0)
endif

set order to 1
seek komi+voc+dtos(dat)+rtrim(dok)
if found()
kolc=kol_otk
kolr=raz_otk
kolcII=kol_otkII
kolrII=raz_otkII
dok=doc_otk
kolr4=kol4
select AMB
seek komi+dtos(dat)+rtrim(dok)
if found()
akolc=amb_kol
akolr=amb_raz
adok=amb_doc
endif
w_izn=0
//? CHR(7)
tone(300,10)
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "ZA OVOG KOMINTENTA ZA DANAS JE VEC UNET OTKUP !" )
else
select AMB
set order to 1
seek komi+dtos(dat)+rtrim(dok)
if found()
akolc=amb_kol
akolr=amb_raz
adok=amb_doc
endif
ENDIF
a1=0
a2=0
a3=0
a4=0
@ 10,10 say ' Prep. klasa:' get kolc picture '999999.99'
@ 10,50 say ' Gajbe:' get a1 picture '9999'
@ 12,10 say ' I klasa  :   ' get kolr picture '999999.99'
@ 12,50 say ' Gajbe:' get a2 picture '9999'
@ 14,10 say ' II klasa:    ' get kolcII picture '999999.99'
@ 14,50 say ' Gajbe:' get a3 picture '9999'
@ 16,10 say ' III klasa:   ' get kolr4 picture '999999.99'
@ 16,50 say ' Gajbe:' get a4 picture '9999'
@ 18,50 say ' Tezina gajbi:' get gg picture '9'
@ 18,66 say '00 g' 
read
akolr=a1+a2+a3+a4
@ 19,10 say 'Amb. vrac.:   ' get akolr picture '999999.99'
@ 19,40 say 'Amb. uzeta:   ' get akolc picture '999999.99'

read
kolc=kolc-(a1*gg*.1)
kolr=kolr-(a2*gg*.1)
kolcII=kolcII-(a3*gg*.1)
kolr4=kolr4-(a4*gg*.1)
if lastkey()=27
return
endif
sumam=kolc+kolr+kolcII+kolr4
if sumam/akolr>2
tone(300,10)
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "PROSEK TEZINE PO GAJBI VECI OD 2 Kilograma !" )
inkey(0)
endif
correct='D'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "Korektni podaci (D/N) ?" )
@ 22, 55 get correct
read
	if correct='D'
select OTKUP
seek komi+voc+dtos(dat)+rtrim(dok)
if found()
    do req_rec_lock
replace sifra_otk with komi, datum_otk with dat, kol_otk with kolc,kol_otkII with kolcII,;
       sifra_otv with voc,raz_otk with kolr,raz_otkII with kolrII, doc_otk with dok, kol4 with kolr4,;
	   cena1 with VOCE->cena_v, cena2 with VOCE->druga, cena3 with VOCE->treca, cena4 with VOCE->cetvrta
	else
	do new_rec
replace sifra_otk with komi, datum_otk with dat, kol_otk with kolc,kol_otkII with kolcII,;
       sifra_otv with voc,raz_otk with kolr,raz_otkII with kolrII, doc_otk with dok, kol4 with kolr4,;
	   cena1 with VOCE->cena_v, cena2 with VOCE->druga, cena3 with VOCE->treca, cena4 with VOCE->cetvrta
endif
  set safety off
  save all like dok to dokum
  set safety on

select AMB
seek komi+dtos(dat)+rtrim(dok)
if found()
    do req_rec_lock
replace amb_sif with komi, amb_datum with dat, amb_kol with akolc,;
        amb_doc with dok,amb_raz with akolr
	else
	do new_rec
replace amb_sif with komi, amb_datum with dat, amb_kol with akolc,;
        amb_doc with dok,amb_raz with akolr
     endif
	 else
correct='D'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "Brisanje (D/N) ?" )
@ 22, 55 get correct
read
if correct='D'
select OTKUP
seek komi+voc+dtos(dat)+rtrim(dok)
if found()
    do req_rec_lock
	delete
endif
select AMB
seek komi+dtos(dat)+rtrim(dok)
if found()
    do req_rec_lock
	delete
	endif
endif
endif

////////*   &&ODAVDE
stampa='D'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa D/N)" )
@ 23, 60 get stampa picture '!'
read
if stampa='D'
set device to print
for n=1 to 2
	amb_z=0
	amb_r=0
@ prow()+4,65 say 'Por.izj: '+rtrim(&file1->mesto_k)
@ prow()+1,65 say dtoc(dat)+' '+ substr(time(),1,5)

if empty(&file1->ime_k)
@ prow()+2,1 say CENTER('MAGACINSKI ULAZ BROJ '+dok)
@ prow()+2,1 say 'Otk. mesto: '+rtrim(MESTA->naziv_m)+' - '+rtrim(MESTA->otk_m)
else
@ prow()+2,1 say CENTER('DNEVNI OTKUPNI LIST BROJ '+dok)
@ prow() +1,0 say chr(27) + chr(15)
@ prow()+1,1 say 'Proizvodjac: '+rtrim(&file1->ime_k)+', JMBG: '+&file1->jmbg+' '+'Otkupno mesto: '+rtrim(MESTA->naziv_m)
endif
@ prow()+1,0 say replicate ('-',162)
@ prow()+1,0 say ' NAZIV ROBE       Jed.mere     Kolicina     Kvalitet   Cena bez PDV   Cena sa PDV Vredn.bez PDV    PDV   Iznos PDV  Vrednost sa PDV '
@ prow()+1,0 say replicate ('-',162)
@ prow()+1,1 say +voce[curr]
if kolc>0
@ prow()+1,1 say '                               '+'kg'+space(12)+ str(kolc,12,2)+space(4)+'Prep. A'+str(VOCE->cena_v,12,2)+space(5)+str(VOCE->cena_v*(1+VOCE->pdv/100),12,2)+space(15)+str(kolc*VOCE->cena_v,12,2)+space(5)+str(VOCE->pdv,2,0)+space(2)+str((kolc*VOCE->cena_v)*(VOCE->pdv/100),12,2)+space(5)+str(kolc*VOCE->cena_v*(1+VOCE->pdv/100),12,2)
endif
if kolr>0
@ prow()+1,1 say '                               '+'kg'+space(12)+ str(kolr,12,2)+space(8)+'A'+space(6)+str(VOCE->druga,12,2)+space(5)+str(VOCE->druga*(1+VOCE->pdv/100),12,2)+space(15)+str(kolr*VOCE->druga,12,2)+space(5)+str(VOCE->pdv,2,0)+space(2)+str((kolr*VOCE->druga)*(VOCE->pdv/100),12,2)+space(5)+str(kolr*VOCE->druga*(1+VOCE->pdv/100),12,2)
endif
if kolcII>0
@ prow()+1,1 say '                               '+'kg'+space(12)+ str(kolcII,12,2)+space(8)+'B'+space(7)+rtrim(str(VOCE->treca,12,2))+space(5)+str(VOCE->treca*(1+VOCE->pdv/100),12,2)+space(15)+str(kolcII*VOCE->treca,12,2)+space(5)+str(VOCE->pdv,2,0)+space(2)+rtrim(str((kolcII*VOCE->treca)*(VOCE->pdv/100),12,2))+space(5)+str(kolcII*VOCE->treca*(1+VOCE->pdv/100),12,2)
endif
@ prow()+1,0 say replicate ('-',162)
  select AMB
set softseek on
seek rtrim(komi)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(komi) .and. amb_datum<=dat .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
skip
enddo
@ prow()+1,1 say '  A M B A L A Z A:'+' Ulaz '+str(akolr,6)+space(3)+'Izlaz  '+str(akolc,6)+'    '+'Stanje: '+str(amb_z,5)+'-'+str(amb_r,5)+'='+str(amb_r-amb_z,5)
//	@ prow()+1,0 say 'Stanje ambalaze: '+str(amb_z,5)+'-'+str(amb_r,5)+'='+str(amb_r-amb_z,5)
//@ prow()+1,1 say '  A M B A L A Z A         '+space(3)+' Ulaz             Izlaz'
//@ prow()+1,1 say '                  '+space(3)+str(akolr,12)
//@ prow() ,40 say str(akolc,12)
//@ prow() ,0 say chr(27) + chr(18)
//@ prow() +1,0 say  chr(83)
@ prow()+2,1 say 'Shodno Zakonu o porezu na dohodak gradjana obracunati iznos poreza i doprinosa pada na teret proizvodjaca ukoliko proizvodjac ne donese potrebnu' 
@ prow()+1,1 say 'dokumentaciju kojom dokazuje da ima pravo na oslobadjanje. U slucaju da otkupna cena nije upisana u ovaj otkupni list ili je upisana pogresna '
@ prow()+1,1 say 'cena proizvodjacu ce biti isplacena otkupna cena cija je visina utvrdjena vazecom odlukom o otkupnim  cenama koju je doneo Euro Frigo d.o.o. Rok'
@ prow()+1,1 say 'isplate 15.09.2025. na tekuci racun proizvodjaca. Pecat je odstampan i punovazan. Napomena: Nerazduzeni PE HOLANDEZI naplacuju se 150,00 dinara ' 
@ prow()+1,1 say 'po komadu. Ako proizvodjac ne dostavi Zakonom propisanu dokumentaciju nece ostvariti pravo na PDV nadoknadu, pa ni u slucaju da je PDV nadoknada'  
@ prow()+1,1 say 'iskazana u ovom otkupnom listu. Svojim potpisom proizvodjac daje saglasnost na sve odredbe ovog otkupnog lista.'
//prow()+1,1 say 'ovog otkupnog lista. '
//@ prow() ,0 say chr(27) + '84'
//if empty(&file1->ime_k)
//@ prow()+2,1 say ' Otkupljivac     	                             '+rtrim(COMPANY->co_line1)
//else
@ prow()+3,10 say '____________________                                                  _____________________'
@ prow()+1,10 say '    Proizvodjac     	                                                 Ovlasceni otkupljivac'
//endif
//@ prow()+2,1 say ' ___________     	                              '&&  ___________'
@ prow() +1,0 say chr(27) + chr(18)

//@ prow()+10,1 say '   '
//@ prow()+7,1 say '   '
eject
next
//eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
endif
//////*/ && DOVDE
if !empty(w_izn)
la = 1
curr = 1
do rfill_roba with la
do red_screen with "Unos otkupa"
  //restore screen from screen1
  curr = achoice(3,20,19,60,roba,.T.,'',curr,curr-1)
  do case
     case curr !=0
	 go roba_no[curr]
	 roba_o=sifra_r
	 do zad_r with komintent,roba_o
//	 loop
     case curr = 0
          close all
          clear screen
          return
  endcase
endif
return


procedure u_mes
parameters pcx
last=100
select MESTA
do fill_mss with pcx
tekuci=pcx
*  restore screen from screen1
  tekuci = achoice(3,30,19,50,kart,.T.,'',tekuci,tekuci-1)
  do case
     case tekuci != 0 
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
     ox=tekuci
     case tekuci = last
	 go rec_no[tekuci]
	 otk_sifra=sifra_m
     ox=tekuci
	 case tekuci = 0
	 otk_sifra='xxx'
//	 clos all
	 return
  endcase
return

procedure fill_mss
parameters desc  
select mesta
go top
last = 1
do while !eof()
   kart [ last ] = naziv_m
   rec_no [ last ] = recno()
   if last=desc
         tekuci = last
   endif
   last = last + 1
   skip
enddo

for i = last + 1 to 100
    kart [ i ] = ''
next
return

procedure xfill_komm
parameters desc  
select KOM
//set order to 2
go top
zad = 1
//seek desc
//if found()
do while !eof()
//do while substr(sifra_k,1,3)=desc .and. !eof()
	if substr(sifra_k,1,3)!=otk_sifra
	skip
	loop
	endif
   komm [ zad ] = ime_k+' '+mesto_k
   rec [ zad ] = recno()
   zad = zad + 1
   skip
enddo
//endif
set order to 1

komm [ zad ] = '*** Zaduzenje otkupnog mesta ****'
for i = zad + 1 to MAX
    komm [ i ] = ''
next
//asort(komm,1,zad)
return

procedure pravi_fill_komm
parameters desc  
select KOM
go top
zad = 1
select TMPK
zap
set index to tmpk
reindex
append from kom for substr(sifra_k,1,3)=otk_sifra
go top
do while !eof()
   komm [ zad ] = ime_k+' '+mesto_k
    rec [ zad ] = recno()
   zad = zad + 1
   skip
enddo
komm [ zad ] = '*** Otkupno mesto ****'
//for i = zad + 1 to MAX
//    komm [ i ] = ''
//next
return

procedure fill_komm
parameters desc  
select KOM
go top
zad = 1

select &file1
zap
set index to &ind1
reindex

append from kom for substr(sifra_k,1,3)=otk_sifra
go top
do while !eof()
   komm [ zad ] = ime_k  &&+' '+mesto_k
    rec [ zad ] = recno()
   zad = zad + 1
   skip
enddo
komm [ zad ] = '*** Otkupno mesto ****'
//for i = zad + 1 to MAX
//    komm [ i ] = ''
//next
return


//Akontacija
procedure akontacija
clear screen
setcolor(DEF_GREEN)
MAX=1000
declare kart [ 100 ]
declare rec_no[ 100 ]
declare komint [ MAX ]
declare rec[ MAX ]
last_sif=0
@ 00, 00 say center("Pregled i stampa akontacije")
@ 1, 0 , 21, 79 box background
//@ 2, 13 clear to 20, 67
//@ 2, 13 to 20, 67 double
*@ 2, 25 say 'Mesto:'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_no,kom_name
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'OTKUP', .F. )
   set index to otk_sd
else
  clos all
  RETURN   
endif
select 4
if NET_USE ( 'VOCE', .F. )
   set index to v_no
else
  clos all
  RETURN   
endif
select 5
if NET_USE ( 'SUMA', .T. )
zap
else
  clos all
  RETURN   
endif
select 6
if NET_USE ( 'ZADUZ', .F. )
   set index to zad_doc,zad_sd,zad_rd,zad_ds,zad_xx
else
  clos all
  RETURN   
endif
select 7
if NET_USE ( 'ROBA', .F. )
   set index to r_no
else
  clos all
  RETURN   
endif

do uzmi_mesta
do red_screen with "Pregled i stampa akontacije"
    //restore screen from screen1
zad = 1


tek = 1

procedure uzmi_mesta
select MESTA
do fill_kart
current=1
  current = achoice(3,30,19,50,kart,.T.,'',current,current-1)
  do case
     case current != 0 &&last
	 go rec_no[current]
	 otk_sifra=sifra_m
	  do prega_kom with otk_sifra
     case current = 0
   setcolor(DEFAULT)
	  return
  endcase
return

///////PO PROIZVODJACIMA
procedure prega_kom
do red_screen with "Pregled i stampa akontacije"
    //restore screen from screen1
store date() to datum1,datum2, xdatum
pro=0
bnk=space(3)
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  " )
@ 00,00  say center(' ')
@ 00,5  say 'Od: ' get datum1
@ 00,25 say 'Do: ' get datum2
@ 00,45 say 'Za: ' get xdatum
@ 00,65 say 'Proc.% : ' get pro picture '99.99'
@ 01,5  say 'Banka: ' get bnk
read
if lastkey()=27
   setcolor(DEFAULT)
return
endif
select KOM
go top
do while !eof()
if substr(sifra_k,1,3)!=otk_sifra 
skip
loop
endif		
if substr(tr,1,3)!=bnk 
skip
loop
endif		
w_c=sifra_k
select OTKUP
 set index to otk_sd
robni=0.0
robni1=0.0
suma=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
select VOCE
   go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

if KOM->pdd='D'
uku_vd=uku_vd+kol_otk*cena1*(1+VOCE->pdv/100)
uku_dd=uku_dd+raz_otk*cena2*(1+VOCE->pdv/100)
uku_td=uku_td+kol_otkii*cena3*(1+VOCE->pdv/100)
thirdd=thirdd+kol4*cena4*(1+VOCE->pdv/100)
else
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
endif
	skip
enddo

select VOCE
skip
enddo

**********ROBA

ukupno=0.00
svega=0.0
select ROBA
go top
do while !eof()
select ZADUZ
set order to 3
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
robni=robni+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
skip
enddo
select ROBA
skip
enddo
svega=uku_vd+uku_dd+uku_td+thirdd	
svega=svega*pro/100
suma=svega-robni
if suma>0
select SUMA
do add_rec
////  OVO JE STARO replace sifra with KOM->sifra_k, iznos with suma*pro/100
replace sifra with KOM->sifra_k, iznos with suma  &&OVO JE NOVO
endif


robni=0.0
robni1=0.0
suma=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0

select KOM
skip
enddo
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Stampa-Razduzenje/Pojedinacno (E/S/P)" )
@ 23, 65 get stampa picture '!'
read
svega=0
if stampa='P'
do poj_ak
endif
if stampa='E'
@ 0,1  say center( "Akontacija za: "+rtrim(MESTA->naziv_m)+' za period '+dtoc(datum1)+'-'+dtoc(datum2))
@ 1,1  say center( "Ime i Prezime                     Racun                       Iznos                                 ")
select KOM
//set order to 2
select SUMA
go top
set relation to sifra into KOM
do while !eof()
@ row()+1,1 say substr(KOM->ime_k,1,30)
@ row(),33 say substr(KOM->tr,1,25)
@ row(),60 say iznos picture '999999.99'
svega=svega+iznos
		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
		@ 2,1 clear to 19,79
@ 1,1  say center( "Ime i Prezime                     Racun                       Iznos                                 ")
		endif

skip
enddo
@ 21,10 say 'Svega:'
@ 21,60 say svega picture '999999.99'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
endif



if stampa='S'
select KOM
//set order to 2
select SUMA
set device to print
@ prow()+1,1  say center( "Akontacija proizvodjaca za:" +rtrim(MESTA->naziv_m)+' za period '+dtoc(datum1)+'-'+dtoc(datum2))
@ prow()+2,1  say center( "Ime i Prezime                     Racun                               Iznos  ")
@ prow()+1,1  say replicate('-',80)

select SUMA
go top
set relation to sifra into KOM
do while !eof()
@ prow()+1,1 say substr(KOM->ime_k,1,30)
@ prow(),33 say substr(KOM->tr,1,30)
@ prow(),70 say iznos picture '999999.99'
svega=svega+iznos
/*
select ZADUZ
   set index to zad_doc,zad_sd,zad_rd,zad_ds,zad_xx
seek KOM->sifra_k+'100'+'AK'+substr(dtoc(xdatum),1,5)
if found()
do req_rec_lock
replace sifra_zad with KOM->sifra_k, sifra_zar with '100' , doc_zad with 'AK'+substr(dtoc(xdatum),1,5), kol_zad with SUMA->iznos, datum_zad with xdatum
else
do new_rec
replace sifra_zad with KOM->sifra_k, sifra_zar with '100' , doc_zad with 'AK'+substr(dtoc(xdatum),1,5), kol_zad with SUMA->iznos, datum_zad with xdatum
endif
*/
select SUMA
 skip
 enddo
@ prow()+1,1  say replicate('-',80)
@ prow()+1,10 say 'SVEGA:'
@ prow(),70 say svega picture '999999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)

set device to screen
endif

clear screen
clos all
   setcolor(DEFAULT)
return

//////////
procedure poj_ak
//if stampa='P'
declare kart [ 1000 ]  &&treba
select KOM
//set order to 2
select SUMA
set device to print
@ prow()+1,1  say center( "Akontacija proizvodjaca za:" +rtrim(MESTA->naziv_m)+' za period '+dtoc(datum1)+'-'+dtoc(datum2))
@ prow()+2,1  say center( "Ime i Prezime                     Racun                               Iznos  ")
@ prow()+1,1  say replicate('-',80)
i=1
select SUMA
go top
set relation to sifra into KOM
do while !eof()
kart[i]=substr(KOM->ime_k,1,35)+substr(KOM->tr,1,35)+str(iznos,10,2)
//@ prow()+1,1 say substr(KOM->ime_k,1,30)
//@ prow(),33 say substr(KOM->tr,1,30)
//@ prow(),70 say iznos picture '999999.99'
//svega=svega+iznos
i=i+1
 skip
 enddo
 tek=1
 zad=i
do while .T.
  restore screen from screen1
  tek = achoice(3,1,19,80,kart,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'000'
	 case tek = 0
set device to screen
	 clos all
	 return
	 otherwise
      @ prow()+1, 1 say '³'+Kart[tek]
      @ prow()+1, 1 say '³_________________________________³_________________³'+'__________________________³'
  endcase
enddo

  @ prow()+1,1  say replicate('-',80)
//@ prow()+1,10 say 'SVEGA:'
//@ prow(),70 say svega picture '999999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)

set device to screen
//endif
clos all
return

procedure xprega_kom
    restore screen from screen1
store date() to datum1,datum2, xdatum
pro=0
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  " )
@ 00,00  say center(' ')
@ 00,5  say 'Od: ' get datum1
@ 00,25 say 'Do: ' get datum2
@ 00,45 say 'Za: ' get xdatum
@ 00,65 say 'Proc.% : ' get pro picture '99.99'
read
if lastkey()=27
   setcolor(DEFAULT)
return
endif
select KOM
   set index to kom_name,kom_no

select KOM
do while !eof()
if substr(sifra_k,1,3)!=otk_sifra 
skip
loop
endif
suma=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
select VOCE
do while !eof()
select OTKUP
set softseek on
seek KOM->sifra_k+VOCE->sifra_v+dtos(datum1)
set softseek off
	  do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->sifra_v .and. datum_otk<=datum2
if KOM->pdd='D'
uku_vd=uku_vd+kol_otk*cena1*(1+VOCE->pdv/100)
uku_dd=uku_dd+raz_otk*cena2*(1+VOCE->pdv/100)
uku_td=uku_td+kol_otkii*cena3*(1+VOCE->pdv/100)
thirdd=thirdd+kol4*cena4*(1+VOCE->pdv/100)
else
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
endif
	  skip
enddo
select VOCE
skip
enddo
suma=suma+ (uku_vd+uku_dd+uku_td+thirdd)
if suma>0
select SUMA
do add_rec
replace sifra with KOM->sifra_k, iznos with suma*pro/100
endif
select KOM
skip
enddo
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Stampa-Razduzenje (E/S)" )
@ 23, 60 get stampa picture '!'
read
svega=0
if stampa='E'
@ 0,1  say center( "Akontacija za: "+rtrim(MESTA->naziv_m)+' za period '+dtoc(datum1)+'-'+dtoc(datum2))
@ 1,1  say center( "Ime i Prezime                     Racun                       Iznos                                 ")
select KOM
set order to 2
select SUMA
set relation to sifra into KOM
do while !eof()
@ row()+1,1 say substr(KOM->ime_k,1,30)
@ row(),33 say substr(KOM->tr,1,25)
@ row(),60 say iznos picture '999999.99'
svega=svega+iznos
		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
		@ 2,1 clear to 19,79
@ 1,1  say center( "Ime i Prezime                     Racun                       Iznos                                 ")
		endif

skip
enddo
@ 21,10 say 'Svega:'
@ 21,60 say svega picture '999999.99'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
endif


if stampa='S'
select KOM
set order to 2
select SUMA
set device to print
@ prow()+1,1  say center( "Akontacija proizvodjaca za:" +rtrim(MESTA->naziv_m)+' za period '+dtoc(datum1)+'-'+dtoc(datum2))
@ prow()+2,1  say center( "Ime i Prezime                     Racun                               Iznos  ")
@ prow()+1,1  say replicate('-',80)

select SUMA
set relation to sifra into KOM
do while !eof()
@ prow()+1,1 say substr(KOM->ime_k,1,30)
@ prow(),33 say substr(KOM->tr,1,30)
@ prow(),70 say iznos picture '999999.99'
svega=svega+iznos
select ZADUZ
seek KOM->sifra_k+'100'+'AK'+substr(dtoc(xdatum),1,5)
if found()
do req_rec_lock
replace sifra_zad with KOM->sifra_k, sifra_zar with '100' , doc_zad with 'AK'+substr(dtoc(xdatum),1,5), kol_zad with SUMA->iznos, datum_zad with xdatum
else
do new_rec
replace sifra_zad with KOM->sifra_k, sifra_zar with '100' , doc_zad with 'AK'+substr(dtoc(xdatum),1,5), kol_zad with SUMA->iznos, datum_zad with xdatum
endif
select SUMA
 skip
 enddo
@ prow()+1,1  say replicate('-',80)
@ prow()+1,10 say 'SVEGA:'
@ prow(),70 say svega picture '999999.99'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)

set device to screen
endif

clear screen
clos all
   setcolor(DEFAULT)
return

procedure otm
clear screen
@ 00, 00 say center( "Unos otkupa")
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1
select 1
if NET_USE ( 'VOCE', .F. )
   set index to v_name,v_no
else
  clos all
  RETURN   
endif


select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif


select 7
if NET_USE ( 'COMPANY', .F. )
else
  clos all
  RETURN   
endif		  

select 8
if NET_USE ( 'OTKUPM', .F. )
   set index to otm_sd, otm_dd
else
  clos all
  RETURN   
endif


MAX=1000
declare voce [ MAX ]
declare voce_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]
otk_sifra=space(3)
ox = 1
do while .T.
do red_screen with "Unos otkupa"
  //restore screen from screen1
current = 1
do u_mes with ox
zad = 1
tek = 1
//do fill_komm with otk_sifra
do while .T. && NOVO
do red_screen with "Unos otkupa"
  //restore screen from screen1
//  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
//  do case
//     case tek =zad
//*	 go rec[tek]
//	 komintent=otk_sifra+'000'
//	 case tek = 0
//	 clos all
//	 return
//*	 exit
//	 otherwise
//*     case tek !=0 
//     select KOM
//     select TMPK
//     select &file1
//	 go rec[tek]
//	 komintent=sifra_k
//  endcase
la = 1
curr = 1
do fill_v with la
do red_screen with "Unos otkupa"
  //restore screen from screen1
  curr = achoice(3,20,19,60,voce,.T.,'',curr,curr-1)
  do case
     case curr !=0
	 go voce_no[curr]
	 voce_o=sifra_v
	 do ot_mes with otk_sifra,voce_o
	 loop
     case curr = 0
          close all
          clear screen
          return
  endcase
enddo
enddo
close all
ox = 1
clear screen
return

procedure ot_mes
parameters komi,voc
MAX=1000
declare roba [ MAX ]
declare roba_no[ MAX ]
clear screen
do red_screen with "Unos otkupa"
  //restore screen from screen1
@ 2, 8 clear to 20, 72
@ 2, 8 to 20, 72 double
dat=date()
kolc=0.00
kolr=0.00
kolcII=0.00
kolrII=0.00
akolc=0.00
akolr=0.00
kolr4=0
dok=space(6)
wkom1=space(25)
wkom2=space(25)
mm=0
   datumx = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
   datumy = ctod( '31.12.' +  str( year( date() ), 4, 0 ))
dok='1     '
select OTKUPM
set order to 2
set softseek on
//wait komi+dtos(datumx)
seek komi+dtos(datumx)
set softseek off
do while sifra_otk=komi .and. datum_otk<datumy .and. !eof()
mm=val(doc_otk)
skip
enddo
mm=mm+1

dok=alltrim(str(mm))+space(6-len(alltrim(str(mm))))
w_izn=0
//@ 4,10 say substr(KOM->sifra_k,2,5)+'  '+KOM->ime_k
@ 4,10 say rtrim(MESTA->NAZIV_M)
@ 6,25 say    voce[curr]
@ 8,10 say 'Za datum : ' get dat
@ 8,40 say 'Dokument : ' get dok valid!empty(dok)
read
if lastkey()=27
clos all
return
endif
select otkupM
set order to 1
seek komi+voc+dtos(dat)+rtrim(dok)
if found()
kolc=kol_otk
kolr=raz_otk
kolcII=kol_otkII
kolrII=raz_otkII
dok=doc_otk
kolr4=kol4
a1=ambv
a2=ambu
wkom1=kom1
wkom2=kom2
auto=vozilo
w_izn=0
//? CHR(7)
tone(300,10)
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "ZA OVOG KOMINTENTA ZA DANAS JE VEC UNET OTKUP !" )
else
a1=0
a2=0
a3=0
a4=0
auto=space(10)
endif
@ 10,10 say 'Prep. klasa:' get kolc picture '999999.99'
@ 10,40 say ' I klasa  :   ' get kolr picture '999999.99'
@ 12,10 say ' II klasa:    ' get kolcII picture '999999.99'
@ 12,40 say ' III klasa:   ' get kolr4 picture '999999.99'
@ 14,10 say ' Gajbe vracene:   ' get a1 picture '999999'
@ 14,40 say ' Gajbe uzete:   ' get a2 picture '999999'
@ 16,10 say 'Vozilo: ' get auto
@ 18,10 say 'Napomena: Ulaz:' get wkom1
@ 19,19 say 'Izlaz:' get wkom2
read

read
if lastkey()=27
return
endif
correct='D'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "Korektni podaci (D/N) ?" )
@ 22, 55 get correct
read
	if correct='D'
select OTKUPM
seek komi+voc+dtos(dat)+rtrim(dok)
if found()
    do req_rec_lock
replace sifra_otk with komi, datum_otk with dat, kol_otk with kolc,kol_otkII with kolcII,;
       sifra_otv with voc,raz_otk with kolr,raz_otkII with kolrII, doc_otk with dok, kol4 with kolr4,;
	   ambv with a1, ambu with a2, vozilo with auto, kom1 with wkom1, kom2 with wkom2
	else
	do new_rec
replace sifra_otk with komi, datum_otk with dat, kol_otk with kolc,kol_otkII with kolcII,;
       sifra_otv with voc,raz_otk with kolr,raz_otkII with kolrII, doc_otk with dok, kol4 with kolr4,;
	   cena1 with VOCE->cena_v, cena2 with VOCE->druga, cena3 with VOCE->treca, cena4 with VOCE->cetvrta,;
	   ambv with a1, ambu with a2, vozilo with auto, kom1 with wkom1, kom2 with wkom2
endif
//  set safety off
//  save all like dok to dokum
//  set safety on

	 else
correct='D'
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "Brisanje (D/N) ?" )
@ 22, 55 get correct
read
if correct='D'
select OTKUPM
seek komi+voc+dtos(dat)+rtrim(dok)
if found()
    do req_rec_lock
	delete
endif
endif
endif
/////ODAVDE STAMPA
do red_screen with "Unos otkupa"
stampa='D'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa D/N)" )
@ 23, 60 get stampa picture '!'
read
ull='U'
@ 23, 0 say centermsg( "Ulaz/Otpremnica U/O)" )
@ 23, 60 get ull picture '!'
read
if stampa='D'
set device to print
for n=1 to 2
//@ prow(),1 say rtrim(COMPANY->co_line1)
//@ prow(),1 say rtrim(COMPANY->co_line1)
//@ prow()+1,1 say rtrim(COMPANY->co_line2)
//@ prow(),1 say rtrim(COMPANY->co_line2)
@ prow()+7,63 say dtoc(dat)+' '+ substr(time(),1,5)
if ull='U'
@ prow()+2,1 say CENTER('MAGACINSKI ULAZ BROJ '+dok)
else
@ prow()+2,1 say CENTER('OTPREMNICA BROJ '+dok)
endif
@ prow()+2,1 say 'Otk. mesto: '+rtrim(MESTA->naziv_m)+ '     Vozilo: '+auto  &&rtrim(MESTA->otk_m)
@ prow()+1,0 say replicate ('-',79)
@ prow()+1,0 say ' PROIZVOD         Jed.mere     Kolicina      Klasa        Cena         Iznos'
@ prow()+1,0 say replicate ('-',79)
@ prow()+1,1 say '                     '+'kg'+space(2)+ str(kolc,12,2)+'    Prep. A'+str(VOCE->cena_v*(1+VOCE->pdv/100),12,2)+space(2)+str(kolc*VOCE->cena_v*(1+VOCE->pdv/100),12,2)
@ prow()+1,1 say +voce[curr]+' '+'kg'+space(2)+ str(kolr,12,2)+'         A '+str(VOCE->druga*(1+VOCE->pdv/100),12,2)+space(2)+str(kolr*VOCE->druga*(1+VOCE->pdv/100),12,2)
@ prow()+1,1 say '                     '+'kg'+space(2)+ str(kolcII,12,2)+'         B '+str(VOCE->treca*(1+VOCE->pdv/100),12,2)+space(2)+str(KOLCii*VOCE->treca*(1+VOCE->pdv/100),12,2)
//@ prow()+1,1 say +voce[curr]+' '+'kg'+space(2)+ str(kolcII,12,2)+'        II '+str(VOCE->treca,12,2)+space(2)+str(KOLCii*VOCE->treca,12,2)
//@ prow()+1,1 say '                     '+'kg'+space(2)+ str(kolr4,12,2)+'       III '+str(VOCE->cetvrta,12,2)+space(2)+str(KOLr4*VOCE->cetvrta,12,2)
@ prow()+1,0 say replicate ('-',79)
@ prow()+1,1 say '  A M B A L A Z A         '+' Ulaz '+str(a1,6)+space(3)+'Izlaz  '+str(a2,6)
@ prow()+2,1 say '  Napomena: '+wkom1
@ prow()+1,13 say wkom2
@ prow()+5,1 say '_________________	                                 _______________'
@ prow()+1,1 say ' Robu primio     	                                    Robu izdao'
//prow()+1,1 say ' Robu primio     	                             '+rtrim(COMPANY->co_line1)
eject
next
//@ prow()+10,1 say '   '
//@ prow()+7,1 say '   '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
endif
return

procedure l_chngs
//KARTICA ROBE 
MAX=1000
declare roba [ MAX ]
declare roba_no[ MAX ]
declare kart [ 1000 ]  &&treba
declare kart_no[ 1000 ]

declare ime[12]
declare dok[12]
clear screen
@ 1,0,22,79 box background
*set color to i
@ 00, 00 say center( "Pregled kartice prometa robe" )
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Esc - Izlaz" )
save screen to scr1
			       
declare documents [ 20 ]
declare rec_no [ 20 ]

select 4
if NET_USE ( 'MESTA', .F. )
   set index to m_no, m_name
else
  clos all
  RETURN   
endif		

select 3
if ! net_use( "PAGES", .T. )
   close all
   return
endif

select 2
if NET_USE ( 'ROBA', .F. )
   set index to r_name
else
  clos all
  RETURN   
endif

select 1
 if net_use( "CHANGES", .F. )
   set index to ch_sd, ch_dob
else
   close all
   return
endif
set relation to ch_dob into mesta

from_date = ctod( '01.01.' + substr( dtos( date() ), 1, 4 ) )
to_date = date()
m_sifra = space(3)
status_sifre = space(1)
u_kol=0
i_kol=0
i_vr=0
u_vr=0
do while .T.
from_date = ctod( '01.01.' + substr( dtos( date() ), 1, 4 ) )
u_kol=0
i_kol=0
i_vr=0
u_vr=0
do whole_screen with "Pregled kartice prometa robe"
//   restore screen from scr1
   select ROBA
   la = 1
curr = 1
do rfill_roba with la
   select CHANGES
   @ 3, 0 to 3, 79
   @ 2, 2 say "Od:" get from_date
   @ 2, 17 say "Do:" get to_date
   read
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double

  curr = achoice(3,20,19,60,roba,.T.,'',curr,curr-1)
  do case
     case curr !=0
	 select ROBA
	 go roba_no[curr]
	 m_sifra=sifra_r
     case curr = 0
          close all
          clear screen
          return
  endcase
ox = 1
current = 1
last=100
select MESTA
 set order to 2
do fill_mesta with ox
set order to 1
do whole_screen with "Pregled kartice prometa robe"
  //restore screen from scr1
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
  tekuci = achoice(3,15,19,65,kart,.T.,'',tekuci,tekuci-1)
  do case
	 case tekuci !=last
	 go kart_no[tekuci]
	 m_sifdob=sifra_m
	 do po_mestu
	 clos all 
	 return
	 case tekuci = 0
	 clos all
	 return
  endcase

   if lastkey() = 27
      close all
      return
   endif
where='E'
   @ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get where picture "!"
read

if where!="E"
do s_kar_pr
      close all
      return
   endif
   key_date = from_date

   @ 1,0 clear to 3, 79
   if from_date > to_date
      ?? chr(7)
      *set color to i+
      set cursor off
      @ 2, 0 say center( "Ne postoje podaci" )
      inkey(0)
      set cursor on
      *set color to
      loop
   endif
   select CHANGES
   set softseek on
   seek m_sifra+dtos(from_date)
//   seek dtos(from_date)+m_sifra
   set softseek off
restore screen from scr1
   text = "Promet svih artikala od " + dtoc( from_date ) + " do " + dtoc( to_date )
   if ! empty(  m_sifra )
      text = text &&+ ' za '+ROBA->naziv_r   &&" sa sifrom: " + rtrim(  m_sifra )
   endif
   @ 0, 0 say center( text )
   end_of_list = .F.
   @ 21, 0 to 24, 79
   @ 22, 0 say centermsg( "PgUp - Prethodna strana, PgDn - Sledeca strana" )
   @ 23, 0 say centermsg( "Home - Pocetak, F5/F6 - Pregled , Esc - Izlaz" )
   @ 2, 3 say " Datum:   Sifra:     Ulaz:     Izlaz:      Cena:      Vr.ulaz    Vr.izlaz"
   @ 3, 2 to 16, 79
   @ 17, 2 to 20, 77 double
   action = 0
   set cursor off
   save screen to scc
   rec_listed = 0
   act_listed = 0
   curr_name = 1
   first = recno()
   top_page = 1
   curr_page = 1
   select PAGES
   append blank
   replace PAGE_HEAD with first
   select CHANGES
   do lst_changes
   do while action != 27
      action = inkey(0)
      do case
         case action = 18  && PgUp
              if curr_page != 1
                 curr_page = curr_page - 1
                 select PAGES
                 go curr_page
                 select CHANGES
                 go PAGES->PAGE_HEAD
                 end_of_list = .F.
                 do lst_changes
              endif
         case action = 3  && PgDn
              if ! end_of_list
                 if curr_page + 1 > top_page  && new page
                    record = recno()
                    select PAGES
                    append blank
                    replace PAGE_HEAD with record
                    select CHANGES
                    top_page = top_page + 1
                 endif
                 curr_page = curr_page + 1
                 do lst_changes
              endif
         case action = 1  && Home
              go first
              end_of_list = .F.
              do lst_changes
         case action = -4  && F5
              do up_nm_ch
         case action = -5  && F6
              do dn_nm_ch
         endcase
   enddo
   set cursor on
   select CHANGES
enddo
close all
return
                                                                                    

procedure lst_changes  && displays 12 records (if possible) 
do whole_screen with "Pregled kartice prometa robe"
//restore screen from scc
rec_listed = 0
act_listed = 0
st_rec = 0
do while ! end_of_list .and. rec_listed < 12
//select ROBA
//seek CHANGES->CH_SIFRA
//   ime[rec_listed + 1] = NAZIV_R+' '+CHANGES->CH_faktura
//   select CHANGES
   doc_type = substr( CH_DOKUM, 1, 2 )
   dok[rec_listed + 1] = rtrim(doc_type) + ' ' + ltrim( substr( CH_DOKUM, 3, 10 ) ) + space(18)
   @ 4 + rec_listed, 3 say substr(dtoc(CH_DATUM),1,5)
   @ 4 + rec_listed, 12 say substr(CH_SIFRA,1,3)
   do case
      case CH_STATUS = "U"
		   u_kol=u_kol+ch_kol
		   ime[rec_listed + 1] = ROBA->NAZIV_R+' '+CHANGES->CH_faktura
           @ 4 + rec_listed, 18 say CH_KOL picture '99999999.99'
           @ 4 + rec_listed, 29 say space(11) 
  		   @ 4 + rec_listed, 40 say transform( CH_CENA, '999999999.99' )
		   @ 4 + rec_listed, 53 say transform( CH_CENA*CH_KOL, '999999999.99' )
		   u_vr=u_vr+ch_cena*ch_kol
      case CH_STATUS = "I"
	       ime[rec_listed + 1] = ROBA->NAZIV_R+' '+MESTA->naziv_m
		   i_kol=i_kol+ch_kol
           @ 4 + rec_listed, 29 say CH_KOL picture '99999999.99'
           @ 4 + rec_listed, 18 say space(11) 
		   @ 4 + rec_listed, 40 say transform( CH_CENA, '999999999.99' )
		   @ 4 + rec_listed, 66 say transform( CH_CENA*CH_KOL, '999999999.99' )
		   i_vr=i_vr+ch_cena*ch_kol
   endcase
   rec_listed = rec_listed + 1
   ch_forward( 1 )
enddo
if rec_listed < 12   && clear previous data
   @ 4+rec_listed, 3 clear to 15, 78
endif
if end_of_list
   @ 16, 18 say U_KOL picture '99999999.99'
   @ 16, 29 say I_KOL picture '99999999.99'
   @ 16, 52 say  u_vr picture '999999999.99'
   @ 16, 66 say  i_vr picture '999999999.99'
   @ 17, 24 say  u_kol-i_kol picture '999999999.99'
else
    @ 3, 2 to 16, 79  && repair box
endif
do set_chng_pointer with curr_name
return


function ch_forward
parameters no_of_rec
select CHANGES
tmp_recno = recno()
prev_date = CH_DATUM
skip no_of_rec
if CH_DATUM > to_date .or. eof()
   end_of_list = .T.
   return(.T.)
endif
if CH_SIFRA = rtrim(  m_sifra )
   end_of_list = .F.
   return( .T. )
endif
if CH_DATUM > prev_date 
   key_date = CH_DATUM
else 
   key_date = CH_DATUM + 1
endif
if key_date > to_date
   end_of_list = .T.
   return( .T. )
endif   
do while key_date <= to_date .and. CH_SIFRA != rtrim(  m_sifra ) 
   key = dtos(key_date ) + rtrim(  m_sifra )
   seek key
   key_date = key_date + 1
enddo
if eof() 
   end_of_list = .T.
   return( .T. )
endif
end_of_list = .F.
return (.T.)  && tek da se nesto vrati, inace ne znaci nista


procedure set_chng_pointer  && sets name pointer at the name_no
parameters name_no
if name_no > rec_listed
   curr_name = rec_listed
else
   curr_name = name_no
endif
&&  Code that follows is because of flicker elimination
*set color to w+
for i = 4 to 18
    do case
       case i < curr_name + 3
            @ i, 0 say "  "
       case i > curr_name + 3
            @ i, 0 say "³ "
       otherwise     && i=curr_name + 3
            @ i, 0 say "Ú-"
   endcase
next
@ 19, 0 say "À-"
@ 18, 3 say "Dokument: " + dok[curr_name]
name = rtrim( ime[curr_name] )
@ 19, 3 say name + space( 74 - len( name ) )
return


procedure up_nm_ch  && find name of upper sifra (on screen)
if curr_name = 1
   return
endif
do set_chng_pointer with curr_name - 1
return

procedure dn_nm_ch  && find name of sifra that is under	current record (on screen)
if curr_name = rec_listed
   return
endif								         
do set_chng_pointer with curr_name + 1
return


procedure s_kar_pr
* Stampanje pregleda prometa
      select CHANGES 
   set index to ch_sd, ch_dokum,ch_ds
   store 0 to ul_genvred, iz_genvred
   select ROBA
   @  2,  0 clear to 3, 79
   line = 1
   page = 1
*   if ! LPR()
*      return
*   endif
   set device to print
   setprc(0,0)
   @ prow()+1, 0 say chr(27) + chr(15)
//   do p_zag    
   @  prow()+2, 2  say "SIFRA: " + SIFRA_R + space(3) + "NAZIV: " + rtrim( NAZIV_R ) &&+ space(3) + "JEDINICA MERE: " + NZ_JM
   select CHANGES
   @  prow()+1, 2  say replicate( "-", 130 )
   @  prow()+1, 40 say "KOLICINE"
//   @  prow(),  100 say "VREDNOST"
   @  prow()+1,  2 say "DATUM:" + space(5) + "DOKUMENT:" + space(12) + "ULAZ:" + space(8) + "IZLAZ:" + space(20) + "CENA:" +space(15)+ "DOBAV./OTK. MESTO"
//   + space(15) + "ULAZ:" + space(15) + "IZLAZ:" 
   @ prow()+1,   2 say replicate( "-", 130 )
   do while ROBA->SIFRA_R = rtrim(  m_sifra ) .AND. !eof()
      set softseek on 
      select CHANGES 
      seek ROBA->SIFRA_R + dtos( from_date ) 
      set softseek off 
      if CH_SIFRA = ROBA->SIFRA_R .and. CH_DATUM <= to_date .and. ! eof()
         sifra = CH_SIFRA
         store 0 to kol_ulaz , kol_izlaz , vred_ulaz , vred_izlaz
         do p_kart 
         ul_genvred = ul_genvred + vred_ulaz
         iz_genvred = iz_genvred + vred_izlaz
      endif 
      if lastkey() = 27
         exit
      endif
      select ROBA
      skip 
   enddo
   @  prow()+1,  2  say replicate( "-", 130)
   @  prow()+1,  5  say 'S V E G A:    '
     @ prow(), 25 say kol_ulaz  picture '9999999999.999'
   @ prow(), 39 say kol_izlaz picture '9999999999.999'
//   @ prow(), 83 say vred_ulaz   picture '99999999999999.999'
//   @ prow(), 102 say vred_izlaz picture '99999999999999.999'
   @  prow()+2,  5  say 'S A L D O:    '
   @ prow(), 30 say kol_ulaz-kol_izlaz picture '9999999999.999'
//   @ prow(), 95 say vred_ulaz-vred_izlaz picture '999999999999999.99'
   @ prow()+1, 0 say chr(27) + "@" 
   @ prow() + 1 ,0 say ''
   cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
   set device to screen
      select ROBA
   set order to 1
close all
return


procedure p_kart
do while CH_SIFRA = sifra .AND. CH_DATUM <= to_date .AND. ! eof()
   do case
      case CH_STATUS = "U"
           kol_ulaz = kol_ulaz + CH_KOL
              vred_ulaz = vred_ulaz + ch_kol*CH_CENA
           col = 25
      case CH_STATUS = "I"
      	   kol_izlaz = kol_izlaz + CH_KOL
              vred_izlaz = vred_izlaz + ch_kol*CH_CENA
            col = 39
   endcase
   if prow() >= 55
      eject
      setprc(0,0)
      @ prow()+1,0 say ' '
      page = page + 1
//      do p_zag
	  do p_subh
   endif
   @ prow()+1,  2   say dtoc( CH_DATUM ) + space(3) + CH_DOKUM
   @ prow()  ,  col say CH_KOL picture '9999999999.99'
   if CH_KOL<>0.00 .AND. substr( CH_DOKUM, 1, 2 ) != 'PR'
   @ prow()  ,  60  say CH_CENA picture '9999999999999.999'
   endif  
   do case
      case CH_STATUS = "U"
      @ prow(), 90  say ch_faktura
//   if substr( CH_DOKUM, 1, 2 ) != 'PR' .AND. CH_KOL<>0.00
//      @ prow(), 84  say CH_CENA*CH_KOL picture '9999999999999.999'
//   else
//      @ prow(), 84 say CH_CENA picture '9999999999999.999'
//   endif

   case CH_STATUS = "I"
      @ prow(), 90  say MESTA->naziv_m
//  if substr( CH_DOKUM, 1, 2 ) != 'PR' .AND. CH_KOL<>0.00
//      @ prow(), 103  say CH_CENA*CH_KOL picture '9999999999999.999'
//   else
//      @ prow(), 103 say CH_CENA picture '9999999999999.999'
//   endif
   endcase
   skip
enddo
return

procedure p_zag
//@ prow()+1, 2 say substr(company_name,1,Len_comp_name) + '     '   + rtrim(COMPLINE1) + space( 40 ) + "Datum:   " + dtoc( date() ) + "            Strana    " + str( page, 3, 0 )
@ prow()+1, 2 say replicate('=',120)
return

procedure p_subh
   select ROBA
   seek CHANGES->CH_SIFRA
   @  prow()+2, 2  say "SIFRA: " + CHANGES->CH_SIFRA + space(3) + "NAZIV: " + rtrim( NAZIV_R )   &&+ space(3) + "JEDINICA MERE: " + NZ_JM
   select CHANGES
   @  prow()+1, 2  say replicate( "-", 120 )
   @  prow()+1, 40 say "KOLICINE"
   @  prow(),  100 say "VREDNOST"
   @  prow()+1,  2 say "DATUM:" + space(5) + "DOKUMENT:" + space(12) + "ULAZ:" + space(8) + "IZLAZ:" + space(20) + "CENA:" ;
   + space(15) + "ULAZ:" + space(15) + "IZLAZ:" 
   @ prow()+1,   2 say replicate( "-", 120 )
return

****************************************************
*ZALIHE NA DAN
**********************************************


procedure l_zaldan

clear screen
@ 1,0,22,79 box background
@ 00, 00 say center( "Pregled zaliha na dan" )
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Esc  Izlaz" )
save screen to scr1


select 2
if NET_USE ( 'ROBA', .F. )
   set index to r_name,r_no
else
  clos all
  RETURN   
endif

select 1
if net_use( "CHANGES", .F. )
   set index to ch_sd, ch_ds, ch_dokum
else
   close all
   return
endif

to_date = date()
from_date = ctod( '01.01.' + substr( dtos( to_date ), 1, 4 ) )
m_sifra = space(6)
status_sifre = space(1)
iz_kol=0
ul_kol=0
iz_vred=0
ul_vred=0
rec_listed=0
ukv=0
zc=0.00
cena='P'
do while .T.
do whole_screen with "Pregled zaliha na dan"
 //  restore screen from scr1
   select CHANGES
   @ 3, 0 to 3, 79
   @ 2, 2 say "Datum:" get from_date
   @ 2, 20 say "Do:" get to_date
   read
   if lastkey() = 27
      close all
      return
   endif
   where="E"
   @ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get where picture "!"
read
if where='P'
do stampza
exit
endif
@ 1,0 clear to 3, 79
   key_date = from_date
   if key_date > to_date
      ?? chr(7)
      *set color to i+
      set cursor off
      @ 2, 0 say center( "Ne postoje podaci koji zadovoljavaju dati uslov! Pritisnite ENTER." )
      inkey(0)
      set cursor on
      *set color to
      loop
   endif
   text = "Stanje zaliha artikala na dan "+ dtoc( to_date )
   @ 1, 0 say center (text)
   @ 2, 3 say " Sifra:   Naziv:                Cena:          Kolicina:         Vrednost:"
   @ 3, 2 to 20, 77
   *set color to
save screen to ekran
   select ROBA
//      seek rtrim( status_sifre + m_sifra )
//  if found()
//  do while nz_sifra=rtrim( status_sifre + m_sifra )	.and. !eof()
  do while  !eof()

  select CHANGES
   set softseek on
   seek ROBA->SIFRA_R+dtos(from_date)
   set softseek off
	  do while ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
	  DO CASE
	  case CH_STATUS = "U"
         ul_kol=ul_kol+ CH_KOL 
            ul_vred=ul_vred+(ch_kol*ch_cena)
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
      iz_vred=iz_vred+(ch_kol*ch_cena)
   endcase
   skip
   enddo

   do disp_zal
	  if rec_listed=16
	  set cursor off
	  rec_listed=0
           @ 23,  0 say centermsg( 'Bilo sta za nastavak, ESC -> Izlaz' )
		   inkey(0)
		   if lastkey()=27
	  set cursor on
     close all
     return
         endif
		 do whole_screen with "Pregled zaliha na dan"
//restore screen from ekran
endif
   select ROBA
   skip
 enddo
 
    set cursor off
    @ 20, 26 say  "   *** Kraj podataka ***   " 
    @ 21, 40 say "S A L D O : " 
    @ 21, 62 say ukv picture '@E 999,999,999.99'
     @ 23,  0 say centermsg( 'ESC -> Izlaz' )
	inkey(0)
ukv=0
rec_listed=0
	set cursor on
enddo       
close all	 
return



procedure disp_zal
//      @ 4 + rec_listed, 4 say NAZIVI->NZ_SIFRA
      @ 4 + rec_listed, 4 say substr(roba->naziv_r,1,25)
*	  if ul_kol+iz_kol<>0
*	  @ 4 + rec_listed, 37 say (ul_vred+iz_vred)/(ul_kol+iz_kol) picture '@E 999,999.999'
      @ 4 + rec_listed, 31 say roba->cena_r picture '@E 999,999.999'
//      @ 4 + rec_listed, 31 say ul_vred/ul_kol picture '@E 999,999.999'
	  @ 4 + rec_listed, 47 say ul_kol-iz_kol picture '@E 999,999,999.99'
	  @ 4 + rec_listed, 62 say (ul_kol-iz_kol)*roba->cena_r picture '@E 999,999,999.99'
//      @ 4 + rec_listed, 62 say ul_vred-iz_vred picture '@E 999,999,999.99'
//ukv=ukv+(ul_vred-iz_vred)
ukv=ukv+((ul_kol-iz_kol)*roba->cena_r)
iz_kol=0
ul_kol=0
iz_vred=0
ul_vred=0
	  
     rec_listed=rec_listed+1

return



****************************************************************
** STAMPA ZALIHA NA DAN
****************************************************************

procedure stampza

@ 1,0 clear to 3, 79
   key_date = from_date
   if key_date > to_date
      ?? chr(7)
      *set color to i+
      set cursor off
      @ 2, 0 say center( "Ne postoje podaci koji zadovoljavaju dati uslov! Pritisnite ENTER." )
      inkey(0)
      set cursor on
      *set color to
      return
   endif
   text = "Stanje zaliha artikala na dan "+ dtoc( to_date )&& +" sa sifrom "+status_sifre + m_sifra
   set device to print
//   @ prow()+1, 0 say rtrim(COMPline1)
   @ prow() +1, 0 say center (text)
   @ prow() +1, 0 say replicate ('-',85)
   @ prow() +2, 3 say " Naziv:                              Cena:        Kolicina:       Vrednost:"
   @ prow() +1, 0 say replicate ('-',85)
   select ROBA
//      seek rtrim( status_sifre + m_sifra )
//  if found()
  do while  !eof()

  select CHANGES
   set softseek on
   seek ROBA->SIFRA_R+dtos(from_date)
   set softseek off
	  do while ch_sifra=roba->sifra_r .and. ch_datum <=to_date .and. !eof()
   do case
      case CH_STATUS = "U"
         ul_kol=ul_kol+ CH_KOL 
            ul_vred=ul_vred+(ch_kol*ch_cena)
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
      iz_vred=iz_vred+(ch_kol*ch_cena)
      zc=ch_cena
   endcase
   skip
   enddo

   do dispst_zal

   select ROBA
   skip
 enddo
 
   @ prow() +1, 0 say replicate ('-',85)
    @ prow() +2, 38 say "SALDO VREDNOSTI: " 
    @ prow() , 70 say ukv picture '@E 99,999,999,999.99'
   @ prow() +1, 0 say " "
   cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
   set device to screen
      set cursor on
return

procedure dispst_zal
	  if ul_kol-iz_kol<>0.000
      @ prow()+1,1 say substr(ROBA->naziv_r,1,30)
//	  if ul_kol<>0
      @ prow(),35 say ROBA->cena_r picture '@E 999,999.99'
//	  @ prow() , 35 say ul_vred/ul_kol picture '@E 999,999.99'
//      endif
	  @ prow() , 50 say ul_kol-iz_kol picture '@E 999,999,999.99'
	  @ prow() , 70 say (ul_kol-iz_kol)*ROBA->cena_r picture '@E 999,999,999.99'
//      @ prow() , 70 say ul_vred-iz_vred picture '@E 99,999,999,999.99'
ukv=ukv+((ul_kol-iz_kol)*ROBA->cena_r)
iz_kol=0
ul_kol=0
iz_vred=0
ul_vred=0
      endif
iz_kol=0
ul_kol=0
iz_vred=0
ul_vred=0
return

procedure po_mestu
where='E'
   @ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get where picture "!"
read
if where!="E"
do stampa_karte
      close all
      return
   endif
   ispis=4
   text = "Promet od " + dtoc( from_date ) + " do " + dtoc( to_date ) + ' za '+ROBA->naziv_r   
   @ 22, 0 to 24, 79
   @ 23, 0 say centermsg( "Bilo sta za nastavak, Esc - Izlaz" )
   @ 2, 3 say " Datum:   Sifra:     Ulaz:     Izlaz:      Cena:      Vr.ulaz    Vr.izlaz"
   @ 0, 0 say center( text )
   @ 3, 2 clear to 20, 79
   @ 3, 2 to 20, 79
   save screen to scr
   select CHANGES
   set order to 2
   set softseek on
   seek m_sifdob+m_sifra+dtos(from_date)
   set softseek off
   do while ch_dob=m_sifdob .and. ch_sifra=m_sifra .and. ch_datum<=to_date
   do case
      case CH_STATUS = "U"
		   u_kol=u_kol+ch_kol
           @ ispis, 4 say CH_datum
           @ ispis, 18 say CH_KOL picture '99999999.99'
           @ ispis, 29 say space(11) 
  		   @ ispis, 40 say transform( CH_CENA, '999999999.99' )
		   @ ispis, 53 say transform( CH_CENA*CH_KOL, '999999999.99' )
		   u_vr=u_vr+ch_cena*ch_kol
      case CH_STATUS = "I"
		   i_kol=i_kol+ch_kol
           @ ispis, 4 say CH_datum
           @ ispis, 29 say CH_KOL picture '99999999.99'
           @ ispis, 18 say space(11) 
		   @ ispis, 40 say transform( CH_CENA, '999999999.99' )
		   @ ispis, 66 say transform( CH_CENA*CH_KOL, '999999999.99' )
		   i_vr=i_vr+ch_cena*ch_kol
   endcase
   ispis=ispis+1
   if ispis>=20
   inkey(0)
   ispis=4
   restore screen from scr
   if lastkey() = 27
      close all
      return
   endif
   endif
   skip
   enddo

   @ 20, 18 say U_KOL picture '99999999.99'
   @ 20, 29 say I_KOL picture '99999999.99'
   @ 20, 52 say  u_vr picture '999999999.99'
   @ 20, 66 say  i_vr picture '999999999.99'
   @ 21, 4 say  "SALDO"
   @ 21, 24 say  u_kol-i_kol picture '999999999.99'
inkey(0)
return

procedure stampa_karte
set device to print
   @ prow()+1, 10 say "Za mesto: " +kart[tekuci]
   @ prow()+1, 10 say "Promet od " + dtoc( from_date ) + " do " + dtoc( to_date ) + ' za '+ROBA->naziv_r 
   @ prow()+1, 3 say " Datum:              Ulaz:     Izlaz:      Cena:      Vr.ulaz    Vr.izlaz"
   @ prow() +1, 0 say replicate ('-',80)
   select CHANGES
   set order to 2
   set softseek on
   seek m_sifdob+m_sifra+dtos(from_date)
   set softseek off
   do while ch_dob=m_sifdob .and. ch_sifra=m_sifra .and. ch_datum<=to_date
   do case
      case CH_STATUS = "U"
		   u_kol=u_kol+ch_kol
           @ prow()+1,0 say CH_datum
           @ prow(), 13 say substr(CH_dokum,1,5)
           @ prow(), 18 say CH_KOL picture '99999999.99'
  		   @ prow(), 40 say transform( CH_CENA, '999999999.99' )
		   @ prow(), 53 say transform( CH_CENA*CH_KOL, '999999999.99' )
		   u_vr=u_vr+ch_cena*ch_kol
      case CH_STATUS = "I"
		   i_kol=i_kol+ch_kol
           @ prow()+1,0 say CH_datum
           @ prow(), 13 say substr(CH_dokum,1,5)
           @ prow(), 29 say CH_KOL picture '99999999.99'
		   @ prow(), 40 say transform( CH_CENA, '999999999.99' )
		   @ prow(), 66 say transform( CH_CENA*CH_KOL, '999999999.99' )
		   i_vr=i_vr+ch_cena*ch_kol
   endcase
   if prow()>=65
   eject
   endif
   skip
   enddo

   @ prow() +1, 0 say replicate ('-',80)
   @ prow()+1,1 say 'SVEGA: '
   @ prow(), 18 say U_KOL picture '99999999.99'
   @ prow(), 29 say I_KOL picture '99999999.99'
   @ prow(), 52 say  u_vr picture '999999999.99'
   @ prow(), 66 say  i_vr picture '999999999.99'
   @ prow()+1, 4 say  "SALDO"
   @ prow(), 24 say  u_kol-i_kol picture '999999999.99'
   cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return


procedure fill_mesta
parameters desc  
go top
last = 1
do while !eof()
   kart [ last ] = naziv_m
   kart_no [ last ] = recno()
   if last=desc
         tekuci = last
   endif
   last = last + 1
   skip
enddo

kart [ last ] = '*** Sva otkupna mesta ****'

for i = last + 1 to 1000
    kart [ i ] = ''
next
return

procedure nab
max=1000
declare roba [ 1000 ]
declare roba_no[ 1000 ]

declare ime[12]
declare dok[12]
clear screen
@ 1,0,22,79 box background
@ 00, 00 say center( "Pregled nabavke robe" )
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Esc - Izlaz" )
save screen to scr1
			       
declare documents [ 20 ]
declare rec_no [ 20 ]

select 3
if NET_USE ( 'NAB', .T. )
   set index to nabs
else
  clos all
  RETURN   
endif
zap
reindex
select 2
if NET_USE ( 'ROBA', .F. )
   set index to r_name
else
  clos all
  RETURN   
endif

select 1
 if net_use( "CHANGES", .F. )
   set index to ch_sd, ch_dob
else
   close all
   return
endif

m_sifra = space(3)
do while .T.
from_date = ctod( '01.01.' + substr( dtos( date() ), 1, 4 ) )
to_date=date()
do whole_screen with "Pregled nabavke robe"
//   restore screen from scr1
   select ROBA
   la = 1
curr = 1
do rfill_roba with la
   @ 3, 0 to 3, 79
   @ 2, 2 say "Od:" get from_date
   @ 2, 17 say "Do:" get to_date
   read
//@ 2, 18 clear to 20, 62
//@ 2, 18 to 20, 62 double
do whole_screen with "Pregled nabavke robe"
  curr = achoice(3,20,19,60,roba,.T.,'',curr,curr-1)
  do case
     case curr !=0
	 select ROBA
	 go roba_no[curr]
	 m_sifra=sifra_r
	 do list
     case curr = 0
          close all
          clear screen
          return
  endcase
  enddo

  procedure list
set device to print
svega=0
xkol=0
@ prow()+1,1 say center('Pregled nabavke robe za '+rtrim(ROBA->naziv_r))
@ prow()+1,1 say center('za period '+dtoc(from_date)+'-'+dtoc(to_date))
   @ prow() +2, 0 say replicate ('-',65)
   @ prow() +1, 3 say " Datum        Kolicina:             Cena:          Vrednost:"
   @ prow() +1, 0 say replicate ('-',65)
  select CHANGES
   set softseek on
   seek m_sifra+dtos(from_date)
   set softseek off
   do while ch_sifra=m_sifra .and. ch_datum<=to_date .and. !eof()
   if ch_status='U'
   @ prow()+1,0 say ch_datum
   @ prow(),15 say ch_kol picture '999999999.99'
   @ prow(),30 say ch_cena picture '999999999.99'
   @ prow(),50 say ch_kol*ch_cena picture '999999999.99'
   select NAB
   seek CHANGES->ch_sifra+str(CHANGES->ch_cena)
   if found()
   do req_rec_lock
   replace kol with kol+CHANGES->ch_kol
   else 
   do new_rec
   replace sifra with CHANGES->ch_sifra,cena with CHANGES->ch_cena,  kol with kol+CHANGES->ch_kol
   endif
   endif
  select CHANGES
  skip
  enddo
   select NAB
   go top
   do while !eof()
//   @ prow()+1,10 say kol picture '999999999.99'
 //  @ prow(),30 say cena picture '999999999.99'
//   @ prow(),50 say kol*cena picture '999999999.99'
	svega=svega+kol*cena
	xkol=xkol+kol
	skip
	enddo
   @ prow() +1, 0 say replicate ('-',65)
   @ prow() +1, 0 say 'SVEGA:'
   @ prow(),15 say xkol picture '999999999.99'
   @ prow(),50 say svega picture '999999999.99'
   @ prow() +1, 0 say '    '
   cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen


return




************************************************
*ZBIRNI PREGLED
************************************************
procedure zbir
setcolor(DEF_RED)
#include "box.ch"
@ 00, 00 say center( "Pregled salda voca i robe")
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'ROBA', .F. )
   set index to r_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'ZADUZ', .F. )
   set index to zad_rd, zad_sd
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'VOCE', .F. )
   set index to v_name,v_no
else
  clos all
  RETURN   
endif

select 6
if NET_USE ( 'OTKUP', .F. )
   set index to otk_vd,otk_ss
else
  clos all
  RETURN   
endif
select 7
if NET_USE ( 'TMPK2', .T. )
file1='tmpk2'
ind1='tmp2'
set index to tmp2
zap
else
  clos all
  RETURN   
endif

select 8
if NET_USE ( 'AMB', .F. )
   set index to amb_ss,amb_sds
else
  clos all
  RETURN   
endif
select 9
if NET_USE ( 'COMPANY', .F. )
endif

select 10
if NET_USE ( 'OBAV', .F. )
   set index to ob_sd,ob_dat
else
  clos all
  RETURN   
endif

****************************************************
save screen to cScreen1
MAX=1000
declare ROBA [ MAX ]
declare ROBA_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]
ox = 1
do w_mes with ox
tek = 1
do while .T.
do red_screen with  "Pregled salda voca i robe"
current = 1
if ox<100
zad = 1

do fill_komm with otk_sifra

do red_screen with  "Pregled salda voca i robe"
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra+'   '
	 do pregled_salda with komintent
	 case tek = 0
	 exit
	 otherwise
	 select &file1
	 go rec[tek]
	 komintent=sifra_k
	 do preg_sal1 with komintent
  endcase
  else
  do saldo
  exit
  endif
enddo
clos all
   setcolor(DEFAULT)

return

***********************************************

procedure pregled_salda
parameters w_c

*row()=2
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
ukupno=0.00
svega=0.00
robni1=0.0
robni=0.0
uku_v=0.00
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Saldo/Proizvodjaci (E/P/S/R)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do stampa_salda
return
endif
if stampa='S'
do vred_saldo
return
endif
if stampa='R'
do saldo_proiz with komintent
*clos all
return
endif
@ 1,1 to 1,79
@ 2,0 say center(MESTA->naziv_m)
////////////////////////////////////////////////ovde prenos
@ 3,25 say 'Prepod.:'
@ 3,35 say 'I klasa:'
@ 3,45 say 'II klasa:'
@ 3,55 say 'III klasa:'
@ 3,70 say 'Vrednost:'
@ row()+1,0 say replicate('-',79)
save screen to scr
select OTKUP
   set index to otk_ss,otk_sd
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno=0.00
uku_v=0.00
uku_d=0.00
uku_t=0.00
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
select VOCE
   go top
do while !eof()
select OTKUP
go top
set softseek on
	seek rtrim(w_c)+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
uku_v=uku_v+kol_otk
uku_d=uku_d+raz_otk
uku_t=uku_t+kol_otkii
third=third+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
 	
	skip
enddo
if !empty(uku_v+uku_d+uku_t)
@ row()+1,1 say VOCE->naziv_v
@ row(),22 say uku_v picture '@E 9,999,999.99'
@ row(),33 say uku_d picture '@E 9,999,999.99'
@ row(),44 say uku_t picture '@E 9,999,999.99'
@ row(),54 say third picture '@E 9,999,999.99'
@ row(),65 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 999,999,999.99'
svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
endif

uku_v=0.00
uku_d=0.00
uku_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0

select VOCE
skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA VOCE:                         Kolicina:'
@ row(),65 say svega_v picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)
**********ROBA
suma=0.0
svega=0.0
ukupno=0.00

select ROBA
go top
do while !eof()
select ZADUZ
set order to 2
go top
set softseek on
seek rtrim(w_c)+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off

do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
robni=robni+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
skip
enddo

if !empty(ukupno)
@ row()+1,1 say ROBA->naziv_r
@ row(),30 say ukupno picture '@E 999,999,999.99'
@ row(),65 say suma*(1+ROBA->pdv/100) picture '@E 999,999,999.99'
svega=svega+suma*(1+ROBA->pdv/100)
endif
suma=0.00
ukupno=0.00
robni1=0.0
if row()=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
	 if lastkey()=27
		  return
	  endif
@ 4,0 clear to 19,79
@ 3,1 to 3,79
endif
select ROBA
skip
enddo

@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA ROBA:'
//@ row(),50 say robni picture '@E 99,999,999.99'
@ row(),65 say svega picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SALDO:'
//@ row(),50 say zbir_v-robni picture '@E 99,999,999.99'
@ row(),65 say  svega_v-svega picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'Procenat duga'
@ row(),60 say ((svega_v-svega)*100)/svega_v picture '@E 999.99'
amb_z=0
amb_r=0
  select AMB
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()

//if  substr(amb_sif,1,3)!=substr(w_c,1,3)
//skip
//loop
//	endif
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
skip
enddo
	@ row()+1,0 say 'Ambalaza: '+str(amb_z,5)+'-'+str(amb_r,5)+'='+str(amb_r-amb_z,5)
inkey(0)
select ZADUZ
set order to 1

return
*******************************
procedure preg_sal1
parameters w_c

*row()=2
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
clear screen
restore screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
   suma=0.00
   ukupno=0.00
svega=0.00
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Priz. Akont/Priz. Kon./Dopl. (E/P/R/K/D)" )
//@ 23, 0 say centermsg( "Ekran/Printer/Priznanica (E/P/R)" )
@ 23, 65 get stampa picture '!'
read
if stampa='P'
do prt_salda_poj
*clos all
return
endif
if stampa='R'
do priznanica
return
endif
if stampa='D'
do priz_kon
return
endif
if stampa='K'
do priz_kon_new
return
endif

*set color to
@ 1,1 to 1,79
@ 2,0 say center(rtrim(&file1->ime_k)+' '+rtrim(&file1->mesto_k))
@ 3,25 say 'Prepod.:'
@ 3,35 say 'I klasa:'
@ 3,45 say 'II klasa:'
@ 3,55 say 'III klasa:'
@ 3,70 say 'Vrednost:'
@ row()+1,0 say replicate('-',80)
save screen to scr
select OTKUP
   set index to otk_vd,otk_sd
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
suma=0.00
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
select VOCE
   go top
   vc=cena_v
do while !eof()
*    @ row()+1,0 say naziv_v
*select MESTA
*	go top
*do while !eof()
select OTKUP
go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
//	if sifra_otk!=w_c
//		skip 
//		loop
//	endif
////////////////////////////////////////staro
ukupno_v=ukupno_v+kol_otk
ukupno_d=ukupno_d+raz_otk
ukupno_t=ukupno_t+kol_otkii
third=third+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
	
	skip
enddo

if !empty(ukupno_v+ukupno_d+ukupno_t+third)
@ row()+1,1 say VOCE->naziv_v
@ row(),22 say ukupno_v picture '@E 999,999.99'
@ row(),33 say ukupno_d picture '@E 999,999.99'
@ row(),44 say ukupno_t picture '@E 999,999.99'
@ row(),54 say third picture '@E 999,999.99'
if &file1->pdd='D'
@ row(),65 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
//@ row(),65 say (ukupno_v*VOCE->cena_v+ukupno_d*VOCE->druga+ukupno_t*VOCE->treca+third*VOCE->cetvrta)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
//svega_v=svega_V+(ukupno_v*VOCE->cena_v+ukupno_d*VOCE->druga+ukupno_t*VOCE->treca+third*VOCE->cetvrta)*(1+VOCE->pdv/100)
else
@ row(),65 say (uku_vd+uku_dd+uku_td+thirdd) picture '@E 99,999,999.99'
svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)
//@ row(),65 say (ukupno_v*VOCE->cena_v+ukupno_d*VOCE->druga+ukupno_t*VOCE->treca+third*VOCE->cetvrta) picture '@E 99,999,999.99'
//svega_v=svega_V+(ukupno_v*VOCE->cena_v+ukupno_d*VOCE->druga+ukupno_t*VOCE->treca+third*VOCE->cetvrta)
endif
endif
//zbir_v=zbir_v+ukupno_v
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
select VOCE
skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA VOCE:                         Kolicina:'
@ row(),65 say svega_v picture '@E 99,999,999.99'
@ row()+1,0 say replicate('-',79)


**********ROBA
suma=0.00
svega=0.0
ukupno=0.00

select ROBA
go top
do while !eof()
*@ row()+1,1 say naziv_r
*select MESTA
*go top
*do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off

do while sifra_zad=w_c .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
	suma=suma+kol_zad*ROBA->cena_r  //cena
	ukupno=ukupno+kol_zad
	robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
	robni=robni+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
  skip
enddo

if !empty(ukupno)
		@ row()+1,1 say ROBA->naziv_r
		@ row(),30 say ukupno picture '@E 99,999,999.99'
	if ROBA->pdv=0
		@ row(),65 say suma picture '@E 99,999,999.99'
		svega=svega+suma
	else
		@ row(),65 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
		svega=svega+suma*(1+ROBA->pdv/100)
	endif
endif

suma=0.00
ukupno=0.00
robni1=0.0
if row()=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
	 if lastkey()=27
		  return
	  endif
@ 4,0 clear to 19,79
@ 3,1 to 3,79
endif
select ROBA
skip
enddo

@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA ROBA:'
//@ row(),50 say robni picture '@E 99,999,999.99'
@ row(),65 say svega picture '@E 99,999,999.99'
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SALDO:'
//@ row(),50 say zbir_v-robni picture '@E 99,999,999.99'
@ row(),65 say  svega_v-svega picture '@E 99,999,999.99'
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'Procenat duga'
@ row(),60 say ((svega_v-svega)*100)/svega_v picture '@E 999.99'
amb_z=0
amb_r=0
  select AMB
  set order to 2
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
skip
enddo
	@ row()+1,0 say 'Ambalaza: '+str(amb_z,5)+'-'+str(amb_r,5)+'='+str(amb_r-amb_z,5)
//	@ row(),30 say amb_z picture '@E 999,999'
//	@ row(),50 say amb_r picture '@E 999,999'
//	@ row(),65 say amb_z-amb_r picture '@E 999,999'
inkey(0)
  set order to 1

return

************************************

procedure saldo
clear screen
select ZADUZ
   set index to zad_rd, zad_sd
   set order to 2
   @ 22, 0 to 24, 79
*@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
   suma=0.00
   ukupno=0.00
svega=0.00
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Saldo (E/P/S)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_all_sal
*clos all
return
endif
if stampa='S'
do vred_saldo
*clos all
return
endif
drg=0
raz=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
svega_v=0
@ 1,1 to 1,79
@ 2,25 say 'Kolicina:'
@ 2,65 say 'Vrednost:'
@ row()+1,0 say replicate('-',79)
save screen to scr
select OTKUP
   set index to otk_ss,otk_sd
   suma=0.00
   ukupno=0.00
svega=0.00
select VOCE
   go top
do while !eof()
select MESTA
	go top
do while !eof()
w_c=sifra_m
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

suma=suma+kol_otk*cena1
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
third=third+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
	
	skip
enddo
select MESTA
	skip
enddo

@ row()+1,0 say VOCE->naziv_v
@ row(),20 say ukupno+raz+drg+third picture '@E 999,999,999.99'
@ row(),60 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 999,999,999.99'
svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
drg=0
raz=0.00
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
suma=0.00
ukupno=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
select VOCE
skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),60 say svega_v picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)


**********ROBA
suma=0.00
ukupno=0.00
svega=0.0
third=0
select ROBA
go top
do while !eof()
select MESTA
	go top
do while !eof()
w_c=sifra_m
select ZADUZ

go top
set softseek on
seek rtrim(w_c)+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=w_c .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
skip
enddo
select MESTA
skip
enddo
if !empty(ukupno)
@ row()+1,1 say ROBA->naziv_r
@ row(),45 say ukupno picture '@E 999,999,999.99'
if ROBA->pdv=0
@ row(),65 say suma picture '@E 999,999,999.99'
svega=svega+suma
else
@ row(),65 say suma*(1+ROBA->pdv/100) picture '@E 999,999,999.99'
svega=svega+suma*(1+ROBA->pdv/100)
endif
//@ row(),62 say ukupno*ROBA->cena_r picture '@E 999,999,999.99'
//svega=svega+ukupno*ROBA->cena_r
endif
suma=0.00
ukupno=0.00
if row()=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
	 if lastkey()=27
		  return
	  endif
@ 4,0 clear to 19,79
@ 3,1 to 3,79
endif
select ROBA
skip
enddo

@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),60 say svega picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)
inkey(0)
select ZADUZ
set order to 1

return



************************************
**********************************
*STAMPA
**********************************
procedure stampa_salda
set device to print
@ prow()+1,10 say 'Saldo otkupa voca i robe za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,5 say 'Za otkupno mesto: '+kart[tekuci]
@ prow()+1,0 say replicate('-',79)
@ prow()+1,25 say 'Prepod.:'
@ prow(),35 say 'I klasa:'
@ prow(),45 say 'II klasa:'
@ prow(),55 say 'III klasa:'
@ prow(),70 say 'Vrednost:'
@ prow()+1,0 say replicate('-',79)
select OTKUP
   set index to otk_ss,otk_sd
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
suma=0.00
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
select VOCE
   go top
   vc=cena_v
do while !eof()
//select MESTA
//	go top
//do while !eof()
//w_c=sifra_m+'   '
select OTKUP
	go top
set softseek on
	seek rtrim(w_c)+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno_v=ukupno_v+kol_otk
ukupno_d=ukupno_d+raz_otk
ukupno_t=ukupno_t+kol_otkii
third=third+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
	
	skip
enddo

if !empty(ukupno_v+ukupno_d+ukupno_t)
@ prow()+1,1 say VOCE->naziv_v
@ prow(),22 say ukupno_v picture '@E 9,999,999.99'
@ prow(),33 say ukupno_d picture '@E 9,999,999.99'
@ prow(),44 say ukupno_t picture '@E 9,999,999.99'
@ prow(),54 say third picture '@E 9,999,999.99'
@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
endif
zbir_v=zbir_v+ukupno_v

ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
 select VOCE
skip
enddo

@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA VOCE:                        Kolicina:'
@ prow(),65 say svega_v picture '@E 999,999,999.99'
@ prow()+1,0 say replicate('-',79)


**********ROBA
suma=0.00
ukupno=0.00
svega=0.0
select ROBA
go top
do while !eof()
*@ prow()+1,1 say naziv_r
*select MESTA
*go top
*do while !eof()
select ZADUZ
set order to 2
go top
set softseek on
seek rtrim(w_c)+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
robni=robni+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
if !empty(ukupno)
@ prow()+1,1 say ROBA->naziv_r
@ prow(),30 say ukupno picture '@E 999,999,999.99'
//@ prow(),50 say robni1 picture '@E 999,999,999.99'
if ROBA->pdv=0
@ prow(),65 say suma picture '@E 999,999,999.99'
svega=svega+suma
else
@ prow(),65 say suma*(1+ROBA->pdv/100) picture '@E 999,999,999.99'
svega=svega+suma*(1+ROBA->pdv/100)
endif
//@ prow(),65 say ukupno*ROBA->cena_r picture '@E 999,999,999.99'
//svega=svega+ukupno*ROBA->cena_r
endif
suma=0.00
ukupno=0.00
robni1=0.0
select ROBA
skip
enddo

@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA ROBA:'
//@ prow(),50 say robni picture '@E 99,999,999.99'
@ prow(),65 say svega picture '@E 999,999,999.99'
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SALDO:'
//@ prow(),50 say zbir_v-robni picture '@E 99,999,999.99'
@ prow(),65 say svega_v-svega picture '@E 999,999,999.99'
*@ prow(),65 say (zbir_v-robni)*vc picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'Procenat duga'
@ prow(),60 say ((svega_v-svega)*100)/svega_v picture '@E 999.99'
*@ prow(),60 say (((zbir_v-robni)*vc)/svega_v)*100 picture '@E 999.99'
amb_z=0
amb_r=0
  select AMB
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
skip
enddo
	@ prow()+1,0 say 'Ambalaza: '+str(amb_z,5)+'-'+str(amb_r,5)+'='+str(amb_r-amb_z,5)
//	@ row(),30 say amb_z picture '@E 999,999'
//	@ row(),50 say amb_r picture '@E 999,999'
//	@ row(),65 say amb_z-amb_r picture '@E 999,999'
//////////////////////////////////////////
@ prow()+3,67 say '  '
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
select ZADUZ
set order to 1

return

***************************************

procedure prt_salda_poj
set device to print
@ prow()+1,10 say 'Saldo otkupa voca i robe za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',100)
@ prow()+1,1 say 'Otkupno mesto: ' +rtrim(kart[tekuci])+' - '+rtrim(komm[tek])
@ prow()+1,0 say replicate('-',100)
@ prow()+1,25 say 'Prepod.:'
@ prow(),35 say 'I klasa:'
@ prow(),45 say 'II klasa:'
@ prow(),55 say 'III klasa:'
@ prow(),70 say 'Iznos sa PDV:'
@ prow()+1,0 say replicate('-',100)
select OTKUP
   set index to otk_vd,otk_sd
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
suma=0.00
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
select VOCE
   go top
   vc=cena_v
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno_v=ukupno_v+kol_otk
ukupno_d=ukupno_d+raz_otk
ukupno_t=ukupno_t+kol_otkii
third=third+kol4	
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
	skip
enddo

if !empty(ukupno_v+ukupno_d+ukupno_t+third)
@ prow()+1,1 say VOCE->naziv_v
@ prow(),22 say ukupno_v picture '@E 999,999.99'
@ prow(),33 say ukupno_d picture '@E 999,999.99'
@ prow(),44 say ukupno_t picture '@E 999,999.99'
@ prow(),54 say third picture '@E 999,999.99'
if &file1->pdd='D'
@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
else
@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd) picture '@E 99,999,999.99'
svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)
endif
endif
zbir_v=zbir_v+ukupno_v

ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
 select VOCE
skip
enddo

@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SVEGA VOCE:                        '
@ prow(),65 say svega_v picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',100)


**********ROBA

@ prow()+1,0 say replicate('-',100)
@ prow()+1,2 say 'Naziv:'
@ prow(),25 say 'Kolicina:'
@ prow(),37 say 'Cena :'
@ prow(),45 say 'Osnovica:'
@ prow(),58 say 'Stopa:'
@ prow(),69 say 'PDV:'
@ prow(),82 say 'Ukupno:'
@ prow()+1,0 say replicate('-',100)
suma=0.00
ukupno=0.00
svega=0.0

select ROBA
go top
do while !eof()
*@ prow()+1,1 say naziv_r
*select MESTA
*go top
*do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
cena1=ROBA->cena_r
//if empty(ROBA->odn)			
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
robni=robni+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
if !empty(ukupno)
@ prow()+1,1 say substr(ROBA->naziv_r,1,20)
@ prow(),25 say ukupno picture '@E 999,999.99'
@ prow(),35 say cena1*(1+ROBA->pdv/100) picture '@E 9,999.99'
@ prow(),45 say suma*(1+ROBA->pdv/100) picture '@E 999,999.99'
@ prow(),60 say ROBA->pdv picture '99'
@ prow(),65 say suma*(ROBA->pdv/100) picture '@E 99,999.99'
if ROBA->pdv=0
@ prow(),80 say suma picture '@E 9,999,999.99'
svega=svega+suma
else
@ prow(),80 say suma*(1+ROBA->pdv/100) picture '@E 9,999,999.99'
svega=svega+suma*(1+ROBA->pdv/100)
endif
endif
cena1=0.00
suma=0.00
ukupno=0.00
robni1=0.0
select ROBA
skip
enddo

@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SVEGA ROBA:'
//@ prow(),50 say robni picture '@E 99,999,999.99'
@ prow(),80 say svega picture '@E 9,999,999.99'
@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'SALDO:'
//@ prow(),50 say zbir_v-robni picture '@E 99,999,999.99'
@ prow(),65 say svega_v-svega picture '@E 99,999,999.99'
*@ prow(),65 say (zbir_v-robni)*vc picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',100)
@ prow()+1,0 say 'Procenat duga'
@ prow(),60 say ((svega_v-svega)*100)/svega_v picture '@E 999.99'
*@ prow(),60 say (((zbir_v-robni)*vc)/svega_v)*100 picture '@E 999.99'
amb_z=0
amb_r=0
  select AMB
  set order to 2
set softseek on
seek rtrim(w_c)+DTOS(DATUM1)
set softseek off
do while  amb_sif=rtrim(w_c) .and. amb_datum<=datum2 .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
skip
enddo
	@ prow()+1,0 say 'Ambalaza: '+str(amb_z,5)+'-'+str(amb_r,5)+'='+str(amb_r-amb_z,5)
//	@ row(),30 say amb_z picture '@E 999,999'
//	@ row(),50 say amb_r picture '@E 999,999'
//	@ row(),65 say amb_z-amb_r picture '@E 999,999'
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
  set order to 1

return

***************************************

procedure prt_all_sal
@ 1,1 to 1,79
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
svega_v=0
set device to print
  @ prow()+1, 1 say chr(27) + '@'
//  @ prow()+1, 1 say chr(27) + chr(15)
@ prow()+1,10 say 'Saldo otkupa voca i robe za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,30 say 'Za sva otkupna mesta'
@ prow()+1,0 say replicate('-',79)
@ prow()+1,25 say 'Prepod.:'
@ prow(),35 say 'I klasa:'
@ prow(),45 say 'II klasa:'
@ prow(),55 say 'III klasa:'
@ prow(),70 say 'Vrednost:'
@ prow()+1,0 say replicate('-',79)
select OTKUP
   set order to 2
   suma=0.00
   ukupno=0.00
svega=0.00
select VOCE
   go top
do while !eof()
*    @ prow()+1,0 say naziv_v
select MESTA
	go top
do while !eof()
w_c=sifra_m
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno_v=ukupno_v+kol_otk
ukupno_d=ukupno_d+raz_otk
ukupno_t=ukupno_t+kol_otkii
third=third+kol4
uku_vd=uku_vd+kol_otk*cena1
uku_dd=uku_dd+raz_otk*cena2
uku_td=uku_td+kol_otkii*cena3
thirdd=thirdd+kol4*cena4
	
	skip
enddo

select MESTA
	skip
enddo
if !empty(ukupno_v+ukupno_d+ukupno_t)
@ prow()+1,1 say VOCE->naziv_v
@ prow(),22 say ukupno_v picture '@E 9,999,999.99'
@ prow(),33 say ukupno_d picture '@E 9,999,999.99'
@ prow(),44 say ukupno_t picture '@E 9,999,999.99'
@ prow(),54 say third picture '@E 9,999,999.99'
@ prow(),67 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 999,999,999.99'
svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
endif

ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
if prow()>=65
eject
@ prow()+1,0 say replicate('-',79)
@ prow()+1,50 say 'Kolicina:'
@ prow(),65 say 'Vrednost:'
@ prow()+1,0 say replicate('-',79)
endif
select VOCE
skip
enddo
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA:'
@ prow(),65 say svega_v picture '@E 999,999,999.99'
@ prow()+1,0 say replicate('-',79)


**********ROBA
suma=0.00
ukupno=0.00
svega=0.0
select ROBA
go top
do while !eof()
select MESTA
go top
do while !eof()
w_c=sifra_m+'   '
select ZADUZ
go top
set softseek on
seek rtrim(w_c)+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
skip
enddo
select MESTA
skip
enddo
if !empty(ukupno)
@ prow()+1,1 say ROBA->naziv_r
@ prow(),45 say ukupno picture '@E 999,999,999.99'
if ROBA->pdv=0
@ prow(),65 say suma picture '@E 999,999,999.99'
svega=svega+suma
else
@ prow(),65 say suma*(1+ROBA->pdv/100) picture '@E 999,999,999.99'
svega=svega+suma*(1+ROBA->pdv/100)
endif
//@ prow(),62 say ukupno*ROBA->cena_r picture '@E 999,999,999.99'
//svega=svega+ukupno*ROBA->cena_r
endif
if prow()>=65
eject
@ prow()+1,0 say replicate('-',79)
@ prow()+1,50 say 'Kolicina:'
@ prow(),65 say 'Vrednost:'
@ prow()+1,0 say replicate('-',79)
endif
*@ prow()+1,1 to prow()+1,79
*prow()=prow()+1
suma=0.00
ukupno=0.00
select ROBA
skip
enddo

@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA:'
@ prow(),62 say svega picture '@E 999,999,999.99'
@ prow()+1,0 say replicate('-',79)
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return
***********************************************
procedure knjiz
clear screen
*set color to i
@ 00, 00 say center( "Pregled knjizenja")  
*set color to
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
save screen to screen1

select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'ROBA', .F. )
   set index to r_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'ZADUZ', .F. )
   set index to zad_ds
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'VOCE', .F. )
   set index to v_no
else
  clos all
  RETURN   
endif

MAX=1000
declare ROBA [ MAX ]
declare ROBA_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]
ox = 1					
do while .T.
do red_screen with "Pregled knjizenja"
  //restore screen from screen1
current = 1
do w_mes with ox
if ox<100
zad = 1
tek = 1
 *	 do lista with otk_sifra
 *	 if lastkey()=27
 *		  exit
 *	  endif
do w_kom with otk_sifra
do red_screen with "Pregled knjizenja"
  //restore screen from screen1
  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
  do case
     case tek =zad
	 komintent=otk_sifra
	 do lista with komintent
	 case tek = 0
	 exit
	 otherwise
	 go rec[tek]
	 komintent=sifra_k
	 do lista1 with komintent
  endcase
  endif
  enddo
  clos all
  return


  procedure lista
  parameters komint
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak... ESC - Izlaz" )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
**set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_knjiz
*clos all
return
endif
@ 1,1 to 1,79
@ 2,1 say '  Datum     Dokument           Kolicina            Roba'   
@ 3,1 to 3,79
  select ZADUZ
set softseek on
seek DTOS(DATUM1)
set softseek off
do while   datum_zad<=datum2 .and. !eof()
if  substr(sifra_zad,1,3)!=komint
skip 
loop
endif

if kol_zad<>0.00
	@ row()+1,1 say datum_zad
	@ row(),15 say doc_zad
	@ row(),26 say kol_zad picture '@E 99,999,999.99'
		select ROBA
			seek ZADUZ->sifra_zar
	if found()
		@ row(),50 say ROBA->naziv_r
	endif
endif

if row()=19
inkey(0)
	 if lastkey()=27
*		  exit
		  return
	  endif
@ 4,0 clear to 19,79
@ 3,1 to 3,79
endif

*@ 2,1 clear to 19,79
select ZADUZ
skip
enddo
inkey(0)
return

  procedure lista1
  parameters komint
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak... ESC - Izlaz" )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
**set color to
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_knj_poj
*clos all
return
endif
@ 1,1 to 1,79
@ 2,1 say '  Datum     Dokument           Kolicina            Roba'   
@ 3,1 to 3,79
  select ZADUZ
set softseek on
seek DTOS(DATUM1)
set softseek off
do while   datum_zad<=datum2 .and. !eof()
if  sifra_zad!=komint
skip 
loop
endif

if kol_zad<>0.00
	@ row()+1,1 say datum_zad
	@ row(),15 say doc_zad
	@ row(),26 say kol_zad picture '@E 99,999,999.99'
		select ROBA
			seek ZADUZ->sifra_zar
	if found()
		@ row(),50 say ROBA->naziv_r
	endif
endif

if row()=19
inkey(0)
	 if lastkey()=27
*		  exit
		  return
	  endif
@ 4,0 clear to 19,79
@ 3,1 to 3,79
endif

*@ 2,1 clear to 19,79
select ZADUZ
skip
enddo
inkey(0)
return
*********************************************
**STAMPA KNJIZENJA

procedure prt_knjiz

set printer to stampa.prn
set device to print
select MESTA
go rec_no[tekuci]

@ prow()+1,10 say 'Pregled knjizenja robe za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,5 say 'Za otkupno mesto '+substr(MESTA->sifra_m,2,2)+' '+rtrim(MESTA->naziv_m)
*@ prow()+1,30 say 'Za otkupno mesto '+kart[tekuci]
@ prow()+1,0 say replicate('-',79)
@ prow()+1,1 say '  Datum     Dokument           Kolicina            Roba'   
@ prow()+1,0 say replicate('-',79)
  select ZADUZ
set softseek on
seek DTOS(DATUM1)
set softseek off
do while   datum_zad<=datum2 .and. !eof()
if  substr(sifra_zad,1,3)!=komint
skip 
loop
endif

if kol_zad<>0.00
	@ prow()+1,1 say datum_zad
	@ prow(),15 say doc_zad
	@ prow(),26 say kol_zad picture '@E 99,999,999.99'
		select ROBA
			seek ZADUZ->sifra_zar
	if found()
		@ prow(),50 say ROBA->naziv_r
	endif
endif

if prow()>=65
@ prow()+1,0 say replicate('-',79)
eject
endif

select ZADUZ
skip
enddo
@ prow()+1,0 say replicate('-',79)
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

procedure prt_knj_poj
set device to print
select MESTA
go rec_no[tekuci]
@ prow()+1,10 say 'Pregled knjizenja robe za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,5 say substr(MESTA->sifra_m,2,2)+' '+rtrim(MESTA->naziv_m)+'-'+substr(komint,2,5)+' '+komm[tek]
@ prow()+1,0 say replicate('-',79)
@ prow()+1,1 say '  Datum     Dokument           Kolicina            Roba'   
@ prow()+1,0 say replicate('-',79)
  select ZADUZ
set softseek on
seek DTOS(DATUM1)
set softseek off
do while   datum_zad<=datum2 .and. !eof()
if  sifra_zad!=komint
skip 
loop
endif

if kol_zad<>0.00
	@ prow()+1,1 say datum_zad
	@ prow(),15 say doc_zad
	@ prow(),26 say kol_zad picture '@E 99,999,999.99'
		select ROBA
			seek ZADUZ->sifra_zar
	if found()
		@ prow(),50 say ROBA->naziv_r
	endif
endif

if prow()>=65
@ prow()+1,0 say replicate('-',79)
eject
endif

select ZADUZ
skip
enddo
@ prow()+1,0 say replicate('-',79)
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

*******************************
**SALDO PO VREDNOSTI
************************************
procedure vred_saldo
setcolor(DEF_RED)
@ 00, 00 say center( "Pregled vrednosnog salda voca i robe")
*declare voce [ MAX ]
*declare voce_no[ MAX ]
   select VOCE
   suma=0.00
   ukupno=0.00
svega=0.00
robni1=0.0
robni=0.0
uku_v=0.00
ukupno_r=0.00
svega_r=0.0
robni1=0.00
robni=0.0
c_v=0.0
*set color to i
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_vred_salda
*clos all
return
endif
*set color to
@ 1,1 to 1,79
@ 2,35 say 'Malina:'
@ 2,50 say 'Roba:'
@ 2,65 say 'Saldo  :'
@ row()+1,0 say replicate('-',79)
save screen to scr
c_v=1.0
suma=0.00
ukupno=0.00
svega=0.00

select MESTA
	go top
do while !eof()
w_c=sifra_m
   select VOCE
      go top
       do while !eof()
		select OTKUP
   set index to otk_ss
				set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

svega=svega+(kol_otk*cena1+raz_otk*cena2+kol_otkii*cena3+kol4*cena4)*(1+VOCE->pdv/100)
	
	skip
enddo

	select VOCE
	   skip
	enddo
ukupno=ukupno+svega
//svega=0

	
select ROBA
go top
do while !eof()
	
	
select ZADUZ
set order to 2
go top
set softseek on
seek rtrim(w_c)+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

//ukupno_r=ukupno_r+kol_zad

//if empty(ROBA->odn)
//	robni1=robni1+kol_zad*ROBA->cena_r
//	robni=robni+kol_zad*ROBA->cena_r
//	robni1=robni1+kol_zad*ROBA->odn_mal
//	robni=robni+kol_zad*ROBA->odn_mal
//else
//	robni1=robni1+kol_zad/ROBA->odn
//	robni=robni+kol_zad/ROBA->odn
//	robni1=robni1+kol_zad/ROBA->cena_r
//	robni=robni+kol_zad/ROBA->cena_r
//endif
	robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
	robni=robni+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)

skip
enddo

select ROBA
skip
enddo


@ row()+1,0 say MESTA->naziv_m
@ row(),20 say svega picture '@E 999,999,999.99'
@ row(),40 say robni1 picture '@E 999,999,999.99'
@ row(),60 say robni1-svega picture '@E 999,999,999.99'
//@ row(),47 say robni1*c_v picture '@E 999,999,999.99'
//@ row(),60 say robni1*c_v-svega picture '@E 999,999,999.99'
//if svega !=0
//@ row(),75 say  (robni1*c_v)/svega picture '@E 9.99'
//endif
*@ row(),65 say robni1-svega picture '@E 999,999,999.99'
robni1=0.00
svega=0.00

if row()=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
	 if lastkey()=27
		  return
	  endif
@ 4,0 clear to 19,79
@ 3,1 to 3,79
endif
	
	select MESTA
	skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),20 say ukupno picture '@E 999,999,999.99'
//@ row(),47 say robni*c_v picture '@E 999,999,999.99'
//@ row(),65 say robni*c_v-ukupno picture '@E 999,999,999.99'
@ row(),40 say robni picture '@E 999,999,999.99'
@ row(),60 say robni-ukupno picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)

inkey(0)

select ZADUZ
set order to 1

return


procedure prt_vred_salda

set device to print
setprc(0,0)
@ prow()+1,5 say 'Pregled vrednosnog salda maline i robe za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,30 say 'Malina:'
@ prow(),50 say 'Roba:'
@ prow(),65 say 'Saldo  :'
@ prow()+1,0 say replicate('-',79)
c_v=1.0
//   select VOCE
//      go top
//       do while !eof()
//	   if cena_v>c_v
//			c_v=cena_v
//	   endif
//	   skip
//	enddo
suma=0.00
ukupno=0.00
svega=0.00

select MESTA
	go top
do while !eof()
w_c=sifra_m
   select VOCE
      go top
       do while !eof()

		select OTKUP
   set index to otk_ss
				set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

svega=svega+(kol_otk*cena1+raz_otk*cena2+kol_otkii*cena3+kol4*cena4)*(1+VOCE->pdv/100)
//svega=svega+(kol_otk*VOCE->cena_v+raz_otk*VOCE->druga+kol_otkii*VOCE->treca)*(1+VOCE->pdv/100)
	
	skip
enddo

	select VOCE
	   skip
	enddo
ukupno=ukupno+svega


	
select ROBA
go top
do while !eof()
	
	
select ZADUZ
set order to 2
go top
set softseek on
seek rtrim(w_c)+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno_r=ukupno_r+kol_zad

//if empty(ROBA->odn)
//	robni1=robni1+kol_zad*ROBA->odn_mal
//	robni=robni+kol_zad*ROBA->odn_mal
//else
//	robni1=robni1+kol_zad/ROBA->odn
//	robni=robni+kol_zad/ROBA->odn
//endif
	robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
	robni=robni+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)

skip
enddo

select ROBA
skip
enddo


@ prow()+1,0 say rtrim(MESTA->naziv_m)
@ prow(),20 say svega picture '@E 999,999,999.99'
@ prow(),40 say robni1 picture '@E 999,999,999.99'
@ prow(),60 say robni1-svega picture '@E 999,999,999.99'
if svega !=0
@ prow(),74 say  ((robni1)/svega) picture '@E 999.99'
endif
*@ prow(),47 say robni1 picture '@E 999,999,999.99'
*@ prow(),65 say robni1-svega picture '@E 999,999,999.99'
robni1=0.00
svega=0.00

if prow()>=65
eject
@ prow()+1,0 say replicate('-',79)
@ prow()+1,35 say 'Malina:'
@ prow()+1,50 say 'Roba:'
@ prow()+1,65 say 'Saldo  :'
@ prow()+1,0 say replicate('-',79)
endif
	
	select MESTA
	skip
enddo
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA:'
@ prow(),20 say ukupno picture '@E 999,999,999.99'
@ prow(),40 say robni picture '@E 999,999,999.99'
@ prow(),60 say robni-ukupno picture '@E 999,999,999.99'
*@ prow(),47 say robni picture '@E 999,999,999.99'
*@ prow(),65 say robni-ukupno picture '@E 999,999,999.99'
@ prow()+1,0 say replicate('-',79)

eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
select ZADUZ
set order to 1

return
 


************************************************
*NOVI ZBIRNI PREGLED
************************************************
procedure new_zbir
setcolor(DEF_RED)
@ 00, 00 say center( "Pregled salda voca i robe")
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_name,kom_no
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'ROBA', .F. )
   set index to r_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'ZADUZ', .F. )
   set index to zad_rd
*   set index to zad_sd
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'VOCE', .F. )
   set index to v_name,v_no
else
  clos all
  RETURN   
endif

select 6
if NET_USE ( 'OTKUP', .F. )
   set index to otk_vd
*   set index to otk_sd
else
  clos all
  RETURN   
endif
select 7
if NET_USE ( 'AMB', .F. )
   set index to amb_sds
else
  clos all
  RETURN   
endif
****************************************************
save screen to screen1
MAX=1000
declare ROBA [ MAX ]
declare ROBA_no[ MAX ]
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare komm [ MAX ] && treba
declare rec[ MAX ]
ox = 1
*do w_mestto with ox
do w_mes with ox
do while .T.
do red_screen with "Pregled salda voca i robe"
  //restore screen from screen1
current = 1
//if ox<100
//zad = 1
//tek = 1
//do w_kom with otk_sifra
//  restore screen from screen1
//  tek = achoice(3,20,19,60,komm,.T.,'',tek,tek-1)
//  do case
//     case tek =zad
	 komintent=otk_sifra+'   '
	 do preg_new_salda with komintent
  exit
//	 case tek = 0
//	 exit
//	 otherwise
//	 go rec[tek]
//	 komintent=sifra_k
//	 do new_sal1 with komintent
//  endcase
//  else
//	 do preg_new_salda 
*  do sal_new
//  exit
//  endif
enddo

return

***********************************************

procedure preg_new_salda
parameters w_c
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "ESC -> Izlaz" )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
   suma=0.00
   ukupno=0.00
svega=0.00
robni1=0.0
robni=0.0
uku_v=0.00
maxx=999999999
minn=0
*set color to i
stampa='N'
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,35  say 'Do datuma :' get datum2
@ 00,60  say 'Sva mesta (D/N):' get stampa picture '!'
@ 23, 20 say 'Raspon: ' get minn
@ 23, 40 say 'do: ' get maxx
read
if stampa='D'
do mesta_zbirno
clos all
setcolor(DEFAULT)
return
endif
///ODAVDE NA EKRAN
clear screen

st='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Spisak/MAX (E/P/S/M)" )
@ 23, 60 get st picture '!'
read
if st='P'
do prx
clos all
setcolor(DEFAULT)
return
endif
if st='S'
do new_prx with maxx
clos all
setcolor(DEFAULT)
return
endif

if st='M'
do max_prx with maxx
clos all
setcolor(DEFAULT)
return
endif

@ 1,1 say '   Prezime i ime'
@ 1,25 say 'Malina:'
@ 1,35 say 'Vred. mal.'
@ 1,45 say 'Robno zad.'
@ 1,55 say 'Din. avans:'
@ 1,68 say 'Isplata:'
@ 2,0 say replicate('-',79)
save screen to scr
n=1
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
suma=0.00
ukupno=0.00
svega=0.00
ukupno1=0.00
svega_r=0.0
robni1=0.00
robni2=0.00
robni3=0.00
robni4=0.00
robni5=0.00
ukupno_r1=0.00
ukupno_r2=0.00
ukupno_r3= 0.00
ukupno_r4=0.00
ukupno_r5=0.00
raz=0.00
amb=0
prv_mal=0.00

select KOM
set index to kom_name
go top                            
//seek substr(w_c,1,3)
do while !eof() 
if substr(sifra_k,1,3)!=substr(w_c,1,3)
skip
loop
endif
//	@ row()+1,0 say n picture '999'
//	@ row(),4 say substr(ime_k,1,20)
//	@ row(),34 say substr(mesto_k,1,10)
**********ROBA

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek KOM->sifra_k+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=KOM->sifra_k .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

do case
case ROBA->status = 1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)


case ROBA->status = 3
robni3=robni3+kol_zad*ROBA->cena_r

//case ROBA->status = 4
//robni4=robni4+kol_zad*ROBA->cena_r

//case ROBA->status = 5
//robni5=robni5+kol_zad*ROBA->cena_r
//if empty(ROBA ->odn)
//robni5=robni5+kol_zad*ROBA->odn_mal
//else
//robni5=robni5+kol_zad/ROBA->odn
//endif

endcase

skip

enddo


select ROBA
skip
enddo

svega_r=robni1+robni2+robni3+robni4+robni5
ukupno_r1=ukupno_r1+robni1
ukupno_r2=ukupno_r2+robni2
ukupno_r3=ukupno_r3+robni3
ukupno_r4=ukupno_r4+robni4
ukupno_r5=ukupno_r5+robni5

****VOCE

select VOCE
   go top
do while !eof()


select OTKUP
	go top

set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
if VOCE->cena_v==0.00
//ukupno1=ukupno1+ kol_otk
ukupno=ukupno+kol_otk+raz_otk+kol_otkii+kol4
if KOM->pdd='D'
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(1+VOCE->pdv/100) 
else
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)
endif
else
ukupno=ukupno+kol_otk+raz_otk+kol_otkii+kol4
if KOM->pdd='D'
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(1+VOCE->pdv/100) 
else
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4) 
endif
endif	
	skip
enddo
select VOCE
skip
enddo

if ukupno>0.00 .or. svega_r>0.00
if ukupno>=minn .and. ukupno<=maxx
	@ row()+1,0 say n picture '999'
n=n+1
	@ row(),4 say substr(KOM->ime_k,1,20)
	@ row(),25 say ukupno picture '@E 9999999.99'
	@ row(),35 say ukupno1 picture '@E 9999999.99'
	@ row(),45 say robni2+robni1+robni4+robni5 picture '@E 99999999.9'
	@ row(),55 say robni3 picture '@E 99999999.9'
//	@ row(),100 say robni3+robni2+robni1+robni4+robni5 picture '@E 9,999,999.99'
    @ row(),65 say ukupno1-svega_r picture '@E 99999999.9'
//    @ prow(),120 say ((ukupno1-svega_r)/ukupno1)*100 picture '@E 999.99'
endif
endif
prv_mal=prv_mal+ukupno
svega=svega+ukupno  
raz=raz+ukupno1
*if ukupno>=svega_r
	robni1=0.00
	robni2=0.00
	robni3=0.00
	robni4=0.00
	robni5=0.00
*endif

*endif



ukupno=0.00
ukupno1=0.00
amb_z=0
amb_r=0
select AMB
set softseek on
seek KOM->sifra_k+DTOS(DATUM1)
set softseek off
do while  amb_sif=KOM->sifra_k .and. amb_datum<=datum2 .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
	amb=amb+amb_kol-amb_raz
skip
enddo
//	@ prow(),126 say str(amb_r-amb_z,5)


//@ prow()+1,25 say '----------'
//@ prow()+1,25 say prv_mal picture '@E 99,999,999.99'
//@ prow()+1,0 say ' '
prv_mal=0.00
if row()>=19
inkey(0)
clear screen
restore screen from scr
@ 2,0 say replicate('-',79)
endif
select KOM
skip
enddo
xx=ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5+ukupno_r3
@ row()+1,0 say 'SVEGA:'
	@ row(),24 say svega picture '@E 9999999.99'
	@ row(),43 say ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5 picture '@E 999999999.99'
	@ row(),65 say raz-xx picture '@E 999999999.99'
	@ row()+1,34 say raz picture '@E 999999999.9'
	@ row(),53 say ukupno_r3 picture '@E 9999999999.9'
//	@ row(),100 say ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5+ukupno_r3 picture '@E 9999999.99'
//    @ prow(),120 say (raz/xx)*100 picture '@E 999.99'
//    @ prow(),126 say amb picture '@E 99999'
@ row()+1,0 say 'SALDO:'
@ row(),55 say raz-(ukupno_r1+ukupno_r2+ukupno_r3+ukupno_r4+ukupno_r5) picture '@E 9999999999.99'
inkey(0)
setcolor(DEFAULT)
clos all
return
////////////////////////DOVDE EKRAN
//az=chr(27)+'l2a'+'l10'+'&k0S' 

procedure prx
pxv=0
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa u toku..." )
//SELECT PRINTER Konica minolta 162 | DEFAULT
//@ row()+1,0 say az     //chr(27)+'l2a'+l10'+'&k0S'       && HP landscape, 10cpi
//ie.  "ampersand - lower l - one - capital O"
set printer to stampa.prn
set device to print
//printer_orient_landscape
setprc(0,0)
//@ prow()+1,0 say chr(27)+"&l1O"
//@ prow()+1,0 say chr(27)+'l2a'+'l10'+'k2S'        // && HP landscape, compressed
@ prow()+1,1 say chr(27)+chr(15)
@ prow()+1,1 say center('Izvestaj o isplati maline za period '+dtoc(datum1)+'-'+dtoc(datum2))+' za '+KART [tekuci]
@ prow()+1,0 say replicate('-',130)
@ prow()+1,1 say '   Prezime i ime'
@ prow(),45 say 'Malina:'
@ prow(),55 say 'Vrednost mal.'
@ prow(),70 say 'Robno zaduz.'
@ prow(),85 say 'Din. avans:'
@ prow(),100 say 'Ukupno:'
@ prow(),112 say 'Isplata:'
@ prow(),121 say 'Amb.:'
@ prow()+1,0 say replicate('-',130)
save screen to scr
n=0
suma=0.00
ukupno=0.00
svega=0.00
ukupno1=0.00
svega_r=0.0
robni1=0.00
robni2=0.00
robni3=0.00
robni4=0.00
robni5=0.00
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno_r1=0.00
ukupno_r2=0.00
ukupno_r3= 0.00
ukupno_r4=0.00
ukupno_r5=0.00
raz=0.00
amb=0
prv_mal=0.00

select KOM
set index to kom_name
go top                            
//seek substr(w_c,1,3)
do while !eof() 

if substr(sifra_k,1,3)!=substr(w_c,1,3)
skip
loop
endif
//	@ prow()+1,0 say n picture '999'
//	@ prow(),4 say substr(ime_k,1,30)
//	@ prow(),34 say substr(mesto_k,1,10)
**********ROBA

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek KOM->sifra_k+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=KOM->sifra_k .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

do case
case ROBA->status = 1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)

case ROBA->status = 2
robni2=robni2+kol_zad*ROBA->cena_r

case ROBA->status = 3
robni3=robni3+kol_zad*ROBA->cena_r
case ROBA->status = 4
robni4=robni4+kol_zad*ROBA->cena_r

case ROBA->status = 5
robni5=robni5+kol_zad*ROBA->cena_r
//if empty(ROBA ->odn)
//robni5=robni5+kol_zad*ROBA->odn_mal
//else
//robni5=robni5+kol_zad/ROBA->odn
//endif

endcase

skip

enddo


select ROBA
skip
enddo

svega_r=robni1+robni2+robni3+robni4+robni5
ukupno_r1=ukupno_r1+robni1
ukupno_r2=ukupno_r2+robni2
ukupno_r3=ukupno_r3+robni3
ukupno_r4=ukupno_r4+robni4
ukupno_r5=ukupno_r5+robni5

****VOCE
select VOCE
   go top
do while !eof()


select OTKUP
	go top

set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

if VOCE->cena_v==0.00
//ukupno1=ukupno1+ kol_otk
ukupno=ukupno+kol_otk+raz_otk+kol_otkii+kol4
if KOM->pdd='D'
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(1+VOCE->pdv/100) 
pxv=pxv+(kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(VOCE->pdv/100)
else
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)
endif
else
ukupno=ukupno+kol_otk+raz_otk+kol_otkii+kol4
if KOM->pdd='D'
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(1+VOCE->pdv/100) 
pxv=pxv+(kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(VOCE->pdv/100)
else
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4) 
endif
endif	
	skip
enddo
select VOCE
skip
enddo


if ukupno>0.00 .or. svega_r>0.00
if ukupno>=minn .and. ukupno<=maxx
//if !empty(ukupno)
n=n+1
	@ prow()+1,0 say n picture '999'
	@ prow(),4 say substr(KOM->ime_k,1,25)
	@ prow(),29 say substr(KOM->mesto_k,1,10)
	@ prow(),40 say ukupno picture '@E 999,999.99'
	@ prow(),50 say ukupno1 picture '@E 99,999,999.99'
	@ prow(),65 say robni2+robni1+robni4+robni5 picture '@E 9,999,999.99'
	@ prow(),80 say robni3 picture '@E 9,999,999.99'
	@ prow(),95 say robni3+robni2+robni1+robni4+robni5 picture '@E 9,999,999.99'
    @ prow(),110 say ukupno1-svega_r picture '@E 9999,999.99'
//    @ prow(),120 say ((ukupno1-svega_r)/ukupno1)*100 picture '@E 999.99'
prv_mal=prv_mal+ukupno
svega=svega+ukupno  
raz=raz+ukupno1
	robni1=0.00
	robni2=0.00
	robni3=0.00
	robni4=0.00
	robni5=0.00
ukupno=0.00
ukupno1=0.00
amb_z=0
amb_r=0
select AMB
set softseek on
seek KOM->sifra_k+DTOS(DATUM1)
set softseek off
do while  amb_sif=KOM->sifra_k .and. amb_datum<=datum2 .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
	amb=amb+amb_kol-amb_raz
skip
enddo
	@ prow(),126 say str(amb_r-amb_z,5)
endif
endif
	robni1=0.00
	robni2=0.00
	robni3=0.00
	robni4=0.00
	robni5=0.00


//@ prow()+1,25 say '----------'
//@ prow()+1,25 say prv_mal picture '@E 99,999,999.99'
//@ prow()+1,0 say ' '
prv_mal=0.00
if prow()>=55
eject
@ prow()+1,0 say replicate('-',130)
@ prow()+1,1 say '   Prezime i ime'
@ prow(),45 say 'Malina:'
@ prow(),55 say 'Vrednost mal.'
@ prow(),70 say 'Robno zaduz.'
@ prow(),85 say 'Din. avans:'
@ prow(),100 say 'Ukupno:'
@ prow(),112 say 'Isplata:'
@ prow(),121 say 'Amb.:'
@ prow()+1,0 say replicate('-',130)
endif
select KOM
skip
enddo
xx=ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5+ukupno_r3
@ prow()+1,0 say replicate('-',130)
@ prow()+1,0 say 'SVEGA:'
	@ prow(),40 say svega picture '@E 999,999.99'
	@ prow(),64 say ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5 picture '@E 99,999,999.99'
	@ prow(),94 say ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5+ukupno_r3 picture '@E 99,999,999.99'
	@ prow()+1,50 say raz picture '@E 99,999,999.99'
	@ prow(),79 say ukupno_r3 picture '@E 99,999,999.99'
	@ prow(),108 say raz-xx picture '@E 99,999,999.99'
//    @ prow(),120 say (raz/xx)*100 picture '@E 999.99'
    @ prow(),121 say amb picture '@E 99999'
@ prow()+1,0 say replicate('-',130)
@ prow()+1,0 say 'SALDO:'
@ prow(),50 say raz-(ukupno_r1+ukupno_r2+ukupno_r3+ukupno_r4+ukupno_r5) picture '@E 9999,999,999.99'
    @ prow()+1,10 say 'PDV:'
    @ prow(),10 say pxv picture '@E 9999,999.99'
@ prow()+1,0 say ' '
eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A/P  " + cOutFName
RUN ( cCmd)
set device to screen
setcolor(DEFAULT)
select ZADUZ

return


/////SPISAK PROIZVODJACA
procedure new_prx
parameters MAXIM
pxv=0
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa u toku..." )
set device to print
setprc(0,0)
@ prow()+1,1 say chr(27)+chr(18)
//@ prow()+1,1 say center('Izvestaj o isplati maline za period '+dtoc(datum1)+'-'+dtoc(datum2))+' za '+rtrim(KART [tekuci])
@ prow()+1,1 say ('Izvestaj o isplati maline za period '+dtoc(datum1)+'-'+dtoc(datum2))+' za '+rtrim(KART [tekuci])
@ prow()+1,1 say replicate('-',80)
@ prow()+1,1 say '   Prezime i ime'
@ prow(),50 say 'JMBG:'
@ prow(),67 say 'Vrednost mal.'
@ prow()+1,1 say replicate('-',80)
save screen to scr
n=0
suma=0.00
ukupno=0.00
svega=0.00
ukupno1=0.00
svega_r=0.0
robni1=0.00
robni2=0.00
robni3=0.00
robni4=0.00
robni5=0.00
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno_r1=0.00
ukupno_r2=0.00
ukupno_r3= 0.00
ukupno_r4=0.00
ukupno_r5=0.00
raz=0.00
amb=0
prv_mal=0.00

select KOM
set index to kom_name
go top                            
//seek substr(w_c,1,3)
do while !eof() 

if substr(sifra_k,1,3)!=substr(w_c,1,3)
skip
loop
endif
****VOCE
select VOCE
   go top
do while !eof()


select OTKUP
	go top

set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

if VOCE->cena_v==0.00
//ukupno1=ukupno1+ kol_otk
ukupno=ukupno+kol_otk+raz_otk+kol_otkii+kol4
if KOM->pdd='D'
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(1+VOCE->pdv/100) 
pxv=pxv+(kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(VOCE->pdv/100)
else
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)
endif
else
ukupno=ukupno+kol_otk+raz_otk+kol_otkii+kol4
if KOM->pdd='D'
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(1+VOCE->pdv/100) 
pxv=pxv+(kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(VOCE->pdv/100)
else
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4) 
endif
endif	
	skip
enddo
select VOCE
skip
enddo


if ukupno>0.00 .or. svega_r>0.00
if ukupno>=minn .and. ukupno<=maxx
//if !empty(ukupno)
n=n+1
	@ prow()+1,1 say n picture '999'
	@ prow(),6 say substr(KOM->ime_k,1,30)
	@ prow(),45 say substr(KOM->JMBG,1,13)
	@ prow(),65 say ukupno1 picture '@E 99,999,999.99'
prv_mal=prv_mal+ukupno
svega=svega+ukupno  
raz=raz+ukupno1
	robni1=0.00
	robni2=0.00
	robni3=0.00
	robni4=0.00
	robni5=0.00
ukupno=0.00
ukupno1=0.00
amb_z=0
amb_r=0
select AMB
set softseek on
seek KOM->sifra_k+DTOS(DATUM1)
set softseek off
do while  amb_sif=KOM->sifra_k .and. amb_datum<=datum2 .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
	amb=amb+amb_kol-amb_raz
skip
enddo
endif
endif
	robni1=0.00
	robni2=0.00
	robni3=0.00
	robni4=0.00
	robni5=0.00

prv_mal=0.00
if prow()>=55
eject
@ prow()+1,1 say replicate('-',80)
@ prow()+1,1 say '   Prezime i ime'
@ prow(),50 say 'JMBG:'
@ prow(),67 say 'Vrednost mal.'
@ prow()+1,1 say replicate('-',80)
endif
select KOM
skip
enddo
xx=ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5+ukupno_r3
@ prow()+1,1 say replicate('-',80)
@ prow()+1,1 say 'SALDO:'
	@ prow(),65 say raz picture '@E 99,999,999.99'
@ prow()+1,1 say replicate('-',80)
//    @ prow()+1,10 say 'PDV:'
//    @ prow(),15 say pxv picture '@E 9999,999.99'
@ prow()+1,0 say ' '
eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
setcolor(DEFAULT)
select ZADUZ

return

///SPISAK SA MAXIMUMOM
/////SPISAK PROIZVODJACA
procedure max_prx
parameters MAXIM
pxv=0
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa u toku..." )
set device to print
setprc(0,0)
@ prow()+1,1 say chr(27)+chr(18)
//@ prow()+1,1 say center('Izvestaj o isplati maline za period '+dtoc(datum1)+'-'+dtoc(datum2))+' za '+rtrim(KART [tekuci])
@ prow()+1,1 say ('Izvestaj o isplati maline za period '+dtoc(datum1)+'-'+dtoc(datum2))+' za '+rtrim(KART [tekuci])
@ prow()+1,1 say replicate('-',80)
@ prow()+1,1 say '   Prezime i ime'
@ prow(),50 say 'JMBG:'
@ prow(),67 say 'Vrednost mal.'
@ prow()+1,1 say replicate('-',80)
save screen to scr
n=0
suma=0.00
ukupno=0.00
svega=0.00
ukupno1=0.00
svega_r=0.0
robni1=0.00
robni2=0.00
robni3=0.00
robni4=0.00
robni5=0.00
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno_r1=0.00
ukupno_r2=0.00
ukupno_r3= 0.00
ukupno_r4=0.00
ukupno_r5=0.00
raz=0.00
amb=0
prv_mal=0.00

select KOM
set index to kom_name
go top                            
//seek substr(w_c,1,3)
do while !eof() 

if substr(sifra_k,1,3)!=substr(w_c,1,3)
skip
loop
endif
****VOCE
select VOCE
   go top
do while !eof()

select OTKUP
	go top

set softseek on
	seek KOM->sifra_k+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(1+VOCE->pdv/100)
pxv=pxv+(kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)*(1+VOCE->pdv/100)

	skip
enddo
select VOCE
skip
enddo


if ukupno1>MAXIM

n=n+1
	@ prow()+1,1 say n picture '999'
	@ prow(),6 say substr(KOM->ime_k,1,30)
	@ prow(),45 say substr(KOM->JMBG,1,13)
	@ prow(),65 say ukupno1 picture '@E 99,999,999.99'
prv_mal=prv_mal+ukupno
svega=svega+ukupno  
raz=raz+ukupno1

ukupno=0.00
ukupno1=0.00



endif


prv_mal=0.00
if prow()>=55
eject
@ prow()+1,1 say replicate('-',80)
@ prow()+1,1 say '   Prezime i ime'
@ prow(),50 say 'JMBG:'
@ prow(),67 say 'Vrednost mal.'
@ prow()+1,1 say replicate('-',80)
endif
select KOM
skip
enddo
xx=ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5+ukupno_r3
@ prow()+1,1 say replicate('-',80)
@ prow()+1,1 say 'SALDO:'
	@ prow(),65 say raz picture '@E 99,999,999.99'
@ prow()+1,1 say replicate('-',80)
//    @ prow()+1,10 say 'PDV:'
//    @ prow(),15 say pxv picture '@E 9999,999.99'
@ prow()+1,0 say ' '
eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
setcolor(DEFAULT)
select ZADUZ

return
////END MAXIMUM



*******************************
procedure new_sal1
parameters w_c
**row()=2
select ZADUZ
   set index to zad_rd,zad_sd,zad_ds
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
ukupno=0.00
svega=0.00
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Priz. Akont/Priz. Kon./Doplata (E/P/R/K/D)" )
@ 23, 65 get stampa picture '!'
read
if stampa='P'
do prt_salda_poj
*clos all
return
endif
if stampa='R'
do priznanica
return
endif
if stampa='D'
do priz_kon
return
endif
if stampa='K'
do priz_kon_new
return
endif

*set color to
@ 1,1 to 1,79
@ 2,30 say 'Kolicina:'
@ 2,50 say 'Voce:'
@ 2,65 say 'Vrednost:'
@ row()+1,0 say replicate('-',79)
save screen to scr
select OTKUP
   set index to otk_vd,otk_sd
   suma=0.00
   ukupno=0.00
ukupno_v=0.00
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
select VOCE
   go top
   vc=cena_v
do while !eof()
*    @ row()+1,0 say naziv_v
*select MESTA
*	go top
*do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

suma=suma+kol_zad*cena
ukupno_v=ukupno_v+kol_otk+raz_otk
	
	skip
enddo

*select MESTA
*	skip
*enddo
if !empty(ukupno_v)
@ row()+1,1 say VOCE->naziv_v
@ row(),50 say ukupno_v picture '@E 99,999,999.99'
@ row(),62 say ukupno_v*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 999,999,999.99'
svega_v=svega_v+ukupno_v*VOCE->cena_v*(1+VOCE->pdv/100)
endif
zbir_v=zbir_v+ukupno_v
		*inkey(0)
ukupno_v=0.00
		*@ 2,1 clear to 19,79
select VOCE
skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),62 say svega_v picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)


**********ROBA
svega=0.0
ukupno=0.00
suma=0.00
select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
//if empty(ROBA->odn)
//robni1=robni1+kol_zad*ROBA->odn_mal
//robni=robni+kol_zad*ROBA->odn_mal
//else
//robni1=robni1+kol_zad/ROBA->odn
//robni=robni+kol_zad/ROBA->odn
//endif
skip
enddo
*select MESTA
*skip
*enddo
if !empty(ukupno)
@ row()+1,1 say ROBA->naziv_r
@ row(),30 say ukupno picture '@E 99,999,999.99'
@ row(),50 say robni1 picture '@E 99,999,999.99'
if ROBA->pdv=0
@ row(),65 say suma picture '@E 99,999,999.99'
svega=svega+suma
else
@ row(),65 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
svega=svega+suma*(1+ROBA->pdv/100)
endif
endif
*@ row()+1,1 to row()+1,79
*row()=row()+1
ukupno=0.00
robni1=0.0
if row()=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
	 if lastkey()=27
		  return
	  endif
@ 4,0 clear to 19,79
@ 3,1 to 3,79
endif
select ROBA
skip
enddo

@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),50 say robni picture '@E 99,999,999.99'
@ row(),62 say svega picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SALDO:'
@ row(),50 say zbir_v-robni picture '@E 99,999,999.99'
*@ row(),62 say svega_v-svega picture '@E 999,999,999.99'
@ row(),62 say  (zbir_v-robni)*vc picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'Procenat duga'
@ row(),60 say (((zbir_v-robni)*vc)/svega_v)*100 picture '@E 999.99'
inkey(0)

return

procedure sal_new
clear screen
@ 22, 0 to 24, 79
*@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
   suma=0.00
   ukupno=0.00
svega=0.00
*set color to i
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Saldo (E/P/S)" )
*@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_all_sal
*clos all
return
endif
if stampa='S'
do vred_saldo
*clos all
return
endif
*set color to
@ 1,1 to 1,79
@ 2,50 say 'Kolicina:'
@ 2,65 say 'Vrednost:'
@ row()+1,0 say replicate('-',79)
save screen to scr
select OTKUP
   set index to otk_vd,otk_sd
ukupno=0.00
svega=0.00
select VOCE
   go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
*	if substr(sifra_otk,1,3)!=MESTA->SIFRA_M 
*		skip 
*		loop
*	endif

ukupno=ukupno+kol_otk+raz_otk
	
	skip
enddo

*select MESTA
*	skip
*enddo
if !empty(ukupno)
@ row()+1,1 say VOCE->naziv_v
@ row(),45 say ukupno picture '@E 99,999,999.99'
@ row(),62 say ukupno*VOCE->cena_v*(1+VOCE->pdv/100) picture '@E 999,999,999.99'
svega=svega+ukupno*VOCE->cena_v*(1+VOCE->pdv/100)
endif
ukupno=0.00
		*@ 2,1 clear to 19,79
select VOCE
skip
enddo
@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),62 say svega picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)


**********ROBA
suma=0.00
ukupno=0.00
svega=0.0
select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
*if substr(sifra_zad,1,3)!=MESTA->SIFRA_M 
*skip 
*loop
*endif

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
skip
enddo
*select MESTA
*skip
*enddo
if !empty(ukupno)
@ row()+1,1 say ROBA->naziv_r
@ row(),45 say ukupno picture '@E 99,999,999.99'
if ROBA->pdv=0
@ row(),65 say suma picture '@E 99,999,999.99'
svega=svega+suma
else
@ row(),65 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
svega=svega+suma*(1+ROBA->pdv/100)
endif
//@ row(),62 say ukupno*ROBA->cena_r picture '@E 999,999,999.99'
//svega=svega+ukupno*ROBA->cena_r
endif
*@ row()+1,1 to row()+1,79
*row()=row()+1
ukupno=0.00
if row()=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
	 if lastkey()=27
		  return
	  endif
@ 4,0 clear to 19,79
@ 3,1 to 3,79
endif
select ROBA
skip
enddo

@ row()+1,0 say replicate('-',79)
@ row()+1,0 say 'SVEGA:'
@ row(),62 say svega picture '@E 999,999,999.99'
@ row()+1,0 say replicate('-',79)
inkey(0)

return

procedure saldo_proiz
parameters comint
stampaj=.F.
cepaj=.F.
x_com=substr(comint,1,3)
set device to print
@ prow()+1,10 say 'Saldo otkupa voca i robe za period '+dtoc(datum1)+ ' - '+dtoc(datum2)
@ prow()+1,0 say replicate('-',79)
@ prow()+1,1 say 'Otkupno mesto: '+' '+rtrim(kart[tekuci])
@ prow()+1,0 say replicate('-',79)
@ prow()+1,25 say 'Prepod.:'
@ prow(),35 say 'I klasa:'
@ prow(),45 say 'II klasa:'
@ prow(),55 say 'III klasa:'
@ prow(),70 say 'Vrednost:'
@ prow()+1,0 say replicate('-',79)
select KOM
go top
//set order to 2
//seek x_com
//do while sifra_k=rtrim(X_COM) .AND. !eof()
do while !eof()
if substr(sifra_k,1,3)!=rtrim(x_com)
skip
loop
endif
stampaj=.F.
cepaj=.F.
W_C=SIFRA_K
//  @ prow()+1,1 say chr(27) + chr(52)+rtrim(kom->ime_k)+' '+rtrim(mesto_k)+chr(27) + chr(53)
  @ prow()+1,1 say chr(27) + chr(14)+rtrim(kom->ime_k)+' '+rtrim(mesto_k)+chr(27) + chr(20)
@ prow()+1,0 say replicate('=',79)
select OTKUP
   set index to otk_vd,otk_sd
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
select VOCE
   go top
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno_v=ukupno_v+kol_otk
ukupno_d=ukupno_d+raz_otk
ukupno_t=ukupno_t+kol_otkii
third=third+kol4
	
	skip
enddo
if !empty(ukupno_v+ukupno_d+ukupno_t)
//  @ prow()+1,1 say chr(27) + chr(14)+rtrim(kom->ime_k)+' '+rtrim(KOM->mesto_k)+chr(27) + chr(20)
//@ prow()+1,0 say replicate('=',79)
@ prow()+1,1 say VOCE->naziv_v
@ prow(),22 say ukupno_v picture '@E 999,999.99'
@ prow(),33 say ukupno_d picture '@E 999,999.99'
@ prow(),44 say ukupno_t picture '@E 999,999.99'
@ prow(),54 say third picture '@E 999,999.99'
if KOM->pdd='D'
@ prow(),65 say (ukupno_v*VOCE->cena_v+ukupno_d*VOCE->druga+ukupno_t*VOCE->treca+third*VOCE->cetvrta)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
svega_v=svega_V+(ukupno_v*VOCE->cena_v+ukupno_d*VOCE->druga+ukupno_t*VOCE->treca+third*VOCE->cetvrta)*(1+VOCE->pdv/100)
else
@ prow(),65 say (ukupno_v*VOCE->cena_v+ukupno_d*VOCE->druga+ukupno_t*VOCE->treca+third*VOCE->cetvrta) picture '@E 99,999,999.99'
svega_v=svega_V+(ukupno_v*VOCE->cena_v+ukupno_d*VOCE->druga+ukupno_t*VOCE->treca+third*VOCE->cetvrta)
endif
stampaj=.T.
cepaj=.T.
endif
ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
select VOCE
skip
enddo

if stampaj
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA:'
@ prow(),65 say svega_v picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',79)
endif

**********ROBA
suma=0.00
ukupno=0.00
svega=0.0
select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
robni=robni+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
skip
enddo
if !empty(ukupno)
if !cepaj
//  @ prow()+1,1 say chr(27) + chr(14)+rtrim(kom->ime_k)+' '+rtrim(KOM->mesto_k)+chr(27) + chr(20)
//@ prow()+1,0 say replicate('=',79)
endif
@ prow()+1,1 say ROBA->naziv_r
@ prow(),30 say ukupno picture '@E 99,999,999.99'
if ROBA->pdv=0
@ prow(),65 say suma picture '@E 99,999,999.99'
svega=svega+suma
else
@ prow(),65 say suma*(1+ROBA->pdv/100) picture '@E 99,999,999.99'
svega=svega+suma*(1+ROBA->pdv/100)
endif
//@ prow(),65 say ukupno*ROBA->cena_r picture '@E 99,999,999.99'
//svega=svega+ukupno*ROBA->cena_r
stampaj=.T.
endif
ukupno=0.00
robni1=0.0
select ROBA
skip
enddo
if stampaj
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SVEGA:'
//@ prow(),50 say robni picture '@E 99,999,999.99'
@ prow(),65 say svega picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',79)
@ prow()+1,0 say 'SALDO:'
//@ prow(),50 say zbir_v-robni picture '@E 99,999,999.99'
@ prow(),65 say svega_v-svega picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('=',79)
//@ prow()+1,0 say 'Procenat duga'
//@ prow(),60 say ((svega_v-svega)*100)/svega_v picture '@E 999.99'
endif
select KOM
skip
enddo
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen

return

procedure ps
select 1
if NET_USE ( 'MESTA', .F. )
   set index to m_no
else
  clos all
  RETURN   
endif

select 2
if NET_USE ( 'KOM', .F. )
   set index to kom_no
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'ROBA', .F. )
   set index to r_no
else
  clos all
  RETURN   
endif

select 4
if NET_USE ( 'ZADUZ', .F. )
   set index to zad_ps
else
  clos all
  RETURN   
endif

select 5
if NET_USE ( 'VOCE', .F. )
   set index to v_no
else
  clos all
  RETURN   
endif

select 6
if NET_USE ( 'OTKUP', .F. )
   set index to otk_ps
else
  clos all
  RETURN   
endif

select 7
if NET_USE ( 'PS', .F. )
   set index to 
else
  clos all
  RETURN   
endif
								  
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ovo ce uraditi pocetno stanje... ESC - Izlaz " )
inkey(0)
	 if lastkey()=27
		  return
	  endif
   dat = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get dat
read


select KOM
go top
do while  !eof()
select OTKUP
ukupno=0.00
ukupno_v=0.00
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
select VOCE
go top
do while !eof()
select OTKUP
set softseek on
	seek kom->sifra_k+VOCE->SIFRA_V
set softseek off
do while sifra_otk=kom->sifra_k .and. sifra_otv=VOCE->SIFRA_V .and. !eof()

ukupno_v=ukupno_v+kol_otk+raz_otk
	
	skip
enddo
svega_v=svega_V+ukupno_v*VOCE->cena_v*(1+VOCE->pdv/100)

ukupno_V=0.00
select VOCE
skip
enddo


**********ROBA
suma=0.00
ukupno=0.00
svega=0.0
select ROBA
go top
do while !eof()
select ZADUZ
set softseek on
seek kom->sifra_k+ROBA->SIFRA_r
set softseek off
do while sifra_zad=kom->sifra_k .and. sifra_zar=ROBA->SIFRA_r .and. !eof()
suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
skip
enddo
svega=svega+suma*(1+ROBA->pdv/100)
suma=0.00
ukupno=0.00
select ROBA
skip
enddo
//wait svega_v
//wait svega
//@ prow(),65 say svega_v-svega picture '@E 99,999,999.99'
if svega_v>svega
select PS
append blank
replace sifra_zad with kom->sifra_k, sifra_zar with '000' , datum_zad with dat,;
		doc_zad with 'PS', kol_zad with -(svega_v-svega)
		else
select PS
append blank
replace sifra_zad with kom->sifra_k, sifra_zar with '100' , datum_zad with dat,;
		doc_zad with 'PS', kol_zad with svega-svega_v
endif
select KOM
skip
enddo


///ZA MESTA
select MESTA
go top
do while  !eof()
sifra=sifra_m+'000'
select OTKUP
ukupno=0.00
ukupno_v=0.00
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
select VOCE
go top
do while !eof()
select OTKUP
set softseek on
	seek sifra+VOCE->SIFRA_V
set softseek off
do while sifra_otk=sifra .and. sifra_otv=VOCE->SIFRA_V .and. !eof()

ukupno_v=ukupno_v+kol_otk+raz_otk
	
	skip
enddo
svega_v=svega_V+ukupno_v*VOCE->cena_v*(1+VOCE->pdv/100)

ukupno_V=0.00
select VOCE
skip
enddo


**********ROBA
suma=0.00
ukupno=0.00
svega=0.0
select ROBA
go top
do while !eof()
select ZADUZ
set softseek on
seek sifra+ROBA->SIFRA_r
set softseek off
do while sifra_zad=sifra .and. sifra_zar=ROBA->SIFRA_r .and. !eof()
suma=suma+kol_zad*ROBA->cena_r
ukupno=ukupno+kol_zad
skip
enddo
svega=svega+suma*(1+ROBA->pdv/100)
ukupno=0.00
select ROBA
skip
enddo
if svega_v>svega
select PS
append blank
replace sifra_zad with sifra, sifra_zar with '000' , datum_zad with dat,;
		doc_zad with 'PS', kol_zad with -(svega_v-svega)
		else
select PS
append blank
replace sifra_zad with sifra, sifra_zar with '100' , datum_zad with dat,;
		doc_zad with 'PS', kol_zad with svega-svega_v
endif
select MESTA
skip
enddo

return

//////////////////////NOVI IZVESTAJ ZA SVA MESTA
procedure mesta_zbirno
clear screen
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "ESC -> Izlaz" )
//store date() to datum1,datum2
//   datum1 = ctod( '01.01.' +  str( year( date() ), 4, 0 ))
ukupno=0.00
svega=0.00
robni1=0.0
robni=0.0
uku_v=0.00
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa u toku..." )
set device to print
setprc(0,0)
@ prow()+1,1 say chr(27)+chr(15)
@ prow()+1,1 say center('Izvestaj o isplati maline za period '+dtoc(datum1)+'-'+dtoc(datum2))+' za SVA MESTA'
@ prow()+1,0 say replicate('-',130)
@ prow()+1,1 say '   Prezime i ime'
@ prow(),30 say 'Malina:'
@ prow(),45 say 'Vrednost mal.'
@ prow(),60 say 'Robno zaduz.'
@ prow(),75 say 'Din. avans:'
@ prow(),100 say 'Ukupno:'
@ prow(),115 say 'Isplata:'
@ prow(),126 say 'Amb.:'
@ prow()+1,0 say replicate('-',130)
save screen to scr
suma=0.00
ukupno=0.00
svega=0.00
ukupno1=0.00
svega_r=0.0
robni1=0.00
robni2=0.00
robni3=0.00
robni4=0.00
robni5=0.00
ukupno_r1=0.00
ukupno_r2=0.00
ukupno_r3= 0.00
ukupno_r4=0.00
ukupno_r5=0.00
raz=0.00
amb=0
prv_mal=0.00

select MESTA
go top                            
do while !eof() 
	@ prow()+1,0 say substr(MESTA->naziv_m,1,30)
//	@ prow(),32 say substr(mesto_k,1,10)
**********ROBA

select ROBA
go top
do while !eof()
select ZADUZ
set index to zad_sd
go top
set softseek on
seek MESTA->sifra_m+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while substr(sifra_zad,1,3)=MESTA->sifra_m .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()

do case
case ROBA->status = 1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)

case ROBA->status = 2
robni2=robni2+kol_zad*ROBA->cena_r

case ROBA->status = 3
robni3=robni3+kol_zad*ROBA->cena_r

case ROBA->status = 4
robni4=robni4+kol_zad*ROBA->cena_r

case ROBA->status = 5
robni5=robni5+kol_zad*ROBA->cena_r
//if empty(ROBA ->odn)
//robni5=robni5+kol_zad*ROBA->odn_mal
//else
//robni5=robni5+kol_zad/ROBA->odn
//endif

endcase

skip

enddo


select ROBA
skip
enddo

svega_r=robni1+robni2+robni3+robni4+robni5
ukupno_r1=ukupno_r1+robni1
ukupno_r2=ukupno_r2+robni2
ukupno_r3=ukupno_r3+robni3
ukupno_r4=ukupno_r4+robni4
ukupno_r5=ukupno_r5+robni5

****VOCE

select VOCE
   go top
do while !eof()


select OTKUP
set index to otk_ss
	go top

set softseek on
	seek MESTA->sifra_m+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while substr(sifra_otk,1,3)=MESTA->sifra_m .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno=ukupno+kol_otk+raz_otk+kol_otkii+kol4
ukupno1=ukupno1+ (kol_otk*cena1+raz_otk*cena2+kol_otkII*cena3+kol4*cena4)
	
	skip
enddo
select VOCE
skip
enddo


*if !empty(ukupno)

	@ prow(),22 say ukupno picture '@E 99,999,999.99'
	@ prow(),40 say ukupno1 picture '@E 999,999,999.99'
	@ prow(),55 say robni2+robni1+robni4+robni5 picture '@E 999,999,999.99'
	@ prow(),70 say robni3 picture '@E 999,999,999.99'
	@ prow(),95 say robni3+robni2+robni1+robni4+robni5 picture '@E 999,999,999.99'
    @ prow(),110 say ukupno1-svega_r picture '@E 99,999,999.99'
//    @ prow(),120 say ((ukupno1-svega_r)/ukupno1)*100 picture '@E 999.99'
prv_mal=prv_mal+ukupno
svega=svega+ukupno  
raz=raz+ukupno1
*if ukupno>=svega_r
	robni1=0.00
	robni2=0.00
	robni3=0.00
	robni4=0.00
	robni5=0.00
*endif

*endif


ukupno=0.00
ukupno1=0.00
amb_z=0
amb_r=0
select AMB
set softseek on
seek KOM->sifra_k+DTOS(DATUM1)
set softseek off
do while  amb_sif=KOM->sifra_k .and. amb_datum<=datum2 .and. !eof()
	amb_z=amb_z+amb_kol
	amb_r=amb_r+amb_raz
	amb=amb+amb_kol-amb_raz
skip
enddo
	@ prow(),126 say str(amb_r-amb_z,5)


//@ prow()+1,25 say '----------'
//@ prow()+1,25 say prv_mal picture '@E 99,999,999.99'
//@ prow()+1,0 say ' '
prv_mal=0.00
if prow()>=65
eject
@ prow()+1,0 say replicate('-',130)
@ prow()+1,1 say '   Prezime i ime'
@ prow(),30 say 'Malina:'
@ prow(),45 say 'Vrednost mal.'
@ prow(),60 say 'Robno zaduz.'
@ prow(),75 say 'Din. avans:'
@ prow(),100 say 'Ukupno:'
@ prow(),115 say 'Isplata:'
@ prow(),126 say 'Amb.:'
@ prow()+1,0 say replicate('-',130)
endif

select MESTA
skip
enddo
xx=ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5+ukupno_r3
@ prow()+1,0 say replicate('-',130)
@ prow()+1,0 say 'SVEGA:'
	@ prow(),22 say svega picture '@E 99,999,999.99'
	@ prow(),40 say raz picture '@E 999,999,999.99'
	@ prow(),55 say ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5 picture '@E 999,999,999.99'
	@ prow(),70 say ukupno_r3 picture '@E 999,999,999.99'
	@ prow(),95 say ukupno_r2+ukupno_r1+ukupno_r4+ukupno_r5+ukupno_r3 picture '@E 999,999,999.99'
	@ prow(),110 say raz-xx picture '@E 99,999,999.99'
//    @ prow(),120 say (raz/xx)*100 picture '@E 999.99'
    @ prow(),126 say amb picture '@E 99999'
@ prow()+1,0 say replicate('-',130)
@ prow()+1,0 say 'SALDO:'
@ prow(),55 say raz-(ukupno_r1+ukupno_r2+ukupno_r3+ukupno_r4+ukupno_r5) picture '@E 9999,999,999.99'
@ prow()+1,0 say ' '
eject
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
select ZADUZ

return
***********************
procedure priznanica
dokx=1
if file("xdokum.mem")
restore from xdokum additive
endif

dokx=dokx+1
@ 02,10  say 'Broj priznanice :' get dokx
read

set device to print
for v=1 to 2
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow(),10 say rtrim(COMPANY->co_line1)
@ prow()+1,15 say rtrim(COMPANY->co_line2)
@ prow()+1,10 say 'PIB: '+ rtrim(COMPANY->co_line6)+' MB: '+rtrim(COMPANY->co_line7)  &&+dtoc(dat)+' '+ substr(time(),1,5
@ prow()+2,10 say 'Primalac priznanice'
@ prow() +1,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'

@ prow()+2,1 say 'Prezime i ime: '+rtrim(komm[tek])+' '+'JMBG: '+&file1->jmbg
//@ prow()+1,1 say 'JMBG: '+&file1->jmbg
@ prow()+1,1 say 'Broj resenja-uverenja o porezu na kat. prihod: '+&file1->mesto_k
//@ prow()+1,1 say 'Broj resenja o porezu na kat. prihod: '+&file1->mesto_k
@ prow() +4,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow()+1,10 say replicate('Ä',21)
//@ prow()+1,10 say '_____________________ '
@ prow()+1,10 say 'PRIZNANICA Br. '
@ prow(),26 say dokx picture '9999'
@ prow()+1,10 say replicate('Ä',21)
//@ prow()+1,10 say '_____________________ '
@ prow() +1,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow()+8,10 say 'Mesto i datum izdavanja: Pozega, ' +dtoc(datum2)
@ prow()+2,15 say 'Vrsta i kolicina isporucenih dobara i vrsta i obim usluga'


@ prow()+1,0 say replicate('Í',80)
@ prow()+1,2 say 'RB:'
@ prow(),10 say 'Vrsta dobra:'
@ prow(),30 say 'J.mere'
@ prow(),40 say 'Kolicina:'
@ prow(),53 say 'Akont.cena:'
@ prow(),66 say 'Iznos naknade'
@ prow()+1,65 say 'za ispor. dobra'
@ prow()+1,0 say replicate('Ä',80)
select OTKUP
   set index to otk_vd,otk_sd
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
n=0
select VOCE
   go top
   vc=cena_v
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno_v=ukupno_v+kol_otk*cena1
ukupno_d=ukupno_d+raz_otk*cena2
ukupno_t=ukupno_t+kol_otkii*cena3
third=third+kol4*cena4
uku_vd=uku_vd+kol_otk
uku_dd=uku_dd+raz_otk
uku_td=uku_td+kol_otkii
thirdd=thirdd+kol4
	skip
enddo
if !empty(ukupno_v)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' Prepodnevna'
@ prow(),35 say 'kg'
@ prow(),40 say uku_vd picture '@E 999,999.99'
@ prow(),55 say ukupno_v/uku_vd picture '@E 999.999'
@ prow(),67 say ukupno_v picture '@E 99,999,999.99'
svega_v=svega_V+ukupno_v
endif
if !empty(ukupno_d)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' I klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_dd picture '@E 999,999.99'
@ prow(),55 say ukupno_d/uku_dd picture '@E 999.999'
@ prow(),67 say ukupno_d picture '@E 99,999,999.99'
svega_v=svega_V+ukupno_d
endif

if !empty(ukupno_t)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' II klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_td picture '@E 999,999.99'
@ prow(),55 say ukupno_t/uku_td picture '@E 999.999'
@ prow(),67 say ukupno_t picture '@E 99,999,999.99'
svega_v=svega_V+ukupno_t
endif


//if !empty(ukupno_v+ukupno_d+ukupno_t+third)
//@ prow()+1,1 say VOCE->naziv_v
//@ prow(),22 say ukupno_v picture '@E 999,999.99'
//@ prow(),33 say ukupno_d picture '@E 999,999.99'
//@ prow(),44 say ukupno_t picture '@E 999,999.99'
//@ prow(),54 say third picture '@E 999,999.99'
//if &file1->pdd='D'
//@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
//svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
//else
//@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd) picture '@E 99,999,999.99'
//svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)
//endif
//endif
zbir_v=zbir_v+ukupno_v

ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
 select VOCE
skip
enddo

@ prow()+1,0 say replicate('Í',80)
@ prow()+1,0 say 'a) Svega vrednost primljenih dobara:                        '
@ prow(),67 say svega_v picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Ä',80)
@ prow()+1,0 say 'b) Iznos PDV naknade obracunate poljoprivredniku:'
if &file1->pdd='D'
@ prow(),67 say svega_v*.1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),67 say svega_v*1.1 picture '@E 99,999,999.99'
else
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),67 say svega_v picture '@E 99,999,999.99'

endif
@ prow()+1,0 say replicate('Í',80)



**********ROBA
suma=0.00
ukupno=0.00
svega=0.0

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
if ROBA->status=1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
else
robni=robni+kol_zad*ROBA->cena_r
endif
skip
enddo

select ROBA
skip
enddo
@ prow()+1,0 say 'c) Akontacija data u robi'
if !empty(robni1)
@ prow(),67 say robni1 picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('Ä',80)
@ prow()+1,0 say 'd) Akontacija data u novcu'
if !empty(robni)
@ prow(),67 say robni picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'II Ukupan iznos akontacije (c+d):'
@ prow(),67 say robni+robni1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II TR: '   +&file1->tr
@ prow(),67 say svega_v*1.1-(robni+robni1) picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)

//@ prow()+1,1 say 'Tekuci racun: '+&file1->tr
@ prow()+3,1 say '    Obracun izvrsio:                    M.P.                   Potpis primaoca'
@ prow()+3,1 say '   __________________                                          _________________'
eject
next
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
  set safety off
  save all like dokx to xdokum
  set safety on

return
///////// STARA 08/14 KONACNA PRIZZNANICA
***********************
procedure yy_priz_kon
dokx=1
if file("xdokum.mem")
restore from xdokum additive
endif
datpz=date()
dokx=dokx+1
doky=space(5)
@ 02,10  say 'Broj priznanice :' get dokx
//@ 03,10  say 'Stara priznanica :' get doky
@ 02,40  say 'Datum priznanice :' get datpz
read

set device to print
for v=1 to 2
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow(),10 say rtrim(COMPANY->co_line1)
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow()+1,15 say rtrim(COMPANY->co_line2)+',  Tel. 031/3816-530,811-617'
@ prow()+1,15 say 'Tek. racun 170-255-25,  EPPDV 132233732'
@ prow()+1,15 say 'PIB: '+ rtrim(COMPANY->co_line6)+' MB: '+rtrim(COMPANY->co_line7)  &&+dtoc(dat)+' '+ substr(time(),1,5
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow()+1,10 say 'Primalac priznanice'
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'

@ prow()+2,1 say 'Prezime i ime: '+rtrim(komm[tek])+' '+'JMBG: '+&file1->jmbg
//@ prow()+1,1 say 'JMBG: '+&file1->jmbg
if substr(&file1->mesto_k,1,1)='A'
@ prow()+1,1 say 'Broj resenja-uverenja o porezu na kat. prihod: '+substr(&file1->mesto_k,2,19)
else
@ prow()+1,1 say 'Izvod iz registra o upisu-aktivnom statusu polj. domacinstva: '+substr(&file1->mesto_k,2,19)
endif
//@ prow()+1,1 say 'Broj resenja o porezu na kat. prihod: '+&file1->mesto_k
@ prow() +4,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow()+1,10 say replicate('Ä',21)
//@ prow()+1,10 say '_____________________ '
@ prow()+1,10 say 'PRIZNANICA Br. '
@ prow(),26 say dokx picture '9999'
@ prow()+1,10 say replicate('Ä',21)
//@ prow()+1,10 say '_____________________ '
@ prow() +1,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow()+6,15 say 'Mesto i datum izdavanja: Pozega, ' +dtoc(datum2)
@ prow()+2,15 say 'Vrsta i kolicina isporucenih dobara i vrsta i obim usluga'


@ prow()+1,0 say replicate('Í',80)
@ prow()+1,2 say 'RB'
@ prow(),10 say 'Vrsta dobra'
@ prow(),30 say 'J.mere'
@ prow(),40 say 'Kolicina'
@ prow(),52 say 'Cena bez PDV'
//@ prow(),55 say 'Doplata '
@ prow(),66 say 'Ukupan iznos'
//@ prow(),66 say 'Iznos doplate'
//@ prow()+1,56 say 'cena:'
//@ prow()+1,65 say '   za 2010.    '
@ prow()+1,0 say replicate('Í',80)
select OTKUP
   set index to otk_vd,otk_sd
   staro_v=0
   kon=0
   kon1=0
   kon2=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
uku_v=0.00
uku_d=0.00
uku_t=0.00
uku_tr=0.00

svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
n=0
v1='1'
v2='1'
v3='1'
v4='1'
select VOCE
   go top
   vc=cena_v
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
prev_cena1=cena1
prev_cena2=cena2
prev_cena3=cena3
prev_cena4=cena4

uku_vd=uku_vd+kol_otk
uku_dd=uku_dd+raz_otk
uku_td=uku_td+kol_otkii
thirdd=thirdd+kol4

uku_v=uku_v+kol_otk*cena1
uku_d=uku_d+raz_otk*cena2
uku_t=uku_t+kol_otkii*cena3
uku_tr=uku_tr+kol4*cena4


	skip

	if cena1<>prev_cena1
	do ispis1
v1='2'
	endif
	if cena2<>prev_cena2
	do ispis2
v2='2'
	endif
	if cena3<>prev_cena3
	do ispis3
v3='2'
	endif
	if cena4<>prev_cena4
	do ispis4
v4='2'
	endif
enddo


zbir_v=zbir_v+ukupno_v

	if v1='1' .or. uku_vd>0.00
	do ispis1
	endif
	if v2='1' .or. uku_dd>0.00
	do ispis2
	endif
	if v3='1' .or. uku_td>0.00
	do ispis3
	endif
	if v4='1' .or. thirdd>0.00
	do ispis4
	endif
uku_v=0.00
uku_d=0.00
uku_t=0.00
ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
 select VOCE
skip
enddo


@ prow()+1,0 say replicate('Í',80)
@ prow()+1,0 say 'a) Svega vrednost primljenih dobara:                        '
@ prow(),67 say svega_v picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Ä',80)
@ prow()+1,0 say 'b) Iznos PDV nadoknade obracunate poljoprivredniku (8%):'
if &file1->pdd='D'
@ prow(),67 say svega_v*.08 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),67 say svega_v*1.08 picture '@E 99,999,999.99'
else
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),67 say svega_v picture '@E 99,999,999.99'

endif
@ prow()+1,0 say replicate('Í',80)



**********ROBA
/////////*
ukupno=0.00
svega=0.0

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
if ROBA->status=1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
else
robni=robni+kol_zad*ROBA->cena_r
endif
skip
enddo

select ROBA
skip
enddo
@ prow()+1,0 say 'c) Akontacija data u robi'
if !empty(robni1)
@ prow(),67 say robni1 picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('Ä',80)
@ prow()+1,0 say 'd) Akontacija data u novcu'
if !empty(robni)
@ prow(),67 say robni picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'II Ukupan iznos akontacije (c+d):'
@ prow(),67 say robni+robni1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)
if &file1->KAT='1'
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II TR: '   +&file1->tr
ELSE
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II  ' 
ENDIF

if &file1->pdd='D'
@ prow(),67 say svega_v*1.08-(robni+robni1) picture '@E 99,999,999.99'
xzbir=svega_v*1.08-(robni+robni1)
ELSE
@ prow(),67 say svega_v-(robni+robni1) picture '@E 99,999,999.99'
xzbir=svega_v-(robni+robni1)
ENDIF
@ prow()+1,0 say replicate('Í',80)

do case

case &file1->kat='2'
brt=svega_v*1.020408163
tro=brt*.9
osn=brt-tro
porezz=osn*.2
@ prow()+1,0 say 'Porez na druge prihode (20%):'
@ prow(),67 say porezz picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,0 say 'OSTAJE ZA ISPLATU TR: ' +&file1->tr
@ prow(),67 say xzbir-porezz picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)

case &file1->kat='3'
brt=svega_v*1.0482180
tro=brt*.9
osn=brt-tro
porezz=osn*.2
pioo=osn*.26
@ prow()+1,0 say 'Porez na druge prihode (20%):'
@ prow(),67 say porezz picture '@E 99,999,999.99'
@ prow()+1,0 say 'Doprinos za pio (26%):'
@ prow(),67 say pioo picture '@E 99,999,999.99'

@ prow()+1,0 say replicate('Í',80)
@ prow()+1,0 say 'OSTAJE ZA ISPLATU TR: ' +&file1->tr
@ prow(),67 say xzbir-porezz-pioo picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)

case &file1->kat='4'
brt=svega_v*1.0596588
tro=brt*.9
osn=brt-tro
porezz=osn*.2
pioo=osn*.26
zdrr=osn*.103
@ prow()+1,0 say 'Porez na druge prihode (20%):'
@ prow(),67 say porezz picture '@E 99,999,999.99'
@ prow()+1,0 say 'Doprinos za pio (26%):'
@ prow(),67 say pioo picture '@E 99,999,999.99'
@ prow()+1,0 say 'Doprinos za zdravstvo (10,3%):'
@ prow(),67 say zdrr picture '@E 99,999,999.99'

@ prow()+1,0 say replicate('Í',80)
@ prow()+1,0 say 'OSTAJE ZA ISPLATU TR: ' +&file1->tr
@ prow(),67 say xzbir-porezz-pioo-zdrr picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)


endcase







@ prow()+3,1 say '    Obracun izvrsio:                    M.P.                   Potpis primaoca'
@ prow()+3,1 say '   __________________                                          _________________'
eject
next
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
  set safety off
  save all like dokx to xdokum
  set safety on

return



Procedure xyz
			**************
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow(),1 say rtrim(COMPANY->co_line1)
@ prow()+1,1 say rtrim(COMPANY->co_line2)
@ prow()+1,1 say 'PIB: '+ rtrim(COMPANY->co_line6)+' MB: '+rtrim(COMPANY->co_line7)  &&+dtoc(dat)+' '+ substr(time(),1,5)
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'

@ prow()+2,10 say 'Primalac priznanice'
@ prow()+2,1 say 'Prezime i ime: '+rtrim(komm[tek])+' '+'JMBG: '+&file1->jmbg
//@ prow()+1,1 say 'JMBG: '+&file1->jmbg
@ prow()+1,1 say 'Broj resenja-uverenja o porezu na kat. prihod: '+&file1->mesto_k
@ prow() +4,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow(),10 say 'PRIZNANICA Br. '
@ prow(),26 say dokx picture '9999'
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow()+8,10 say 'Mesto i datum izdavanja: Pozega, ' +dtoc(datum2)

@ prow()+1,0 say replicate('-',80)
@ prow()+1,2 say 'RB:'
@ prow(),10 say 'Vrsta dobra:'
@ prow(),30 say 'J.mere'
@ prow(),40 say 'Kolicina:'
@ prow(),55 say 'Cena:'
@ prow(),65 say 'Iznos naknade:'
@ prow()+1,0 say replicate('-',80)
select OTKUP
   set index to otk_vd,otk_sd
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
n=0
select VOCE
   go top
   vc=cena_v
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()

ukupno_v=ukupno_v+kol_otk*cena1
ukupno_d=ukupno_d+raz_otk*cena2
ukupno_t=ukupno_t+kol_otkii*cena3
third=third+kol4*cena4
uku_vd=uku_vd+kol_otk
uku_dd=uku_dd+raz_otk
uku_td=uku_td+kol_otkii
thirdd=thirdd+kol4
	skip
enddo
if !empty(ukupno_v)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' Prepodnevna'
@ prow(),35 say 'kg'
@ prow(),40 say uku_vd picture '@E 999,999.99'
@ prow(),55 say VOCE->cena_v picture '@E 999.99'
//@ prow(),70 say ukupno_v*VOCE->cena_v picture '@E 999,999.99'
@ prow(),70 say ukupno_v picture '@E 999,999.99'
svega_v=svega_V+ukupno_v
endif
if !empty(ukupno_d)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' I klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_dd picture '@E 999,999.99'
@ prow(),55 say VOCE->druga picture '@E 999.99'
@ prow(),70 say ukupno_d picture '@E 999,999.99'
//@ prow(),70 say ukupno_d*VOCE->druga picture '@E 999,999.99'
svega_v=svega_V+ukupno_d
endif

if !empty(ukupno_t)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' II klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_td picture '@E 999,999.99'
@ prow(),55 say VOCE->treca picture '@E 999.99'
@ prow(),70 say ukupno_t picture '@E 999,999.99'
//@ prow(),70 say ukupno_t*VOCE->treca picture '@E 999,999.99'
svega_v=svega_V+ukupno_t
endif


//if !empty(ukupno_v+ukupno_d+ukupno_t+third)
//@ prow()+1,1 say VOCE->naziv_v
//@ prow(),22 say ukupno_v picture '@E 999,999.99'
//@ prow(),33 say ukupno_d picture '@E 999,999.99'
//@ prow(),44 say ukupno_t picture '@E 999,999.99'
//@ prow(),54 say third picture '@E 999,999.99'
//if &file1->pdd='D'
//@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
//svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
//else
//@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd) picture '@E 99,999,999.99'
//svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)
//endif
//endif
zbir_v=zbir_v+ukupno_v

ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
 select VOCE
skip
enddo

@ prow()+1,0 say replicate('-',80)
@ prow()+1,0 say 'a) Svega vrednost primljenih dobara:                        '
@ prow(),67 say svega_v picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',80)
@ prow()+1,0 say 'b) Iznos PDV naknade obracunate poljoprivredniku:'
if &file1->pdd='D'
@ prow(),67 say svega_v*.1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',80)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),67 say svega_v*1.1 picture '@E 99,999,999.99'
else
@ prow()+1,0 say replicate('-',80)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),67 say svega_v picture '@E 99,999,999.99'

endif
@ prow()+1,0 say replicate('-',80)



**********ROBA

ukupno=0.00
svega=0.0

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
if ROBA->status=1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
else
robni=robni+kol_zad*ROBA->cena_r
endif
skip
enddo

select ROBA
skip
enddo
@ prow()+1,0 say 'c) Akontacija data u robi'
if !empty(robni1)
@ prow(),70 say robni1 picture '@E 999,999.99'
endif
@ prow()+1,0 say replicate('-',80)
@ prow()+1,0 say 'd) Akontacija data u novcu'
if !empty(robni)
@ prow(),70 say robni picture '@E 999,999.99'
endif
@ prow()+1,0 say replicate('-',80)
@ prow()+1,5 say 'II Ukupan iznos akontacije (c+d):'
@ prow(),70 say robni+robni1 picture '@E 999,999.99'
@ prow()+1,0 say replicate('-',80)
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II TR: '   +&file1->tr
@ prow(),67 say svega_v*1.1-(robni+robni1) picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',80)
//@ prow()+1,1 say 'Tekuci racun: '+&file1->tr
@ prow()+3,1 say '    Obracun izvrsio:                    M.P.                   Potpis primaoca'
@ prow()+3,1 say '   __________________                                          _________________'
eject

set device to screen
  set safety off
  save all like dokx to xdokum
  set safety on

return

***************************************
///STARA KONACNA PRIZNANICA
procedure xx_priz_kon
dokx=1
if file("xdokum.mem")
restore from xdokum additive
endif
datpz=date()
dokx=dokx+1
doky=space(5)
@ 02,10  say 'Broj priznanice :' get dokx
@ 03,10  say 'Stara priznanica :' get doky
@ 03,40  say 'Datum priznanice :' get datpz
read

set device to print
for v=1 to 2
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow(),10 say rtrim(COMPANY->co_line1)
@ prow()+1,15 say rtrim(COMPANY->co_line2)
@ prow()+1,10 say 'PIB: '+ rtrim(COMPANY->co_line6)+' MB: '+rtrim(COMPANY->co_line7)  &&+dtoc(dat)+' '+ substr(time(),1,5
@ prow()+2,10 say 'Primalac priznanice'
@ prow() +1,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'

@ prow()+2,1 say 'Prezime i ime: '+rtrim(komm[tek])+' '+'JMBG: '+&file1->jmbg
//@ prow()+1,1 say 'JMBG: '+&file1->jmbg
@ prow()+1,1 say 'Broj resenja-uverenja o porezu na kat. prihod: '+&file1->mesto_k
//@ prow()+1,1 say 'Broj resenja o porezu na kat. prihod: '+&file1->mesto_k
@ prow() +4,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow()+1,10 say replicate('Ä',21)
//@ prow()+1,10 say '_____________________ '
@ prow()+1,10 say 'PRIZNANICA Br. '
@ prow(),26 say dokx picture '9999'
@ prow()+1,10 say replicate('Ä',21)
//@ prow()+1,10 say '_____________________ '
@ prow() +1,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow()+6,10 say 'Mesto i datum izdavanja: Pozega, ' +dtoc(datum2)
@ prow()+2,15 say 'Vrsta i kolicina isporucenih dobara i vrsta i obim usluga'


@ prow()+1,0 say replicate('Í',80)
@ prow()+1,2 say 'RB:'
@ prow(),10 say 'Vrsta dobra:'
@ prow(),30 say 'J.mere'
@ prow(),40 say 'Kolicina:'
@ prow(),55 say 'Konacna '
@ prow(),66 say 'Iznos naknade'
@ prow()+1,56 say 'cena:'
@ prow(),65 say 'za ispor. dobra'
@ prow()+1,0 say replicate('Í',80)
select OTKUP
   set index to otk_vd,otk_sd
   staro_v=0
   kon=0
   kon1=0
   kon2=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
uku_v=0.00
uku_d=0.00
uku_t=0.00

svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
n=0
select VOCE
   go top
   vc=cena_v
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
uku_v=uku_v+kol_otk*cena1
uku_d=uku_d+raz_otk*cena2
uku_t=uku_t+kol_otkii*cena3


ukupno_v=ukupno_v+kol_otk*VOCE->cena_v
ukupno_d=ukupno_d+raz_otk*VOCE->druga
ukupno_t=ukupno_t+kol_otkii*VOCE->treca
third=third+kol4*cena4
uku_vd=uku_vd+kol_otk
uku_dd=uku_dd+raz_otk
uku_td=uku_td+kol_otkii
thirdd=thirdd+kol4
	skip
enddo
if !empty(ukupno_v)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' Prepodnevna'
@ prow(),35 say 'kg'
@ prow(),40 say uku_vd picture '@E 999,999.99'
@ prow(),55 say ukupno_v/uku_vd picture '@E 999.999'
@ prow(),67 say ukupno_v picture '@E 99,999,999.99'
svega_v=svega_V+ukupno_v
staro_v=staro_v+uku_v
kon=kon+uku_vd*voce->cena_v
endif
if !empty(ukupno_d)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' I klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_dd picture '@E 999,999.99'
@ prow(),55 say ukupno_d/uku_dd picture '@E 999.999'
@ prow(),67 say ukupno_d picture '@E 99,999,999.99'
staro_v=staro_v+uku_d
svega_v=svega_V+ukupno_d
kon1=kon1+uku_dd*voce->druga
endif

if !empty(ukupno_t)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' II klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_td picture '@E 999,999.99'
@ prow(),55 say ukupno_t/uku_td picture '@E 999.999'
@ prow(),67 say ukupno_t picture '@E 99,999,999.99'
staro_v=staro_v+uku_t
svega_v=svega_V+ukupno_t
kon2=kon2+uku_td*voce->treca
endif


//if !empty(ukupno_v+ukupno_d+ukupno_t+third)
//@ prow()+1,1 say VOCE->naziv_v
//@ prow(),22 say ukupno_v picture '@E 999,999.99'
//@ prow(),33 say ukupno_d picture '@E 999,999.99'
//@ prow(),44 say ukupno_t picture '@E 999,999.99'
//@ prow(),54 say third picture '@E 999,999.99'
//if &file1->pdd='D'
//@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100) picture '@E 99,999,999.99'
//svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)*(1+VOCE->pdv/100)
//else
//@ prow(),65 say (uku_vd+uku_dd+uku_td+thirdd) picture '@E 99,999,999.99'
//svega_v=svega_V+(uku_vd+uku_dd+uku_td+thirdd)
//endif
//endif
zbir_v=zbir_v+ukupno_v

//   kon=0
//   kon1=0
//   kon2=0
uku_v=0.00
uku_d=0.00
uku_t=0.00
ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
//kon=svega_v*VOCE->cena_v
 select VOCE
skip
enddo

@ prow()+1,0 say replicate('Í',80)
@ prow()+1,0 say 'a) Svega vrednost primljenih dobara:                        '
@ prow(),67 say svega_v picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Ä',80)
@ prow()+1,0 say 'b) Iznos PDV naknade obracunate poljoprivredniku:'
if &file1->pdd='D'
@ prow(),67 say svega_v*.1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),67 say svega_v*1.1 picture '@E 99,999,999.99'
else
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),67 say svega_v picture '@E 99,999,999.99'

endif
@ prow()+1,0 say replicate('Í',80)



**********ROBA

ukupno=0.00
svega=0.0

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
if ROBA->status=1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
else
robni=robni+kol_zad*ROBA->cena_r
endif
skip
enddo

select ROBA
skip
enddo
@ prow()+1,0 say 'c) Akontacija data u robi'
if !empty(robni1)
@ prow(),67 say robni1 picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('Ä',80)
@ prow()+1,0 say 'd) Akontacija data u novcu'
if !empty(robni)
@ prow(),67 say robni picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,5 say 'II Ukupan iznos akontacije (c+d):'
@ prow(),67 say robni+robni1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II TR: '   +&file1->tr
@ prow(),67 say svega_v*1.1-(robni+robni1) picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)

@ prow()+2,0 say replicate('Í',80)
@ prow()+1,2 say 'Datum:'
@ prow(),15 say 'Opis:'
@ prow(),40 say 'Osnovica:'
@ prow(),55 say 'PDV: '
@ prow(),66 say 'Ukupno:'
@ prow()+1,0 say replicate('Í',80)
@ prow()+1,1 say datpz
@ prow(),15 say 'Priznanica Br. '
@ prow(),30 say doky picture '9999'
@ prow()+1,15 say 'Akontna isplata '
@ prow(),37 say staro_v picture '@E 9,999,999.99'
@ prow(),53 say staro_v*.1 picture '@E 99,999,999.99'
@ prow(),67 say staro_v*1.1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Ä',80)
@ prow()+1,1 say datum2
@ prow(),15 say 'Konacna isplata '
@ prow(),37 say kon+kon1+kon2 picture '@E 9,999,999.99'
@ prow(),53 say (kon+kon1+kon2)*.1 picture '@E 99,999,999.99'
@ prow(),67 say (kon+kon1+kon2)*1.1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Ä',80)
@ prow()+1,15 say 'Razlika '
@ prow(),37 say (kon+kon1+kon2)-staro_v picture '@E 9,999,999.99'
@ prow(),53 say ((kon+kon1+kon2)*.1)-(staro_v*.1) picture '@E 99,999,999.99'
@ prow(),67 say ((kon+kon1+kon2)*1.1)-(staro_v*1.1) picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',80)


@ prow()+3,1 say '    Obracun izvrsio:                    M.P.                   Potpis primaoca'
@ prow()+3,1 say '   __________________                                          _________________'
eject
next
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
  set safety off
  save all like dokx to xdokum
  set safety on

return
procedure ispis1
if !empty(uku_v)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' Prepodnevna'
@ prow(),35 say 'kg'
@ prow(),40 say uku_vd picture '@E 999,999.99'
@ prow(),55 say prev_cena1 picture '@E 999.999'
@ prow(),67 say uku_v picture '@E 99,999,999.99'
svega_v=svega_V+uku_v
staro_v=staro_v+uku_v
kon=kon+uku_vd*voce->cena_v
uku_v=0
uku_vd=0
endif
v1='1'
return

procedure ispis2
if !empty(uku_d)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' I klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_dd picture '@E 999,999.99'
@ prow(),55 say prev_cena2 picture '@E 999.999'
@ prow(),67 say uku_d picture '@E 99,999,999.99'
staro_v=staro_v+uku_d
svega_v=svega_V+uku_d
kon1=kon1+uku_dd*voce->druga
uku_d=0
uku_dd=0
endif
v2='1'
return

procedure ispis3
if !empty(uku_t)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' II klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_td picture '@E 999,999.99'
@ prow(),55 say prev_cena3 picture '@E 999.999'
@ prow(),67 say uku_t picture '@E 99,999,999.99'
staro_v=staro_v+uku_t
svega_v=svega_V+uku_t
kon2=kon2+uku_td*voce->treca
uku_td=0
uku_t=0
endif
v3='1'
return

procedure ispis4
if !empty(uku_tr)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' III klasa'
@ prow(),35 say 'kg'
@ prow(),40 say thirdd picture '@E 999,999.99'
@ prow(),55 say prev_cena4 picture '@E 999.999'
@ prow(),67 say uku_tr picture '@E 99,999,999.99'
staro_v=staro_v+uku_tr
svega_v=svega_V+uku_tr
kon2=kon2+thirdd*voce->cetvrta
uku_tr=0
thirdd=0
endif
v4='1'
return


	
///NOVA KONACNA PRIZNANICA
procedure priz_kon_new
dokx=1
if file("xdokum.mem")
restore from xdokum additive
endif
datpz=date()
dokx=dokx+1
doky=space(5)
public dokx
stampa='D'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa D/N)" )
@ 02,10  say 'Broj priznanice :' get dokx
@ 02,40  say 'Datum priznanice :' get datpz
@ 23, 60 get stampa picture '!'
read
if stampa='D'
set printer to stampa.prn
select KOM
   set order to 2
  seek &file1->sifra_k
if found()
do req_rec_lock
replace priz with alltrim(str(dokx))
endif
do pdf_create with dokx
return
set device to print
else
set printer to stampa.prn
set device to print
endif
select KOM
   set order to 2
//   wait '1111'
//   wait &file1->sifra_k
seek &file1->sifra_k
if found()
do req_rec_lock
replace priz with alltrim(str(dokx))
endif
for v=1 to 2
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow(),10 say rtrim(COMPANY->co_line1)
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow()+1,15 say rtrim(COMPANY->co_line2)+',  Tel. 031/3816-530,811-617'
@ prow()+1,15 say 'Tek. racun 170-255-25,  EPPDV 132233732'
@ prow()+1,15 say 'PIB: '+ rtrim(COMPANY->co_line6)+' MB: '+rtrim(COMPANY->co_line7)  &&+dtoc(dat)+' '+ substr(time(),1,5
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow()+1,10 say 'Primalac priznanice'
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'

@ prow()+2,1 say 'Prezime i ime: '+rtrim(komm[tek])+' '+'JMBG: '+&file1->jmbg
//@ prow()+1,1 say 'JMBG: '+&file1->jmbg
if substr(&file1->mesto_k,1,1)='A'
@ prow()+1,1 say 'Broj resenja-uverenja o porezu na kat. prihod: '+substr(&file1->mesto_k,2,19)
else
@ prow()+1,1 say 'Izvod iz registra o upisu-aktivnom statusu polj. domacinstva: '+substr(&file1->mesto_k,2,19)
endif
//@ prow()+1,1 say 'Broj resenja o porezu na kat. prihod: '+&file1->mesto_k

@ prow()+1,10 say replicate('-',21)

//@ prow()+1,10 say '_____________________ '
@ prow()+1,10 say 'PRIZNANICA Br. '
@ prow(),26 say dokx picture '9999'
@ prow()+1,10 say replicate('-',21)   
//@ prow()+1,10 say '_____________________ '

@ prow()+6,15 say 'Mesto i datum izdavanja: Pozega, ' +dtoc(datpz)
@ prow()+2,15 say 'Vrsta i kolicina isporucenih dobara i vrsta i obim usluga'


@ prow()+1,0 say replicate('-',87)  
@ prow()+1,2 say 'RB'
@ prow(),10 say 'Vrsta dobra'
@ prow(),30 say 'J.mere'
@ prow(),40 say 'Kolicina'
@ prow(),53 say 'Cena bez'
@ prow(),65 say 'Cena sa'
@ prow(),75 say 'Ukupan iznos'
@ prow()+1,55 say ' PDV'
@ prow(),66 say ' PDV'
//@ prow(),52 say 'Cena bez PDV'
//@ prow(),66 say 'Ukupan iznos'
@ prow()+1,0 say replicate('-',87)
select OTKUP
   set index to otk_vd,otk_sd
   staro_v=0
   kon=0
   kon1=0
   kon2=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
uku_v=0.00
uku_d=0.00
uku_t=0.00
uku_tr=0.00

svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
xsuma=0
n=0
v1='1'
v2='1'
v3='1'
v4='1'
select VOCE
   go top
   vc=cena_v
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
prev_cena1=cena1
prev_cena2=cena2
prev_cena3=cena3
prev_cena4=cena4

uku_vd=uku_vd+kol_otk
uku_dd=uku_dd+raz_otk
uku_td=uku_td+kol_otkii
thirdd=thirdd+kol4

uku_v=uku_v+kol_otk*VOCE->cena_v
uku_d=uku_d+raz_otk*VOCE->druga
uku_t=uku_t+kol_otkii*VOCE->treca
uku_tr=uku_tr+kol4*cena4
//uku_v=uku_v+kol_otk*cena1
//uku_d=uku_d+raz_otk*cena2
//uku_t=uku_t+kol_otkii*cena3
//uku_tr=uku_tr+kol4*cena4


	skip

enddo
///OVDE OBRACUN SVEGA PRE STAMPE
svega_v=svega_V+uku_v
svega_v=svega_V+uku_d
svega_v=svega_V+uku_t
porezz=0
pioo=0
zdrr=0

do case

case &file1->kat='2'
brt=svega_v*1.020408163
tro=brt*.9
osn=brt-tro
porezz=osn*.2
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz
endif

case &file1->kat='3'
brt=svega_v*1.0482180
tro=brt*.9
osn=brt-tro
porezz=osn*.2
pioo=osn*.26
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo
endif

case &file1->kat='4'
brt=svega_v*1.0596588
tro=brt*.9
osn=brt-tro
porezz=osn*.2
pioo=osn*.26
zdrr=osn*.103
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo, zdr with zdrr
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo, zdr with zdrr
endif

endcase

xzbir=svega_v-porezz-pioo-zdrr
vkoef=xzbir/svega_v
vkoef=round(vkoef,5)
///DOVDE OBRACUN CENE

if !empty(uku_v)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' Prepodnevna'
@ prow(),35 say 'kg'
@ prow(),40 say uku_vd picture '@E 999,999.99'
@ prow(),55 say round(VOCE->cena_v*vkoef,3) picture '@E 999.99'
@ prow(),65 say round(VOCE->cena_v*vkoef*1.08,0) picture '@E 999.99'
@ prow(),74 say uku_vd*round(VOCE->cena_v*vkoef,3) picture '@E 99,999,999.99'
xsuma=xsuma+uku_vd*round(VOCE->cena_v*vkoef,3)
endif
if !empty(uku_d)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' I klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_dd picture '@E 999,999.99'
@ prow(),55 say round(VOCE->druga*vkoef,3) picture '@E 999.99'
@ prow(),65 say round(VOCE->druga*vkoef*1.08,0) picture '@E 999.99'
@ prow(),74 say uku_dd*round(VOCE->druga*vkoef,3) picture '@E 99,999,999.99'
xsuma=xsuma+uku_dd*round(VOCE->druga*vkoef,3)
endif

if !empty(uku_t)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' II klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_td picture '@E 999,999.99'
@ prow(),55 say round(VOCE->treca*vkoef,3) picture '@E 999.99'
@ prow(),65 say round(VOCE->treca*vkoef*1.08,0) picture '@E 999.99'
@ prow(),74 say uku_td*round(VOCE->treca*vkoef,3) picture '@E 99,999,999.99'
xsuma=xsuma+uku_td*round(VOCE->treca*vkoef,3)
endif


zbir_v=zbir_v+ukupno_v


uku_v=0.00
uku_d=0.00
uku_t=0.00
ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
 select VOCE
skip
enddo


@ prow()+1,0 say replicate('-',87)
@ prow()+1,0 say 'a) Svega vrednost primljenih dobara:                        '
@ prow(),74 say xsuma picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',87)
@ prow()+1,0 say 'b) Iznos PDV nadoknade obracunate poljoprivredniku (8%):'
if &file1->pdd='D'
@ prow(),74 say xsuma*.08 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',87)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),74 say xsuma*1.08 picture '@E 99,999,999.99'
else
@ prow()+1,0 say replicate('-',87)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),74 say xzbir picture '@E 99,999,999.99'

endif
@ prow()+1,0 say replicate('-',87)



**********ROBA
/////////*
ukupno=0.00
svega=0.0

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
if ROBA->status=1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
else
robni=robni+kol_zad*ROBA->cena_r
endif
skip
enddo

select ROBA
skip
enddo
@ prow()+1,0 say 'c) Akontacija data u robi'
if !empty(robni1)
@ prow(),74 say robni1 picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('-',87)
@ prow()+1,0 say 'd) Akontacija data u novcu'
if !empty(robni)
@ prow(),74 say robni picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('-',87)
@ prow()+1,5 say 'II Ukupan iznos akontacije (c+d):'
@ prow(),74 say robni+robni1 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('-',87)
if &file1->KAT='1'
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II TR: '   +&file1->tr
ELSE
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II  ' 
ENDIF

if &file1->pdd='D'
@ prow(),74 say xzbir*1.08-(robni+robni1) picture '@E 99,999,999.99'
ELSE
@ prow(),74 say xzbir-(robni+robni1) picture '@E 99,999,999.99'
ENDIF
@ prow()+1,0 say replicate('-',87)







@ prow()+3,1 say '    Obracun izvrsio:                    M.P.                   Potpis primaoca'
@ prow()+3,1 say '   __________________                                          _________________'
eject
next


cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)

set device to screen
  set safety off
  save all like dokx to xdokum
  set safety on

return

procedure iz_obav
clear screen
u_posn=0
u_porez=0
u_pio=0
u_zdr=0

use OBAV
   set index to ob_dat
datum1=date()
@ 00,00  say center('Izrada izvestaja ')
@ 02,10  say 'Za datum :' get datum1
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Brisanje(E/P/B)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do stam_izv
clos all
return
endif
if stampa='B'
use obav exclusive
zap
pack
   set index to ob_dat,ob_sd
reindex
clos all
return
endif
clear screen
@ 01,1 say 'Proizvodjac:'
//@ 01,25 say 'Osnovica'
@ 01,32 say 'Porez'
@ 01,45 say 'Pio'
@ 01,55 say 'Zdravstvo'
@ 01,70 say 'Svega'
@ 02,0 say replicate('Í',100)
rb=1
select OBAV
seek dtos(datum1)
if found()
do while datum=datum1 .and. !eof()
@ row()+1,1 say substr(ime,1,25)
//@ row(),25 say posn picture'99,999,999.99'
@ row(),30 say porez picture'999,999.99'
@ row(),40 say pio picture'999,999.99'
@ row(),50 say zdr picture'999,999.99'
@ row(),65 say porez+pio+zdr picture'99,999,999.99'
rb=rb+1
u_posn=u_posn+posn
u_porez=u_porez+porez
u_pio=u_pio+pio
u_zdr=u_zdr+zdr
skip
if row()>=21
clear screen
@ 01,1 say 'Proizvodjac:'
//@ 01,25 say 'Osnovica'
@ 01,32 say 'Porez'
@ 01,45 say 'Pio'
@ 01,55 say 'Zdravstvo'
@ 01,70 say 'Svega'
@ 02,0 say replicate('Í',100)
endif

enddo
endif
@ row()+1,0 say replicate('Í',100)
@ 23,1 say 'SVEGA:'
//@ row(),25 say u_posn picture'99,999,999.99'
@ 23,30 say u_porez picture'999,999.99'
@ 23,40 say u_pio picture'999,999.99'
@ 23,50 say u_zdr picture'999,999.99'
@ 23,65 say u_porez+u_pio+u_zdr picture'99,999,999.99'
inkey(0)
clos all
return

procedure stam_izv
set device to print
@ prow() +1,0 say chr(27) + chr(15)
@ prow()+1,2 say 'RB'
@ prow(),5 say 'Proizvodjac:'
@ prow(),45 say 'Osnovica'
@ prow(),56 say 'Porez'
@ prow(),70 say 'Pio'
@ prow(),76 say 'Zdravstvo'
@ prow(),90 say 'Svega'
@ prow()+1,0 say replicate('Í',100)
rb=1
select OBAV
seek dtos(datum1)
if found()
do while datum=datum1 .and. !eof()
@ prow()+1,1 say str(rb,3)
@ prow(),5 say substr(ime,1,35)
@ prow(),40 say posn picture'99,999,999.99'
@ prow(),55 say porez picture'999,999.99'
@ prow(),65 say pio picture'999,999.99'
@ prow(),75 say zdr picture'999,999.99'
@ prow(),85 say porez+pio+zdr picture'99,999,999.99'
rb=rb+1
u_posn=u_posn+posn
u_porez=u_porez+porez
u_pio=u_pio+pio
u_zdr=u_zdr+zdr
skip
enddo
endif
@ prow()+1,0 say replicate('Í',100)
@ prow()+1,1 say 'SVEGA:'
@ prow(),40 say u_posn picture'99,999,999.99'
@ prow(),55 say u_porez picture'999,999.99'
@ prow(),65 say u_pio picture'999,999.99'
@ prow(),75 say u_zdr picture'999,999.99'
@ prow(),85 say u_porez+u_pio+u_zdr picture'99,999,999.99'
@ prow() +1,0 say chr(27) + chr(18)
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return


/////PRIZNANICA ZA DOPLATU
procedure priz_kon
dokx=1
if file("xdokum.mem")
restore from xdokum additive
endif
datpz=date()
dokx=dokx+1
doky=space(5)
dokz=ltrim(str(dokx,4)+space(4))
stampa='D'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Stampa D/N)" )
@ 02,10  say 'Broj priznanice :' get dokz picture 'XXXXXXXX'
@ 02,40  say 'Datum priznanice :' get datpz
@ 23, 60 get stampa picture '!'
read
if stampa='D'
set device to print
else
set printer to stampa.prn
set device to print
endif
for v=1 to 2
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow(),10 say rtrim(COMPANY->co_line1)
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow()+1,15 say rtrim(COMPANY->co_line2)+',  Tel. 031/3816-530,811-617'
@ prow()+1,15 say 'Tek. racun 170-255-25,  EPPDV 132233732'
@ prow()+1,15 say 'PIB: '+ rtrim(COMPANY->co_line6)+' MB: '+rtrim(COMPANY->co_line7)  &&+dtoc(dat)+' '+ substr(time(),1,5
@ prow() +1,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow()+1,10 say 'Primalac priznanice'
@ prow() ,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'

@ prow()+2,1 say 'Prezime i ime: '+rtrim(komm[tek])+' '+'JMBG: '+&file1->jmbg
//@ prow()+1,1 say 'JMBG: '+&file1->jmbg
if substr(&file1->mesto_k,1,1)='A'
@ prow()+1,1 say 'Broj resenja-uverenja o porezu na kat. prihod: '+substr(&file1->mesto_k,2,19)
else
@ prow()+1,1 say 'Izvod iz registra o upisu-aktivnom statusu polj. domacinstva: '+substr(&file1->mesto_k,2,19)
endif
//@ prow()+1,1 say 'Broj resenja o porezu na kat. prihod: '+&file1->mesto_k
@ prow() +4,0 say chr(27) + chr(120) + '1'
@ prow() ,0 say chr(27) + chr(87) + '1'
@ prow()+1,10 say replicate('Ä',21)
//@ prow()+1,10 say '_____________________ '
//@ prow()+1,12 say 'KONACNA PRIZNANICA' 
//@ prow(),26 say dokx picture '9999'
@ prow()+1,10 say 'PRIZNANICA Br. '
@ prow(),26 say dokz picture 'XXXXXXXX'

@ prow()+1,10 say replicate('Ä',21)
//@ prow()+1,10 say '_____________________ '
@ prow() +1,0 say chr(27) + chr(87) + '0'
@ prow() ,0 say chr(27) + chr(120) + '0'
@ prow()+1,5 say 'ZA DOPLATU MALINE RODA 2015. PO DOKUMENTU Br. _______ od _________2015. godine '
@ prow()+4,15 say 'Mesto i datum izdavanja: Pozega, ' +dtoc(datpz)
@ prow()+2,15 say 'Vrsta i kolicina isporucenih dobara i vrsta i obim usluga'


@ prow()+1,0 say replicate('Í',87)
@ prow()+1,2 say 'RB'
@ prow(),10 say 'Vrsta dobra'
@ prow(),30 say 'J.mere'
@ prow(),40 say 'Kolicina'
@ prow(),53 say 'Cena bez'
@ prow(),65 say 'Cena sa'
@ prow(),75 say 'Ukupan iznos'
@ prow()+1,55 say ' PDV'
@ prow(),66 say ' PDV'
@ prow()+1,0 say replicate('Í',87)
select OTKUP
   set index to otk_vd,otk_sd
   staro_v=0
   kon=0
   kon1=0
   kon2=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
uku_v=0.00
uku_d=0.00
uku_t=0.00
uku_tr=0.00

svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
xsuma=0
n=0
v1='1'
v2='1'
v3='1'
v4='1'
select VOCE
   go top
   vc=cena_v
///   IF SIFRA_V = '102'
//   SKIP
//   LOOP
//   ENDIF
do while !eof()
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
prev_cena1=cena1
prev_cena2=cena2
prev_cena3=cena3
prev_cena4=cena4

uku_vd=uku_vd+kol_otk
uku_dd=uku_dd+raz_otk
uku_td=uku_td+kol_otkii
thirdd=thirdd+kol4

uku_v=uku_v+kol_otk*VOCE->cena_v
uku_d=uku_d+raz_otk*VOCE->druga
uku_t=uku_t+kol_otkii*VOCE->treca
uku_tr=uku_tr+kol4*cena4
//uku_v=uku_v+kol_otk*cena1
//uku_d=uku_d+raz_otk*cena2
//uku_t=uku_t+kol_otkii*cena3
//uku_tr=uku_tr+kol4*cena4


	skip

enddo
///OVDE OBRACUN SVEGA PRE STAMPE
uku_t=0.00
svega_v=svega_V+uku_v
svega_v=svega_V+uku_d
svega_v=svega_V+uku_t
porezz=0
pioo=0
zdrr=0

do case

case &file1->kat='2'
brt=svega_v*1.020408163
tro=brt*.9
osn=brt-tro
porezz=osn*.2
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz
endif

case &file1->kat='3'
brt=svega_v*1.0482180
tro=brt*.9
osn=brt-tro
porezz=osn*.2
pioo=osn*.26
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo
endif

case &file1->kat='4'
brt=svega_v*1.0596588
tro=brt*.9
osn=brt-tro
porezz=osn*.2
pioo=osn*.26
zdrr=osn*.103
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo, zdr with zdrr
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo, zdr with zdrr
endif

endcase

xzbir=svega_v-porezz-pioo-zdrr
vkoef=xzbir/svega_v
vkoef=round(vkoef,5)
///DOVDE OBRACUN CENE

if !empty(uku_v)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' Prepodnevna'
@ prow(),35 say 'kg'
@ prow(),40 say uku_vd picture '@E 999,999.99'
@ prow(),55 say round(VOCE->cena_v*vkoef,2) picture '@E 999.99'
@ prow(),65 say round(VOCE->cena_v*vkoef*1.08,0) picture '@E 999.99'
@ prow(),74 say uku_vd*round(VOCE->cena_v*vkoef,2) picture '@E 99,999,999.99'
xsuma=xsuma+uku_vd*round(VOCE->cena_v*vkoef,2)
endif
if !empty(uku_d)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' I klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_dd picture '@E 999,999.99'
@ prow(),55 say round(VOCE->druga*vkoef,2) picture '@E 999.99'
@ prow(),65 say round(VOCE->druga*vkoef*1.08,0) picture '@E 999.99'
@ prow(),74 say uku_dd*round(VOCE->druga*vkoef,2) picture '@E 99,999,999.99'
xsuma=xsuma+uku_dd*round(VOCE->druga*vkoef,2)
endif

if !empty(uku_t)
n=n+1
@ prow()+1,1 say n picture '9'
@ prow(),5 say rtrim(VOCE->naziv_v)+' II klasa'
@ prow(),35 say 'kg'
@ prow(),40 say uku_td picture '@E 999,999.99'
@ prow(),55 say round(VOCE->treca*vkoef,2) picture '@E 999.99'
@ prow(),65 say round(VOCE->treca*vkoef*1.08,0) picture '@E 999.99'
@ prow(),74 say uku_td*round(VOCE->treca*vkoef,2) picture '@E 99,999,999.99'
xsuma=xsuma+uku_td*round(VOCE->treca*vkoef,2)
endif


zbir_v=zbir_v+ukupno_v


uku_v=0.00
uku_d=0.00
uku_t=0.00
ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0

 select VOCE
skip
enddo


@ prow()+1,0 say replicate('Í',87)
@ prow()+1,0 say 'a) Svega vrednost primljenih dobara:'
@ prow(),74 say xsuma picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Ä',87)
@ prow()+1,0 say 'b) Iznos PDV nadoknade obracunate poljoprivredniku (8%):'
if &file1->pdd='D'
@ prow(),74 say xsuma*.08 picture '@E 99,999,999.99'
@ prow()+1,0 say replicate('Í',87)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),74 say xsuma*1.08 picture '@E 99,999,999.99'
else
@ prow()+1,0 say replicate('Í',87)
@ prow()+1,5 say 'I Ukupna vrednost dobara sa PDV (a+b):'
@ prow(),74 say xzbir picture '@E 99,999,999.99'

endif
@ prow()+1,0 say replicate('Í',87)


/*
**********ROBA
/////////*
ukupno=0.00
svega=0.0

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
if ROBA->status=1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
else
robni=robni+kol_zad*ROBA->cena_r
endif
skip
enddo

select ROBA
skip
enddo
@ prow()+1,0 say 'c) Akontacija data u robi'
if !empty(robni1)
@ prow(),74 say robni1 picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('Ä',87)
@ prow()+1,0 say 'd) Akontacija data u novcu'
if !empty(robni)
@ prow(),74 say robni picture '@E 99,999,999.99'
endif
@ prow()+1,0 say replicate('Í',87)
@ prow()+1,5 say 'II Ukupan iznos akontacije (c+d):'
@ prow(),74 say robni+robni1 picture '@E 99,999,999.99'
*/
@ prow()+1,0 say replicate('Í',87)
if &file1->KAT='1'
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II TR: '   +&file1->tr
ELSE
@ prow()+1,0 say 'IZNOS ZA ISPLATU I-II  ' 
ENDIF

if &file1->pdd='D'
@ prow(),74 say xzbir*1.08-(robni+robni1) picture '@E 99,999,999.99'
ELSE
@ prow(),74 say xzbir-(robni+robni1) picture '@E 99,999,999.99'
ENDIF
@ prow()+1,0 say replicate('Í',87)







@ prow()+9,1 say '    Obracun izvrsio:                    M.P.                   Potpis primaoca'
@ prow()+3,1 say '   __________________                                          _________________'
eject
next

cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)

set device to screen
  set safety off
  save all like dokx to xdokum
  set safety on

return

procedure xzaduz
MAX=1000
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]
declare roba [ MAX ]
declare roba_no[ MAX ]

clear screen
@ 1,0,22,79 box background
*set color to i
@ 00, 00 say center( "Zaduzivanje magacina" )
*set color to
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Esc - Izlaz" )
save screen to screen1

select 1
if net_use( "CHANGES", .F. )
   set index to ch_dokum, ch_sd, ch_ds, ch_dob
else
   close all
   return
endif


select 2
if NET_USE ( 'ROBA', .F. )
   set index to r_name,r_no
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif		

la = 1
curr = 1
do rfill_roba with la

m_datum = date()
m_dok = 'NP'
m_br_dok = space(10)
vrednost = 0
m_fakt_iznos = 0
m_sifdob=space(3)
do while .T.
do whole_screen with  "Zaduzivanje magacina"
 //  restore screen from screen1
   m_dok='NP'
   @ 3, 0 to 3, 79
   @ 2, 1 say 'Datum:' get m_datum
   @ 2, 25 say 'Vrsta i broj dokumenta:' get m_dok picture '!!'
   @ 2, 55 get m_br_dok picture '@!'
   read
   if lastkey() = 27
      exit
   endif
      m_br_fakt = space(40)
      @ 5, 0 to 7, 79
      @ 6, 1 say 'Dobavljac:' get m_br_fakt picture '@!'    &&valid !empty( m_br_fakt )
      read
      if lastkey() = 27 
         loop
      endif
	  if empty(m_br_fakt)
	  ox = 1
current = 1
last=100
select MESTA
do fill_rms with ox
do whole_screen with  "Zaduzivanje magacina"
  //restore screen from screen1
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
  tekuci = achoice(3,15,19,65,kart,.T.,'',tekuci,tekuci-1)
  do case
                                                                                                                                                                                          case tekuci != 0 
	 go rec_no[tekuci]
	 m_sifdob=sifra_m
	 case tekuci = 0
	 clos all
	 return
  endcase
  endif
  save screen to screen2
   m_sifra = space(6)
   vrednost = 0
   jos_stavki = 'D'
//   prev_status = status_sifre
   do while jos_stavki = 'D'
   do whole_screen with  "Zaduzivanje magacina"
   //restore screen from screen1
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double

  curr = achoice(3,20,19,60,roba,.T.,'',curr,curr-1)
  do case
     case curr !=0
	 select ROBA
	 go roba_no[curr]
	 m_sifra=sifra_r
//	 do zad_r with komintent,roba_o
//	 loop
     case curr = 0
          close all
          clear screen
          return
  endcase
  do whole_screen with  "Zaduzivanje magacina"
   //restore screen from screen1
     @ 14, 5 to 21, 74
     @ 15, 10 say "Naziv:         " +ROBA->NAZIV_R
	select CHANGES
	seek (m_dok+m_br_dok)+(m_sifra)
	if found()
	  m_kol=ch_kol
	  m_cena=ch_cena
	  m_rabat=0
	  else
	 store 0 to m_kol, m_cena, m_komada, m_rabat
	endif
        @ 18, 10 say "Kolicina:" get m_kol picture "99999999.999"
        @ 20, 10 say "Cena:    " get m_cena picture "99999999.999" 
     @ 23, 0 say centermsg( "Esc - Izlaz" )
     read
     if lastkey() = 27
        exit
     endif
     ok = 'D'
     @ 23, 0 say centermsg( ' Korektni podaci (D/N)' )
     @ 23, 65 get ok picture '!'
     read
if ok = 'D'
        select CHANGES
  if ! empty(m_sifdob)
		seek (m_dok+m_br_dok)+(m_sifra)
     if found()
		 do req_rec_lock
        replace CH_DATUM with m_datum, CH_SIFRA with m_sifra, CH_KOL with -m_kol, CH_STATUS with 'I',;  && , CH_KOM with m_komada;
                CH_CENA with m_cena, CH_DOKUM with m_dok + m_br_dok, CH_faktura with m_br_fakt, CH_DATCEN with m_datum, CH_DOB with m_sifdob
	  else 
				do new_rec
        replace CH_DATUM with m_datum, CH_SIFRA with m_sifra, CH_KOL with -m_kol, CH_STATUS with 'I',;  && , CH_KOM with m_komada;
                CH_CENA with m_cena, CH_DOKUM with m_dok + m_br_dok, CH_FAKTURA with m_br_fakt, CH_DATCEN with m_datum, CH_DOB with m_sifdob
	  endif
  else
       seek (m_dok+m_br_dok)+(m_sifra)
     if found()
	 do req_rec_lock
        replace CH_DATUM with m_datum, CH_SIFRA with m_sifra, CH_KOL with m_kol, CH_STATUS with 'U',;  && , CH_KOM with m_komada;
                CH_CENA with m_cena, CH_DOKUM with m_dok + m_br_dok, CH_faktura with m_br_fakt, CH_DATCEN with m_datum, CH_DOB with m_sifdob
	 else 
				do new_rec
        replace CH_DATUM with m_datum, CH_SIFRA with m_sifra, CH_KOL with m_kol, CH_STATUS with 'U',;  && , CH_KOM with m_komada;
                CH_CENA with m_cena, CH_DOKUM with m_dok + m_br_dok, CH_FAKTURA with m_br_fakt, CH_DATCEN with m_datum, CH_DOB with m_sifdob
    endif
 endif
 else 
     okx = 'D'
     @ 23, 0 say centermsg( ' Brisanje (D/N)' )
     @ 23, 65 get okx picture '!'
     read
      seek (m_dok+m_br_dok)+(m_sifra)
     if okx='D'
	 do req_rec_lock
	 delete
     endif
 endif
 do whole_screen with  "Zaduzivanje magacina"
     @ 23, 0 say centermsg( 'Unos jos neke stavke  (D/N)' )
     @ 23, 65 get jos_stavki picture '!'
     read
   enddo  && while jos_stavki = 'D'
   enddo
   clos all
   return
////////////////////////////////////
   procedure xrazduz
MAX=1000
declare roba [ MAX ]
declare roba_no[ MAX ]
declare kart [ 100 ]  &&treba
declare kart1 [ 100 ]  &&treba
declare rec_no[ 100 ]

clear screen
@ 1,0,22,79 box background
@ 00, 00 say center( "Razduzivanje magacina" )
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Esc - Izlaz" )
save screen to screen1

select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name,m_no
else
  clos all
  RETURN   
endif		

select 1
if net_use( "CHANGES", .F. )
   set index to ch_dokum, ch_sd, ch_ds, ch_dob
else
   close all
   return
endif


select 2
if NET_USE ( 'ROBA', .F. )
   set index to r_name,r_no
else
  clos all
  RETURN   
endif


select 4
if NET_USE ( 'COMPANY', .F. )
else
  clos all
  RETURN   
endif

la = 1
curr = 1
do rfill_roba with la

m_datum = date()
m_dok = 'NI'
m_br_dok = space(10)
vrednost = 0
m_fakt_iznos = 0
do while .T.
do whole_screen with  "Razduzivanje magacina" 
   //restore screen from screen1
   m_dok='NI'
   @ 3, 0 to 3, 79
   @ 2, 1 say 'Datum:' get m_datum
   @ 2, 25 say 'Vrsta i broj dokumenta:' get m_dok picture '!!'
   @ 2, 55 get m_br_dok picture '@!'
   read
   if lastkey() = 27
      exit
   endif
//      m_br_fakt = space(20)
//      @ 5, 0 to 7, 79
//      @ 6, 1 say 'Faktura br:' get m_br_fakt picture '@!' valid !empty( m_br_fakt )
//      read
//      if lastkey() = 27 
//         loop
//      endif
//   save screen to screen2
   m_sifra = space(6)
   vrednost = 0
   jos_stavki = 'D'
//   prev_status = status_sifre
ox = 1
current = 1
last=100
select MESTA
do fill_rms with ox
do whole_screen with  "Razduzivanje magacina" 
  //restore screen from screen1
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
  tekuci = achoice(3,15,19,65,kart,.T.,'',tekuci,tekuci-1)
  do case
                                                                                                                                                                                          case tekuci != 0 
	 go rec_no[tekuci]
	 m_sifdob=sifra_m
	 case tekuci = 0
	 clos all
	 return
  endcase

   do while jos_stavki = 'D'
   do whole_screen with  "Razduzivanje magacina" 
   //restore screen from screen1
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double

  curr = achoice(3,20,19,60,roba,.T.,'',curr,curr-1)
  do case
     case curr !=0
	 select ROBA
	 go roba_no[curr]
	 m_sifra=sifra_r
//	 do zad_r with komintent,roba_o
//	 loop
     case curr = 0
          close all
          clear screen
          return
  endcase
  do whole_screen with  "Razduzivanje magacina" 
   //restore screen from screen1
     @ 14, 5 to 21, 74
     @ 15, 10 say "Naziv:         " +ROBA->NAZIV_R
	select CHANGES
	seek (m_dok+m_br_dok)+(m_sifra)
	if found()
	  m_kol=ch_kol
	  m_cena=ch_cena
	  m_rabat=0
	  else
	 store 0 to m_kol, m_cena, m_komada, m_rabat
	endif
        @ 18, 10 say "Kolicina:" get m_kol picture "99999999.999"
        @ 20, 10 say "Cena:    " get m_cena picture "99999999.999" 
     @ 23, 0 say centermsg( "Esc - Izlaz" )
     read
     if lastkey() = 27
        exit
     endif
     ok = 'D'
     @ 23, 0 say centermsg( ' Korektni podaci (D/N)' )
     @ 23, 65 get ok picture '!'
     read
     if ok = 'D'
        select CHANGES
	seek (m_dok+m_br_dok)+(m_sifra)
     if found()
	 do req_rec_lock
        replace CH_DATUM with m_datum, CH_SIFRA with m_sifra, CH_KOL with m_kol, CH_STATUS with 'I',;  && , CH_KOM with m_komada;
                CH_CENA with m_cena, CH_DOKUM with m_dok + m_br_dok, CH_DOB with m_sifdob  &&, CH_DATCEN with m_datum
				else 
				do new_rec
        replace CH_DATUM with m_datum, CH_SIFRA with m_sifra, CH_KOL with m_kol, CH_STATUS with 'I',;  && , CH_KOM with m_komada;
                CH_CENA with m_cena, CH_DOKUM with m_dok + m_br_dok, CH_DOB with m_sifdob   &&, CH_DATCEN with m_datum
      endif
	  else
     okx = 'D'
     @ 23, 0 say centermsg( ' Brisanje (D/N)' )
     @ 23, 65 get okx picture '!'
     read
      seek (m_dok+m_br_dok)+(m_sifra)
     if okx='D'
	 do req_rec_lock
	 delete
     endif
     endif
	 do whole_screen with  "Razduzivanje magacina" 
     @ 23, 0 say centermsg( 'Unos jos neke stavke  (D/N)' )
     @ 23, 65 get jos_stavki picture '!'
     read
   enddo  && while jos_stavki = 'D'
   enddo
     okx = 'D'
     @ 23, 0 say centermsg( ' Stampa otpremnice (D/N)' )
     @ 23, 65 get okx picture '!'
     read
	 if okx='N'
	 return
	 endif
     if okx='D'
	 ukupno=0
	 select ROBA
	 set order to 2
	 n=1
	 set device to print
for v=1 to 2
	 ukupno=0
     @ prow() +1,0 say chr(27) + chr(71)
     @ prow() +1,0 say chr(27) + chr(119)+'1'
//	 @ prow()+1,1 say COMPANY->co_line1
	 @ prow()+5,35 say 'OTPREMNICA BROJ: '+m_dok+m_br_dok
     @ prow() +1,0 say chr(27) + chr(119)+'0'
     @ prow() +1,0 say chr(27) + chr(72)
//     @ prow()+1, 1 say chr(15)
  
//	 @ prow()+1,1 say COMPANY->co_line2
//	 @ prow()+2,10 say 'OTPREMNICA BROJ: '+m_dok+m_br_dok
	 @ prow()+1,50 say rtrim(COMPANY->co_line3)+' '+ dtoc(m_datum)
	 @ prow()+2,10 say 'KUPAC: '+rtrim(MESTA->otk_m)+' - '+kart[tekuci]
	 @ prow()+2,0 say replicate('-',80)
	 @ prow()+1,0 say 'RB    Naziv                        Kolicina           Cena             Iznos'              
	 @ prow()+1,0 say replicate('-',80)

	select CHANGES
	seek (m_dok+m_br_dok)
	do while ch_dokum= (m_dok+m_br_dok)
	select ROBA
	seek CHANGES->ch_sifra
	 @ prow()+1,0 say n picture '99'
	 @ prow(),5 say rtrim(ROBA->naziv_r)
	 @ prow(),30 say CHANGES->ch_kol  picture '@E 999,999.99'
	 @ prow(),50 say CHANGES->ch_cena picture '@E 999,999.99'
	 @ prow(),68 say CHANGES->ch_kol*CHANGES->ch_cena picture '@E 9,999,999.99'
	 ukupno=ukupno+CHANGES->ch_kol*CHANGES->ch_cena
	 n=n+1
	select CHANGES
	 skip
	 enddo
	 @ prow()+1,0 say replicate('-',80)
	 @ prow()+1,50 say 'SVEGA:'
	 @ prow(),68 say ukupno picture '@E 9,999,999.99'
	 @ prow()+2,2 say 'U cenu uracunat PDV od 8%'
//	 @ prow()+1,2 say 'Ukupno zaduzenje u EUR___________'
//	 @ prow()+1,2 say 'Veza ugovor br.___________'
//	 @ prow()+2,2 say 'Prevoznik:'
//	 @ prow() ,35 say 'Robu preuzeo:'
//	 @ prow() ,65 say 'Robu izdao:'
//	 @ prow()+2,2 say '___________'
//	 @ prow() ,35 say '___________'
//	 @ prow() ,65 say '___________'
//@ prow() +1,0 say chr(27) + chr(87) + chr(48)
eject
next
	 endif
	 cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
	 set device to screen
//	 enddo
clos all
return

procedure mag_otkup
//#include "euro.ch"
clear screen
MAX=1000
declare kart [ 100 ]  &&treba
declare rec_no[ 100 ]

clear screen
@ 1,0,22,79 box background
@ 00, 00 say center( "Pregled stanja otkupnih mesta" )
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Esc - Izlaz" )
save screen to screen1

select 4
if NET_USE ( 'ZADUZ', .F. )
   set index to zad_sd, zad_xx
//   set index to zad_rd
else
  clos all
  RETURN   
endif

select 1
if net_use( "CHANGES", .F. )
   set index to ch_dob,ch_sd
else
   close all
   return
endif


select 2
if NET_USE ( 'ROBA', .F. )
   set index to r_no
else
  clos all
  RETURN   
endif

select 3
if NET_USE ( 'MESTA', .F. )
   set index to m_name, m_no
else
  clos all
  RETURN   
endif		
store 0 to ul_kol,iz_kol,rec_listed,ukupno
from_date = ctod( '01.01.' + substr( dtos( date() ), 1, 4 ) )
to_date = date()


   @ 3, 0 to 3, 79
   @ 2, 2 say "Od:" get from_date
   @ 2, 17 say "Do:" get to_date
   read
if lastkey()=27
clos all
return
endif
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Saldo-stampa/Saldo-ekran/Rekapi. (E/P/S/K/R)" )
@ 23, 75 get stampa picture '!'
read
if stampa='P'
do prt_mag_otkup
*clos all
return
endif
if stampa='S'
do jedi_mesta
clos all
return
endif
if stampa='K'
do ekran_jedi_mesta
clos all
return
endif
if stampa='R'
do rekapi
clos all
return
endif

m_sifdob=space(3)
ox = 1
current = 1
tekuci=1
last=100
select MESTA
do fill_rmsx with ox
do whole_screen with "Pregled stanja otkupnih mesta"
 // restore screen from screen1
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
  tekuci = achoice(3,15,19,65,kart,.T.,'',tekuci,tekuci-1)
  
  do case
     case tekuci = last
	 do all_mesta
	 return
     case tekuci !=0
	 go rec_no[tekuci]
	 m_sifdob=sifra_m
	 case tekuci = 0
	 clos all
	 return
  endcase
  do whole_screen with "Pregled stanja otkupnih mesta"
  //restore screen from screen1
	  xvred1=0
	  xvred2=0

  @ 1 , 1 say center(MESTA->naziv_m)
  @ 2 , 1 say 'Roba:               Magacin:    Vredn.:   Otkupno mesto:    Vredn.:    Stanje:'
	 save screen to scr2
  select ROBA
  do while !eof()
select CHANGES
set softseek on
seek m_sifdob+ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_dob=m_sifdob .and. ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
cena1=CH_CENA
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
cena1=CH_CENA
   endcase
   skip
   enddo
select ZADUZ
set softseek on
//seek m_sifdob+ROBA->sifra_r+dtos(from_date)
seek m_sifdob+ROBA->SIFRA_r+DTOS(from_date)
set softseek off
do while substr(sifra_zad,1,3)=m_sifdob .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()
cena1=ROBA->cena_r
ukupno=ukupno+kol_zad

skip
enddo
	  if iz_kol<>0 .or. ukupno<>0
      @ 4 + rec_listed, 1 say substr(roba->naziv_r,1,25)
      @ 4 + rec_listed, 23 say iz_kol picture '@E 9999999.99'
      @ 4 + rec_listed, 35 say iz_kol*cena1*(1+roba->pdv/100) picture '@E 9999999.99'
      @ 4 + rec_listed, 47 say ukupno picture '@E 99999999.99'
      @ 4 + rec_listed, 59 say ukupno*cena1*(1+roba->pdv/100) picture '@E 99999999.99'
      @ 4 + rec_listed, 70 say iz_kol-ukupno picture '@E 99999999.99'
	  xvred1=xvred1+iz_kol*cena1*(1+roba->pdv/100)
	  xvred2=xvred2+ukupno*cena1*(1+roba->pdv/100)
iz_kol=0
ul_kol=0
ukupno=0	  
cena1=0.00
     rec_listed=rec_listed+1
endif
	  if rec_listed=16
	  set cursor off
	  rec_listed=0
           @ 23,  0 say centermsg( 'Bilo sta za nastavak, ESC -> Izlaz' )
		   inkey(0)
		   do whole_screen with "Pregled stanja otkupnih mesta"
		   //restore screen from scr2
		   if lastkey()=27
	  set cursor on
     close all
     return
         endif
         endif
select ROBA
skip
enddo
     rec_listed=rec_listed+1
      @ 4+rec_listed, 1 say replicate('-',79)
     rec_listed=rec_listed+1
      @ 4+rec_listed, 10 say 'SVEGA:'
      @ 4+rec_listed, 34 say xvred1 picture '@E 9,999,999.99'
      @ 4+rec_listed, 57 say xvred2 picture '@E 99,999,999.99'
		   inkey(0)
		   clos all
return
//////////////////////////////////////////////////////////
procedure prt_mag_otkup
m_sifdob=space(3)
	  xvred1=0
	  xvred2=0
ox = 1
current = 1
tekuci=1
last=100
select MESTA
do fill_rmsx with ox
do whole_screen with "Pregled stanja otkupnih mesta"
  //restore screen from screen1
@ 2, 13 clear to 20, 67
@ 2, 13 to 20, 67 double
  tekuci = achoice(3,15,19,65,kart,.T.,'',tekuci,tekuci-1)
  
  do case
     case tekuci !=0
	 go rec_no[tekuci]
	 m_sifdob=sifra_m
	 case tekuci = 0
	 clos all
	 return
  endcase
//  restore screen from screen1
  set device to print
  	* LANDSCAPE PAGE with component based PCL commands:
@ prow(),0 say PCL_LAND
//@ prow(),pcol() say  PCL_10CPI + PCL_COUR 
// @ prow (),0 say chr(27)+'l2a'+'l10'+'k2S'         //&& HP landscape, compressed

// @ prow()+1, 1 say chr(27) + chr(15)
      @ prow()+1 , 1 say center('Otkupno mesto: '+MESTA->naziv_m)
      @ prow()+2 , 1 say replicate('-',100)
      @ prow()+1 , 1 say 'Roba:            Zaduzenje iz magacina:  '&&  Otkupno mesto:       Vrednost      Stanje:'
      @ prow() , 40 say 'Vrednost:'
      @ prow() , 55 say 'Otkupno mesto:'
      @ prow() , 70 say 'Vrednost:'
      @ prow() , 90 say 'Stanje:'
      @ prow() +1, 1 say replicate('-',100)

  select ROBA
  do while !eof()
select CHANGES
set softseek on
seek m_sifdob+ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_dob=m_sifdob .and. ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
   endcase
   skip
   enddo
select ZADUZ
set softseek on
seek m_sifdob+ROBA->sifra_r+dtos(from_date)
set softseek off
do while substr(sifra_zad,1,3)=m_sifdob .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()

ukupno=ukupno+kol_zad
cena1=cena

skip
enddo
	  if iz_kol<>0.0 .or. ukupno<>0.00
      @ prow()+1, 1 say substr(roba->naziv_r,1,25)
      @ prow(), 26 say iz_kol picture '@E 9,999,999.99'
      @ prow(), 40 say iz_kol*cena1*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ prow(), 55 say ukupno picture '@E 99999,999.99'
      @ prow(), 70 say ukupno*cena1*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ prow(), 90 say iz_kol-ukupno picture '@E 9999,999.99'
	  xvred1=xvred1+iz_kol*cena1*(1+roba->pdv/100)
	  xvred2=xvred2+ukupno*cena1*(1+roba->pdv/100)
	  endif
iz_kol=0
ul_kol=0
ukupno=0	  
cena1=0.00
//     rec_listed=rec_listed+1

select ROBA
skip
enddo
      @ prow() +1, 1 say replicate('-',100)
      @ prow()+1, 10 say 'SVEGA:'
      @ prow(), 40 say xvred1 picture '@E 99,999,999.99'
      @ prow(), 70 say xvred2 picture '@E 99,999,999.99'
      @ prow() +1, 1 say replicate('-',100)
//      @ prow()+1 , 1 say replicate('-',80)
cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
		   clos all
return

procedure fill_rmsx
parameters desc  
select mesta
go top
last = 1
do while !eof()
   kart [ last ] = naziv_m
//   kart1 [ last ] = otk_m
   rec_no [ last ] = recno()
   if last=desc
         tekuci = last
   endif
   last = last + 1
   skip
enddo

kart [ last ] = '*** Sva otkupna mesta ****'

for i = last + 1 to 100
    kart [ i ] = ''
next
return
////////////////////////////////////
////////////////////////////////
procedure all_mesta

  restore screen from screen1
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do prt_all_mesta
clos all
return
endif
      @ 2 , 1 say 'Roba:             Magacin:      Otk .mesto:       Stanje:'

select MESTA
go top
do while !eof()
  select ROBA
  go top
  do while !eof()
select CHANGES
set softseek on
seek MESTA->sifra_m+ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_dob=MESTA->sifra_m .and. ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
   endcase
   skip
   enddo
select ZADUZ
set softseek on
seek MESTA->sifra_m+ROBA->sifra_r+dtos(from_date)
set softseek off
do while substr(sifra_zad,1,3)=MESTA->sifra_m .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()

ukupno=ukupno+kol_zad
  
skip
enddo
	   if iz_kol<>0
      @ 4 + rec_listed, 1 say substr(roba->naziv_r,1,20)
      @ 4 + rec_listed, 22 say iz_kol picture '@E 9999,999.99'
      @ 4 + rec_listed, 34 say ukupno picture '@E 9,999,999.99'
      @ 4 + rec_listed, 48 say iz_kol-ukupno picture '@E 99,999,999.99'
      @ 4 + rec_listed, 62 say MESTA->naziv_m
iz_kol=0
ul_kol=0
ukupno=0	  
     rec_listed=rec_listed+1
	 endif

	  if rec_listed=16
	  set cursor off
	  rec_listed=0
           @ 23,  0 say centermsg( 'Bilo sta za nastavak, ESC -> Izlaz' )
		   inkey(0)
@ 3, 0 clear to 20, 79
		   if lastkey()=27
	  set cursor on
     close all
     return
         endif
         endif
select ROBA
skip
enddo
select MESTA
skip
enddo
		   inkey(0)
		   clos all
return

procedure prt_all_mesta
xvred1=0
xvred2=0
  set device to print
@ prow()+1,20 say 'Izvestaj  od '+' '+dtoc(from_date)+' do '+dtoc(to_date)
      @ prow()+2 , 1 say replicate('-',100)
      @ prow()+1 , 1 say 'Roba:            Zaduzenje iz magacina:  '&&  Otkupno mesto:       Vrednost      Stanje:'
      @ prow() , 43 say 'Vrednost:'
      @ prow() , 55 say 'Otkupno mesto:'
      @ prow() , 73 say 'Vrednost:'
      @ prow() , 90 say 'Stanje:'
      @ prow() +1, 1 say replicate('-',100)
  select MESTA
  go top
  do while !eof()
      @ prow()+1 , 1 say 'Otkupno mesto: '+MESTA->naziv_m
      @ prow() +1, 1 say replicate('-',100)
  select ROBA
  go top
  do while !eof()
select CHANGES
set softseek on
seek MESTA->sifra_m+ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_dob=MESTA->sifra_m .and. ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
   endcase
   skip
   enddo
  
select ZADUZ
set softseek on
seek MESTA->sifra_m+ROBA->sifra_r+dtos(from_date)
set softseek off
do   while substr(sifra_zad,1,3)=MESTA->sifra_m .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()

ukupno=ukupno+kol_zad

skip
enddo
		  if iz_kol<>0 .or. ukupno<>0
      @ prow()+1, 1 say substr(roba->naziv_r,1,25)
      @ prow(), 26 say iz_kol picture '@E 9,999,999.99'
      @ prow(), 40 say iz_kol*roba->cena_r*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ prow(), 55 say ukupno picture '@E 9,999,999.99'
      @ prow(), 70 say ukupno*roba->cena_r*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ prow(), 90 say iz_kol-ukupno picture '@E 99,999,999.99'
	  endif
	  xvred1=xvred1+iz_kol*roba->cena_r*(1+roba->pdv/100)
	  xvred2=xvred2+ukupno*roba->cena_r*(1+roba->pdv/100)
iz_kol=0
ul_kol=0
ukupno=0	  
select ROBA
skip
enddo
      @ prow() +1, 1 say replicate('-',100)
      @ prow()+1, 10 say 'SVEGA:'
      @ prow(), 40 say xvred1 picture '@E 99,999,999.99'
      @ prow(), 70 say xvred2 picture '@E 99,999,999.99'
      @ prow() +1, 1 say replicate('-',100)
xvred1=0
xvred2=0

select MESTA
skip
enddo

kol1=0
kol2=0
kol3=0
kol4=0
kol5=0
      @ prow()+1 , 1 say replicate('-',100)
      @ prow()+1 , 1 say 'REKAPITULACIJA ROBE'
	  select MESTA
	  set order to 2
select ZADUZ
	  set order to 2
	  select CHANGES
	  set order to 2
	  zadd='1'+space(5)
  select ROBA
  go top
  do while !eof()
select CHANGES
set softseek on
seek ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
select mesta
seek CHANGES->ch_dob
if !found()
select CHANGES
skip
loop
endif
select CHANGES
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
   endcase
   skip
   enddo

select ZADUZ
set softseek on
seek ROBA->SIFRA_r+DTOS(from_date)
set softseek off
do while sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()
select mesta
seek substr(ZADUZ->sifra_zad,1,3)
if !found()
select ZADUZ
skip
loop
endif
select ZADUZ
ukupno=ukupno+kol_zad
//wait kol_zad
skip
enddo
	//	  if iz_kol>0 .or. ukupno>0
      @ prow()+1, 1 say substr(roba->naziv_r,1,25)
      @ prow(), 26 say iz_kol picture '@E 99,999,999.99'
      @ prow(), 40 say iz_kol*roba->cena_r*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ prow(), 55 say ukupno picture '@E 99,999,999.99'
      @ prow(), 70 say ukupno*roba->cena_r*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ prow(), 90 say iz_kol-ukupno picture '@E 99,999,999.99'
	//  endif
	kol2=kol2+(iz_kol*roba->cena_r*(1+roba->pdv/100))
	kol4=kol4+(ukupno*roba->cena_r*(1+roba->pdv/100))
iz_kol=0
ul_kol=0
ukupno=0	  
 select ROBA
skip
enddo
      @ prow()+1 , 1 say replicate('-',100)
      @ prow()+1, 1 say 'UKUPNO:'
      @ prow(), 40 say kol2 picture '@E 99,999,999.99'
      @ prow(), 70 say kol4 picture '@E 99,999,999.99'
	  cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)

set device to screen
		   clos all
return

////////////////////////////////////////////
procedure jedi_mesta
xvred1=0
xvred2=0
general1=0
general2=0
cena1=0.00

  set device to print
@ prow()+1,20 say 'Izvestaj  od '+' '+dtoc(from_date)+' do '+dtoc(to_date)
      @ prow()+2 , 1 say replicate('-',82)
      @ prow()+1, 1 say 'Otkupno mesto:'
      @ prow() , 40 say 'Magacin:'
      @ prow() , 70 say 'Otkupno mesto:'
      @ prow() +1, 1 say replicate('-',82)
  select MESTA
  go top
  do while !eof()
      @ prow()+1 , 1 say +MESTA->naziv_m
  select ROBA
  go top
  do while !eof()
select CHANGES
set softseek on
seek MESTA->sifra_m+ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_dob=MESTA->sifra_m .and. ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
   endcase
   skip
   enddo
  
select ZADUZ
set softseek on
seek MESTA->sifra_m+ROBA->SIFRA_r+DTOS(from_date)
set softseek off
do while substr(sifra_zad,1,3)=MESTA->sifra_m .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()

cena1=cena
ukupno=ukupno+kol_zad

skip
enddo
	  xvred1=xvred1+iz_kol*cena1*(1+roba->pdv/100)
	  xvred2=xvred2+ukupno*cena1*(1+roba->pdv/100)
iz_kol=0
ul_kol=0
ukupno=0	  
cena1=0.00
select ROBA
skip
enddo
      @ prow(), 40 say xvred1 picture '@E 99,999,999.99'
      @ prow(), 70 say xvred2 picture '@E 99,999,999.99'
      @ prow() +1, 1 say replicate('-',82)
	  general1=general1+xvred1
	  general2=general2+xvred2
xvred1=0
xvred2=0

select MESTA
skip
enddo
      @ prow()+1, 1 say 'SVEGA:'
      @ prow(),40 say general1 picture '@E 99,999,999.99'
      @ prow(),70 say general2 picture '@E 99,999,999.99'
      @ prow() +1, 1 say replicate('-',82)
	  cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)

set device to screen
		   clos all
return

///////////////////////////////////
procedure ekran_jedi_mesta
clear screen
xvred1=0
xvred2=0
general1=0
general2=0
cena1=0

	  @ row()+1,20 say 'Izvestaj  od '+' '+dtoc(from_date)+' do '+dtoc(to_date)
      @ row()+1, 1 say 'Otkupno mesto:'
      @ row() , 25 say 'Magacin:'
      @ row() , 50 say 'Otkupno mesto:'
      @ row() , 65 say 'Saldo:'
      @ row() +1, 1 say replicate('-',79)
  select MESTA
  go top
  do while !eof()
      @ row()+1 , 1 say +MESTA->naziv_m
  select ROBA
  go top
  do while !eof()
select CHANGES
set softseek on
seek MESTA->sifra_m+ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_dob=MESTA->sifra_m .and. ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
   endcase
   skip
   enddo
  
select ZADUZ
set softseek on
seek MESTA->sifra_m+ROBA->SIFRA_r+DTOS(from_date)
set softseek off
do while substr(sifra_zad,1,3)=MESTA->sifra_m .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()
cena1=cena
ukupno=ukupno+kol_zad

skip
enddo
	  xvred1=xvred1+ul_kol*cena1*(1+roba->pdv/100)
	  xvred2=xvred2+ukupno*cena1*(1+roba->pdv/100)
iz_kol=0
ul_kol=0
ukupno=0	  
select ROBA
skip
enddo
      @ row(), 25 say xvred1 picture '@E 99,999,999.99'
      @ row(), 50 say xvred2 picture '@E 99,999,999.99'
      @ row() +1, 1 say replicate('-',79)
	  general1=general1+xvred1
	  general2=general2+xvred2
xvred1=0
xvred2=0
		if row()>=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
		inkey(0)
		@ 3,1 to 3,79
		@ 4,1 clear to 19,79
		endif

select MESTA
skip
enddo
      @ row()+1, 1 say 'SVEGA:'
      @ row(),25 say general1 picture '@E 99,999,999.99'
      @ row(),50 say general2 picture '@E 99,999,999.99'
      @ row(),65 say general1-general2 picture '@E 99,999,999.99'
      @ row() +1, 1 say replicate('-',79)
		inkey(0)
	clos all
return


/////////////////////////////////
///Rekapitulacija
////////////////////////
procedure rekapi
cena1=0
  restore screen from screen1
	  select MESTA
	  set order to 2
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer (E/P)" )
@ 23, 60 get stampa picture '!'
read
if stampa='P'
do druck_rekapi
clos all
return
endif
      @ 1,0 say center('REKAPITULACIJA ROBE ZA PERIOD: '+dtoc(from_date)+'-'+dtoc(to_date))
      @ row()+1,1 say 'Roba:     Magacin:  '
      @ row() , 25 say 'Vrednost:'
      @ row() , 40 say 'Otkupno mesto:'
      @ row() , 55 say 'Vrednost:'
      @ row() , 70 say 'Stanje:'
select ZADUZ
	  set order to 2
	  select CHANGES
	  set order to 2
	  zadd='1'+space(2)
  select ROBA
  go top
  do while !eof()
select CHANGES
set softseek on
seek ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
select mesta
seek CHANGES->ch_dob
if !found()
select CHANGES
skip
loop
endif
select CHANGES
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
   endcase
   skip
   enddo

select ZADUZ
set order to 2
set softseek on
seek ROBA->SIFRA_r+DTOS(from_date)
set softseek off
do while sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()
select mesta
seek substr(ZADUZ->sifra_zad,1,3)
if !found()
select ZADUZ
skip
loop
endif
select ZADUZ
cena1=cena
ukupno=ukupno+kol_zad
//wait kol_zad
skip
enddo
	//	  if iz_kol>0 .or. ukupno>0
      @ row()+1,0 say substr(roba->naziv_r,1,10)
      @ row(), 11 say iz_kol picture '@E 99,999,999.99'
      @ row(), 25 say iz_kol*cena1*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ row(), 39 say ukupno picture '@E 99,999,999.99'
      @ row(), 53 say ukupno*cena1*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ row(), 67 say iz_kol-ukupno picture '@E 99,999,999.99'
	//  endif
if row()=19
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)
	 if lastkey()=27
		  return
	  endif
  restore screen from screen1
      @ 1,0 say center('REKAPITULACIJA ROBE ZA PERIOD: '+dtoc(from_date)+'-'+dtoc(to_date))
      @ row()+1,1 say 'Roba:     Magacin:  '
      @ row() , 25 say 'Vrednost:'
      @ row() , 40 say 'Otkupno mesto:'
      @ row() , 55 say 'Vrednost:'
      @ row() , 70 say 'Stanje:'
endif
iz_kol=0
ul_kol=0
ukupno=0	  
 select ROBA
skip
enddo
      @ row()+1 , 1 say replicate('-',79)
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
inkey(0)

		   clos all
return

procedure druck_rekapi
vr_ulaza=0
vr_izlaza=0
cena1=0
set device to print
      @ prow()+1 , 1 say center('REKAPITULACIJA ROBE ZA PERIOD: '+dtoc(from_date)+'-'+dtoc(to_date))
      @ prow()+1 , 1 say 'Roba:      Zaduzenje iz magacina:  '
      @ prow() , 40 say 'Vrednost:'
      @ prow() , 55 say 'Otkupno mesto:'
      @ prow() , 75 say 'Vrednost:'
      @ prow() , 95 say 'Stanje:'
      @ prow()+1 , 1 say replicate('-',100)
select ZADUZ
	  set order to 2
	  select CHANGES
	  set order to 2
	  zadd='1'+space(5)
  select ROBA
  go top
  do while !eof()
select CHANGES
set softseek on
seek ROBA->sifra_r+dtos(from_date)
set softseek off
do while ch_sifra=Roba->sifra_r .and. ch_datum <=to_date .and. !eof()
select mesta
seek CHANGES->ch_dob
if !found()
select CHANGES
skip
loop
endif
select CHANGES
DO CASE
	  case CH_STATUS = "U"
      ul_kol=ul_kol+ CH_KOL 
      case CH_STATUS = "I"
      iz_kol=iz_kol+CH_KOL 
   endcase
   skip
   enddo

select ZADUZ
set order to 2
set softseek on
seek ROBA->SIFRA_r+DTOS(from_date)
set softseek off
do while sifra_zar=ROBA->SIFRA_r .and. datum_zad<=to_date .and. !eof()
select mesta
seek substr(ZADUZ->sifra_zad,1,3)
if !found()
select ZADUZ
skip
loop
endif
select ZADUZ
cena1=cena
ukupno=ukupno+kol_zad
skip
enddo
	//	  if iz_kol>0 .or. ukupno>0
      @ prow()+1, 1 say substr(roba->naziv_r,1,25)
      @ prow(), 26 say iz_kol picture '@E 99,999,999.99'
      @ prow(), 40 say iz_kol*cena1*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ prow(), 55 say ukupno picture '@E 99,999,999.99'
      @ prow(), 70 say ukupno*cena1*(1+roba->pdv/100) picture '@E 99,999,999.99'
      @ prow(), 90 say iz_kol-ukupno picture '@E 99,999,999.99'
	  vr_ulaza=vr_ulaza+iz_kol*roba->cena_r*(1+roba->pdv/100)
	  vr_izlaza=vr_izlaza+ukupno*cena1*(1+roba->pdv/100)
	//  endif
iz_kol=0
ul_kol=0
ukupno=0	  
cena1=0
 select ROBA
skip
enddo
      @ prow()+1 , 1 say replicate('-',100)
      @ prow()+1, 40 say vr_ulaza picture '@E 99,999,999.99'
      @ prow(), 70 say vr_izlaza picture '@E 99,999,999.99'
	  cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return

PROCEDURE xx
select 5
if NET_USE ( 'OTKUPM', .F. )
//   set index to otm_ssd
else
  clos all
  RETURN   
endif
parameters k_par

@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Bilo sta za nastavak..." )
store date() to datum1,datum2
ukupno=0.00
svega=0.00
drg=0
raz=0.00
svega1=0
svega2=0
svega3=0
svega4=0
mxx1=0
mxx2=0
mxx3=0
mxx4=0
xx1=0
xx2=0
xx3=0
xx4=0
treca=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
amb=0
@ 1,1 to 1,79
@ 00,00  say center(' ')
@ 00,10  say 'Od datuma :' get datum1
@ 00,40  say 'Do datuma :' get datum2
read
stampa='E'
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Ekran/Printer/Ambalaza (E/P/A)" )
@ 23, 60 get stampa picture '!'
read

@ 2,0 say center('Za sva mesta')
@ 4,25 say 'Prepod. :'
@ 4,39 say 'I klasa:'
@ 4,52 say 'II klasa:'
@ 4,67 say 'III klasa:'
@ 5,0 to 5,79
save screen to scr
w_c='102'
voc='100'

//set softseek on
//seek '10210020170701'
	seek w_c+VOC+DTOS(DATUM1)
//		wait w_c+VOC+DTOS(DATUM1)
	
//set softseek off
	//wait w_c+VOCE->SIFRA_V+DTOS(DATUM1)
	if found()
	wait '1'
 do while sifra_otk=(w_c) .and. sifra_otv=VOC .and. datum_otk<=datum2 .and. !eof()
 wait datum_otk
svega1=svega1+kol_otk 
svega2=svega2+raz_otk
svega3=svega3+kol_otkii	 
svega4=svega4+kol4
amb=amb+(ambu-ambv)
skip
enddo
endif
if svega1>0 .or. svega2>0 .or. svega3>0 .or. svega4>0
@ row()+1,20 say 'OM'
@ row(),24 say svega1 picture '@E 999,999.99'
@ row(),37 say svega2 picture '@E 999,999.99'
@ row(),49 say svega3 picture '@E 999,999.99'
@ row(),67 say svega4 picture '@E 999,999.99'
@ row()+1,0 to row()+1,79
mxx1=mxx1+svega1
mxx2=mxx2+svega2
mxx3=mxx3+svega3
mxx4=mxx4+svega4
endif
svega1=0
svega2=0
svega3=0
svega4=0
//////dovde otkupm
if row()>=19
inkey(0)
restore screen from scr
@ 5,0 to 5,79
endif

//endif
   
@ row()+1,0 say 'SVEGA:'
@ row(),20 say 'PR'
@ row(),24 say xx1 picture '@E 999,999.99'
@ row(),37 say xx2 picture '@E 999,999.99'
@ row(),49 say xx3 picture '@E 999,999.99'
@ row(),67 say xx4 picture '@E 999,999.99'
@ row()+1,20 say 'OM'
@ row(),24 say mxx1 picture '@E 999,999.99'
@ row(),37 say mxx2 picture '@E 999,999.99'
@ row(),49 say mxx3 picture '@E 999,999.99'
@ row(),67 say mxx4 picture '@E 999,999.99'



inkey(0)
return

////PO DATUMU JEDNO MESTO-SVO VOCE
procedure pr_jm_datum
set printer to stampa.prn
set device to print
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
w_c=sifra_m
@ prow()+1,1 say center('Otkupno mesto: '+naziv_m)
@ prow()+2,35 say 'Prepod. :'
@ prow(),49 say 'I klasa:'
@ prow(),62 say 'II klasa:'
@ prow(),77 say 'III klasa:'
@ prow()+1,0 say replicate ('-',90)
save screen to scr
select VOCE
go top
do while !eof()
//@ row()+1,0 say naziv_v
zz=datum2- datum1
select OTKUP
go top
for n=0  to zz
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1+n)
	if found()
do while substr(sifra_otk,1,3)=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum1+n .and. !eof()
ukupno=ukupno+kol_otk &&+raz_otk
raz=raz+raz_otk
drg=drg+kol_otkii
treca=treca+kol4
skip
enddo
endif
if ukupno>0.00 .or. raz>0.00 .or. drg>0.00 .or. treca>0.00
@ prow()+1,1 say datum1+n
@ prow(),12 say Voce->naziv_v
@ prow(),34 say ukupno picture '@E 999,999.99'
@ prow(),47 say raz picture '@E 999,999.99'
@ prow(),59 say drg picture '@E 999,999.99'
@ prow(),77 say treca picture '@E 999,999.99'
//@ prow()+1,0 to row()+1,79
if prow()>=64
eject
endif

endif
xx1=xx1+ukupno
xx2=xx2+raz
xx3=xx3+drg
xx4=xx4+treca
ukupno=0.00
drg=0
raz=0.00
treca=0
if prow()>=64
eject
endif
next
select VOCE

skip
enddo
endif
select MESTA
   set index to m_name,m_no
@ prow()+1,0 say replicate ('-',90)
@ prow()+1,0 say 'SVEGA:'
@ prow(),34 say xx1 picture '@E 999,999.99'
@ prow(),47 say xx2 picture '@E 999,999.99'
@ prow(),59 say xx3 picture '@E 999,999.99'
@ prow(),77 say xx4 picture '@E 999,999.99'
	  cOutFName := "stampa.prn"
cCmd := "NOTEPAD /A /P " + cOutFName
RUN ( cCmd)
set device to screen
return
////KRAJ



function pdf_create()
#include <hmg.ch>
#include <hmg_hpdf.ch>

   local lSuccess := .f.
   local cLB := chr( 10 )
  
   PRIVATE nCurLine:=10, nPageSize:=280, nVMargin:=10, nHMargin:=10 
		PRIVATE cFontName:="Times New Roman", pFontSize:=7,nFontSize:=8, nFontHeight:=3, nCharWidth:=2.2, gFontSize:=12
         nPrintRow := 10    
         nPrintCol := 10    
         nFontSize := 10
         nLine_Num :=  0
		 
   SELECT HPDFDOC 'HMG_HPDF_Doc.pdf' TO lSuccess papersize HPDF_PAPER_A4
   SET HPDFDOC COMPRESS ALL
   SET HPDFDOC PAGEMODE TO OUTLINE
   SET HPDFINFO AUTHOR      TO 'A.Kotarac'
   SET HPDFINFO CREATOR     TO 'ABS Solutions'
   SET HPDFINFO TITLE       TO 'HMG_HPDF Documentation'
   SET HPDFINFO SUBJECT     TO 'Documentation of LibHaru/HPDF Library in HMG'
   SET HPDFINFO KEYWORDS    TO 'HMG, HPDF, Documentation, LibHaru, Harbour, MiniGUI'
   SET HPDFINFO DATECREATED TO date() TIME time()
   if lSuccess

	START HPDFDOC
         START HPDFPAGE
		
 //           SET HPDFDOC PAGEOUTLINE TITLE "Introduction" 
 //           Draw_HeaderBox()
 //          Print_Header( "HMG_HPDF Introduction" )
 //          Print_Header( "HMG_HPDF Introduction" )
/*           cContent := "      Ja sam u stvari majstor za kompjutere" + ;
                        cLB + ;
                       
*/
					//if  HB_FileExists( 'logo.png' ) 
					//@ 5,  30 HPDFPRINT IMAGE "logo.png" width 140 height 40 ///size 10
					//	nCurLine:=45
					//	else
					
					//endif
					@ nCurLine,100 HPDFPRINT COMPANY->co_line1 FONT cFontName SIZE gFontSize ITALIC CENTER	 
					@ nCurLine+=5,60 HPDFPRINT rtrim(COMPANY->co_line2)+',  Tel. 031/3816-530,811-617'  FONT cFontName SIZE nFontSize ITALIC
					//@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 
					@ nCurLine+=5,60 HPDFPRINT 'Tek. racun 170-255-25,  EPPDV 132233732' FONT cFontName SIZE nFontSize
					@ nCurLine+=5,60 HPDFPRINT 'PIB: '+rtrim(COMPANY->co_line6)+' MB: '+rtrim(COMPANY->co_line7) SIZE nFontSize
					//@ 26,120 HPDFPRINT RECTANGLE ;
					//			TO 56,200 ;
					//			PENWIDTH 0.1 
					@ nCurLine+=10,70 HPDFPRINT 'Primalac priznanice' FONT cFontName SIZE gFontSize		
					@ nCurLine+=10,10 HPDFPRINT  'Prezime i ime: '+rtrim(komm[tek])+' '+'JMBG: '+&file1->jmbg SIZE nFontSize
				if substr(&file1->mesto_k,1,1)='A'					
					@ nCurLine+=5,10 HPDFPRINT 'Broj resenja-uverenja o porezu na kat. prihod: '+substr(&file1->mesto_k,1,22)	FONT cFontName SIZE nFontSize	
				else					
					@ nCurLine+=5,10 HPDFPRINT 'Izvod iz registra o upisu-aktivnom statusu polj. domacinstva: '+substr(&file1->mesto_k,1,22) FONT cFontName SIZE nFontSize
				endif	
				
				@ nCurLine+=20,60 HPDFPRINT LINE TO nCurLine,110
					@ nCurLine,60 HPDFPRINT 'PRIZNANICA Br. ' FONT cFontName SIZE gFontSize
					@ nCurLine,110 HPDFPRINT TRANSFORM(dokx,"@E 9999") RIGHT  SIZE gFontSize
				@ nCurLine+=5,60 HPDFPRINT LINE TO nCurLine,110	
				@ nCurLine+=25,30 HPDFPRINT  'Mesto i datum izdavanja: Pozega, ' +dtoc(datpz)  SIZE pFontSize
				@ nCurLine+=3,30 HPDFPRINT  'Vrsta i kolicina isporucenih dobara i vrsta i obim usluga'  SIZE pFontSize
				@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1
				@ nCurLine,10 HPDFPRINT 'RB        Vrsta dobra                                                   J.mere                         Kolicina               Cena bez                   Cena sa                                       Ukupan iznos' SIZE pFontSize
				@ nCurLine+=3,115 HPDFPRINT 'PDV                      PDV' SIZE pFontSize
				@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1
				
				
				select OTKUP
   set index to otk_vd,otk_sd
   staro_v=0
   kon=0
   kon1=0
   kon2=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
ukupno=0.00
ukupno_v=0.00
ukupno_d=0.00
ukupno_t=0.00
uku_v=0.00
uku_d=0.00
uku_t=0.00
uku_tr=0.00

svega=0.00
svega_v=0.00
robni=0.0
robni1=0.0
zbir_v=0.0
third=0
xsuma=0
n=0
v1='1'
v2='1'
v3='1'
v4='1'
select VOCE
   go top
   vc=cena_v
do while !eof()
/*
if sifra_v='105'
skip
loop
endif
if sifra_v='106'
skip
loop
endif
*/
select OTKUP
	go top
set softseek on
	seek w_c+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=rtrim(w_c) .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
prev_cena1=cena1
prev_cena2=cena2
prev_cena3=cena3
prev_cena4=cena4

uku_vd=uku_vd+kol_otk
uku_dd=uku_dd+raz_otk
uku_td=uku_td+kol_otkii
thirdd=thirdd+kol4
//uku_v=uku_v+kol_otk*VOCE->cena_v
//uku_d=uku_d+raz_otk*VOCE->druga
//uku_t=uku_t+kol_otkii*VOCE->treca
//uku_tr=uku_tr+kol4*cena4
uku_v=uku_v+kol_otk*cena1
uku_d=uku_d+raz_otk*cena2
uku_t=uku_t+kol_otkii*cena3
uku_tr=uku_tr+kol4*cena4

	skip

enddo
///OVDE OBRACUN SVEGA PRE STAMPE
svega_v=svega_V+uku_v
svega_v=svega_V+uku_d
svega_v=svega_V+uku_t
porezz=0
pioo=0
zdrr=0

do case

case &file1->kat='2'
brt=svega_v*1.020408163
tro=brt*.9
osn=brt-tro
porezz=osn*.2
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz
endif

case &file1->kat='3'
brt=svega_v*1.0482180
tro=brt*.9
osn=brt-tro
porezz=osn*.2
pioo=osn*.26
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo
endif

case &file1->kat='4'
brt=svega_v*1.0596588
tro=brt*.9
osn=brt-tro
porezz=osn*.2
pioo=osn*.26
zdrr=osn*.103
select OBAV
seek &file1->sifra_k+dtos(datpz)
if found()
do req_rec_lock
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo, zdr with zdrr
else
add_rec()
replace sifra with &file1->sifra_k, datum with datpz, ime with &file1->ime_k, posn with osn, porez with porezz, pio with pioo, zdr with zdrr
endif

endcase

xzbir=svega_v-porezz-pioo-zdrr
vkoef=xzbir/svega_v
vkoef=round(vkoef,5)
///DOVDE OBRACUN CENE

if !empty(uku_v)
n=n+1
@ nCurLine+=3,10 HPDFPRINT TRANSFORM(n,'9') FONT cFontName SIZE pFontSize
@ nCurLine,15 HPDFPRINT rtrim(VOCE->naziv_v)+' Prepodnevna' FONT cFontName SIZE pFontSize
@ nCurLine,70 HPDFPRINT 'kg' FONT cFontName SIZE pFontSize
@ nCurLine,90 HPDFPRINT TRANSFORM(uku_vd,'@E 999,999.99') FONT cFontName SIZE pFontSize

@ nCurLine,115 HPDFPRINT TRANSFORM(round(prev_cena1*vkoef,3),'@E 999.999') FONT cFontName SIZE pFontSize
@ nCurLine,135 HPDFPRINT TRANSFORM(round(prev_cena1*vkoef*1.08,0), '@E 999') FONT cFontName SIZE pFontSize
@ nCurLine,200 HPDFPRINT TRANSFORM(uku_vd*round(prev_cena1*vkoef,3),'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
xsuma=xsuma+uku_vd*round(prev_cena1*vkoef,3)

endif
if !empty(uku_d)
n=n+1
@ nCurLine+=3,10 HPDFPRINT TRANSFORM(n,'9') FONT cFontName SIZE pFontSize
//@ nCurLine,15 HPDFPRINT rtrim(VOCE->naziv_v)+' I klasa' FONT cFontName SIZE pFontSize
@ nCurLine,15 HPDFPRINT 'DOPLATA MALINE RODA 2024' FONT cFontName SIZE pFontSize
@ nCurLine,70 HPDFPRINT 'kg' FONT cFontName SIZE pFontSize
@ nCurLine,90 HPDFPRINT TRANSFORM(uku_dd,'@E 999,999.99') FONT cFontName SIZE pFontSize

@ nCurLine,115 HPDFPRINT TRANSFORM(round(prev_cena2*vkoef,3),'@E 999.999') FONT cFontName SIZE pFontSize
@ nCurLine,135 HPDFPRINT TRANSFORM(round(prev_cena2*vkoef*1.08,0),'@E 999') FONT cFontName SIZE pFontSize
@ nCurLine,200 HPDFPRINT TRANSFORM(uku_dd*round(prev_cena2*vkoef,3),'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
xsuma=xsuma+uku_dd*round(prev_cena2*vkoef,3)

endif

if !empty(uku_t)
n=n+1
@ nCurLine=+5,10 HPDFPRINT TRANSFORM(n,'9') FONT cFontName SIZE pFontSize
@ nCurLine,15 HPDFPRINT rtrim(VOCE->naziv_v)+' II klasa' FONT cFontName SIZE pFontSize
@ nCurLine,70 HPDFPRINT 'kg' FONT cFontName SIZE pFontSize
@ nCurLine,90 HPDFPRINT TRANSFORM(uku_td,'@E 999,999.99')FONT cFontName SIZE pFontSize

@ nCurLine,115 HPDFPRINT TRANSFORM(round(prev_cena3*vkoef,3),'@E 999.99') FONT cFontName SIZE pFontSize
@ nCurLine,135 HPDFPRINT TRANSFORM(round(prev_cena3*vkoef*1.08,0),'@E 999') FONT cFontName SIZE pFontSize
@ nCurLine,200 HPDFPRINT TRANSFORM(uku_td*round(prev_cena3*vkoef,3),'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
xsuma=xsuma+uku_td*round(prev_cena3*vkoef,3)

endif


zbir_v=zbir_v+ukupno_v


uku_v=0.00
uku_d=0.00
uku_t=0.00
ukupno_V=0.00
ukupno_d=0.00
ukupno_t=0.00
third=0
uku_vd=0
uku_dd=0
uku_td=0
thirdd=0
 select VOCE
skip
enddo

@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1
@ nCurLine+=3,10 HPDFPRINT 'a) Svega vrednost primljenih dobara:                        ' FONT cFontName SIZE pFontSize
@ nCurLine,200 HPDFPRINT TRANSFORM(xsuma,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1

//@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1
@ nCurLine+=3,10 HPDFPRINT 'b) Iznos PDV nadoknade obracunate poljoprivredniku (8%):' FONT cFontName SIZE pFontSize

if &file1->pdd='D'
@ nCurLine,200 HPDFPRINT TRANSFORM(xsuma*.08,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1

@ nCurLine+=3,10 HPDFPRINT 'I Ukupna vrednost dobara sa PDV (a+b):' FONT cFontName SIZE pFontSize
@ nCurLine,200 HPDFPRINT TRANSFORM(xsuma*1.08,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
else
@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1
@ nCurLine+=3,10 HPDFPRINT 'I Ukupna vrednost dobara sa PDV (a+b):' FONT cFontName SIZE pFontSize
@ nCurLine,200 HPDFPRINT TRANSFORM(xzbir,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize

endif

@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1  


**********ROBA
/////////*
ukupno=0.00
svega=0.0

select ROBA
go top
do while !eof()
select ZADUZ
go top
set softseek on
seek w_c+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=rtrim(w_c) .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
if ROBA->status=1
robni1=robni1+kol_zad*ROBA->cena_r*(1+ROBA->pdv/100)
else
robni=robni+kol_zad*ROBA->cena_r
endif
skip
enddo

select ROBA
skip
enddo
@ nCurLine+=3,10 HPDFPRINT  'c) Akontacija data u robi' FONT cFontName SIZE pFontSize
if !empty(robni1)
@ nCurLine,200 HPDFPRINT  TRANSFORM(robni1,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
else
@ nCurLine,200 HPDFPRINT  TRANSFORM(0.00,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
endif
@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1

@ nCurLine+=3,10 HPDFPRINT  'd) Akontacija data u novcu' FONT cFontName SIZE pFontSize
if !empty(robni)
@ nCurLine,200 HPDFPRINT  TRANSFORM(robni,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
endif
@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1
@ nCurLine+=3,10 HPDFPRINT 'II Ukupan iznos akontacije (c+d):' FONT cFontName SIZE pFontSize      
@ nCurLine,200 HPDFPRINT  TRANSFORM(robni+robni1,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1
if &file1->KAT='1'
@ nCurLine+=3,10 HPDFPRINT  'IZNOS ZA ISPLATU I-II TR: '   +&file1->tr FONT cFontName SIZE pFontSize
ELSE
@ nCurLine+=3,10 HPDFPRINT  'IZNOS ZA ISPLATU I-II  '  FONT cFontName SIZE pFontSize
ENDIF

if &file1->pdd='D'
If robni+robni1=0
@ nCurLine,200 HPDFPRINT  TRANSFORM(xsuma*1.08,'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
else
@ nCurLine,200 HPDFPRINT  TRANSFORM(xsuma*1.08-(robni+robni1),'@E 99,999,999.99') FONT cFontName  RIGHT SIZE pFontSize
endif
ELSE
@ nCurLine,200 HPDFPRINT  TRANSFORM(xsuma-(robni+robni1),'@E 99,999,999.99') FONT cFontName RIGHT SIZE pFontSize
ENDIF
@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 PENWIDTH 0.1
@ nCurLine+=25,10 HPDFPRINT  '    Obracun izvrsio:                                                                                                             M.P. ' FONT cFontName SIZE pFontSize
@ nCurLine,180 HPDFPRINT  '    Potpis primaoca' FONT cFontName SIZE pFontSize
@ nCurLine+=10,10 HPDFPRINT  '   __________________  ' FONT cFontName SIZE pFontSize
@ nCurLine,180 HPDFPRINT  '   __________________   ' FONT cFontName SIZE pFontSize
//eject
//next
		
		         END HPDFPAGE
		 END HPDFDOC
	
endif
  
execute file 'HMG_HPDF_Doc.pdf'
set safety off
  save all like dokx to xdokum
  set safety on
set device to screen
  return			
					
procedure ostalo				
if lsuccess	
					@ 50,125 HPDFPRINT 'PIB:'+w_pib FONT cFontName SIZE nFontSize
					
					@ nCurLine+=50,100 HPDFPRINT 'RACUN BROJ ' + FAKTURE->FA_BROJ+'/'+ substr(dtoc(FAKTURE->FA_DAT_FA),9,2)FONT cFontName SIZE gfontsize ITALIC CENTER
					@ nCurLine+=10,10 HPDFPRINT 'DATUM PROMETA DOBARA: ' + dtoc(FAKTURE->FA_DAT_OT) +'      '+'OTPREMNICA BR. '  + FAKTURE->FA_BR_OT+'       '+ ' VALUTA:  '  + dtoc(FAKTURE->FA_DAT_VA) size 10
					@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 
					@ nCurLine+=5,10 HPDFPRINT '  RB   Sifra       NAZIV  DOBRA             J.M.    Kolicina     Cena          Por.osn.    Stopa PDV      Ukup.naknada       Rabat%   ' SIZE 10
					@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 

w_vrednost=0
  w_prevoz  = FAKTURE->Fa_PREVOZ
  SELECT STAVKE
  SEEK f_broj
  ukupno = 0.0
  vred_robe = 0.0
  rb=0
  store 0.0 to ukurabat, w_rabat, ukumtz, w_mtz,TAKSA,tax_bp
  DO WHILE f_broj = FS_BROJ

     SELECT NAZIVI
     SEEK STAVKE->FS_ROBA
     if found()
	 w_proizvod = substr(stavke->fs_NAZIV,1,25)
     	w_jm = NZ_JM
		taksa=0
     else
       w_proizvod = substr(stavke->fs_NAZIV,1,25)
       store space(4) to w_jm
     endif

     SELECT STAVKE
	 //TRANSFORM( INVOICE->(RECNO()), "999" ) RIGHT  SIZE 9 
     @ nCurLine+=3,11 HPDFPRINT TRANSFORM( rb+=1, "999" ) RIGHT  SIZE 7
     @ nCurLine,15 HPDFPRINT  FS_ROBA  SIZE 7
     @ nCurLine,30 HPDFPRINT w_proizvod SIZE 7
     @ nCurLine,70 HPDFPRINT alltrim(w_jm) SIZE 7
     @ nCurLine,90 HPDFPRINT TRANSFORM(FS_KOL, "999999.999" ) RIGHT  SIZE 7
     @ nCurLine,110 HPDFPRINT TRANSFORM(FS_cena, "999999.999" ) RIGHT  SIZE 7
     w_vrednost = FS_KOL * FS_CENA
     w_rabat = round(w_vrednost * ( FS_RABAT / 100 ),2)
     vred_robe = vred_robe + (w_vrednost-w_rabat)
     w_mtz = FS_MTZ*FS_KOL
     ukumtz = ukumtz + w_mtz
     ukurabat = ukurabat + w_rabat
     @ nCurLine,130 HPDFPRINT TRANSFORM( w_vrednost, "99999999.99" ) RIGHT  SIZE 7
************************
select tarif
seek STAVKE->FS_TARIFA
if found()
       //  do get_current_tarifa_date with STAVKE->fs_tarifa, FAKTURE->fa_dat_fa
     @ nCurLine,140 HPDFPRINT TRANSFORM( p_osnovni, "999" ) RIGHT  SIZE 7 
     @ nCurLine,155 HPDFPRINT  TRANSFORM( (w_vrednost-w_rabat)*((p_osnovni)/100), "99999999.99" ) RIGHT  SIZE 7 
     @ nCurLine,180 HPDFPRINT TRANSFORM( (w_vrednost-w_rabat)+(w_vrednost-w_rabat)*((p_osnovni)/100), "99999999.99" ) RIGHT  SIZE 7  
	 @ nCurLine,198 HPDFPRINT TRANSFORM (STAVKE->fs_rabat, "999.99" ) RIGHT  SIZE 7  
endif
     select STAVKE

     if  FAKTURE->Fa_taxfree != 'D'    &&.and. w_mtz>0.00 &&& OVO ZA ORIGINALNE FAKTURE
            tmp_iznos = w_vrednost-w_rabat 
         select TMP_TAX
         seek STAVKE->FS_BROJ + STAVKE->FS_TARIFA
         if found()
            do req_rec_lock
            replace T_IZNOS with T_IZNOS + tmp_iznos
         else
            do new_rec
            replace T_FAKTURA with STAVKE->FS_BROJ,;
                    T_TARIF with STAVKE->FS_TARIFA,;
                    T_IZNOS with tmp_iznos,;
                    T_STATUS with substr(STAVKE->FS_ROBA,1,1)
         endif 
     endif
	 
     select STAVKE
     ukupno = ukupno + w_vrednost 
     skip
     red = prow() + 1
 //    rb = rb + 1
  ENDDO
		@ nCurLine+=3,10 HPDFPRINT LINE TO nCurLine,200 
  if ukurabat > 0
  				@ nCurLine+=5,140 HPDFPRINT 'Rabat:' FONT cFontName SIZE nFontSize
				@ nCurLine,180 HPDFPRINT TRANSFORM (-ukurabat, "@E 99,999,999.99" ) RIGHT  SIZE 7  
     ukupno = ukupno - round(ukurabat,2)
				@ nCurLine+=3,140 HPDFPRINT LINE TO nCurLine,180 
  
  endif
				@ nCurLine+=5,140 HPDFPRINT 'Osnovica:' FONT cFontName SIZE nFontSize
				@ nCurLine,180 HPDFPRINT TRANSFORM (vred_robe, "@E 99,999,999.99" ) RIGHT  SIZE nFontSize
  
//  if w_prevoz > 0
//     @ prow()+1,82 say ' Prevoz:'
//     @ prow(),84 say w_prevoz picture '@E 99,999,999,999.99'
//     ukupno = ukupno + w_prevoz
//  endif
* display poreze po stopama

      //do pr_tax
      totalporez = ukupososn + ukuposrep + ukuosn + ukubg
      if totalporez > 0
         ukupno = ukupno + round(totalporez,2)
      endif

@ nCurLine+=3,140 HPDFPRINT LINE TO nCurLine,180 
  ukupno = round(ukupno,2)   				
  				@ nCurLine+=5,140 HPDFPRINT 'UKUPNO:' FONT cFontName SIZE nFontSize
				@ nCurLine,180 HPDFPRINT TRANSFORM (ukupno, "@E 99,999,999.99" ) RIGHT  SIZE nFontSize 
  				@ nCurLine+=5,40 HPDFPRINT 'Uslovi prodaje___________________________________' FONT cFontName SIZE 8
				@ nCurLine+=5,40 HPDFPRINT 'Napomena o poreskom oslobadjanju__________________' FONT cFontName SIZE 8
	  
  if !empty(fakture->fa_note1)
  @ nCurLine+=5,125 HPDFPRINT  "POSEBNA NAPOMENA:" FONT cFontName SIZE nFontSize
  @ nCurLine+=5,125 HPDFPRINT  FAKTURE->FA_NOTE1 FONT cFontName SIZE nFontSize
  @ nCurLine+=5,125 HPDFPRINT  FAKTURE->FA_NOTE2 FONT cFontName SIZE nFontSize
  @ nCurLine+=5,125 HPDFPRINT  FAKTURE->FA_NOTE3 FONT cFontName SIZE nFontSize
  endif

select LICE
@ nCurLine+=10,10 HPDFPRINT  'ODGOVORNO LICE' FONT cFontName SIZE 8
@ nCurLine+=3,10 HPDFPRINT  LICE->IME FONT cFontName SIZE 8
@ nCurLine,50 HPDFPRINT  '                                    ROBU PRIMIO                                                              ROBU IZDAO' FONT cFontName SIZE 8
//@ nCurLine+=3,10 HPDFPRINT  rtrim(LICE->ADRESA)+' '+LICE->MESTO FONT cFontName SIZE 8
//@ nCurLine+=3,10 HPDFPRINT  LICE->JMBG FONT cFontName SIZE 8
@ nCurLine,50 HPDFPRINT  '                              ______________                                       ______________'
@ nCurLine+=3,10 HPDFPRINT  LICE->LK FONT cFontName SIZE 8
@ nCurLine+=3,10 HPDFPRINT  LICE->TELEFON FONT cFontName SIZE 8
@ nCurLine+=10,10 HPDFPRINT  'Mesto i datum izdavanja racuna: '+rtrim(COMPline3) +', '+ DTOC(FAKTURE->FA_DAT_FA) SIZE 8

//  cDefaultPrinter := WIN_PRINTERGETDEFAULT() 
// WIN_PRINTFILERAW( cDefaultPrinter, "stampa.prn" )
            //Print_Content( cContent )
         END HPDFPAGE
		 END HPDFDOC
endif	
// restore screen from fscr
  
execute file 'HMG_HPDF_Doc.pdf'
return
