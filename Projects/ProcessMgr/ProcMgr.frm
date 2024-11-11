VERSION 4.00
Begin VB.Form ProcMgr 
   BackColor       =   &H00C0C0C0&
   Caption         =   "Process List"
   ClientHeight    =   6855
   ClientLeft      =   1095
   ClientTop       =   1290
   ClientWidth     =   11070
   FillStyle       =   0  'Solid
   Height          =   7260
   Left            =   1035
   LinkTopic       =   "Form1"
   ScaleHeight     =   6855
   ScaleWidth      =   11070
   Top             =   945
   Width           =   11190
   Begin VB.Timer timerRefresh 
      Interval        =   1000
      Left            =   10680
      Top             =   0
   End
   Begin VB.CommandButton cmdModule 
      Caption         =   "Module"
      Height          =   255
      Left            =   3600
      TabIndex        =   13
      Top             =   3240
      Width           =   7455
   End
   Begin VB.CommandButton cmdNBytes 
      Caption         =   "Bytes"
      Height          =   255
      Left            =   2400
      TabIndex        =   12
      Top             =   3240
      Width           =   1215
   End
   Begin VB.CommandButton cmdGlobalCnt 
      Caption         =   "Global Count"
      Height          =   255
      Left            =   1200
      TabIndex        =   11
      Top             =   3240
      Width           =   1215
   End
   Begin VB.CommandButton cmdModProcID 
      Caption         =   "Command1"
      Height          =   255
      Left            =   0
      TabIndex        =   10
      Top             =   3240
      Width           =   1215
   End
   Begin VB.CommandButton cmdExec 
      Caption         =   "Executable"
      Height          =   195
      Left            =   4800
      TabIndex        =   9
      Top             =   480
      Width           =   6255
   End
   Begin VB.CommandButton cmdPriority 
      Caption         =   "Priority"
      Height          =   195
      Left            =   3600
      TabIndex        =   8
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton cmdThreads 
      Caption         =   "Threads"
      Height          =   195
      Left            =   2400
      TabIndex        =   7
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton cmdParent 
      Caption         =   "Parent ID"
      Height          =   195
      Left            =   1200
      TabIndex        =   6
      Top             =   480
      Width           =   1215
   End
   Begin VB.CommandButton cmdProcID 
      Caption         =   "Process ID"
      Height          =   195
      Left            =   0
      TabIndex        =   5
      Top             =   480
      Width           =   1215
   End
   Begin VB.ListBox lstModule 
      BackColor       =   &H00808080&
      Height          =   2985
      Left            =   0
      TabIndex        =   4
      Top             =   3480
      Width           =   11055
   End
   Begin VB.CommandButton btnModules 
      Caption         =   "Modules"
      Height          =   375
      Left            =   960
      TabIndex        =   2
      Top             =   0
      Width           =   975
   End
   Begin VB.CommandButton btnProcesses 
      Caption         =   "Processes"
      Height          =   375
      Left            =   0
      TabIndex        =   0
      Top             =   0
      Width           =   975
   End
   Begin MSGrid.Grid treeProcess 
      Height          =   2415
      Left            =   0
      TabIndex        =   3
      Top             =   720
      Width           =   11055
      _Version        =   65536
      _ExtentX        =   19500
      _ExtentY        =   4260
      _StockProps     =   77
      BackColor       =   16777215
      Cols            =   1
      FixedRows       =   0
      FixedCols       =   0
      ScrollBars      =   2
      GridLines       =   0   'False
      HighLight       =   0   'False
   End
   Begin ComctlLib.StatusBar StatusBar 
      Align           =   2  'Align Bottom
      Height          =   375
      Left            =   0
      TabIndex        =   1
      Top             =   6480
      Width           =   11070
      _Version        =   65536
      _ExtentX        =   19526
      _ExtentY        =   661
      _StockProps     =   68
      AlignSet        =   -1  'True
      SimpleText      =   ""
      NumPanels       =   2
      i1              =   "ProcMgr.frx":0000
      i2              =   "ProcMgr.frx":00CD
   End
End
Attribute VB_Name = "ProcMgr"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Option Explicit
Dim arrProcID()

