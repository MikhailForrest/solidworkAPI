Option Explicit
Dim traverseLevel As Long
Sub main()
    Dim swApp As SldWorks.SldWorks
    Dim myModel As SldWorks.ModelDoc2
    Dim featureMgr As SldWorks.FeatureManager
    Dim rootNode As SldWorks.TreeControlItem    
    Set swApp = Application.SldWorks
    Set myModel = swApp.ActiveDoc
    Set featureMgr = myModel.FeatureManager
    Set rootNode = featureMgr.GetFeatureTreeRootItem()
    If Not rootNode Is Nothing Then
        Debug.Print
        traverseLevel = 0
        traverse_node rootNode
    End If
    
End Sub
Private Sub traverse_node(node As SldWorks.TreeControlItem)
    Dim childNode As SldWorks.TreeControlItem
    Dim featureNode As SldWorks.Feature
    Dim componentNode As SldWorks.Component2
    Dim nodeObjectType As Long
    Dim nodeObject As Object
    Dim restOfString As String
    Dim indent As String
    Dim i As Long
    Dim displayNodeInfo As Boolean
    Dim compName As String
    Dim suppr As Long, supprString As String
    Dim vis As Long, visString As String
    Dim fixed As Boolean, fixedString As String
    Dim componentDoc As Object, docString As String
    Dim refConfigName As String    
    displayNodeInfo = False
    nodeObjectType = node.ObjectType
    Set nodeObject = node.Object
    Select Case nodeObjectType
    Case SwConst.swTreeControlItemType_e.swFeatureManagerItem_Feature:
        displayNodeInfo = True
        If Not nodeObject Is Nothing Then
            Set featureNode = nodeObject
            restOfString = "[FEATURE: " & featureNode.Name & "]"
        Else
            restOfString = "[FEATURE: object null?]"
        End If
    Case SwConst.swTreeControlItemType_e.swFeatureManagerItem_Component:
        displayNodeInfo = True
        If Not nodeObject Is Nothing Then
            Set componentNode = nodeObject
            compName = componentNode.Name2
            If (compName = "") Then
                compName = "?"
            End If
            suppr = componentNode.GetSuppression()
            Select Case (suppr)
            Case SwConst.swComponentSuppressionState_e.swComponentFullyResolved
                supprString = "Resolved"
            Case SwConst.swComponentSuppressionState_e.swComponentLightweight
                supprString = "Lightweight"
            Case SwConst.swComponentSuppressionState_e.swComponentSuppressed
                supprString = "Suppressed"
            End Select
            vis = componentNode.Visible            
            Select Case (vis)
            Case SwConst.swComponentVisibilityState_e.swComponentHidden
                visString = "Hidden"
            Case SwConst.swComponentVisibilityState_e.swComponentVisible
                visString = "Visible"
            End Select
            fixed = componentNode.IsFixed            
            If fixed = 0 Then
                fixedString = "Floating"
            Else
                fixedString = "Fixed"
            End If            
            Set componentDoc = componentNode.GetModelDoc
            If componentDoc Is Nothing Then
                docString = "Not loaded"
            Else
                docString = "Loaded"
            End If
            refConfigName = componentNode.ReferencedConfiguration
            If (refConfigName = "") Then
                refConfigName = "?"
            End If
            restOfString = "[COMPONENT: " & compName & " " & docString & " " & supprString & " " & visString & " " & refConfigName & "]"
        Else
            restOfString = "[COMPONENT: object null?]"
        End If
    Case Else:
        displayNodeInfo = True
        If Not nodeObject Is Nothing Then
            restOfString = "[object type not handled]"
        Else
            restOfString = "[object null?]"
        End If
    End Select
    For i = 1 To traverseLevel
        indent = indent & "  "
    Next i
    If (displayNodeInfo) Then
        Debug.Print indent & node.Text & " : " & restOfString
    End If
    traverseLevel = traverseLevel + 1
    Set childNode = node.GetFirstChild()
    While Not childNode Is Nothing
        traverse_node childNode
        Set childNode = childNode.GetNext
    Wend
    traverseLevel = traverseLevel - 1
End Sub
