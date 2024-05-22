let lineStatusesTodayJSON = """
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
    "created": "2023-10-10T15:08:36.863Z",
    "modified": "2023-10-10T15:08:36.863Z",
    "lineStatuses": [
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "elizabeth",
        "statusSeverity": 6,
        "statusSeverityDescription": "Severe Delays",
        "reason": "Severe delays between Abbey Wood and Reading / Heathrow Terminals due to a signal failure at Acton Main Line. MINOR DELAYS on the rest of the line. London Underground, London Buses, DLR, Great Western Railway, Southeastern and Thameslink are accepting tickets. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-17T10:06:39Z",
            "toDate": "2023-10-18T00:29:00Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "Severe delays between Abbey Wood and Reading / Heathrow Terminals due to a signal failure at Acton Main Line. MINOR DELAYS on the rest of the line. London Underground, London Buses, DLR, Great Western Railway, Southeastern and Thameslink are accepting tickets. ",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "severeDelays"
        }
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "elizabeth",
        "statusSeverity": 9,
        "statusSeverityDescription": "Minor Delays",
        "reason": "Severe delays between Abbey Wood and Reading / Heathrow Terminals due to a signal failure at Acton Main Line. MINOR DELAYS on the rest of the line. London Underground, London Buses, DLR, Great Western Railway, Southeastern and Thameslink are accepting tickets. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-17T10:06:39Z",
            "toDate": "2023-10-18T00:29:00Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "Severe delays between Abbey Wood and Reading / Heathrow Terminals due to a signal failure at Acton Main Line. MINOR DELAYS on the rest of the line. London Underground, London Buses, DLR, Great Western Railway, Southeastern and Thameslink are accepting tickets. ",
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
        "statusSeverity": 6,
        "statusSeverityDescription": "Severe Delays",
        "reason": "London Overground: No service between Watford Junction and Willesden Junction while we fix a faulty train at Harrow & Wealdstone. SEVERE DELAYS between Willesden Junction and Euston. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-17T11:19:47Z",
            "toDate": "2023-10-18T00:29:00Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "London Overground: No service between Watford Junction and Willesden Junction while we fix a faulty train at Harrow & Wealdstone. SEVERE DELAYS between Willesden Junction and Euston. ",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "severeDelays"
        }
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "london-overground",
        "statusSeverity": 3,
        "statusSeverityDescription": "Part Suspended",
        "reason": "London Overground: No service between Watford Junction and Willesden Junction while we fix a faulty train at Harrow & Wealdstone. SEVERE DELAYS between Willesden Junction and Euston. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-17T11:19:47Z",
            "toDate": "2023-10-17T14:40:20Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "London Overground: No service between Watford Junction and Willesden Junction while we fix a faulty train at Harrow & Wealdstone. SEVERE DELAYS between Willesden Junction and Euston. ",
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
        "lineId": "piccadilly",
        "statusSeverity": 6,
        "statusSeverityDescription": "Severe Delays",
        "reason": "Piccadilly Line: No service between Arnos Grove and Cockfosters to a signal failure at Finsbury Park. SEVERE DELAYS between Arnos Grove and Acton Town. London Buses, Great Northern, London Overground and South Western Railway are accepting tickets. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-17T11:32:15Z",
            "toDate": "2023-10-18T00:29:00Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "Piccadilly Line: No service between Arnos Grove and Cockfosters to a signal failure at Finsbury Park. SEVERE DELAYS between Arnos Grove and Acton Town. London Buses, Great Northern, London Overground and South Western Railway are accepting tickets. ",
          "affectedRoutes": [],
          "affectedStops": [],
          "closureText": "severeDelays"
        }
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
        "id": 0,
        "lineId": "piccadilly",
        "statusSeverity": 3,
        "statusSeverityDescription": "Part Suspended",
        "reason": "Piccadilly Line: No service between Arnos Grove and Cockfosters to a signal failure at Finsbury Park. SEVERE DELAYS between Arnos Grove and Acton Town. London Buses, Great Northern, London Overground and South Western Railway are accepting tickets. ",
        "created": "0001-01-01T00:00:00",
        "validityPeriods": [
          {
            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
            "fromDate": "2023-10-17T11:32:15Z",
            "toDate": "2023-10-17T14:40:20Z",
            "isNow": true
          }
        ],
        "disruption": {
          "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
          "category": "RealTime",
          "categoryDescription": "RealTime",
          "description": "Piccadilly Line: No service between Arnos Grove and Cockfosters to a signal failure at Finsbury Park. SEVERE DELAYS between Arnos Grove and Acton Town. London Buses, Great Northern, London Overground and South Western Railway are accepting tickets. ",
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
  }
]
"""
