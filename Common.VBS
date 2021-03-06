Option Explicit

'====================================================================
Public Function GetPathFromArgs()
  If WScript.Arguments.Count = 0 Then 
    GetPathFromArgs = ""
    Exit Function
  End If
  
  If WScript.Arguments.Count = 1 Then
    Select Case UCase(WScript.Arguments(0))
      Case "/?" 
        ShowUsage
      Case Else
        GetPathFromArgs = WScript.Arguments(0)
    End Select
    Exit Function
  End If
  
  ShowUsage
End Function

'====================================================================
Public Sub ShowUsage()
  MsgBox AppTitle & vbCrLf & _
         AppCopyright & vbCrLf & _
         vbCrLf & _
         "Использование:" & vbCrLf & _
         vbCrLf & _
         WScript.ScriptName & " [Path]" & vbCrLf & _
         vbCrLf & _
         "Path - путь к каталогу, куда скрипт будет сохранять " & _
         "картинки. Если не указан, программа будет сохранять " & _
         "в текущий каталог.", vbInformation, AppTitle
  
  ' Здесь всё закончится.
  WScript.Quit
End Sub

'====================================================================
Public Function PadWithZero(ByVal Number, ByVal nZero)
  Dim TMP
  
  PadWithZero = CStr(Number)
  TMP = nZero - Len(PadWithZero)
  If TMP > 0 Then PadWithZero = String(TMP, "0") & PadWithZero
End Function

'====================================================================
Public Function GetUserAgent()
  GetUserAgent = "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:63.0) Gecko/20100101 Firefox/63.0"
End Function

'====================================================================
Private Sub SaveJPGFile(ByVal Path, ByVal PictureData)
  Dim FileName
  
  On Error Resume Next
  
  FileName = "Nuerburgring Log " & _
             PadWithZero(Year(Now), 4) & "-" & _
             PadWithZero(Month(Now), 2) & "-" & _
             PadWithZero(Day(Now), 2) & " " & _
             PadWithZero(Hour(Now), 2) & "-" & _
             PadWithZero(Minute(Now), 2) & "-" & _
             PadWithZero(Second(Now), 2) & ".JPG"
  If Path <> "" Then
    If Right(Path, 1) = "\" Then 
      FileName = Path & FileName
    Else
      FileName = Path & "\" & FileName
    End If
  End If
  
  PutFile FileName, PictureData
  If Err.Number <> 0 Then
    MsgBox FileName & vbCrLf & vbCrLf & _
           "Не удалось сохранить файл.", _
           vbCritical, AppTitle
  End If
End Sub

'====================================================================
Private Sub PutFile(ByVal FileName, ByVal Text)
  Select Case VarType(Text)
    Case vbString
      PutFileA FileName, Text
    Case vbByte + vbArray
      PutFileB FileName, Text
  End Select
End Sub

'====================================================================
Private Sub PutFileA(ByVal FileName, ByVal Text)
  Dim FSO
  Dim File
  
  Set FSO = CreateObject("Scripting.FileSystemObject")
  Set File = FSO.CreateTextFile(FileName, True, False)
  
  File.Write Text
  File.Close
End Sub

'====================================================================
Private Sub PutFileB(ByVal FileName, ByVal Text)
  Dim oStream
  
  Const adTypeBinary = 1
  Const adSaveCreateOverWrite = 2
  
  Set oStream = CreateObject("ADODB.Stream")
  
  oStream.Open
  oStream.Type = adTypeBinary
  oStream.Write Text
  oStream.SaveToFile FileName, adSaveCreateOverWrite
  oStream.Close
End Sub
