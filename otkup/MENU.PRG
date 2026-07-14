//set printer to stampa.prn
//? "Printer redirected !"
//inkey(1)
clear screen
//set procedure to util
//if date()>=ctod('06/01/2006')
//!del otkup.exe
//endif
ANNOUNCE HB_GT_SYS
REQUEST HB_GT_WIN
REQUEST HB_GT_WVT_DEFAULT
///////////////////AZURIRAJ PATH !!!!!!!!!!!!!!!!!!!!!!!
//set device to print
//set print on
//set talk off
//?? chr(27)+"(s0ps1s16.66H"
//?? chr(27)+"(s0ps0b"
//?? chr(27)+"(s1s"
//?? chr(27)+"&k2S"
//?? chr(27)+"&l4C"
set device to screen
* altd(1)     
clear screen
firma='OTKUP MALINE'
//firma='OTKUP KUPINE'
set path to z:\euro2017
clear typeahead
*do Init_mat
shade = replicate(chr(176),9)

//setmode (48,128)
setmode (25,80)
set exclusive off
set confirm on
set date german
set scoreboard off
set deleted on
set century on
if !file("c:\windows\dos.sys")
? 'PROGRAM NEPRAVILNO INSTALIRAN !!!! ZOVITE SASU !!!!'
quit
endif

USE_COLORS = iscolor()
if USE_COLORS
   DEFAULT     = 'W/B+,N/BG,,,R/W'
   DEF_GREEN   = 'W/G+,N/BG,,,R/W'
   DEF_MAGENTA = 'W/RB+,N/BG,,,R/W'
   DEF_YELLOW  = 'W/GR+,N/BG,,,R/W'
   DEF_RED     = 'W/R+,N/BG,,,R/W'
   INV_RED     = 'N/R'
   INV_CYAN    = 'N/BG'
   INV_GREEN   = 'N/G'
   INV_YELLOW  = 'N/GR+'
   INV_MAGNETA = 'N/RB+'
   BOX_COLOR   = 'W+33/B'
   SHADE_COLOR = 'N+/N+'
   MESS_BLINK  = "W*+/R"   
   MESS        = "W+/R"    
   HI_INT      = "W+/B+"  
   HI_BLINK    = "W+*/R+"  
else
   DEFAULT     = "W/N,N/W,,,N/W"
   DEF_GREEN   = "W/N,N/W,,,N/W"
   DEF_MAGENTA = "W/N,N/W,,,N/W"
   DEF_YELLOW  = "W/N,N/W,,,N/W"
   DEF_RED     = "W/N,N/W,,,N/W"
   INV_RED     = 'N/R'
   DEFAULT_INV = 'i'
   INV_RED     = 'i'
   INV_CYAN    = 'i'
   INV_GREEN   = 'i'
   INV_YELLOW  = 'i'
   INV_MAGNETA = 'i'
   SHADE_COLOR = ''
   BOX_COLOR   = "W/N,N/W,,,N/W"
   MESS_BLINK  = "i*"
   MESS        = "i"  
   HI_INT      = "W+"  
   HI_BLINK    = "W+*"  
endif
   setcolor(DEFAULT)
subidu     = chr(194) + chr(196) + chr(194) +chr(179) +chr(193) +;
             chr(196) + chr(193) + chr(179) 
subidubida = chr(194) + chr(196) + chr(191) +chr(179) +chr(217) +;
             chr(196) + chr(193) + chr(179) 
* double line top and single  line sides
double_top     = chr(213) + chr(205) + chr(184) +chr(179) +chr(190) +;
                 chr(205) + chr(212) + chr(179) 
* double line top and single  line sides         
doublebottomrestsingle = chr(218) + chr(196) + chr(191) +chr(179) +chr(190) +;
                            chr(205) + chr(212) + chr(179) 
* single line top and double line sides
single_top = chr(214) + chr(196) + chr(183) +chr(186) +chr(189) +;
             chr(196) + chr(211) + chr(186)
background = chr(178) + chr(177) + chr(177) +chr(177) +chr(177) +;
             chr(177) + chr(177) + chr(177) + chr(177) && white background

frame      = chr(201) + chr(205) + chr(187) +chr(186) +chr(188) +;
             chr(205) + chr(200) + chr(186) 
double_bottom = chr(179) + chr(32) + chr(179) +chr(179) +chr(190) +;
                chr(205) + chr(212) + chr(179) 
