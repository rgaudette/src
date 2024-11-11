VERSION 4.00
Begin VB.Form Form1 
   Caption         =   "Form1"
   ClientHeight    =   8460
   ClientLeft      =   1140
   ClientTop       =   1515
   ClientWidth     =   6690
   Height          =   8865
   Left            =   1080
   LinkTopic       =   "Form1"
   ScaleHeight     =   8460
   ScaleWidth      =   6690
   Top             =   1170
   Width           =   6810
   Begin VB.TextBox Text1 
      Height          =   2895
      Left            =   360
      TabIndex        =   0
      Text            =   "Text1"
      Top             =   240
      Width           =   4335
   End
End
Attribute VB_Name = "Form1"
Attribute VB_Creatable = False
Attribute VB_Exposed = False
Option Explicit

Private Declare Function CSort Lib "e:\Src\VisCPP\Sort\Debug\sort.dll" Alias "sort" (Elem1 As Any, ByVal nElems As Short) As Short
Private Declare Function SimpleSum Lib "e:\Src\VisCPP\SimpleDLL\Release\SimpleDLL.dll" (ByVal a As Long, ByVal b As Long) As Long

Private Sub Text1_DblClick()
    ReDim Array(6) As Long
    Dim nElem As Long
    Dim RetVal As Long
    Dim a As Long
    Dim b As Long
   
    Array(0) = 10
    Array(1) = 3
    Array(2) = 7
    Array(3) = 4
    Array(4) = 9
    Array(5) = -1
    nElem = 6
    RetVal = CSort(Array(0), nElem)
    Text1.Text = Format(RetVal) + " " + Format(Array(0)) + " " + Format(Array(1)) + " " + Format(Array(2)) + " " + Format(Array(3)) + " " + Format(Array(4)) + " " + Format(Array(5))
    
    '
    '  For SimpleDLL test
    '
    'a = 2
    'b = 3
    'RetVal = SimpleSum(ByVal a, ByVal b)
    'Text1.Text = Format(RetVal)
End Sub


