tableextension 91300 "Finance Cue Ext" extends "Finance Cue"
{
    fields
    {
        field(91300; "Saldo Total Pendiente"; Decimal)
        {
            AutoFormatExpression = '';
            AutoFormatType = 1;
            Caption = 'Total Overdue (LCY)';
            FieldClass = FlowField;
            CalcFormula = sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" where(
                "Initial Entry Due Date" = field(upperlimit("Overdue Date Filter"))
            ));
        }
    }
}