shade = chr(176) + chr(176) + chr(176) +chr(176) +chr(176) +;
        chr(176) + chr(176) + chr(176)

@ 4,0, 20,79 box background 
@ 0,0, 20, 79 box frame

parent = 1                 && main menu selection (to get submenu..child)
child  = 1
set message to 23 center   && display MESSAGEs on line 22
set wrap on
public file1
public ind1
public ind2
public m_pr
public MAX
public otk_sifra
public komintent
public voce_o
public ox
public tekuci
keyboard chr(13)
declare M_ZAD[ 2 ]
M_ZAD[ 1 ] = 'Zaduzenje  '
M_ZAD[ 2 ] = 'Razduzenje '
do prt_main_menu
@ 22,0 to 24,79
ZAGLAVLJE = center(firma)
@ 0,0 say ZAGLAVLJE
public main_menu
save screen to main_menu
menu to parent
do while .T.
   do sub_menu with parent
      if child != 0
	 keyboard chr(13)
      else
	 if nextkey() = 0

	    exit
	 endif
      endif
	  
restore screen from main_menu
@ 4,0, 20,79 box background 
@ 0,0, 20, 79 box frame
   do prt_main_menu
   menu to parent
enddo
set color to                          && SET COLOR
clear screen


*@ 8,26,13,55 box shade
*set color to i
*@ 8,26 say "    KOTARAC  ALEKSANDAR      "
*@ 9,26 say "  Heroja Bondzulica 29/52    "
*@ 10,26 say "         31210 Pozega       "
*@ 11,26 say "        (031) 817-526       "
*@ 7,25 to 12,54 double
*@ 13, 0 say ""
set cursor on
quit

procedure prt_main_menu
   @ 01,01 to 03,20
   @ 02,02 prompt "Unos              " 
   @ 01,20, 03,40 box subidu
   @ 02,21 prompt "Izvestaji          "
   @ 01,40,03,60 box subidu
   @ 02,41 prompt "Ambalaza           " 
   @ 01,60,03,78 box subidubida
   @ 02,61 prompt "Ostalo           " 
return
* end of print main menu 


*procnedure .............. sub_menu calls the child menus
procedure sub_menu
parameter parent_menu
       set key 19 to left_arrow
       set key 4 to right_arrow
       do case                         
	  case parent_menu = 1         
	       do m_sub1         
	  case parent_menu = 2         
	       do m_sub2
	  case parent_menu = 3
	       do m_sub3
	  case parent_menu = 4
	       do m_sub4
       endcase
       menu to child
       do Strelice                &&   reset the left and right arrow keys
       do case
	  case parent_menu = 1
	       do case
		  case child = 1
		   cFunction := "Otkup"
           xRetVal :=DO( cFunction )
	//		do otkup  //&& e_voce
		  case child = 2
		  cFunction := "zaduz"
           xRetVal :=DO( cFunction )
//        do (zaduz)  //&& e_kom
		  case child = 3 
		  cFunction := "e_roba"
           xRetVal :=DO( cFunction )
//			do (e_roba)
		  case child = 4
		  cFunction := "e_voce"
           xRetVal :=DO( cFunction )
//			do (e_voce)
		  case child = 5
		  cFunction := "e_kom"
           xRetVal :=DO( cFunction )
//			do (e_kom)
		  case child = 6
		  cFunction := "e_mesta"
           xRetVal :=DO( cFunction )
//			 do (e_mesta)
		  case child = 7
                       @ 10, 23, 13, 36 box shade
                       @ 09, 22 to 12, 35
                       choice = achoice( 10, 23, 11, 34, M_ZAD )
                       do case
                          case choice = 1
						  cFunction := "xzaduz"
                          xRetVal :=DO( cFunction )
 //                              do (xzaduz)
                          case choice = 2
						  cFunction := "xrazduz"
                          xRetVal :=DO( cFunction )
 //                              do (xrazduz)
                       endcase
		  case child = 8
		  cFunction := "otm"
		  //cFunction := "xx"
          xRetVal :=DO( cFunction )
//			 do (otm)   // &&e_voce
	       endcase  
	  case parent_menu = 2
	       do case
		  case child = 1
		  cFunction := "preg_otk"
          xRetVal :=DO( cFunction )
