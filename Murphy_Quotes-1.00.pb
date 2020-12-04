; M U R P H Y ' S   L A W   Q U O T E S
;  Originally by James Marshall   December 19, 1995
; Rewritten for purebasic, December 14, 2010 by John Duchek
;working 2020-1204 v1.00
; Randomly selects And prints one of a selected number of sayings from
; _The_Complete_Murphy's_Law_ by Arthur Bloch


Global Dim Murphy.s(400)
Global total.i

Procedure load_data()
  If ReadFile(0, "Murphy.data")   ; if the file could be read, we continue...
    While Eof(0) = 0                ; loop as long the 'end of file' isn't reached
      i=i+1
      Murphy(i)= ReadString(0)      
     
      
    Wend
    total=i
    For i=1 To total
      Debug Murphy(i)
      Next
    CloseFile(0)      ; close the previously opened file
  Else
    MessageRequester("Information","Couldn't open the file!")
  EndIf
   EndProcedure
   load_data()
   ran.i=Random(total)
  
   Enumeration
#win_main
#button_close
EndEnumeration
Global quit.b=#False
#flags=#PB_Window_SystemMenu|#PB_Window_ScreenCentered
If OpenWindow(#win_main,0,0,300,200,"Murphy Says:",#flags)
If WindowID(win_main)
ButtonGadget(#button_close,10,10,290,190, murphy(ran),#PB_Button_MultiLine)
Repeat
event.l=WaitWindowEvent()
Select event
Case #PB_Event_Gadget
Select EventGadget()
   Case #button_close
   quit=#True
   EndSelect
   EndSelect
   Until event = #PB_Event_CloseWindow Or quit=#True
   EndIf
   EndIf
   End
   
; IDE Options = PureBasic 5.73 LTS (Linux - x64)
; CursorPosition = 3
; Folding = -
; EnableXP
; Executable = ../2012-Pure_SC/Executables - Linux/Murphys_Law