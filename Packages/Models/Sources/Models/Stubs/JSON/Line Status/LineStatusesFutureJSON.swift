let lineStatusesFutureJSON = """
[
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "bakerloo",
    "name": "Bakerloo",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Bakerloo&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "central",
    "name": "Central",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Central&serviceTypes=Regular"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Night",
        "uri": "/Line/Route?ids=Central&serviceTypes=Night"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "circle",
    "name": "Circle",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Circle&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "district",
    "name": "District",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=District&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "dlr",
    "name": "DLR",
    "modeName": "dlr",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "dlr",
        "statusSeverity": 5,
        "statusSeverityDescription": "Part Closure",
        "reason": "DOCKLANDS LIGHT RAILWAY: Sunday 22 October, no service between Poplar / Stratford International and Beckton / Woolwich Arsenal. Use Jubilee line between Stratford, West Ham and Canning Town. Replacement buses operate.",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-22T03:30:00Z",
            "toDate": "2023-10-23T00:29:00Z",
            "isNow": false
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "PlannedWork",
          "categoryDescription": "PlannedWork",
          "description": "DOCKLANDS LIGHT RAILWAY: Sunday 22 October, no service between Poplar / Stratford International and Beckton / Woolwich Arsenal. Use Jubilee line between Stratford, West Ham and Canning Town. Replacement buses operate.",
          "created": "2023-09-08T16:33:00Z",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "partClosure"
        }
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=DLR&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "elizabeth",
    "name": "Elizabeth line",
    "modeName": "elizabeth-line",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "elizabeth",
        "statusSeverity": 7,
        "statusSeverityDescription": "Reduced Service",
        "reason": "ELIZABETH LINE: Sunday 22 October, before 1000 and after 2200, only one train per hour will call at Burnham, Taplow, Twyford and Reading. Some trains terminate and start at Maidenhead instead of Reading. From 1000 until 2200, only two trains per hour will call at Burnham.",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-22T03:30:00Z",
            "toDate": "2023-10-23T00:29:00Z",
            "isNow": false
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "PlannedWork",
          "categoryDescription": "PlannedWork",
          "description": "ELIZABETH LINE: Sunday 22 October, before 1000 and after 2200, only one train per hour will call at Burnham, Taplow, Twyford and Reading. Some trains terminate and start at Maidenhead instead of Reading. From 1000 until 2200, only two trains per hour will call at Burnham.",
          "created": "2023-09-08T16:11:00Z",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "reducedService"
        }
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Elizabeth line&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "hammersmith-city",
    "name": "Hammersmith & City",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.877Z",
    "modified": "2023-10-10T15:08:36.877Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Hammersmith & City&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "jubilee",
    "name": "Jubilee",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Jubilee&serviceTypes=Regular"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Night",
        "uri": "/Line/Route?ids=Jubilee&serviceTypes=Night"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "london-overground",
    "name": "London Overground",
    "modeName": "overground",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "london-overground",
        "statusSeverity": 5,
        "statusSeverityDescription": "Part Closure",
        "reason": "LONDON OVERGROUND: Sunday 22 October, no service between Sydenham and Crystal Palace. Please use local London Buses connections between Anerley and Crystal Palace",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-22T03:30:00Z",
            "toDate": "2023-10-23T00:29:00Z",
            "isNow": false
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "PlannedWork",
          "categoryDescription": "PlannedWork",
          "description": "LONDON OVERGROUND: Sunday 22 October, no service between Sydenham and Crystal Palace. Please use local London Buses connections between Anerley and Crystal Palace",
          "created": "2023-09-08T16:29:00Z",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "partClosure"
        }
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "london-overground",
        "statusSeverity": 5,
        "statusSeverityDescription": "Part Closure",
        "reason": "LONDON OVERGROUND: Sunday 22 October, no service between Richmond and Willesden Junction. Use District line services between Richmond, Kew Gardens and Gunnersbury. Replacement bus service R operates between Gunnersbury, South Acton (Acton Lane), Acton Central and Willesden Junction.",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-22T03:30:00Z",
            "toDate": "2023-10-23T00:29:00Z",
            "isNow": false
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "PlannedWork",
          "categoryDescription": "PlannedWork",
          "description": "LONDON OVERGROUND: Sunday 22 October, no service between Richmond and Willesden Junction. Use District line services between Richmond, Kew Gardens and Gunnersbury. Replacement bus service R operates between Gunnersbury, South Acton (Acton Lane), Acton Central and Willesden Junction.",
          "created": "2023-09-08T16:30:00Z",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "partClosure"
        }
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=London Overground&serviceTypes=Regular"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Night",
        "uri": "/Line/Route?ids=London Overground&serviceTypes=Night"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "metropolitan",
    "name": "Metropolitan",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.877Z",
    "modified": "2023-10-10T15:08:36.877Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Metropolitan&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "northern",
    "name": "Northern",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Northern&serviceTypes=Regular"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Night",
        "uri": "/Line/Route?ids=Northern&serviceTypes=Night"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "piccadilly",
    "name": "Piccadilly",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Piccadilly&serviceTypes=Regular"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Night",
        "uri": "/Line/Route?ids=Piccadilly&serviceTypes=Night"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "tram",
    "name": "Tram",
    "modeName": "tram",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.847Z",
    "modified": "2023-10-10T15:08:36.847Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "tram",
        "statusSeverity": 5,
        "statusSeverityDescription": "Part Closure",
        "reason": "LONDON TRAMS: Saturday 21 to Sunday 29 October, no service between East Croydon and Beckenham Junction / Elmers End / New Addington. Replacement buses operate.",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-21T03:30:00Z",
            "toDate": "2023-10-30T01:29:00Z",
            "isNow": false
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "PlannedWork",
          "categoryDescription": "PlannedWork",
          "description": "LONDON TRAMS: Saturday 21 to Sunday 29 October, no service between East Croydon and Beckenham Junction / Elmers End / New Addington. Replacement buses operate.",
          "created": "2023-09-08T16:36:00Z",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "partClosure"
        }
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Tram&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "victoria",
    "name": "Victoria",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.877Z",
    "modified": "2023-10-10T15:08:36.877Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "statusSeverity": 10,
        "statusSeverityDescription": "Good Service",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": []
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Victoria&serviceTypes=Regular"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Night",
        "uri": "/Line/Route?ids=Victoria&serviceTypes=Night"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "waterloo-city",
    "name": "Waterloo & City",
    "modeName": "tube",
    "disruptions": [],
    "created": "2023-10-10T15:08:36.847Z",
    "modified": "2023-10-10T15:08:36.847Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "waterloo-city",
        "statusSeverity": 4,
        "statusSeverityDescription": "Planned Closure",
        "reason": "Waterloo & City line: Service operates Monday to Friday between 06:00 and 00:30 only. There is no service on Saturdays, Sundays and on public/bank holidays.",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-20T23:30:00Z",
            "toDate": "2023-10-21T22:59:00Z",
            "isNow": false
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-21T23:00:00Z",
            "toDate": "2023-10-22T22:59:00Z",
            "isNow": false
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-22T23:00:00Z",
            "toDate": "2023-10-22T23:45:00Z",
            "isNow": false
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "PlannedWork",
          "categoryDescription": "PlannedWork",
          "description": "Waterloo & City line: Service operates Monday to Friday between 06:00 and 00:30 only. There is no service on Saturdays, Sundays and on public/bank holidays.",
          "created": "2023-01-16T05:24:00Z",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "plannedClosure"
        }
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Waterloo & City&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  }
]
"""
