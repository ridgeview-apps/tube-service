let journeyByBoatJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-02-27T10:35:00",
    "duration": 12,
    "arrivalDateTime": "2024-02-27T10:47:00",
    "description": "Scenario1 Intermodal",
    "alternativeRoute": false,
    "legs": [
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 12,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Boat RB6 to Chelsea Harbour Pier",
                "detailed": "Boat RB6 towards Putney Pier",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T10:35:00",
            "arrivalTime": "2024-02-27T10:47:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "930GBSP",
                "platformName": "",
                "stopLetter": "->W",
                "icsCode": "1002015",
                "individualStopId": "9300BSP2",
                "commonName": "Battersea Power Station Pier",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.48392565794,
                "lon": -0.14572447444
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "930GCHP",
                "platformName": "",
                "stopLetter": "->W",
                "icsCode": "1002022",
                "individualStopId": "9300CHP2",
                "commonName": "Chelsea Harbour Pier",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.47442828349,
                "lon": -0.17950264911
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.48393776156, -0.14572533374],[51.48391041556, -0.14589792598],[51.48474550431, -0.14695868357],[51.48442677650, -0.15126367647],[51.48296714921, -0.16195171765],[51.48223899706, -0.16771307361],[51.48141444110, -0.17192268426],[51.47996876912, -0.17552325409],[51.47782168375, -0.17739463047],[51.47516821370, -0.17850839368],[51.47446495573, -0.17957244245]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "930GCHP",
                        "name": "Chelsea Harbour Pier",
                        "uri": "/StopPoint/930GCHP",
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
                    "name": "Boat RB6",
                    "directions": [
                        "Putney Pier"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "rb6",
                        "name": "RB6",
                        "uri": "/Line/rb6",
                        "type": "Line",
                        "crowding": {
                            "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
                        },
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    "direction": "Inbound"
                }
            ],
            "mode": {
                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                "id": "river-bus",
                "name": "river-bus",
                "type": "Mode",
                "routeType": "Unknown",
                "status": "Unknown",
                "motType": "10",
                "network": "tfl"
            },
            "disruptions": [],
            "plannedWorks": [],
            "isDisrupted": false,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-27T10:35:00",
            "scheduledArrivalTime": "2024-02-27T10:47:00"
        }
    ]
}
"""#
