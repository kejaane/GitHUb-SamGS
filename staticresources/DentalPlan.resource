{
  "Jurisdiction": "DC",
  "ProductStatus": "Active",
  "InOutNetLifeTimeMaximum": "Yes",
  "PlanType": "Standard",
  "ProductLine": "DENTAL",
  "PlanId": "PLAN-2058",
  "CFProductID": "QLPE2277",
  "EndDate": "4000-12-31",
  "InOutNetAnnualMaximum": "Yes",
  "ProductCategory": "Dental",
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
            "High": "NA",
            "Low": "NA",
            "Amount": "NA",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          },
          "Single": {
            "High": "NA",
            "Low": "NA",
            "Amount": "NA",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          },
          "Indvidual": {
            "High": "NA",
            "Low": "NA",
            "Amount": "NA",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
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
            "High": "NA",
            "Low": "NA",
            "Amount": "NA",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          },
          "Single": {
            "High": "NA",
            "Low": "NA",
            "Amount": "NA",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          },
          "Indvidual": {
            "High": "NA",
            "Low": "NA",
            "Amount": "NA",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          }
        },
        "CoinsuranceRange": {
          "High": "NA",
          "Low": "NA",
          "Amount": "NA",
          "InvalidIncrements": "NA",
          "AdditionalIncrements": "NA",
          "Increment": "NA"
        }
      },
      "NetworkID": "NET-13",
      "AliasName": "In-Network",
      "Grouper": [
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "200",
                  "Low": "20",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "5"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-555",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 1,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "20",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "EffDate": "2016-01-01",
                      "MaxDuration": "14",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "12",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Days"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Comprehensive â€“ adolescent",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "500",
                  "Low": "50",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "50"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-554",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "50",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "EffDate": "2016-01-01",
                      "MaxDuration": "15",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "12",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ]
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Comprehensive â€“ adult",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "500",
                  "Low": "50",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "10"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-552",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 3,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "50",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Admission",
                      "EffDate": "2016-01-01",
                      "MaxDuration": "2",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "11",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Screening"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Orthodontic retention",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "600",
                  "Low": "60",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "20"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-553",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 4,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "60",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Admission",
                      "EffDate": "2016-01-01",
                      "MaxDuration": "12",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "12",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Days"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Pre-orthodontic treatment visit",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            }
          ],
          "BRFSequence": 10,
          "GrouperID": "GRP-87",
          "DeductibleApplies": "Yes",
          "AnnualMaximumApplies": "Yes",
          "AliasName": "ORTHODONTICS",
          "IsCovered": true,
          "CoinsuranceRange": {
            "High": "NA",
            "Low": "NA",
            "Amount": "100",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          }
        },
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "800",
                  "Low": "100",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "10"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-547",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 1,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "100",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Hours",
                      "EffDate": "2016-01-01",
                      "MaxDuration": "14",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "15",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Days"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Full mouth debridement",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "200",
                  "Low": "50",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "10"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-556",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "50",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Day",
                      "EffDate": "2016-01-01",
                      "MaxDuration": "12",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "4",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Accidental Treatment"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Periodontal maintenance procedures following active therapy",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "300",
                  "Low": "30",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "10"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-523",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 3,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "30",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Hours",
                      "EffDate": "2016-01-01",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Dollars"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Periodontal scaling and root planing",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            }
          ],
          "BRFSequence": 9,
          "GrouperID": "GRP-85",
          "DeductibleApplies": "Yes",
          "AnnualMaximumApplies": "Yes",
          "AliasName": "SOFT TISSUE MANAGEMENT (PER OFFICE VISIT COPAY)",
          "IsCovered": true,
          "CoinsuranceRange": {
            "High": "NA",
            "Low": "NA",
            "Amount": "100",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          }
        },
        {
          "Benefit": [
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "900",
                  "Low": "90",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "10"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-551",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 1,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "90",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Day",
                      "EffDate": "2016-01-01",
                      "MaxDuration": "14",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "12",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Days"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Osseous Surgery (including flap entry and closure) per quadrant",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "NA",
                  "Low": "NA",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "NA"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-549",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 2,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "50",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Admission",
                      "EffDate": "2016-01-01",
                      "MaxDuration": "14",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "12",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Dollars"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Removal of impacted tooth â€“ completely bony",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            },
            {
              "CopayRange": {
                "AmountRange": {
                  "High": "600",
                  "Low": "50",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "20"
                }
              },
              "IsAppGlobalCopay": false,
              "BenefitID": "BEN-550",
              "IsAppGlobalCoinsurance": false,
              "BRFSequence": 3,
              "VariationCondition": [
                {
                  "CopayType": [
                    {
                      "TierCopayAmount": "50",
                      "EffDate": "2016-01-01",
                      "TierCoinsuranceAmount": "N/A",
                      "DeductibleApplies": "Yes",
                      "EndDate": "4000-12-31",
                      "AnnualMaximumApplies": "Y",
                      "TierNumber": "1",
                      "IsCovered": true
                    }
                  ],
                  "PlaceOfService": "General",
                  "ProviderType": "General",
                  "MaxRows": [
                    {
                      "MaxDurationType": "Hours",
                      "EffDate": "2016-01-01",
                      "MaxDuration": "10",
                      "EndDate": "4000-12-31",
                      "TierNumber": "2",
                      "MaxValue": "12",
                      "BenefitCommentCodes": [
                        {
                          "IsRequired": "Yes",
                          "Type": "Limitation",
                          "FundingArrangement": "ASO",
                          "Code": "345",
                          "Comment": "limits apply for regular and immediate dentures"
                        }
                      ],
                      "MaxType": "Days"
                    }
                  ],
                  "VariationID": "General-General"
                }
              ],
              "ASOFlag": "No",
              "AliasName": "Surgical removal of erupted tooth",
              "CoinsuranceRange": {
                "High": "NA",
                "Low": "NA",
                "Amount": "NA",
                "InvalidIncrements": "NA",
                "AdditionalIncrements": "NA",
                "Increment": "NA"
              }
            }
          ],
          "BRFSequence": 8,
          "GrouperID": "GRP-86",
          "DeductibleApplies": "Yes",
          "AnnualMaximumApplies": "Yes",
          "AliasName": "SURGICAL SERVICES",
          "IsCovered": true,
          "CoinsuranceRange": {
            "High": "NA",
            "Low": "NA",
            "Amount": "100",
            "InvalidIncrements": "NA",
            "AdditionalIncrements": "NA",
            "Increment": "NA"
          }
        }
      ]
    }
  ],
  "ParentProductName": "PROD DHMO PP 0404",
  "EffDate": "2016-01-01",
  "Option": "OPT1",
  "CFPlanName": "PLAN DHMO PP 0404",
  "MarketSegments": [
    {
      "AliasName": "Large(1000+)"
    }
  ]
}