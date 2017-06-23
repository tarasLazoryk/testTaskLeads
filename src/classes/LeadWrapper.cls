/**
 * Created by new on 20.06.2017.
 */
global class LeadWrapper implements Comparable{

    public String compareField {get; set;}
    public Lead lead {get; set;}
    private Boolean isChecked;
    private LeadsPageController leadPageController;

    public LeadWrapper(Boolean isChecked, Lead lead, LeadsPageController leadPageController) {
        this.leadPageController = leadPageController;
        this.isChecked = isChecked;
        this.lead = lead;
    }

    public Boolean getIsChecked() {
        return isChecked;
    }

    public void setIsChecked(Boolean isChecked) {
        this.isChecked = isChecked;
        leadPageController.addToList(lead,isChecked);
    }
    global Integer compareTo(Object o) {
        LeadWrapper lw = (LeadWrapper)o;
        if (lead.get(compareField) != null && lw.lead.get(compareField) != null) {
            return (compare(lead.get(compareField), lw.lead.get(compareField)));
        } else if (lead.get(compareField) == null) {
            return  1;
        } else if (lw.lead.get(compareField) == null) {
            return -1;
        }
        else return 0;

    }

    private Integer compareStrings(String thisValue, String objValue) {
        return thisValue.compareTo(objValue);
    }

    private Integer compareNumbers(Double thisValue, Double objValue) {
        return thisValue > objValue ? -1 : thisValue == objValue ? 0 : 1;
    }

    private Integer compareBooleans(Boolean thisValue, Boolean objValue) {
        if (thisValue == objValue) {
            return 0;
        } else if (thisValue == true){
            return -1;
        }
        return 1;

    }

    private Integer compare(Object thisObject, Object otherObject) {
        if (thisObject instanceof  String) {
            return compareStrings((String)thisObject,(String)otherObject);
        } else if (thisObject instanceof Id) {
            return compareStrings((String)thisObject, (String)otherObject);
        } else if (thisObject instanceof Double) {
            return compareNumbers((Double)thisObject,(Double)otherObject);
        } else if (thisObject instanceof Boolean) {
            return (compareBooleans((Boolean)thisObject,(Boolean)otherObject));
        } else return 0;

    }







}