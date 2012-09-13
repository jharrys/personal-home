Attribute VB_Name = "Reports"
Option Explicit

Public Sub TaskStatusReport()
    On Error GoTo On_Error
    
    Dim Session As Outlook.NameSpace
    Dim Report As String
    Dim TaskFolder As Outlook.Folder
    Dim currentItem As Object
    Dim currentTask As TaskItem
    Set Session = Application.Session
    
    Set TaskFolder = Session.GetDefaultFolder(olFolderTasks)
    
    Dim Completed(0 To 2) As String
    Dim Finished(0 To 2) As String
    Dim Working(0 To 2) As String
    Dim About(0 To 2) As String
    
    Completed(0) = "I'm done with the "
    Completed(1) = "I completed the "
    Completed(2) = "Finished with "
    
    Finished(0) = "Got it finished on "
    Finished(1) = "Completed it on "
    Finished(2) = "Had it done on "
    
    Working(0) = "Working on "
    Working(1) = "This week I worked on "
    Working(2) = "I'm taking care of "
    
    About(0) = "It's about "
    About(1) = "I'm about "
    About(2) = "Almost "
    
    For Each currentItem In TaskFolder.Items
        If (currentItem.Class = olTask) Then
            Set currentTask = currentItem
            
            If ((currentTask.Sensitivity <> olPrivate) And currentTask.Subject <> "") Then
            
                'Report = Report & AddToReportIfNotBlank("LastModificationTime: ", currentTask.LastModificationTime)
                'Report = Report & AddToReportIfNotBlank("ResponseState: ", currentTask.ResponseState)
                'Report = Report & AddToReportIfNotBlank("Role: ", currentTask.Role)
                'Report = Report & AddToReportIfNotBlank("StartDate: ", currentTask.StartDate)
                
                If (currentTask.Complete = True) Then
                    ' Completed tasks
                    Report = Report & AddToReportIfNotBlank(Completed(MeRnd(0, 2)), currentTask.Subject & ". ")
                    Report = Report & AddToReportIfNotBlank(Finished(MeRnd(0, 2)), currentTask.DateCompleted & ".", True)
                Else
                    ' Pending tasks
                    Report = Report & AddToReportIfNotBlank(Working(MeRnd(0, 2)), currentTask.Subject & ". ")
                    Report = Report & AddToReportIfNotBlank(About(MeRnd(0, 2)), currentTask.PercentComplete & "% complete.", True)
                End If
                
                ' Common
                If (currentTask.Body <> "") Then
                    Report = Report & AddToReportIfNotBlank("Here are some notes from my task.", vbCrLf & currentTask.Body)
                End If
                
                Report = Report & vbCrLf & vbCrLf
            End If
        End If
        
    Next
    
    
    Call CreateReportAsEmail("List of Tasks", Report)
    
Exiting:
        Exit Sub
On_Error:
    MsgBox "error=" & Err.Number & " " & Err.Description
    Resume Exiting
    
End Sub

Private Function AddToReportIfNotBlank(FieldName As String, FieldValue As String, Optional EOL As Boolean)
    AddToReportIfNotBlank = ""
    If (FieldValue <> "") Then
        If (EOL = True) Then
            AddToReportIfNotBlank = FieldName & FieldValue & vbCrLf
        Else
            AddToReportIfNotBlank = FieldName & FieldValue
        End If
    End If
    
End Function
Private Function MeRnd(lower As Integer, upper As Integer)
    Dim result As Integer
    
    Randomize
    result = CInt((Int(upper - lower + 1) * Rnd) + lower)

End Function


' VBA SubRoutine which displays a report inside an email
' Programming by Greg Thatcher, http://www.GregThatcher.com
Public Sub CreateReportAsEmail(Title As String, Report As String)
    On Error GoTo On_Error
    
    Dim Session As Outlook.NameSpace
    Dim mail As MailItem
    Dim MyAddress As AddressEntry
    Dim Inbox As Outlook.Folder
    
    Set Session = Application.Session
    Set Inbox = Session.GetDefaultFolder(olFolderInbox)
    Set mail = Inbox.Items.Add("IPM.Mail")
    
    Set MyAddress = Session.CurrentUser.AddressEntry
    mail.Recipients.Add (MyAddress.Address)
    mail.Recipients.ResolveAll
    
    mail.Subject = Title
    mail.Body = Report
    
    mail.Save
    mail.Display
    
    
Exiting:
        Set Session = Nothing
        Exit Sub
On_Error:
    MsgBox "error=" & Err.Number & " " & Err.Description
    Resume Exiting

End Sub
