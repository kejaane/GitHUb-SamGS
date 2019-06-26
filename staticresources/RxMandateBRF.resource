{
  "RxMandate": [
    {
      "MandateTermDate": "4000-12-30",
      "MandateName": "MD",
      "MandateDescription": "MD",
      "MandateApply": "Y",
      "MandateJurisdiction": "M",
      "MandateEffectiveDate": "2017-01-01"
    },
    {
      "MandateTermDate": "2017-02-27",
      "MandateName": "FFM",
      "MandateDescription": "FFM",
      "MandateApply": "Y",
      "MandateJurisdiction": "M",
      "MandateEffectiveDate": "2017-02-01"
    }
  ],
  "DiabeticSuppCopayApply": "No",
  "MailOrdDispnsMaintDaysSupp": "90",
  "PlanId": "PLAN-2008",
  "RxTierCount": "3",
  "EndDate": "4000-12-31",
  "MailOrderAllDrugs": "Yes",
  "Network": [
    {
      "CostShareRanges": {
        "AnnualMax": {
          "Single": {
            "High": "NA",
            "Low": "NA",
            "Amount": "NA",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          }
        },
        "Deductible": {
          "Family": {
            "High": "900",
            "Low": "30",
            "Amount": "30",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "30"
          },
          "Single": {
            "High": "200",
            "Low": "10",
            "Amount": "10",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "5"
          },
          "Indvidual": {
            "High": "500",
            "Low": "25",
            "Amount": "25",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "25"
          }
        },
        "LifetimeMax": {
          "Single": {
            "High": "NA",
            "Low": "NA",
            "Amount": "NA",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          }
        },
        "OutOfPocket": {
          "Family": {
            "High": "2500",
            "Low": "250",
            "Amount": "250",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "50"
          },
          "Single": {
            "High": "1500",
            "Low": "150",
            "Amount": "150",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "150"
          },
          "Indvidual": {
            "High": "2000",
            "Low": "200",
            "Amount": "200",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "50"
          }
        },
        "CoinsuranceRange": {
          "High": "100",
          "Low": "0",
          "Amount": "80",
          "InvalidIncrements": "NA",
          "AdditionalIncrements": "NA",
          "Increment": "5"
        }
      },
      "NetworkID": "NET-12",
      "AliasName": "In-Network",
      "Grouper": [
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "2000",
                  "Low": "100",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "50"
                }
              },
              "MaxPayment": {
                "High": "50",
                "Low": "5",
                "InvalidIncrements": "15",
                "AdditionalIncrements": "42",
                "Increment": "5"
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-496",
              "MinPayment": {
                "High": "20",
                "Low": "2",
                "InvalidIncrements": "12",
                "AdditionalIncrements": "15",
                "Increment": "2"
              },
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 1,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "100",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "80",
                      "EndDate": "4000-12-31",
                      "TierNumber": "1",
                      "TierType": "Generic",
                      "MaxPayAmount": "40",
                      "IsCovered": true,
                      "MinPayAmount": "2"
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "Office",
                  "VariationID": "RX VC SF0313"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Occupational Therapy - Facility Practitioner",
              "CoinsuranceRange": {
                "High": "100",
                "Low": "0",
                "Amount": "80",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "5"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "2000",
                  "Low": "100",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "50"
                }
              },
              "MaxPayment": {
                "High": "50",
                "Low": "5",
                "InvalidIncrements": "15",
                "AdditionalIncrements": "42",
                "Increment": "5"
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-498",
              "MinPayment": {
                "High": "20",
                "Low": "2",
                "InvalidIncrements": "12",
                "AdditionalIncrements": "15",
                "Increment": "2"
              },
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "100",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "80",
                      "EndDate": "4000-12-31",
                      "TierNumber": "1",
                      "TierType": "Generic",
                      "MaxPayAmount": "40",
                      "IsCovered": true,
                      "MinPayAmount": "2"
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "Office",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Benefit Period",
                      "EffDate": "2016-01-01",
                      "MaxDuration": "1",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "150",
                      "MaxType": "Dollars"
                    }
                  ],
                  "VariationID": "RX VC SF0313"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Pulmonary Rehabilitation - Facility Practitioner",
              "CoinsuranceRange": {
                "High": "100",
                "Low": "0",
                "Amount": "80",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "5"
              }
            }
          ],
          "BRFSequence": 15,
          "GrouperID": "GRP-66",
          "AliasName": "MANDATES GRP 0317"
        }
      ]
    }
  ],
  "DeductibleAccumulatorMethod": "Stacked",
  "EffDate": "2016-01-01",
  "Option": "opt1",
  "CFPlanName": "Mandate Plan 0317",
  "MarketSegments": [
    {
      "AliasName": "Large(1000+)"
    }
  ],
  "DiabeticSuppDedApply": "No",
  "PrscrbdOrlContrcptvAndDevc": "",
  "IntegratedDedIndicator": "Yes",
  "CDHType": "HRA Non-Integrated",
  "ProductStatus": "Active",
  "Jurisdiction": "MD",
  "ProductLine": "PHARMACY",
  "PlanType": "Standard",
  "CDHFundtype": "BlueFund",
  "CFProductID": "ELEL1234",
  "RxNetwork": "National",
  "RetDispnsMaintDaysSupp": "90",
  "ProductCategory": "Pharmacy",
  "GenStepTherapy": "No",
  "RetDispnsNMaintDaysSupp": "34",
  "RxFundamentalApply": "Yes",
  "ParentProductName": "MANDATE PROD 0317",
  "PriorAuth": "Yes",
  "IntegratedOOPIndicator": "Yes",
  "OOPAccumulatorMethod": "Stacked",
  "DiabeticSuppMandateApply": "Yes",
  "MailOrdDispnsNMaintDaysSupp": "34",
  "OTCCovered": "Yes",
  "GenDispsng": "MANDATORY",
  "GrowthHormone": "Yes",
  "PrevntvCovrd": "Yes"
}