Public Sub GetProcTable()
    Dim RetVal As Long
    Dim idxProc As Integer
    Dim nProc As Long, nBytes As Long, count As Long
    Dim ProcID As Long, ParentID As Long, nThreads As Long, Priority As Long
    Dim ExeFile As String, ProcLine As String
    Dim Junk As Integer
  
    
    '
    '   Get a toolhelp snapshot of the system state
    '
    RetVal = ProcessSnapShot()
    If RetVal <> 0 Then
        Junk = MsgBox("Unable to get system snapshot  Return value:" & Str(RetVal), vbOKOnly, "Process Manager")
        Exit Sub
    End If
    
    '
    '   Display the number of processes
    '
    nProc = GetNProc()
    ReDim arrProcID(nProc)
    
    '
    '  Update status bar process count
    '
    StatusBar.Panels(1).Text = "Processes: " & Str(nProc)
    
    '
    '   Setup the process grid
    '
    treeProcess.Rows = nProc
    treeProcess.Cols = 5
    treeProcess.ColWidth(0) = cmdProcID.Width
    treeProcess.ColWidth(1) = cmdParent.Width
    treeProcess.ColWidth(2) = cmdThreads.Width
    treeProcess.ColWidth(3) = cmdPriority.Width
    treeProcess.ColWidth(4) = cmdExec.Width
    treeProcess.ColAlignment(0) = 1
    treeProcess.ColAlignment(1) = 1
    treeProcess.ColAlignment(2) = 2
    treeProcess.ColAlignment(3) = 2
    treeProcess.ColAlignment(4) = 0
    
    '
    '   Get the first process
    '
    ExeFile = String(255, 0)
    ProcLine = String(255, 0)
    idxProc = 0
    RetVal = GetFirstProcess(ProcID, ParentID, nThreads, Priority, ExeFile)
    arrProcID(idxProc) = ProcID
    
    '
    '  Enter first process row
    '
    treeProcess.Row = 0
    treeProcess.Col = 0
    treeProcess.Text = Str(ProcID)
    treeProcess.Col = 1
    treeProcess.Text = Str(ParentID)
    treeProcess.Col = 2
    treeProcess.Text = Str(nThreads)
    treeProcess.Col = 3
    treeProcess.Text = Str(Priority)
    treeProcess.Col = 4
    treeProcess.Text = ExeFile
    
    '
    '   Get the rest of the processes
    '
    For idxProc = 1 To (nProc - 1)
        RetVal = GetNextProcess(ProcID, ParentID, nThreads, Priority, ExeFile)
        arrProcID(idxProc) = ProcID
        treeProcess.Row = idxProc
        treeProcess.Col = 0
        treeProcess.Text = Str(ProcID)
        treeProcess.Col = 1
        treeProcess.Text = Str(ParentID)
        treeProcess.Col = 2
        treeProcess.Text = Str(nThreads)
        treeProcess.Col = 3
        treeProcess.Text = Str(Priority)
        treeProcess.Col = 4
        treeProcess.Text = ExeFile
    Next

    '
    '  Free the snapshot handle
    '
    FreeHandle
End Sub

Private Sub btnModules_Click()
    GetModuleTable (arrProcID(treeProcess.Row))
End Sub

Private Sub btnProcesses_Click()
     GetProcTable
End Sub

Private Sub Form_Load()
    GetProcTable
End Sub


Private Sub timerRefresh_Timer()
    GetProcTable
End Sub


Private Sub treeProcess_DblClick()
    Dim Ret As Integer
    GetModuleTable (arrProcID(treeProcess.Row))
End Sub


Public Sub GetModuleTable(ProcID As Long)
    Dim RetVal As Long
    Dim nModules As Long
    Dim Junk As Integer
    'Dim ProcID As Long
    Dim count As Long, nBytes As Long
    Dim ModuleName As String, ModulePath As String
    
    '
    '  Snapshot the requested module
    '
    nModules = ModuleSnapShot(ProcID)
    If RetVal < 0 Then
        Junk = MsgBox("Unable to get module snapshot  Return value:" & Str(RetVal), vbOKOnly, "Process Manager")
        Exit Sub
    End If
    '
    '  Update status bar module count
    '
    StatusBar.Panels(2).Text = "Modules: " & Str(nModules)
    ModuleName = String(255, 0)
    ModulePath = String(255, 0)
    
    '
    '   Get the first module
    '
    RetVal = GetFirstModule(ProcID, count, nBytes, ModuleName, ModulePath)
    If RetVal <> 1 Then
        Junk = MsgBox("Unable to get first module")
        Exit Sub
    Else
        lstModule.Clear
    End If
    lstModule.AddItem Format(ProcID, "#############") + "    " + Format(count, "#############") + "    " + Format(nBytes, "#############") + "    " + ModulePath + ModuleName
        
    
    RetVal = GetNextModule(ProcID, count, nBytes, ModuleName, ModulePath)
    While RetVal <> 0
        lstModule.AddItem Format(ProcID, "#############") + "    " + Format(count, "#############") + "    " + Format(nBytes, "#############") + "    " + ModulePath + ModuleName
        RetVal = GetNextModule(ProcID, count, nBytes, ModuleName, ModulePath)
    Wend

    '
    '  Free the snapshot handle
    '
    FreeHandle
    
End Sub