//		     do (preg_otk)  //&& e_mesta
		  case child = 2
		  cFunction := "preg_zad"
          xRetVal :=DO( cFunction )
//		     do (preg_zad)  // &&e_roba
		  case child = 3
		  cFunction := "zbir"
          xRetVal :=DO( cFunction )
//		     do (zbir) //&& preg_zb
		  case child = 4
		  cFunction := "knjiz"
          xRetVal :=DO( cFunction )
//		     do (knjiz)  // && preg_zb
		  case child = 5
		  cFunction := "new_zbir"
          xRetVal :=DO( cFunction )
//		     do (new_zbir) //&& preg_zb
		  case child = 6
		  cFunction := "preg_mes"
          xRetVal :=DO( cFunction )
//		     do (preg_mes) // && e_mesta
	       endcase   
	  case parent_menu = 3
	       do case
		  case child = 1
		  cFunction := "amb"
          xRetVal :=DO( cFunction )
//			do (amb)
		  case child = 2
		  cFunction := "amb_pomestu"
          xRetVal :=DO( cFunction )
//		     do (amb_pomestu)
		  case child = 3
		  cFunction := "knj_amb"
          xRetVal :=DO( cFunction )
//		     do (knj_amb)
		  case child = 4
		  cFunction := "l_chngs"
          xRetVal :=DO( cFunction )
//			do (l_chngs)
		  case child = 5
		  cFunction := "l_zaldan"
          xRetVal :=DO( cFunction )
//			do (l_zaldan) //&& l_chngs
		  case child = 6
		  cFunction := "mag_otkup"
          xRetVal :=DO( cFunction )
//			do (mag_otkup)  //&& xzaduz
		  case child = 7
		  cFunction := "nab"
          xRetVal :=DO( cFunction )
//			do (nab)  //&& l_chngs
	      endcase   
	  case parent_menu = 4
	       do case
		  case child = 1
		  cFunction := "indexx"
          xRetVal :=DO( cFunction )
//		     do (indexx)
		  case child = 2
          cFunction := "spisak_mesta"
          xRetVal :=DO( cFunction )		  
//		     do (spisak_mesta)   //&&e_mesta
		  case child = 3
		  cFunction := "spisak_sifra"
          xRetVal :=DO( cFunction )
//		     do (spisak_sifra)  //&&e_mesta
		  case child = 4
		  cFunction := "ps"
          xRetVal :=DO( cFunction )
//             do (ps)
		  case child = 5
		  cFunction := "oxx"
          xRetVal :=DO( cFunction )
//			do (oxx)    //&&&e_mesta
		  case child = 6
		  cFunction := "to_del"
          xRetVal :=DO( cFunction )
//			do (to_del)
		  case child = 7
		  cFunction := "firma"
          xRetVal :=DO( cFunction )
//			do (firma)
		  case child = 8
		  cFunction := "akontacija"
          xRetVal :=DO( cFunction )
//			do (akontacija)   //  &&e_voce
		  case child = 9
		  cFunction := "pr_cene"
          xRetVal :=DO( cFunction )
//			do (pr_cene)  //&&e_mesta
	      endcase   
       endcase           &&   parent  ends
return
*eop sub_menu




*procedure .............. set cursor for left arrow
procedure left_arrow
parameter pn, pl, rv
*            esc ,  left  arrow, return
   keyboard chr(27) + chr(19) + chr(13)
return
*eop left_arrow

*procedure .............. set cursor for right arrow
procedure right_arrow
parameter pn, pl, rv
*             esc,    right arrow, return
     keyboard chr(27) + chr(4) + chr(13)
return
* eop right_arrow


* sub menu for 'Unos'
procedure m_sub1

    @ 5,02,13,21  box shade
    @ 04,01,12,20 box double_bottom  
	@ 22,0 to 24,79
    @ 3, 01 say chr(195) 
    @ 3, 20 say chr(197) 
    @ 04,02 prompt "Otkup voca        " message "Unos i ispravka otkupa voca"
    @ 05,02 prompt "Unos zaduzenja    " message "Unos zaduzenja robe"
    @ 06,02 prompt "Roba              " message "Unos i ispravka robe"
    @ 07,02 prompt "Voce              " message "Unos i ispravka podataka o vocu"
    @ 08,02 prompt "Proizvodjaci      " message "Unos i ispravka podataka o proizvodjacima"
    @ 09,02 prompt "Otkupna mesta     " message "Unos i ispravka otkupnih mesta i otkupljivaca"
    @ 10,02 prompt "Magacin           " message "Unos i ispravka robe u magacinu"
    @ 11,02 prompt "Unos maline       " message "Unos i ispravka podataka o malini sa otkupnog mesta"
