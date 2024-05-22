let lineStatusDisruptedDuplicatesJSON =
"""
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
        "lineId": "bakerloo",
        "statusSeverity": 9,
        "statusSeverityDescription": "Minor Delays",
        "reason": "Bakerloo Line: No service between Stonebridge Park and Harrow & Wealdstone while we fix a faulty train at Harrow & Wealdstone. London Buses are accepting tickets. MINOR DELAYS on the rest of the line. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-17T11:38:29Z",
            "toDate": "2023-10-18T00:29:00Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "Bakerloo Line: No service between Stonebridge Park and Harrow & Wealdstone while we fix a faulty train at Harrow & Wealdstone. London Buses are accepting tickets. MINOR DELAYS on the rest of the line. ",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "minorDelays"
        }
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "bakerloo",
        "statusSeverity": 3,
        "statusSeverityDescription": "Part Suspended",
        "reason": "Bakerloo Line: No service between Stonebridge Park and Harrow & Wealdstone while we fix a faulty train at Harrow & Wealdstone. London Buses are accepting tickets. MINOR DELAYS on the rest of the line. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-17T11:38:29Z",
            "toDate": "2023-10-17T14:40:20Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "Bakerloo Line: No service between Stonebridge Park and Harrow & Wealdstone while we fix a faulty train at Harrow & Wealdstone. London Buses are accepting tickets. MINOR DELAYS on the rest of the line. ",
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
        "uri": "/Line/Route?ids=Bakerloo&serviceTypes=Regular"
      }
    ],
    "crowding": {
      "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
    }
  }
"""
