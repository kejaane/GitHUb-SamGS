{
  "DiabeticSuppCopayApply": "Yes",
  "RxTierCount": "4",
  "MailOrderAllDrugs": "Yes",
  "EndDate": "2050-12-31",
  "Network": [
    {
      "CostShareRanges": {
        "Deductible": {
          "Family": {
            "High": "100",
            "Low": "15",
            "Amount": "30",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "15"
          },
          "Single": {
            "High": "50",
            "Low": "5",
            "Amount": "10",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "5"
          },
          "Indvidual": {
            "High": "60",
            "Low": "10",
            "Amount": "20",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "10"
          }
        },
        "LifetimeMax": {
          "Single": {
            "High": "20",
            "Low": "5",
            "Amount": "10",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "5"
          }
        },
        "OutOfPocket": {
          "Family": {
            "High": "60",
            "Low": "10",
            "Amount": "20",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "10"
          },
          "Single": {
            "High": "20",
            "Low": "2",
            "Amount": "4",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "2"
          },
          "Indvidual": {
            "High": "40",
            "Low": "5",
            "Amount": "10",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "5"
          }
        },
        "CoinsuranceRange": {
          "High": "50",
          "Low": "10",
          "Amount": "20",
          "InvalidIncrements": "NA",
          "AdditionalIncrements": "NA",
          "Increment": "10"
        }
      },
      "AliasName": "In-Network",
      "Grouper": [
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "100",
                  "Low": "20",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "20"
                }
              },
              "MaxPayment": {
                "High": "100",
                "Low": "15",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "15"
              },
              "MinPayment": {
                "High": "100",
                "Low": "10",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "10"
              },
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "40",
                      "TierCoinsuranceAmount": "20",
                      "MaxPayAmount": "30",
                      "MinPayAmount": "20",
                      "TierType": "Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "Freestanding",
                  "ProviderType": "Facility"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "BEN Rx SF BT 0930",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "10",
                "Amount": "20",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "10"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "100",
                  "Low": "20",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "20"
                }
              },
              "MaxPayment": {
                "High": "100",
                "Low": "15",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "15"
              },
              "MinPayment": {
                "High": "100",
                "Low": "10",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "10"
              },
              "BRFSequence": 3,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "40",
                      "TierCoinsuranceAmount": "20",
                      "MaxPayAmount": "30",
                      "MinPayAmount": "20",
                      "TierType": "Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "BENTS Rx SF BT 0930",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "10",
                "Amount": "20",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "10"
              }
            }
          ],
          "BRFSequence": 66,
          "AliasName": "GRP_RX_MR_930"
        }
      ]
    }
  ],
  "EffDate": "2016-10-06",
  "Option": "FDER5",
  "FertilityAgents": "Yes",
  "MarketSegments": [
    {
      "AliasName": "Large(1000+)"
    }
  ],
  "Jurisdiction": "VA",
  "ProductStatus": "Active",
  "PlanType": "Standard",
  "OralChemoCopayApply": "Yes",
  "CDHFundtype": "BlueFund",
  "CFProductID": "AIAKJIUH",
  "ErectileDysfunc": "Yes",
  "GenStepTherapy": "Yes",
  "RxFundamentalApply": "Yes",
  "RxFundamentalDedCopayRule": "Waive Ded/Waive Copay (Standard)",
  "OTCCovered": "Yes",
  "GenDispsng": "VOLUNTARY",
  "RetMailDispnsMaint": "Other",
  "GrowthHormone": "Yes",
  "OralChemoDedApply": "Yes",
  "MailOrdDispnsMaintDaysSupp": "90",
  "PlanId": "PLAN-TEST-RX",
  "DeductibleAccumulatorMethod": "N/A",
  "CFPlanName": "PLAN RX MR 106",
  "OralChemoMandateApply": "Yes",
  "DiabeticSuppDedApply": "Yes",
  "LegalEntity": "CFBC",
  "PrscrbdOrlContrcptvAndDevc": "Woman’s Preventive Services (standard with Preventive $0 copay unless religious exclusion)",
  "IntegratedDedIndicator": "Yes",
  "HBSelectGeneric": "Waive Ded/Waive Copay (Standard)",
  "CDHType": "HRA Non-Integrated",
  "ProductLine": "PHARMACY",
  "RxNetwork": "National",
  "RetDispnsMaintDaysSupp": "90",
  "ProductCategory": "Pharmacy",
  "RetDispnsNMaintDaysSupp": "34",
  "ParentProductName": "PROD RX MR 106",
  "IntegratedOOPIndicator": "Yes",
  "PriorAuth": "Yes",
  "RetMailDispnsMaintLimitation": "Others",
  "DiabeticSuppMandateApply": "Yes",
  "MailOrdDispnsNMaintDaysSupp": "34",
  "OOPAccumulatorMethod": "Unstacked",
  "PrevntvDrugCopayAmount": "300",
  "AllergySerums": "Yes",
  "PrevntvCovrd": "Yes"
}