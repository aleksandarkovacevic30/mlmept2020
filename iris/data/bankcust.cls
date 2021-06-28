/// 
Class User.BANKCUST Extends %Persistent [ ClassType = persistent, DdlAllowed, Final, Owner = {SuperUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BANKCUST ]
{

Property CLIENTNUM As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 2 ];

Property AttritionFlag As %Library.String(MAXLEN = 30) [ Required, SqlColumnNumber = 3, SqlFieldName = Attrition_Flag ];

Property CustomerAge As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4, SqlFieldName = Customer_Age ];

Property Gender As %Library.String(MAXLEN = 1) [ SqlColumnNumber = 5 ];

Property Dependentcount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6, SqlFieldName = Dependent_count ];

Property EducationLevel As %Library.String(MAXLEN = 50) [ SqlColumnNumber = 7, SqlFieldName = Education_Level ];

Property MaritalStatus As %Library.String(MAXLEN = 30) [ SqlColumnNumber = 8, SqlFieldName = Marital_Status ];

Property IncomeCategory As %Library.String(MAXLEN = 40) [ SqlColumnNumber = 9, SqlFieldName = Income_Category ];

Property CardCategory As %Library.String(MAXLEN = 20) [ SqlColumnNumber = 10, SqlFieldName = Card_Category ];

Property Monthsonbook As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11, SqlFieldName = Months_on_book ];

Property TotalRelationshipCount As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 12, SqlFieldName = Total_Relationship_Count ];

Property MonthsInactive12mon As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13, SqlFieldName = Months_Inactive_12_mon ];

Property ContactsCount12mon As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14, SqlFieldName = Contacts_Count_12_mon ];

Property CreditLimit As %Library.Double [ SqlColumnNumber = 15, SqlFieldName = Credit_Limit ];

Property TotalRevolvingBal As %Library.Double [ SqlColumnNumber = 16, SqlFieldName = Total_Revolving_Bal ];

Property AvgOpenToBuy As %Library.Double [ SqlColumnNumber = 17, SqlFieldName = Avg_Open_To_Buy ];

Property TotalAmtChngQ4Q1 As %Library.Double [ SqlColumnNumber = 18, SqlFieldName = Total_Amt_Chng_Q4_Q1 ];

Property TotalTransAmt As %Library.Double [ SqlColumnNumber = 19, SqlFieldName = Total_Trans_Amt ];

Property TotalTransCt As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 20, SqlFieldName = Total_Trans_Ct ];

Property TotalCtChngQ4Q1 As %Library.Double [ SqlColumnNumber = 21, SqlFieldName = Total_Ct_Chng_Q4_Q1 ];

Property AvgUtilizationRatio As %Library.Double [ SqlColumnNumber = 22, SqlFieldName = Avg_Utilization_Ratio ];

Parameter USEEXTENTSET = 1;

/// DDL Primary Key Specification
Index CLINTNUMK On CLIENTNUM [ PrimaryKey, Type = index, Unique ];

/// Bitmap Extent Index auto-generated by DDL CREATE TABLE statement.  Do not edit the SqlName of this index.
Index DDLBEIndex [ Extent, SqlName = "%%DDLBEIndex", Type = bitmap ];

Storage Default
{
<Data name="BANKCUSTDefaultData">
<Value name="1">
<Value>CLIENTNUM</Value>
</Value>
<Value name="2">
<Value>AttritionFlag</Value>
</Value>
<Value name="3">
<Value>CustomerAge</Value>
</Value>
<Value name="4">
<Value>Gender</Value>
</Value>
<Value name="5">
<Value>Dependentcount</Value>
</Value>
<Value name="6">
<Value>EducationLevel</Value>
</Value>
<Value name="7">
<Value>MaritalStatus</Value>
</Value>
<Value name="8">
<Value>IncomeCategory</Value>
</Value>
<Value name="9">
<Value>CardCategory</Value>
</Value>
<Value name="10">
<Value>Monthsonbook</Value>
</Value>
<Value name="11">
<Value>TotalRelationshipCount</Value>
</Value>
<Value name="12">
<Value>MonthsInactive12mon</Value>
</Value>
<Value name="13">
<Value>ContactsCount12mon</Value>
</Value>
<Value name="14">
<Value>CreditLimit</Value>
</Value>
<Value name="15">
<Value>TotalRevolvingBal</Value>
</Value>
<Value name="16">
<Value>AvgOpenToBuy</Value>
</Value>
<Value name="17">
<Value>TotalAmtChngQ4Q1</Value>
</Value>
<Value name="18">
<Value>TotalTransAmt</Value>
</Value>
<Value name="19">
<Value>TotalTransCt</Value>
</Value>
<Value name="20">
<Value>TotalCtChngQ4Q1</Value>
</Value>
<Value name="21">
<Value>AvgUtilizationRatio</Value>
</Value>
<Value name="22"/>
<Value name="23"/>
</Data>
<DataLocation>^poCN.EGLT.1</DataLocation>
<DefaultData>BANKCUSTDefaultData</DefaultData>
<ExtentLocation>^poCN.EGLT</ExtentLocation>
<IdFunction>sequence</IdFunction>
<IdLocation>^poCN.EGLT.1</IdLocation>
<Index name="CLINTNUMK">
<Location>^poCN.EGLT.2</Location>
</Index>
<Index name="DDLBEIndex">
<Location>^poCN.EGLT.3</Location>
</Index>
<Index name="IDKEY">
<Location>^poCN.EGLT.1</Location>
</Index>
<IndexLocation>^poCN.EGLT.I</IndexLocation>
<StreamLocation>^poCN.EGLT.S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}