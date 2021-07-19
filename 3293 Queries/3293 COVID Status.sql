--Patel3293 COVID Status

SELECT 
pd.Coid AS HospID
,Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(fp.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID
,Cast((reg.Patient_DW_ID (Format '999999999999999999')) + 135792468 + Cast(pd.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID
,Cast(lr.Lab_Test_Collection_Date_Time AS DATE Format 'YYYY-MM-DD')  - Cast (fp.Admission_Date AS DATE Format 'YYYY-MM-DD') AS Rel_COVIDTest_Coll_Day
,Cast(lr.Lab_Test_Collection_Date_Time AS TIME) AS COVIDTest_Collection_Time
,Cast(lr.Lab_Test_Result_Status_Date_Time AS DATE Format 'YYYY-MM-DD')  - Cast (fp.Admission_Date AS DATE Format 'YYYY-MM-DD') AS Rel_COVIDTest_Result_Day
,Cast(lr.Lab_Test_Result_Status_Date_Time AS TIME) AS COVIDTest_Result_Time
,pd.COVID19_Status_Text AS PatientDetail_Status
,ed.COVID19_Status_Text AS EncounterDetail_Status
,pd.COVID19_Positive_Flag AS PatientDetail_Pos_Flag
,ed.COVID19_Positive_Flag AS EncounterDetail_Pos_Flag
,lo.Lab_Test_Mnemonic_CS AS Lab_Mnemonic
,lo.Mic_Source_Name AS Specimen_Type
,lr.Lab_Test_Subid_Text
FROM	EDWCDM_Views.COVID19_Patient_Detail pd

INNER JOIN QWU6617.Patel3293 pop
ON pd.Patient_DW_Id = pop.Patient_DW_Id
AND pd.Company_Code = pop.Company_Code
AND pd.Coid = pop.Coid

LEFT JOIN EDWCDM_Views.COVID19_Encounter_Detail ed
ON pd.Patient_DW_Id = ed.Patient_DW_Id
AND pd.CoID = ed.CoID
AND pd.company_code = ed.company_code 
AND pd.EMPI_Text = ed.EMPI_Text

LEFT JOIN EDWCDM_Views.COVID19_Lab_Test_Result lr
ON pd.Patient_DW_Id = lr.Patient_DW_Id
AND pd.CoID = lr.CoID
AND pd.company_code = lr.company_code 
AND pd.EMPI_Text = lr.EMPI_Text

LEFT JOIN EDWCDM_Views.COVID19_Lab_Order_Detail lo
ON pd.Patient_DW_Id = lo.Patient_DW_Id
AND pd.CoID = lo.CoID
AND pd.company_code = lo.company_code 
AND pd.EMPI_Text = lo.EMPI_Text

LEFT JOIN EDWCDM_Views.Fact_Patient fp
ON pd.Patient_DW_Id = fp.Patient_DW_Id
AND pd.CoID = fp.CoID
AND pd.company_code = fp.company_code 
AND pd.EMPI_Text = fp.Patient_EMPI_Num

LEFT JOIN EDWCL_Views.Person_CL p
ON fp.Patient_Person_DW_Id = p.Person_DW_Id

INNER JOIN EDWCL_Views.Clinical_Registration reg
ON fp.Patient_DW_Id = reg.Patient_DW_Id
AND fp.CoID = reg.CoID
AND fp.company_code = reg.company_code 


GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14