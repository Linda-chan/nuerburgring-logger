Option Explicit

Const AppTitle = "AJPapps - Nuerburgring logger WHT ver."
Const AppCopyright = "Линда Кайе 2009-2018. Посвящается Ариэль"

Const HTTPREQUEST_PROXYSETTING_DEFAULT = 0
Const HTTPREQUEST_PROXYSETTING_PRECONFIG = 0
Const HTTPREQUEST_PROXYSETTING_DIRECT = 1
Const HTTPREQUEST_PROXYSETTING_PROXY = 2

Dim UserAgent

'====================================================================
Public Sub Main()
  Dim Path
  Dim PictureData
  
  ' Заранее получаем юзерагент, чтобы он не менялся при запросах...
  UserAgent = GetUserAgent()
  
  Path = GetPathFromArgs()
  PictureData = GetJPGFile()
  If VarType(PictureData) <> vbByte + vbArray And _
     VarType(PictureData) <> vbString Then WScript.Quit
  
  SaveJPGFile Path, PictureData
End Sub

'====================================================================
Private Function GetJPGFile()
  Dim WHT
  
  On Error Resume Next
  
  Set WHT = CreateObject("WinHttp.WinHttpRequest.5.1")
  
  If Err.Number <> 0 Then
    MsgBox "Не удалось получить картинку с Нюрбургринга." & _
           vbCrLf & vbCrLf & _
           "Не удаётся создать объект Microsoft WinHTTP Services.", _
           vbCritical, AppTitle
    Exit Function
  End If
  
  ' ResolveTimeout As Long, ConnectTimeout As Long, 
  ' SendTimeout As Long, ReceiveTimeout As Long
  WHT.SetTimeouts 300 * 1000, 300 * 1000, 300 * 1000, 300 * 1000
  
  ' Устанавливаем прямое соединение...
  WHT.SetProxy HTTPREQUEST_PROXYSETTING_DIRECT, "", ""
  
  WHT.Open "GET", "http://www.nuerburgring.de/fileadmin/webcam/webcam.jpg"
  WHT.SetRequestHeader "User-Agent", UserAgent
  WHT.Send
  
  If Err Then
    MsgBox "Не удалось получить картинку с Нюрбургринга." & _
           vbCrLf & vbCrLf & _
           "Ошибка отправки HTTP запроса.", _
           vbCritical, AppTitle
    Exit Function
  End If
  
  If WHT.Status <> 200 Then
    MsgBox "Не удалось получить картинку с Нюрбургринга." & _
           vbCrLf & vbCrLf & _
           "Сервер вернул: " & WHT.Status & " " & _
           WHT.StatusText & ".", vbCritical, AppTitle
    Exit Function
  End If
  
  GetJPGFile = WHT.ResponseBody  ' Byte array
  'GetJPGFile = WHT.ResponseText  ' String
End Function
