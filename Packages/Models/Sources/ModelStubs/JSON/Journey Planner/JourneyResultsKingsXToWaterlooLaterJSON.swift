let journeyResultsKingsXToWaterlooLaterJSON = #"""
    {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.ItineraryResult, Tfl.Api.Presentation.Entities",
        "journeys": [
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
                "startDateTime": "2026-05-29T14:53:00",
                "duration": 14,
                "arrivalDateTime": "2026-05-29T15:07:00",
                "alternativeRoute": false,
                "legs": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                        "duration": 5,
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
                        "departureTime": "2026-05-29T14:53:00",
                        "arrivalTime": "2026-05-29T14:58:00",
                        "departurePoint": {
                            "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                            "naptanId": "940GZZLUKSX",
                            "platformName": "",
                            "icsCode": "1000129",
                            "individualStopId": "9400ZZLUKSX2",
                            "commonName": "King's Cross St. Pancras Underground Station",
                            "placeType": "StopPoint",
                            "additionalProperties": [],
                            "lat": 51.530960898624,
                            "lon": -0.12225951825999999
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
                            "lat": 51.51577881206,
                            "lon": -0.141851269513
                        },
                        "path": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                            "lineString": "[[51.53096127449, -0.12224817133],[51.53087511499, -0.12253510895],[51.53068087051, -0.12322029411],[51.53047425273, -0.12404294838],[51.53037483412, -0.12457399411],[51.53024512895, -0.12545518374],[51.53003678947, -0.12682978724],[51.52988786467, -0.12774736294],[51.52975418564, -0.12845987041],[51.52955750096, -0.12923666217],[51.52934693924, -0.12997249438],[51.52916957421, -0.13051766363],[51.52898861917, -0.13105778548],[51.52883545305, -0.13153044720],[51.52848030939, -0.13268459854],[51.52844565616, -0.13279721216],[51.52838973228, -0.13300119170],[51.52829446783, -0.13331548263],[51.52820659137, -0.13355724205],[51.52796143154, -0.13413225848],[51.52773632218, -0.13453763049],[51.52728115651, -0.13553525790],[51.52714050249, -0.13578348823],[51.52667979889, -0.13643316259],[51.52633389199, -0.13683724377],[51.52588156265, -0.13732941921],[51.52536812563, -0.13792628636],[51.52482198916, -0.13860476888],[51.52450871583, -0.13901440562],[51.52424498968, -0.13930257401],[51.52402715185, -0.13954059797],[51.52350411838, -0.14014544637],[51.52310158234, -0.14058017510],[51.52241568847, -0.14123602871],[51.52219220773, -0.14139951180],[51.52190211706, -0.14156455187],[51.52165953271, -0.14165745637],[51.52142471643, -0.14179227848],[51.52117968882, -0.14191828948],[51.52074310987, -0.14207198696],[51.52028180214, -0.14222005716],[51.51989776048, -0.14231265691],[51.51868788171, -0.14220866950],[51.51765232663, -0.14222702551],[51.51713322366, -0.14219510705],[51.51664397578, -0.14208371117],[51.51607117600, -0.14189212263],[51.51578549727, -0.14180687142]]",
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
                        "disruptions": [],
                        "plannedWorks": [],
                        "distance": 32.0,
                        "isDisrupted": false,
                        "hasFixedLocations": true,
                        "scheduledDepartureTime": "2026-05-29T14:53:00",
                        "scheduledArrivalTime": "2026-05-29T14:58:00",
                        "interChangeDuration": "2",
                        "interChangePosition": "AFTER"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                        "duration": 7,
                        "instruction": {
                            "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                            "summary": "Bakerloo line to Waterloo",
                            "detailed": "Bakerloo line towards Elephant & Castle",
                            "steps": []
                        },
                        "obstacles": [],
                        "departureTime": "2026-05-29T15:00:00",
                        "arrivalTime": "2026-05-29T15:07:00",
                        "departurePoint": {
                            "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                            "naptanId": "940GZZLUOXC",
                            "platformName": "",
                            "icsCode": "1000173",
                            "individualStopId": "9400ZZLUOXC3",
                            "commonName": "Oxford Circus Underground Station",
                            "placeType": "StopPoint",
                            "additionalProperties": [],
                            "lat": 51.515727173562,
                            "lon": -0.14199749916999999
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
                            "lat": 51.503125839461994,
                            "lon": -0.114773036163
                        },
                        "path": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                            "lineString": "[[51.51572487769, -0.14201161233],[51.51566681203, -0.14199044301],[51.51547708492, -0.14193460335],[51.51525325568, -0.14187179256],[51.51509281571, -0.14183119237],[51.51483152587, -0.14175376506],[51.51451351482, -0.14162661815],[51.51415512739, -0.14136895535],[51.51393309254, -0.14123214109],[51.51369247091, -0.14105169530],[51.51350476513, -0.14089647996],[51.51327744059, -0.14068696029],[51.51299525761, -0.14043182893],[51.51237777586, -0.13986119206],[51.51214318172, -0.13965269929],[51.51161791914, -0.13920990248],[51.51128733798, -0.13890848333],[51.51105598884, -0.13870058858],[51.51035879820, -0.13811696371],[51.51024198635, -0.13798107386],[51.51019251735, -0.13789547151],[51.51014122398, -0.13778558904],[51.51006058276, -0.13756608273],[51.51003651016, -0.13748852435],[51.51000816612, -0.13738548865],[51.50998318890, -0.13727928943],[51.50995233040, -0.13711986541],[51.50992710257, -0.13694695379],[51.50990870894, -0.13677405174],[51.50990001308, -0.13644180095],[51.50990712645, -0.13621035841],[51.50994156128, -0.13582518813],[51.51002107184, -0.13522662301],[51.50991629880, -0.13570113191],[51.50997676412, -0.13528477928],[51.50998431488, -0.13519279161],[51.50999868595, -0.13501771263],[51.51003468882, -0.13366866664],[51.51002956459, -0.13347663287],[51.51000028329, -0.13329798005],[51.50993490231, -0.13315639836],[51.50983438465, -0.13299939265],[51.50965832409, -0.13277990650],[51.50949107714, -0.13261698455],[51.50920185250, -0.13237820730],[51.50804018435, -0.13148528792],[51.50785349459, -0.13125356982],[51.50771640692, -0.13100829554],[51.50764800614, -0.13080718908],[51.50758068833, -0.13021710582],[51.50750740398, -0.12971545928],[51.50744036923, -0.12911528061],[51.50741912561, -0.12831926577],[51.50740996132, -0.12807488115],[51.50741912561, -0.12831926577],[51.50744036923, -0.12911528061],[51.50750740398, -0.12971545928],[51.50758068833, -0.13021710582],[51.50764800614, -0.13080718908],[51.50771640692, -0.13100829554],[51.50785349459, -0.13125356982],[51.50804018435, -0.13148528792],[51.50920185250, -0.13237820730],[51.50949107714, -0.13261698455],[51.50965832409, -0.13277990650],[51.50983438465, -0.13299939265],[51.50993490231, -0.13315639836],[51.51000028329, -0.13329798005],[51.51002956459, -0.13347663287],[51.51003468882, -0.13366866664],[51.50999868595, -0.13501771263],[51.50997676412, -0.13528477928],[51.50991629880, -0.13570113191],[51.51002107184, -0.13522662301],[51.51003512954, -0.13502487098],[51.51006955205, -0.13367257396],[51.51006960667, -0.13346692611],[51.51004031990, -0.13327098012],[51.50997110351, -0.13311442356],[51.50986755371, -0.13295336260],[51.50968641512, -0.13272558165],[51.50952000070, -0.13255282636],[51.50923161454, -0.13231588848],[51.50809037166, -0.13144634396],[51.50789672730, -0.13121836883],[51.50776363729, -0.13097566879],[51.50770690251, -0.13081818025],[51.50768156255, -0.13063318038],[51.50759135237, -0.12968464207],[51.50754462252, -0.12913406647],[51.50753188186, -0.12833553981],[51.50752148557, -0.12798277060],[51.50750275222, -0.12773308837],[51.50747431848, -0.12751795630],[51.50739750066, -0.12697596730],[51.50731899582, -0.12652555399],[51.50720773260, -0.12593858106],[51.50663379357, -0.12298416472],[51.50660239149, -0.12286389011],[51.50660239540, -0.12286388750],[51.50311609539, -0.11475058749]]",
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
                        "disruptions": [],
                        "plannedWorks": [],
                        "distance": 683.0,
                        "isDisrupted": false,
                        "hasFixedLocations": true,
                        "scheduledDepartureTime": "2026-05-29T15:00:00",
                        "scheduledArrivalTime": "2026-05-29T15:07:00"
                    }
                ],
                "fare": {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.JourneyFare, Tfl.Api.Presentation.Entities",
                    "totalCost": 300,
                    "fares": [
                        {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Fare, Tfl.Api.Presentation.Entities",
                            "lowZone": 1,
                            "highZone": 1,
                            "cost": 300,
                            "chargeProfileName": "Normal",
                            "isHopperFare": false,
                            "chargeLevel": "Off Peak",
                            "peak": 310,
                            "offPeak": 300,
                            "taps": [
                                {
                                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                                    "atcoCode": "940GZZLUKSX",
                                    "tapDetails": {
                                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                                        "modeType": "Rail",
                                        "validationType": "None",
                                        "hostDeviceType": "Gate",
                                        "nationalLocationCode": 772,
                                        "tapTimestamp": "2026-05-29T15:53:00+01:00"
                                    }
                                },
                                {
                                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                                    "atcoCode": "940GZZLUWLO",
                                    "tapDetails": {
                                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                                        "modeType": "Rail",
                                        "validationType": "None",
                                        "hostDeviceType": "Gate",
                                        "nationalLocationCode": 747,
                                        "tapTimestamp": "2026-05-29T16:07:00+01:00"
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
            },
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
                "startDateTime": "2026-05-29T14:56:00",
                "duration": 14,
                "arrivalDateTime": "2026-05-29T15:10:00",
                "alternativeRoute": false,
                "legs": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                        "duration": 1,
                        "instruction": {
                            "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                            "summary": "Victoria line to Euston",
                            "detailed": "Victoria line towards Brixton",
                            "steps": []
                        },
                        "obstacles": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                                "type": "ESCALATOR",
                                "incline": "UP",
                                "stopId": 1000077,
                                "position": "AFTER"
                            },
                            {
                                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                                "type": "STAIRS",
                                "incline": "DOWN",
                                "stopId": 1000077,
                                "position": "AFTER"
                            }
                        ],
                        "departureTime": "2026-05-29T14:56:00",
                        "arrivalTime": "2026-05-29T14:57:00",
                        "departurePoint": {
                            "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                            "naptanId": "940GZZLUKSX",
                            "platformName": "",
                            "icsCode": "1000129",
                            "individualStopId": "9400ZZLUKSX2",
                            "commonName": "King's Cross St. Pancras Underground Station",
                            "placeType": "StopPoint",
                            "additionalProperties": [],
                            "lat": 51.530960898624,
                            "lon": -0.12225951825999999
                        },
                        "arrivalPoint": {
                            "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                            "naptanId": "940GZZLUEUS",
                            "platformName": "",
                            "icsCode": "1000077",
                            "individualStopId": "9400ZZLUEUS6",
                            "commonName": "Euston Underground Station",
                            "placeType": "StopPoint",
                            "additionalProperties": [],
                            "lat": 51.528501712476995,
                            "lon": -0.132697604835
                        },
                        "path": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                            "lineString": "[[51.53096127449, -0.12224817133],[51.53087511499, -0.12253510895],[51.53068087051, -0.12322029411],[51.53047425273, -0.12404294838],[51.53037483412, -0.12457399411],[51.53024512895, -0.12545518374],[51.53003678947, -0.12682978724],[51.52988786467, -0.12774736294],[51.52975418564, -0.12845987041],[51.52955750096, -0.12923666217],[51.52934693924, -0.12997249438],[51.52916957421, -0.13051766363],[51.52898861917, -0.13105778548],[51.52883545305, -0.13153044720],[51.52848030939, -0.13268459854]]",
                            "stopPoints": [
                                {
                                    "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                    "id": "940GZZLUEUS",
                                    "name": "Euston Underground Station",
                                    "uri": "/StopPoint/940GZZLUEUS",
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
                        "disruptions": [],
                        "plannedWorks": [],
                        "distance": 89.0,
                        "isDisrupted": false,
                        "hasFixedLocations": true,
                        "scheduledDepartureTime": "2026-05-29T14:56:00",
                        "scheduledArrivalTime": "2026-05-29T14:57:00",
                        "interChangeDuration": "4",
                        "interChangePosition": "AFTER"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                        "duration": 9,
                        "instruction": {
                            "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                            "summary": "Northern line to Waterloo",
                            "detailed": "Northern line towards Battersea Power Station via Charing Cross",
                            "steps": []
                        },
                        "obstacles": [],
                        "departureTime": "2026-05-29T15:01:00",
                        "arrivalTime": "2026-05-29T15:10:00",
                        "departurePoint": {
                            "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                            "naptanId": "940GZZLUEUS",
                            "platformName": "",
                            "icsCode": "1000077",
                            "individualStopId": "9400ZZLUEUS5",
                            "commonName": "Euston Underground Station",
                            "placeType": "StopPoint",
                            "additionalProperties": [],
                            "lat": 51.528111940068,
                            "lon": -0.134198477225
                        },
                        "arrivalPoint": {
                            "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                            "naptanId": "940GZZLUWLO",
                            "platformName": "",
                            "icsCode": "1000254",
                            "individualStopId": "9400ZZLUWLO7",
                            "commonName": "Waterloo Underground Station",
                            "placeType": "StopPoint",
                            "additionalProperties": [],
                            "lat": 51.502858702770006,
                            "lon": -0.113818671132
                        },
                        "path": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                            "lineString": "[[51.52812552920, -0.13421165264],[51.52810045154, -0.13424508047],[51.52787613634, -0.13465517822],[51.52764335524, -0.13519464634],[51.52676499316, -0.13743752851],[51.52662629192, -0.13779768480],[51.52656102371, -0.13795171840],[51.52649495743, -0.13807248262],[51.52637265618, -0.13822523777],[51.52623543463, -0.13832180105],[51.52606678261, -0.13836443204],[51.52586635969, -0.13834867618],[51.52568049934, -0.13829859309],[51.52460572114, -0.13774937140],[51.52433416050, -0.13761989917],[51.52431097469, -0.13760426645],[51.52371341728, -0.13720137737],[51.52293956374, -0.13650758935],[51.52068068940, -0.13435300368],[51.52055245915, -0.13423070105],[51.51864016395, -0.13222808327],[51.51706806734, -0.13077006841],[51.51613105274, -0.13025698959],[51.51596428432, -0.13018024934],[51.51531076274, -0.12987952995],[51.51523949615, -0.12984281399],[51.51422858201, -0.12956239027],[51.51350429258, -0.12922772006],[51.51332429750, -0.12912844494],[51.51261218726, -0.12868923516],[51.51225059422, -0.12844665936],[51.51213905806, -0.12840540140],[51.51203115308, -0.12837192122],[51.51197239694, -0.12836016510],[51.51177560512, -0.12832806336],[51.51151139961, -0.12829392827],[51.51058659975, -0.12833846125],[51.51041588474, -0.12831360925],[51.51027052219, -0.12826581344],[51.51017063642, -0.12822206252],[51.50997660635, -0.12809426326],[51.50980826317, -0.12793068166],[51.50968077013, -0.12775735643],[51.50956083679, -0.12752809616],[51.50934906048, -0.12698167397],[51.50908598945, -0.12612349501],[51.50903242790, -0.12597365947],[51.50884666952, -0.12556151744],[51.50878862893, -0.12543274414],[51.50852795287, -0.12493316527],[51.50838303408, -0.12466012723],[51.50830799752, -0.12448336526],[51.50825165753, -0.12430050413],[51.50818449221, -0.12405367328],[51.50801152687, -0.12333737502],[51.50794653251, -0.12310832653],[51.50777056295, -0.12260917870],[51.50766350133, -0.12229618229],[51.50752169097, -0.12188160337],[51.50733165808, -0.12125709808],[51.50711461772, -0.12051309638],[51.50694955166, -0.11998239282],[51.50667837898, -0.11912131751],[51.50650040738, -0.11853207475],[51.50629912444, -0.11797535473],[51.50603201777, -0.11728445953],[51.50590586953, -0.11699425926],[51.50567987385, -0.11652863277],[51.50543273195, -0.11612944679],[51.50500118732, -0.11564853344],[51.50475193619, -0.11538129106],[51.50442633224, -0.11500740343],[51.50419516030, -0.11479086257],[51.50395149472, -0.11458031503],[51.50357063784, -0.11431044830],[51.50285849530, -0.11383478783]]",
                            "stopPoints": [
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
                                    "id": "940GZZLUGDG",
                                    "name": "Goodge Street Underground Station",
                                    "uri": "/StopPoint/940GZZLUGDG",
                                    "type": "StopPoint",
                                    "routeType": "Unknown",
                                    "status": "Unknown"
                                },
                                {
                                    "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                                    "id": "940GZZLUTCR",
                                    "name": "Tottenham Court Road Underground Station",
                                    "uri": "/StopPoint/940GZZLUTCR",
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
                                "name": "Northern",
                                "directions": [
                                    "Battersea Power Station Underground Station via Charing Cross"
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
                        "distance": 85.0,
                        "isDisrupted": false,
                        "hasFixedLocations": true,
                        "scheduledDepartureTime": "2026-05-29T15:01:00",
                        "scheduledArrivalTime": "2026-05-29T15:10:00"
                    }
                ],
                "fare": {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.JourneyFare, Tfl.Api.Presentation.Entities",
                    "totalCost": 300,
                    "fares": [
                        {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Fare, Tfl.Api.Presentation.Entities",
                            "lowZone": 1,
                            "highZone": 1,
                            "cost": 300,
                            "chargeProfileName": "Normal",
                            "isHopperFare": false,
                            "chargeLevel": "Off Peak",
                            "peak": 310,
                            "offPeak": 300,
                            "taps": [
                                {
                                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                                    "atcoCode": "940GZZLUKSX",
                                    "tapDetails": {
                                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                                        "modeType": "Rail",
                                        "validationType": "None",
                                        "hostDeviceType": "Gate",
                                        "nationalLocationCode": 772,
                                        "tapTimestamp": "2026-05-29T15:56:00+01:00"
                                    }
                                },
                                {
                                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                                    "atcoCode": "940GZZLUWLO",
                                    "tapDetails": {
                                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                                        "modeType": "Rail",
                                        "validationType": "None",
                                        "hostDeviceType": "Gate",
                                        "nationalLocationCode": 747,
                                        "tapTimestamp": "2026-05-29T16:10:00+01:00"
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
            },
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
                "startDateTime": "2026-05-29T14:58:00",
                "duration": 13,
                "arrivalDateTime": "2026-05-29T15:11:00",
                "alternativeRoute": false,
                "legs": [
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
                        "departureTime": "2026-05-29T14:58:00",
                        "arrivalTime": "2026-05-29T15:02:00",
                        "departurePoint": {
                            "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                            "naptanId": "940GZZLUKSX",
                            "platformName": "",
                            "icsCode": "1000129",
                            "individualStopId": "9400ZZLUKSX2",
                            "commonName": "King's Cross St. Pancras Underground Station",
                            "placeType": "StopPoint",
                            "additionalProperties": [],
                            "lat": 51.530960898624,
                            "lon": -0.12225951825999999
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
                            "lat": 51.51577881206,
                            "lon": -0.141851269513
                        },
                        "path": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                            "lineString": "[[51.53096127449, -0.12224817133],[51.53087511499, -0.12253510895],[51.53068087051, -0.12322029411],[51.53047425273, -0.12404294838],[51.53037483412, -0.12457399411],[51.53024512895, -0.12545518374],[51.53003678947, -0.12682978724],[51.52988786467, -0.12774736294],[51.52975418564, -0.12845987041],[51.52955750096, -0.12923666217],[51.52934693924, -0.12997249438],[51.52916957421, -0.13051766363],[51.52898861917, -0.13105778548],[51.52883545305, -0.13153044720],[51.52848030939, -0.13268459854],[51.52844565616, -0.13279721216],[51.52838973228, -0.13300119170],[51.52829446783, -0.13331548263],[51.52820659137, -0.13355724205],[51.52796143154, -0.13413225848],[51.52773632218, -0.13453763049],[51.52728115651, -0.13553525790],[51.52714050249, -0.13578348823],[51.52667979889, -0.13643316259],[51.52633389199, -0.13683724377],[51.52588156265, -0.13732941921],[51.52536812563, -0.13792628636],[51.52482198916, -0.13860476888],[51.52450871583, -0.13901440562],[51.52424498968, -0.13930257401],[51.52402715185, -0.13954059797],[51.52350411838, -0.14014544637],[51.52310158234, -0.14058017510],[51.52241568847, -0.14123602871],[51.52219220773, -0.14139951180],[51.52190211706, -0.14156455187],[51.52165953271, -0.14165745637],[51.52142471643, -0.14179227848],[51.52117968882, -0.14191828948],[51.52074310987, -0.14207198696],[51.52028180214, -0.14222005716],[51.51989776048, -0.14231265691],[51.51868788171, -0.14220866950],[51.51765232663, -0.14222702551],[51.51713322366, -0.14219510705],[51.51664397578, -0.14208371117],[51.51607117600, -0.14189212263],[51.51578549727, -0.14180687142]]",
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
                                "category": "RealTime",
                                "type": "lineInfo",
                                "categoryDescription": "RealTime",
                                "description": "Victoria Line: Minor delays due to train cancellations.",
                                "summary": "",
                                "additionalInfo": "",
                                "created": "2026-05-29T15:00:00",
                                "lastUpdate": "2026-05-29T15:00:00"
                            }
                        ],
                        "plannedWorks": [],
                        "distance": 32.0,
                        "isDisrupted": true,
                        "hasFixedLocations": true,
                        "scheduledDepartureTime": "2026-05-29T14:58:00",
                        "scheduledArrivalTime": "2026-05-29T15:02:00",
                        "interChangeDuration": "2",
                        "interChangePosition": "AFTER"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
                        "duration": 7,
                        "instruction": {
                            "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                            "summary": "Bakerloo line to Waterloo",
                            "detailed": "Bakerloo line towards Elephant & Castle",
                            "steps": []
                        },
                        "obstacles": [],
                        "departureTime": "2026-05-29T15:04:00",
                        "arrivalTime": "2026-05-29T15:11:00",
                        "departurePoint": {
                            "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                            "naptanId": "940GZZLUOXC",
                            "platformName": "",
                            "icsCode": "1000173",
                            "individualStopId": "9400ZZLUOXC3",
                            "commonName": "Oxford Circus Underground Station",
                            "placeType": "StopPoint",
                            "additionalProperties": [],
                            "lat": 51.515727173562,
                            "lon": -0.14199749916999999
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
                            "lat": 51.503125839461994,
                            "lon": -0.114773036163
                        },
                        "path": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                            "lineString": "[[51.51572487769, -0.14201161233],[51.51566681203, -0.14199044301],[51.51547708492, -0.14193460335],[51.51525325568, -0.14187179256],[51.51509281571, -0.14183119237],[51.51483152587, -0.14175376506],[51.51451351482, -0.14162661815],[51.51415512739, -0.14136895535],[51.51393309254, -0.14123214109],[51.51369247091, -0.14105169530],[51.51350476513, -0.14089647996],[51.51327744059, -0.14068696029],[51.51299525761, -0.14043182893],[51.51237777586, -0.13986119206],[51.51214318172, -0.13965269929],[51.51161791914, -0.13920990248],[51.51128733798, -0.13890848333],[51.51105598884, -0.13870058858],[51.51035879820, -0.13811696371],[51.51024198635, -0.13798107386],[51.51019251735, -0.13789547151],[51.51014122398, -0.13778558904],[51.51006058276, -0.13756608273],[51.51003651016, -0.13748852435],[51.51000816612, -0.13738548865],[51.50998318890, -0.13727928943],[51.50995233040, -0.13711986541],[51.50992710257, -0.13694695379],[51.50990870894, -0.13677405174],[51.50990001308, -0.13644180095],[51.50990712645, -0.13621035841],[51.50994156128, -0.13582518813],[51.51002107184, -0.13522662301],[51.50991629880, -0.13570113191],[51.50997676412, -0.13528477928],[51.50998431488, -0.13519279161],[51.50999868595, -0.13501771263],[51.51003468882, -0.13366866664],[51.51002956459, -0.13347663287],[51.51000028329, -0.13329798005],[51.50993490231, -0.13315639836],[51.50983438465, -0.13299939265],[51.50965832409, -0.13277990650],[51.50949107714, -0.13261698455],[51.50920185250, -0.13237820730],[51.50804018435, -0.13148528792],[51.50785349459, -0.13125356982],[51.50771640692, -0.13100829554],[51.50764800614, -0.13080718908],[51.50758068833, -0.13021710582],[51.50750740398, -0.12971545928],[51.50744036923, -0.12911528061],[51.50741912561, -0.12831926577],[51.50740996132, -0.12807488115],[51.50741912561, -0.12831926577],[51.50744036923, -0.12911528061],[51.50750740398, -0.12971545928],[51.50758068833, -0.13021710582],[51.50764800614, -0.13080718908],[51.50771640692, -0.13100829554],[51.50785349459, -0.13125356982],[51.50804018435, -0.13148528792],[51.50920185250, -0.13237820730],[51.50949107714, -0.13261698455],[51.50965832409, -0.13277990650],[51.50983438465, -0.13299939265],[51.50993490231, -0.13315639836],[51.51000028329, -0.13329798005],[51.51002956459, -0.13347663287],[51.51003468882, -0.13366866664],[51.50999868595, -0.13501771263],[51.50997676412, -0.13528477928],[51.50991629880, -0.13570113191],[51.51002107184, -0.13522662301],[51.51003512954, -0.13502487098],[51.51006955205, -0.13367257396],[51.51006960667, -0.13346692611],[51.51004031990, -0.13327098012],[51.50997110351, -0.13311442356],[51.50986755371, -0.13295336260],[51.50968641512, -0.13272558165],[51.50952000070, -0.13255282636],[51.50923161454, -0.13231588848],[51.50809037166, -0.13144634396],[51.50789672730, -0.13121836883],[51.50776363729, -0.13097566879],[51.50770690251, -0.13081818025],[51.50768156255, -0.13063318038],[51.50759135237, -0.12968464207],[51.50754462252, -0.12913406647],[51.50753188186, -0.12833553981],[51.50752148557, -0.12798277060],[51.50750275222, -0.12773308837],[51.50747431848, -0.12751795630],[51.50739750066, -0.12697596730],[51.50731899582, -0.12652555399],[51.50720773260, -0.12593858106],[51.50663379357, -0.12298416472],[51.50660239149, -0.12286389011],[51.50660239540, -0.12286388750],[51.50311609539, -0.11475058749]]",
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
                        "disruptions": [],
                        "plannedWorks": [],
                        "distance": 683.0,
                        "isDisrupted": false,
                        "hasFixedLocations": true,
                        "scheduledDepartureTime": "2026-05-29T15:04:00",
                        "scheduledArrivalTime": "2026-05-29T15:11:00"
                    }
                ],
                "fare": {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.JourneyFare, Tfl.Api.Presentation.Entities",
                    "totalCost": 300,
                    "fares": [
                        {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Fare, Tfl.Api.Presentation.Entities",
                            "lowZone": 1,
                            "highZone": 1,
                            "cost": 300,
                            "chargeProfileName": "Normal",
                            "isHopperFare": false,
                            "chargeLevel": "Off Peak",
                            "peak": 310,
                            "offPeak": 300,
                            "taps": [
                                {
                                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                                    "atcoCode": "940GZZLUKSX",
                                    "tapDetails": {
                                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                                        "modeType": "Rail",
                                        "validationType": "None",
                                        "hostDeviceType": "Gate",
                                        "nationalLocationCode": 772,
                                        "tapTimestamp": "2026-05-29T15:58:00+01:00"
                                    }
                                },
                                {
                                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                                    "atcoCode": "940GZZLUWLO",
                                    "tapDetails": {
                                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                                        "modeType": "Rail",
                                        "validationType": "None",
                                        "hostDeviceType": "Gate",
                                        "nationalLocationCode": 747,
                                        "tapTimestamp": "2026-05-29T16:11:00+01:00"
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
        ],
        "lines": [
            {
                "$type": "Tfl.Api.Presentation.Entities.Line, Tfl.Api.Presentation.Entities",
                "id": "bakerloo",
                "name": "Bakerloo",
                "modeName": "tube",
                "disruptions": [],
                "created": "2026-05-26T12:41:07.333Z",
                "modified": "2026-05-26T12:41:07.333Z",
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
                "created": "2026-05-26T12:41:07.333Z",
                "modified": "2026-05-26T12:41:07.333Z",
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
                "id": "victoria",
                "name": "Victoria",
                "modeName": "tube",
                "disruptions": [],
                "created": "2026-05-26T12:41:07.333Z",
                "modified": "2026-05-26T12:41:07.333Z",
                "lineStatuses": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.LineStatus, Tfl.Api.Presentation.Entities",
                        "id": 0,
                        "lineId": "victoria",
                        "statusSeverity": 9,
                        "statusSeverityDescription": "Minor Delays",
                        "reason": "Victoria Line: Minor delays due to train cancellations. ",
                        "created": "0001-01-01T00:00:00",
                        "validityPeriods": [
                            {
                                "$type": "Tfl.Api.Presentation.Entities.ValidityPeriod, Tfl.Api.Presentation.Entities",
                                "fromDate": "2026-05-29T13:59:50Z",
                                "toDate": "2026-05-30T00:29:00Z",
                                "isNow": true
                            }
                        ],
                        "disruption": {
                            "$type": "Tfl.Api.Presentation.Entities.Disruption, Tfl.Api.Presentation.Entities",
                            "category": "RealTime",
                            "categoryDescription": "RealTime",
                            "description": "Victoria Line: Minor delays due to train cancellations. ",
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
        "stopMessages": [],
        "recommendedMaxAgeMinutes": 5,
        "searchCriteria": {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.SearchCriteria, Tfl.Api.Presentation.Entities",
            "dateTime": "2026-05-29T14:50:00",
            "dateTimeType": "Departing",
            "timeAdjustments": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustments, Tfl.Api.Presentation.Entities",
                "earliest": {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustment, Tfl.Api.Presentation.Entities",
                    "date": "20260529",
                    "time": "0300",
                    "timeIs": "departing",
                    "uri": "/journey/journeyresults/1000129/to/1000254?app_id=&app_key=&timeIs=departing&time=0300&date=20260529"
                },
                "earlier": {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustment, Tfl.Api.Presentation.Entities",
                    "date": "20260529",
                    "time": "1435",
                    "timeIs": "departing",
                    "uri": "/journey/journeyresults/1000129/to/1000254?app_id=&app_key=&timeIs=departing&time=1435&date=20260529"
                },
                "later": {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustment, Tfl.Api.Presentation.Entities",
                    "date": "20260529",
                    "time": "1459",
                    "timeIs": "departing",
                    "uri": "/journey/journeyresults/1000129/to/1000254?app_id=&app_key=&timeIs=departing&time=1459&date=20260529"
                },
                "latest": {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.TimeAdjustment, Tfl.Api.Presentation.Entities",
                    "date": "20260530",
                    "time": "0300",
                    "timeIs": "departing",
                    "uri": "/journey/journeyresults/1000129/to/1000254?app_id=&app_key=&timeIs=departing&time=0300&date=20260530"
                }
            }
        },
        "journeyVector": {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.JourneyVector, Tfl.Api.Presentation.Entities",
            "from": "1000129",
            "to": "1000254",
            "via": "",
            "uri": "/journey/journeyresults/1000129/to/1000254?app_id=&app_key=&timeis=departing&time=1450&date=20260529"
        }
    }
    """#
