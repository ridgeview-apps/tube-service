let journeyItineraryKingsXToWaterlooJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.ItineraryResult, Tfl.Api.Presentation.Entities",
    "journeys": [
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
            "startDateTime": "2024-03-12T16:39:00",
            "duration": 23,
            "arrivalDateTime": "2024-03-12T17:02:00",
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
                    "departureTime": "2024-03-12T16:39:00",
                    "arrivalTime": "2024-03-12T16:44:00",
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
                    "scheduledDepartureTime": "2024-03-12T16:39:00",
                    "scheduledArrivalTime": "2024-03-12T16:44:00",
                    "interChangeDuration": "5",
                    "interChangePosition": "IDEST"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 6,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "Piccadilly line to Leicester Square",
                        "detailed": "Piccadilly line towards Northfields",
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
                    "departureTime": "2024-03-12T16:44:00",
                    "arrivalTime": "2024-03-12T16:50:00",
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
                                "Northfields Underground Station"
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
                            "description": "Piccadilly Line: Minor delay due to an earlier signal failure at Chiswick Park.",
                            "summary": "",
                            "additionalInfo": "",
                            "created": "2024-03-12T16:24:00",
                            "lastUpdate": "2024-03-12T16:24:00"
                        }
                    ],
                    "plannedWorks": [],
                    "isDisrupted": true,
                    "hasFixedLocations": true,
                    "scheduledDepartureTime": "2024-03-12T16:44:00",
                    "scheduledArrivalTime": "2024-03-12T16:50:00",
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
                    "departureTime": "2024-03-12T16:54:00",
                    "arrivalTime": "2024-03-12T16:57:00",
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
                    "scheduledDepartureTime": "2024-03-12T16:51:00",
                    "scheduledArrivalTime": "2024-03-12T16:54:00"
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
                    "departureTime": "2024-03-12T16:57:00",
                    "arrivalTime": "2024-03-12T17:02:00",
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
                    "scheduledDepartureTime": "2024-03-12T16:54:00",
                    "scheduledArrivalTime": "2024-03-12T16:59:00",
                    "interChangeDuration": "5",
                    "interChangePosition": "IDEST"
                }
            ]
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
            "startDateTime": "2024-03-12T16:40:00",
            "duration": 24,
            "arrivalDateTime": "2024-03-12T17:04:00",
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
                    "departureTime": "2024-03-12T16:40:00",
                    "arrivalTime": "2024-03-12T16:45:00",
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
                        "individualStopId": "9400ZZLUKSX2",
                        "commonName": "King's Cross St. Pancras Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.53045649671,
                        "lon": -0.12220818558999999
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "lineString": "[[51.53013919541, -0.12373508748],[51.53028507338, -0.12385882890],[51.53046549541, -0.12220778748]]",
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
                    "scheduledDepartureTime": "2024-03-12T16:39:00",
                    "scheduledArrivalTime": "2024-03-12T16:44:00",
                    "interChangeDuration": "5",
                    "interChangePosition": "IDEST"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 4,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "Victoria line to Oxford Circus",
                        "detailed": "Victoria line towards Brixton",
                        "steps": []
                    },
                    "obstacles": [
                        {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                            "type": "WALKWAY",
                            "incline": "LEVEL",
                            "stopId": 1000173,
                            "position": "AFTER"
                        }
                    ],
                    "departureTime": "2024-03-12T16:45:00",
                    "arrivalTime": "2024-03-12T16:49:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "940GZZLUKSX",
                        "platformName": "",
                        "icsCode": "1000129",
                        "individualStopId": "9400ZZLUKSX2",
                        "commonName": "King's Cross St. Pancras Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.53045649671,
                        "lon": -0.12220818558999999
                    },
                    "arrivalPoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "940GZZLUOXC",
                        "platformName": "",
                        "icsCode": "1000173",
                        "individualStopId": "9400ZZLUOXC6",
                        "commonName": "Oxford Circus Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.51577393238,
                        "lon": -0.14211089907000002
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "lineString": "[[51.53046098943, -0.12220548959],[51.52898372132, -0.12965030752],[51.52884728553, -0.13011724258],[51.52810204663, -0.13207640885],[51.52810204663, -0.13207640885],[51.52622331599, -0.13701475135],[51.52597923903, -0.13750044403],[51.52566996631, -0.13784463148],[51.52401101124, -0.13871820068],[51.52401101124, -0.13871820068],[51.51715323345, -0.14232862448],[51.51657046612, -0.14243881405],[51.51589144404, -0.14214935605],[51.51577377095, -0.14211189165]]",
                        "stopPoints": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "940GZZLUEUS",
                                "name": "Euston Underground Station",
                                "uri": "/StopPoint/940GZZLUEUS",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "940GZZLUWRR",
                                "name": "Warren Street Underground Station",
                                "uri": "/StopPoint/940GZZLUWRR",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "940GZZLUOXC",
                                "name": "Oxford Circus Underground Station",
                                "uri": "/StopPoint/940GZZLUOXC",
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
                            "name": "Victoria",
                            "directions": [
                                "Brixton Underground Station"
                            ],
                            "lineIdentifier": {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "victoria",
                                "name": "Victoria",
                                "uri": "/Line/victoria",
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
                            "category": "Information",
                            "type": "stopInfo",
                            "categoryDescription": "Information",
                            "description": "Kings Cross St Pancras Station: Mini ramps are available at this station on the Circle, Hammersmith & City, Metropolitan, Northern and Victoria line platforms. They are designed to cover the small remaining step / or gap between the platform and the train on step-free to train platforms. They make it easier for customers people to get on and off the train, in particular for people whose mobility aids have small or swivel wheels. The ramps are quick and easy to use. Staff are trained to use them and will be happy to provide one for you to use. If you would like to use a mini ramp, please ask for help from staff or press the information button on a help point.",
                            "summary": "",
                            "additionalInfo": "",
                            "created": "2024-02-13T10:31:00",
                            "lastUpdate": "2024-02-13T10:32:00"
                        }
                    ],
                    "plannedWorks": [],
                    "isDisrupted": true,
                    "hasFixedLocations": true,
                    "scheduledDepartureTime": "2024-03-12T16:44:00",
                    "scheduledArrivalTime": "2024-03-12T16:48:00",
                    "interChangeDuration": "2",
                    "interChangePosition": "AFTER"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 6,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "Bakerloo line to Waterloo",
                        "detailed": "Bakerloo line towards Elephant & Castle",
                        "steps": []
                    },
                    "obstacles": [],
                    "departureTime": "2024-03-12T16:53:00",
                    "arrivalTime": "2024-03-12T16:59:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "940GZZLUOXC",
                        "platformName": "",
                        "icsCode": "1000173",
                        "individualStopId": "9400ZZLUOXC3",
                        "commonName": "Oxford Circus Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.515728770680006,
                        "lon": -0.1420983239
                    },
                    "arrivalPoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "940GZZLUWLO",
                        "platformName": "",
                        "icsCode": "1000254",
                        "individualStopId": "9400ZZLUWLO2",
                        "commonName": "Waterloo Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.50305005203,
                        "lon": -0.11509315899
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "lineString": "[[51.51572888065, -0.14209759966],[51.51452669313, -0.14171486242],[51.51441816803, -0.14167604188],[51.51405459181, -0.14143141735],[51.51101771190, -0.13875921757],[51.51049815569, -0.13831923529],[51.51023228320, -0.13799861868],[51.51007447888, -0.13768800986],[51.50997013649, -0.13734640067],[51.50991004028, -0.13695975507],[51.50991771739, -0.13631094724],[51.50995847141, -0.13519906170],[51.50995847141, -0.13519906170],[51.51000551808, -0.13391513441],[51.50997122467, -0.13345538323],[51.50983000639, -0.13305764785],[51.50884247734, -0.13203162822],[51.50850538295, -0.13175720456],[51.50787681403, -0.13124973359],[51.50775654528, -0.13103849980],[51.50768973711, -0.13079625859],[51.50757251694, -0.12964823492],[51.50743356460, -0.12806817176],[51.50743356460, -0.12806817176],[51.50724291724, -0.12590067962],[51.50710053146, -0.12486899326],[51.50665266834, -0.12272584835],[51.50665266834, -0.12272584835],[51.50646755027, -0.12184007562],[51.50630601327, -0.12129914274],[51.50497108456, -0.11880357521],[51.50467265527, -0.11813862564],[51.50404509256, -0.11601751349],[51.50383076649, -0.11555085272],[51.50350030723, -0.11513221551],[51.50321042204, -0.11500008799],[51.50306578747, -0.11496389475]]",
                        "stopPoints": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "940GZZLUPCC",
                                "name": "Piccadilly Circus Underground Station",
                                "uri": "/StopPoint/940GZZLUPCC",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
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
                            "name": "Bakerloo",
                            "directions": [
                                "Elephant & Castle Underground Station"
                            ],
                            "lineIdentifier": {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "bakerloo",
                                "name": "Bakerloo",
                                "uri": "/Line/bakerloo",
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
                            "description": "Bakerloo Line: Minor delays due to shortage of trains.",
                            "summary": "",
                            "additionalInfo": "",
                            "created": "2024-03-12T16:36:00",
                            "lastUpdate": "2024-03-12T16:36:00"
                        },
                        {
                            "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                            "category": "Information",
                            "type": "stopInfo",
                            "categoryDescription": "Information",
                            "description": "WATERLOO STATION: The southbound Bakerloo line platform is step free to/from street level. Please note that due to the curve of the platform, the gap between platform and train exceeds the size that any boarding ramp can be safely used",
                            "summary": "",
                            "additionalInfo": "",
                            "created": "2023-01-10T13:44:00",
                            "lastUpdate": "2023-01-10T13:47:00"
                        }
                    ],
                    "plannedWorks": [],
                    "isDisrupted": true,
                    "hasFixedLocations": true,
                    "scheduledDepartureTime": "2024-03-12T16:53:00",
                    "scheduledArrivalTime": "2024-03-12T16:59:00"
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
                            "incline": "DOWN",
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
                    "departureTime": "2024-03-12T16:59:00",
                    "arrivalTime": "2024-03-12T17:04:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "940GZZLUWLO",
                        "platformName": "",
                        "icsCode": "1000254",
                        "individualStopId": "9400ZZLUWLO2",
                        "commonName": "Waterloo Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.50305005203,
                        "lon": -0.11509315899
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
                        "lineString": "[[51.50306589539, -0.11496278749],[51.50380410034, -0.11333295095],[51.50380386869, -0.11331855142],[51.50388739539, -0.11515948749]]",
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
                    "scheduledDepartureTime": "2024-03-12T16:59:00",
                    "scheduledArrivalTime": "2024-03-12T17:04:00",
                    "interChangeDuration": "5",
                    "interChangePosition": "IDEST"
                }
            ]
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
            "startDateTime": "2024-03-12T16:41:00",
            "duration": 23,
            "arrivalDateTime": "2024-03-12T17:04:00",
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
                    "departureTime": "2024-03-12T16:41:00",
                    "arrivalTime": "2024-03-12T16:46:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000129",
                        "individualStopId": "4900ZZLUKSX3",
                        "commonName": "King's Cross St. Pancras Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.530152347139996,
                        "lon": -0.12343176325
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
                        "lineString": "[[51.53022559541, -0.12351528748],[51.53028507338, -0.12385882890],[51.53135059541, -0.12300758748]]",
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
                    "scheduledDepartureTime": "2024-03-12T16:41:00",
                    "scheduledArrivalTime": "2024-03-12T16:46:00",
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
                    "departureTime": "2024-03-12T16:46:00",
                    "arrivalTime": "2024-03-12T16:52:00",
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
                            "description": "Piccadilly Line: Minor delay due to an earlier signal failure at Chiswick Park.",
                            "summary": "",
                            "additionalInfo": "",
                            "created": "2024-03-12T16:24:00",
                            "lastUpdate": "2024-03-12T16:24:00"
                        }
                    ],
                    "plannedWorks": [],
                    "isDisrupted": true,
                    "hasFixedLocations": true,
                    "scheduledDepartureTime": "2024-03-12T16:46:00",
                    "scheduledArrivalTime": "2024-03-12T16:52:00",
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
                    "departureTime": "2024-03-12T16:56:00",
                    "arrivalTime": "2024-03-12T16:59:00",
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
                    "scheduledDepartureTime": "2024-03-12T16:54:00",
                    "scheduledArrivalTime": "2024-03-12T16:57:00"
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
                    "departureTime": "2024-03-12T16:59:00",
                    "arrivalTime": "2024-03-12T17:04:00",
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
                    "scheduledDepartureTime": "2024-03-12T16:57:00",
                    "scheduledArrivalTime": "2024-03-12T17:02:00",
                    "interChangeDuration": "5",
                    "interChangePosition": "IDEST"
                }
            ]
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
            "startDateTime": "2024-03-12T16:51:00",
            "duration": 25,
            "arrivalDateTime": "2024-03-12T17:16:00",
            "description": "Scenario1 Bus Only",
            "alternativeRoute": false,
            "legs": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 10,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "63 bus to Farringdon Station",
                        "detailed": "63 bus towards Therapia Road",
                        "steps": []
                    },
                    "obstacles": [],
                    "departureTime": "2024-03-12T16:51:00",
                    "arrivalTime": "2024-03-12T17:01:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "490G00129R",
                        "platformName": "D",
                        "stopLetter": "D",
                        "icsCode": "1000129",
                        "individualStopId": "490000129D",
                        "commonName": "King's Cross Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.53039843935,
                        "lon": -0.12307562388
                    },
                    "arrivalPoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "490G00080B",
                        "platformName": "",
                        "stopLetter": "B",
                        "icsCode": "1000080",
                        "individualStopId": "490000080B",
                        "commonName": "Farringdon Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.52023830275,
                        "lon": -0.10582145817
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "lineString": "[[51.53040872047, -0.12309084529],[51.53058991915, -0.12267847458],[51.53074683501, -0.12236924971],[51.53088345890, -0.12135439320],[51.53089589358, -0.12100785773],[51.53096659756, -0.11980827964],[51.53085206077, -0.11939488726],[51.53064831851, -0.11848064610],[51.53064831851, -0.11848064610],[51.53062919623, -0.11839484181],[51.53048376484, -0.11773763216],[51.53031206393, -0.11712476294],[51.53027403623, -0.11699657481],[51.52992649672, -0.11607378721],[51.52970665409, -0.11582335166],[51.52940917214, -0.11577796505],[51.52888725776, -0.11575626242],[51.52857220020, -0.11572125094],[51.52857220020, -0.11572125094],[51.52850889678, -0.11571421626],[51.52843677291, -0.11570277722],[51.52782198410, -0.11549749326],[51.52760283476, -0.11529029298],[51.52731002177, -0.11485227768],[51.52731002177, -0.11485227768],[51.52707763564, -0.11450465986],[51.52692023242, -0.11422283444],[51.52647289290, -0.11324659529],[51.52636111472, -0.11300614017],[51.52632192374, -0.11280593343],[51.52601632703, -0.11225634052],[51.52546290114, -0.11128195169],[51.52546290114, -0.11128195169],[51.52507233014, -0.11059431581],[51.52454043518, -0.10995321298],[51.52444848066, -0.10982727998],[51.52420027245, -0.10949158518],[51.52403511615, -0.10925246322],[51.52403511615, -0.10925246322],[51.52382276837, -0.10894501851],[51.52357386083, -0.10856611589],[51.52308712009, -0.10793760068],[51.52232775856, -0.10713300784],[51.52218164950, -0.10699491731],[51.52173649068, -0.10664968981],[51.52173649068, -0.10664968981],[51.52161704508, -0.10655705918],[51.52116260306, -0.10625878733],[51.52023064024, -0.10586110471]]",
                        "stopPoints": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G000700",
                                "name": "King's Cross Road / Pentonville Road",
                                "uri": "/StopPoint/490G000700",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00003087",
                                "name": "Acton Street",
                                "uri": "/StopPoint/490G00003087",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00007613",
                                "name": "Gwynne Place",
                                "uri": "/StopPoint/490G00007613",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00010089",
                                "name": "Rosebery Avenue / Mount Pleasant",
                                "uri": "/StopPoint/490G00010089",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00004217",
                                "name": "Bowling Green Lane",
                                "uri": "/StopPoint/490G00004217",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00015104",
                                "name": "Clerkenwell Road",
                                "uri": "/StopPoint/490G00015104",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00080B",
                                "name": "Farringdon Station",
                                "uri": "/StopPoint/490G00080B",
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
                            "name": "63",
                            "directions": [
                                "Therapia Road"
                            ],
                            "lineIdentifier": {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "63",
                                "name": "63",
                                "uri": "/Line/63",
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
                    "scheduledDepartureTime": "2024-03-12T16:51:00",
                    "scheduledArrivalTime": "2024-03-12T17:04:00",
                    "interChangeDuration": "2",
                    "interChangePosition": "AFTER"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 10,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "341 bus to Waterloo Station / Waterloo Road",
                        "detailed": "341 bus towards Waterloo Station / Waterloo Road",
                        "steps": []
                    },
                    "obstacles": [],
                    "departureTime": "2024-03-12T17:04:00",
                    "arrivalTime": "2024-03-12T17:14:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "490G00080B",
                        "platformName": "",
                        "stopLetter": "B",
                        "icsCode": "1000080",
                        "individualStopId": "490000080B",
                        "commonName": "Farringdon Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.52023830275,
                        "lon": -0.10582145817
                    },
                    "arrivalPoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "490G000401",
                        "platformName": "E",
                        "stopLetter": "E",
                        "icsCode": "1003705",
                        "individualStopId": "490000254E",
                        "commonName": "Waterloo Station   / Waterloo Road",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.503512433190004,
                        "lon": -0.11141418974
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "lineString": "[[51.52023064024, -0.10586110471],[51.51977719890, -0.10566762035],[51.51853953183, -0.10531539024],[51.51808056252, -0.10526986835],[51.51808056252, -0.10526986835],[51.51771989743, -0.10523409711],[51.51747586535, -0.10515774417],[51.51709657006, -0.10505817936],[51.51696107419, -0.10502056322],[51.51658201150, -0.10493540407],[51.51639236377, -0.10488562327],[51.51596860111, -0.10481673457],[51.51579692635, -0.10476620882],[51.51529158672, -0.10465746999],[51.51511991188, -0.10460694552],[51.51501160817, -0.10458261605],[51.51489432325, -0.10455834184],[51.51489432325, -0.10455834184],[51.51460558556, -0.10449858293],[51.51434427825, -0.10446619320],[51.51416361681, -0.10441604349],[51.51416780648, -0.10467529265],[51.51417292640, -0.10499215281],[51.51416766292, -0.10522296954],[51.51417580550, -0.10572706546],[51.51419130453, -0.10612996964],[51.51419316499, -0.10624519166],[51.51419735061, -0.10650444126],[51.51421261450, -0.10689294319],[51.51420897434, -0.10722457937],[51.51421199579, -0.10741181535],[51.51421292540, -0.10746942643],[51.51420835415, -0.10774345151],[51.51421160711, -0.10794509033],[51.51419618970, -0.10810426554],[51.51418952629, -0.10824866557],[51.51419092009, -0.10833508219],[51.51418705063, -0.10840802642],[51.51418705063, -0.10840802642],[51.51418402413, -0.10846507940],[51.51416333537, -0.10885507083],[51.51414838112, -0.10904305113],[51.51414218094, -0.10921625642],[51.51411823957, -0.10940460861],[51.51398582865, -0.11011629506],[51.51393608642, -0.11037777543],[51.51391992269, -0.11046509066],[51.51391992269, -0.11046509066],[51.51382854152, -0.11095871699],[51.51374772149, -0.11152413824],[51.51372284886, -0.11165487708],[51.51364730273, -0.11198948225],[51.51349690284, -0.11270189710],[51.51327043575, -0.11315803226],[51.51310293462, -0.11336672218],[51.51299741893, -0.11357162821],[51.51299741893, -0.11357162821],[51.51292853127, -0.11370540357],[51.51288017049, -0.11405328857],[51.51277144954, -0.11456219658],[51.51309982782, -0.11485129053],[51.51310723461, -0.11531217000],[51.51312690434, -0.11539760479],[51.51312690434, -0.11539760479],[51.51327157595, -0.11602599146],[51.51329166514, -0.11671694317],[51.51325228200, -0.11706445742],[51.51316888958, -0.11747143369],[51.51301429637, -0.11792457919],[51.51290992378, -0.11814506063],[51.51263734703, -0.11853100286],[51.51235301036, -0.11874448332],[51.51226465711, -0.11880780068],[51.51226465711, -0.11880780068],[51.51203295787, -0.11897384399],[51.51167326303, -0.11897424885],[51.51128247193, -0.11927857507],[51.51123453656, -0.11909320053],[51.51001300576, -0.11806268238],[51.50991276668, -0.11798034698],[51.50979432324, -0.11788435119],[51.50906430074, -0.11722272035],[51.50895623046, -0.11721276493],[51.50863730690, -0.11695211094],[51.50736897423, -0.11580835547],[51.50726873362, -0.11572602968],[51.50711341654, -0.11557392585],[51.50697653524, -0.11544988253],[51.50691270353, -0.11539487601],[51.50673941287, -0.11524351615],[51.50662995385, -0.11514716312],[51.50646519561, -0.11499679366],[51.50646519561, -0.11499679366],[51.50619188555, -0.11474735525],[51.50610984887, -0.11467869225],[51.50581834266, -0.11444575922],[51.50530791627, -0.11402013348],[51.50517793565, -0.11376612877],[51.50517724084, -0.11372292884],[51.50510947073, -0.11342312769],[51.50504332155, -0.11322412693],[51.50469191836, -0.11318100491],[51.50440110436, -0.11299128769],[51.50434255073, -0.11270552113],[51.50418282640, -0.11227984381],[51.50407243786, -0.11212590473],[51.50376133080, -0.11179294452],[51.50371547059, -0.11173720393],[51.50348545155, -0.11146007262]]",
                        "stopPoints": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G000747",
                                "name": "Snow Hill",
                                "uri": "/StopPoint/490G000747",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00012640",
                                "name": "Fleet Street / City Thameslink",
                                "uri": "/StopPoint/490G00012640",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00006826",
                                "name": "Fetter Lane",
                                "uri": "/StopPoint/490G00006826",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00015067",
                                "name": "Chancery Lane",
                                "uri": "/StopPoint/490G00015067",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G000731",
                                "name": "The Royal Courts of Justice",
                                "uri": "/StopPoint/490G000731",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G000023",
                                "name": "Aldwych / Australia House",
                                "uri": "/StopPoint/490G000023",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G00019703",
                                "name": "Aldwych / Drury Lane",
                                "uri": "/StopPoint/490G00019703",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G000819",
                                "name": "Waterloo Bridge / South Bank",
                                "uri": "/StopPoint/490G000819",
                                "type": "StopPoint",
                                "routeType": "Unknown",
                                "status": "Unknown"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "490G000401",
                                "name": "Waterloo Station   / Waterloo Road",
                                "uri": "/StopPoint/490G000401",
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
                            "name": "341",
                            "directions": [
                                "Waterloo Station / Waterloo Road"
                            ],
                            "lineIdentifier": {
                                "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                "id": "341",
                                "name": "341",
                                "uri": "/Line/341",
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
                    "scheduledDepartureTime": "2024-03-12T17:04:00",
                    "scheduledArrivalTime": "2024-03-12T17:22:00"
                },
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 2,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "Walk to Waterloo Station",
                        "detailed": "Walk to Waterloo Station",
                        "steps": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "Waterloo Road for 191 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Waterloo Road",
                                "distance": 191,
                                "cumulativeDistance": 191,
                                "skyDirection": 321,
                                "skyDirectionDescription": "NorthWest",
                                "cumulativeTravelTime": 171,
                                "latitude": 51.50349515569,
                                "longitude": -0.11145813111,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 69 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "",
                                "distance": 69,
                                "cumulativeDistance": 260,
                                "skyDirection": 248,
                                "skyDirectionDescription": "West",
                                "cumulativeTravelTime": 233,
                                "latitude": 51.50452325832,
                                "longitude": -0.11331765591,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to York Road, continue for 121 metres",
                                "turnDirection": "SHARP_LEFT",
                                "streetName": "York Road",
                                "distance": 121,
                                "cumulativeDistance": 381,
                                "skyDirection": 189,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 342,
                                "latitude": 51.5047341644,
                                "longitude": -0.11413028008,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a sharp left",
                                "trackType": "None"
                            }
                        ]
                    },
                    "obstacles": [],
                    "departureTime": "2024-03-12T17:14:00",
                    "arrivalTime": "2024-03-12T17:16:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "naptanId": "490G000401",
                        "platformName": "E",
                        "stopLetter": "E",
                        "icsCode": "1003705",
                        "individualStopId": "490000254E",
                        "commonName": "Waterloo Station   / Waterloo Road",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.503512433190004,
                        "lon": -0.11141418974
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
                        "lineString": "[[51.50348619539, -0.11145848749],[51.50338190860, -0.11133433148],[51.50344628987, -0.11141284275],[51.50344952720, -0.11141679059],[51.50371547059, -0.11173720393],[51.50376133080, -0.11179294452],[51.50407243786, -0.11212590473],[51.50418282640, -0.11227984381],[51.50434255073, -0.11270552113],[51.50440110436, -0.11299128769],[51.50452325832, -0.11331765591],[51.50447281341, -0.11353587927],[51.50450394211, -0.11379396151],[51.50454150955, -0.11389327554],[51.50473416440, -0.11413028008],[51.50462678851, -0.11416353207],[51.50455605357, -0.11423849917],[51.50440582845, -0.11440320338],[51.50425768650, -0.11469750372],[51.50411760457, -0.11493383270],[51.50402037222, -0.11503870956],[51.50387888644, -0.11516452124],[51.50388739539, -0.11515948749]]",
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
                    "scheduledDepartureTime": "2024-03-12T17:22:00",
                    "scheduledArrivalTime": "2024-03-12T17:24:00"
                }
            ]
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
            "startDateTime": "2024-03-12T16:38:00",
            "duration": 15,
            "arrivalDateTime": "2024-03-12T16:53:00",
            "description": "Scenario1 Bike",
            "alternativeRoute": false,
            "legs": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 15,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "Cycle to Waterloo Station",
                        "detailed": "Cycle to Waterloo Station",
                        "steps": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "Pancras Road for 2 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Pancras Road",
                                "distance": 2,
                                "cumulativeDistance": 2,
                                "skyDirection": 151,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 1,
                                "latitude": 51.530064786530005,
                                "longitude": -0.12414181551,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "PushBike"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 31 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "",
                                "distance": 31,
                                "cumulativeDistance": 33,
                                "skyDirection": 230,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 7,
                                "latitude": 51.53004658293,
                                "longitude": -0.1241281464,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "QuietRoad"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Euston Road, continue for 150 metres",
                                "turnDirection": "SLIGHT_RIGHT",
                                "streetName": "Euston Road",
                                "distance": 150,
                                "cumulativeDistance": 183,
                                "skyDirection": 236,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 61,
                                "latitude": 51.52982606503,
                                "longitude": -0.12439672238,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Judd Street, continue for 63 metres",
                                "turnDirection": "LEFT",
                                "streetName": "Judd Street",
                                "distance": 63,
                                "cumulativeDistance": 246,
                                "skyDirection": 127,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 73,
                                "latitude": 51.52909075594,
                                "longitude": -0.12621465932,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "QuietRoad"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Bidborough Street, continue for 145 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Bidborough Street",
                                "distance": 145,
                                "cumulativeDistance": 391,
                                "skyDirection": 237,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 99,
                                "latitude": 51.52863290909,
                                "longitude": -0.12570003141,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "QuietRoad"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Mabledon Place, continue for 54 metres",
                                "turnDirection": "LEFT",
                                "streetName": "Mabledon Place",
                                "distance": 54,
                                "cumulativeDistance": 445,
                                "skyDirection": 149,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 105,
                                "latitude": 51.527960025300004,
                                "longitude": -0.12748650434,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Cartwright Gardens, continue for 165 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Cartwright Gardens",
                                "distance": 165,
                                "cumulativeDistance": 610,
                                "skyDirection": 149,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 125,
                                "latitude": 51.52754020076,
                                "longitude": -0.12710006497999998,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Marchmont Street, continue for 69 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Marchmont Street",
                                "distance": 69,
                                "cumulativeDistance": 679,
                                "skyDirection": 155,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 133,
                                "latitude": 51.5262532996,
                                "longitude": -0.12591308268,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Tavistock Place, continue for 199 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Tavistock Place",
                                "distance": 199,
                                "cumulativeDistance": 878,
                                "skyDirection": 236,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 156,
                                "latitude": 51.525680467490005,
                                "longitude": -0.12551853959,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Tavistock Square, continue for 154 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Tavistock Square",
                                "distance": 154,
                                "cumulativeDistance": 1032,
                                "skyDirection": 232,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 175,
                                "latitude": 51.52470271162,
                                "longitude": -0.12792286537,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Gordon Square, continue for 31 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Gordon Square",
                                "distance": 31,
                                "cumulativeDistance": 1063,
                                "skyDirection": 235,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 179,
                                "latitude": 51.5238770189,
                                "longitude": -0.12971541081000002,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 233 metres",
                                "turnDirection": "LEFT",
                                "streetName": "",
                                "distance": 233,
                                "cumulativeDistance": 1296,
                                "skyDirection": 145,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 214,
                                "latitude": 51.52373021769,
                                "longitude": -0.13009622539000001,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "QuietRoad"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Thornhaugh Street, continue for 33 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Thornhaugh Street",
                                "distance": 33,
                                "cumulativeDistance": 1329,
                                "skyDirection": 136,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 218,
                                "latitude": 51.522128147930005,
                                "longitude": -0.12831674961,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Russell Square, continue for 191 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Russell Square",
                                "distance": 191,
                                "cumulativeDistance": 1520,
                                "skyDirection": 142,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 241,
                                "latitude": 51.521907181500005,
                                "longitude": -0.12799426938,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Montague Street, continue for 221 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Montague Street",
                                "distance": 221,
                                "cumulativeDistance": 1741,
                                "skyDirection": 142,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 268,
                                "latitude": 51.52053181735,
                                "longitude": -0.12633536031,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Great Russell Street, continue for 257 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Great Russell Street",
                                "distance": 257,
                                "cumulativeDistance": 1998,
                                "skyDirection": 232,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 306,
                                "latitude": 51.51893683631,
                                "longitude": -0.12444053542,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Bloomsbury Street, continue for 111 metres",
                                "turnDirection": "LEFT",
                                "streetName": "Bloomsbury Street",
                                "distance": 111,
                                "cumulativeDistance": 2109,
                                "skyDirection": 152,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 346,
                                "latitude": 51.51778302801,
                                "longitude": -0.12764449071,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Bloomsbury Avenue, continue for 81 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Bloomsbury Avenue",
                                "distance": 81,
                                "cumulativeDistance": 2190,
                                "skyDirection": 148,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 375,
                                "latitude": 51.516899136,
                                "longitude": -0.12691683832,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Shaftesbury Avenue, continue for 52 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Shaftesbury Avenue",
                                "distance": 52,
                                "cumulativeDistance": 2242,
                                "skyDirection": 149,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 394,
                                "latitude": 51.516252343379996,
                                "longitude": -0.1263956782,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to High Holborn, continue for 10 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "High Holborn",
                                "distance": 10,
                                "cumulativeDistance": 2252,
                                "skyDirection": 253,
                                "skyDirectionDescription": "West",
                                "cumulativeTravelTime": 398,
                                "latitude": 51.51583320593,
                                "longitude": -0.12605255558,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Endell Street, continue for 311 metres",
                                "turnDirection": "LEFT",
                                "streetName": "Endell Street",
                                "distance": 311,
                                "cumulativeDistance": 2563,
                                "skyDirection": 166,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 482,
                                "latitude": 51.5158085472,
                                "longitude": -0.12619769636,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "QuietRoad"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Long Acre, continue for 11 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "Long Acre",
                                "distance": 11,
                                "cumulativeDistance": 2574,
                                "skyDirection": 45,
                                "skyDirectionDescription": "NorthEast",
                                "cumulativeTravelTime": 483,
                                "latitude": 51.5137570929,
                                "longitude": -0.12331296307,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Bow Street, continue for 52 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Bow Street",
                                "distance": 52,
                                "cumulativeDistance": 2626,
                                "skyDirection": 125,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 489,
                                "latitude": 51.513827142130005,
                                "longitude": -0.12319478605999999,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 9 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "",
                                "distance": 9,
                                "cumulativeDistance": 2635,
                                "skyDirection": 122,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 490,
                                "latitude": 51.51354763199,
                                "longitude": -0.12258655142000001,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Bow Street, continue for 129 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Bow Street",
                                "distance": 129,
                                "cumulativeDistance": 2764,
                                "skyDirection": 130,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 505,
                                "latitude": 51.51350085453,
                                "longitude": -0.12247317748,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Wellington Street, continue for 200 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Wellington Street",
                                "distance": 200,
                                "cumulativeDistance": 2964,
                                "skyDirection": 142,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 529,
                                "latitude": 51.51265356028,
                                "longitude": -0.1212253577,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to bike connection, continue for 8 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "bike connection",
                                "distance": 8,
                                "cumulativeDistance": 2972,
                                "skyDirection": 150,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 530,
                                "latitude": 51.51134630188,
                                "longitude": -0.11933359218,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Lancaster Place, continue for 168 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "Lancaster Place",
                                "distance": 168,
                                "cumulativeDistance": 3140,
                                "skyDirection": 111,
                                "skyDirectionDescription": "East",
                                "cumulativeTravelTime": 550,
                                "latitude": 51.511282471929995,
                                "longitude": -0.11927857507,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Waterloo Bridge, continue for 595 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Waterloo Bridge",
                                "distance": 595,
                                "cumulativeDistance": 3735,
                                "skyDirection": 151,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 622,
                                "latitude": 51.51001300576,
                                "longitude": -0.11806268237999999,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Waterloo Gardens, continue for 23 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "Waterloo Gardens",
                                "distance": 23,
                                "cumulativeDistance": 3758,
                                "skyDirection": 128,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 625,
                                "latitude": 51.505307916270006,
                                "longitude": -0.11402013348000001,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 80 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "",
                                "distance": 80,
                                "cumulativeDistance": 3838,
                                "skyDirection": 90,
                                "skyDirectionDescription": "East",
                                "cumulativeTravelTime": 635,
                                "latitude": 51.505177935649996,
                                "longitude": -0.11376612877,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "BusyRoads"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Waterloo Road, continue for 197 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Waterloo Road",
                                "distance": 197,
                                "cumulativeDistance": 4035,
                                "skyDirection": 156,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 681,
                                "latitude": 51.50469191836,
                                "longitude": -0.11318100491000001,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "BusyRoads"
                            }
                        ]
                    },
                    "obstacles": [],
                    "departureTime": "2024-03-12T16:38:00",
                    "arrivalTime": "2024-03-12T16:53:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000129",
                        "commonName": "King's Cross St. Pancras Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.5300820685,
                        "lon": -0.12409785297
                    },
                    "arrivalPoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000254",
                        "commonName": "Waterloo Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.50336035713,
                        "lon": -0.11146370422
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "lineString": "[[51.53008206850, -0.12409785297],[51.53006420625, -0.12414309970],[51.53004831534, -0.12412961634],[51.53004658293, -0.12412814640],[51.53000303236, -0.12421644074],[51.52982606503, -0.12439672238],[51.52952328065, -0.12514444418],[51.52935045614, -0.12558405881],[51.52931566082, -0.12565757365],[51.52928155607, -0.12577431141],[51.52909075594, -0.12621465932],[51.52900711460, -0.12604508900],[51.52863290909, -0.12570003141],[51.52796002530, -0.12748650434],[51.52754020076, -0.12710006498],[51.52691046165, -0.12652041914],[51.52625329960, -0.12591308268],[51.52568046749, -0.12551853959],[51.52522235880, -0.12667620517],[51.52470271162, -0.12792286537],[51.52446788907, -0.12842262700],[51.52426878105, -0.12890650387],[51.52387701890, -0.12971541081],[51.52379912514, -0.12990600249],[51.52373021769, -0.13009622539],[51.52298920746, -0.12930491801],[51.52306664074, -0.12908551725],[51.52212814793, -0.12831674961],[51.52190718150, -0.12799426938],[51.52178805622, -0.12785500699],[51.52154911530, -0.12753326864],[51.52110901762, -0.12700356789],[51.52093551138, -0.12683771284],[51.52053181735, -0.12633536031],[51.51980783497, -0.12548581204],[51.51893683631, -0.12444053542],[51.51878913071, -0.12476370747],[51.51842550697, -0.12564346523],[51.51822663981, -0.12614169338],[51.51800265102, -0.12675625645],[51.51790010203, -0.12709197527],[51.51778302801, -0.12764449071],[51.51731850099, -0.12727438061],[51.51729131111, -0.12726108254],[51.51689913600, -0.12691683832],[51.51666180309, -0.12669596464],[51.51625234338, -0.12639567820],[51.51604242962, -0.12620251086],[51.51583320593, -0.12605255558],[51.51580854720, -0.12619769636],[51.51552812085, -0.12609390252],[51.51525368920, -0.12580249880],[51.51481750560, -0.12495564907],[51.51455090636, -0.12459187251],[51.51429329263, -0.12422773101],[51.51379603512, -0.12349872170],[51.51375709290, -0.12331296307],[51.51382714213, -0.12319478606],[51.51354763199, -0.12258655142],[51.51350085453, -0.12247317748],[51.51317686893, -0.12189560489],[51.51265356028, -0.12122535770],[51.51204844532, -0.12050084583],[51.51182307200, -0.11990483362],[51.51173872941, -0.11969213214],[51.51134630188, -0.11933359218],[51.51128247193, -0.11927857507],[51.51123453656, -0.11909320053],[51.51001300576, -0.11806268238],[51.50991276668, -0.11798034698],[51.50979432324, -0.11788435119],[51.50906430074, -0.11722272035],[51.50895623046, -0.11721276493],[51.50863730690, -0.11695211094],[51.50736897423, -0.11580835547],[51.50726873362, -0.11572602968],[51.50711341654, -0.11557392585],[51.50697653524, -0.11544988253],[51.50691270353, -0.11539487601],[51.50673941287, -0.11524351615],[51.50662995385, -0.11514716312],[51.50619188555, -0.11474735525],[51.50610984887, -0.11467869225],[51.50581834266, -0.11444575922],[51.50530791627, -0.11402013348],[51.50517793565, -0.11376612877],[51.50517724084, -0.11372292884],[51.50510947073, -0.11342312769],[51.50504332155, -0.11322412693],[51.50469191836, -0.11318100491],[51.50440110436, -0.11299128769],[51.50434255073, -0.11270552113],[51.50418282640, -0.11227984381],[51.50407243786, -0.11212590473],[51.50376133080, -0.11179294452],[51.50371547059, -0.11173720393],[51.50344952720, -0.11141679059],[51.50340660635, -0.11136444971],[51.50336035713, -0.11146370422]]",
                        "stopPoints": [],
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
                        "id": "cycle",
                        "name": "cycle",
                        "type": "Mode",
                        "routeType": "Unknown",
                        "status": "Unknown",
                        "motType": "107",
                        "network": ""
                    },
                    "disruptions": [],
                    "plannedWorks": [],
                    "distance": 4035.0,
                    "isDisrupted": false,
                    "hasFixedLocations": true,
                    "scheduledDepartureTime": "2024-03-12T16:38:00",
                    "scheduledArrivalTime": "2024-03-12T16:53:00"
                }
            ]
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
            "startDateTime": "2024-03-12T16:38:00",
            "duration": 0,
            "arrivalDateTime": "2024-03-12T16:38:00",
            "description": "Scenario1 Bike",
            "alternativeRoute": false,
            "legs": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 0,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "Cycle to Waterloo Station",
                        "detailed": "Cycle to Waterloo Station",
                        "steps": []
                    },
                    "obstacles": [],
                    "departureTime": "2024-03-12T16:38:00",
                    "arrivalTime": "2024-03-12T16:38:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000129",
                        "commonName": "King's Cross St. Pancras Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.53086044575,
                        "lon": -0.12384959143
                    },
                    "arrivalPoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000254",
                        "commonName": "Waterloo Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.50401045987,
                        "lon": -0.11498148193999999
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "stopPoints": [],
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
                        "id": "cycle",
                        "name": "cycle",
                        "type": "Mode",
                        "routeType": "Unknown",
                        "status": "Unknown",
                        "motType": "107",
                        "network": ""
                    },
                    "disruptions": [],
                    "plannedWorks": [],
                    "isDisrupted": false,
                    "hasFixedLocations": true,
                    "scheduledDepartureTime": "2024-03-12T16:38:00",
                    "scheduledArrivalTime": "2024-03-12T16:38:00"
                }
            ]
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
            "startDateTime": "2024-03-12T16:38:00",
            "duration": 50,
            "arrivalDateTime": "2024-03-12T17:28:00",
            "description": "Scenario1 Bike Hire",
            "alternativeRoute": false,
            "legs": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 50,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "Cycle to Waterloo Station",
                        "detailed": "Cycle to Waterloo Station",
                        "steps": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "Euston Road Exit/Entrance for 17 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Euston Road Exit/Entrance",
                                "distance": 17,
                                "cumulativeDistance": 17,
                                "skyDirection": 155,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 15,
                                "latitude": 51.53010441584,
                                "longitude": -0.1249331431,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 99 metres",
                                "turnDirection": "SLIGHT_RIGHT",
                                "streetName": "",
                                "distance": 99,
                                "cumulativeDistance": 116,
                                "skyDirection": 201,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 105,
                                "latitude": 51.52996800467,
                                "longitude": -0.12483782652,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Euston Road, continue for 52 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Euston Road",
                                "distance": 52,
                                "cumulativeDistance": 168,
                                "skyDirection": 231,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 152,
                                "latitude": 51.529350456139994,
                                "longitude": -0.12558405881,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Judd Street, continue for 382 metres",
                                "turnDirection": "LEFT",
                                "streetName": "Judd Street",
                                "distance": 382,
                                "cumulativeDistance": 550,
                                "skyDirection": 127,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 496,
                                "latitude": 51.52909075594,
                                "longitude": -0.12621465932,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Hunter Street, continue for 156 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Hunter Street",
                                "distance": 156,
                                "cumulativeDistance": 706,
                                "skyDirection": 157,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 636,
                                "latitude": 51.52607381582,
                                "longitude": -0.12368595418,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Brunswick Square, continue for 127 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Brunswick Square",
                                "distance": 127,
                                "cumulativeDistance": 833,
                                "skyDirection": 156,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 750,
                                "latitude": 51.52475739055,
                                "longitude": -0.12290395895,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Grenville Street, continue for 82 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Grenville Street",
                                "distance": 82,
                                "cumulativeDistance": 915,
                                "skyDirection": 162,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 824,
                                "latitude": 51.52371240309,
                                "longitude": -0.12222616375,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Guilford Street, continue for 67 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Guilford Street",
                                "distance": 67,
                                "cumulativeDistance": 982,
                                "skyDirection": 248,
                                "skyDirectionDescription": "West",
                                "cumulativeTravelTime": 884,
                                "latitude": 51.52301397738,
                                "longitude": -0.1218512707,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Queen Annes Walk, continue for 59 metres",
                                "turnDirection": "LEFT",
                                "streetName": "Queen Annes Walk",
                                "distance": 59,
                                "cumulativeDistance": 1041,
                                "skyDirection": 164,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 937,
                                "latitude": 51.52280361009,
                                "longitude": -0.12275366178,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Queen Square, continue for 138 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Queen Square",
                                "distance": 138,
                                "cumulativeDistance": 1179,
                                "skyDirection": 148,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 1063,
                                "latitude": 51.522287684940004,
                                "longitude": -0.12254424018,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Boswell Street, continue for 208 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Boswell Street",
                                "distance": 208,
                                "cumulativeDistance": 1387,
                                "skyDirection": 146,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 1249,
                                "latitude": 51.521193149,
                                "longitude": -0.12158023531,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Theobalds Road, continue for 83 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Theobalds Road",
                                "distance": 83,
                                "cumulativeDistance": 1470,
                                "skyDirection": 224,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 1323,
                                "latitude": 51.51957736707,
                                "longitude": -0.12007558538,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Southampton Row, continue for 167 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "Southampton Row",
                                "distance": 167,
                                "cumulativeDistance": 1637,
                                "skyDirection": 163,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 1473,
                                "latitude": 51.519069762790004,
                                "longitude": -0.12094690861,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Kingsway, continue for 551 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Kingsway",
                                "distance": 551,
                                "cumulativeDistance": 2188,
                                "skyDirection": 165,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 1971,
                                "latitude": 51.517621983450006,
                                "longitude": -0.1203867171,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Aldwych, continue for 221 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Aldwych",
                                "distance": 221,
                                "cumulativeDistance": 2409,
                                "skyDirection": 231,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 2170,
                                "latitude": 51.51301429637,
                                "longitude": -0.11792457919,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Lancaster Place, continue for 164 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "Lancaster Place",
                                "distance": 164,
                                "cumulativeDistance": 2573,
                                "skyDirection": 164,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 2317,
                                "latitude": 51.511282471929995,
                                "longitude": -0.11927857507,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Waterloo Bridge, continue for 594 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Waterloo Bridge",
                                "distance": 594,
                                "cumulativeDistance": 3167,
                                "skyDirection": 148,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 2855,
                                "latitude": 51.50995310357,
                                "longitude": -0.11825249437,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Waterloo Gardens, continue for 23 metres",
                                "turnDirection": "SLIGHT_RIGHT",
                                "streetName": "Waterloo Gardens",
                                "distance": 23,
                                "cumulativeDistance": 3190,
                                "skyDirection": 187,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 2877,
                                "latitude": 51.505307916270006,
                                "longitude": -0.11402013348000001,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 42 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "",
                                "distance": 42,
                                "cumulativeDistance": 3232,
                                "skyDirection": 204,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 2915,
                                "latitude": 51.5051019196,
                                "longitude": -0.11407186771000001,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to York Road, continue for 102 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "York Road",
                                "distance": 102,
                                "cumulativeDistance": 3334,
                                "skyDirection": 189,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 3007,
                                "latitude": 51.5047341644,
                                "longitude": -0.11413028008,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            }
                        ]
                    },
                    "obstacles": [],
                    "departureTime": "2024-03-12T16:38:00",
                    "arrivalTime": "2024-03-12T17:28:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000129",
                        "commonName": "King's Cross St. Pancras Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.53012123749,
                        "lon": -0.12486036494
                    },
                    "arrivalPoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000254",
                        "commonName": "Waterloo Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.50401045987,
                        "lon": -0.11498148193999999
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "lineString": "[[51.53012123749, -0.12486036494],[51.53010579856, -0.12493616469],[51.52996800467, -0.12483782652],[51.52985233045, -0.12491466613],[51.52956659507, -0.12560401577],[51.52946013713, -0.12569489138],[51.52935045614, -0.12558405881],[51.52931566082, -0.12565757365],[51.52928155607, -0.12577431141],[51.52909075594, -0.12621465932],[51.52900711460, -0.12604508900],[51.52863290909, -0.12570003141],[51.52844142778, -0.12553489297],[51.52824971599, -0.12535534856],[51.52735567174, -0.12455591322],[51.52711833440, -0.12433500274],[51.52690910842, -0.12418502101],[51.52672753326, -0.12407715308],[51.52607381582, -0.12368595418],[51.52543807031, -0.12329402727],[51.52475739055, -0.12290395895],[51.52436658638, -0.12264613444],[51.52394836067, -0.12236061134],[51.52378591014, -0.12232404760],[51.52371240309, -0.12222616375],[51.52334994113, -0.12205367618],[51.52301397738, -0.12185127070],[51.52280361009, -0.12275366178],[51.52228768494, -0.12254424018],[51.52186761406, -0.12214348807],[51.52138417433, -0.12171652127],[51.52119314900, -0.12158023531],[51.52100120068, -0.12138633036],[51.52071823241, -0.12112410091],[51.52059034333, -0.12099963500],[51.51957736707, -0.12007558538],[51.51937575415, -0.12040099578],[51.51929764464, -0.12057717949],[51.51906976279, -0.12094690861],[51.51829990189, -0.12060383943],[51.51811141419, -0.12062601221],[51.51804781562, -0.12058538947],[51.51762198345, -0.12038671710],[51.51737772958, -0.12029587917],[51.51711434819, -0.12013376323],[51.51665993931, -0.11983538356],[51.51661431366, -0.11979402301],[51.51637812230, -0.11964520582],[51.51558751296, -0.11913007844],[51.51530569485, -0.11893990938],[51.51494207304, -0.11869546259],[51.51476026196, -0.11857324063],[51.51407956696, -0.11818333020],[51.51334356437, -0.11770923824],[51.51318226806, -0.11774471125],[51.51301429637, -0.11792457919],[51.51290992378, -0.11814506063],[51.51263734703, -0.11853100286],[51.51235301036, -0.11874448332],[51.51203295787, -0.11897384399],[51.51167326303, -0.11897424885],[51.51128247193, -0.11927857507],[51.51121910385, -0.11925236197],[51.50995310357, -0.11825249437],[51.50985263354, -0.11815575717],[51.50973395915, -0.11804535960],[51.50914058572, -0.11749338028],[51.50895623046, -0.11721276493],[51.50863730690, -0.11695211094],[51.50736897423, -0.11580835547],[51.50726873362, -0.11572602968],[51.50711341654, -0.11557392585],[51.50697653524, -0.11544988253],[51.50691270353, -0.11539487601],[51.50673941287, -0.11524351615],[51.50662995385, -0.11514716312],[51.50619188555, -0.11474735525],[51.50610984887, -0.11467869225],[51.50581834266, -0.11444575922],[51.50530791627, -0.11402013348],[51.50510191960, -0.11407186771],[51.50502196659, -0.11413280686],[51.50473416440, -0.11413028008],[51.50462678851, -0.11416353207],[51.50455605357, -0.11423849917],[51.50440582845, -0.11440320338],[51.50425768650, -0.11469750372],[51.50411760457, -0.11493383270],[51.50402811601, -0.11503035697],[51.50401045987, -0.11498148194]]",
                        "stopPoints": [],
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
                        "id": "cycle",
                        "name": "cycle",
                        "type": "Mode",
                        "routeType": "Unknown",
                        "status": "Unknown",
                        "motType": "107",
                        "network": ""
                    },
                    "disruptions": [],
                    "plannedWorks": [],
                    "distance": 3334.0,
                    "isDisrupted": false,
                    "hasFixedLocations": true,
                    "scheduledDepartureTime": "2024-03-12T16:38:00",
                    "scheduledArrivalTime": "2024-03-12T17:28:00"
                }
            ]
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
            "startDateTime": "2024-03-12T16:38:00",
            "duration": 50,
            "arrivalDateTime": "2024-03-12T17:28:00",
            "description": "Scenario1 Walk",
            "alternativeRoute": false,
            "legs": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                    "duration": 50,
                    "instruction": {
                        "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                        "summary": "Walk to Waterloo Station",
                        "detailed": "Walk to Waterloo Station",
                        "steps": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "Euston Road Exit/Entrance for 17 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Euston Road Exit/Entrance",
                                "distance": 17,
                                "cumulativeDistance": 17,
                                "skyDirection": 155,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 15,
                                "latitude": 51.53010441584,
                                "longitude": -0.1249331431,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 99 metres",
                                "turnDirection": "SLIGHT_RIGHT",
                                "streetName": "",
                                "distance": 99,
                                "cumulativeDistance": 116,
                                "skyDirection": 201,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 105,
                                "latitude": 51.52996800467,
                                "longitude": -0.12483782652,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Euston Road, continue for 52 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Euston Road",
                                "distance": 52,
                                "cumulativeDistance": 168,
                                "skyDirection": 231,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 152,
                                "latitude": 51.529350456139994,
                                "longitude": -0.12558405881,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Judd Street, continue for 382 metres",
                                "turnDirection": "LEFT",
                                "streetName": "Judd Street",
                                "distance": 382,
                                "cumulativeDistance": 550,
                                "skyDirection": 127,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 496,
                                "latitude": 51.52909075594,
                                "longitude": -0.12621465932,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Hunter Street, continue for 156 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Hunter Street",
                                "distance": 156,
                                "cumulativeDistance": 706,
                                "skyDirection": 157,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 636,
                                "latitude": 51.52607381582,
                                "longitude": -0.12368595418,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Brunswick Square, continue for 127 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Brunswick Square",
                                "distance": 127,
                                "cumulativeDistance": 833,
                                "skyDirection": 156,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 750,
                                "latitude": 51.52475739055,
                                "longitude": -0.12290395895,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Grenville Street, continue for 82 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Grenville Street",
                                "distance": 82,
                                "cumulativeDistance": 915,
                                "skyDirection": 162,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 824,
                                "latitude": 51.52371240309,
                                "longitude": -0.12222616375,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Guilford Street, continue for 67 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Guilford Street",
                                "distance": 67,
                                "cumulativeDistance": 982,
                                "skyDirection": 248,
                                "skyDirectionDescription": "West",
                                "cumulativeTravelTime": 884,
                                "latitude": 51.52301397738,
                                "longitude": -0.1218512707,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Queen Annes Walk, continue for 59 metres",
                                "turnDirection": "LEFT",
                                "streetName": "Queen Annes Walk",
                                "distance": 59,
                                "cumulativeDistance": 1041,
                                "skyDirection": 164,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 937,
                                "latitude": 51.52280361009,
                                "longitude": -0.12275366178,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Queen Square, continue for 138 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Queen Square",
                                "distance": 138,
                                "cumulativeDistance": 1179,
                                "skyDirection": 148,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 1063,
                                "latitude": 51.522287684940004,
                                "longitude": -0.12254424018,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Boswell Street, continue for 208 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Boswell Street",
                                "distance": 208,
                                "cumulativeDistance": 1387,
                                "skyDirection": 146,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 1249,
                                "latitude": 51.521193149,
                                "longitude": -0.12158023531,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Theobalds Road, continue for 83 metres",
                                "turnDirection": "RIGHT",
                                "streetName": "Theobalds Road",
                                "distance": 83,
                                "cumulativeDistance": 1470,
                                "skyDirection": 224,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 1323,
                                "latitude": 51.51957736707,
                                "longitude": -0.12007558538,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Turn right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Southampton Row, continue for 167 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "Southampton Row",
                                "distance": 167,
                                "cumulativeDistance": 1637,
                                "skyDirection": 163,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 1473,
                                "latitude": 51.519069762790004,
                                "longitude": -0.12094690861,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Kingsway, continue for 551 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Kingsway",
                                "distance": 551,
                                "cumulativeDistance": 2188,
                                "skyDirection": 165,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 1971,
                                "latitude": 51.517621983450006,
                                "longitude": -0.1203867171,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Aldwych, continue for 221 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Aldwych",
                                "distance": 221,
                                "cumulativeDistance": 2409,
                                "skyDirection": 231,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 2170,
                                "latitude": 51.51301429637,
                                "longitude": -0.11792457919,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Lancaster Place, continue for 164 metres",
                                "turnDirection": "SLIGHT_LEFT",
                                "streetName": "Lancaster Place",
                                "distance": 164,
                                "cumulativeDistance": 2573,
                                "skyDirection": 164,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 2317,
                                "latitude": 51.511282471929995,
                                "longitude": -0.11927857507,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight left",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Waterloo Bridge, continue for 594 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "Waterloo Bridge",
                                "distance": 594,
                                "cumulativeDistance": 3167,
                                "skyDirection": 148,
                                "skyDirectionDescription": "SouthEast",
                                "cumulativeTravelTime": 2855,
                                "latitude": 51.50995310357,
                                "longitude": -0.11825249437,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to Waterloo Gardens, continue for 23 metres",
                                "turnDirection": "SLIGHT_RIGHT",
                                "streetName": "Waterloo Gardens",
                                "distance": 23,
                                "cumulativeDistance": 3190,
                                "skyDirection": 187,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 2877,
                                "latitude": 51.505307916270006,
                                "longitude": -0.11402013348000001,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Take a slight right",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "for 42 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "",
                                "distance": 42,
                                "cumulativeDistance": 3232,
                                "skyDirection": 204,
                                "skyDirectionDescription": "SouthWest",
                                "cumulativeTravelTime": 2915,
                                "latitude": 51.5051019196,
                                "longitude": -0.11407186771000001,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                                "description": "on to York Road, continue for 102 metres",
                                "turnDirection": "STRAIGHT",
                                "streetName": "York Road",
                                "distance": 102,
                                "cumulativeDistance": 3334,
                                "skyDirection": 189,
                                "skyDirectionDescription": "South",
                                "cumulativeTravelTime": 3007,
                                "latitude": 51.5047341644,
                                "longitude": -0.11413028008,
                                "pathAttribute": {
                                    "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                                },
                                "descriptionHeading": "Continue along ",
                                "trackType": "None"
                            }
                        ]
                    },
                    "obstacles": [],
                    "departureTime": "2024-03-12T16:38:00",
                    "arrivalTime": "2024-03-12T17:28:00",
                    "departurePoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000129",
                        "commonName": "King's Cross St. Pancras Underground Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.53012123749,
                        "lon": -0.12486036494
                    },
                    "arrivalPoint": {
                        "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                        "platformName": "",
                        "icsCode": "1000254",
                        "commonName": "Waterloo Station",
                        "placeType": "StopPoint",
                        "additionalProperties": [],
                        "lat": 51.50401045987,
                        "lon": -0.11498148193999999
                    },
                    "path": {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                        "lineString": "[[51.53012123749, -0.12486036494],[51.53010579856, -0.12493616469],[51.52996800467, -0.12483782652],[51.52985233045, -0.12491466613],[51.52956659507, -0.12560401577],[51.52946013713, -0.12569489138],[51.52935045614, -0.12558405881],[51.52931566082, -0.12565757365],[51.52928155607, -0.12577431141],[51.52909075594, -0.12621465932],[51.52900711460, -0.12604508900],[51.52863290909, -0.12570003141],[51.52844142778, -0.12553489297],[51.52824971599, -0.12535534856],[51.52735567174, -0.12455591322],[51.52711833440, -0.12433500274],[51.52690910842, -0.12418502101],[51.52672753326, -0.12407715308],[51.52607381582, -0.12368595418],[51.52543807031, -0.12329402727],[51.52475739055, -0.12290395895],[51.52436658638, -0.12264613444],[51.52394836067, -0.12236061134],[51.52378591014, -0.12232404760],[51.52371240309, -0.12222616375],[51.52334994113, -0.12205367618],[51.52301397738, -0.12185127070],[51.52280361009, -0.12275366178],[51.52228768494, -0.12254424018],[51.52186761406, -0.12214348807],[51.52138417433, -0.12171652127],[51.52119314900, -0.12158023531],[51.52100120068, -0.12138633036],[51.52071823241, -0.12112410091],[51.52059034333, -0.12099963500],[51.51957736707, -0.12007558538],[51.51937575415, -0.12040099578],[51.51929764464, -0.12057717949],[51.51906976279, -0.12094690861],[51.51829990189, -0.12060383943],[51.51811141419, -0.12062601221],[51.51804781562, -0.12058538947],[51.51762198345, -0.12038671710],[51.51737772958, -0.12029587917],[51.51711434819, -0.12013376323],[51.51665993931, -0.11983538356],[51.51661431366, -0.11979402301],[51.51637812230, -0.11964520582],[51.51558751296, -0.11913007844],[51.51530569485, -0.11893990938],[51.51494207304, -0.11869546259],[51.51476026196, -0.11857324063],[51.51407956696, -0.11818333020],[51.51334356437, -0.11770923824],[51.51318226806, -0.11774471125],[51.51301429637, -0.11792457919],[51.51290992378, -0.11814506063],[51.51263734703, -0.11853100286],[51.51235301036, -0.11874448332],[51.51203295787, -0.11897384399],[51.51167326303, -0.11897424885],[51.51128247193, -0.11927857507],[51.51121910385, -0.11925236197],[51.50995310357, -0.11825249437],[51.50985263354, -0.11815575717],[51.50973395915, -0.11804535960],[51.50914058572, -0.11749338028],[51.50895623046, -0.11721276493],[51.50863730690, -0.11695211094],[51.50736897423, -0.11580835547],[51.50726873362, -0.11572602968],[51.50711341654, -0.11557392585],[51.50697653524, -0.11544988253],[51.50691270353, -0.11539487601],[51.50673941287, -0.11524351615],[51.50662995385, -0.11514716312],[51.50619188555, -0.11474735525],[51.50610984887, -0.11467869225],[51.50581834266, -0.11444575922],[51.50530791627, -0.11402013348],[51.50510191960, -0.11407186771],[51.50502196659, -0.11413280686],[51.50473416440, -0.11413028008],[51.50462678851, -0.11416353207],[51.50455605357, -0.11423849917],[51.50440582845, -0.11440320338],[51.50425768650, -0.11469750372],[51.50411760457, -0.11493383270],[51.50402811601, -0.11503035697],[51.50401045987, -0.11498148194]]",
                        "stopPoints": [],
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
                        "motType": "100",
                        "network": ""
                    },
                    "disruptions": [],
                    "plannedWorks": [],
                    "distance": 3334.0,
                    "isDisrupted": false,
                    "hasFixedLocations": true,
                    "scheduledDepartureTime": "2024-03-12T16:38:00",
                    "scheduledArrivalTime": "2024-03-12T17:28:00"
                }
            ]
        }
    ],
    "lines": [
        {
            "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
            "id": "341",
            "name": "341",
            "modeName": "bus",
            "disruptions": [],
            "created": "2024-03-07T12:33:15.223Z",
            "modified": "2024-03-07T12:33:15.223Z",
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
                    "uri": "/Line/Route?ids=341&serviceTypes=Regular"
                }
            ],
            "crowding": {
                "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
            }
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
            "id": "63",
            "name": "63",
            "modeName": "bus",
            "disruptions": [],
            "created": "2024-03-07T12:33:15.223Z",
            "modified": "2024-03-07T12:33:15.223Z",
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
                    "uri": "/Line/Route?ids=63&serviceTypes=Regular"
                }
            ],
            "crowding": {
                "$type": "Tfl.Api.Presentation.Entities.Crowding, Tfl.Api.Presentation.Entities"
            }
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
            "id": "bakerloo",
            "name": "Bakerloo",
            "modeName": "tube",
            "disruptions": [],
            "created": "2024-03-07T12:33:15.223Z",
            "modified": "2024-03-07T12:33:15.223Z",
            "lineStatuses": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
                    "id": 0,
                    "lineId": "bakerloo",
                    "statusSeverity": 9,
                    "statusSeverityDescription": "Minor Delays",
                    "reason": "Bakerloo Line: Minor delays due to shortage of trains. ",
                    "created": "0001-01-01T00:00:00",
                    "validityPeriods": [
                        {
                            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
                            "fromDate": "2024-03-12T16:35:30Z",
                            "toDate": "2024-03-13T01:29:00Z",
                            "isNow": true
                        }
                    ],
                    "disruption": {
                        "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                        "category": "RealTime",
                        "categoryDescription": "RealTime",
                        "description": "Bakerloo Line: Minor delays due to shortage of trains. ",
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
                    "uri": "/Line/Route?ids=Bakerloo&serviceTypes=Regular"
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
            "created": "2024-03-07T12:33:15.223Z",
            "modified": "2024-03-07T12:33:15.223Z",
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
            "created": "2024-03-07T12:33:15.223Z",
            "modified": "2024-03-07T12:33:15.223Z",
            "lineStatuses": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
                    "id": 0,
                    "lineId": "piccadilly",
                    "statusSeverity": 9,
                    "statusSeverityDescription": "Minor Delays",
                    "reason": "Piccadilly Line: Minor delay due to an earlier signal failure at Chiswick Park. ",
                    "created": "0001-01-01T00:00:00",
                    "validityPeriods": [
                        {
                            "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
                            "fromDate": "2024-03-12T16:23:21Z",
                            "toDate": "2024-03-13T01:29:00Z",
                            "isNow": true
                        }
                    ],
                    "disruption": {
                        "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                        "category": "RealTime",
                        "categoryDescription": "RealTime",
                        "description": "Piccadilly Line: Minor delay due to an earlier signal failure at Chiswick Park. ",
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
            "id": "victoria",
            "name": "Victoria",
            "modeName": "tube",
            "disruptions": [],
            "created": "2024-03-07T12:33:15.207Z",
            "modified": "2024-03-07T12:33:15.207Z",
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
        }
    ],
    "stopMessages": [
        "Kings Cross St Pancras Station: Mini ramps are available at this station on the Circle, Hammersmith & City, Metropolitan, Northern and Victoria line platforms. They are designed to cover the small remaining step / or gap between the platform and the train on step-free to train platforms. They make it easier for customers people to get on and off the train, in particular for people whose mobility aids have small or swivel wheels. The ramps are quick and easy to use. Staff are trained to use them and will be happy to provide one for you to use. If you would like to use a mini ramp, please ask for help from staff or press the information button on a help point.",
        "Bus Stop Closed\\n\\n\\n",
        "WATERLOO STATION: The southbound Bakerloo line platform is step free to/from street level. Please note that due to the curve of the platform, the gap between platform and train exceeds the size that any boarding ramp can be safely used",
        "Waterloo Underground Station: Mini ramps are available at this station on the Jubilee line platforms. They are designed to cover the small remaining step / or gap between the platform and the train on step-free to train platforms. They make it easier for customers people to get on and off the train, in particular for people whose mobility aids have small or swivel wheels. The ramps are quick and easy to use. Staff are trained to use them and will be happy to provide one for you to use. If you would like to use a mini ramp, please ask for help from staff or press the information button on a help point."
    ],
    "recommendedMaxAgeMinutes": 1,
    "searchCriteria": {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.SearchCriteria, Tfl.Api.Presentation.Entities",
        "dateTime": "2024-03-12T16:38:00",
        "dateTimeType": "Departing",
        "timeAdjustments": {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustments, Tfl.Api.Presentation.Entities",
            "earliest": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustment, Tfl.Api.Presentation.Entities",
                "date": "20240312",
                "time": "0300",
                "timeIs": "departing",
                "uri": "/journey/journeyresults/1000129/to/1000254?app_id=e6c991d9%0a&app_key=f6fa116d76f34742a36211a6eeeed24a&usemultimodalcall=true&includealternativeroutes=false&routebetweenentrances=true&time=0300&date=20240312&timeIs=departing"
            },
            "earlier": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustment, Tfl.Api.Presentation.Entities",
                "date": "20240312",
                "time": "1623",
                "timeIs": "departing",
                "uri": "/journey/journeyresults/1000129/to/1000254?app_id=e6c991d9%0a&app_key=f6fa116d76f34742a36211a6eeeed24a&usemultimodalcall=true&includealternativeroutes=false&routebetweenentrances=true&time=1623&date=20240312&timeIs=departing"
            },
            "later": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustment, Tfl.Api.Presentation.Entities",
                "date": "20240312",
                "time": "1642",
                "timeIs": "departing",
                "uri": "/journey/journeyresults/1000129/to/1000254?app_id=e6c991d9%0a&app_key=f6fa116d76f34742a36211a6eeeed24a&usemultimodalcall=true&includealternativeroutes=false&routebetweenentrances=true&time=1642&date=20240312&timeIs=departing"
            },
            "latest": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustment, Tfl.Api.Presentation.Entities",
                "date": "20240313",
                "time": "0300",
                "timeIs": "departing",
                "uri": "/journey/journeyresults/1000129/to/1000254?app_id=e6c991d9%0a&app_key=f6fa116d76f34742a36211a6eeeed24a&usemultimodalcall=true&includealternativeroutes=false&routebetweenentrances=true&time=0300&date=20240313&timeIs=departing"
            }
        }
    },
    "journeyVector": {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.JourneyVector, Tfl.Api.Presentation.Entities",
        "from": "1000129",
        "to": "1000254",
        "via": "",
        "uri": "/journey/journeyresults/1000129/to/1000254?app_id=e6c991d9%0a&app_key=f6fa116d76f34742a36211a6eeeed24a&usemultimodalcall=true&includealternativeroutes=false&routebetweenentrances=true"
    }
}
"""#
