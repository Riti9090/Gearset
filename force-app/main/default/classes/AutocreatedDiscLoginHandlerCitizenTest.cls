/*************************************************************************************************\
Author:         Tomas Farkasovsky
Company:        IBM
Description:    Test class for AutocreatedDiscLoginHandlerCitizen
                Test Discoverable handler login.
                Create a user with specific email identifier and invoke login.
                Expected : User should be discovered and pagereference should be returned.
History:        Tomas Farkasovsky created on 16/02/2021
*************************************************************************************************/
@isTest
public inherited sharing class AutocreatedDiscLoginHandlerCitizenTest {
    @isTest static void testLogin() {
        try {
            // Create user
            String identifierEmail = getUniqueName() + '@test.org';
            createTestUser(identifierEmail);
            Map<String, String> requestAttributes = new Map<String, String>();
            String startUrl = '';
            AutocreatedDiscLoginHandlerCitizen myLoginDefaultHandler = new AutocreatedDiscLoginHandlerCitizen();
            // Invoke login method from handler with the email of user created
            PageReference  pageReference = myLoginDefaultHandler.login(identifierEmail, startUrl, requestAttributes);
            // Assert page reference is returned
            //System.assertNotEquals(null, pageReference, 'Page reference was not returned');
        }catch (Auth.LoginDiscoveryException loginDiscoveryException) {
            // Assert exception message
            System.assert(loginDiscoveryException.getMessage().contains('No Passwordless Login redirect URL returned for verification method'), 'message=' + loginDiscoveryException.getMessage());
        }
    }
    /* Test Discoverable handler login with invalid (non-existing) user.
        Expected : Auth.LoginDiscoveryException
     */
    @isTest static void testLoginWithInvalidUser() {
        try {
            Map<String, String> requestAttributes = new Map<String, String>();
            String startUrl = '';
            String uniqueName = getUniqueName();
            String email = uniqueName + '@test.org';
            AutocreatedDiscLoginHandlerCitizen myLoginDefaultHandler = new AutocreatedDiscLoginHandlerCitizen();
            // Invoke login method from handler with non-existing user
            myLoginDefaultHandler.login(email, startUrl, requestAttributes);
        }catch (Auth.LoginDiscoveryException loginDiscoveryException) {
            // Assert exception message
            System.assert(loginDiscoveryException.getMessage().contains('No unique user found'), 'message=' + loginDiscoveryException.getMessage());
        }
    }

    @isTest static void testLoginWithMobileNegative() {
        try {
            // Create user
            String identifierEmail = getUniqueName() + '@test.org';
            String identifierMobilePhone = '+36 904936633';
            createTestUser(identifierEmail);
            Map<String, String> requestAttributes = new Map<String, String>();
            String startUrl = '';
            AutocreatedDiscLoginHandlerCitizen myLoginDefaultHandler = new AutocreatedDiscLoginHandlerCitizen();
            // Invoke login method from handler with the email of user created
            PageReference  pageReference = myLoginDefaultHandler.login(identifierMobilePhone, startUrl, requestAttributes);
            // Assert page reference is returned
            //System.assertNotEquals(null, pageReference, 'Page reference was not returned');
        }catch (Auth.LoginDiscoveryException loginDiscoveryException) {
            // Assert exception message
            System.assert(loginDiscoveryException.getMessage().contains('No unique user found'), 'message=' + loginDiscoveryException.getMessage());
        }
    }

    @isTest static void testLoginWithMobilePositive() {
        try {
            // Create user
            String identifierEmail = getUniqueName() + '@test.org';
            String identifierMobilePhone = '+420 904936633';
            createTestUser(identifierEmail);
            Map<String, String> requestAttributes = new Map<String, String>();
            String startUrl = '';
            AutocreatedDiscLoginHandlerCitizen myLoginDefaultHandler = new AutocreatedDiscLoginHandlerCitizen();
            // Invoke login method from handler with the email of user created
            PageReference  pageReference = myLoginDefaultHandler.login(identifierMobilePhone, startUrl, requestAttributes);
            // Assert page reference is returned
            //System.assertNotEquals(null, pageReference, 'Page reference was not returned');
        }catch (Auth.LoginDiscoveryException loginDiscoveryException) {
            // Assert exception message
            System.assert(loginDiscoveryException.getMessage().contains('No Passwordless Login redirect URL returned for verification method'), 'message=' + loginDiscoveryException.getMessage());
        }
    }

    @isTest static void testLoginWithWrongIdentifier() {
        try {
            // Create user
            String identifierEmail = getUniqueName() + '@test.org';
            String identifierInvalidEmail = getUniqueName();
            createTestUser(identifierEmail);
            Map<String, String> requestAttributes = new Map<String, String>();
            String startUrl = '';
            AutocreatedDiscLoginHandlerCitizen myLoginDefaultHandler = new AutocreatedDiscLoginHandlerCitizen();
            // Invoke login method from handler with the email of user created
            PageReference  pageReference = myLoginDefaultHandler.login(identifierInvalidEmail, startUrl, requestAttributes);
            // Assert page reference is returned
            //System.assertNotEquals(null, pageReference, 'Page reference was not returned');
        }catch (Auth.LoginDiscoveryException loginDiscoveryException) {
            // Assert exception message
            System.assert(loginDiscoveryException.getMessage().contains('Invalid Identifier'), 'message=' + loginDiscoveryException.getMessage());
        }
    }
    /*
       Generate a random name
     */
    private static String getUniqueName() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        return uniqueName;
    }
    /*
      Create user with given email.
     */
    private static void createTestUser(String identifierEmail)
    {
        String uniqueName = getUniqueName();
        Profile pf = [SELECT Id FROM Profile WHERE Name='Standard User'];
        String profileID = pf.Id;
        String fName = 'fname';
        String lName = uniqueName + '-lname'; 
        User tuser = new User(  firstname = fName,
                                lastName = lName,
                                email = identifierEmail,
                                Username = uniqueName + '@test.org',
                                MobilePhone = '+420 904936633',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                ProfileId = profileID);
        insert tuser;
    }
}