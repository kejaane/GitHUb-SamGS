/********************************************************************************
 ********************************************************************************    
 *	Class            : XmlParser
 *	Author		     : Acumen Solutions: Alejandro Olivas
 *	Version History  : 1.0
 *	Creation         : 06/17/11
 *	Description      : This class contains generic XML Document parsing and
 *					   handling functions
 ********************************************************************************
 ********************************************************************************/
public with sharing class XmlParser {

	/**
	 * Given an XML node returns a direct child XML node within a specified tag, if
	 * a child node is not found a null value is returned.
	 */
    public static dom.XmlNode getElementsByTagName(dom.XmlNode parentNode, String tag) {
        dom.XmlNode desiredNode = null;
        try {
            List<dom.XmlNode> children = parentNode.getChildElements();
            for ( Integer i = 0; i < children.size(); i++ ) {
                dom.XmlNode child = children.get(i);
                // If node is found, exit the loop
                if ( child.getName().equalsIgnoreCase(tag) ) {
                    desiredNode = child;
                    i = children.size();
                }
            }
        } catch (Exception e) {
        	String errorMessage = 'Exception trying to parse the following tag [ ' +
        		tag + ' ] coming from the node [ ' + parentNode + ' ]</br>' +
        		'Error Message = ' + e.getMessage();
        	ApexPages.Message msg = 
        		new ApexPages.Message(ApexPages.Severity.ERROR, errorMessage);
			ApexPages.addMessage(msg); 
        }
        return desiredNode;
    }

}