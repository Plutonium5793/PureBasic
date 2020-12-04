Global Dim Einstein.s(100)
Global total.i,i.i

; E I N S T E I N   Q U O T E S
   ; by James Marshall  August 31, 1995
   ;Randomly selects And prints a saying from a List of quotes by Einstein
; redone in purebasic by John Duchek (john.duchek@asemonline.org) v1.00
;working 2020-1204, with data file

Procedure load_data()
  If ReadFile(0, "Einstein.data")   ; if the file could be read, we continue...
    While Eof(0) = 0                ; loop as long the 'end of file' isn't reached
      i=i+1
      Einstein(i)= ReadString(0)      
     
      
    Wend
    total=i
    ;For i=1 To total
   ;   Debug Einstein(i)
   ;   Next
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
If OpenWindow(#win_main,0,0,600,300,"Einstein Says:",#flags)
If WindowID(win_main)
ButtonGadget(#button_close,10,10,590,290, Einstein(ran),#PB_Button_MultiLine)
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
; CursorPosition = 6
; Folding = +
; EnableXP