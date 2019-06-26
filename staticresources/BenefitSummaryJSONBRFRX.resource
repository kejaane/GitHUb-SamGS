{
  "DiabeticSuppCopayApply": "No",
  "MailOrdDispnsMaintDaysSupp": "90",
  "PlanId": "PLAN-1474",
  "RxTierCount": "3",
  "EndDate": "4000-12-31",
  "MailOrderAllDrugs": "Yes",
  "Network": [
    {
      "CostShareRanges": {
        "Deductible": {
          "Family": {
            "High": "20000",
            "Low": "5",
            "Amount": "0",
            "InvalidIncrements": "5",
            "AdditionalIncrements": "0",
            "Increment": "1"
          },
          "Single": {
            "High": "10000",
            "Low": "5",
            "Amount": "0",
            "InvalidIncrements": "5",
            "AdditionalIncrements": "0",
            "Increment": "1"
          },
          "Indvidual": {
            "High": "20000",
            "Low": "5",
            "Amount": "NA",
            "InvalidIncrements": "5",
            "AdditionalIncrements": "0",
            "Increment": "1"
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
            "High": "20000",
            "Low": "5",
            "Amount": "9000",
            "InvalidIncrements": "5",
            "AdditionalIncrements": "0",
            "Increment": "1"
          },
          "Single": {
            "High": "10000",
            "Low": "5",
            "Amount": "4500",
            "InvalidIncrements": "5",
            "AdditionalIncrements": "0",
            "Increment": "1"
          },
          "Indvidual": {
            "High": "20000",
            "Low": "5",
            "Amount": "NA",
            "InvalidIncrements": "5",
            "AdditionalIncrements": "0",
            "Increment": "1"
          }
        },
        "CoinsuranceRange": {
          "High": "50",
          "Low": "0",
          "Amount": "NA",
          "InvalidIncrements": "NA",
          "AdditionalIncrements": "NA",
          "Increment": "1"
        }
      },
      "AliasName": "In-Network",
      "Grouper": [
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "200",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "3000",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "300",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 1,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "16",
                      "TierType": "Generic",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Mail Order Maintenance Generic",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "200",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "3000",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "300",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 3,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "60",
                      "TierType": "Non-Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Mail Order Maintenance NonPreferred Brand",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "200",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "3000",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "300",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "30",
                      "TierType": "Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Mail Order Maintenance Preferred Brand",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            }
          ],
          "BRFSequence": 4,
          "AliasName": "3 Tier Mail Order Maintenance"
        },
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "100",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "1500",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "150",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 1,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "8",
                      "TierType": "Generic",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Mail Order NonMaintenance Generic",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "100",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "1500",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "150",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 3,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "30",
                      "TierType": "Non-Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Mail Order NonMaintenance NonPreferred Brand",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "100",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "1500",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "150",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "15",
                      "TierType": "Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Mail Order NonMaintenance Preferred Brand",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            }
          ],
          "BRFSequence": 3,
          "AliasName": "3 Tier Mail Order NonMaintenance"
        },
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "200",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "3000",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "300",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 1,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "16",
                      "TierType": "Generic",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Retail Maintenance Generic",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "200",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "3000",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "300",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 3,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "60",
                      "TierType": "Non-Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Retail Maintenance NonPreferred Brand",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "200",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "3000",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "300",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "30",
                      "TierType": "Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Retail Maintenance Preferred Brand",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            }
          ],
          "BRFSequence": 2,
          "AliasName": "3 Tier Retail Maintenance"
        },
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "100",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "1500",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "150",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 1,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "8",
                      "TierType": "Generic",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Retail NonMaintenance Generic",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "100",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "1500",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "150",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 3,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "30",
                      "TierType": "Non-Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Retail NonMaintenance NonPreferred Brand",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "100",
                  "Low": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "1"
                }
              },
              "MaxPayment": {
                "High": "1500",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "MinPayment": {
                "High": "150",
                "Low": "5",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              },
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "15",
                      "TierType": "Preferred",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Retail NonMaintenance Preferred Brand",
              "CoinsuranceRange": {
                "High": "50",
                "Low": "0",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "1"
              }
            }
          ],
          "BRFSequence": 1,
          "AliasName": "3 Tier Retail NonMaintenance"
        }
      ]
    }
  ],
  "EffDate": "1940-01-01",
  "Option": "Option 2",
  "CFPlanName": "Rx $0 DED $4500/$9000 OOP $8/$15/$30",
  "FertilityAgents": "Yes",
  "OralChemoMandateApply": "Yes",
  "MarketSegments": [
    {
      "AliasName": "Large(1000+)"
    },
    {
      "AliasName": "Large(200-999)"
    }
  ],
  "DiabeticSuppDedApply": "No",
  "PrscrbdOrlContrcptvAndDevc": "Womans Preventive Services (standard with Preventive $0 copay unless religious exclusion)",
  "IntegratedDedIndicator": "No",
  "ProductStatus": "Active",
  "Jurisdiction": "DC",
  "ProductLine": "PHARMACY",
  "PlanType": "Standard",
  "OralChemoCopayApply": "No",
  "RxNetwork": "National",
  "ErectileDysfunc": "Yes",
  "RetDispnsMaintDaysSupp": "90",
  "ProductCategory": "Pharmacy",
  "GenStepTherapy": "No",
  "RetDispnsNMaintDaysSupp": "34",
  "ParentProductName": "Rx 3 Tier Blue Preferred Product - DC - Non-Integrated Ded Non-Integrated OOP",
  "PriorAuth": "Yes",
  "IntegratedOOPIndicator": "No",
  "PrevntvDrugCopayAmount": "0",
  "OOPAccumulatorMethod": "Stacked",
  "MailOrdDispnsNMaintDaysSupp": "34",
  "DiabeticSuppMandateApply": "Yes",
  "OTCCovered": "Yes",
  "GenDispsng": "RESTRICTED",
  "AllergySerums": "No",
  "RetMailDispnsMaint": "Up to 90 day supply 2 copays (standard)",
  "GrowthHormone": "Yes",
  "PrevntvCovrd": "Yes",
  "OralChemoDedApply": "No"
}