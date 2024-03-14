let journeyByNationalRailJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-02-27T10:15:00",
    "duration": 23,
    "arrivalDateTime": "2024-02-27T10:38:00",
    "description": "Scenario1 Intermodal",
    "alternativeRoute": false,
    "legs": [
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 23,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Great Western Railway to Reading",
                "detailed": "Great Western Railway towards Cardiff Central",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T10:15:00",
            "arrivalTime": "2024-02-27T10:38:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "910GPADTON",
                "platformName": "",
                "icsCode": "1001221",
                "individualStopId": "9100PADTON0",
                "commonName": "London Paddington Rail Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.51699285316,
                "lon": -0.1773880138
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "910GRDNG4AB",
                "platformName": "",
                "icsCode": "1000972",
                "individualStopId": "9100RDNGSTN0",
                "commonName": "Reading Rail Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.45878431615,
                "lon": -0.97184883925
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.51699307748, -0.17740241876],[51.51781215248, -0.17860927413],[51.51810778427, -0.17911636635],[51.51836026782, -0.17974049410],[51.51844852575, -0.18021262435],[51.51852439306, -0.18104559090],[51.51863809306, -0.18315986952],[51.51858850098, -0.18460320750],[51.51883548814, -0.18894632917],[51.51905622297, -0.19101315750],[51.51938942470, -0.19337824551],[51.51968564528, -0.19509620015],[51.52097555214, -0.20062356495],[51.52138739468, -0.20226499909],[51.52309543257, -0.20810789600],[51.52390792376, -0.21126177830],[51.52450946180, -0.21415012965],[51.52471726541, -0.21539615032],[51.52506992371, -0.21789068277],[51.52529498517, -0.21968385845],[51.52564900491, -0.22346140795],[51.52570104680, -0.22511720175],[51.52573524950, -0.22737915671],[51.52571947149, -0.22931148919],[51.52557060258, -0.23554487461],[51.52544121508, -0.23710677365],[51.52509414326, -0.23974381790],[51.52427515645, -0.24389818702],[51.52351242206, -0.24701235928],[51.52288372679, -0.24947261802],[51.52216403334, -0.25186421925],[51.52179367891, -0.25295949156],[51.52048376248, -0.25618072518],[51.51902802488, -0.25988298147],[51.51835627642, -0.26188322444],[51.51783407911, -0.26366152224],[51.51753700250, -0.26485469977],[51.51718317686, -0.26646799528],[51.51611335405, -0.27197103004],[51.51570321445, -0.27465287817],[51.51535264844, -0.27772156607],[51.51504361114, -0.28240282582],[51.51497798175, -0.28406271251],[51.51486829667, -0.28640162572],[51.51483398728, -0.28836298313],[51.51488627039, -0.29194968367],[51.51493614134, -0.29537794570],[51.51488935165, -0.29772889410],[51.51465245626, -0.30247933887],[51.51452047273, -0.30454518301],[51.51424637015, -0.30860514904],[51.51386216534, -0.31439856394],[51.51354276578, -0.31971390360],[51.51317750506, -0.32435349808],[51.51271364588, -0.32965955432],[51.51206367322, -0.33580814163],[51.51202404770, -0.33618427966],[51.51198360389, -0.33650280164],[51.51138216333, -0.34102097284],[51.51097247018, -0.34384599353],[51.51031310340, -0.34874073809],[51.50940864993, -0.35476818825],[51.50759563398, -0.36724039151],[51.50600103562, -0.37869518407],[51.50539597365, -0.38306822093],[51.50404124929, -0.39245301323],[51.50372412842, -0.39556202062],[51.50336925863, -0.39920542054],[51.50327771089, -0.40040452947],[51.50311434978, -0.40359450396],[51.50297727876, -0.40674031265],[51.50284121026, -0.41328642309],[51.50282236035, -0.41521778737],[51.50288038323, -0.41818388343],[51.50309156023, -0.42251348682],[51.50356428551, -0.42758336354],[51.50420338874, -0.43300785139],[51.50497131097, -0.43799581668],[51.50550378965, -0.44084501814],[51.50649169456, -0.44549435231],[51.50706299330, -0.44857296784],[51.50860279996, -0.45896795047],[51.50882436909, -0.46077614842],[51.50974647795, -0.47146640159],[51.50983265645, -0.47325040771],[51.50989352833, -0.47516495891],[51.50995305990, -0.47697868648],[51.51000467363, -0.48304376352],[51.50994246415, -0.48588468243],[51.50991814950, -0.48748504390],[51.50973332610, -0.49198719230],[51.50956292090, -0.49552333855],[51.50904273483, -0.50195297335],[51.50800883095, -0.51469630192],[51.50775369797, -0.52012263779],[51.50758741301, -0.52691495568],[51.50755363188, -0.52995647102],[51.50770349375, -0.53907295057],[51.50794351214, -0.54536231540],[51.50835210061, -0.55222279038],[51.50953598705, -0.56956394482],[51.50974208775, -0.57171902540],[51.51035953644, -0.57739183468],[51.51106004588, -0.58326396625],[51.51215194965, -0.59142855813],[51.51215194965, -0.59142855813],[51.51252243188, -0.59419985131],[51.51259260203, -0.59480295765],[51.51289315376, -0.59662393206],[51.51388115210, -0.60104672654],[51.51507546970, -0.60619841535],[51.51692927657, -0.61391014384],[51.51959096156, -0.62461047810],[51.52032460265, -0.62813409978],[51.52144824977, -0.63426946477],[51.52249401717, -0.64069573017],[51.52289008418, -0.64306229563],[51.52318822382, -0.64551829319],[51.52334367198, -0.64730106997],[51.52357921960, -0.65135897828],[51.52390865168, -0.65734571678],[51.52399108730, -0.65983702019],[51.52399273319, -0.65998111798],[51.52411255853, -0.66734348343],[51.52413594270, -0.67019690023],[51.52408296450, -0.67187053965],[51.52381659826, -0.67535219137],[51.52345718066, -0.68016262010],[51.52250352795, -0.68893955017],[51.52115091137, -0.70153269123],[51.52025128931, -0.70964417291],[51.51997193989, -0.71204467024],[51.51861766056, -0.72140797338],[51.51843819804, -0.72256457326],[51.51843819804, -0.72256457326],[51.51816392619, -0.72433204018],[51.51799573028, -0.72540327338],[51.51776585116, -0.72659151919],[51.51508713987, -0.73832527656],[51.51457224205, -0.74061652247],[51.51399391101, -0.74286622800],[51.51251066575, -0.74795085754],[51.51144106344, -0.75136665088],[51.50601886984, -0.76837315158],[51.50341454765, -0.77642536907],[51.49424806343, -0.80484706686],[51.48632009254, -0.82920735977],[51.48064141848, -0.84687842233],[51.47798023196, -0.85518224167],[51.47744786711, -0.85683713189],[51.47603424484, -0.86126423197],[51.47540703644, -0.86318196422],[51.47540703644, -0.86318196422],[51.47505614881, -0.86425476185],[51.47434914754, -0.86646091943],[51.47399113627, -0.86756408409],[51.46939244240, -0.88216143336],[51.46627812723, -0.89225723267],[51.46580761890, -0.89385218179],[51.46535547498, -0.89548984204],[51.46454223260, -0.89889243366],[51.46424886638, -0.90020948226],[51.46073639308, -0.91797018106],[51.46046277989, -0.91950244315],[51.46021969050, -0.92142261034],[51.45987065985, -0.92453995793],[51.45945462537, -0.92820579712],[51.45894020005, -0.93391778158],[51.45873490810, -0.94103305647],[51.45870719585, -0.94594194787],[51.45869413893, -0.94949748930],[51.45867870574, -0.95784617574],[51.45886698296, -0.96387286076],[51.45895251634, -0.96643301205],[51.45904154229, -0.96837416145],[51.45929059036, -0.97175050855]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "910GRDNG4AB",
                        "name": "Reading Rail Station",
                        "uri": "/StopPoint/910GRDNG4AB",
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
                    "name": "Great Western Railway",
                    "directions": [
                        "Cardiff Central Rail Station"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "great-western-railway",
                        "name": "Great Western Railway",
                        "uri": "/Line/great-western-railway",
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
                "id": "national-rail",
                "name": "national-rail",
                "type": "Mode",
                "routeType": "Unknown",
                "status": "Unknown",
                "motType": "6",
                "network": "nrc"
            },
            "disruptions": [],
            "plannedWorks": [],
            "isDisrupted": false,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-27T10:15:00",
            "scheduledArrivalTime": "2024-02-27T10:38:00"
        }
    ],
    "fare": {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.JourneyFare, Tfl.Api.Presentation.Entities",
        "totalCost": 1200,
        "fares": [
            {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Fare, Tfl.Api.Presentation.Entities",
                "lowZone": 1,
                "highZone": 6,
                "cost": 1200,
                "chargeProfileName": "Standard peak/off peak",
                "isHopperFare": false,
                "chargeLevel": "Off Peak",
                "peak": 2760,
                "offPeak": 1200,
                "taps": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                        "atcoCode": "910GPADTON",
                        "tapDetails": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                            "modeType": "Rail",
                            "validationType": "None",
                            "hostDeviceType": "Gate",
                            "nationalLocationCode": 3087,
                            "tapTimestamp": "2024-02-27T10:15:00+00:00"
                        }
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTap, Tfl.Api.Presentation.Entities",
                        "atcoCode": "910GRDNG4AB",
                        "tapDetails": {
                            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.FareTapDetails, Tfl.Api.Presentation.Entities",
                            "modeType": "Rail",
                            "validationType": "None",
                            "hostDeviceType": "Gate",
                            "nationalLocationCode": 3149,
                            "tapTimestamp": "2024-02-27T10:38:00+00:00"
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
