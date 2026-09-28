codeunit 91303 "Payables Dictionary"
{
    var
        PayablesMgt: Codeunit "Payables Mgt";

    trigger OnRun()
    var
        PayablesCue: Record "Payables Cue";
        Input: Text;
        Inputs: Dictionary of [Text, Text];
        Results: Dictionary of [Text, Text];
    begin
        Inputs := Page.GetBackgroundParameters();

        foreach Input in Inputs.Keys() do
            case Input of
                PayablesCue.FieldName("Total Outstanding"):
                    Results.Add(
                        PayablesCue.FieldName("Total Outstanding"),
                        Format(PayablesMgt.CalcTotalOutstanding()));

                PayablesCue.FieldName("Overdue Amount"):
                    Results.Add(
                        PayablesCue.FieldName("Overdue Amount"),
                        Format(PayablesMgt.CalcOverdueAmount()));

                PayablesCue.FieldName("Not Due Amount"):
                    Results.Add(
                        PayablesCue.FieldName("Not Due Amount"),
                        Format(PayablesMgt.CalcNotDueAmount()));

                PayablesCue.FieldName("Payments Made"):
                    Message('ENTRÓ AL CASO PAYMENTS MADE');
            // Results.Add(
            //     PayablesCue.FieldName("Payments Made"),
            //     Format(PayablesMgt.CalcPaymentsMade()));
            end;

        Page.SetBackgroundTaskResult(Results);
    end;


    procedure FillPayablesCue(
        DataList: Dictionary of [Text, Text];
        var PayablesCue: Record "Payables Cue")
    begin
        if DataList.ContainsKey(
            PayablesCue.FieldName("Total Outstanding"))
        then
            Evaluate(
                PayablesCue."Total Outstanding",
                DataList.Get(
                    PayablesCue.FieldName("Total Outstanding")));

        if DataList.ContainsKey(
            PayablesCue.FieldName("Overdue Amount"))
        then
            Evaluate(
                PayablesCue."Overdue Amount",
                DataList.Get(
                    PayablesCue.FieldName("Overdue Amount")));

        if DataList.ContainsKey(
            PayablesCue.FieldName("Not Due Amount"))
        then
            Evaluate(
                PayablesCue."Not Due Amount",
                DataList.Get(
                    PayablesCue.FieldName("Not Due Amount")));

        // if DataList.ContainsKey(
        //     PayablesCue.FieldName("Payments Made"))
        // then
        //     Evaluate(
        //         PayablesCue."Payments Made",
        //         DataList.Get(
        //             PayablesCue.FieldName("Payments Made")));
    end;
}