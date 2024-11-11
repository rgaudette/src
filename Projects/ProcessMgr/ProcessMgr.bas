Attribute VB_Name = "Module1"
Option Explicit
Declare Function ProcessSnapShot Lib "e:\Src\Projects\ProcessMgr\Debug\ProcessMgr.dll" () As Long
Declare Function GetNProc Lib "e:\Src\Projects\ProcessMgr\Debug\ProcessMgr.dll" () As Long
Declare Sub FreeHandle Lib "e:\Src\Projects\ProcessMgr\Debug\ProcessMgr.dll" ()
Declare Function GetFirstProcess Lib "e:\Src\Projects\ProcessMgr\Debug\ProcessMgr.dll" (ProcID As Long, ParentID As Long, nThreads As Long, Priority As Long, ByVal ExeFile As String) As Long
Declare Function GetNextProcess Lib "e:\Src\Projects\ProcessMgr\Debug\ProcessMgr.dll" (ProcID As Long, ParentID As Long, nThreads As Long, Priority As Long, ByVal ExeFile As String) As Long
Declare Function ModuleSnapShot Lib "e:\Src\Projects\ProcessMgr\Debug\ProcessMgr.dll" (ByVal ProcID As Long) As Long
Declare Function GetFirstModule Lib "e:\Src\Projects\ProcessMgr\Debug\ProcessMgr.dll" (ProcID As Long, count As Long, nSize As Long, ByVal ModuleName As String, ByVal ExePath As String) As Long
Declare Function GetNextModule Lib "e:\Src\Projects\ProcessMgr\Debug\ProcessMgr.dll" (ProcID As Long, count As Long, nSize As Long, ByVal ModuleName As String, ByVal ExePath As String) As Long

