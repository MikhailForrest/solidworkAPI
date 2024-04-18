import win32com.client
import pySldWrap.sw_tools as sw_tools
import swconst

# Connect to SolidWorks
swApp = win32com.client.Dispatch("SldWorks.Application")
swModel = swApp.ActiveDoc

print(swModel.GetTitle)
print(swModel.GetPathName)
ftManager = swModel.FeatureManager
rootNode = ftManager.GetFeatureTreeRootItem #https://help.solidworks.com/2023/english/api/swconst/SOLIDWORKS.Interop.swconst~SOLIDWORKS.Interop.swconst.swTreeControlItemType_e.html
rootNodeObjecttType = rootNode.ObjectType
rootNodeObject = rootNode.Object
if rootNodeObjecttType == swconst.constants.swFeatureManagerItem_Feature:
    print (1)
if rootNodeObjecttType == swconst.constants.swFeatureManagerItem_Component:
    print (2)
if rootNodeObjecttType == swconst.constants.swFeatureManagerItem_Unsupported:
    print (0)
print(rootNode.Text) #https://help.solidworks.com/2023/english/api/sldworksapi/SolidWorks.Interop.sldworks~SolidWorks.Interop.sldworks.ITreeControlItem_members.html
#print(rootNode.GetFirstChild.Text)
chld = rootNode.GetFirstChild
while chld:
    print(chld.Text)
    chld_chld = chld.GetFirstChild
    while chld_chld:
        print(' '+chld_chld.Text)
        print(' '+str(chld_chld.ObjectType))
        ch_ch_object = chld_chld.Object
        #print("[FEATURE: " + ch_ch_object.Name2 +"]")
        chld_chld = chld_chld.GetNext
    #chld=chld.GetNext



