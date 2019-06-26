{
   "ReferralSpecDescription": "Referral to a Specialist or Non-Physician Specialist:  A Member May Request a Referral to a Specialist or Non-Physician Specialist who is a Non-Preferred Provider if the Member is Diagnosed with a Condition or Disease that Requires Specialized Health Care Services or Medical Care.  For Purposes of Calculating Any Member Payment, Covered Services Rendered by the Non-Preferred Provider will be Treated as if the Services were Provided by a Preferred Provider if CareFirst does not Contract with, or Cannot Provide Reasonable Access to, a Preferred Provider with the Professional Training and Expertise to Treat the Condition.",
   "PlanId": "PLAN-1382",
   "EndDate": "4000-12-31",
   "Network":    [
            {
         "CostShareRanges":          {
            "Deductible":             {
               "Family":                {
                  "High": "20000",
                  "Low": "100",
                  "Amount": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               },
               "Single":                {
                  "High": "20000",
                  "Low": "100",
                  "Amount": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               },
               "Indvidual":                {
                  "High": "20000",
                  "Low": "100",
                  "Amount": "NA",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               }
            },
            "DeductibleCarryover":             {
               "PeriodValue": "NA",
               "High": "3",
               "Low": "0",
               "TimeValue": "Months",
               "InvalidIncrements": "NA",
               "AdditionalIncrements": "NA",
               "Increment": "3"
            },
            "LifetimeMax": {"Single":             {
               "High": "NA",
               "Low": "NA",
               "Amount": "NA",
               "InvalidIncrements": "NA",
               "AdditionalIncrements": "NA",
               "Increment": "NA"
            }},
            "OutOfPocket":             {
               "Family":                {
                  "High": "40000",
                  "Low": "100",
                  "Amount": "2000",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               },
               "Single":                {
                  "High": "40000",
                  "Low": "100",
                  "Amount": "1000",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               },
               "Indvidual":                {
                  "High": "40000",
                  "Low": "100",
                  "Amount": "NA",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               }
            },
            "Copay":             {
               "PerAdmissionCopay":                {
                  "High": "5000",
                  "Low": "25",
                  "Amount": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "25"
               },
               "SpecialistCopay":                {
                  "High": "75",
                  "Low": "0",
                  "Amount": "10",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "5"
               },
               "PCPCopay":                {
                  "High": "75",
                  "Low": "0",
                  "Amount": "10",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "5"
               }
            },
            "CoinsuranceRange":             {
               "High": "100",
               "Low": "50",
               "Amount": "100",
               "InvalidIncrements": "NA",
               "AdditionalIncrements": "NA",
               "Increment": "5"
            }
         },
         "AliasName": "In-Network",
         "Grouper":          [
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true,
                           "BenefitCommentCodes": [                           {
                              "IsRequired": "Yes",
                              "Type": "",
                              "Code": "1",
                              "Comment": "Includes Preadmission Testing"
                           }]
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Lab  - Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes": [                              {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "1",
                                 "Comment": "Includes Preadmission Testing"
                              }]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Lab - Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes": [                              {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "1",
                                 "Comment": "Includes Preadmission Testing"
                              }]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Lab - Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 6,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "4",
                                    "Comment": "Out of Network Paid the Same as In-Network"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "1",
                                    "Comment": "Includes Preadmission Testing"
                                 }
                              ]
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Radiological Imaging – Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true,
                           "BenefitCommentCodes":                            [
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "4",
                                 "Comment": "Out of Network Paid the Same as In-Network"
                              },
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "1",
                                 "Comment": "Includes Preadmission Testing"
                              }
                           ]
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Radiological Imaging – Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "4",
                                    "Comment": "Out of Network Paid the Same as In-Network"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "1",
                                    "Comment": "Includes Preadmission Testing"
                                 }
                              ]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Radiological Imaging – Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 9,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "4",
                                    "Comment": "Out of Network Paid the Same as In-Network"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "1",
                                    "Comment": "Includes Preadmission Testing"
                                 }
                              ]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "MRI/CAT Scan – Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 7,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true,
                           "BenefitCommentCodes":                            [
                                                            {
                                 "IsRequired": "No",
                                 "Type": "",
                                 "Code": "4",
                                 "Comment": "Out of Network Paid the Same as In-Network"
                              },
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "1",
                                 "Comment": "Includes Preadmission Testing"
                              }
                           ]
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "MRI/CAT Scan – Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 8,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "4",
                                    "Comment": "Out of Network Paid the Same as In-Network"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "1",
                                    "Comment": "Includes Preadmission Testing"
                                 }
                              ]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "MRI/CAT Scan – Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 1,
               "AliasName": "Diagnostic/Lab/X-Ray"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "50",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true,
                           "BenefitCommentCodes":                            [
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "4",
                                 "Comment": "Out of Network Paid the Same as In-Network"
                              },
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "3",
                                 "Comment": "Copay Waived if Admitted"
                              }
                           ]
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Emergency Services  - Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "4",
                                    "Comment": "Out of Network Paid the Same as In-Network"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "3",
                                    "Comment": "Copay Waived if Admitted"
                                 }
                              ]
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Emergency Services  - Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "10",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "10",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "6",
                                    "Comment": "Copay Applies to the Office Exam Only"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "63",
                                    "Comment": "PPACA Payment Rules do not Apply"
                                 }
                              ]
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Emergency Services – Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "200",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true,
                           "BenefitCommentCodes": [                           {
                              "IsRequired": "Yes",
                              "Type": "",
                              "Code": "63",
                              "Comment": "PPACA Payment Rules do not Apply"
                           }]
                        }],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Urgent Care Center",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 2,
               "AliasName": "Emergency Services"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 7,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Artificial Insemination –  Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true,
                           "BenefitCommentCodes":                            [
                                                            {
                                 "IsRequired": "No",
                                 "Type": "",
                                 "Code": "11",
                                 "Comment": "AI Benefits are Available Even if Donor Eggs/Sperm are Used"
                              },
                                                            {
                                 "IsRequired": "No",
                                 "Type": "",
                                 "Code": "10",
                                 "Comment": "AI Benefits are Not Available if Donor Eggs/Sperm are Used"
                              },
                                                            {
                                 "IsRequired": "No",
                                 "Type": "",
                                 "Code": "9",
                                 "Comment": "Cost of Donor Eggs/Sperm Covered"
                              }
                           ]
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Artificial Insemination – Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 6,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Artificial Insemination – Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 11,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "15",
                                    "Comment": "2 Year Infertility History. Abnormal Male Factor, Including Oligospermia added as Eligible Medical Condition to Waive the 2 Year Waiting Period. 3 Attempts Per Live Birth. Not to Exceed a Lifetime Benefit of $100,000."
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "14",
                                    "Comment": "2 Year Infertility History. Abnormal Male Factor, Including Oligospermia added as Eligible Medical Condition to Waive the 2 Year Waiting Period. 3 Attempts Per Live Birth. Not to Exceed a Lifetime Benefit of $100,000. IVF Benefits are Available to Same-Sex Spouses."
                                 }
                              ]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "In-Vitro Fertilization  –  Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 8,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Invitro Fertilization",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "18",
                                    "Comment": "Same-Sex and Opposite Sex IVF Benefits are Available Even if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "17",
                                    "Comment": "If the Member and Spouse are of the Same Sex, IVF Benefits are Available Even if Donor Eggs/Sperm are Used. If the Member and Spouse are of the Opposite Sex, IVF Benefits are Not Available if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "16",
                                    "Comment": "IVF Benefits are Not Available if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "15",
                                    "Comment": "2 Year Infertility History. Abnormal Male Factor, Including Oligospermia added as Eligible Medical Condition to Waive the 2 Year Waiting Period. 3 Attempts Per Live Birth. Not to Exceed a Lifetime Benefit of $100,000."
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "14",
                                    "Comment": "2 Year Infertility History. Abnormal Male Factor, Including Oligospermia added as Eligible Medical Condition to Waive the 2 Year Waiting Period. 3 Attempts Per Live Birth. Not to Exceed a Lifetime Benefit of $100,000. IVF Benefits are Available to Same-Sex Spouses."
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "13",
                                    "Comment": "Infertility Services Treatment Covered"
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "12",
                                    "Comment": "Infertility Services Diagnosis/Testing is Paid the same as any Other Outpatient Related Service"
                                 }
                              ]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "IsCovered": false,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "18",
                                    "Comment": "Same-Sex and Opposite Sex IVF Benefits are Available Even if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "17",
                                    "Comment": "If the Member and Spouse are of the Same Sex, IVF Benefits are Available Even if Donor Eggs/Sperm are Used. If the Member and Spouse are of the Opposite Sex, IVF Benefits are Not Available if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "16",
                                    "Comment": "IVF Benefits are Not Available if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "15",
                                    "Comment": "2 Year Infertility History. Abnormal Male Factor, Including Oligospermia added as Eligible Medical Condition to Waive the 2 Year Waiting Period. 3 Attempts Per Live Birth. Not to Exceed a Lifetime Benefit of $100,000."
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "14",
                                    "Comment": "2 Year Infertility History. Abnormal Male Factor, Including Oligospermia added as Eligible Medical Condition to Waive the 2 Year Waiting Period. 3 Attempts Per Live Birth. Not to Exceed a Lifetime Benefit of $100,000. IVF Benefits are Available to Same-Sex Spouses."
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "13",
                                    "Comment": "Infertility Services Treatment Covered"
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "12",
                                    "Comment": "Infertility Services Diagnosis/Testing is Paid the same as any Other Outpatient Related Service"
                                 }
                              ]
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "In-Vitro Fertilization  –  Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 9,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "18",
                                    "Comment": "Same-Sex and Opposite Sex IVF Benefits are Available Even if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "17",
                                    "Comment": "If the Member and Spouse are of the Same Sex, IVF Benefits are Available Even if Donor Eggs/Sperm are Used. If the Member and Spouse are of the Opposite Sex, IVF Benefits are Not Available if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "16",
                                    "Comment": "IVF Benefits are Not Available if Donor Eggs/Sperm are Used"
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "15",
                                    "Comment": "2 Year Infertility History. Abnormal Male Factor, Including Oligospermia added as Eligible Medical Condition to Waive the 2 Year Waiting Period. 3 Attempts Per Live Birth. Not to Exceed a Lifetime Benefit of $100,000."
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "14",
                                    "Comment": "2 Year Infertility History. Abnormal Male Factor, Including Oligospermia added as Eligible Medical Condition to Waive the 2 Year Waiting Period. 3 Attempts Per Live Birth. Not to Exceed a Lifetime Benefit of $100,000. IVF Benefits are Available to Same-Sex Spouses."
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "13",
                                    "Comment": "Infertility Services Treatment Covered"
                                 },
                                                                  {
                                    "IsRequired": "No",
                                    "Type": "",
                                    "Code": "12",
                                    "Comment": "Infertility Services Diagnosis/Testing is Paid the same as any Other Outpatient Related Service"
                                 }
                              ]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "In-Vitro Fertilization  –  Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "Per Admission Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Maternity - Inpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Maternity - Inpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes": [                              {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "66",
                                 "Comment": "Includes Newborn Discharge Visit"
                              }]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Newborn Care",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Pre & Post Natal Care",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 3,
               "AliasName": "Maternity"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Durable Medical Equipment",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "Jurisdiction": "MD",
                           "TierCopayAmount": "0",
                           "MandateName": "Hearing Aids for Minor Children",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "Yes",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "General",
                        "ProviderType": "General",
                        "MaxRows": [                        {
                           "Jurisdiction": "MD",
                           "MaxDurationType": "Months",
                           "MandateName": "Hearing Aids for Minor Children",
                           "MaxAgeFrom": "0",
                           "MaxAgeType": "Years",
                           "MaxAgeTo": "18",
                           "MandateInd": "Yes",
                           "MaxDuration": "36",
                           "MaxApply": "Per Hearing Impaired Ear",
                           "MaxValue": "1",
                           "MaxType": "Hearing Aid"
                        }]
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hearing Aids for Minor Children",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 4,
               "AliasName": "Medical Devices and Supplies"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "5",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "5",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Allergy Injections",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Allergy Testing",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "Per Admission Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hospital - Inpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hospital - Inpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hospital - Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 7,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "10",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "10",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Professional Physician Visit - Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 6,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Professional Physician Visit - Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 5,
               "AliasName": "Medical Services"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Per Admission Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "25",
                                    "Comment": "Includes Inpatient Psychiatric, Alcohol, Drug Abuse Services"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "24",
                                    "Comment": "Includes Behavioral Health Treatment"
                                 }
                              ]
                           }
                        ],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Inpatient  Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "25",
                                    "Comment": "Includes Inpatient Psychiatric, Alcohol, Drug Abuse Services"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "24",
                                    "Comment": "Includes Behavioral Health Treatment"
                                 }
                              ]
                           }
                        ],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Inpatient  Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "10",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "26",
                                    "Comment": "Includes Outpatient Psychiatric, Alcohol, Drug Abuse"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "24",
                                    "Comment": "Includes Behavioral Health Treatment"
                                 }
                              ]
                           },
                                                      {
                              "TierCopayAmount": "10",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true,
                           "BenefitCommentCodes":                            [
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "26",
                                 "Comment": "Includes Outpatient Psychiatric, Alcohol, Drug Abuse"
                              },
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "24",
                                 "Comment": "Includes Behavioral Health Treatment"
                              }
                           ]
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes":                               [
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "26",
                                    "Comment": "Includes Outpatient Psychiatric, Alcohol, Drug Abuse"
                                 },
                                                                  {
                                    "IsRequired": "Yes",
                                    "Type": "",
                                    "Code": "24",
                                    "Comment": "Includes Behavioral Health Treatment"
                                 }
                              ]
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 6,
               "AliasName": "Mental Health/Substance Abuse"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true,
                           "BenefitCommentCodes":                            [
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "72",
                                 "Comment": "Surface"
                              },
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "73",
                                 "Comment": "Air"
                              },
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "74",
                                 "Comment": "Private"
                              },
                                                            {
                                 "IsRequired": "Yes",
                                 "Type": "",
                                 "Code": "75",
                                 "Comment": "Public"
                              }
                           ]
                        }],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Ambulance",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Hospice",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility",
                        "MaxRows": [                        {
                           "Jurisdiction": "MD",
                           "MaxDurationType": "Lifetime",
                           "MandateName": "Hospice",
                           "MandateInd": "Yes",
                           "MaxDuration": "1",
                           "MaxValue": "180",
                           "BenefitCommentCodes": [                           {
                              "IsRequired": "Yes",
                              "Type": "",
                              "Code": "78",
                              "Comment": "Inpatient and Outpatient Combinded"
                           }],
                           "MaxType": "Days"
                        }]
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hospice -  Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "Per Admission Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility",
                        "MaxRows": [                        {
                           "MaxDurationType": "Benefit Period",
                           "MandateInd": "No",
                           "MaxDuration": "1",
                           "MaxValue": "60",
                           "MaxType": "Days"
                        }]
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Skilled Nursing",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 7,
               "AliasName": "Other Medical Care"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "999",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "999",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Adult Routine  - Physical Exam",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Colorectal Cancer Screening",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine Colorectal Cancer Screening",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine GYN Physical Exam",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Breast Cancer Mammography Screening",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine Mammography",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine Pap Smear - Screening Lab",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 6,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "VA",
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "TierAgeFrom": "40",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "999",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Prostate Cancer Screening",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "40",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "75",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine Prostate Cancer Screening",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 7,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Child Wellness Services",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Child Wellness Services",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Well Child Routine - Immunizations",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "500",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 8,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Child Wellness Services",
                              "TierCoinsuranceAmount": "100",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "17",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "17",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "17",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Child Wellness Services",
                              "TierCoinsuranceAmount": "100",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "17",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Well Child Routine - Physical Exam",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 8,
               "AliasName": "Preventive Services"
            }
         ]
      },
            {
         "CostShareRanges":          {
            "Deductible":             {
               "Family":                {
                  "High": "40000",
                  "Low": "100",
                  "Amount": "500",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               },
               "Single":                {
                  "High": "40000",
                  "Low": "100",
                  "Amount": "250",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               },
               "Indvidual":                {
                  "High": "20000",
                  "Low": "100",
                  "Amount": "NA",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               }
            },
            "DeductibleCarryover":             {
               "PeriodValue": "NA",
               "High": "3",
               "Low": "0",
               "TimeValue": "Months",
               "InvalidIncrements": "NA",
               "AdditionalIncrements": "NA",
               "Increment": "3"
            },
            "LifetimeMax": {"Single":             {
               "High": "NA",
               "Low": "NA",
               "Amount": "NA",
               "InvalidIncrements": "NA",
               "AdditionalIncrements": "NA",
               "Increment": "NA"
            }},
            "OutOfPocket":             {
               "Family":                {
                  "High": "80000",
                  "Low": "100",
                  "Amount": "4000",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               },
               "Single":                {
                  "High": "80000",
                  "Low": "100",
                  "Amount": "2000",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               },
               "Indvidual":                {
                  "High": "40000",
                  "Low": "100",
                  "Amount": "NA",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "50"
               }
            },
            "Copay":             {
               "PerAdmissionCopay":                {
                  "High": "5000",
                  "Low": "25",
                  "Amount": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "0",
                  "Increment": "25"
               },
               "SpecialistCopay":                {
                  "High": "75",
                  "Low": "0",
                  "Amount": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "5"
               },
               "PCPCopay":                {
                  "High": "75",
                  "Low": "0",
                  "Amount": "0",
                  "InvalidIncrements": "NA",
                  "AdditionalIncrements": "NA",
                  "Increment": "5"
               }
            },
            "CoinsuranceRange":             {
               "High": "100",
               "Low": "50",
               "Amount": "80",
               "InvalidIncrements": "NA",
               "AdditionalIncrements": "NA",
               "Increment": "5"
            }
         },
         "AliasName": "Out of Network",
         "Grouper":          [
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "5",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Lab  - Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Lab - Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true,
                              "BenefitCommentCodes": [                              {
                                 "IsRequired": "N/A",
                                 "Type": "",
                                 "Code": "4",
                                 "Comment": "Out of Network Paid the Same as In-Network"
                              }]
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Lab - Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 6,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Radiological Imaging – Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "5",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Radiological Imaging – Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Diagnostic Radiological Imaging – Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 9,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "MRI/CAT Scan – Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "5",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 7,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "MRI/CAT Scan – Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "5",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "0",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 8,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "MRI/CAT Scan – Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 1,
               "AliasName": "Diagnostic/Lab/X-Ray"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "50",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "No",
                           "DeductibleApplies": "No",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Emergency Services  - Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Emergency Services  - Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Emergency Services – Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Urgent Care Center",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 2,
               "AliasName": "Emergency Services"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 7,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Artificial Insemination –  Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Artificial Insemination – Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 6,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Artificial Insemination – Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 11,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "In-Vitro Fertilization  –  Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "500",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 8,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "DeductibleApplies": "Yes",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "In-Vitro Fertilization  –  Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 9,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "In-Vitro Fertilization",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "In-Vitro Fertilization  –  Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "AmountRange":                         {
                           "High": "2000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "Per Admission Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Maternity - Inpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Maternity - Inpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Newborn Care",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Pre & Post Natal Care",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "100",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 3,
               "AliasName": "Maternity"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Durable Medical Equipment",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "Jurisdiction": "MD",
                           "TierCopayAmount": "0",
                           "MandateName": "Hearing Aids for Minor Children",
                           "TierCoinsuranceAmount": "100",
                           "MandateInd": "Yes",
                           "TierAgeFrom": "0",
                           "TierAgeType": "Years",
                           "DeductibleApplies": "No",
                           "TierAgeTo": "18",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hearing Aids for Minor Children",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 4,
               "AliasName": "Medical Devices and Supplies"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Allergy Injections",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Allergy Testing",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "AmountRange":                         {
                           "High": "2000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "Per Admission Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hospital - Inpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hospital - Inpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hospital - Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 7,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Professional Physician Visit - Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 6,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Professional Physician Visit - Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 5,
               "AliasName": "Medical Services"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "AmountRange":                         {
                           "High": "2000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Per Admission Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Inpatient  Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "PCPCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Inpatient  Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Office"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Office",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility Practitioner"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Mental Health/Substance Abuse  - Outpatient Facility Practitioner",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 6,
               "AliasName": "Mental Health/Substance Abuse"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "General Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Ambulance",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "1000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Hospice",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "Outpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Hospice -  Outpatient Facility",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "2000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "AmountRange":                         {
                           "High": "2000",
                           "Low": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "50"
                        },
                        "SpecialistCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "PCPCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType": [                        {
                           "TierCopayAmount": "0",
                           "TierCoinsuranceAmount": "80",
                           "MandateInd": "No",
                           "DeductibleApplies": "Yes",
                           "AliasName": "Per Admission Copay",
                           "IsCovered": true
                        }],
                        "PlaceOfService": "Inpatient",
                        "ProviderType": "Facility"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Skilled Nursing",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 7,
               "AliasName": "Other Medical Care"
            },
                        {
               "Benefit":                [
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 1,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "18",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "Yes",
                              "TierAgeTo": "999",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "18",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "Yes",
                              "TierAgeTo": "999",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Adult Routine  - Physical Exam",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 2,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Colorectal Cancer Screening",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine Colorectal Cancer Screening",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 3,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine GYN Physical Exam",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 4,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Breast Cancer Mammography Screening",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine Mammography",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 5,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine Pap Smear - Screening Lab",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 6,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "VA",
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "No",
                              "TierAgeFrom": "40",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "999",
                              "AliasName": "General Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Prostate Cancer Screening",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "40",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "No",
                              "TierAgeTo": "75",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "100",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "No",
                              "AliasName": "General Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Routine Prostate Cancer Screening",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 7,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "No",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Child Wellness Services",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Child Wellness Services",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Well Child Routine - Immunizations",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  },
                                    {
                     "CopayRange":                      {
                        "PerAdmissionCopay":                         {
                           "High": "NA",
                           "Low": "NA",
                           "Amount": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "AmountRange":                         {
                           "High": "NA",
                           "Low": "NA",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "NA"
                        },
                        "SpecialistCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        },
                        "PCPCopay":                         {
                           "High": "1000",
                           "Low": "0",
                           "Amount": "0",
                           "InvalidIncrements": "NA",
                           "AdditionalIncrements": "NA",
                           "Increment": "5"
                        }
                     },
                     "BRFSequence": 8,
                     "VariationCondition": [                     {
                        "CopayType":                         [
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Child Wellness Services",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "Yes",
                              "TierAgeTo": "17",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "MD",
                              "TierCopayAmount": "0",
                              "MandateName": "Child Wellness Services",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "Yes",
                              "TierAgeTo": "17",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "Yes",
                              "TierAgeTo": "17",
                              "AliasName": "Specialist Copay",
                              "IsCovered": true
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "DeductibleApplies": "Yes",
                              "AliasName": "PCP Copay",
                              "IsCovered": false
                           },
                                                      {
                              "TierCopayAmount": "0",
                              "TierCoinsuranceAmount": "80",
                              "DeductibleApplies": "Yes",
                              "AliasName": "Specialist Copay",
                              "IsCovered": false
                           },
                                                      {
                              "Jurisdiction": "Federal",
                              "TierCopayAmount": "0",
                              "MandateName": "Patient Protection and Affordable Care Act (PPACA)",
                              "TierCoinsuranceAmount": "80",
                              "MandateInd": "Yes",
                              "TierAgeFrom": "0",
                              "TierAgeType": "Years",
                              "DeductibleApplies": "Yes",
                              "TierAgeTo": "17",
                              "AliasName": "PCP Copay",
                              "IsCovered": true
                           }
                        ],
                        "PlaceOfService": "General",
                        "ProviderType": "General"
                     }],
                     "ASOFlag": "No",
                     "AliasName": "Well Child Routine - Physical Exam",
                     "CoinsuranceRange":                      {
                        "High": "100",
                        "Low": "50",
                        "Amount": "80",
                        "InvalidIncrements": "NA",
                        "AdditionalIncrements": "NA",
                        "Increment": "5"
                     }
                  }
               ],
               "BRFSequence": 8,
               "AliasName": "Preventive Services"
            }
         ]
      }
   ],
   "GenReferralDescription": "General Referrals Covered",
   "DeductibleAccumulatorMethod": "Stacked",
   "ApplyDeductibleToOOP": "Yes",
   "EffDate": "1940-01-01",
   "Option": "Option 1",
   "CFPlanName": "BluePreferred PPO",
   "ReferralSpec": "Yes",
   "PrescriptionCovrdArrngmnt": "Covered under Drug Program",
   "IntegratedDedIndicator": "Yes",
   "ProductStatus": "Active",
   "Jurisdiction": "MD",
   "ProductLine": "PPO",
   "PlanType": "Standard",
   "PriorCarrierDedCred": "No",
   "ApplyCopayToOOP": "Yes",
   "BenefitPeriodMaximum": "No",
   "FamilyDedCalculation": "Aggregate 2x",
   "ProductCategory": "Medical",
   "GenReferral": "Yes",
   "ParentProductName": "Blue Preferred Option 1 (Maryland)",
   "IntegratedOOPIndicator": "Yes",
   "ApplyPerAdmissionCopayToOOP": "Yes",
   "ApplyCoinsuranceToOOP": "Yes",
   "OOPAccumulatorMethod": "Stacked",
   "FamilyOOPCalculation": "Aggregate 2x"
}