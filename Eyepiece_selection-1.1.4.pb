;Eyepiece Selection ---- (c) by John Duchek
; Version 1.1.4, with 293 eyepieces
;2010-12-05 completed with filesave as replacement for REALbasic program
;adjusting fonts for windows & linux as they don't match
;Last change 2020-1204 - working
version.s="1.1.4"
; runs under Windows or Linux
Declare read_user()
Declare read_file()
Declare write_user()
Structure eyepiece
  brand.s
  focal_length.f
  app_fov.f
 EndStructure
;"Eyepiece"," Size(mm) ","App FOV "
 Global Dim ep.eyepiece(350)
 Global Dim eye_load.s(350)
Global total.l
Global u_pupil.f, u_aperture.f, u_fratio.f

read_file()
read_user()

Enumeration
  #win_main
  ;----- Text -----
#text_g1
#text_g2
#text_g3
#text_g4
;----- Input boxes -----
#input_g1
#input_g2
#input_g3
;----- Input Labels -----
#input_lbl_g1
#input_lbl_g2
#input_lbl_g3
;----- Output boxes -----
#output_g1
#output_g2
#output_g3
#output_g4
#output_g5
#output_g6
#output_g7
#output_g8
#output_g9
;----- Output Labels -----
#output_lbl_g1
#output_lbl_g2
#output_lbl_g3
#output_lbl_g4
#output_lbl_g5
#output_lbl_g6
#output_lbl_g7
#output_lbl_g8
;----- Fonts -----
#Font1
;----- Lists -----
#listicon_g1
;----- Buttons -----
#button_close
EndEnumeration
Global quit.b=#False
#flags=#PB_Window_SystemMenu|#PB_Window_ScreenCentered
If #PB_Compiler_OS =2 ;Linux
Font1 = LoadFont(#PB_Any, "Arial"  ,10 ,#PB_Font_Bold)
font2 = LoadFont(#PB_Any, "Arial"  ,12 ,#PB_Font_Bold)
EndIf

If #PB_Compiler_OS =1 ;Windows
Font1 = LoadFont(#PB_Any, "Arial"  ,10 ,#PB_Font_Bold)
font2 = LoadFont(#PB_Any, "Arial"  ,12 ,#PB_Font_Bold)
EndIf
If OpenWindow(#win_main,0,0,1024,600,"Eyepiece Selector by Pupil Size",#flags)
  If WindowID(win_main)
    
    SetGadgetFont(#PB_Any,FontID(font1))
 TextGadget(#text_g1,10,10,1000,20,"Decide which eyepieces will work with your eyes and telescope. Enter your maximum pupil size and your telescope aperture and F/ratio.  Click on ")
TextGadget(#text_g2,10,30,1000,20,"your choice of eyepiece to see the recommendation and % of light that will be lost.  It allows 1mm clearance in the pupil to allow for edge effects.")
TextGadget(#text_g3,200,550,1000,20,"John Duchek (john.duchek@asemonline.org), 2006-2020, Version "+version)
TextGadget(#text_g4,200,570,1000,20,"Additional eyepieces can be added to eyepiece.data in a text editor. Put it in alphabetical order.")
SetGadgetFont(#PB_Any,FontID(font2))

TextGadget(#input_lbl_g1,25,60,280,20,"Your eye's pupil size (mm)")
TextGadget(#input_lbl_g2,325,60,280,20,"Your Telescope Aperture (mm)")
TextGadget(#input_lbl_g3,625,60,280,20,"Your Telescope F/ratio")

TextGadget(#output_lbl_g3,600,160,160,30,"App FOV (deg) :")
TextGadget(#output_lbl_g4,800,160,160,30,"Actual FOV (deg) :")
TextGadget(#output_lbl_g5,600,260,160,30,"Power :")
TextGadget(#output_lbl_g6,800,260,160,30,"Exit Pupil (mm) :")
TextGadget(#output_lbl_g7,600,360,160,20,"Light Lost (%) : ")
TextGadget(#output_lbl_g8,800,360,160,20,"Recommend ?(Y/N) :")
TextGadget(#output_g9,600,475,160,20,"# EP Database : "+Str(total+1))
StringGadget(#input_g1,25,80,280,30,StrF(u_pupil,1))
StringGadget(#input_g2,325,80,280,30,StrF(u_aperture,0))
StringGadget(#input_g3,625,80,280,30,StrF(u_fratio,1))


;----- Output -----
StringGadget(#output_g3,600,200,160,30,"")
StringGadget(#output_g4,800,200,160,30,"")
StringGadget(#output_g5,600,300,160,30,"")
StringGadget(#output_g6,800,300,160,30,"")
StringGadget(#output_g7,600,400,160,30,"")
StringGadget(#output_g8,800,400,160,30,"")
ListIconGadget(#listicon_g1, 25,140,500,400,"Eyepiece : ",300,#PB_ListIcon_GridLines|#PB_ListIcon_FullRowSelect|#PB_ListIcon_AlwaysShowSelection)
AddGadgetColumn(#listicon_g1,2,"Size (mm) : ",100)
AddGadgetColumn(#listicon_g1,3,"App FOV : ",100)

ButtonGadget(#button_close, 830,475,100,40,"Quit")
;SetActiveGadget(#String_input)
For i=1 To total
  AddGadgetItem(#listicon_g1,i,ep(i)\brand+Chr(10)+StrF(ep(i)\focal_length,1)+Chr(10)+StrF(ep(i)\app_fov,1))
  Next

Repeat
event.l=WaitWindowEvent()
Select event
Case #PB_Event_Gadget
Select EventGadget()
  
  Case #button_close
    u_pupil = ValF(GetGadgetText(#input_g1))
    u_aperture = ValF(GetGadgetText(#input_g2))
    u_fratio = ValF(GetGadgetText(#input_g3))
    write_user()
     quit=#True
   Case #listicon_g1
     Gosub calculate
     
   EndSelect
   
   EndSelect
   Until event = #PB_Event_CloseWindow Or quit=#True
   EndIf
 EndIf
 
   End
   calculate:
  item.l=GetGadgetState(#listicon_g1)
 If item =-1 
       Goto nada
     EndIf
     aperture.f=ValF(GetGadgetText(#input_g2))
     f_ratio.f=ValF(GetGadgetText(#input_g3))
     app_fov.f = ep(item)\app_fov
     pupil_mm.f=ValF(GetGadgetText(#input_g1)) -1
     focal_length.f =aperture *f_ratio
     mag.f=focal_length/(ep(item)\focal_length)
     act_fov.f=app_fov/mag
     exit_pupil.f = aperture/mag
     exit_pupil_area.f = Pow(0.5*exit_pupil,2)
     user_pupil_area.f =Pow(0.5*pupil_mm,2)
     If user_pupil_area >= exit_pupil_area
       ep_light_loss.f=0
     Else
       ep_light_loss.f=(exit_pupil_area - user_pupil_area)/exit_pupil_area
     EndIf
     If ep_light_loss = 0
       recommend.s="yes"
     Else
       recommend.s=" no"
       EndIf
     SetGadgetText(#output_g3,StrF(app_fov,0))
     SetGadgetText(#output_g4,StrF(act_fov,3))
     SetGadgetText(#output_g5,StrF(mag,1))
     SetGadgetText(#output_g6,StrF(exit_pupil,1))
     SetGadgetText(#output_g7,StrF(ep_light_loss*100,1))
     SetGadgetText(#output_g8,recommend)
    nada: 
    Return
    Procedure read_user()
      
    
If ReadFile(0, "user.data")
  u_pupil = ValF(ReadString(0))
  u_aperture=ValF(ReadString(0))
  u_fratio=ValF(ReadString(0))
  
  	CloseFile(0)
Else
	MessageRequester("Error", "Could not open the file: 'user.data'.")
EndIf
 
 
EndProcedure
Procedure write_user()
If CreateFile(0, "user.data")
  WriteStringN(0, StrF(u_pupil,2))
  WriteStringN(0, StrF(u_aperture,2))
  WriteStringN(0, StrF(u_fratio,2))

  CloseFile(0)
Else
  MessageRequester("PureBasic", "Error: can't write the file", 0)
  End
EndIf  

EndProcedure

Procedure read_file()
  
If ReadFile(1, "eyepiece.data")

  ; if the file could be read, we continue...
    While Eof(1) = 0                ; loop as long the 'end of file' isn't reached
      i=i+1
      eye_load(i)=ReadString(1)
      leng.i=Len(eye_load(i))
      leng1.i=FindString(eye_load(i),",")
      ep(i)\brand= Left(eye_load(i),leng1-1)
      eye_load(i)=Right(eye_load(i),leng-leng1)
      ep(i)\focal_length=ValF(eye_load(i))
      
      leng=Len(eye_load(i))
      leng1=FindString(eye_load(i),",")
      eye_load(i)=Right(eye_load(i),leng-leng1)
     ep(i)\app_fov=ValF(eye_load(i))
    Wend
    total=i
  
  
  Else
    MessageRequester("Information","Couldn't open the file!")
  EndIf

  	CloseFile(1)
  
EndProcedure
; IDE Options = PureBasic 5.73 LTS (Linux - x64)
; CursorPosition = 4
; Folding = 8
; EnableXP
; Executable = Eyepiece_selection-1.1.3.exe