return


* sub menu for 'Izvestaji'
procedure m_sub2

    @ 5,22,11,41  box shade			
    @ 04,20,10,40 box double_bottom  
	@ 22,0 to 24,79
    @ 3, 20 say chr(195) 
    @ 3, 40 say chr(197) 
    @ 04,21 prompt "Pregled otkupa     " message "Pregled otkupa voca  po otkupnom mestu, proizvodjacu ili ukupno"
    @ 05,21 prompt "Pregled zaduzenja  " message "Pregleg zaduzenja robom i novcem"
    @ 06,21 prompt "Pregled salda      " message "Pregled otkupa voca i zaduzenja robom"
    @ 07,21 prompt "Knjizenje          " message "Pregled knjizenja za period"
    @ 08,21 prompt "Kolicinski saldo   " message "Pregled i stampa kolicinskog salda"
    @ 09,21 prompt "Saldo maline       " message "Pregled i stampa kolicinskog salda maline na otkupnom mestu"
return

* sub menu for 'Sifarnici'
procedure m_sub3

    @ 5,42,12,61  box shade
    @ 04,40,11,60 box double_bottom  
	@ 22,0 to 24,79
    @ 3, 40 say chr(195) 
    @ 3, 60 say chr(197) 
     @ 04,41 prompt "Ambalaza           " message "Unos i ispravka zaduzenja ambalaze"
     @ 05,41 prompt "Izvestaj o ambalazi" message "pregled i stampa izvestaja o ambalazi"
     @ 06,41 prompt "Knjizenje ambalaze " message "Pregled knjizenja ambalaze"
     @ 07,41 prompt "Pregled robe       " message "Pregled knjizenja robe "
     @ 08,41 prompt "Zalihe  robe       " message "Pregled zaliha robe "
     @ 09,41 prompt "Pregled zaduzenja  " message "Pregled zaduzenja otkupnh mesta"
     @ 10,41 prompt "Pregled nabavke    " message "Pregled nabvke robe"
return

* sub menu for 'Ostalo'
procedure m_sub4

    @ 5,62,14,79  box shade
    @ 04,60,13,78 box double_bottom  
	@ 22,0 to 24,79
    @ 3, 60 say chr(195)   
    @ 3, 78 say chr(180) 
    @ 04,61 prompt "Indeksiranje     " message "Indeksiranje baza "
    @ 05,61 prompt "Otkupna mesta    " message "Pregled i stampa otkupnih mesta"
    @ 06,61 prompt "Proizvodjaci     " message "Pregled i stampa proizvodjaca"
    @ 07,61 prompt "Pocetno stanje   " message "Izrada pocetnog stanja"
    @ 08,61 prompt "Stampa proizv.   " message "Stampa proizvodjaca za avans"
    @ 09,61 prompt "Skrivanje mesta  " message "Skrivanje i povrat mesta"
    @ 10,61 prompt "Firma            " message "Podaci o firmi"
    @ 11,61 prompt "Akontacija       " message "Izrada akontacije"
    @ 12,61 prompt "Promena cena     " message "Promena cena"
*return


******************************************************************************
Procedure LevoDesno
       set key 19 to levo
       set key 4 to desno
return

Procedure Levo
parameter p
   keyboard chr(27)
return

Procedure Desno
parameter p
   keyboard chr(27)
return

Procedure Strelice
       set key 4 to
       set key 19 to
return


procedure indexx
set cursor off
clear screen
@ 1,0, 22,79 box background
//set color to i
@ 00, 00 say center( "Indeksiranje datoteka (potrebno u slucaju nestanka struje i sl.)" )
//set color to
@ 3, 2, 19, 77 box shade
@ 2, 1, 18, 76 box frame
@ 2, 2 say ' Baza: '
@ 2, 11 say ' Komentar: '
@ 2, 59 say ' Status: '
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "Enter  Indeksiraj, Razmaknica  Preskoci" )
@ 23, 0 say centermsg( "Esc  Izlaz" )

