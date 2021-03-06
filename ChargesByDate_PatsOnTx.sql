/** Charges by Date, restricted to 
   specific RO CPTs 77290+, 77285+, 77280+, 77372-73, 77385-86, 77402, 77407 and 77412
   4 rad-onc docs.
   Date parametrized to last 3 months
**/
SET NOCOUNT ON;
Use Mosaiq;
DECLARE @TwoYearsAgo VARCHAR(8);
SET @TwoYearsAgo = CONVERT(varchar(8),dateadd(year,-2,GetDate()),112)
SELECT 
    convert(varchar(10),[Proc_DtTm],101) as Proc_date
    ,Quotename(dbo.fn_GetPatientName(Pat_ID1,'NAMELFM'),'"') as Pat_Name 
    ,charge.Hsp_Code as CPT
    ,Quotename(CPT.DESCRIPTION,'"') as CPT_Description
    ,Days_Units
    ,IsInPatient
    ,Topog.Diag_Code as ICD_DX_Code
    ,Quotename(Topog.Description,'"') as ICD_DX_Desc
    ,Quotename(dbo.fn_GetStaffName(staff_id,'NAMELFM'),'"') as Provider
    ,Quotename(dbo.fn_GetStaffName(Location_ID,'NAMELFM'),'"') as Machine
    ,SCH_ID
  FROM [MOSAIQ].[dbo].[Charge] 
  join CPT on CPT.PRS_ID=Charge.PRS_ID
  join Topog on Topog.TPG_ID=Charge.TPG_ID1
  WHERE 
    staff_id in (70,170,1676,42)
	AND CONVERT(CHAR(8),Proc_DtTm,112) >= @TwoYearsAgo 
	AND Charge.Hsp_Code in( '77290 TC', '77290 26', '77285','77285 26', '77285 TC', '77280', '77280 26', '77280 TC', '77372', '77373', '77385', '77386', '77402', '77407', '77412')
 