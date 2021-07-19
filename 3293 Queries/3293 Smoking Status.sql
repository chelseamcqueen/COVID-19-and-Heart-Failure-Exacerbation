--Patel3293 Smoking Status--

SELECT  
        cpq.Company_Code
		,cpq.Coid AS HospID
       ,Substr(Cast(Cast(Trim(OTranslate(reg.Medical_Record_Num,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ,'')) AS INTEGER) + 135792468 + Cast(cpq.Coid AS INTEGER) + 1000000000000 AS CHAR(13)),2,12) AS PtID
	   ,Cast((cpq.Patient_DW_ID (Format '999999999999999999'))  + 135792468 + Cast(cpq.Coid AS INTEGER)AS DECIMAL(18,0)) AS AdmtID

        --cpq.Query_Mnemonic_CS,
        ,cq.Query_Text
        --cpq.Nurs_Intervention_Ctr,
        --cpq.Nurs_Intervention_Base_Num,
        --cpq.Nurs_Intervention_URN,
        --cpq.ED_Intervention_Assess_Ctr,
 /*       cpq.Query_Response_Text,*/
        ,cqgr.Group_Rspn_Elem_Desc
     /*   cpq.Query_Response_Activity_Date,  --this is commented out to keep the results in line with the NIH Safe Harbor Deidentification Guidelines
        cpq.Query_Response_Activity_Time,*/ --this is commented out to keep the results in line with the NIH Safe Harbor Deidentification Guidelines
        --cpq.Clinical_System_Module_Code,
  /*      cpq.Facility_Mnemonic_CS,
        cpq.Network_Mnemonic_CS*/ --these two mnemonics are commented out because no one ever uses these columns
        --cpq.DW_Last_Update_Date_Time
FROM EDWCL_VIEWS.Clinical_Patient_Query cpq

JOIN EDWCL_Views.Clinical_Query cq
ON cpq.COID = cq.COID
AND cpq.Query_Mnemonic_CS = cq.Query_Mnemonic_CS

JOIN EDWCL_Views.Clinical_Query_Group_Rspn_Elem cqgr
ON cq.COID = cqgr.COID
AND cq.Group_Rspn_Mnemonic_CS = cqgr.Group_Rspn_Mnemonic_CS
AND cpq.Group_Rspn_Elem_Mnemonic_CS = cqgr.Group_Rspn_Elem_Mnemonic

INNER JOIN qwu6617.Patel3293 pop		 --update pop
ON cpq.Patient_DW_Id = pop.Patient_DW_Id
AND cpq.Company_Code = pop.Company_Code
AND cpq.Coid = pop.Coid

INNER JOIN EDWCL_Views.Clinical_Registration reg
ON cpq.Patient_DW_Id = reg.Patient_DW_Id
AND cpq.CoID = reg.CoID
AND cpq.Company_Code = 'H'

WHERE cpq.Query_Mnemonic_CS IN (
'hcaMU08',        --see what these are about CM--
'hcaMU204',       
'HCAMU204'       
)
ORDER BY cpq.COID, cpq.Patient_DW_ID, cpq.Nurs_Intervention_Ctr DESC

--GROUP BY 1,2,3,4,5,6--,7,8,9,10,11