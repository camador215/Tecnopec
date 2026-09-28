pageextension 91300 "Business Manager RC Ext" extends "Business Manager Role Center"
{
    layout
    {
        addafter(Control139)
        {
            part(ReceivablesCue; "Receivables Cue")
            {
                ApplicationArea = All;
            }
            part(PayablesCue; "Payables Cue")
            {
                ApplicationArea = All;
            }
        }
        modify(Control139)
        {
            Visible = true;
        }

        // modify(Control16)
        // {
        //     Visible = false;
        // }

        // modify("User Tasks Activities")
        // {
        //     Visible = false;
        // }

        // modify("Job Queue Tasks Activities")
        // {
        //     Visible = false;
        // }

        // modify(Emails)
        // {
        //     Visible = false;
        // }

        // modify(ApprovalsActivities)
        // {
        //     Visible = false;
        // }

        // modify("Intercompany Activities")
        // {
        //     Visible = false;
        // }

        // modify(Control46)
        // {
        //     Visible = false;
        // }

        // modify(Control55)
        // {
        //     Visible = false;
        // }

        // modify("Favorite Accounts")
        // {
        //     Visible = false;
        // }

        // modify(Control9)
        // {
        //     Visible = false;
        // }

        // modify(PowerBIEmbeddedReportPart)
        // {
        //     Visible = false;
        // }

        // modify(Control96)
        // {
        //     Visible = false;
        // }

        // modify(MyNotes)
        // {
        //     Visible = false;
        // }
    }
}
