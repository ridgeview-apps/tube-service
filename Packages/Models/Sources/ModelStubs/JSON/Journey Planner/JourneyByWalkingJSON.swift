let journeyByWalkingJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-02-22T12:23:00",
    "duration": 50,
    "arrivalDateTime": "2024-02-22T13:13:00",
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
            "departureTime": "2024-02-22T12:23:00",
            "arrivalTime": "2024-02-22T13:13:00",
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
            "scheduledDepartureTime": "2024-02-22T12:23:00",
            "scheduledArrivalTime": "2024-02-22T13:13:00"
        }
    ]
}
"""#