select 1
use INDEXES
index on IX_DB_NAME to IX_DB
go top

red = 2
baza = 'X'

do while !eof()
 //  if alltrim(INDEXES->IX_DB_NAME) != baza
      baza = alltrim(INDEXES->IX_DB_NAME)
//	  wait baza
      do ind_m1 with baza, INDEXES->IX_COMMENT
      do case
         case lastkey() = 27   && esc
              exit
         case lastkey() = 13   && enter
              select 2
              use &baza exclusive
              do ind_m2 with INDEXES->IX_KEY, alltrim(INDEXES->IX_IX_NAME)
              @ red, 60 say '*REINDEXIRANO*'
         otherwise
              @ red, 60 say '--------------'
      endcase
//   else
 //     if lastkey() = 13
 //        select 2
 //        do ind_m2 with INDEXES->IX_KEY, alltrim(INDEXES->IX_IX_NAME)
 //        @ red, 60 say '*REINDEXIRANO*'
 //     endif
//   endif
   select INDEXES
   skip
 enddo
set cursor on
close all
return


procedure ind_m1
parameter baza, komentar
red = red + 1
if red > 17
   red = 17
   scroll( 3, 2, 17, 75, 1 )
endif
@ 22, 0 say centermsg( "Enter  Indeksiraj, Razmaknica  Preskoci" )
@ 23, 0 say centermsg( "Esc  Izlaz" )
@ red, 3 say baza
@ red, 12 say komentar
@ red, 60 say 'Indeksiranje?'
inkey(0)
return

procedure ind_m2
parameters i_key, i_name
@ red, 60 say 'INDEXIRAM...  '
@ 22, 0 say centermsg( "Sacekajte..." )
@ 23, 0 say centermsg( "Kreiram index: "  + i_name )
index on &i_key to &i_name
return






procedure st_covek
private vcc,mz_svega,mz_robni
vcc=0
mz_malina=0
mz_svega=0
mz_robni=0
mz_mal=0
dug=0
vc=0
strana=1
set device to print
  @ prow()+1, 1 say chr(27) + chr(15)
select MESTA
   set index to m_no,m_name
seek substr(k_par,1,3)
if found()
@ prow()+1,10 say 'Pregled zaduzenja robom za period '+dtoc(datum1)+ ' - '+dtoc(datum2)+'     '+'strana: '+str(strana)
@ prow()+1,0 say replicate('-',130)
@ prow()+1,20 say 'Za otkupno mesto: '+naziv_m
@ prow()+1,0 say replicate('-',130)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Vrednost:'
@ prow(),62 say 'Pred. maline (kg):'
@ prow(),80 say 'Pred. maline (din):'
@ prow(),105 say 'Dug (din.):'
@ prow(),120 say '% duga:'
@ prow()+1,0 say replicate('-',130)
endif
select KOM
   set index to kom_name
*seek substr(k_par,1,3)
*if found()
*do while sifra_k=substr(k_par,1,3) .and. !eof()
do while !eof()
stampa='0'
if substr(sifra_k,1,3)!=substr(k_par,1,3)
skip
loop
endif
select ROBA
go top
do while !eof()
select ZADUZ
set index to zad_rd
go top
set softseek on
seek KOM->SIFRA_K+ROBA->SIFRA_r+DTOS(DATUM1)
set softseek off
do while sifra_zad=KOM->SIFRA_K .and. sifra_zar=ROBA->SIFRA_r .and. datum_zad<=datum2 .and. !eof()
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
if !empty(ukupno)
if stampa='0'
@ prow()+1,1 say substr(KOM->sifra_k,2,5)+' '+KOM->IME_K
@ prow()+1,0 say replicate('-',130)
endif
@ prow()+1,0 say ROBA->naziv_r
@ prow(),35 say ukupno picture '@E 999,999.99'
@ prow(),50 say ukupno*ROBA->cena_r picture '@E 999,999.99'
@ prow(),65 say robni1 picture '@E 999,999.99'
@ prow()+1,0 say replicate('-',130)
stampa='1'
endif
mz_svega=mz_svega+ukupno*ROBA->cena_r
svega=svega+ukupno*ROBA->cena_r
robni1=0.00
ukupno=0.00	 
if prow()>=60
eject
strana=strana+1
@ prow()+1,100 say 'Strana: '+str(strana)
@ prow()+2,0 say replicate('-',130)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Vrednost:'
@ prow(),62 say 'Pred. maline (kg):'
@ prow(),80 say 'Pred. maline (din):'
@ prow(),105 say 'Dug (din.):'
@ prow(),120 say '% duga:'
@ prow()+1,0 say replicate('-',130)
endif

