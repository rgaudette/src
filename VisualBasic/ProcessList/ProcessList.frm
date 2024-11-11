VERSION 4.00
Begin VB.Form MainWindow 
   Caption         =   "Process List"
   ClientHeight    =   3480
   ClientLeft      =   1035
   ClientTop       =   1455
   ClientWidth     =   11370
   Height          =   3885
   Left            =   975
   LinkTopic       =   "Form1"
   ScaleHeight     =   3480
   ScaleWidth      =   11370
   Top             =   1110
   Width           =   11490
   Begin VB.ListBox ProcessList 
      Height          =   2400
      Left            =   120
      TabIndex        =   5
      Top             =   840
      Width           =   11055
   End
   Begin VB.CommandButton btnPriority 
      Caption         =   "Adjust Priority"
      Height          =   375
      Left            =   1200
      TabIndex        =   4
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton btnKill 
      Caption         =   "Kill"
      Height          =   375
      Left            =   10440
      TabIndex        =   3
      Top             =   120
      Width           =   855
   End
   Begin VB.CommandButton btnRefresh 
      Caption         =   "Refresh"
      Height          =   375
      Left            =   120
      TabIndex        =   2
      Top             =   120
      Width           =   855
   End
   Begin VB.Label lblThreadId 
      Caption         =   "Thread ID"
      Height          =   255
      Left            =   1200
      TabIndex        =   6
      Top             =   600
      Width           =   975
   End
   Begin VB.Label lblPriority 
      Caption         =   "Priority"
      Height          =   255
      Left            =   2280
      TabIndex        =   1
      Top             =   600
      Width           =   615
   End
   Begin VB.Label lblProcID 
      Caption         =   "Process ID"
      Height          =   255
      Left            =   120
      TabIndex        =   0
      Top             =   600
      Width           =   975
   End
End
Attribute VB_Name = "MainWindow"
Attribute VB_Creatable = False
Attribute VB_Exposed = False








Public Sub GetTaskList()
    Dim nChars As Long
    Dim WinText As String
    Dim idx As Integer
    Dim idxOut As Integer
    Dim idxIn As Integer
    Dim nWindows As Integer
    Dim MinRss As Long
    Dim MaxRss As Long
    
    Dim hWindow(1024) As Long
    Dim idThread(1024) As Long
    Dim idProcess(1024) As Long
   
    
    '
    '  Get all of the window, process & thread IDs
    '
    hWindow(0) = GetTopWindow(0)
    idThread(0) = GetWindowThreadProcessId(hWindow(0), idProcess(0))
    idx = 0
    While hWindow(idx) <> 0
        idx = idx + 1
        hWindow(idx) = GetWindow(hWindow(idx - 1), GW_HWNDNEXT)
        idThread(idx) = GetWindowThreadProcessId(hWindow(idx), idProcess(idx))
    Wend
    nWindows = idx
    
    '
    '  Sort the process table by process Id
    '
    For idxOut = 0 To nWindows - 1
        For idxIn = 0 To nWindows - 1
            If idProcess(idxOut) > idProcess(idxIn) Then
                temp = idProcess(idxIn)
                idProcess(idxIn) = idProcess(idxOut)
                idProcess(idxOut) = temp
                
                temp = idThread(idxIn)
                idThread(idxIn) = idThread(idxOut)
                idThread(idxOut) = temp
                
        
                temp = hWindow(idxIn)
                hWindow(idxIn) = hWindow(idxOut)
                hWindow(idxOut) = temp
            End If
        Next idxIn
    Next idxOut
    
    '
    '   Put process table in the list box
    '
    ProcessList.Clear
    nChars = GetWindowTextLength(hWindow(0))
    WinText = Space(nChars + 1)
    If nChars > 0 Then
        nChars = GetWindowText(hWindow(0), WinText, nChars + 1)
    Else
        WinText = "<No Title>"
    End If
'    ReturnValue = GetProcessWorkingSetSize(idThread(0), MinRss, MaxRss)
    ProcessList.AddItem Format(idProcess(0), "00000000    ") + Format(idThread(0), "00000000    ") + Format(hWindow(0), "00000000    ") + WinText
    
    For idx = 1 To nWindows - 1
        If idProcess(idx) <> idProcess(idx - 1) Then
            nChars = GetWindowTextLength(hWindow(idx))
            WinText = Space(nChars + 1)
            If nChars > 0 Then
                nChars = GetWindowText(hWindow(idx), WinText, nChars + 1)
            Else
                WinText = "<No Title>"
            End If
 '           ReturnValue = GetProcessWorkingSetSize(idThread(idx), MinRss, MaxRss)
            ProcessList.AddItem Format(idProcess(idx), "00000000    ") + Format(idThread(idx), "00000000    ") + Format(hWindow(idx), "00000000    ") + WinText
        End If
    Next idx
    
End Sub

Private Sub btnRefresh_Click()
    GetTaskList
End Sub




Private Sub Label1_Click()

End Sub


