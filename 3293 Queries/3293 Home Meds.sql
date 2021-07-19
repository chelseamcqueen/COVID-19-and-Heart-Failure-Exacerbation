--Patel3293 Home Meds

SELECT
fp.Coid  AS HospID
,Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(fp.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID
,Cast((fp.Patient_DW_ID (Format '999999999999999999'))  + 135792468 + Cast(fp.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID
,Med.Clinical_Phrm_Mnem_CS AS HM_PhrmMnem
,Med.Clinical_Phrm_Trade_Name AS HM_PhrmTradeName
,Med.RX_Dose_Text AS Dose_Text									-- this field shows actual dose taken/prescribed and may differ from medication name/mnem
,Med.RX_Unit_Text AS Unit_Text										--this field shows unit of measurement corresponding to previous dose field
,Med. RX_Route_Mnem_CS AS Route_Mnem					--this field shows route of medication (oral, topical, injection, etc)
,Med.RX_Frequency_Text AS Freq_Text							--this field shows frequency of medication taken and/or if prn (as needed)
,rcp.Therapeutic_Cls_Group_Mnem_CS AS TherClsGrp
,HMRef.Clinical_Phrm_RXM_NDC_Code AS HM_NDC
,Med.RX_Type AS HM_Type
,Cast(Med.Update_Date_Time AS DATE) - fp.Admission_Date AS Rel_UpdateDay
,Med.RX_Action_Text AS ActionText
,Med.Med_Status_Code AS HM_Status
FROM EDWCDM_Views.Fact_Patient fp

INNER JOIN EDWCL_Views.Clinical_Registration reg
ON fp.Patient_DW_Id = reg.Patient_DW_Id
AND fp.CoID = reg.CoID
AND reg.Company_Code = 'H'

INNER JOIN qwu6617.Patel3293 pop								--update pop
ON fp.Patient_DW_Id = pop.Patient_DW_Id
AND fp.Company_Code = pop.Company_Code
AND fp.Coid = pop.Coid

INNER JOIN  EDWCL_VIEWS.Clinical_Patient_Med_List Med
ON fp.Patient_dw_id=Med.Patient_dw_id
AND fp.Coid=Med.Coid
AND Med.Clinical_Systems_Module_Code NOT IN ('TEV','IAT')
--Below two filters added to limit to discharge prescription actions
--AND Med.RX_Type = 'R'
--AND Med.RX_Action_Text LIKE 'DIS.%'

LEFT JOIN EDWCL_VIEWS.Ref_Clinical_Phrm_RXM HMRef
ON HMRef.Coid = Med.Coid
AND HMRef.Clinical_Phrm_RXM_Mnemonic_CS = Med.Clinical_Phrm_Mnem_CS

LEFT JOIN EDWCL_Views.Ref_Clinical_Pharmaceutical rcp
ON HMRef.COID = rcp.COID
AND HMRef.Clinical_Phrm_RXM_NDC_Code = rcp.NDC

GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