select ROBA
skip
enddo

select VOCE
go top
do while !eof()
select OTKUP
   set index to otk_sd
go top
set softseek on
seek KOM->SIFRA_K+VOCE->SIFRA_V+DTOS(DATUM1)
set softseek off
do while sifra_otk=KOM->SIFRA_K .and. sifra_otv=VOCE->SIFRA_V .and. datum_otk<=datum2 .and. !eof()
vcc=vcc+kol_otk &&+raz_otk
mz_malina=mz_malina+kol_otk*VOCE->cena_v &&+raz_otk
vc=VOCE->cena_v
skip
enddo
select VOCE
skip
enddo
mz_robni=mz_robni+vcc
if mz_malina!=0
if stampa='0' 
@ prow()+1,1 say substr(KOM->sifra_k,2,5)+' '+KOM->IME_K
@ prow()+1,0 say replicate('-',130)
endif
@ prow()+1,50 say mz_svega picture '@E 999,999.99'
@ prow()  ,65 say vcc picture '@E 999,999.99'
@ prow(),80 say mz_malina picture '@E 99,999,999.99'
@ prow(),100 say mz_svega-mz_malina picture '@E 99,999,999.99'
if mz_svega!=0.0 .and. mz_malina!=0
@ prow(),120 say ((mz_malina-mz_svega)*100)/mz_malina picture '@E 999.99'
endif
@ prow()+1,50 say replicate('=',80)
endif
*dug=dug+(mz_robni-vcc)*vc
dug=dug+mz_robni
mz_mal=mz_mal+mz_malina
vcc=0
mz_svega=0
*mz_robni=0
mz_malina=0
if prow()>=60
eject
strana=strana+1
@ prow()+2,0 say replicate('-',130)
@ prow()+1,100 say 'Strana: '+str(strana)
@ prow()+1,35 say 'Kolicina:'
@ prow(),50 say 'Vrednost:'
@ prow(),62 say 'Pred. maline (kg):'
@ prow(),80 say 'Pred. maline (din):'
@ prow(),105 say 'Dug (din.):'
@ prow(),120 say '% duga:'
@ prow()+1,0 say replicate('-',130)
endif

select KOm
skip
enddo
*endif
@ prow()+1,0 say replicate('-',130)
@ prow()+1,0 say 'SVEGA:'
@ prow(),50 say svega picture '@E 999,999.99'
@ prow(),65 say mz_robni picture '@E 999,999.99'
@ prow(),80 say mz_mal picture '@E 99,999,999.99'
@ prow(),100 say svega-mz_mal picture '@E 99,999,999.99'
*@ 19,01 say 'ROBNO ZAD.MALINE (kg) :'
*@ 19,65 say robni picture '@E 999,999.99'
*@ 20,01 say 'ZADUZENJE MALINE (kg) :'
*@ 20,65 say svega/VOCE->cena_v picture '@E 999,999.99'
@ prow()+3,0 say '       '
set device to screen
return
*******************************
procedure firma
clear screen
use COMPANY exclusive
@ 6,10 say "NAZIV:    " get CO_line1
@ 8,10 say "ADRESA:   " get CO_line2
@ 10,10 say "MESTO:  " get CO_line3
@ 12,10 say "TELEFON:  " get CO_line4
@ 14,10 say "ZIRO RN:  " get CO_line5
@ 16,10 say "PIB    :  " get CO_line6
@ 18,10 say "MATICNI BROJ    :  " get CO_line7
@ 20,10 say "SIFRA DELATNOSTI    :  " get CO_line8
read
close all
return
////UTIL>PRG
procedure new_rec
set deleted off
seek '???'
if found()
   if MUST_REC_LOCK() 
      recall
      set deleted on
      return
    endif
endif
if ADD_REC()   && append blank successfull
   set deleted on
endif
return

function centermsg
private message
parameters string
    if len(string) >= 80       
       return string
    endif
    message = space(38 - int(len(string)/2)) + string
return  "³" + message + space( 78 - len( message ) ) + "³"

