let lineStatusDisruptedJSON = """
{
   "$type":"Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
   "id":"london-overground",
   "name":"London Overground",
   "modeName":"overground",
   "disruptions":[
      
   ],
   "created":"2023-10-10T15:08:36.863Z",
   "modified":"2023-10-10T15:08:36.863Z",
   "lineStatuses":[
      {
         "$type":"Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
         "id":0,
         "lineId":"london-overground",
         "statusSeverity":5,
         "statusSeverityDescription":"Part Closure",
         "reason":"LONDON OVERGROUND: Sunday 15 October, until 1015, no service between Liverpool Street and Chingford. Use local London Buses and London Underground connections. Replacement buses operate between Hackney Downs and Chingford.",
         "created":"0001-01-01T00:00:00",
         "validityPeriods":[
            {
               "$type":"Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
               "fromDate":"2023-10-15T03:30:00Z",
               "toDate":"2023-10-15T09:15:00Z",
               "isNow":false
            }
         ],
         "disruption":{
            "$type":"Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
            "category":"PlannedWork",
            "categoryDescription":"PlannedWork",
            "description":"LONDON OVERGROUND: Sunday 15 October, until 1015, no service between Liverpool Street and Chingford. Use local London Buses and London Underground connections. Replacement buses operate between Hackney Downs and Chingford.",
            "additionalInfo":"Replacement buses operateService L3: Hackney Downs - Clapton - St James Street - Walthamstow Central - Wood Street - Highams Park - Chingford.",
            "created":"2023-09-08T16:03:00Z",
            "affectedRoutes":[
               
            ],
            "affectedStops":[
               
            ],
            "closureText":"partClosure"
         }
      },
      {
         "$type":"Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
         "id":0,
         "lineId":"london-overground",
         "statusSeverity":5,
         "statusSeverityDescription":"Part Closure",
         "reason":"LONDON OVERGROUND: Sunday 15 October, until 1015, no service between Liverpool Street and Enfield Town / Cheshunt. Use local London Buses and London Underground connections between Liverpool Street and Seven Sisters. Replacement buses operate between Seven Sisters and Enfield Town / Cheshunt.",
         "created":"0001-01-01T00:00:00",
         "validityPeriods":[
            {
               "$type":"Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
               "fromDate":"2023-10-15T03:30:00Z",
               "toDate":"2023-10-15T09:15:00Z",
               "isNow":false
            }
         ],
         "disruption":{
            "$type":"Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
            "category":"PlannedWork",
            "categoryDescription":"PlannedWork",
            "description":"LONDON OVERGROUND: Sunday 15 October, until 1015, no service between Liverpool Street and Enfield Town / Cheshunt. Use local London Buses and London Underground connections between Liverpool Street and Seven Sisters. Replacement buses operate between Seven Sisters and Enfield Town / Cheshunt.",
            "additionalInfo":"Replacement buses operateService L1: Seven Sisters - Bruce Grove - White Hart Lane - Silver Street - Edmonton Green - Bush Hill Park (Great Cambridge Road) - Enfield Town;Service L2: Seven Sisters - Bruce Grove - White Hart Lane - Silver Street - Edmonton Green - Bush Hill Park (Great Cambridge Road) - Southbury - Turkey Street - Theobalds Grove - Cheshunt",
            "created":"2023-09-08T16:05:00Z",
            "affectedRoutes":[
               
            ],
            "affectedStops":[
               
            ],
            "closureText":"partClosure"
         }
      }
   ],
   "routeSections":[
      
   ],
   "serviceTypes":[
      {
         "$type":"Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
         "name":"Regular",
         "uri":"/Line/Route?ids=London Overground&serviceTypes=Regular"
      },
      {
         "$type":"Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
         "name":"Night",
         "uri":"/Line/Route?ids=London Overground&serviceTypes=Night"
      }
   ],
   "crowding":{
      "$type":"Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
   }
}
"""
