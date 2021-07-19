--Nursing Notes--Patel3293 

SELECT
    nr.Coid AS HospId
	,Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(nr.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID
	,Cast((reg.Patient_DW_ID (Format '999999999999999999')) + 135792468 + Cast(nr.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID
    ,Cast (nr.Nursing_Query_Occr_Date_Time AS DATE Format 'YYYY-MM-DD') - Cast (pop.Admission_Date AS DATE Format 'YYYY-MM-DD') AS Rel_Occur_Day
    ,nr.Nursing_Query_Occr_Date_Time(TIME) AS Occur_Time
	,nr.Nursing_Query_Id_Txt AS EMR_Q
    ,nr.Nursing_Result_Val_Txt AS EMR_A
	,nr.Source_System_Original_Code AS EMR_Source_Code
FROM EDWCDM_PC_Views.Fact_Nursing_Result nr

INNER JOIN qwu6617.Patel3293 pop
ON nr.Patient_DW_Id = pop.Patient_DW_Id
AND nr.Company_Code = pop.Company_Code
AND nr.Coid = pop.Coid

INNER JOIN EDWCL_Views.Clinical_Registration reg
  ON nr.Patient_DW_Id = reg.Patient_DW_Id
AND nr.CoID = reg.CoID
AND nr.company_code = reg.company_code


WHERE nr.Nursing_Query_Id_Txt  IN(
'Ventilator mode:'
,'Oxygen delivery devices:'
,'Oxygen delivery device:'
,'Initial or Subsequent BIPAP Treatment:'
,'Daily O2 Device:'
,'BiPAP/CPAP treatment:'
,'BIPAP/CPAP - Subesequent Day:'
,'BIPAP/CPAP - Initial Day:'
,'BIPAP Subsequent'
,'BIPAP Initial'
)
AND (EMR_Q like '%BiPAP%' or EMR_A like '%BiPAP%')

GROUP BY 1,2,3,4,5,6,7,8
