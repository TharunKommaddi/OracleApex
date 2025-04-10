

# GETEX Package Refactoring - Function Mapping Table

## 1. PCK_RI_GETEX_COMPARE Functions

| Old Function (PCK_RI_GETEX) | New Function (PCK_RI_GETEX_COMPARE) |
|----------------------------|-----------------------------------|
| fCompareEinsatzdaten | fCompareEinsatzdaten &#x2611;|
| pCompareVorschrift | pCompareVorschrift &#x2611;|
| fCheckdiff_in_Kraft_datum | fCheckDiffInKraftDatum &#x2611;|
| fCheckDiffGetexVorschriftEinsatzDaten | fCheckEinsatzDatenDiff &#x2611;|
| pVergleichAttributevonGetex | pCompareGetexAttrs *Deleted (Obsolete)* &#x2611;|
| fCheckDifference_to_Getex_relations | fCheckRelationDiff &#x2611;|
| fIsDiff_to_Getex_EquivalentOrDemand | fCheckEquivDemandDiff &#x2611;|
| fIsLandListChanging | fIsLandListChanged &#x2611;|
| fIsThemaListChanging | fIsThemaListChanged &#x2611;|
| fIsAntriebsartListChanging | fIsAntriebsartListChanged &#x2611;|
| fIsFzgKlasseListChanging | fIsFzgKlasseListChanged &#x2611;|
| fIsEinsatzdatumModelChanging | fIsEinsatzDatumModelChanged &#x2611;|
| fIsEinsatzdatum_TypChanging | fIsEinsatzDatumTypChanged &#x2611;|
| fIsEinsatzdatum_Types_Changing | fIsEinsatzDatumTypesChanged &#x2611;|
| fCheckDifference_to_Getex_Successor_relations | fCheckSuccessorDiff &#x2611;|
| fCheckDifference_to_Getex_Amendment_relations | fCheckAmendmentDiff &#x2611;|
| fCheckDifference_to_Getex_Demands_relations | fCheckDemandsDiff &#x2611;|
| fCheckDifference_to_Getex_LinkedTo_relations | fCheckLinkedToDiff &#x2611;|
| fCheckDifference_to_Getex_Equivalent_relations | fCheckEquivalentDiff &#x2611;|
| fCheckDifference_to_Getex_Consolidates_relations | fCheckConsolidatesDiff &#x2611;|

## 2. PCK_RI_GETEX_APPLY Functions

| Old Function (PCK_RI_GETEX) | New Function (PCK_RI_GETEX_APPLY) |
|----------------------------|----------------------------------|
| pLoad_Vorschrift_Thema_Einsatzdatum_typ_fromGetex | pLoadGetexThemaEinsatzDaten &#x2611;|
| pActualisiereVorschriftVerknuepfungen_vomGetex | pUpdateGetexVerknuepRelations &#x2611;|
| pMassenAktualisierung_Kerndaten_VomGetex | pMassenUpdateGetexKernDaten &#x2611;|
| pMassenAktualisierung_Einsatzdaten_VomGetex | pMassenUpdateGetexEinsatzdaten &#x2611;|
| pActualise_Predecessor_Relations_vomGetex | pUpdateGetexPredecessorRelations &#x2611;|
| pActualise_Linked_Relations_vomGetex | pUpdateGetexLinkedRelations &#x2611;|
| pActualise_Changes_Relations_vomGetex | pUpdateGetexChangeRelations &#x2611;|
| pActualise_Equivalent_Relations_vomGetex | pUpdateGetexEquivalentRelations &#x2611;|
| pActualise_Demands_Relations_vomGetex | pUpdateGetexDemandsRelations &#x2611;|
| pMassenAktualisierung_ListenAttributen_VomGetex | pMassenUpdateGetexListAttrs &#x2611;|
| pActualise_Consolidates_Relations_vomGetex | pUpdateGetexConsolidatesRelations &#x2611;|
| pactualiseVorschriftKerndaten | pUpdateKernDaten &#x2611;|
| pactualiseVorschriftThema | pUpdateVorThema &#x2611;|
| pactualiseVorschriftAntriebsart | pUpdateVorAntriebsart &#x2611;|
| pactualiseVorschriftFahrzeugklasse | pUpdateVorFzgKlasse &#x2611;|
| pactualiseVorschriftLand | pUpdateVorLand &#x2611;|
| pactualiseVorschriftEinsatzmodel | pUpdateVorEinsatzModel &#x2611;|
| pactualiseVorschriftEinsatzDaten | pUpdateVorEinsatzdaten &#x2611;|
| paktualise_In_Kraft_Datum | pUpdateInKraftDatum &#x2611;|
| pAbgleichRegindexVorschriftVomGetex | pAbgleichRegIndexVomGetex &#x2611;|
| tpFilltheThemaEinsatzdaten_from_getex | pFillGetexThemaEinsatzDaten *Deleted (Obsolete)* &#x2611;|

## 3. PCK_RI_GETEX_CTRL Functions

| Old Function (PCK_RI_GETEX) | New Function (PCK_RI_GETEX_CTRL) |
|----------------------------|--------------------------------|
| fAdjust_Equi_Demands | fEquiDemandsCheck &#x2611;|
| fUse_Getex_Subcountries | fSubcountryCheck &#x2611;|
| fCalcVorschriftTypID | fCalcVorTypID &#x2611;|
| fEinsatzdatum_ModellId | fEinsatzDatumModellID &#x2611;|
| pImportFromZip | pImportFromZip &#x2611;|
| pImportFromZip_snippet | pImportZipSnippet *Deleted (Obsolete)* &#x2611;|
| fTimestampToDate | fConvertTimestamp &#x2611;|
| pSetAttributesForGetexImport | pSetAttributesForGetexImport &#x2611;|
| fgetRelationDates_Getex | fGetGetexRelationDates &#x2611;|
| fNeueVorschrift | fNeueVorschrift &#x2611;|
| fVorschriftBitmaskHistory | fGetBitmaskHistory &#x2611;|
| pSynchronizeTopicNames | pSyncThemaNames &#x2611;|
| PHISTORIZE_GETEX_DATA | pHistorizeGetexData &#x2611;|
| pCreateJob_AbschlussBeladung | pCreateImportJob &#x2611;|
| pAbschlussBeladung | pAbschlussBeladung &#x2611;|
| pRefreshMViews | pRefreshMViews &#x2611;|
| pfill_Getex_key_in_regindex_vorschrift | pFillGetexKeys &#x2611;|


## 4. Functions to Delete from PCK_RI_GETEX

| Old Function (PCK_RI_GETEX) | New Function|
|----------------------------|--------------|
| pVergleichAttributevonGetex | PCK_RI_GETEX_COMPARE.pCompareGetexAttrs &#x2611;|
| tpFilltheThemaEinsatzdaten_from_getex | PCK_RI_GETEX_APPLY.pFillGetexThemaEinsatzDaten &#x2611;|
| pInitialCreation_regulationFromGetex | PCK_RI_GETEX_APPLY.pInitCreateGetexReg &#x2611;|
| pInitialComparing_existingWithregulationFromGetex | PCK_RI_GETEX_APPLY.pInitCompareGetexReg &#x2611;|
| pCreateRegulationFromGetexImport | Delete (Obsolete) *(NOT FOUND)* |
| pImportFromZip_snippet | PCK_RI_GETEX_CTRL.pImportZipSnippet &#x2611;|
