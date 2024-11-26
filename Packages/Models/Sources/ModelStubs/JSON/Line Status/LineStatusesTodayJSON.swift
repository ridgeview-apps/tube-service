let lineStatusesTodayJSON = """
[
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "bakerloo",
    "name": "Bakerloo",
    "modeName": "tube",
    "disruptions": [],
    "created": "2024-11-21T16:12:13.08Z",
    "modified": "2024-11-21T16:12:13.08Z",
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
    "created": "2024-11-21T16:12:13.08Z",
    "modified": "2024-11-21T16:12:13.08Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "elizabeth",
        "statusSeverity": 6,
        "statusSeverityDescription": "Severe Delays",
        "reason": "No service between Paddington and Abbey Wood while we deal with a signalling systems fault. SEVERE DELAYS on the rest of the line. London Underground are accepting their tickets via any reasonable route. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2024-11-26T15:57:37Z",
            "toDate": "2024-11-27T01:29:00Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "No service between Paddington and Abbey Wood while we deal with a signalling systems fault. SEVERE DELAYS on the rest of the line. London Underground are accepting their tickets via any reasonable route. ",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "severeDelays"
        }
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "elizabeth",
        "statusSeverity": 3,
        "statusSeverityDescription": "Part Suspended",
        "reason": "No service between Paddington and Abbey Wood while we deal with a signalling systems fault. SEVERE DELAYS on the rest of the line. London Underground are accepting their tickets via any reasonable route. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2024-11-26T15:57:37Z",
            "toDate": "2024-11-26T20:37:22Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "No service between Paddington and Abbey Wood while we deal with a signalling systems fault. SEVERE DELAYS on the rest of the line. London Underground are accepting their tickets via any reasonable route. ",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "partSuspended"
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
    "created": "2024-11-21T16:12:13.08Z",
    "modified": "2024-11-21T16:12:13.08Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "jubilee",
        "statusSeverity": 9,
        "statusSeverityDescription": "Minor Delays",
        "reason": "Jubilee Line: Minor delays due to train cancellations. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2024-11-26T16:51:20Z",
            "toDate": "2024-11-27T01:29:00Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "Jubilee Line: Minor delays due to train cancellations. ",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "minorDelays"
        }
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
    "id": "liberty",
    "name": "Liberty",
    "modeName": "overground",
    "disruptions": [],
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
        "uri": "/Line/Route?ids=Liberty&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "lioness",
    "name": "Lioness",
    "modeName": "overground",
    "disruptions": [],
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
        "uri": "/Line/Route?ids=Lioness&serviceTypes=Regular"
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
    "id": "mildmay",
    "name": "Mildmay",
    "modeName": "overground",
    "disruptions": [],
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
        "uri": "/Line/Route?ids=Mildmay&serviceTypes=Regular"
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
    "created": "2024-11-21T16:12:13.08Z",
    "modified": "2024-11-21T16:12:13.08Z",
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
    "id": "suffragette",
    "name": "Suffragette",
    "modeName": "overground",
    "disruptions": [],
    "created": "2024-11-21T16:12:13.08Z",
    "modified": "2024-11-21T16:12:13.08Z",
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
        "uri": "/Line/Route?ids=Suffragette&serviceTypes=Regular"
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
    "created": "2024-11-21T16:12:13.08Z",
    "modified": "2024-11-21T16:12:13.08Z",
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
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
        "uri": "/Line/Route?ids=Waterloo & City&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "weaver",
    "name": "Weaver",
    "modeName": "overground",
    "disruptions": [],
    "created": "2024-11-21T16:12:13.093Z",
    "modified": "2024-11-21T16:12:13.093Z",
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
        "uri": "/Line/Route?ids=Weaver&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  },
  {
    "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
    "id": "windrush",
    "name": "Windrush",
    "modeName": "overground",
    "disruptions": [],
    "created": "2024-11-21T16:12:13.08Z",
    "modified": "2024-11-21T16:12:13.08Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "windrush",
        "statusSeverity": 9,
        "statusSeverityDescription": "Minor Delays",
        "reason": "London Overground: Minor delays between Sydenham and West Croydon while Network Rail  fix a signal failure at Norwood Junction. GOOD SERVICE on all other routes. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2024-11-26T17:21:24Z",
            "toDate": "2024-11-27T01:29:00Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "London Overground: Minor delays between Sydenham and West Croydon while Network Rail  fix a signal failure at Norwood Junction. GOOD SERVICE on all other routes. ",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "minorDelays"
        }
      }
    ],
    "routeSections": [],
    "serviceTypes": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Regular",
        "uri": "/Line/Route?ids=Windrush&serviceTypes=Regular"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineServiceTypeInfo, Tfl.Api.Presentation.Entities",
        "name": "Night",
        "uri": "/Line/Route?ids=Windrush&serviceTypes=Night"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  }
]
"""
