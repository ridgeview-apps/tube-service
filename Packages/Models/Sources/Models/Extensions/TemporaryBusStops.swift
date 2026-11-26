import Foundation

/// Real stops around the two test areas, until the seed data replaces them.
enum TemporaryBusStops {

    static let all = kingsCross + totteridgeAndWhetstone

    static let kingsCross: [BusStop] = [
        BusStop(
            id: "490000129D",
            name: "King's Cross Station",
            letter: "D",
            towards: "Farringdon or Holborn Circus",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.53045, lon: -0.12328),
            routes: ["46", "63", "N63"]
        ),
        BusStop(
            id: "490000129E",
            name: "King's Cross Station",
            letter: "E",
            towards: "Angel Islington",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.5305, lon: -0.12307),
            routes: ["30", "73", "205", "214", "N73", "N205"]
        ),
        BusStop(
            id: "490000129R",
            name: "King's Cross Station",
            letter: "R",
            towards: "Euston",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.53047, lon: -0.12169),
            routes: ["30", "73", "91", "205", "390", "N73", "N91", "N205"]
        ),
        BusStop(
            id: "490001171G",
            name: "King's Cross Station / York Way",
            letter: "G",
            towards: "Archway or Holloway",
            stopAreaID: "490G000479",
            location: LocationCoordinate(lat: 51.53128, lon: -0.12268),
            routes: ["17", "63", "91", "390", "476", "N63", "N91"]
        ),
        BusStop(
            id: "490001171H",
            name: "King's Cross Stn / Pentonville Rd",
            letter: "H",
            towards: "Euston or Holborn",
            stopAreaID: "490G000480",
            location: LocationCoordinate(lat: 51.53147, lon: -0.12088),
            routes: ["17", "91", "390", "476", "N91"]
        ),
        BusStop(
            id: "490001172K",
            name: "King's Cross Road",
            letter: "K",
            towards: "Angel Islington",
            stopAreaID: "490G00019931",
            location: LocationCoordinate(lat: 51.53111, lon: -0.11856),
            routes: ["30", "73", "205", "214", "476", "N73", "N205"]
        ),
        BusStop(
            id: "490001172X",
            name: "King's Cross / Caledonian Road",
            letter: "X",
            towards: "Camden Town or Euston",
            stopAreaID: "490G00005909",
            location: LocationCoordinate(lat: 51.53084, lon: -0.12052),
            routes: ["30", "73", "205", "214", "476", "N73", "N205"]
        ),
        BusStop(
            id: "490001276S",
            name: "St Pancras International Station",
            letter: "S",
            towards: "Farringdon, Holborn Circus or Angel",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.5316, lon: -0.12718),
            routes: ["1", "46", "63", "214", "N63"]
        ),
        BusStop(
            id: "490003087W1",
            name: "Acton Street",
            letter: "HA",
            towards: "Holborn Circus",
            stopAreaID: "490G00003087",
            location: LocationCoordinate(lat: 51.52835, lon: -0.11809),
            routes: ["17", "46"]
        ),
        BusStop(
            id: "490004354N",
            name: "Swinton Street",
            letter: "N",
            towards: "Camden Town or Holloway",
            stopAreaID: "490G00013117",
            location: LocationCoordinate(lat: 51.52924, lon: -0.12014),
            routes: ["17", "46", "63", "N63"]
        ),
        BusStop(
            id: "490004722A",
            name: "St Pancras International Station",
            letter: "A",
            towards: "Tottenham Court Road, Russell Square or Baker St",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.52946, lon: -0.12499),
            routes: ["30", "73", "91", "205", "390", "N73", "N91", "N205"]
        ),
        BusStop(
            id: "490004722M",
            name: "St Pancras International Station",
            letter: "M",
            towards: "Holloway or Tufnell Park",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.52976, lon: -0.12485),
            routes: ["91", "390", "N91"]
        ),
        BusStop(
            id: "490010929L",
            name: "King's Cross Road / Pentonville Road",
            letter: "L",
            towards: "Chancery Lane or Farringdon Station",
            stopAreaID: "490G000700",
            location: LocationCoordinate(lat: 51.53055, lon: -0.11791),
            routes: ["17", "46", "63", "N63"]
        ),
        BusStop(
            id: "490012149N",
            name: "Acton Street",
            letter: "HF",
            towards: "Camden Town or Holloway",
            stopAreaID: "490G00003087",
            location: LocationCoordinate(lat: 51.52761, lon: -0.11872),
            routes: ["17", "46"]
        ),
        BusStop(
            id: "490012553B",
            name: "St Pancras Intern'l & King's X Stns",
            letter: "T",
            towards: "Camden Town or Camden Road Station",
            stopAreaID: "490G000760",
            location: LocationCoordinate(lat: 51.53055, lon: -0.12473),
            routes: ["46", "214"]
        ),
        BusStop(
            id: "490015700C",
            name: "British Library",
            letter: "C",
            towards: "Angel Islington, Tufnell Park or Holloway",
            stopAreaID: "490G00009498",
            location: LocationCoordinate(lat: 51.52903, lon: -0.12661),
            routes: ["30", "73", "91", "205", "390", "N73", "N91", "N205"]
        )
    ]

    static let totteridgeAndWhetstone: [BusStop] = [
        BusStop(
            id: "490000237A",
            name: "Totteridge & Whetstone Station",
            letter: "A",
            towards: "Arnos Grove or East Barnet",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.63016, lon: -0.17788),
            routes: ["251", "326", "628", "688"]
        ),
        BusStop(
            id: "490000237B",
            name: "Totteridge & Whetstone Station",
            letter: "B",
            towards: "Mill Hill or Finchley",
            stopAreaID: nil,
            location: LocationCoordinate(lat: 51.63008, lon: -0.17676),
            routes: ["251", "326", "688"]
        ),
        BusStop(
            id: "490001985Z",
            name: "Hill Crescent",
            letter: nil,
            towards: nil,
            stopAreaID: "490G00001985",
            location: LocationCoordinate(lat: 51.6302, lon: -0.18278),
            routes: ["326"]
        ),
        BusStop(
            id: "490002256Y",
            name: "Greenway / Totteridge",
            letter: nil,
            towards: nil,
            stopAreaID: "490G00002256",
            location: LocationCoordinate(lat: 51.62862, lon: -0.18306),
            routes: ["326"]
        ),
        BusStop(
            id: "490002256Z",
            name: "Greenway / Totteridge",
            letter: nil,
            towards: nil,
            stopAreaID: "490G00002256",
            location: LocationCoordinate(lat: 51.62916, lon: -0.18307),
            routes: ["326"]
        ),
        BusStop(
            id: "490003425E",
            name: "Ashcroft Court",
            letter: nil,
            towards: "Arnos Grove or Southgate",
            stopAreaID: "490G00003425",
            location: LocationCoordinate(lat: 51.62992, lon: -0.16928),
            routes: ["34", "125", "251", "628", "688"]
        ),
        BusStop(
            id: "490004553N",
            name: "Buckingham Avenue",
            letter: nil,
            towards: "High Barnet",
            stopAreaID: "490G00004553",
            location: LocationCoordinate(lat: 51.63562, lon: -0.17684),
            routes: ["34", "234", "263", "326", "626", "634", "N20"]
        ),
        BusStop(
            id: "490004978N",
            name: "Chandos Avenue",
            letter: "K",
            towards: "High Barnet",
            stopAreaID: "490G00004978",
            location: LocationCoordinate(lat: 51.63332, lon: -0.17594),
            routes: ["34", "234", "263", "326", "626", "634", "N20"]
        ),
        BusStop(
            id: "490004978S",
            name: "Chandos Avenue",
            letter: "L",
            towards: "North Finchley, Hendon or Muswell Hill",
            stopAreaID: "490G00004978",
            location: LocationCoordinate(lat: 51.63389, lon: -0.17586),
            routes: ["34", "234", "263", "326", "626", "634", "N20"]
        ),
        BusStop(
            id: "490006060N",
            name: "Derwent Crescent",
            letter: "F",
            towards: "High Barnet or Southgate",
            stopAreaID: "490G00006060",
            location: LocationCoordinate(lat: 51.62402, lon: -0.17645),
            routes: ["125", "263", "626", "N20"]
        ),
        BusStop(
            id: "490007027S",
            name: "Swan Lane",
            letter: "H",
            towards: "East Finchley or Finchley Central",
            stopAreaID: "490G00013104",
            location: LocationCoordinate(lat: 51.62669, lon: -0.17531),
            routes: ["125", "263", "626", "N20"]
        ),
        BusStop(
            id: "490007028N",
            name: "Whetstone High Road / Friern Barnet Lane",
            letter: "I",
            towards: "High Barnet or Southgate",
            stopAreaID: "490G00007028",
            location: LocationCoordinate(lat: 51.62827, lon: -0.17472),
            routes: ["125", "234", "263", "383", "626", "634", "N20"]
        ),
        BusStop(
            id: "490007028S",
            name: "Whetstone High Road / Friern Barnet Lane",
            letter: "E",
            towards: "North Finchley or Muswell Hill",
            stopAreaID: "490G00007028",
            location: LocationCoordinate(lat: 51.62873, lon: -0.17446),
            routes: ["125", "234", "263", "383", "626", "634", "N20"]
        ),
        BusStop(
            id: "490009188E",
            name: "Links Drive",
            letter: nil,
            towards: "Arnos Grove",
            stopAreaID: "490G00009188",
            location: LocationCoordinate(lat: 51.631, lon: -0.18713),
            routes: ["251", "628", "688"]
        ),
        BusStop(
            id: "490009188W",
            name: "Links Drive",
            letter: nil,
            towards: "Mill Hill",
            stopAreaID: "490G00009188",
            location: LocationCoordinate(lat: 51.63094, lon: -0.18785),
            routes: ["251", "688"]
        ),
        BusStop(
            id: "490009313E",
            name: "Longland Drive",
            letter: nil,
            towards: "Arnos Grove",
            stopAreaID: "490G00009313",
            location: LocationCoordinate(lat: 51.63008, lon: -0.17936),
            routes: ["251", "628", "688"]
        ),
        BusStop(
            id: "490009313W",
            name: "Longland Drive",
            letter: nil,
            towards: "Mill Hill",
            stopAreaID: "490G00009313",
            location: LocationCoordinate(lat: 51.63048, lon: -0.18313),
            routes: ["251", "688"]
        ),
        BusStop(
            id: "490009313Y",
            name: "Longland Drive",
            letter: nil,
            towards: nil,
            stopAreaID: "490G00009313",
            location: LocationCoordinate(lat: 51.62627, lon: -0.18499),
            routes: ["326"]
        ),
        BusStop(
            id: "490009313Z",
            name: "Longland Drive",
            letter: nil,
            towards: nil,
            stopAreaID: "490G00009313",
            location: LocationCoordinate(lat: 51.62672, lon: -0.18438),
            routes: ["326"]
        ),
        BusStop(
            id: "490010496W",
            name: "Oakleigh Park North",
            letter: nil,
            towards: "High Barnet, North Finchley or Totteridge",
            stopAreaID: "490G00010496",
            location: LocationCoordinate(lat: 51.63002, lon: -0.1702),
            routes: ["34", "125", "251", "688"]
        ),
        BusStop(
            id: "490013104N",
            name: "Swan Lane",
            letter: nil,
            towards: "High Barnet or Southgate",
            stopAreaID: "490G00013104",
            location: LocationCoordinate(lat: 51.62606, lon: -0.17592),
            routes: ["125", "263", "626", "N20"]
        ),
        BusStop(
            id: "490014562E",
            name: "Oakleigh Gardens",
            letter: "N",
            towards: "Oakleigh Park Station",
            stopAreaID: "490G00014562",
            location: LocationCoordinate(lat: 51.63108, lon: -0.17442),
            routes: ["383"]
        ),
        BusStop(
            id: "490014562W",
            name: "Oakleigh Gardens",
            letter: "O",
            towards: "Torrington Park",
            stopAreaID: "490G00014562",
            location: LocationCoordinate(lat: 51.63085, lon: -0.17452),
            routes: ["383"]
        ),
        BusStop(
            id: "490014563C",
            name: "Whetstone / the Griffin",
            letter: "C",
            towards: "Arnos Grove or Southgate",
            stopAreaID: "490G00014563",
            location: LocationCoordinate(lat: 51.63027, lon: -0.17305),
            routes: ["34", "125", "251", "628", "688"]
        ),
        BusStop(
            id: "490014563D",
            name: "Whetstone / the Griffin",
            letter: "D",
            towards: "Barnet, North Finchley or Totteridge",
            stopAreaID: "490G00014563",
            location: LocationCoordinate(lat: 51.6299, lon: -0.17398),
            routes: ["34", "125", "251", "688"]
        ),
        BusStop(
            id: "490014564F",
            name: "Sweets Way",
            letter: "F",
            towards: "Muswell Hill or Woodside Park",
            stopAreaID: "490G00014564",
            location: LocationCoordinate(lat: 51.62743, lon: -0.17442),
            routes: ["234", "383", "634"]
        ),
        BusStop(
            id: "490014564G",
            name: "Sweets Way",
            letter: "G",
            towards: "High Barnet",
            stopAreaID: "490G00014564",
            location: LocationCoordinate(lat: 51.62685, lon: -0.17416),
            routes: ["234", "383", "634"]
        ),
        BusStop(
            id: "490015488J",
            name: "Athenaeum Road",
            letter: "J",
            towards: "High Road Whetstone/ Friern Barnet Lane",
            stopAreaID: "490G00002320",
            location: LocationCoordinate(lat: 51.63124, lon: -0.17537),
            routes: ["34", "234", "263", "326", "626", "634", "N20"]
        ),
        BusStop(
            id: "490015488M",
            name: "High Road Whetstone / Athenaeum Road",
            letter: "M",
            towards: "North Finchley, Muswell Hill or Hendon",
            stopAreaID: "490G000901",
            location: LocationCoordinate(lat: 51.63101, lon: -0.17513),
            routes: ["34", "234", "263", "326", "626", "634", "N20"]
        )
    ]
}
