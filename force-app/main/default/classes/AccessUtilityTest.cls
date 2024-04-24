/**-----------------------------------------------------------------------------------------------------------//
* Class Name AccessUtilityTest
* Project Health Service Executive (HSE)
* @author Liran Shriki
* @date 24/01/2022
* @description Test class for AccessUtility
* ----------------------------------------------------------------------------------------------------------
*           No.     Date            Author                  Description
*           -----   ----------      --------------------    ---------------
* @version  1.0                     Liran Shriki
*-----------------------------------------------------------------------------------------------------------*/
@IsTest
private class AccessUtilityTest {

    @testSetup
    private static void setupData() {
        Id adminProfileId = HSE_GlobalUtils.getProfileIdByName(HSE_Constants.HSE_PROFILE_NAMES.get('SysAdmin'));
        Id citizenProfileId = HSE_GlobalUtils.getProfileIdByName(HSE_Constants.HSE_PROFILE_NAMES.get('CitizenCommunityUser'));
        Id ceoRoleId = HSE_GlobalUtils.getRoleIdByName('CEO');
        User sysAdmin = (User) TestDataFactory.createSObject(
                'User',
                new Map<String, Object>{
                        'Email' => 'hseAdminUser1@hse.com',
                        'ProfileId' => adminProfileId,
                        'CommunityNickname' => 'nickname',
                        'UserName' => 'AccessUtilityTest@hse.com',
                        'UserRoleId' => ceoRoleId,
                        'firstname' => 'aaa',
                        'lastName' => 'bb',
                        'EmailEncodingKey' => 'ISO-8859-1',
                        'Alias' => 'alias',
                        'TimeZoneSidKey' => 'America/Los_Angeles',
                        'LocaleSidKey' => 'en_US',
                        'LanguageLocaleKey' => 'en_US'
                },
                true
        );

        System.runAs(sysAdmin) {
            Account account = (Account) TestDataFactory.createSObject(
                    'Account',
                    new Map<String, Object>{
                            'Salutation' => 'Mr',
                            'FirstName' => 'account 1',
                            'LastName' => 'abc',
                            'RecordTypeId' => HSE_GlobalUtils.getRecordTypeId(
                                    HSE_Constants.SO_ACCOUNT,
                                    HSE_Constants.SO_RT_ACCOUNT_PERSONACCOUNT
                            )
                    },
                    true
            );

            Contact contact = [SELECT Id FROM Contact Where AccountId = :account.Id];
            User citizenCommunityUser = (User) TestDataFactory.createSObject('User', new Map<String, Object>{
                    'firstname' => 'aa',
                    'lastName' => 'bb',
                    'Email' => 'citizenUser1@community.com',
                    'CommunityNickname' => 'nick',
                    'ProfileId' => citizenProfileId,
                    'UserName' => 'AccessUtilityTestCommunity@hse.com',
                    'EmailEncodingKey' => 'ISO-8859-1',
                    'Alias' => 'alias',
                    'TimeZoneSidKey' => 'America/Los_Angeles',
                    'LocaleSidKey' => 'en_US',
                    'LanguageLocaleKey' => 'en_US',
                    'ContactId' => contact.id
            }, true) ;

            Site.createExternalUser(citizenCommunityUser, account.Id, 'Test12345@');
        }
    }

    @IsTest
    static void testCreateRecord() {
        Account account = getAccount('account created',false);

        Test.startTest();
        AccessUtility.createRecord(account);
        Test.stopTest();
        System.assert([SELECT Name FROM Account WHERE Name = 'account created'].size() == 1, 'Account not created' );
    }

    @IsTest
    static void testUpdateRecord() {
        Account account = getAccount('account created',true);

        Test.startTest();
        account = [SELECT Name FROM Account WHERE Name = 'account created'][0];
        account.Name = 'account updated';
        AccessUtility.updateRecord(account);
        Test.stopTest();
        System.assert([SELECT Name FROM Account WHERE Name = 'account updated'].Name == 'account updated', 'Account not updated' );
    }

    @IsTest
    static void testThrowExceptionOnUpdate() {
        Account account = getAccount('account created',true);
        User communityUser = [SELECT Id FROM User WHERE UserName = 'AccessUtilityTestCommunity@hse.com'];
        System.runAs(communityUser) {
            Test.startTest();
            try {
                //Assumption: citizen community user does not have access to AccountSource (for now)
                account.AccountSource = 'Web';
                AccessUtility.updateRecord(account);
            }
            catch (DmlException e) {
                System.assert(e.getMessage() == 'Not have access to AccountSource on Account', 'Something wrong here');
            }
            Test.stopTest();
        }
    }

    private static Account getAccount(String accountName,Boolean doInsert) {
        Account account = (Account) TestDataFactory.createSObject(
                'Account',
                new Map<String, Object>{
                        'Name' => accountName
                },
                doInsert
        );
        return account;
    }

}