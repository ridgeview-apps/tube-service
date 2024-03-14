let journeyByCableCarJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-02-27T10:06:00",
    "duration": 18,
    "arrivalDateTime": "2024-02-27T10:24:00",
    "description": "Scenario1 Alternative",
    "alternativeRoute": true,
    "legs": [
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 4,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Transfer to IFS Cloud Royal Docks",
                "detailed": "Transfer to IFS Cloud Royal Docks",
                "steps": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "Seagull Lane for 155 metres",
                        "turnDirection": "STRAIGHT",
                        "streetName": "Seagull Lane",
                        "distance": 155,
                        "cumulativeDistance": 155,
                        "skyDirection": 258,
                        "skyDirectionDescription": "West",
                        "cumulativeTravelTime": 141,
                        "latitude": 51.5090428775,
                        "longitude": 0.0186854159,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Continue along ",
                        "trackType": "None"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "for 85 metres",
                        "turnDirection": "STRAIGHT",
                        "streetName": "",
                        "distance": 85,
                        "cumulativeDistance": 240,
                        "skyDirection": 215,
                        "skyDirectionDescription": "SouthWest",
                        "cumulativeTravelTime": 217,
                        "latitude": 51.50818852615,
                        "longitude": 0.01712011178,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Continue along ",
                        "trackType": "None"
                    }
                ]
            },
            "obstacles": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "WALKWAY",
                    "incline": "LEVEL",
                    "stopId": 1002071,
                    "position": "IDEST"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "ESCALATOR",
                    "incline": "UP",
                    "stopId": 1020078,
                    "position": "IDEST"
                }
            ],
            "departureTime": "2024-02-27T10:06:00",
            "arrivalTime": "2024-02-27T10:10:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "platformName": "",
                "icsCode": "1002071",
                "individualStopId": "4900ZZDLRVC2",
                "commonName": "Royal Victoria",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.50907882096,
                "lon": 0.018687004769999998
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZALRDK",
                "platformName": "",
                "icsCode": "1020078",
                "individualStopId": "9400ZZALRDK1",
                "commonName": "IFS Cloud Royal Docks",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.50753188265,
                "lon": 0.01765311979
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.50903369540, 0.01869941257],[51.50902951864, 0.01868711295],[51.50893919584, 0.01791705075],[51.50862264148, 0.01749955845],[51.50818852615, 0.01712011178],[51.50804747646, 0.01695536411],[51.50788374940, 0.01706341825],[51.50786433228, 0.01772532509],[51.50786339540, 0.01772541257],[51.50752269540, 0.01766711257]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "name": "IFS Cloud Royal Docks",
                        "uri": "/StopPoint/",
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
                    "name": "",
                    "directions": [
                        ""
                    ],
                    "direction": ""
                }
            ],
            "mode": {
                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                "id": "walking",
                "name": "walking",
                "type": "Mode",
                "routeType": "Unknown",
                "status": "Unknown",
                "motType": "99",
                "network": ""
            },
            "disruptions": [],
            "plannedWorks": [],
            "isDisrupted": false,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-27T10:06:00",
            "scheduledArrivalTime": "2024-02-27T10:10:00",
            "interChangeDuration": "4",
            "interChangePosition": "IDEST"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 7,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "IFS Cloud Cable Car to IFS Cloud Greenwich Peninsula",
                "detailed": "IFS Cloud Cable Car towards IFS Cloud Greenwich Peninsula",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T10:10:00",
            "arrivalTime": "2024-02-27T10:17:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZALRDK",
                "platformName": "",
                "icsCode": "1020078",
                "individualStopId": "9400ZZALRDK1",
                "commonName": "IFS Cloud Royal Docks",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.50753188265,
                "lon": 0.01765311979
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZALGWP",
                "platformName": "",
                "icsCode": "1020079",
                "individualStopId": "9400ZZALGWP1",
                "commonName": "IFS Cloud Greenwich Peninsula",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.49987379299,
                "lon": 0.0080072253700000009
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.50752038067, 0.01767182834],[51.49986368439, 0.00802306873]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZALGWP",
                        "name": "IFS Cloud Greenwich Peninsula",
                        "uri": "/StopPoint/940GZZALGWP",
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
                    "name": "IFS Cloud Cable Car",
                    "directions": [
                        "IFS Cloud Greenwich Peninsula"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "london-cable-car",
                        "name": "IFS Cloud Cable Car",
                        "uri": "/Line/london-cable-car",
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
                "id": "cable-car",
                "name": "cable-car",
                "type": "Mode",
                "routeType": "Unknown",
                "status": "Unknown",
                "motType": "13",
                "network": "tfl"
            },
            "disruptions": [],
            "plannedWorks": [],
            "isDisrupted": false,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-27T10:10:00",
            "scheduledArrivalTime": "2024-02-27T10:17:00"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 7,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Walk to North Greenwich",
                "detailed": "Walk to North Greenwich",
                "steps": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "Edmund Halley Way for 189 metres",
                        "turnDirection": "STRAIGHT",
                        "streetName": "Edmund Halley Way",
                        "distance": 189,
                        "cumulativeDistance": 189,
                        "skyDirection": 232,
                        "skyDirectionDescription": "SouthWest",
                        "cumulativeTravelTime": 171,
                        "latitude": 51.49989349053,
                        "longitude": 0.00790723447,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Continue along ",
                        "trackType": "None"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "for 159 metres",
                        "turnDirection": "SHARP_RIGHT",
                        "streetName": "",
                        "distance": 159,
                        "cumulativeDistance": 348,
                        "skyDirection": 0,
                        "skyDirectionDescription": "North",
                        "cumulativeTravelTime": 316,
                        "latitude": 51.498960950329995,
                        "longitude": 0.00564744437,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Take a sharp right",
                        "trackType": "None"
                    }
                ]
            },
            "obstacles": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "ESCALATOR",
                    "incline": "DOWN",
                    "stopId": 1020079,
                    "position": "IDEST"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "WALKWAY",
                    "incline": "LEVEL",
                    "stopId": 1020079,
                    "position": "IDEST"
                }
            ],
            "departureTime": "2024-02-27T10:17:00",
            "arrivalTime": "2024-02-27T10:24:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZALGWP",
                "platformName": "",
                "icsCode": "1020079",
                "individualStopId": "9400ZZALGWP1",
                "commonName": "IFS Cloud Greenwich Peninsula",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.49987379299,
                "lon": 0.0080072253700000009
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "platformName": "",
                "icsCode": "1000160",
                "individualStopId": "4900ZZLUNGW1",
                "commonName": "North Greenwich",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.50026440495,
                "lon": 0.00462405606
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.49986459539, 0.00802121256],[51.49988429539, 0.00792121256],[51.49988445258, 0.00792464928],[51.49973035816, 0.00758775213],[51.49972818059, 0.00758299134],[51.49954613000, 0.00718597505],[51.49948569257, 0.00703923984],[51.49932161197, 0.00664301723],[51.49926092750, 0.00651068053],[51.49920898250, 0.00639313590],[51.49896095033, 0.00564744437],[51.49905979581, 0.00565178401],[51.49946281029, 0.00522283104],[51.49970186079, 0.00491634731],[51.49978347283, 0.00487670494],[51.49991075305, 0.00479584235],[51.50013869938, 0.00442779672],[51.50014179539, 0.00443141256]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "name": "North Greenwich",
                        "uri": "/StopPoint/",
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
                    "name": "",
                    "directions": [
                        ""
                    ],
                    "direction": ""
                }
            ],
            "mode": {
                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                "id": "walking",
                "name": "walking",
                "type": "Mode",
                "routeType": "Unknown",
                "status": "Unknown",
                "motType": "99",
                "network": ""
            },
            "disruptions": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                    "category": "RealTime",
                    "type": "stopInfo",
                    "categoryDescription": "RealTime",
                    "description": "North Greenwich: No Step Free Access - Step free access is not available to the westbound platform due to a faulty lift. Call us on 0343 222 1234 if you need help planning your journey.",
                    "summary": "",
                    "additionalInfo": "",
                    "created": "2024-02-27T08:33:00",
                    "lastUpdate": "2024-02-27T08:33:00"
                }
            ],
            "plannedWorks": [],
            "isDisrupted": true,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-27T10:17:00",
            "scheduledArrivalTime": "2024-02-27T10:24:00",
            "interChangeDuration": "7",
            "interChangePosition": "IDEST"
        }
    ],
    "fare": {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.JourneyFare, Tfl.Api.Presentation.Entities",
        "totalCost": 600,
        "fares": [
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Fare, Tfl.Api.Presentation.Entities",
                "lowZone": 0,
                "highZone": 0,
                "cost": 600,
                "chargeProfileName": "Standard peak/off peak",
                "isHopperFare": false,
                "chargeLevel": "Off Peak",
                "peak": 600,
                "offPeak": 600,
                "taps": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                        "atcoCode": "940GZZALRDK",
                        "tapDetails": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                            "modeType": "Cablecar",
                            "validationType": "None",
                            "hostDeviceType": "Gate",
                            "nationalLocationCode": 910,
                            "tapTimestamp": "2024-02-27T10:10:00+00:00"
                        }
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                        "atcoCode": "940GZZALGWP",
                        "tapDetails": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                            "modeType": "Cablecar",
                            "validationType": "None",
                            "hostDeviceType": "Gate",
                            "nationalLocationCode": 911,
                            "tapTimestamp": "2024-02-27T10:17:00+00:00"
                        }
                    }
                ]
            }
        ],
        "caveats": [
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareCaveat, Tfl.Api.Presentation.Entities",
                "text": "The price shown is a single adult pay as you go fare.",
                "type": "generic"
            }
        ]
    }
}
"""#
