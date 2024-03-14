let journeyByOvergroundJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-02-27T10:23:00",
    "duration": 3,
    "arrivalDateTime": "2024-02-27T10:26:00",
    "description": "Scenario1 Intermodal",
    "alternativeRoute": false,
    "legs": [
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 3,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "London Overground to Camden Road Rail Station",
                "detailed": "London Overground towards Richmond",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T10:23:00",
            "arrivalTime": "2024-02-27T10:26:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "910GCLDNNRB",
                "platformName": "",
                "icsCode": "1001043",
                "individualStopId": "9100CLDNNRB1",
                "commonName": "Caledonian Road & Barnsbury Rail Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.543443413060004,
                "lon": -0.11558766872
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "910GCMDNRD",
                "platformName": "",
                "icsCode": "1001045",
                "individualStopId": "9100CMDNRD1",
                "commonName": "Camden Road Rail Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.5417779743,
                "lon": -0.13913398527
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.54335085150, -0.11553259493],[51.54273662757, -0.11805408434],[51.54155170666, -0.12267443317],[51.54107726934, -0.12505897979],[51.54092264263, -0.12607479196],[51.54083344392, -0.12724653941],[51.54084446551, -0.12850069499],[51.54107794653, -0.13186559551],[51.54175664072, -0.13835611881],[51.54183985418, -0.13913167479]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "910GCMDNRD",
                        "name": "Camden Road Rail Station",
                        "uri": "/StopPoint/910GCMDNRD",
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
                    "name": "London Overground",
                    "directions": [
                        "Richmond Rail Station"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "london-overground",
                        "name": "London Overground",
                        "uri": "/Line/london-overground",
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
                "id": "overground",
                "name": "overground",
                "type": "Mode",
                "routeType": "Unknown",
                "status": "Unknown",
                "motType": "7",
                "network": "nrc"
            },
            "disruptions": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                    "category": "RealTime",
                    "type": "stopInfo",
                    "categoryDescription": "RealTime",
                    "description": "Caledonian Road & Barnsbury: No Step Free Access - The lifts will be out of order between Platform 1,2 & 3 and Concourse/exit from now until further notice at Caledonian Rd & Barnsbury station.",
                    "summary": "",
                    "additionalInfo": "",
                    "created": "2024-02-27T00:30:00",
                    "lastUpdate": "2024-02-27T00:30:00"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                    "category": "RealTime",
                    "type": "stopInfo",
                    "categoryDescription": "RealTime",
                    "description": "Caledonian Road & Barnsbury: No Step Free Access - The lifts will be out of order between Platform 1,2 & 3 and Concourse/exit from now until further notice at Caledonian Rd & Barnsbury station.",
                    "summary": "",
                    "additionalInfo": "",
                    "created": "2024-02-27T00:03:00",
                    "lastUpdate": "2024-02-27T00:03:00"
                }
            ],
            "plannedWorks": [],
            "isDisrupted": true,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-27T10:23:00",
            "scheduledArrivalTime": "2024-02-27T10:26:00"
        }
    ],
    "fare": {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.JourneyFare, Tfl.Api.Presentation.Entities",
        "totalCost": 180,
        "fares": [
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Fare, Tfl.Api.Presentation.Entities",
                "lowZone": 2,
                "highZone": 2,
                "cost": 180,
                "chargeProfileName": "Standard peak/off peak",
                "isHopperFare": false,
                "chargeLevel": "Off Peak",
                "peak": 190,
                "offPeak": 180,
                "taps": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                        "atcoCode": "910GCLDNNRB",
                        "tapDetails": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                            "modeType": "Rail",
                            "validationType": "None",
                            "hostDeviceType": "Gate",
                            "nationalLocationCode": 1439,
                            "tapTimestamp": "2024-02-27T10:23:00+00:00"
                        }
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                        "atcoCode": "910GCMDNRD",
                        "tapDetails": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                            "modeType": "Rail",
                            "validationType": "None",
                            "hostDeviceType": "Gate",
                            "nationalLocationCode": 1440,
                            "tapTimestamp": "2024-02-27T10:26:00+00:00"
                        }
                    }
                ]
            }
        ],
        "caveats": [
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareCaveat, Tfl.Api.Presentation.Entities",
                "text": "<p>Fares between two stations may vary depending on the direction of travel, time of day and day of the week.</p><p>We charge higher fares at the busiest times of the day (usually between 06:30 and 09:30, and between 16:00 and 19:00, Monday to Friday).</p><p>When you pay as you go, you must touch your contactless or Oyster card on a yellow reader at the start and end of your journey.</p><p>Some journeys are charged via Zone 1 regardless of the route taken.</p><p>If your journey avoids Zone 1 and you see a pink card reader when changing trains, touch your contactless or Oyster card on it to pay the right fare.</p>",
                "type": "allRailModes"
            },
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareCaveat, Tfl.Api.Presentation.Entities",
                "text": "The price shown is a single adult pay as you go fare.",
                "type": "generic"
            }
        ]
    }
}
"""#