Function red_screen
parameters xstring
@ 00, 00 say center( xstring)
@ 1, 0 , 21, 79 box background
@ 2, 18 clear to 20, 62
@ 2, 18 to 20, 62 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
return

Function voce_screen
parameters xstring
@ 00, 00 say center( xstring)
@ 1, 0 , 21, 79 box background
@ 2, 0 clear to 20, 79
@ 1, 30 say 'Prepodnevna         I klasa        II klasa'
@ 2, 4 to 20, 80 double
@ 21, 0 to 24, 79
@ 22, 0 say centermsg( "  Gore,   Dole, PgUp  Prethodna strana, PgDn  Sledeca strana" )
@ 23, 0 say centermsg( "Home  Pocetak, End  Kraj, Esc  Izlaz" )
return

Function whole_screen
parameters xstring
@ 00, 00 say center( xstring)
@ 1,0,22,79 box background
@ 22, 0 to 24, 79
@ 23, 0 say centermsg( "Esc - Izlaz" )
return

function center
*private str, width
parameters str
    if len(str) >= 80 
       return str
    endif
    str = space(40 - int(len(str)/2)) + str
return str + space( 80 - len( str ) )

FUNCTION   NET_USE
PARAMETERS file, ex_use
DO WHILE .T.
   IF ex_use      && exclusive
      USE &file EXCLUSIVE
   ELSE
      USE &file   && shared
   ENDIF
   IF ! NETERR()  && USE succeeds
      RETURN (.T.)
   ENDIF
   save screen to usescr
   @ 22, 1 clear to 23, 78
   @ 22, 0 say centermsg( 'Datoteka &file zauzeta pritisnite bilo koju tipku da probamo ponovo ili')
   @ 23, 0 say centermsg( "Esc  Izlaz" )
   if INKEY(0) = Esc
      exit
   endif
ENDDO
restore screen from usescr
RETURN (.F.)  

FUNCTION   xNET_USE
PARAMETERS file, ex_use
DO WHILE .T.
   IF ex_use      && exclusive
      USE &file EXCLUSIVE
   ELSE
      USE &file   && shared
   ENDIF
   IF ! NETERR()  && USE succeeds
      RETURN (.T.)
   ENDIF
   exit
ENDDO
RETURN (.F.)  

FUNCTION FIL_LOCK
PARAMETERS file   && used only for error message
DO WHILE .T.
   IF FLOCK()
      RETURN (.T.)	&& locked
   ENDIF
   save screen to lckscr
   @ 22, 1 clear to 23, 78
   @ 22, 0 say centermsg( 'Datoteka  &file  zauzeta pritisnite bilo koju tipku da probamo ponovo ili')
   @ 23,  0 say centermsg( "Esc  Izlaz" )
   if INKEY(0) = Esc
      exit
   endif
ENDDO
restore screen from lckscr
RETURN (.F.)	&& not locked

FUNCTION FX_LOCK
PARAMETERS file, ex_use
DO WHILE .T.
   IF ex_use      && exclusive
      USE &file EXCLUSIVE
   ENDIF
   IF ! NETERR()  && USE succeeds
      RETURN (.T.)
   ENDIF
ENDDO
RETURN (.F.)  

FUNCTION REC_LOCK 
DO WHILE .T.
   IF RLOCK()
      RETURN (.T.)		&& locked
   ENDIF
   save screen to lckscr
   @ 22, 1 clear to 23, 78
   @ 22, 0 say centermsg( 'Informacija zauzeta pritisnite bilo koju tipku da probamo ponovo ili')
   @ 23, 0 say centermsg( "Esc  Izlaz" )
   if INKEY(0) = Esc
      exit
   endif
ENDDO
restore screen from lckscr
RETURN (.F.)			&& not locked

FUNCTION req_REC_LOCK 
save screen to lckscr
DO WHILE .T.
   IF RLOCK()
      restore screen from lckscr
      RETURN (.T.)		&& locked
   ENDIF
   @ 22, 1 clear to 23, 78
   @ 22, 0 say centermsg( 'Informacija zauzeta sacekajte')
   @ 23, 0 say centermsg( " " )
ENDDO

FUNCTION ADD_REC
save screen to lckscr
DO WHILE .T.
   APPEND BLANK
   IF ! NETERR()
      restore screen from lckscr
      RETURN (.T.)
   ENDIF
   @ 22, 1 clear to 23, 78
   @ 22, 0 say centermsg( 'Datoteka zauzeta sacekajte da se upis informacije omoguci')
