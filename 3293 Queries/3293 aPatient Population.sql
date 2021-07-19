--Patel3293 Patient pop

REPLACE VIEW qwu6617.Patel3293 AS
SELECT
fp.Patient_DW_Id
,fp.Company_Code
,fp.Coid
,fp.Admission_Date
,fp.discharge_date
FROM EDWCDM_Views.Fact_Patient FP

INNER JOIN EDW_Pub_Views.Fact_Facility ff
ON fp.Coid = ff.Coid

AND ff.LOB_Code = 'HOS' --Code for hospital
AND ff.COID_Status_Code = 'F' --Code for active facilities (i.e. not sold/closed)

INNER JOIN EDWCL_Views.Person_CL p
ON fp.Patient_Person_DW_Id = p.Person_DW_Id

INNER JOIN edwcdm_views.COVID19_Encounter_Detail ced
ON fp.company_code = ced.company_code
AND fp.coid = ced.coid
AND fp.Patient_DW_ID = ced.Patient_DW_ID

INNER JOIN EDWCDM_PC_Views.Patient_Diagnosis  PD
ON	PD.Patient_DW_Id = FP.Patient_DW_Id  	   
AND PD.COID = FP.COID
AND PD.Diag_Mapped_Code NOT = 'Y'
AND pd.Diag_Cycle_Code = 'F'
AND pd.Diag_Rank_Num BETWEEN '1' AND '10'
AND (
	 (PD.Diag_Type_Code='0' AND pd.diag_code IN(
		'I501'   
		,'I5020'  
		,'I5021'  
		,'I5022'  
		,'I5023'  
		,'I5040'  
		,'I5041'  
		,'I5042'  
		,'I5043'  
		,'I5082'  
)))

WHERE fp.Admission_Date BETWEEN '2020-08-01' AND '2021-04-30'		--adjust dates as needed
AND fp.Discharge_Date BETWEEN '2020-08-01' AND '2021-04-30'
AND ((Cast((Cast((fp.Admission_Date(Format'YYYY-MM')) AS CHAR(7)) || '-01') AS DATE) - Cast((Cast((p.Person_Birth_Date(Format'YYYY-MM')) AS CHAR(7)) || '-01') AS DATE))/365) BETWEEN '40' AND '75'
AND fp.Company_Code='H'
AND fp.final_bill_date <> '0001-01-01'
AND fp.final_bill_date IS NOT NULL
AND ced.COVID19_Positive_Flag ='1' 
AND fp.Patient_Type_Code_Pos1 = 'I'
GROUP BY 1,2,3,4,5