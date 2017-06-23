/**
 * Created by new on 20.06.2017.
 */

global class LeadsPageController {
    public Set<Lead> leadsToConvert {get;set;}
    public String inputedCompanyName {get; set;}
    public String compareField {get; set;}
    public List<LeadWrapper> leadWrappers {get;set;}
    public List<LeadWrapper> leadWrappersToShow {get; set;}
    public List<FieldSetMember> fields {get; set;}
    public List<SelectOption> rowsPerPage {get; set;}
    private Boolean globalChecbox = false;
    public Integer rowsAmount {get; set;}
    public Integer pageCount {get; set;}
    public Id leadID {get; set;}

    public LeadsPageController() {
        init();
    }

    public PageReference changeRowsAmount() {
        pageCount = 0;
        next();
        return null;
    }

    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Lead.fieldSets.LeadFieldSet.getFields();
    }

    public PageReference changeAllCheckBoxes() {
        globalChecbox = !globalChecbox;
        for (LeadWrapper leadWrapper : leadWrappers) {
            leadWrapper.setIsChecked(globalChecbox);
        }
        return null;
    }

    public PageReference moveToLead() {
        system.debug(leadID);
        PageReference pageReference = new PageReference('/' + leadID);
        return pageReference;
    }

    public PageReference next() {
        Integer endPoint = 0;
        if (pageCount * rowsAmount > leadWrappers.size()) {
            return null;
        }
        leadWrappersToShow =  new List<LeadWrapper>();
        if (leadWrappers.size() >= (pageCount + 1) * rowsAmount) {
            endPoint = ( pageCount + 1) * rowsAmount;
        } else {
            endPoint = leadWrappers.size();
        }
        for (Integer i = pageCount * rowsAmount; i < endPoint; i ++ ) {
            leadWrappersToShow.add(leadWrappers.get(i));
            system.debug(leadWrappers.get(i));
        }
        pageCount ++;
        return null;

    }
    public PageReference previous() {
        if (pageCount <= 1) {
            return null;
        }
        leadWrappersToShow =  new List<LeadWrapper>();
        Integer startPoint = 0;
        if (pageCount != 1) {
            startPoint = (pageCount - 2) * rowsAmount;
        }
        for (Integer i = startPoint; i < (pageCount - 1) * rowsAmount; i++ ) {
            leadWrappersToShow.add(leadWrappers.get(i));
        }
        pageCount--;
        return null;

    }

    public PageReference sort() {
        for (LeadWrapper lw : leadWrappers) {
            lw.compareField = compareField;
        }
        leadWrappers.sort();
        recalculateVisibleLeadWrapers();
        return null;
    }

    public PageReference convertLeads() {
        try{
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            List<Database.LeadConvert> leadConverts = new List<Database.LeadConvert>();
            for(Lead lead : leadsToConvert) {
                Database.LeadConvert tempLc = new Database.LeadConvert();
                tempLc.setLeadId(lead.Id);
                tempLc.setConvertedStatus(convertStatus.MasterLabel);
                leadConverts.add(tempLc);
            }
            List<Database.LeadConvertResult> results = Database.convertLead(leadConverts);
            for (Database.LeadConvertResult res : results) {
                System.assert(res.isSuccess());
            }
        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Some of leads, u r trying to convert have been already converted!'));

        }
        fillLeadWrappers();
        recalculateVisibleLeadWrapers();
        return null;
    }

    private void recalculateVisibleLeadWrapers() {
        pageCount--;
        next();
    }

    private void init() {
        leadsToConvert = new Set<Lead>();
        compareField = '';
        rowsAmount = 10;
        fillRowsPerPageList();
        pageCount = 0;
        fillLeadWrappers();
        next();
    }

    private void fillRowsPerPageList() {
        rowsPerPage = new List<SelectOption>();
        rowsPerPage.add(new SelectOption('5','5'));
        rowsPerPage.add(new SelectOption('10','10'));
        rowsPerPage.add(new SelectOption('25','25'));
        rowsPerPage.add(new SelectOption('50','50'));
        rowsPerPage.add(new SelectOption('100','100'));
    }

    private void fillLeadWrappers() {
        leadWrappers = new List<LeadWrapper>();
        List<Lead> leads = getLeads();
        fields = getFields();
        for (Lead lead : leads) {
            leadWrappers.add(new LeadWrapper(false,lead,this));
        }
    }

    private List<Lead> getLeads() {
        String query = 'SELECT ';
        for (Schema.FieldSetMember f : this.getFields()) {
            query += f.getFieldPath() +  ', ';

        }
        query += 'Id FROM Lead WHERE Status != \'Closed - Converted\'';
        return Database.query(query);

    }

    public void addToList(Lead newLead, Boolean isChecked) {

        if (leadsToConvert!=null) {
            if (isChecked) {
                leadsToConvert.add(newLead);
            } else {
                leadsToConvert.remove(newLead);
            }
        }
    }




}