/**
 * @description       : Factory class for Account object.
 * @author            : danijel.scuric@ibm.com
 * @last modified on  : 21-02-2022
 * @last modified by  : danijel.scuric@ibm.com
**/
@isTest
public class th_Account {

	public static Account create(String firstName, String lastName) {

		return create(firstName, lastName, true);
	}

	public static Account create(String firstName, String lastName, Boolean insertRecord) {

		Id recordTypeId = 
            utl_RecordType.getRecordTypesById(Account.getSobjectType()).values().get(0).getRecordTypeId();

		return create(firstName, lastName, recordTypeId, insertRecord);
	}

	public static Account create(String firstName, String lastName, Id recordTypeId, Boolean insertRecord) {

        Account testAccount = new Account();
        testAccount.FirstName = firstName;
        testAccount.LastName = lastName;
        testAccount.RecordTypeId = recordTypeId;        

        if(insertRecord) {

        	insert testAccount;
        }

        return testAccount;
	}
}