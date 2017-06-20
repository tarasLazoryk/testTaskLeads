/**
 * Created by new on 20.06.2017.
 */

public with sharing class LeadsPageController {
    public List<LeadWrapper> leadWrappers {get;set;}

    private void fillLeadWrappers() {
        leadWrappers = new List<LeadWrapper>();
        List<Lead> leads = [SELECT Id, LastName, CompanyName__c FROM Lead];
        for (Lead lead : leads) {
            leadWrappers.add(new LeadWrapper(false,lead));
        }
    }

    public LeadsPageController() {
        fillLeadWrappers();
    }
    public PageReference changeAll() {
        for (LeadWrapper leadWrapper : leadWrappers) {
            leadWrapper.isChecked = !leadWrapper.isChecked;
        }
        return null;
    }

}