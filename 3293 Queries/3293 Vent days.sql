--Patel3293 COVID Vent Days 11-30

SELECT	
	fp.Coid AS HospID
	,Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(fp.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID
	,Cast((reg.Patient_DW_ID (Format '999999999999999999')) + 135792468 + Cast(fp.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID
	,cve.Episode_Seq_Num
	,Cast(cve.Vent_Start_Date_Time AS DATE) - fp.Admission_Date AS Vent_Start_Day
	,Cast(cve.Vent_Start_Date_Time AS TIME) AS Vent_Start_Time
	,cve.Episode_Duration_Amt
	,cvpd.Trach_Date - fp.Admission_Date AS Trach_Proc_Day
FROM	EDWCDM_Views.Fact_Patient fp

INNER JOIN qwu6617.Patel3293 pop
	ON fp.Patient_DW_Id = pop.Patient_DW_Id
	AND fp.Company_Code = pop.Company_Code
	AND fp.Coid = pop.Coid
	
INNER JOIN EDWCL_Views.Clinical_Registration reg
	ON fp.Patient_DW_Id = reg.Patient_DW_Id
	AND fp.CoID = reg.CoID
	AND fp.company_code = reg.company_code 
	
INNER JOIN EDWCDM_Views.COVID19_Vent_Episode cve
	ON fp.Patient_DW_Id = cve.Patient_DW_Id
	AND fp.CoID = cve.CoID
	AND fp.company_code = cve.company_code
	
LEFT JOIN EDWCDM_Views.COVID19_Vent_Patient_Day cvpd
	ON cvpd.Patient_DW_Id = cve.Patient_DW_Id
	AND cvpd.CoID = cve.CoID
	AND cvpd.company_code = cve.company_code
	
GROUP BY 1,2,3,4,5,6,7,8