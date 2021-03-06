Option Explicit

Const AppTitle = "AJPapps - Nuerburgring logger HTR ver."
Const AppCopyright = "Линда Кайе 2009-2018. Посвящается Ариэль"

Dim UserAgent

'====================================================================
Public Sub Main()
  Dim Path
  Dim PictureData
  
  ' Заранее получаем юзерагент, чтобы он не менялся при запросах...
  UserAgent = GetUserAgent()
  
  Path = GetPathFromArgs()
  PictureData = GetJPGFile()
  If PictureData = "" Then WScript.Quit
  SaveJPGFile Path, PictureData
End Sub

'====================================================================
Private Function GetJPGFile()
  Dim HTR 'As ajpHTTPRequest
  Dim Proxy 'As ProxySettings
  
  On Error Resume Next
  
  Set HTR = CreateObject("CmnFuncs0301.ajpHTTPRequest")
  Set Proxy = CreateObject("CmnFuncs0301.ProxySettings")
  
  If Err.Number <> 0 Then
    MsgBox "Не удалось получить картинку с Нюрбургринга." & _
           vbCrLf & vbCrLf & _
           "Не удаётся создать объект ajpHTTPRequest.", _
           vbCritical, AppTitle
    Exit Function
  End If
  
  On Error Goto 0
  
  Proxy.HTTP_AccessType = 1 ' psatDirect 
  Set HTR.ProxySettings = Proxy
  
  HTR.Execute "www.nuerburgring.de", , , _
              "/fileadmin/webcam/webcam.jpg", , , , , , _
              UserAgent, , , True, True, True
  
  If HTR.ErrorCode <> 0 Then
    MsgBox "Не удалось получить картинку с Нюрбургринга." & _
           vbCrLf & vbCrLf & _
           "Ошибка отправки HTTP запроса.", _
           vbCritical, AppTitle
    Exit Function
  End If
  
  If HTR.ResponseCode <> 200 Then
    MsgBox "Не удалось получить картинку с Нюрбургринга." & _
           vbCrLf & vbCrLf & _
           "Сервер вернул: " & HTR.ResponseCode & " " & _
           HTR.ResponseText & ".", vbCritical, AppTitle
    Exit Function
  End If
  
  GetJPGFile = HTR.ReceivedData
End Function
