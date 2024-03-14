let journeyByBusLongJSON = #"""
{
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-02-27T10:32:00",
    "duration": 169,
    "arrivalDateTime": "2024-02-27T13:21:00",
    "description": "Scenario1 Bus Only",
    "alternativeRoute": false,
    "legs": [
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 12,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "27 bus to Notting Hill Gate Station",
                "detailed": "27 bus towards Glenthorne House",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T10:32:00",
            "arrivalTime": "2024-02-27T10:44:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "490G01221H",
                "platformName": "F",
                "stopLetter": "F",
                "icsCode": "1001221",
                "individualStopId": "490001221F",
                "commonName": "Paddington",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.5154919095,
                "lon": -0.17570399307
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUNHG",
                "platformName": "C",
                "stopLetter": "C",
                "icsCode": "1000167",
                "individualStopId": "490015039C",
                "commonName": "Notting Hill Gate Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.50925793116,
                "lon": -0.19707909531999998
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.51551705683, -0.17572838274],[51.51538787514, -0.17595316464],[51.51525643165, -0.17617460463],[51.51516902637, -0.17633663422],[51.51536245346, -0.17663157424],[51.51631003807, -0.17800620092],[51.51684335758, -0.17876322636],[51.51698372149, -0.17897000557],[51.51698372149, -0.17897000557],[51.51738632992, -0.17956312420],[51.51745978995, -0.17966108828],[51.51776373367, -0.18012461191],[51.51781899597, -0.18020888959],[51.51795692801, -0.18040518016],[51.51776282264, -0.18117735717],[51.51776282264, -0.18117735717],[51.51766048058, -0.18158447663],[51.51755124235, -0.18207888026],[51.51719320806, -0.18334708487],[51.51709138794, -0.18374029180],[51.51694686177, -0.18427932667],[51.51690066770, -0.18445127680],[51.51690066770, -0.18445127680],[51.51670028510, -0.18519715437],[51.51647887986, -0.18599866823],[51.51631770545, -0.18662482727],[51.51629274878, -0.18675553467],[51.51610572242, -0.18745477896],[51.51595130189, -0.18793653153],[51.51592791144, -0.18801152336],[51.51592791144, -0.18801152336],[51.51580564382, -0.18840352039],[51.51569317150, -0.18927274609],[51.51563016896, -0.18985175256],[51.51552645061, -0.19070621164],[51.51547153943, -0.19122724280],[51.51539299570, -0.19196539788],[51.51528160640, -0.19290662658],[51.51517154027, -0.19393427352],[51.51509908416, -0.19448481534],[51.51501763848, -0.19503571072],[51.51464793342, -0.19561096449],[51.51464793342, -0.19561096449],[51.51432384281, -0.19611523165],[51.51425416203, -0.19626210690],[51.51396246408, -0.19659069682],[51.51319055984, -0.19726971777],[51.51283378703, -0.19744382247],[51.51283378703, -0.19744382247],[51.51254792353, -0.19758332140],[51.51218999309, -0.19769832995],[51.51162403379, -0.19773507770],[51.51154292953, -0.19772386710],[51.51110035361, -0.19759722080],[51.50962139561, -0.19732414112],[51.50941292383, -0.19721708398],[51.50925966229, -0.19717819830]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G000450",
                        "name": "Paddington Stn / Eastbourne Terrace",
                        "uri": "/StopPoint/490G000450",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00014406",
                        "name": "Westbourne Terrace",
                        "uri": "/StopPoint/490G00014406",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00007252",
                        "name": "Gloucester Terrace",
                        "uri": "/StopPoint/490G00007252",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00011366",
                        "name": "Queensway",
                        "uri": "/StopPoint/490G00011366",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00005089",
                        "name": "Pembridge Villas",
                        "uri": "/StopPoint/490G00005089",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00005085",
                        "name": "Chepstow Crescent",
                        "uri": "/StopPoint/490G00005085",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUNHG",
                        "name": "Notting Hill Gate Underground Station",
                        "uri": "/StopPoint/940GZZLUNHG",
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
                    "name": "27",
                    "directions": [
                        "Glenthorne House"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "27",
                        "name": "27",
                        "uri": "/Line/27",
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
            "scheduledDepartureTime": "2024-02-27T10:35:00",
            "scheduledArrivalTime": "2024-02-27T10:47:00",
            "interChangeDuration": "3",
            "interChangePosition": "AFTER"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 19,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "94 bus to Turnham Green Station",
                "detailed": "94 bus towards Acton Green",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T10:48:00",
            "arrivalTime": "2024-02-27T11:07:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUNHG",
                "platformName": "H",
                "stopLetter": "H",
                "icsCode": "1000167",
                "individualStopId": "490000167H",
                "commonName": "Notting Hill Gate Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.50928384435,
                "lon": -0.19467148799
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUTNG",
                "platformName": "MM",
                "stopLetter": "MM",
                "icsCode": "1000240",
                "individualStopId": "490000240MM",
                "commonName": "Turnham Green Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.49579266459,
                "lon": -0.25450121942000004
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.50934957892, -0.19471339489],[51.50919651242, -0.19542429440],[51.50904015897, -0.19636716180],[51.50896702640, -0.19687442035],[51.50888924298, -0.19707923908],[51.50888136288, -0.19715160293],[51.50874885863, -0.19789176958],[51.50870420455, -0.19836966964],[51.50870420455, -0.19836966964],[51.50864073748, -0.19904887397],[51.50865282027, -0.19925014423],[51.50863116550, -0.19959684938],[51.50861606527, -0.19978478071],[51.50854100148, -0.20075323908],[51.50842225211, -0.20121905009],[51.50833591567, -0.20145301641],[51.50813170863, -0.20221039402],[51.50791674430, -0.20285290609],[51.50785692433, -0.20305700298],[51.50773728331, -0.20346519519],[51.50764327864, -0.20378591615],[51.50750808641, -0.20435322713],[51.50750808641, -0.20435322713],[51.50723637153, -0.20540143100],[51.50710883668, -0.20588197134],[51.50702454776, -0.20617434063],[51.50702454776, -0.20617434063],[51.50684411341, -0.20680019315],[51.50660568377, -0.20767414297],[51.50650400053, -0.20808160707],[51.50637557467, -0.20850452797],[51.50623137224, -0.20907216208],[51.50612113672, -0.20950877420],[51.50601944702, -0.20991623002],[51.50591907433, -0.21041008997],[51.50575941923, -0.21116538336],[51.50575941923, -0.21116538336],[51.50570100735, -0.21144171010],[51.50563438089, -0.21179014708],[51.50545093327, -0.21273394280],[51.50540950885, -0.21296611456],[51.50520873542, -0.21395380631],[51.50514559944, -0.21421286180],[51.50514559944, -0.21421286180],[51.50494635898, -0.21503035230],[51.50490427254, -0.21521931740],[51.50485407517, -0.21546623603],[51.50473176145, -0.21570156188],[51.50462698331, -0.21590738322],[51.50443978768, -0.21601555837],[51.50426376924, -0.21626738677],[51.50417784020, -0.21653010485],[51.50425608669, -0.21694491263],[51.50430321140, -0.21708716391],[51.50431415480, -0.21780719068],[51.50429003805, -0.21799544950],[51.50424311612, -0.21845836971],[51.50416089997, -0.21896589215],[51.50411946309, -0.21919805198],[51.50405402480, -0.21961853925],[51.50405402480, -0.21961853925],[51.50396379070, -0.22019833923],[51.50388113001, -0.22067705476],[51.50382258922, -0.22096751336],[51.50363994023, -0.22196883785],[51.50342155227, -0.22298595325],[51.50336126045, -0.22316120383],[51.50323871284, -0.22338210142],[51.50310015345, -0.22373329861],[51.50298043943, -0.22414139559],[51.50286570824, -0.22451747796],[51.50286570824, -0.22451747796],[51.50274912243, -0.22489963360],[51.50268991731, -0.22514687956],[51.50250570759, -0.22604736302],[51.50243947278, -0.22642455530],[51.50242302276, -0.22652605321],[51.50235591558, -0.22684564417],[51.50229039310, -0.22723740126],[51.50229039310, -0.22723740126],[51.50223220908, -0.22758527434],[51.50218988459, -0.22775981712],[51.50203109364, -0.22855843589],[51.50198130280, -0.22883412472],[51.50187316678, -0.22941464866],[51.50173060038, -0.23009736149],[51.50168080588, -0.23037304690],[51.50163101073, -0.23064873173],[51.50158121493, -0.23092441598],[51.50155571234, -0.23104052795],[51.50155571234, -0.23104052795],[51.50139609199, -0.23176725634],[51.50122655020, -0.23245099814],[51.50115855877, -0.23271297373],[51.50094385857, -0.23338404659],[51.50085745690, -0.23361791502],[51.50076271810, -0.23389532863],[51.50057601414, -0.23448088552],[51.50057601414, -0.23448088552],[51.50053945732, -0.23459553650],[51.50039924362, -0.23543660772],[51.50030991523, -0.23607400031],[51.50026097266, -0.23640726857],[51.50020282544, -0.23672648360],[51.50013943354, -0.23709059011],[51.50013943354, -0.23709059011],[51.50005382550, -0.23758228848],[51.49996936245, -0.23794573850],[51.49993254824, -0.23788952771],[51.49990558662, -0.23789056760],[51.49987970669, -0.23796360398],[51.49995268603, -0.23803282767],[51.49991315762, -0.23839454345],[51.49989756221, -0.23855362890],[51.49987752011, -0.23901544611],[51.49977887696, -0.23903365585],[51.49985293663, -0.23917487762],[51.49980095896, -0.23930654942],[51.49951626745, -0.24010993463],[51.49941274187, -0.24040207224],[51.49922632987, -0.24111568007],[51.49922632987, -0.24111568007],[51.49908958386, -0.24163914603],[51.49883615310, -0.24272944741],[51.49878546571, -0.24294750627],[51.49872046999, -0.24341103836],[51.49867725906, -0.24352795770],[51.49869566483, -0.24355606463],[51.49875792855, -0.24351044916],[51.49865722217, -0.24406128389],[51.49865722217, -0.24406128389],[51.49850857471, -0.24487431208],[51.49838130686, -0.24538345147],[51.49817573568, -0.24606847925],[51.49735401132, -0.24824664016],[51.49711225906, -0.24891861912],[51.49698389874, -0.24935573963],[51.49693319887, -0.24957378254],[51.49687415593, -0.24983536455],[51.49682214955, -0.25006689634],[51.49682214955, -0.25006689634],[51.49677296878, -0.25028584623],[51.49655433223, -0.25130267848],[51.49629246680, -0.25243640615],[51.49595570741, -0.25397636166],[51.49591377180, -0.25417965316],[51.49584049736, -0.25451540105]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00019162",
                        "name": "Notting Hill Gate Stn  / Hillgate St",
                        "uri": "/StopPoint/490G00019162",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUHPK",
                        "name": "Holland Park Underground Station",
                        "uri": "/StopPoint/940GZZLUHPK",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUHPK",
                        "name": "Holland Park Underground Station",
                        "uri": "/StopPoint/940GZZLUHPK",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00010305",
                        "name": "Norland Square",
                        "uri": "/StopPoint/490G00010305",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00008651",
                        "name": "Royal Crescent",
                        "uri": "/StopPoint/490G00008651",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00203A",
                        "name": "Shepherd's Bush Station",
                        "uri": "/StopPoint/490G00203A",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00010913",
                        "name": "Shepherd's Bush Road",
                        "uri": "/StopPoint/490G00010913",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUGHK",
                        "name": "Goldhawk Road Underground Station",
                        "uri": "/StopPoint/940GZZLUGHK",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00012946",
                        "name": "St Stephens Avenue",
                        "uri": "/StopPoint/490G00012946",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00004871",
                        "name": "Cathnor Road",
                        "uri": "/StopPoint/490G00004871",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00010710",
                        "name": "Paddenswick Road",
                        "uri": "/StopPoint/490G00010710",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00015455",
                        "name": "Askew Road",
                        "uri": "/StopPoint/490G00015455",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00006872",
                        "name": "Flanchford Road",
                        "uri": "/StopPoint/490G00006872",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00003060",
                        "name": "Abinger Road",
                        "uri": "/StopPoint/490G00003060",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUTNG",
                        "name": "Turnham Green Underground Station",
                        "uri": "/StopPoint/940GZZLUTNG",
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
                    "name": "94",
                    "directions": [
                        "Acton Green"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "94",
                        "name": "94",
                        "uri": "/Line/94",
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
            "scheduledDepartureTime": "2024-02-27T10:49:00",
            "scheduledArrivalTime": "2024-02-27T11:08:00"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 5,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Walk to Chiswick Lane",
                "detailed": "Walk to Chiswick Lane",
                "steps": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "Bath Road for 81 metres",
                        "turnDirection": "STRAIGHT",
                        "streetName": "Bath Road",
                        "distance": 81,
                        "cumulativeDistance": 81,
                        "skyDirection": 249,
                        "skyDirectionDescription": "West",
                        "cumulativeTravelTime": 73,
                        "latitude": 51.495837815360005,
                        "longitude": -0.25451390101,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Continue along ",
                        "trackType": "None"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "on to Turnham Green Terrace, continue for 112 metres",
                        "turnDirection": "LEFT",
                        "streetName": "Turnham Green Terrace",
                        "distance": 112,
                        "cumulativeDistance": 193,
                        "skyDirection": 178,
                        "skyDirectionDescription": "South",
                        "cumulativeTravelTime": 174,
                        "latitude": 51.495669638619994,
                        "longitude": -0.25529826463,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Turn left",
                        "trackType": "None"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "on to Thornton Avenue, continue for 100 metres",
                        "turnDirection": "LEFT",
                        "streetName": "Thornton Avenue",
                        "distance": 100,
                        "cumulativeDistance": 293,
                        "skyDirection": 91,
                        "skyDirectionDescription": "East",
                        "cumulativeTravelTime": 263,
                        "latitude": 51.49466284686,
                        "longitude": -0.25532229883,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Turn left",
                        "trackType": "None"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "on to Mayfield Avenue, continue for 206 metres",
                        "turnDirection": "RIGHT",
                        "streetName": "Mayfield Avenue",
                        "distance": 206,
                        "cumulativeDistance": 499,
                        "skyDirection": 180,
                        "skyDirectionDescription": "South",
                        "cumulativeTravelTime": 448,
                        "latitude": 51.494632431730004,
                        "longitude": -0.25388286423,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Turn right",
                        "trackType": "None"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "on to Chiswick High Road, continue for 47 metres",
                        "turnDirection": "LEFT",
                        "streetName": "Chiswick High Road",
                        "distance": 47,
                        "cumulativeDistance": 546,
                        "skyDirection": 85,
                        "skyDirectionDescription": "East",
                        "cumulativeTravelTime": 490,
                        "latitude": 51.4927810489,
                        "longitude": -0.25395360463,
                        "pathAttribute": {
                            "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
                        },
                        "descriptionHeading": "Turn left",
                        "trackType": "None"
                    }
                ]
            },
            "obstacles": [
                {
                    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
                    "type": "WALKWAY",
                    "incline": "LEVEL",
                    "stopId": 1000240,
                    "position": "IDEST"
                }
            ],
            "departureTime": "2024-02-27T11:11:00",
            "arrivalTime": "2024-02-27T11:16:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUTNG",
                "platformName": "MM",
                "stopLetter": "MM",
                "icsCode": "1000240",
                "individualStopId": "490000240MM",
                "commonName": "Turnham Green Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.49579266459,
                "lon": -0.25450121942000004
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "490G00013850",
                "platformName": "RR",
                "stopLetter": "RR",
                "icsCode": "1013850",
                "individualStopId": "490013850RR",
                "commonName": "Chiswick Lane",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.4926211903,
                "lon": -0.25348433665000003
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.49583779539, -0.25451388756],[51.49591080476, -0.25419324841],[51.49567046945, -0.25529445787],[51.49566963862, -0.25529826463],[51.49540879275, -0.25529381796],[51.49525600866, -0.25529965149],[51.49509423727, -0.25530582812],[51.49492369276, -0.25532674569],[51.49466284686, -0.25532229883],[51.49463243173, -0.25388286423],[51.49278104890, -0.25395360463],[51.49281085604, -0.25327843065],[51.49280139538, -0.25350628756]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "name": "Chiswick Lane",
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
            "scheduledDepartureTime": "2024-02-27T11:11:00",
            "scheduledArrivalTime": "2024-02-27T11:16:00",
            "interChangeDuration": "5",
            "interChangePosition": "IDEST"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 31,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "H91 bus to Hounslow West Station",
                "detailed": "H91 bus towards Hounslow West",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T11:16:00",
            "arrivalTime": "2024-02-27T11:47:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "490G00013850",
                "platformName": "RR",
                "stopLetter": "RR",
                "icsCode": "1013850",
                "individualStopId": "490013850RR",
                "commonName": "Chiswick Lane",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.4926211903,
                "lon": -0.25348433665000003
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUHWT",
                "platformName": "B",
                "stopLetter": "B",
                "icsCode": "1000118",
                "individualStopId": "490000118B",
                "commonName": "Hounslow West Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.47289460085,
                "lon": -0.38544147056
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.49280080018, -0.25350622013],[51.49278104890, -0.25395360463],[51.49274382795, -0.25447361984],[51.49270404333, -0.25542589253],[51.49265932723, -0.25604702894],[51.49261139839, -0.25705723021],[51.49260433674, -0.25718714737],[51.49254013400, -0.25831320870],[51.49252558021, -0.25854424796],[51.49250074552, -0.25929426883],[51.49247372829, -0.25975660742],[51.49247372829, -0.25975660742],[51.49247206087, -0.25978514056],[51.49245771777, -0.26003057622],[51.49244378244, -0.26090982754],[51.49243949162, -0.26122690645],[51.49244866872, -0.26184598337],[51.49245784255, -0.26246506062],[51.49245976224, -0.26259463497],[51.49253372785, -0.26394591944],[51.49256214356, -0.26465069913],[51.49262969855, -0.26557007364],[51.49265876498, -0.26621711816],[51.49265876498, -0.26621711816],[51.49268331477, -0.26676368064],[51.49289729681, -0.26907483248],[51.49291994606, -0.26939089326],[51.49294301928, -0.26973574909],[51.49293912938, -0.27008162593],[51.49290167387, -0.27063027868],[51.49290167387, -0.27063027868],[51.49285038727, -0.27138146841],[51.49281740857, -0.27158439086],[51.49262292128, -0.27303227605],[51.49242197045, -0.27465325541],[51.49237842286, -0.27520286083],[51.49237842286, -0.27520286083],[51.49236129474, -0.27541902213],[51.49234734224, -0.27569324749],[51.49233931457, -0.27637059472],[51.49223337338, -0.27772867576],[51.49217077540, -0.27836486108],[51.49213989773, -0.27871174746],[51.49210923031, -0.27907303056],[51.49204490693, -0.27968003719],[51.49204619538, -0.27968038757],[51.49251729538, -0.28852188758],[51.49251411683, -0.28851908039],[51.49193048827, -0.29021486900],[51.49140449152, -0.29176146455],[51.49130356115, -0.29224059697],[51.49119303601, -0.29329627801],[51.49120558506, -0.29354069118],[51.49123799363, -0.29391400646],[51.49123821993, -0.29454781012],[51.49127023409, -0.29736996175],[51.49130262721, -0.29836268857],[51.49130596934, -0.29859304150],[51.49131934271, -0.29889504525],[51.49132351900, -0.29918298659],[51.49132100817, -0.30011950076],[51.49132100817, -0.30011950076],[51.49131930477, -0.30075327063],[51.49129982886, -0.30189197620],[51.49127174467, -0.30261293260],[51.49127174467, -0.30261293260],[51.49122114609, -0.30391157183],[51.49116052361, -0.30407227419],[51.49119019262, -0.30425843549],[51.49115295612, -0.30479279384],[51.49074547454, -0.30646444229],[51.49063217048, -0.30671351909],[51.49038372238, -0.30741620805],[51.49038372238, -0.30741620805],[51.48986323075, -0.30888825739],[51.48980301648, -0.30907774181],[51.48945071194, -0.31021430571],[51.48880048741, -0.31189480746],[51.48852158695, -0.31251007334],[51.48841705021, -0.31274439518],[51.48825208492, -0.31315379246],[51.48818287605, -0.31334359635],[51.48756731499, -0.31493630632],[51.48735110458, -0.31553482285],[51.48712627947, -0.31610567987],[51.48712627947, -0.31610567987],[51.48675245541, -0.31705483416],[51.48631794492, -0.31810786421],[51.48616174170, -0.31850249739],[51.48566595478, -0.31967297653],[51.48523877165, -0.32066707951],[51.48523877165, -0.32066707951],[51.48480442158, -0.32167782126],[51.48472579901, -0.32183913773],[51.48461328538, -0.32214572453],[51.48455304928, -0.32233517005],[51.48437048627, -0.32277394818],[51.48405886949, -0.32362072660],[51.48386182330, -0.32430486726],[51.48368213152, -0.32494515892],[51.48357198161, -0.32543870797],[51.48357198161, -0.32543870797],[51.48325109211, -0.32687645163],[51.48301183830, -0.32901672913],[51.48286987783, -0.33129670974],[51.48286987783, -0.33129670974],[51.48285814533, -0.33148510906],[51.48264240612, -0.33572764132],[51.48264240612, -0.33572764132],[51.48259104581, -0.33673719559],[51.48257613265, -0.33695376844],[51.48237033746, -0.34083537937],[51.48234703988, -0.34109545980],[51.48232557400, -0.34148509089],[51.48225684734, -0.34253834436],[51.48225684734, -0.34253834436],[51.48213338626, -0.34443004430],[51.48211744287, -0.34457464027],[51.48189792703, -0.34622439295],[51.48185076003, -0.34645847828],[51.48185076003, -0.34645847828],[51.48169622360, -0.34722540816],[51.48165432775, -0.34744294839],[51.48080045776, -0.35130459426],[51.48070682637, -0.35182533342],[51.48070682637, -0.35182533342],[51.48055024386, -0.35269614713],[51.48051651683, -0.35285577708],[51.48026911228, -0.35444882911],[51.47999996838, -0.35641707580],[51.47990320785, -0.35721261701],[51.47978982753, -0.35802359359],[51.47978982753, -0.35802359359],[51.47948633033, -0.36019420317],[51.47921769243, -0.36220556557],[51.47917677352, -0.36249504940],[51.47907956971, -0.36326177695],[51.47904807152, -0.36352235924],[51.47904807152, -0.36352235924],[51.47893445716, -0.36446224012],[51.47888574906, -0.36483840349],[51.47874840474, -0.36595217414],[51.47856153173, -0.36738452225],[51.47849706703, -0.36786238919],[51.47849706703, -0.36786238919],[51.47797207998, -0.37175344793],[51.47797207998, -0.37175344793],[51.47795826594, -0.37185581959],[51.47781026901, -0.37285472099],[51.47764788016, -0.37411333493],[51.47743193268, -0.37605065840],[51.47722795547, -0.37755553047],[51.47718759571, -0.37788816835],[51.47711388458, -0.37846652262],[51.47711388458, -0.37846652262],[51.47686309326, -0.38043410608],[51.47678915844, -0.38094072904],[51.47661709864, -0.38215642686],[51.47652617302, -0.38273564534],[51.47649928855, -0.38293716157],[51.47649928855, -0.38293716157],[51.47645282350, -0.38328544006],[51.47629613724, -0.38431337712],[51.47578898087, -0.38470569057],[51.47504311277, -0.38539441621],[51.47477644720, -0.38561982347],[51.47406652508, -0.38630725012],[51.47316587217, -0.38685739234],[51.47295922644, -0.38621673024],[51.47303734480, -0.38601238867],[51.47286120546, -0.38546973151]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00005210",
                        "name": "Duke Road",
                        "uri": "/StopPoint/490G00005210",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G000807",
                        "name": "Turnham Green Church",
                        "uri": "/StopPoint/490G000807",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00005211",
                        "name": "Chiswick Road",
                        "uri": "/StopPoint/490G00005211",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00094B",
                        "name": "Gunnersbury Station",
                        "uri": "/StopPoint/490G00094B",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00018897",
                        "name": "Power Road",
                        "uri": "/StopPoint/490G00018897",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00007605",
                        "name": "Chiswick Roundabout / Gunnersbury",
                        "uri": "/StopPoint/490G00007605",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00014010",
                        "name": "Vantage West",
                        "uri": "/StopPoint/490G00014010",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00005378",
                        "name": "Clayponds Avenue",
                        "uri": "/StopPoint/490G00005378",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00006300",
                        "name": "Ealing Road",
                        "uri": "/StopPoint/490G00006300",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00014772",
                        "name": "Windmill Road",
                        "uri": "/StopPoint/490G00014772",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00007421",
                        "name": "Boston Manor Road",
                        "uri": "/StopPoint/490G00007421",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00014417",
                        "name": "West Cross Way",
                        "uri": "/StopPoint/490G00014417",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00007179",
                        "name": "Gillette Corner",
                        "uri": "/StopPoint/490G00007179",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00012686",
                        "name": "St Francis of Assisi Church",
                        "uri": "/StopPoint/490G00012686",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00014873",
                        "name": "Wood Lane",
                        "uri": "/StopPoint/490G00014873",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00011577",
                        "name": "Ridgeway Road",
                        "uri": "/StopPoint/490G00011577",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00010658",
                        "name": "Osterley Library",
                        "uri": "/StopPoint/490G00010658",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUOSY",
                        "name": "Osterley Underground Station",
                        "uri": "/StopPoint/940GZZLUOSY",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00007524",
                        "name": "Gresham Road",
                        "uri": "/StopPoint/490G00007524",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00008925",
                        "name": "Lampton Road",
                        "uri": "/StopPoint/490G00008925",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G000347",
                        "name": "Lampton School",
                        "uri": "/StopPoint/490G000347",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00013078",
                        "name": "Sutton Lane",
                        "uri": "/StopPoint/490G00013078",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00004629",
                        "name": "Burton Gardens",
                        "uri": "/StopPoint/490G00004629",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00014037",
                        "name": "Vicarage Farm Road",
                        "uri": "/StopPoint/490G00014037",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "940GZZLUHWT",
                        "name": "Hounslow West Underground Station",
                        "uri": "/StopPoint/940GZZLUHWT",
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
                    "name": "H91",
                    "directions": [
                        "Hounslow West"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "h91",
                        "name": "H91",
                        "uri": "/Line/h91",
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
            "scheduledDepartureTime": "2024-02-27T11:16:00",
            "scheduledArrivalTime": "2024-02-27T11:47:00",
            "interChangeDuration": "2",
            "interChangePosition": "AFTER"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 17,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "81 bus to Compass Centre",
                "detailed": "81 bus towards Slough",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T11:55:00",
            "arrivalTime": "2024-02-27T12:12:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "940GZZLUHWT",
                "platformName": "C",
                "stopLetter": "C",
                "icsCode": "1000118",
                "individualStopId": "490000118C",
                "commonName": "Hounslow West Underground Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.47256066017,
                "lon": -0.38535246803
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "490G00005530",
                "platformName": "",
                "stopLetter": "BW",
                "icsCode": "1005530",
                "individualStopId": "490005530W",
                "commonName": "Compass Centre",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.48149419608,
                "lon": -0.46948759479
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.47266303893, -0.38528032861],[51.47276176333, -0.38559014858],[51.47295922644, -0.38621673024],[51.47316587217, -0.38685739234],[51.47348432755, -0.38778209936],[51.47352225796, -0.38792475306],[51.47392812111, -0.38932156916],[51.47408882227, -0.38989187975],[51.47430680643, -0.39070496681],[51.47467648764, -0.39208870369],[51.47468990567, -0.39214373022],[51.47468990567, -0.39214373022],[51.47485751862, -0.39283111254],[51.47497227711, -0.39333106315],[51.47509720422, -0.39391705651],[51.47520592590, -0.39463321841],[51.47532028281, -0.39510439204],[51.47534377348, -0.39550675775],[51.47530939697, -0.39562316096],[51.47541377764, -0.39602268964],[51.47546829609, -0.39606397648],[51.47570086861, -0.39663180954],[51.47594734393, -0.39755915686],[51.47614118309, -0.39834240117],[51.47614118309, -0.39834240117],[51.47641370175, -0.39944361189],[51.47678288829, -0.40079869864],[51.47691807653, -0.40126715544],[51.47691807653, -0.40126715544],[51.47710378507, -0.40191069115],[51.47753938686, -0.40352270453],[51.47752768040, -0.40398392353],[51.47750247936, -0.40411440594],[51.47759745172, -0.40448550029],[51.47770628699, -0.40455370466],[51.47792669857, -0.40489162498],[51.47798317170, -0.40507686100],[51.47821981030, -0.40594703981],[51.47838041993, -0.40647387752],[51.47838041993, -0.40647387752],[51.47844569447, -0.40668799678],[51.47864363255, -0.40735793098],[51.47871964151, -0.40765769805],[51.47887068024, -0.40818526554],[51.47901253329, -0.40869875538],[51.47908853885, -0.40899852716],[51.47916522934, -0.40926873500],[51.47916522934, -0.40926873500],[51.47951349544, -0.41049583898],[51.47964596035, -0.41098086734],[51.48017580017, -0.41292100923],[51.48041277057, -0.41382006033],[51.48053305128, -0.41429290845],[51.48053305128, -0.41429290845],[51.48115352030, -0.41673225715],[51.48122420892, -0.41730586792],[51.48125719463, -0.41775117182],[51.48127259085, -0.41822588783],[51.48116202565, -0.42002989327],[51.48107460915, -0.42081087870],[51.48107460915, -0.42081087870],[51.48096135810, -0.42182259828],[51.48084097530, -0.42356931517],[51.48081102060, -0.42401678903],[51.48074180591, -0.42515622835],[51.48074180591, -0.42515622835],[51.48070055924, -0.42583515881],[51.48066334620, -0.42641249099],[51.48054181560, -0.42874967352],[51.48057180768, -0.43233455138],[51.48060651814, -0.43358626971],[51.48064232511, -0.43424750078],[51.48065342722, -0.43440553444],[51.48066856389, -0.43486585657],[51.48069439955, -0.43561397327],[51.48069439955, -0.43561397327],[51.48069787178, -0.43571452835],[51.48084642555, -0.44011624810],[51.48097092824, -0.44339550777],[51.48098622067, -0.44387023168],[51.48101715944, -0.44458901628],[51.48101715944, -0.44458901628],[51.48107719721, -0.44598413765],[51.48117004053, -0.44824200221],[51.48121813675, -0.44983892688],[51.48123392046, -0.45172499141],[51.48123392046, -0.45172499141],[51.48124919304, -0.45355344035],[51.48129691144, -0.45444471515],[51.48129012493, -0.45529462883],[51.48128928820, -0.45591391845],[51.48112317418, -0.45832455746],[51.48109062719, -0.45858487937],[51.48099827702, -0.45976890176],[51.48095066718, -0.46093701191],[51.48101222606, -0.46220225688],[51.48108821216, -0.46307785006],[51.48108821216, -0.46307785006],[51.48113932940, -0.46366692156],[51.48136176004, -0.46554603568],[51.48149969166, -0.46715437204],[51.48153271477, -0.46830538375],[51.48157396338, -0.46939851565],[51.48157716811, -0.46948468995]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00007425",
                        "name": "Great West Road / Basildene Road",
                        "uri": "/StopPoint/490G00007425",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00015462",
                        "name": "Henlys Roundabout",
                        "uri": "/StopPoint/490G00015462",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00011470",
                        "name": "Rectory Road",
                        "uri": "/StopPoint/490G00011470",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00005707",
                        "name": "Cranford Library / the Parkway",
                        "uri": "/StopPoint/490G00005707",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00013235",
                        "name": "The Avenue",
                        "uri": "/StopPoint/490G00013235",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00005704",
                        "name": "Waye Avenue",
                        "uri": "/StopPoint/490G00005704",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00013596",
                        "name": "Craneswater",
                        "uri": "/StopPoint/490G00013596",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00010677",
                        "name": "Oxford Avenue",
                        "uri": "/StopPoint/490G00010677",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00007811",
                        "name": "Harlington Corner",
                        "uri": "/StopPoint/490G00007811",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00004149",
                        "name": "Mondial Way",
                        "uri": "/StopPoint/490G00004149",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00008021",
                        "name": "Sipson Road",
                        "uri": "/StopPoint/490G00008021",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00010249",
                        "name": "Bath Road / Newport Road",
                        "uri": "/StopPoint/490G00010249",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "490G00005530",
                        "name": "Compass Centre",
                        "uri": "/StopPoint/490G00005530",
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
                    "name": "81",
                    "directions": [
                        "Slough"
                    ],
                    "lineIdentifier": {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "81",
                        "name": "81",
                        "uri": "/Line/81",
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
            "scheduledDepartureTime": "2024-02-27T11:55:00",
            "scheduledArrivalTime": "2024-02-27T12:12:00",
            "interChangeDuration": "5",
            "interChangePosition": "AFTER"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 54,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "RA1 bus to Reading Town Centre, Reading RailAir",
                "detailed": "RA1 bus towards Reading Rail Stn",
                "steps": []
            },
            "obstacles": [],
            "departureTime": "2024-02-27T12:21:00",
            "arrivalTime": "2024-02-27T13:15:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "naptanId": "490G00005530",
                "platformName": "",
                "stopLetter": "BW",
                "icsCode": "1005530",
                "individualStopId": "490005530W",
                "commonName": "Compass Centre",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.48149419608,
                "lon": -0.46948759479
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "platformName": "->E",
                "stopLetter": "->E",
                "icsCode": "1000973",
                "individualStopId": "039027060027",
                "commonName": "Reading Town Centre, Reading RailAir",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.458114254989994,
                "lon": -0.97131693886999992
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.48157716811, -0.46948468995],[51.48171244734, -0.47312387768],[51.48168979635, -0.47483841564],[51.48168904357, -0.47547210778],[51.48164951764, -0.47658234197],[51.48197040121, -0.47913513650],[51.48205782896, -0.47963628548],[51.48218549832, -0.48046733709],[51.48232140446, -0.48124051281],[51.48276951277, -0.48390437194],[51.48311950170, -0.48593784433],[51.48349745228, -0.48874813462],[51.48356982985, -0.49087725213],[51.48353978165, -0.49273611255],[51.48318960501, -0.49277646099],[51.48266151074, -0.49296669189],[51.48035748564, -0.49420911908],[51.47983930096, -0.49447099918],[51.47956195441, -0.49458093669],[51.47931723521, -0.49443058528],[51.47921614521, -0.49426110517],[51.47917982202, -0.49423349986],[51.47897364353, -0.49428349121],[51.47894704799, -0.49431316823],[51.47878266944, -0.49411697275],[51.47847281256, -0.49379596583],[51.47811094290, -0.49432629850],[51.47747683240, -0.49466398101],[51.47637661719, -0.49511779221],[51.47558693110, -0.49524457513],[51.47494672312, -0.49510724688],[51.47504171630, -0.49480173364],[51.47549155412, -0.49341897151],[51.47553298239, -0.49314401513],[51.47542134457, -0.49215412648],[51.47499825298, -0.49141930779],[51.47445904889, -0.49074593142],[51.47374720851, -0.48993428030],[51.47349349509, -0.48978426916],[51.47306057000, -0.48968337420],[51.47184880416, -0.48969239014],[51.47184880416, -0.48969239014],[51.47024627978, -0.48970431168],[51.47011219542, -0.48976633036],[51.46976183377, -0.48979229590],[51.46957604295, -0.49002879292],[51.46958104580, -0.49041736531],[51.46950200289, -0.49056395051],[51.46942777518, -0.49108471489],[51.47013035107, -0.49117672113],[51.47075332744, -0.49137214194],[51.47130624755, -0.49171386056],[51.47215179153, -0.49243469900],[51.47245395851, -0.49285669680],[51.47250148996, -0.49305671096],[51.47287759569, -0.49363466647],[51.47349767900, -0.49430539113],[51.47441363684, -0.49490880028],[51.47445125292, -0.49503715527],[51.47430860659, -0.49583380354],[51.47378305248, -0.49832771638],[51.47365124884, -0.49997352494],[51.47367220033, -0.50090877019],[51.47404299287, -0.50318606928],[51.47412243103, -0.50377383241],[51.47417820754, -0.50532711192],[51.47404704617, -0.50632493430],[51.47397843817, -0.50658635786],[51.47353010565, -0.50739293717],[51.47311938453, -0.50762232272],[51.47275691558, -0.50740377137],[51.47258008877, -0.50693438795],[51.47262668815, -0.50635692187],[51.47290863471, -0.50590135419],[51.47318452569, -0.50567635951],[51.47339804738, -0.50549659676],[51.47390818738, -0.50530713844],[51.47542044468, -0.50472493172],[51.47558938963, -0.50457541228],[51.47661168501, -0.50435478428],[51.47801956422, -0.50404953109],[51.47868268814, -0.50386943145],[51.47911247987, -0.50372576306],[51.47949732924, -0.50358356266],[51.48059684309, -0.50307234148],[51.48115045002, -0.50276619079],[51.48156959739, -0.50249323935],[51.48268340457, -0.50169346339],[51.48366182758, -0.50085488068],[51.48565917415, -0.49883061063],[51.48765943591, -0.49703651945],[51.48850558181, -0.49640374568],[51.48861288866, -0.49635700494],[51.48899809694, -0.49624350690],[51.48980243553, -0.49585694417],[51.49058294715, -0.49571602485],[51.49092561347, -0.49579117364],[51.49160288077, -0.49601376293],[51.49217357933, -0.49634069846],[51.49298406433, -0.49713512141],[51.49354434456, -0.49805303727],[51.49392356004, -0.49887608486],[51.49432188602, -0.50049081940],[51.49438612284, -0.50129541905],[51.49426860156, -0.50335925214],[51.49426953259, -0.50413711579],[51.49416296464, -0.50494730695],[51.49401401707, -0.50596055496],[51.49388927629, -0.50675692561],[51.49344915282, -0.50962353169],[51.49326658767, -0.51082511017],[51.49297226332, -0.51527144768],[51.49301161545, -0.51980775379],[51.49316892429, -0.52945405561],[51.49306226059, -0.53242492305],[51.49303441234, -0.53307404296],[51.49290338524, -0.53482125004],[51.49282410944, -0.53567368321],[51.49266176801, -0.53707615901],[51.49196088690, -0.54144880195],[51.49150234315, -0.54362411230],[51.49014425804, -0.54868000526],[51.48972251450, -0.55020581038],[51.48929986189, -0.55165959677],[51.48779233966, -0.55702218983],[51.48730140807, -0.55878047008],[51.48670085791, -0.56186723773],[51.48644390879, -0.56511597201],[51.48652931776, -0.56842596194],[51.48693384237, -0.57136591720],[51.48760602929, -0.57413914025],[51.48840651674, -0.57637552054],[51.48961442017, -0.57884417555],[51.49085989958, -0.58070681463],[51.49244570324, -0.58245816688],[51.49755990858, -0.58748582274],[51.49852571628, -0.58853646906],[51.49933006378, -0.58962095676],[51.49993561089, -0.59062517101],[51.50099991783, -0.59314246033],[51.50161076727, -0.59534242759],[51.50197991230, -0.59763631857],[51.50211753919, -0.60012464156],[51.50212217931, -0.60051350963],[51.50211559601, -0.60071542025],[51.50211227592, -0.60119097874],[51.50204121226, -0.60655283954],[51.50201018968, -0.60848442296],[51.50203710835, -0.60999641661],[51.50223637283, -0.61239645842],[51.50320173088, -0.61723708029],[51.50336336743, -0.61798141243],[51.50489351100, -0.62499535544],[51.50506425628, -0.62575387663],[51.50523600854, -0.62659882555],[51.50650867287, -0.63239626347],[51.50888285305, -0.64326227499],[51.50986077307, -0.64774361148],[51.51075331881, -0.65185298534],[51.51113289572, -0.65358545980],[51.51120910557, -0.65395788848],[51.51154436706, -0.65574934432],[51.51167590809, -0.65702802761],[51.51177032598, -0.65820693330],[51.51178432506, -0.65943143635],[51.51171269710, -0.66103312984],[51.51151766448, -0.66285459126],[51.51142682913, -0.66356337165],[51.51081782194, -0.66773139750],[51.50996672682, -0.67356351796],[51.50910699960, -0.67945330670],[51.50851445651, -0.68193449376],[51.50795646341, -0.68349241176],[51.50682432740, -0.68597459397],[51.50505715652, -0.68956993512],[51.50430129977, -0.69113330836],[51.50314957669, -0.69348598727],[51.50256944289, -0.69468401560],[51.50144717384, -0.69726619345],[51.50049112048, -0.70024691393],[51.50002643697, -0.70213304008],[51.49952663891, -0.70491334676],[51.49919180253, -0.70879824413],[51.49915668210, -0.70969245229],[51.49922918682, -0.71301835899],[51.49944069009, -0.71672935399],[51.49945454826, -0.71799676239],[51.49940829835, -0.71952517795],[51.49910062456, -0.72264564075],[51.49861800370, -0.72539636932],[51.49771766291, -0.72860525743],[51.49728114988, -0.72981310668],[51.49625433450, -0.73214656680],[51.49433941519, -0.73551287226],[51.49285898758, -0.73831952732],[51.49224351509, -0.73961851535],[51.49079659173, -0.74304335795],[51.48858163867, -0.74949933623],[51.48699395972, -0.75324428802],[51.48591013596, -0.75533339719],[51.48430139101, -0.75795514260],[51.48204854442, -0.76089658661],[51.47905940068, -0.76394404266],[51.47599326317, -0.76651799362],[51.47378921608, -0.76813248435],[51.47124210416, -0.77047593550],[51.47069049186, -0.77103787260],[51.46820282378, -0.77391209010],[51.46715650482, -0.77532219866],[51.46625294884, -0.77662765137],[51.46401713676, -0.78038708654],[51.46231743697, -0.78382961123],[51.46192230829, -0.78474699030],[51.46031980589, -0.78890633768],[51.46004915347, -0.78969079189],[51.45842039232, -0.79393684764],[51.45659797450, -0.79772710151],[51.45415086681, -0.80199396476],[51.45306585800, -0.80405164400],[51.45150014681, -0.80747457010],[51.44881414602, -0.81482624460],[51.44677832276, -0.81981474110],[51.44650557905, -0.82041176105],[51.44517618465, -0.82323758594],[51.44108951557, -0.83089644880],[51.43924148312, -0.83494340352],[51.43733135593, -0.83999869908],[51.43624145731, -0.84345034616],[51.43611115042, -0.84391401078],[51.43602408909, -0.84420394161],[51.43595443951, -0.84443588549],[51.43583240992, -0.84482740256],[51.43562331441, -0.84550884342],[51.43513793882, -0.84644180596],[51.43490030882, -0.84696569769],[51.43434102470, -0.84769908279],[51.43415393609, -0.84787642205],[51.43396656459, -0.84802499493],[51.43345810485, -0.84844058568],[51.43305865015, -0.84896851375],[51.43281215992, -0.84950697648],[51.43265024189, -0.85041733606],[51.43278769285, -0.85343487222],[51.43280862549, -0.85373644695],[51.43271058378, -0.85566657297],[51.43255760755, -0.85657668512],[51.43229814821, -0.85763330167],[51.43205018870, -0.85894855694],[51.43222417516, -0.86019575826],[51.43266560735, -0.86120615231],[51.43355749749, -0.86230607842],[51.43450694060, -0.86377865945],[51.43491900530, -0.86454529848],[51.43565224808, -0.86598016186],[51.43584631881, -0.86652204754],[51.43612282393, -0.86722015226],[51.43778177369, -0.87234412583],[51.43882826332, -0.87644757778],[51.43935051022, -0.87934107706],[51.43976143862, -0.88282725839],[51.43991048909, -0.88715436447],[51.43987332845, -0.88892497076],[51.43978029647, -0.89049549801],[51.43959283905, -0.89254309835],[51.43954324633, -0.89300470468],[51.43934038230, -0.89437643555],[51.43919582454, -0.89525756954],[51.43915385621, -0.89557510902],[51.43911979328, -0.89577735663],[51.43897259463, -0.89733475982],[51.43905795422, -0.89972104042],[51.43913648514, -0.90042414561],[51.44068331240, -0.91395495358],[51.44121056978, -0.91651794197],[51.44211826636, -0.91938855635],[51.44414406522, -0.92456400897],[51.44596147944, -0.92860800064],[51.44673718779, -0.92985616520],[51.44765449300, -0.93085643221],[51.44902207502, -0.93193257806],[51.45144138312, -0.93396289200],[51.45253949865, -0.93507427002],[51.45328647221, -0.93613629306],[51.45476762207, -0.93784335780],[51.45494155919, -0.93818474216],[51.45512708984, -0.93881371175],[51.45507666488, -0.93920347982],[51.45502832020, -0.93982347950],[51.45501229128, -0.94003973880],[51.45489657047, -0.94116503342],[51.45481968715, -0.94161297855],[51.45443031905, -0.94330588633],[51.45387581008, -0.94563582665],[51.45363197791, -0.94651936063],[51.45339648326, -0.94733073331],[51.45323905335, -0.94782368048],[51.45306338323, -0.94828825944],[51.45293240337, -0.94872302480],[51.45286422311, -0.94914195423],[51.45292370593, -0.94975943920],[51.45308040142, -0.95018760186],[51.45312125501, -0.95073355837],[51.45313269082, -0.95100674301],[51.45315108140, -0.95120811870],[51.45315108140, -0.95120811870],[51.45323236790, -0.95209824828],[51.45331122864, -0.95287361048],[51.45347818140, -0.95445291599],[51.45357692937, -0.95544371344],[51.45364677801, -0.95621929254],[51.45374410355, -0.95705181639],[51.45378402989, -0.95749706286],[51.45386170459, -0.95814294099],[51.45390162680, -0.95858818961],[51.45392177890, -0.95883239812],[51.45394218593, -0.95910538541],[51.45392159938, -0.95982546221],[51.45389832969, -0.96024336378],[51.45383061832, -0.96071984250],[51.45377973791, -0.96106640871],[51.45372024870, -0.96145634578],[51.45390323500, -0.96181199851],[51.45408354568, -0.96186547806],[51.45430032604, -0.96197570015],[51.45461676101, -0.96217001806],[51.45478922741, -0.96235320964],[51.45497992823, -0.96256477434],[51.45517037413, -0.96274756143],[51.45542387741, -0.96294331403],[51.45611763879, -0.96310031033],[51.45682000831, -0.96321393702],[51.45687433030, -0.96325588586],[51.45715128032, -0.96407002443],[51.45723841727, -0.96477331969],[51.45731643302, -0.96546243051],[51.45739292231, -0.96597885902],[51.45760376297, -0.96745660833],[51.45771911592, -0.96830321432],[51.45779407424, -0.96864696591],[51.45789726680, -0.96913401677],[51.45790752171, -0.96927771998],[51.45793220255, -0.97004001572],[51.45794612016, -0.97060104626],[51.45794877233, -0.97090324862],[51.45794965622, -0.97100398276],[51.45794672474, -0.97169493321],[51.45795101378, -0.97218421343],[51.45814854332, -0.97215099072],[51.45806574056, -0.97193694823],[51.45806031452, -0.97131815117]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "id": "910GHTRBUS5",
                        "name": "Heathrow Terminal 5",
                        "uri": "/StopPoint/910GHTRBUS5",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "name": "Reading, Cemetery Junction",
                        "uri": "/StopPoint/",
                        "type": "StopPoint",
                        "routeType": "Unknown",
                        "status": "Unknown"
                    },
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "name": "Reading Town Centre, Reading RailAir",
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
                    "name": "RA1",
                    "directions": [
                        "Reading Rail Stn"
                    ],
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
                "network": "set"
            },
            "disruptions": [],
            "plannedWorks": [],
            "isDisrupted": false,
            "hasFixedLocations": true,
            "scheduledDepartureTime": "2024-02-27T12:21:00",
            "scheduledArrivalTime": "2024-02-27T13:15:00"
        },
        {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
            "duration": 6,
            "instruction": {
                "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
                "summary": "Walk to Reading Rail Station",
                "detailed": "Walk to Reading Rail Station",
                "steps": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
                        "description": "Station Approach for 89 metres",
                        "turnDirection": "STRAIGHT",
                        "streetName": "Station Approach",
                        "distance": 89,
                        "cumulativeDistance": 89,
                        "skyDirection": 317,
                        "skyDirectionDescription": "NorthWest",
                        "cumulativeTravelTime": 82,
                        "latitude": 51.458114254989994,
                        "longitude": -0.97131693886999992,
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
                    "stopId": 1000973,
                    "position": "IDEST"
                }
            ],
            "departureTime": "2024-02-27T13:15:00",
            "arrivalTime": "2024-02-27T13:21:00",
            "departurePoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "platformName": "->E",
                "stopLetter": "->E",
                "icsCode": "1000973",
                "individualStopId": "039027060027",
                "commonName": "Reading Town Centre, Reading RailAir",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.458114254989994,
                "lon": -0.97131693886999992
            },
            "arrivalPoint": {
                "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
                "platformName": "",
                "icsCode": "1000972",
                "individualStopId": "0390RDNG4AB0",
                "commonName": "Reading Rail Station",
                "placeType": "StopPoint",
                "additionalProperties": [],
                "lat": 51.458516253700004,
                "lon": -0.9720419778099999
            },
            "path": {
                "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
                "lineString": "[[51.45811425499, -0.97131693887],[51.45806027933, -0.97131413877],[51.45806570538, -0.97193293582],[51.45806574056, -0.97193694823],[51.45814854332, -0.97215099072],[51.45834731119, -0.97239829130],[51.45834859535, -0.97240558792]]",
                "stopPoints": [
                    {
                        "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
                        "name": "Reading Rail Station",
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
            "scheduledDepartureTime": "2024-02-27T13:15:00",
            "scheduledArrivalTime": "2024-02-27T13:21:00",
            "interChangeDuration": "6",
            "interChangePosition": "IDEST"
        }
    ]
}
"""#
