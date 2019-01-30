[PCOMM SCRIPT HEADER]
LANGUAGE=VBSCRIPT
DESCRIPTION=confirms a printer msgw
[PCOMM SCRIPT SOURCE]
OPTION EXPLICIT
autECLSession.SetConnectionByName(ThisSessionName)

Dim errmsg,errdata,timeout
timeout = 5000
errmsg = ""
errdata = ""

main

'If not errmsg = "" Then
'  msgbox errmsg
'  msgbox errdata
'End If


function main()
  wait()
  If not read(1,25,30) = "Work with Signage Output Queue" Then
    If not waitFor("Work with Signage Output Queue",1,25,timeout) Then
      errmsg = "expected signage output queue screen"
      errdata = read(1,25,30)
      Exit function
    End If
  End If
  write("[pf12]")

  write("[pf10]")

  wait()
  If not read(1,30,22) = "Work with Output Queue" Then
    If not waitFor("Work with Output Queue",1,30,timeout) Then
      errmsg = "expected work output queue screen"
      errdata = read(1,30,22)
      Exit function
    End If
  End If
  write("[pf22]")

  wait()
  If not read(1,30,22) = "Work with All Printers" Then
    If not waitFor("Work with All Printers",1,30,timeout) Then
      errmsg = "expected all printers screen"
      errdata = read(1,30,22)
      Exit function
    End If
  End If

  If read(14,19,3) = "END" Then
    StartPrinter()
  End If

  ConfirmMessage()

  wait()
  If not read(1,30,22) = "Work with All Printers" Then
    If not waitFor("Work with All Printers",1,30,timeout) Then
      errmsg = "expected all printers screen"
      errdata = read(1,30,22)
      Exit function
    End If
  End If
  write("[pf12]")

  wait()
  If not read(1,30,22) = "Work with Output Queue" Then
    If not waitFor("Work with Output Queue",1,30,timeout) Then
      errmsg = "expected all printers screen"
      errdata = read(1,30,22)
      Exit function
    End If
  End If
  write("[pf12]")

  If not waitFor("SIGNAGE MENU",2,34,timeout) Then
    errmsg = "expected signage menu"
    errdata = read(2,34,12)
    Exit function
  End If
  writeto "41",20,45
  write("[enter]")
end function

function wait()
  autECLSession.autECLOIA.WaitForInputReady
End function

function waitFor(text,y,x,timeout)
  waitFor = autECLSession.autECLPS.WaitForString(text,y,x,timeout)
End function

function write(text)
  autECLSession.autECLOIA.WaitForInputReady
  autECLSession.autECLPS.SendKeys text
End Function

function writeto(text,y,x)
  autECLSession.autECLOIA.WaitForInputReady
  autECLSession.autECLPS.SendKeys text,y,x
End Function

function search(text,x,y)
  search = autECLSession.autECLPS.SearchText(text,1,x,y)
End Function

function read(y,x,l)
  read = autECLSession.autECLPS.GetText(y,x,l)
End Function

function StartTimer()
  tstart = Timer()*1000
End function

function EndTimer()
  tend = Timer()*1000
  EndTimer = tend-tstart
End function

function StartPrinter()
  writeto "1",14,3
  write("[enter]")
  write("[pf12]")

  If not waitFor("Work with Output Queue",1,30,timeout) Then
    errmsg = "expected work output queue screen"
    errdata = read(1,30,22)
    Exit function
  End If
  write("[pf22]")
End function


function ConfirmMessage()
  If read(14,19,4) = "MSGW" Then
    writeto "7",14,3
    write "[enter]"

    wait()
    If read(7,22,14) = "Load form type" Then
      writeto "g",20,19
      write("[enter]")
    End If

    wait()
    If not read(20,2,23) = "Press Enter to continue" Then
      If not waitfor("Press Enter to continue",20,2,timeout) Then
        errmsg = "expected press enter to continue response"
        errdata = read(20,2,23)
        Exit function
      End If
    End If
    write("[enter]")
  End If
End function