let journeyByTubeJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-03-12T12:04:00",
    "duration": 23,
    "arrivalDateTime": "2024-03-12T12:27:00",
    "description": "Scenario1 Intermodal",
    "alternativeRoute": false,
    "legs": [
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 5,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Transfer to King's Cross St. Pancras Underground Station",
                "detailed": "Transfer to King's Cross St. Pancras Underground Station",
                "steps": []
            },
            "obstacles": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "STAIRS",
                    "incline": "DOWN",
                    "stopId": 1000129,
                    "position": "IDEST"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "ESCALATOR",
                    "incline": "DOWN",
                    "stopId": 1000129,
                    "position": "IDEST"
                }
            ],
            "departureTime": "2024-03-12T12:04:00",
            "arrivalTime": "2024-03-12T12:09:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "platformName": "",
                "icsCode": "1000129",
                "individualStopId": "4900ZZLUKSX4",
                "commonName": "King's Cross St. Pancras Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.53005672132,
                "lon": -0.12363753879
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUKSX",
                "platformName": "",
                "icsCode": "1000129",
                "individualStopId": "9400ZZLUKSX7",
                "commonName": "King's Cross St. Pancras Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.531350556599996,
                "lon": -0.12300762725
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.53013919541, -0.12373508748],[51.53028507338, -0.12385882890],[51.53135059541, -0.12300758748]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "name": "King's Cross St. Pancras Underground Station",
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
            "scheduledDepartureTime": "2024-03-12T12:04:00",
            "scheduledArrivalTime": "2024-03-12T12:09:00",
            "interChangeDuration": "5",
            "interChangePosition": "IDEST"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 6,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Piccadilly line to Leicester Square",
                "detailed": "Piccadilly line towards Heathrow Terminal 5",
                "steps": []
            },
            "obstacles": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "STAIRS",
                    "incline": "UP",
                    "stopId": 1000135,
                    "position": "AFTER"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "STAIRS",
                    "incline": "UP",
                    "stopId": 1000135,
                    "position": "AFTER"
                }
            ],
            "departureTime": "2024-03-12T12:09:00",
            "arrivalTime": "2024-03-12T12:15:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUKSX",
                "platformName": "",
                "icsCode": "1000129",
                "individualStopId": "9400ZZLUKSX7",
                "commonName": "King's Cross St. Pancras Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.531350556599996,
                "lon": -0.12300762725
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLULSQ",
                "platformName": "",
                "icsCode": "1000135",
                "individualStopId": "9400ZZLULSQ4",
                "commonName": "Leicester Square Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.51151474372,
                "lon": -0.12761327959000002
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.53135059602, -0.12300762563],[51.53076642840, -0.12303165336],[51.52993436397, -0.12329655351],[51.52629224752, -0.12553666263],[51.52597057131, -0.12566520219],[51.52569129581, -0.12563342285],[51.52433064079, -0.12489644160],[51.52341549111, -0.12433514487],[51.52341549111, -0.12433514487],[51.52329534209, -0.12426145459],[51.52280868313, -0.12419496199],[51.52225289569, -0.12430429039],[51.52202823048, -0.12431352190],[51.52169411344, -0.12422634744],[51.52144755856, -0.12399142945],[51.51992489437, -0.12212250233],[51.51912023353, -0.12129076552],[51.51864623897, -0.12089227144],[51.51721307767, -0.12014565439],[51.51721307767, -0.12014565439],[51.51715905031, -0.12011750934],[51.51679519999, -0.11985863988],[51.51649679526, -0.11975562321],[51.51630900037, -0.11982100902],[51.51608779865, -0.12004631259],[51.51584240655, -0.12044556457],[51.51534147792, -0.12117240922],[51.51516497578, -0.12138144952],[51.51481888106, -0.12166952788],[51.51454513967, -0.12198345082],[51.51347436027, -0.12362723809],[51.51315867499, -0.12413021952],[51.51302757941, -0.12436616467],[51.51302757941, -0.12436616467],[51.51250310040, -0.12531009695],[51.51211228092, -0.12617643205],[51.51187123768, -0.12684925791],[51.51154999963, -0.12763933877]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLURSQ",
                        "name": "Russell Square Underground Station",
                        "uri": "/StopPoint/940GZZLURSQ",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUHBN",
                        "name": "Holborn Underground Station",
                        "uri": "/StopPoint/940GZZLUHBN",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUCGN",
                        "name": "Covent Garden Underground Station",
                        "uri": "/StopPoint/940GZZLUCGN",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLULSQ",
                        "name": "Leicester Square Underground Station",
                        "uri": "/StopPoint/940GZZLULSQ",
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
                    "name": "Piccadilly",
                    "directions": [
                        "Heathrow Terminal 5 Underground Station"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "piccadilly",
                        "name": "Piccadilly",
                        "uri": "/Line/piccadilly",
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
                "id": "tube",
                "name": "tube",
                "type": "Mode",
                "routeType": "Unknown",
                "status": "Unknown",
                "motType": "1",
                "network": "tfl"
            },
            "disruptions": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                    "category": "RealTime",
                    "type": "lineInfo",
                    "categoryDescription": "RealTime",
                    "description": "Piccadilly Line: No service between Hyde Park Corner and Uxbridge / Heathrow Airport and SEVERE DELAYS on the rest of the line due to a signal failure at Chiswick Park. London Buses and Elizabeth line are accepting tickets.",
                    "summary": "",
                    "additionalInfo": "",
                    "created": "2024-03-12T11:09:00",
                    "lastUpdate": "2024-03-12T11:09:00"
                }
            ],
            "plannedWorks": [],
            "isDisrupted": true,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-03-12T12:09:00",
            "scheduledArrivalTime": "2024-03-12T12:15:00",
            "interChangeDuration": "4",
            "interChangePosition": "AFTER"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 3,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Northern line to Waterloo",
                "detailed": "Northern line towards Battersea Power Station",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-03-12T12:19:00",
            "arrivalTime": "2024-03-12T12:22:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLULSQ",
                "platformName": "",
                "icsCode": "1000135",
                "individualStopId": "9400ZZLULSQ2",
                "commonName": "Leicester Square Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.511976259170005,
                "lon": -0.12835817417
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUWLO",
                "platformName": "",
                "icsCode": "1000254",
                "individualStopId": "9400ZZLUWLO3",
                "commonName": "Waterloo Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.503374829209996,
                "lon": -0.11348036186999999
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.51194360605, -0.12859202804],[51.51186242040, -0.12855019106],[51.51095453931, -0.12857298551],[51.51036925821, -0.12852491425],[51.51007040073, -0.12839305086],[51.50976048788, -0.12813194364],[51.50946578906, -0.12769728583],[51.50925081867, -0.12718731020],[51.50881604180, -0.12558825255],[51.50881604180, -0.12558825255],[51.50869669107, -0.12514931399],[51.50845474988, -0.12464046618],[51.50754848947, -0.12307813893],[51.50726881517, -0.12251430869],[51.50726881517, -0.12251430869],[51.50709316128, -0.12216019243],[51.50505710740, -0.11575962921],[51.50481489482, -0.11523647240],[51.50437150269, -0.11450548536],[51.50406017068, -0.11415810701],[51.50332402965, -0.11366926841]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUCHX",
                        "name": "Charing Cross Underground Station",
                        "uri": "/StopPoint/940GZZLUCHX",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUEMB",
                        "name": "Embankment Underground Station",
                        "uri": "/StopPoint/940GZZLUEMB",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUWLO",
                        "name": "Waterloo Underground Station",
                        "uri": "/StopPoint/940GZZLUWLO",
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
                    "name": "Northern",
                    "directions": [
                        "Battersea Power Station Underground Station"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "northern",
                        "name": "Northern",
                        "uri": "/Line/northern",
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
                "id": "tube",
                "name": "tube",
                "type": "Mode",
                "routeType": "Unknown",
                "status": "Unknown",
                "motType": "1",
                "network": "tfl"
            },
            "disruptions": [],
            "plannedWorks": [],
            "isDisrupted": false,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-03-12T12:18:00",
            "scheduledArrivalTime": "2024-03-12T12:21:00"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 5,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Walk to Waterloo Station",
                "detailed": "Walk to Waterloo Station",
                "steps": []
            },
            "obstacles": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "STAIRS",
                    "incline": "UP",
                    "stopId": 1000254,
                    "position": "IDEST"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "ESCALATOR",
                    "incline": "UP",
                    "stopId": 1000254,
                    "position": "IDEST"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "WALKWAY",
                    "incline": "LEVEL",
                    "stopId": 1000254,
                    "position": "IDEST"
                }
            ],
            "departureTime": "2024-03-12T12:22:00",
            "arrivalTime": "2024-03-12T12:27:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUWLO",
                "platformName": "",
                "icsCode": "1000254",
                "individualStopId": "9400ZZLUWLO3",
                "commonName": "Waterloo Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.503374829209996,
                "lon": -0.11348036186999999
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "platformName": "",
                "icsCode": "1000254",
                "individualStopId": "4900WATRLMN2",
                "commonName": "Waterloo Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.50389756853,
                "lon": -0.11523109592000001
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.50332389539, -0.11366978749],[51.50380410034, -0.11333295095],[51.50380386869, -0.11331855142],[51.50388739539, -0.11515948749]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "name": "Waterloo Station",
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
            "scheduledDepartureTime": "2024-03-12T12:21:00",
            "scheduledArrivalTime": "2024-03-12T12:26:00",
            "interChangeDuration": "5",
            "interChangePosition": "IDEST"
        }
    ]
}
"""#
