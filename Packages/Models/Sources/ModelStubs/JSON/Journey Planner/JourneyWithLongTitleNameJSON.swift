let journeyWithLongTitleNameJSON = #"""
{
  "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
  "startDateTime": "2024-04-01T16:41:00",
  "duration": 6,
  "arrivalDateTime": "2024-04-01T16:47:00",
  "alternativeRoute": false,
  "legs": [
    {
      "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
      "duration": 6,
      "instruction": {
        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
        "summary": "23 bus to Charing Cross",
        "detailed": "23 bus towards Aldwych / Drury Lane",
        "steps": []
      },
      "obstacles": [],
      "departureTime": "2024-04-01T16:41:00",
      "arrivalTime": "2024-04-01T16:47:00",
      "departurePoint": {
        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
        "naptanId": "940GZZLUPCC",
        "platformName": "B",
        "stopLetter": "B",
        "icsCode": "1000179",
        "individualStopId": "490000179B",
        "commonName": "Piccadilly Circus Underground Station (deliberately making this a very long title so that it flows over 3 lines on most devices)",
        "placeType": "StopPoint",
        "additionalProperties": [],
        "lat": 51.50930502061,
        "lon": -0.13623507476
      },
      "arrivalPoint": {
        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
        "naptanId": "490G00045",
        "platformName": "",
        "stopLetter": "E",
        "icsCode": "1000045",
        "individualStopId": "490013766E",
        "commonName": "Charing Cross Stn / Trafalgar Square (deliberately making this a very long title so that it flows over 3 lines on most devices)",
        "placeType": "StopPoint",
        "additionalProperties": [],
        "lat": 51.50804363504,
        "lon": -0.12648747087999998
      },
      "path": {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
        "lineString": "[[51.50925646192, -0.13619121309],[51.50937073442, -0.13584330083],[51.50941406550, -0.13574065628],[51.50945648076, -0.13558040552],[51.50967244705, -0.13502397393],[51.50974044719, -0.13477621104],[51.50984943251, -0.13484381468],[51.50995635656, -0.13478180374],[51.51011422295, -0.13453036805],[51.51002394971, -0.13394320332],[51.51009612129, -0.13339263426],[51.50993876342, -0.13311084585],[51.50974660455, -0.13290253694],[51.50968232224, -0.13281869947],[51.50965466295, -0.13279159671],[51.50965466295, -0.13279159671],[51.50952702672, -0.13266652909],[51.50924362445, -0.13237549031],[51.50883394941, -0.13206079834],[51.50846874807, -0.13171547155],[51.50808626076, -0.13141408870],[51.50769432707, -0.13108427675],[51.50763447380, -0.13015005761],[51.50761420444, -0.13000678468],[51.50757228728, -0.12963383406],[51.50756480793, -0.12956149387],[51.50756480793, -0.12956149387],[51.50750849042, -0.12901680612],[51.50748730066, -0.12881593082],[51.50750251674, -0.12864238449],[51.50750391970, -0.12816678892],[51.50751591660, -0.12779163074],[51.50753274046, -0.12771888982],[51.50754057762, -0.12764651725],[51.50755671164, -0.12753057372],[51.50772124951, -0.12713474945],[51.50784315284, -0.12688477452],[51.50801736525, -0.12653177974],[51.50804076911, -0.12648393710]]",
        "stopPoints": [
          {
            "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
            "id": "490G00020307",
            "name": "Haymarket / Jermyn Street",
            "uri": "/StopPoint/490G00020307",
            "type": "StopPoint",
            "routeType": "Unknown",
            "status": "Unknown"
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
            "id": "490G000804",
            "name": "Northumberland Avenue / Trafalgar Square",
            "uri": "/StopPoint/490G000804",
            "type": "StopPoint",
            "routeType": "Unknown",
            "status": "Unknown"
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
            "id": "490G00045",
            "name": "Charing Cross Stn / Trafalgar Square",
            "uri": "/StopPoint/490G00045",
            "type": "StopPoint",
            "routeType": "Unknown",
            "status": "Unknown"
          }
        ],
        "elevation": []
      },
      "routeOptions": [
        {
          "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.RouteOption, Tfl.Api.Presentation.Entities",
          "name": "23",
          "directions": [
            "Aldwych / Drury Lane"
          ],
          "lineIdentifier": {
            "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
            "id": "23",
            "name": "23",
            "uri": "/Line/23",
            "type": "Line",
            "crowding": {
              "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
            },
            "routeType": "Unknown",
            "status": "Unknown"
          },
          "direction": "Outbound"
        }
      ],
      "mode": {
        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
        "id": "bus",
        "name": "bus",
        "type": "Mode",
        "routeType": "Unknown",
        "status": "Unknown",
        "motType": "3",
        "network": "tfl"
      },
      "disruptions": [],
      "plannedWorks": [],
      "isDisrupted": false,
      "hasFixedLocations": true,
      "scheduledDepartureTime": "2024-04-01T16:47:00",
      "scheduledArrivalTime": "2024-04-01T16:53:00"
    }
  ]
}
"""#
