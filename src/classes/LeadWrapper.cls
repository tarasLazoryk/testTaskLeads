/**
 * Created by new on 20.06.2017.
 */

public with sharing class LeadWrapper {
    public Lead lead {get; set;}
    public Boolean isChecked{get;set;}

    public LeadWrapper(Boolean isChecked, Lead lead) {
        this.isChecked = isChecked;
        this.lead = lead;
    }



}