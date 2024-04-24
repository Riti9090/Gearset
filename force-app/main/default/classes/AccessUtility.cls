/**-----------------------------------------------------------------------------------------------------------//
* Class Name    : AccessUtility
* Project       : Health Service Executive (HSE)
* Author        : Liran Shriki
* Date          :
* @description   : Enforcing object and fields permissions on apex code
* ----------------------------------------------------------------------------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0                     Liran Shriki
*-----------------------------------------------------------------------------------------------------------*/
public without sharing class AccessUtility {


    /******************************************************************************************************
     * @Method createRecord
     * @Author Liran Shriki (lshriki@salesforce.com)
     * @description create record with object and fields permissions enforced
     * @param record
    ******************************************************************************************************/
    public static void createRecord(SObject record) {
        createRecords(new List<SObject>{ record });
    }

    /******************************************************************************************************
     * @Method updateRecord
     * @Author Liran Shriki (lshriki@salesforce.com)
     * @description updateRecord record with object and fields permissions enforced
     * @param record
    ******************************************************************************************************/
    public static void updateRecord(SObject record) {
        updateRecords(new List<SObject>{ record });
    }

    /******************************************************************************************************
     * @Method updateRecords
     * @Author Liran Shriki (lshriki@salesforce.com)
     * @description update records with object and fields permissions enforced
     * @param records
    ******************************************************************************************************/
    public static void updateRecords(List<SObject> records) {
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.UPDATABLE, records,true);
        Map<String,Set<String>> removedFields = securityDecision.getRemovedFields();
        if (removedFields.Size() > 0) {
            throwException(removedFields);
        }
        update securityDecision.getRecords();
    }

    /******************************************************************************************************
     * @Method createRecords
     * @Author Liran Shriki (lshriki@salesforce.com)
     * @description create records with object and fields permissions enforced
     * @param records
    ******************************************************************************************************/
    public static void createRecords(List<SObject> records) {
        SObjectAccessDecision securityDecision = Security.stripInaccessible(AccessType.CREATABLE, records,true);
        Map<String,Set<String>> removedFields = securityDecision.getRemovedFields();
        if (removedFields.Size() > 0) {
            throwException(removedFields);
        }
        insert securityDecision.getRecords();
    }

    /******************************************************************************************************
     * @Method throwException
     * @Author Liran Shriki (lshriki@salesforce.com)
     * @description Throw DML exception if no access to object or fields
     * @param removedFields
    ******************************************************************************************************/
    private static void throwException(Map<String, Set<String>> removedFields) {
        String objectName = new List<String>(removedFields.keySet())[0];
        String fieldName = new List<String>(removedFields.get(objectName))[0];
        throw new DmlException('Not have access to ' + fieldName + ' on ' + objectName);
    }

}