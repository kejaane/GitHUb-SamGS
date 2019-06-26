<!--
*=================================================================================================================
* Date         : 01/26/2018
* Developer    : Goutham Rapolu
* Purpose      : AIA_Create_New_BRF app is rendered inside AIA_BRF_RecordTypeRedirect page to create BRF.
*=================================================================================================================
*                                 Update History
*                                 ++++++++++++++
*   Date        Developer       Tag   Description
*============+================+=====+=============================================================================
* 01/26/2018 | Goutham Rapolu |     | Initial Version                                         
* 03/21/2018 | Gayathri 	  | T01 | Added dependency for all the components  
*===========+=================+=====+=============================================================================
*
-->

<aura:application access="GLOBAL" extends="ltng:outApp">
   
    <aura:dependency resource="c:AIA_BRF_ASO_Layout"  />
    <aura:dependency resource="markup://force:navigateToSObject" type="EVENT"/>
    <!--T01 Start-->
    <aura:dependency resource="c:AIA_BRF_Other_Layout"  />
    <aura:dependency resource="c:AIA_BRF_Risk_Layout"  />
    <aura:dependency resource="c:AIA_BRF_Both_Layout"  />
    <aura:dependency resource="c:Lookup"/>
    <aura:dependency resource="c:DEPENDENT_PICKLIST"/>
    <!--T01 End --> 
</aura:application>