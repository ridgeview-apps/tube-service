let journeyByBikeJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-02-22T12:23:00",
    "duration": 15,
    "arrivalDateTime": "2024-02-22T12:38:00",
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
                        "description": "on to Gordon Square, continue for 16 metres",
                        "turnDirection": "STRAIGHT",
                        "streetName": "Gordon Square",
                        "distance": 16,
                        "cumulativeDistance": 1048,
                        "skyDirection": 235,
                        "skyDirectionDescription": "SouthWest",
                        "cumulativeTravelTime": 177,
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
                        "description": "on to Woburn Square, continue for 96 metres",
                        "turnDirection": "LEFT",
                        "streetName": "Woburn Square",
                        "distance": 96,
                        "cumulativeDistance": 1144,
                        "skyDirection": 143,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 194,
                        "latitude": 51.523799125139995,
                        "longitude": -0.12990600249,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Turn left",
                        "trackType": "QuietRoad"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "for 121 metres",
                        "turnDirection": "STRAIGHT",
                        "streetName": "",
                        "distance": 121,
                        "cumulativeDistance": 1265,
                        "skyDirection": 146,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 209,
                        "latitude": 51.52309406018,
                        "longitude": -0.12911322376,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Continue along ",
                        "trackType": "QuietRoad"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "on to Thornhaugh Street, continue for 33 metres",
                        "turnDirection": "STRAIGHT",
                        "streetName": "Thornhaugh Street",
                        "distance": 33,
                        "cumulativeDistance": 1298,
                        "skyDirection": 136,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 213,
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
                        "cumulativeDistance": 1489,
                        "skyDirection": 142,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 236,
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
                        "cumulativeDistance": 1710,
                        "skyDirection": 142,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 263,
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
                        "cumulativeDistance": 1967,
                        "skyDirection": 232,
                        "skyDirectionDescription": "SouthWest",
                        "cumulativeTravelTime": 301,
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
                        "cumulativeDistance": 2078,
                        "skyDirection": 152,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 341,
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
                        "cumulativeDistance": 2159,
                        "skyDirection": 148,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 370,
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
                        "cumulativeDistance": 2211,
                        "skyDirection": 149,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 389,
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
                        "cumulativeDistance": 2221,
                        "skyDirection": 253,
                        "skyDirectionDescription": "West",
                        "cumulativeTravelTime": 393,
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
                        "cumulativeDistance": 2532,
                        "skyDirection": 166,
                        "skyDirectionDescription": "South",
                        "cumulativeTravelTime": 477,
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
                        "cumulativeDistance": 2543,
                        "skyDirection": 45,
                        "skyDirectionDescription": "NorthEast",
                        "cumulativeTravelTime": 478,
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
                        "cumulativeDistance": 2595,
                        "skyDirection": 125,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 484,
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
                        "cumulativeDistance": 2604,
                        "skyDirection": 122,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 485,
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
                        "cumulativeDistance": 2733,
                        "skyDirection": 130,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 500,
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
                        "cumulativeDistance": 2933,
                        "skyDirection": 142,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 524,
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
                        "cumulativeDistance": 2941,
                        "skyDirection": 150,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 525,
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
                        "cumulativeDistance": 3109,
                        "skyDirection": 111,
                        "skyDirectionDescription": "East",
                        "cumulativeTravelTime": 545,
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
                        "cumulativeDistance": 3704,
                        "skyDirection": 151,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 617,
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
                        "cumulativeDistance": 3727,
                        "skyDirection": 128,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 620,
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
                        "cumulativeDistance": 3807,
                        "skyDirection": 90,
                        "skyDirectionDescription": "East",
                        "cumulativeTravelTime": 630,
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
                        "cumulativeDistance": 4004,
                        "skyDirection": 156,
                        "skyDirectionDescription": "SouthEast",
                        "cumulativeTravelTime": 676,
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
            "departureTime": "2024-02-22T12:23:00",
            "arrivalTime": "2024-02-22T12:38:00",
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
                "lineString": "[[51.53008206850, -0.12409785297],[51.53006420625, -0.12414309970],[51.53004831534, -0.12412961634],[51.53004658293, -0.12412814640],[51.53000303236, -0.12421644074],[51.52982606503, -0.12439672238],[51.52952328065, -0.12514444418],[51.52935045614, -0.12558405881],[51.52931566082, -0.12565757365],[51.52928155607, -0.12577431141],[51.52909075594, -0.12621465932],[51.52900711460, -0.12604508900],[51.52863290909, -0.12570003141],[51.52796002530, -0.12748650434],[51.52754020076, -0.12710006498],[51.52691046165, -0.12652041914],[51.52625329960, -0.12591308268],[51.52568046749, -0.12551853959],[51.52522235880, -0.12667620517],[51.52470271162, -0.12792286537],[51.52446788907, -0.12842262700],[51.52426878105, -0.12890650387],[51.52387701890, -0.12971541081],[51.52379912514, -0.12990600249],[51.52309406018, -0.12911322376],[51.52306664074, -0.12908551725],[51.52212814793, -0.12831674961],[51.52190718150, -0.12799426938],[51.52178805622, -0.12785500699],[51.52154911530, -0.12753326864],[51.52110901762, -0.12700356789],[51.52093551138, -0.12683771284],[51.52053181735, -0.12633536031],[51.51980783497, -0.12548581204],[51.51893683631, -0.12444053542],[51.51878913071, -0.12476370747],[51.51842550697, -0.12564346523],[51.51822663981, -0.12614169338],[51.51800265102, -0.12675625645],[51.51790010203, -0.12709197527],[51.51778302801, -0.12764449071],[51.51731850099, -0.12727438061],[51.51729131111, -0.12726108254],[51.51689913600, -0.12691683832],[51.51666180309, -0.12669596464],[51.51625234338, -0.12639567820],[51.51604242962, -0.12620251086],[51.51583320593, -0.12605255558],[51.51580854720, -0.12619769636],[51.51552812085, -0.12609390252],[51.51525368920, -0.12580249880],[51.51481750560, -0.12495564907],[51.51455090636, -0.12459187251],[51.51429329263, -0.12422773101],[51.51379603512, -0.12349872170],[51.51375709290, -0.12331296307],[51.51382714213, -0.12319478606],[51.51354763199, -0.12258655142],[51.51350085453, -0.12247317748],[51.51317686893, -0.12189560489],[51.51265356028, -0.12122535770],[51.51204844532, -0.12050084583],[51.51182307200, -0.11990483362],[51.51173872941, -0.11969213214],[51.51134630188, -0.11933359218],[51.51128247193, -0.11927857507],[51.51123453656, -0.11909320053],[51.51001300576, -0.11806268238],[51.50991276668, -0.11798034698],[51.50979432324, -0.11788435119],[51.50906430074, -0.11722272035],[51.50895623046, -0.11721276493],[51.50863730690, -0.11695211094],[51.50736897423, -0.11580835547],[51.50726873362, -0.11572602968],[51.50711341654, -0.11557392585],[51.50697653524, -0.11544988253],[51.50691270353, -0.11539487601],[51.50673941287, -0.11524351615],[51.50662995385, -0.11514716312],[51.50619188555, -0.11474735525],[51.50610984887, -0.11467869225],[51.50581834266, -0.11444575922],[51.50530791627, -0.11402013348],[51.50517793565, -0.11376612877],[51.50517724084, -0.11372292884],[51.50510947073, -0.11342312769],[51.50504332155, -0.11322412693],[51.50469191836, -0.11318100491],[51.50440110436, -0.11299128769],[51.50434255073, -0.11270552113],[51.50418282640, -0.11227984381],[51.50407243786, -0.11212590473],[51.50376133080, -0.11179294452],[51.50371547059, -0.11173720393],[51.50344952720, -0.11141679059],[51.50340660635, -0.11136444971],[51.50336035713, -0.11146370422]]",
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
            "distance": 4004.0,
            "isDisrupted": false,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-22T12:23:00",
            "scheduledArrivalTime": "2024-02-22T12:38:00"
        }
    ]
}
"""#
