codeunit 91301 "Receivables Dictionary"
{
    var
        ReceivablesMgt: Codeunit "Receivables Mgt";

    trigger OnRun()
    var
        ReceivablesCue: Record "Receivables Cue";
        Input: Text;
        Inputs: Dictionary of [Text, Text];
        Results: Dictionary of [Text, Text];
    begin
        Inputs := Page.GetBackgroundParameters();

        foreach Input in Inputs.Keys() do
            case Input of
                ReceivablesCue.FieldName("Total Outstanding"):
                    Results.Add(ReceivablesCue.FieldName("Total Outstanding"), Format(ReceivablesMgt.CalcTotalOutstanding()));
                ReceivablesCue.FieldName("Overdue Amount"):
                    Results.Add(ReceivablesCue.FieldName("Overdue Amount"), Format(ReceivablesMgt.CalcOverdueAmount()));
                ReceivablesCue.FieldName("Not Due Amount"):
                    Results.Add(ReceivablesCue.FieldName("Not Due Amount"), Format(ReceivablesMgt.CalcNotDueAmount()));
                ReceivablesCue.FieldName("Payments Received"):
                    Results.Add(ReceivablesCue.FieldName("Payments Received"), Format(ReceivablesMgt.CalcPaymentsReceived()));
            end;

        Page.SetBackgroundTaskResult(Results);
    end;

    procedure FillReceivablesCue(DataList: Dictionary of [Text, Text]; var ReceivablesCue: record "Receivables Cue")
    begin
        if DataList.ContainsKey(ReceivablesCue.FieldName("Total Outstanding")) then
            Evaluate(ReceivablesCue."Total Outstanding", DataList.Get(ReceivablesCue.FieldName("Total Outstanding")));

        if DataList.ContainsKey(ReceivablesCue.FieldName("Overdue Amount")) then
            Evaluate(ReceivablesCue."Overdue Amount", DataList.Get(ReceivablesCue.FieldName("Overdue Amount")));

        if DataList.ContainsKey(ReceivablesCue.FieldName("Not Due Amount")) then
            Evaluate(ReceivablesCue."Not Due Amount", DataList.Get(ReceivablesCue.FieldName("Not Due Amount")));

        if DataList.ContainsKey(ReceivablesCue.FieldName("Payments Received")) then
            Evaluate(ReceivablesCue."Payments Received", DataList.Get(ReceivablesCue.FieldName("Payments Received")));
    end;
}
