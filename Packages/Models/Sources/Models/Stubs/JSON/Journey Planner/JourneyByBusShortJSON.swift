let journeyByBusShortJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-02-22T12:28:00",
    "duration": 33,
    "arrivalDateTime": "2024-02-22T13:01:00",
    "description": "Scenario1 Bus Only",
    "alternativeRoute": false,
    "legs": [
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 1,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "73 bus to St Pancras International",
                "detailed": "73 bus towards Oxford Circus",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-22T12:28:00",
            "arrivalTime": "2024-02-22T12:29:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "490G00129R",
                "platformName": "",
                "stopLetter": "R",
                "icsCode": "1000129",
                "individualStopId": "490000129R",
                "commonName": "King's Cross Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.53046616561,
                "lon": -0.12168875732000001
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "490G01276S",
                "platformName": "A",
                "stopLetter": "A",
                "icsCode": "1001276",
                "individualStopId": "490004722A",
                "commonName": "St Pancras International Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.52946659757,
                "lon": -0.12497376659
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.53053520456, -0.12164383648],[51.53056663291, -0.12178554489],[51.53058991915, -0.12267847458],[51.53033829951, -0.12325110701],[51.53007861217, -0.12388173427],[51.52998275514, -0.12407310067],[51.52982606503, -0.12439672238],[51.52955177560, -0.12507407723]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G01276S",
                        "name": "St Pancras International Station",
                        "uri": "/StopPoint/490G01276S",
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
                    "name": "73",
                    "directions": [
                        "Oxford Circus"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "73",
                        "name": "73",
                        "uri": "/Line/73",
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
            "scheduledDepartureTime": "2024-02-22T12:28:00",
            "scheduledArrivalTime": "2024-02-22T12:29:00",
            "interChangeDuration": "2",
            "interChangePosition": "AFTER"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 28,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "1 bus to Waterloo Station / Waterloo Road",
                "detailed": "1 bus towards Canada Water",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-22T12:31:00",
            "arrivalTime": "2024-02-22T12:59:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "490G01276S",
                "platformName": "S",
                "stopLetter": "S",
                "icsCode": "1001276",
                "individualStopId": "490001276S",
                "commonName": "St Pancras International Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.53159707297,
                "lon": -0.1271786677
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
                "lineString": "[[51.53157071669, -0.12731601641],[51.53069197059, -0.12681212110],[51.53047491152, -0.12673452582],[51.52927324972, -0.12638017186],[51.52909075594, -0.12621465932],[51.52871122084, -0.12722501171],[51.52859876492, -0.12750354773],[51.52841648489, -0.12791469844],[51.52825291872, -0.12832582713],[51.52825291872, -0.12832582713],[51.52816575847, -0.12854490446],[51.52795005595, -0.12911600095],[51.52775970241, -0.12958513667],[51.52745757306, -0.13037601209],[51.52737898958, -0.13052339644],[51.52731654238, -0.13055478737],[51.52723612190, -0.13058691440],[51.52709164696, -0.13054958278],[51.52689971302, -0.13035561530],[51.52677015367, -0.13020503333],[51.52677015367, -0.13020503333],[51.52643243800, -0.12981252412],[51.52581815768, -0.12907364477],[51.52520571177, -0.12845003651],[51.52488642307, -0.12811540321],[51.52488642307, -0.12811540321],[51.52470271162, -0.12792286537],[51.52384164057, -0.12693468709],[51.52332976666, -0.12634788615],[51.52332976666, -0.12634788615],[51.52283401358, -0.12577958135],[51.52221003121, -0.12499796676],[51.52187983458, -0.12459350051],[51.52161369470, -0.12425848136],[51.52149433470, -0.12410482451],[51.52102668504, -0.12356257525],[51.52102668504, -0.12356257525],[51.52079798770, -0.12329740110],[51.51989908764, -0.12219563474],[51.51976175182, -0.12204272836],[51.51940435483, -0.12162500971],[51.51916355143, -0.12118808532],[51.51906976279, -0.12094690861],[51.51857118903, -0.12072473039],[51.51857118903, -0.12072473039],[51.51829990189, -0.12060383943],[51.51811141419, -0.12062601221],[51.51804781562, -0.12058538947],[51.51762198345, -0.12038671710],[51.51737772958, -0.12029587917],[51.51711434819, -0.12013376323],[51.51671571498, -0.11987200734],[51.51671571498, -0.11987200734],[51.51665993931, -0.11983538356],[51.51661431366, -0.11979402301],[51.51637812230, -0.11964520582],[51.51558751296, -0.11913007844],[51.51530569485, -0.11893990938],[51.51494207304, -0.11869546259],[51.51476026196, -0.11857324063],[51.51465840582, -0.11839007480],[51.51416712191, -0.11803559816],[51.51336728799, -0.11750649068],[51.51316888958, -0.11747143369],[51.51301429637, -0.11792457919],[51.51290992378, -0.11814506063],[51.51263734703, -0.11853100286],[51.51235301036, -0.11874448332],[51.51226465711, -0.11880780068],[51.51226465711, -0.11880780068],[51.51203295787, -0.11897384399],[51.51167326303, -0.11897424885],[51.51128247193, -0.11927857507],[51.51123453656, -0.11909320053],[51.51001300576, -0.11806268238],[51.50991276668, -0.11798034698],[51.50979432324, -0.11788435119],[51.50906430074, -0.11722272035],[51.50895623046, -0.11721276493],[51.50863730690, -0.11695211094],[51.50736897423, -0.11580835547],[51.50726873362, -0.11572602968],[51.50711341654, -0.11557392585],[51.50697653524, -0.11544988253],[51.50691270353, -0.11539487601],[51.50673941287, -0.11524351615],[51.50662995385, -0.11514716312],[51.50646519561, -0.11499679366],[51.50646519561, -0.11499679366],[51.50619188555, -0.11474735525],[51.50610984887, -0.11467869225],[51.50581834266, -0.11444575922],[51.50530791627, -0.11402013348],[51.50517793565, -0.11376612877],[51.50517724084, -0.11372292884],[51.50510947073, -0.11342312769],[51.50504332155, -0.11322412693],[51.50469191836, -0.11318100491],[51.50440110436, -0.11299128769],[51.50434255073, -0.11270552113],[51.50418282640, -0.11227984381],[51.50407243786, -0.11212590473],[51.50376133080, -0.11179294452],[51.50371547059, -0.11173720393],[51.50348545155, -0.11146007262]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00009498",
                        "name": "British Library",
                        "uri": "/StopPoint/490G00009498",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00012867",
                        "name": "Upper Woburn Place / Euston Road",
                        "uri": "/StopPoint/490G00012867",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00013170",
                        "name": "Tavistock Square",
                        "uri": "/StopPoint/490G00013170",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
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
                        "id": "490G00005624",
                        "name": "Southampton Row",
                        "uri": "/StopPoint/490G00005624",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00013478",
                        "name": "Southampton Row / Theobald's Road",
                        "uri": "/StopPoint/490G00013478",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00000350",
                        "name": "Kingsway / Holborn Station",
                        "uri": "/StopPoint/490G00000350",
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
                    "name": "1",
                    "directions": [
                        "Canada Water"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "1",
                        "name": "1",
                        "uri": "/Line/1",
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
            "disruptions": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                    "category": "PlannedWork",
                    "type": "lineInfo",
                    "categoryDescription": "PlannedWork",
                    "description": "EVERSHOLT STREET, NW1: Route 1 is on diversion in both directions from Monday 13 November 08:00 to Monday 15 April 18:30 due to Thames Water works. Buses towards Canada Water will not serve stops 'Mornington Cres Stn/Camden Tb Library'(G) to 'Euston Station'(B). Buses towards South End Green will not serve stop 'Mornington Cres Stn/Camden Tb Library'(F). Please allow extra time for your journey.",
                    "summary": "CE23/44284 C EVERSHOLT STREET, NW1 - ROUTE 1 - THAMES WATER WORKS",
                    "additionalInfo": "",
                    "created": "2023-11-02T09:19:00",
                    "lastUpdate": "2023-11-02T09:28:00"
                }
            ],
            "plannedWorks": [],
            "isDisrupted": true,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-22T12:31:00",
            "scheduledArrivalTime": "2024-02-22T12:59:00"
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
            "obstacles": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "WALKWAY",
                    "incline": "LEVEL",
                    "stopId": 1003705,
                    "position": "IDEST"
                }
            ],
            "departureTime": "2024-02-22T12:59:00",
            "arrivalTime": "2024-02-22T13:01:00",
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
            "scheduledDepartureTime": "2024-02-22T12:59:00",
            "scheduledArrivalTime": "2024-02-22T13:01:00",
            "interChangeDuration": "2",
            "interChangePosition": "IDEST"
        }
    ]
}
"""#