ENDDO

FUNCTION MUST_REC_LOCK 
   IF RLOCK()
      RETURN (.T.)		&& locked
   else
      RETURN (.F.)			&& not locked
   endif



FUNCTION comperr
sum=0
for i = 1 to 30
   sum= sum + asc(substr(company_name,i,1))
next

*? sum
*wait
if sum <> 1532
   return(.T.)
endif
return(.F.)


FUNCTION LPR
  DO WHILE !isprinter()
     @ 23,00 say centermsg("Stampac nije spreman! Pritisnite neku tipku za nastavak. Esc  Prekid stampe")
     inkey(0)
     if lastkey() = Esc
        RETURN (.F.)
     endif
  ENDDO
RETURN (.T.)


function slova
parameters broj
store "" to isp
do case
  case broj ='01' 
       isp = "prvi"
  case broj = '02' 
       isp = "drugi"
  case broj = '03'
       isp = "tre}i"
  case broj = '04'
       isp = "~etvrti"
  case broj = '05'
       isp = "peti"
  case broj = '06'
       isp = "{esti"
  case broj = '07'
       isp = "sedmi" 
  case broj = '08'
       isp = "osmi"
  case broj = '09'
       isp = "deveti"
  case broj = '10'
       isp = "deseti"
  case broj = '11' 
       isp = "jedanaesti"
  case broj = '12'
       isp = "dvanaesti"
  case broj = '13'
       isp = "trinaesti"
  case broj = '14'
       isp = "~etrnaesti"
  case broj = '15'
       isp = "petnaesti"
  case broj = '16'
       isp = "{esnaesti"
  case broj = '17' 
       isp = "sedamnaesti"
  case broj = '18'
       isp = "osamnaesti"
  case broj = '19'
       isp = "devetnaesti"
  case broj = '20'
       isp = "dvadeseti"
  case broj = '21'
       isp = "dvadesetprvi"
  case broj = '22'
       isp = "dvadesetdrugi"
  case broj = '23'
       isp = "dvadesettreci"
  case broj = '24'
       isp = "dvadeset~etvrti"
  case broj = '25'
       isp = "dvadesetpeti"
  case broj = '26'
       isp = "dvadeset{esti"
  case broj = '27'
       isp = "dvadesetsedmi"
  case broj = '28'
       isp = "dvadesetosmi"
  case broj = '29'
       isp = "dvadesetdeveti"
  case broj = '30' 
       isp = "trideseti"
  case broj = '31'
       isp = "tridesetprvi"
endcase
return (isp)

function mesec
parameters broj_1
store "" to isp_1
do case
  case broj_1 ='01' 
       isp_1 = "JANUAR"
  case broj_1 = '02' 
       isp_1 = "FEBRUAR"
  case broj_1 = '03'
       isp_1 = "MART"
  case broj_1 = '04'
       isp_1 = "APRIL"
  case broj_1 = '05'
       isp_1 = "MAJ"
  case broj_1 = '06'
       isp_1 = "JUN"
  case broj_1 = '07'
       isp_1 = "JUL" 
  case broj_1 = '08'
       isp_1 = "AVGUST"
  case broj_1 = '09'
       isp_1 = "SEPTEMBAR"
  case broj_1 = '10'
       isp_1 = "OKTOBAR"
  case broj_1 = '11' 
       isp_1 = "NOVEMBAR"
  case broj_1 = '12'
       isp_1 = "DECEMBAR"
endcase
return (isp_1)
PROCEDURE PrintCodes( cCtrlCode )
   
   LOCAL nRow     := PROW()                     // Save the current row
   LOCAL nCol     := PCOL()                     // Save the current column
   LOCAL lPrinter := SET( _SET_PRINTER, .T. )   // SET PRINTER ON
   LOCAL lConsole := SET( _SET_CONSOLE, .F. )   // SET CONSOLE OFF

   ?? cCtrlCode                  // Send the code(s) to the printer

   SETPRC( nRow, nCol )          // Restore the previous row/column settings
   SET( _SET_PRINTER, lPrinter ) // Restore printer setting
   SET( _SET_CONSOLE, lPrinter ) // Restore console setting

   RETURN 


