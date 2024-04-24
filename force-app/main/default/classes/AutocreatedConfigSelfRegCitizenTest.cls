/*************************************************************************************************\
Author:         Tomas Farkasovsky
Company:        IBM
Description:    Test class for AutocreatedConfigSelfRegCitizen
History:        Tomas Farkasovsky created on 12/02/2021
*************************************************************************************************/
@isTest
public without sharing class AutocreatedConfigSelfRegCitizenTest {
    
    @TestSetup
    private static void makeData(){
        Profile sysadminProfile = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
        User usr = new User(LastName = 'Edison',
                           FirstName='Thomas',
                           Alias = 'tedison',
                           Email = 'thomas.edison@test123.com',
                           Username = 'thomas.edison@test123.com',
                           ProfileId = sysadminProfile.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US',
                           MobilePhone = '05555555555'
                           );
        String RecTypeId= [select Id from RecordType where Name='Person Account' AND SobjectType='Account'].Id;
        Account a = new Account(FirstName='TestAccount123456',LastName = 'Edison',RecordTypeID=RecTypeId);

        try{
            insert usr;
            insert a;
        }
        catch(Exception e){
            System.debug(e);
        }
    }

    @isTest
    static void testCreateUser() {
        User uRunning = [SELECT Id, Name FROM User WHERE FirstName = 'Thomas' AND Email = 'thomas.edison@test123.com' LIMIT 1];
        Id profileId = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1].Id;
        Id accountId = [SELECT Id FROM Account LIMIT 1].Id;

        AutocreatedConfigSelfRegCitizen handler = new AutocreatedConfigSelfRegCitizen();

        Map<SObjectField, String> registrationAttributes = new Map<SObjectField, String>();
        Schema.DescribeFieldResult fn = user.firstname.getDescribe();
        Schema.sObjectField fname = fn.getSObjectField();

        Schema.sObjectField MobilePhone = user.MobilePhone.getDescribe().getSobjectField();

        Schema.DescribeFieldResult em = user.email.getDescribe();
        Schema.sObjectField uemail = em.getSObjectField();

        registrationAttributes.put(fname,'ThomasX124');
        registrationAttributes.put(MobilePhone,'5555555555');
        //registrationAttributes.put(uemail,'thomas.edison@first.com');

        String password = '';
        System.runAs(uRunning) { 
            Id uid = handler.createUser(null, profileId, registrationAttributes, password);
            System.assertEquals(null, uid);    
    
        }
    }    
}