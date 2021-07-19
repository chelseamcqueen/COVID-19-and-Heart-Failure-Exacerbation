--Patel3293 Social History

SELECT	
		e.COID, 
		Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(fp.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID,
		Cast((e.Encounter_DW_ID (Format '999999999999999999')) + 135792468 + Cast(e.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID,
        sh.Encounter_dW_id,
		sh.Social_Hist_Cat_Desc,
	    sh.Social_Hist_Cond_Desc,
		sh.Social_Hist_Detail_Desc,
		sh.Social_Hist_Value_Txt,
		sh.Snomed_Code
		
FROM	EDWPS_GME_Views.Encounter e

INNER JOIN EDWCDM_Views.Fact_Patient fp
ON e.EMPI_Text = fp.Patient_EMPI_Num

INNER JOIN EDWPS_GME_Views.Encounter_Social_History sh --IDEALLY, you should be able to swap this table (and the corresponding columns in the SELECT statement) out for whichever table in the clinic data you wish to use
ON e.Encounter_DW_Id = sh.Encounter_DW_Id

INNER JOIN EDWCL_Views.Clinical_Registration reg
ON fp.Patient_DW_ID = reg.Patient_Dw_ID
AND fp.Coid = reg.Coid
AND fp.Company_Code = reg.Company_Code

INNER JOIN qwu6617.Patel3293 pop --swap this patient population out for your own!
ON fp.Patient_DW_Id = pop.Patient_DW_Id
AND fp.Coid = pop.Coid
AND fp.Company_Code = pop.Company_Code

WHERE sh.Social_Hist_Cond_Desc in('Alcohol Use', 'Tobacco Status', 'Tobacco Status (CQW)')

GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9
