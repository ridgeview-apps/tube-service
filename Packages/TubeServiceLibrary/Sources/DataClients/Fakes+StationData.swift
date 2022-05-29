#if DEBUG

let fakeStations =
"""
[
  {
    "name" : "Abbey Road",
    "id" : "940GZZDLABR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLABR"
      }
    ]
  },
  {
    "name" : "Abbey Wood",
    "id" : "HUBABW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GABWDXR"
      }
    ]
  },
  {
    "name" : "Acton Main Line",
    "id" : "910GACTONML",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GACTONML"
      }
    ]
  },
  {
    "name" : "Acton Town",
    "id" : "940GZZLUACT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUACT"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUACT"
      }
    ]
  },
  {
    "name" : "Addington Village",
    "id" : "940GZZCRADV",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRADV"
      }
    ]
  },
  {
    "name" : "Addiscombe",
    "id" : "940GZZCRADD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRADD"
      }
    ]
  },
  {
    "name" : "Aldgate",
    "id" : "940GZZLUALD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle"
        ],
        "atcoCode" : "940GZZLUALD"
      },
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUALD"
      }
    ]
  },
  {
    "name" : "Aldgate East",
    "id" : "940GZZLUADE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUADE"
      }
    ]
  },
  {
    "name" : "All Saints",
    "id" : "940GZZDLALL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLALL"
      }
    ]
  },
  {
    "name" : "Alperton",
    "id" : "940GZZLUALP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUALP"
      }
    ]
  },
  {
    "name" : "Amersham",
    "id" : "HUBAMR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUAMS"
      }
    ]
  },
  {
    "name" : "Ampere Way",
    "id" : "940GZZCRAMP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRAMP"
      }
    ]
  },
  {
    "name" : "Angel",
    "id" : "940GZZLUAGL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUAGL"
      }
    ]
  },
  {
    "name" : "Archway",
    "id" : "940GZZLUACY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUACY"
      }
    ]
  },
  {
    "name" : "Arena",
    "id" : "940GZZCRARA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRARA"
      }
    ]
  },
  {
    "name" : "Arnos Grove",
    "id" : "940GZZLUASG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUASG"
      }
    ]
  },
  {
    "name" : "Arsenal",
    "id" : "940GZZLUASL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUASL"
      }
    ]
  },
  {
    "name" : "Avenue Road",
    "id" : "940GZZCRAVE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRAVE"
      }
    ]
  },
  {
    "name" : "Baker Street",
    "id" : "940GZZLUBST",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUBST"
      },
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUBST"
      },
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUBST"
      },
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUBST"
      }
    ]
  },
  {
    "name" : "Balham",
    "id" : "HUBBAL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUBLM"
      }
    ]
  },
  {
    "name" : "Bank",
    "id" : "HUBBAN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUBNK"
      },
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLBNK"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUBNK"
      },
      {
        "lineIds" : [
          "waterloo-city"
        ],
        "atcoCode" : "940GZZLUBNK"
      }
    ]
  },
  {
    "name" : "Barbican",
    "id" : "940GZZLUBBN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUBBN"
      }
    ]
  },
  {
    "name" : "Barking",
    "id" : "HUBBKG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUBKG"
      },
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUBKG"
      },
      {
        "lineIds" : [
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUBKG"
      }
    ]
  },
  {
    "name" : "Barkingside",
    "id" : "940GZZLUBKE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUBKE"
      }
    ]
  },
  {
    "name" : "Barons Court",
    "id" : "940GZZLUBSC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUBSC"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUBSC"
      }
    ]
  },
  {
    "name" : "Battersea Power Station",
    "id" : "940GZZBPSUST",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZBPSUST"
      }
    ]
  },
  {
    "name" : "Bayswater",
    "id" : "940GZZLUBWT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUBWT"
      }
    ]
  },
  {
    "name" : "Beckenham Junction",
    "id" : "HUBBEK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRBEK"
      }
    ]
  },
  {
    "name" : "Beckenham Road",
    "id" : "940GZZCRBRD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRBRD"
      }
    ]
  },
  {
    "name" : "Beckton",
    "id" : "940GZZDLBEC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLBEC"
      }
    ]
  },
  {
    "name" : "Beckton Park",
    "id" : "940GZZDLBPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLBPK"
      }
    ]
  },
  {
    "name" : "Becontree",
    "id" : "940GZZLUBEC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUBEC"
      }
    ]
  },
  {
    "name" : "Beddington Lane",
    "id" : "940GZZCRBED",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRBED"
      }
    ]
  },
  {
    "name" : "Belgrave Walk",
    "id" : "940GZZCRBGV",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRBGV"
      }
    ]
  },
  {
    "name" : "Belsize Park",
    "id" : "940GZZLUBZP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUBZP"
      }
    ]
  },
  {
    "name" : "Bermondsey",
    "id" : "940GZZLUBMY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUBMY"
      }
    ]
  },
  {
    "name" : "Bethnal Green",
    "id" : "940GZZLUBLG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUBLG"
      }
    ]
  },
  {
    "name" : "Birkbeck",
    "id" : "HUBBIR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRBIR"
      }
    ]
  },
  {
    "name" : "Blackfriars",
    "id" : "HUBBFR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUBKF"
      }
    ]
  },
  {
    "name" : "Blackhorse Lane",
    "id" : "940GZZCRBLA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRBLA"
      }
    ]
  },
  {
    "name" : "Blackhorse Road",
    "id" : "HUBBHO",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUBLR"
      }
    ]
  },
  {
    "name" : "Blackwall",
    "id" : "940GZZDLBLA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLBLA"
      }
    ]
  },
  {
    "name" : "Bond Street",
    "id" : "HUBBDS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUBND"
      },
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUBND"
      }
    ]
  },
  {
    "name" : "Borough",
    "id" : "940GZZLUBOR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUBOR"
      }
    ]
  },
  {
    "name" : "Boston Manor",
    "id" : "940GZZLUBOS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUBOS"
      }
    ]
  },
  {
    "name" : "Bounds Green",
    "id" : "940GZZLUBDS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUBDS"
      }
    ]
  },
  {
    "name" : "Bow Church",
    "id" : "940GZZDLBOW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLBOW"
      }
    ]
  },
  {
    "name" : "Bow Road",
    "id" : "940GZZLUBWR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUBWR"
      }
    ]
  },
  {
    "name" : "Brent Cross",
    "id" : "940GZZLUBTX",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUBTX"
      }
    ]
  },
  {
    "name" : "Brentwood",
    "id" : "910GBRTWOOD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GBRTWOOD"
      }
    ]
  },
  {
    "name" : "Brixton",
    "id" : "HUBBRX",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUBXN"
      }
    ]
  },
  {
    "name" : "Bromley-by-Bow",
    "id" : "940GZZLUBBB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUBBB"
      }
    ]
  },
  {
    "name" : "Buckhurst Hill",
    "id" : "940GZZLUBKH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUBKH"
      }
    ]
  },
  {
    "name" : "Burnham (Berks)",
    "id" : "910GBNHAM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GBNHAM"
      }
    ]
  },
  {
    "name" : "Burnt Oak",
    "id" : "940GZZLUBTK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUBTK"
      }
    ]
  },
  {
    "name" : "Caledonian Road",
    "id" : "940GZZLUCAR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUCAR"
      }
    ]
  },
  {
    "name" : "Camden Town",
    "id" : "940GZZLUCTN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUCTN"
      }
    ]
  },
  {
    "name" : "Canada Water",
    "id" : "HUBZCW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUCWR"
      }
    ]
  },
  {
    "name" : "Canary Wharf",
    "id" : "HUBCAW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLCAN"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GCANWHRF"
      },
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUCYF"
      }
    ]
  },
  {
    "name" : "Canning Town",
    "id" : "HUBCAN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLCGT"
      },
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUCGT"
      }
    ]
  },
  {
    "name" : "Cannon Street",
    "id" : "HUBCST",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUCST"
      }
    ]
  },
  {
    "name" : "Canons Park",
    "id" : "940GZZLUCPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUCPK"
      }
    ]
  },
  {
    "name" : "Centrale",
    "id" : "940GZZCRCTR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRCTR"
      }
    ]
  },
  {
    "name" : "Chadwell Heath",
    "id" : "910GCHDWLHT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GCHDWLHT"
      }
    ]
  },
  {
    "name" : "Chalfont & Latimer",
    "id" : "HUBCFO",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUCAL"
      }
    ]
  },
  {
    "name" : "Chalk Farm",
    "id" : "940GZZLUCFM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUCFM"
      }
    ]
  },
  {
    "name" : "Chancery Lane",
    "id" : "940GZZLUCHL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUCHL"
      }
    ]
  },
  {
    "name" : "Charing Cross",
    "id" : "HUBCHX",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUCHX"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUCHX"
      }
    ]
  },
  {
    "name" : "Chesham",
    "id" : "940GZZLUCSM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUCSM"
      }
    ]
  },
  {
    "name" : "Chigwell",
    "id" : "940GZZLUCWL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUCWL"
      }
    ]
  },
  {
    "name" : "Chiswick Park",
    "id" : "940GZZLUCWP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUCWP"
      }
    ]
  },
  {
    "name" : "Chorleywood",
    "id" : "HUBCLW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUCYD"
      }
    ]
  },
  {
    "name" : "Church Street",
    "id" : "940GZZCRCHR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRCHR"
      }
    ]
  },
  {
    "name" : "Clapham Common",
    "id" : "940GZZLUCPC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUCPC"
      }
    ]
  },
  {
    "name" : "Clapham North",
    "id" : "940GZZLUCPN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUCPN"
      }
    ]
  },
  {
    "name" : "Clapham South",
    "id" : "940GZZLUCPS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUCPS"
      }
    ]
  },
  {
    "name" : "Cockfosters",
    "id" : "940GZZLUCKS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUCKS"
      }
    ]
  },
  {
    "name" : "Colindale",
    "id" : "940GZZLUCND",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUCND"
      }
    ]
  },
  {
    "name" : "Colliers Wood",
    "id" : "940GZZLUCSD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUCSD"
      }
    ]
  },
  {
    "name" : "Coombe Lane",
    "id" : "940GZZCRCOO",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRCOO"
      }
    ]
  },
  {
    "name" : "Covent Garden",
    "id" : "940GZZLUCGN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUCGN"
      }
    ]
  },
  {
    "name" : "Crossharbour",
    "id" : "940GZZDLCLA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLCLA"
      }
    ]
  },
  {
    "name" : "Croxley",
    "id" : "940GZZLUCXY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUCXY"
      }
    ]
  },
  {
    "name" : "Custom House",
    "id" : "HUBCUS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLCUS"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GCSTMHSXR"
      }
    ]
  },
  {
    "name" : "Cutty Sark",
    "id" : "HUBCUT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLCUT"
      }
    ]
  },
  {
    "name" : "Cyprus",
    "id" : "940GZZDLCYP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLCYP"
      }
    ]
  },
  {
    "name" : "Dagenham East",
    "id" : "940GZZLUDGE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUDGE"
      }
    ]
  },
  {
    "name" : "Dagenham Heathway",
    "id" : "940GZZLUDGY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUDGY"
      }
    ]
  },
  {
    "name" : "Debden",
    "id" : "940GZZLUDBN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUDBN"
      }
    ]
  },
  {
    "name" : "Deptford Bridge",
    "id" : "940GZZDLDEP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLDEP"
      }
    ]
  },
  {
    "name" : "Devons Road",
    "id" : "940GZZDLDEV",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLDEV"
      }
    ]
  },
  {
    "name" : "Dollis Hill",
    "id" : "940GZZLUDOH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUDOH"
      }
    ]
  },
  {
    "name" : "Dundonald Road",
    "id" : "940GZZCRDDR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRDDR"
      }
    ]
  },
  {
    "name" : "Ealing Broadway",
    "id" : "HUBEAL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUEBY"
      },
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUEBY"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GEALINGB"
      }
    ]
  },
  {
    "name" : "Ealing Common",
    "id" : "940GZZLUECM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUECM"
      }
    ]
  },
  {
    "name" : "Earl's Court",
    "id" : "940GZZLUECT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUECT"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUECT"
      }
    ]
  },
  {
    "name" : "East Acton",
    "id" : "940GZZLUEAN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUEAN"
      }
    ]
  },
  {
    "name" : "East Croydon",
    "id" : "HUBECY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRECR"
      }
    ]
  },
  {
    "name" : "East Finchley",
    "id" : "940GZZLUEFY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUEFY"
      }
    ]
  },
  {
    "name" : "East Ham",
    "id" : "940GZZLUEHM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUEHM"
      }
    ]
  },
  {
    "name" : "East India",
    "id" : "940GZZDLEIN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLEIN"
      }
    ]
  },
  {
    "name" : "East Putney",
    "id" : "940GZZLUEPY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUEPY"
      }
    ]
  },
  {
    "name" : "Eastcote",
    "id" : "940GZZLUEAE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUEAE"
      }
    ]
  },
  {
    "name" : "Edgware",
    "id" : "940GZZLUEGW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUEGW"
      }
    ]
  },
  {
    "name" : "Edgware Road (Bakerloo)",
    "id" : "940GZZLUERB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUERB"
      }
    ]
  },
  {
    "name" : "Edgware Road (Circle Line)",
    "id" : "940GZZLUERC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle"
        ],
        "atcoCode" : "940GZZLUERC"
      },
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUERC"
      },
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUERC"
      }
    ]
  },
  {
    "name" : "Elephant & Castle",
    "id" : "HUBEPH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUEAC"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUEAC"
      }
    ]
  },
  {
    "name" : "Elm Park",
    "id" : "940GZZLUEPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUEPK"
      }
    ]
  },
  {
    "name" : "Elmers End",
    "id" : "HUBELM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRELM"
      }
    ]
  },
  {
    "name" : "Elverson Road",
    "id" : "940GZZDLELV",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLELV"
      }
    ]
  },
  {
    "name" : "Embankment",
    "id" : "940GZZLUEMB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUEMB"
      },
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUEMB"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUEMB"
      }
    ]
  },
  {
    "name" : "Epping",
    "id" : "940GZZLUEPG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUEPG"
      }
    ]
  },
  {
    "name" : "Euston",
    "id" : "HUBEUS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUEUS"
      },
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUEUS"
      }
    ]
  },
  {
    "name" : "Euston Square",
    "id" : "940GZZLUESQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUESQ"
      }
    ]
  },
  {
    "name" : "Fairlop",
    "id" : "940GZZLUFLP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUFLP"
      }
    ]
  },
  {
    "name" : "Farringdon",
    "id" : "HUBZFD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUFCN"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GFRNDXR"
      }
    ]
  },
  {
    "name" : "Fieldway",
    "id" : "940GZZCRFLD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRFLD"
      }
    ]
  },
  {
    "name" : "Finchley Central",
    "id" : "940GZZLUFYC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUFYC"
      }
    ]
  },
  {
    "name" : "Finchley Road",
    "id" : "940GZZLUFYR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUFYR"
      },
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUFYR"
      }
    ]
  },
  {
    "name" : "Finsbury Park",
    "id" : "HUBFPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUFPK"
      },
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUFPK"
      }
    ]
  },
  {
    "name" : "Forest Gate",
    "id" : "910GFRSTGT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GFRSTGT"
      }
    ]
  },
  {
    "name" : "Fulham Broadway",
    "id" : "940GZZLUFBY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUFBY"
      }
    ]
  },
  {
    "name" : "Gallions Reach",
    "id" : "940GZZDLGAL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLGAL"
      }
    ]
  },
  {
    "name" : "Gants Hill",
    "id" : "940GZZLUGTH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUGTH"
      }
    ]
  },
  {
    "name" : "George Street",
    "id" : "940GZZCRCEN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRCEN"
      }
    ]
  },
  {
    "name" : "Gidea Park",
    "id" : "910GGIDEAPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GGIDEAPK"
      }
    ]
  },
  {
    "name" : "Gloucester Road",
    "id" : "940GZZLUGTR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle"
        ],
        "atcoCode" : "940GZZLUGTR"
      },
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUGTR"
      },
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUGTR"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUGTR"
      }
    ]
  },
  {
    "name" : "Golders Green",
    "id" : "940GZZLUGGN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUGGN"
      }
    ]
  },
  {
    "name" : "Goldhawk Road",
    "id" : "940GZZLUGHK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUGHK"
      }
    ]
  },
  {
    "name" : "Goodge Street",
    "id" : "940GZZLUGDG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUGDG"
      }
    ]
  },
  {
    "name" : "Goodmayes",
    "id" : "910GGODMAYS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GGODMAYS"
      }
    ]
  },
  {
    "name" : "Grange Hill",
    "id" : "940GZZLUGGH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUGGH"
      }
    ]
  },
  {
    "name" : "Gravel Hill",
    "id" : "940GZZCRGRA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRGRA"
      }
    ]
  },
  {
    "name" : "Great Portland Street",
    "id" : "940GZZLUGPS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUGPS"
      }
    ]
  },
  {
    "name" : "Green Park",
    "id" : "940GZZLUGPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUGPK"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUGPK"
      },
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUGPK"
      }
    ]
  },
  {
    "name" : "Greenford",
    "id" : "HUBGFD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUGFD"
      }
    ]
  },
  {
    "name" : "Greenwich",
    "id" : "HUBGNW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLGRE"
      }
    ]
  },
  {
    "name" : "Gunnersbury",
    "id" : "HUBGUN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUGBY"
      }
    ]
  },
  {
    "name" : "Hainault",
    "id" : "940GZZLUHLT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUHLT"
      }
    ]
  },
  {
    "name" : "Hammersmith",
    "id" : "HUBHMS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUHSC"
      },
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUHSD"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHSD"
      }
    ]
  },
  {
    "name" : "Hampstead",
    "id" : "940GZZLUHTD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUHTD"
      }
    ]
  },
  {
    "name" : "Hanger Lane",
    "id" : "940GZZLUHGR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUHGR"
      }
    ]
  },
  {
    "name" : "Hanwell",
    "id" : "910GHANWELL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GHANWELL"
      }
    ]
  },
  {
    "name" : "Harlesden",
    "id" : "HUBHDN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUHSN"
      }
    ]
  },
  {
    "name" : "Harold Wood",
    "id" : "910GHRLDWOD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GHRLDWOD"
      }
    ]
  },
  {
    "name" : "Harrington Road",
    "id" : "940GZZCRHAR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRHAR"
      }
    ]
  },
  {
    "name" : "Harrow & Wealdstone",
    "id" : "HUBHRW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUHAW"
      }
    ]
  },
  {
    "name" : "Harrow-on-the-Hill",
    "id" : "HUBHOH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUHOH"
      }
    ]
  },
  {
    "name" : "Hatton Cross",
    "id" : "940GZZLUHNX",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHNX"
      }
    ]
  },
  {
    "name" : "Hayes & Harlington",
    "id" : "910GHAYESAH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GHAYESAH"
      }
    ]
  },
  {
    "name" : "Heathrow Airport Terminal 4",
    "id" : "HUBHX4",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHR4"
      }
    ]
  },
  {
    "name" : "Heathrow Airport Terminal 5",
    "id" : "HUBHX5",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GHTRWTM5"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHR5"
      }
    ]
  },
  {
    "name" : "Heathrow Terminals 2 & 3",
    "id" : "HUBH13",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GHTRWAPT"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHRC"
      }
    ]
  },
  {
    "name" : "Hendon Central",
    "id" : "940GZZLUHCL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUHCL"
      }
    ]
  },
  {
    "name" : "Heron Quays",
    "id" : "940GZZDLHEQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLHEQ"
      }
    ]
  },
  {
    "name" : "High Barnet",
    "id" : "940GZZLUHBT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUHBT"
      }
    ]
  },
  {
    "name" : "High Street Kensington",
    "id" : "940GZZLUHSK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUHSK"
      }
    ]
  },
  {
    "name" : "Highbury & Islington",
    "id" : "HUBHHY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUHAI"
      }
    ]
  },
  {
    "name" : "Highgate",
    "id" : "940GZZLUHGT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUHGT"
      }
    ]
  },
  {
    "name" : "Hillingdon",
    "id" : "940GZZLUHGD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHGD"
      }
    ]
  },
  {
    "name" : "Holborn",
    "id" : "940GZZLUHBN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUHBN"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHBN"
      }
    ]
  },
  {
    "name" : "Holland Park",
    "id" : "940GZZLUHPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUHPK"
      }
    ]
  },
  {
    "name" : "Holloway Road",
    "id" : "940GZZLUHWY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHWY"
      }
    ]
  },
  {
    "name" : "Hornchurch",
    "id" : "940GZZLUHCH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUHCH"
      }
    ]
  },
  {
    "name" : "Hounslow Central",
    "id" : "940GZZLUHWC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHWC"
      }
    ]
  },
  {
    "name" : "Hounslow East",
    "id" : "940GZZLUHWE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHWE"
      }
    ]
  },
  {
    "name" : "Hounslow West",
    "id" : "940GZZLUHWT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHWT"
      }
    ]
  },
  {
    "name" : "Hyde Park Corner",
    "id" : "940GZZLUHPC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHPC"
      }
    ]
  },
  {
    "name" : "Ickenham",
    "id" : "940GZZLUICK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUICK"
      }
    ]
  },
  {
    "name" : "Ilford",
    "id" : "910GILFORD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GILFORD"
      }
    ]
  },
  {
    "name" : "Island Gardens",
    "id" : "940GZZDLISL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLISL"
      }
    ]
  },
  {
    "name" : "Iver",
    "id" : "910GIVER",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GIVER"
      }
    ]
  },
  {
    "name" : "Kennington",
    "id" : "940GZZLUKNG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUKNG"
      }
    ]
  },
  {
    "name" : "Kensal Green",
    "id" : "HUBKNL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUKSL"
      }
    ]
  },
  {
    "name" : "Kensington (Olympia)",
    "id" : "HUBKPA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUKOY"
      }
    ]
  },
  {
    "name" : "Kentish Town",
    "id" : "HUBKTN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUKSH"
      }
    ]
  },
  {
    "name" : "Kenton",
    "id" : "HUBKNT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUKEN"
      }
    ]
  },
  {
    "name" : "Kew Gardens",
    "id" : "HUBKWG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUKWG"
      }
    ]
  },
  {
    "name" : "Kilburn",
    "id" : "940GZZLUKBN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUKBN"
      }
    ]
  },
  {
    "name" : "Kilburn Park",
    "id" : "940GZZLUKPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUKPK"
      }
    ]
  },
  {
    "name" : "King George V",
    "id" : "940GZZDLKGV",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLKGV"
      }
    ]
  },
  {
    "name" : "King Henry's Drive",
    "id" : "940GZZCRKGH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRKGH"
      }
    ]
  },
  {
    "name" : "King's Cross & St Pancras International",
    "id" : "HUBKGX",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUKSX"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUKSX"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUKSX"
      },
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUKSX"
      }
    ]
  },
  {
    "name" : "Kingsbury",
    "id" : "940GZZLUKBY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUKBY"
      }
    ]
  },
  {
    "name" : "Knightsbridge",
    "id" : "940GZZLUKNB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUKNB"
      }
    ]
  },
  {
    "name" : "Ladbroke Grove",
    "id" : "940GZZLULAD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLULAD"
      }
    ]
  },
  {
    "name" : "Lambeth North",
    "id" : "940GZZLULBN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLULBN"
      }
    ]
  },
  {
    "name" : "Lancaster Gate",
    "id" : "940GZZLULGT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLULGT"
      }
    ]
  },
  {
    "name" : "Langdon Park",
    "id" : "940GZZDLLDP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLLDP"
      }
    ]
  },
  {
    "name" : "Langley (Berks)",
    "id" : "910GLANGLEY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GLANGLEY"
      }
    ]
  },
  {
    "name" : "Latimer Road",
    "id" : "940GZZLULRD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLULRD"
      }
    ]
  },
  {
    "name" : "Lebanon Road",
    "id" : "940GZZCRLEB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRLEB"
      }
    ]
  },
  {
    "name" : "Leicester Square",
    "id" : "940GZZLULSQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLULSQ"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLULSQ"
      }
    ]
  },
  {
    "name" : "Lewisham",
    "id" : "HUBLEW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLLEW"
      }
    ]
  },
  {
    "name" : "Leyton",
    "id" : "940GZZLULYN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLULYN"
      }
    ]
  },
  {
    "name" : "Leytonstone",
    "id" : "940GZZLULYS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLULYS"
      }
    ]
  },
  {
    "name" : "Limehouse",
    "id" : "HUBLHS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLLIM"
      }
    ]
  },
  {
    "name" : "Liverpool Street",
    "id" : "HUBLST",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLULVT"
      },
      {
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLULVT"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GLIVST"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GLIVSTLL"
      }
    ]
  },
  {
    "name" : "Lloyd Park",
    "id" : "940GZZCRLOY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRLOY"
      }
    ]
  },
  {
    "name" : "London Bridge",
    "id" : "HUBLBG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLULNB"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLULNB"
      }
    ]
  },
  {
    "name" : "London City Airport",
    "id" : "HUBLCY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLLCA"
      }
    ]
  },
  {
    "name" : "Loughton",
    "id" : "940GZZLULGN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLULGN"
      }
    ]
  },
  {
    "name" : "Maida Vale",
    "id" : "940GZZLUMVL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUMVL"
      }
    ]
  },
  {
    "name" : "Maidenhead",
    "id" : "910GMDNHEAD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GMDNHEAD"
      }
    ]
  },
  {
    "name" : "Manor House",
    "id" : "940GZZLUMRH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUMRH"
      }
    ]
  },
  {
    "name" : "Manor Park",
    "id" : "910GMANRPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GMANRPK"
      }
    ]
  },
  {
    "name" : "Mansion House",
    "id" : "940GZZLUMSH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUMSH"
      }
    ]
  },
  {
    "name" : "Marble Arch",
    "id" : "940GZZLUMBA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUMBA"
      }
    ]
  },
  {
    "name" : "Maryland",
    "id" : "910GMRYLAND",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GMRYLAND"
      }
    ]
  },
  {
    "name" : "Marylebone",
    "id" : "HUBMYB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUMYB"
      }
    ]
  },
  {
    "name" : "Merton Park",
    "id" : "940GZZCRMTP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRMTP"
      }
    ]
  },
  {
    "name" : "Mile End",
    "id" : "940GZZLUMED",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUMED"
      },
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUMED"
      }
    ]
  },
  {
    "name" : "Mill Hill East",
    "id" : "940GZZLUMHL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUMHL"
      }
    ]
  },
  {
    "name" : "Mitcham",
    "id" : "940GZZCRMCH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRMCH"
      }
    ]
  },
  {
    "name" : "Mitcham Junction",
    "id" : "HUBMJT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRMJT"
      }
    ]
  },
  {
    "name" : "Monument",
    "id" : "940GZZLUMMT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUMMT"
      }
    ]
  },
  {
    "name" : "Moor Park",
    "id" : "940GZZLUMPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUMPK"
      }
    ]
  },
  {
    "name" : "Moorgate",
    "id" : "HUBZMG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUMGT"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUMGT"
      }
    ]
  },
  {
    "name" : "Morden",
    "id" : "940GZZLUMDN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUMDN"
      }
    ]
  },
  {
    "name" : "Morden Road",
    "id" : "940GZZCRMDN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRMDN"
      }
    ]
  },
  {
    "name" : "Mornington Crescent",
    "id" : "940GZZLUMTC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUMTC"
      }
    ]
  },
  {
    "name" : "Mudchute",
    "id" : "940GZZDLMUD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLMUD"
      }
    ]
  },
  {
    "name" : "Neasden",
    "id" : "940GZZLUNDN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUNDN"
      }
    ]
  },
  {
    "name" : "New Addington",
    "id" : "940GZZCRNWA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRNWA"
      }
    ]
  },
  {
    "name" : "Newbury Park",
    "id" : "940GZZLUNBP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUNBP"
      }
    ]
  },
  {
    "name" : "Nine Elms",
    "id" : "940GZZNEUGST",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZNEUGST"
      }
    ]
  },
  {
    "name" : "North Acton",
    "id" : "940GZZLUNAN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUNAN"
      }
    ]
  },
  {
    "name" : "North Ealing",
    "id" : "940GZZLUNEN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUNEN"
      }
    ]
  },
  {
    "name" : "North Greenwich",
    "id" : "HUBNGW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUNGW"
      }
    ]
  },
  {
    "name" : "North Harrow",
    "id" : "940GZZLUNHA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUNHA"
      }
    ]
  },
  {
    "name" : "North Wembley",
    "id" : "HUBNWB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUNWY"
      }
    ]
  },
  {
    "name" : "Northfields",
    "id" : "940GZZLUNFD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUNFD"
      }
    ]
  },
  {
    "name" : "Northolt",
    "id" : "940GZZLUNHT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUNHT"
      }
    ]
  },
  {
    "name" : "Northwick Park",
    "id" : "940GZZLUNKP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUNKP"
      }
    ]
  },
  {
    "name" : "Northwood",
    "id" : "940GZZLUNOW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUNOW"
      }
    ]
  },
  {
    "name" : "Northwood Hills",
    "id" : "940GZZLUNWH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUNWH"
      }
    ]
  },
  {
    "name" : "Notting Hill Gate",
    "id" : "940GZZLUNHG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUNHG"
      },
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUNHG"
      }
    ]
  },
  {
    "name" : "Oakwood",
    "id" : "940GZZLUOAK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUOAK"
      }
    ]
  },
  {
    "name" : "Old Street",
    "id" : "HUBOLD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUODS"
      }
    ]
  },
  {
    "name" : "Osterley",
    "id" : "940GZZLUOSY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUOSY"
      }
    ]
  },
  {
    "name" : "Oval",
    "id" : "940GZZLUOVL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUOVL"
      }
    ]
  },
  {
    "name" : "Oxford Circus",
    "id" : "940GZZLUOXC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUOXC"
      },
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUOXC"
      },
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUOXC"
      }
    ]
  },
  {
    "name" : "Paddington",
    "id" : "HUBPAD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUPAC"
      },
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUPAC"
      },
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUPAH"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GPADTLL"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GPADTON"
      }
    ]
  },
  {
    "name" : "Park Royal",
    "id" : "940GZZLUPKR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUPKR"
      }
    ]
  },
  {
    "name" : "Parsons Green",
    "id" : "940GZZLUPSG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUPSG"
      }
    ]
  },
  {
    "name" : "Perivale",
    "id" : "940GZZLUPVL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUPVL"
      }
    ]
  },
  {
    "name" : "Phipps Bridge",
    "id" : "940GZZCRPHI",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRPHI"
      }
    ]
  },
  {
    "name" : "Piccadilly Circus",
    "id" : "940GZZLUPCC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUPCC"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUPCC"
      }
    ]
  },
  {
    "name" : "Pimlico",
    "id" : "940GZZLUPCO",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUPCO"
      }
    ]
  },
  {
    "name" : "Pinner",
    "id" : "940GZZLUPNR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUPNR"
      }
    ]
  },
  {
    "name" : "Plaistow",
    "id" : "940GZZLUPLW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUPLW"
      }
    ]
  },
  {
    "name" : "Pontoon Dock",
    "id" : "940GZZDLPDK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLPDK"
      }
    ]
  },
  {
    "name" : "Poplar",
    "id" : "940GZZDLPOP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLPOP"
      }
    ]
  },
  {
    "name" : "Preston Road",
    "id" : "940GZZLUPRD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUPRD"
      }
    ]
  },
  {
    "name" : "Prince Regent",
    "id" : "940GZZDLPRE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLPRE"
      }
    ]
  },
  {
    "name" : "Pudding Mill Lane",
    "id" : "940GZZDLPUD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLPUD"
      }
    ]
  },
  {
    "name" : "Putney Bridge",
    "id" : "940GZZLUPYB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUPYB"
      }
    ]
  },
  {
    "name" : "Queen's Park",
    "id" : "HUBQPW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUQPS"
      }
    ]
  },
  {
    "name" : "Queensbury",
    "id" : "940GZZLUQBY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUQBY"
      }
    ]
  },
  {
    "name" : "Queensway",
    "id" : "940GZZLUQWY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUQWY"
      }
    ]
  },
  {
    "name" : "Ravenscourt Park",
    "id" : "940GZZLURVP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLURVP"
      }
    ]
  },
  {
    "name" : "Rayners Lane",
    "id" : "940GZZLURYL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ],
        "atcoCode" : "940GZZLURYL"
      }
    ]
  },
  {
    "name" : "Reading",
    "id" : "910GRDNGSTN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GRDNGSTN"
      }
    ]
  },
  {
    "name" : "Redbridge",
    "id" : "940GZZLURBG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLURBG"
      }
    ]
  },
  {
    "name" : "Reeves Corner",
    "id" : "940GZZCRRVC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRRVC"
      }
    ]
  },
  {
    "name" : "Regent's Park",
    "id" : "940GZZLURGP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLURGP"
      }
    ]
  },
  {
    "name" : "Richmond",
    "id" : "HUBRMD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLURMD"
      }
    ]
  },
  {
    "name" : "Rickmansworth",
    "id" : "HUBRIC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLURKW"
      }
    ]
  },
  {
    "name" : "Roding Valley",
    "id" : "940GZZLURVY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLURVY"
      }
    ]
  },
  {
    "name" : "Romford",
    "id" : "910GROMFORD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GROMFORD"
      }
    ]
  },
  {
    "name" : "Royal Albert",
    "id" : "940GZZDLRAL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLRAL"
      }
    ]
  },
  {
    "name" : "Royal Oak",
    "id" : "940GZZLURYO",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLURYO"
      }
    ]
  },
  {
    "name" : "Royal Victoria",
    "id" : "HUBRVC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLRVC"
      }
    ]
  },
  {
    "name" : "Ruislip",
    "id" : "940GZZLURSP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLURSP"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLURSP"
      }
    ]
  },
  {
    "name" : "Ruislip Gardens",
    "id" : "940GZZLURSG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLURSG"
      }
    ]
  },
  {
    "name" : "Ruislip Manor",
    "id" : "940GZZLURSM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ],
        "atcoCode" : "940GZZLURSM"
      }
    ]
  },
  {
    "name" : "Russell Square",
    "id" : "940GZZLURSQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLURSQ"
      }
    ]
  },
  {
    "name" : "Sandilands",
    "id" : "940GZZCRSAN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRSAN"
      }
    ]
  },
  {
    "name" : "Seven Kings",
    "id" : "910GSVNKNGS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GSVNKNGS"
      }
    ]
  },
  {
    "name" : "Seven Sisters",
    "id" : "HUBSVS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUSVS"
      }
    ]
  },
  {
    "name" : "Shadwell",
    "id" : "HUBSDE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLSHA"
      }
    ]
  },
  {
    "name" : "Shenfield",
    "id" : "910GSHENFLD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GSHENFLD"
      }
    ]
  },
  {
    "name" : "Shepherd's Bush",
    "id" : "HUBSPB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUSBC"
      }
    ]
  },
  {
    "name" : "Shepherd's Bush Market",
    "id" : "940GZZLUSBM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUSBM"
      }
    ]
  },
  {
    "name" : "Sloane Square",
    "id" : "940GZZLUSSQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUSSQ"
      }
    ]
  },
  {
    "name" : "Slough",
    "id" : "910GSLOUGH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GSLOUGH"
      }
    ]
  },
  {
    "name" : "Snaresbrook",
    "id" : "940GZZLUSNB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUSNB"
      }
    ]
  },
  {
    "name" : "South Ealing",
    "id" : "940GZZLUSEA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUSEA"
      }
    ]
  },
  {
    "name" : "South Harrow",
    "id" : "940GZZLUSHH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUSHH"
      }
    ]
  },
  {
    "name" : "South Kensington",
    "id" : "940GZZLUSKS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUSKS"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUSKS"
      }
    ]
  },
  {
    "name" : "South Kenton",
    "id" : "HUBSOK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUSKT"
      }
    ]
  },
  {
    "name" : "South Quay",
    "id" : "940GZZDLSOQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLSOQ"
      }
    ]
  },
  {
    "name" : "South Ruislip",
    "id" : "HUBSRU",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUSRP"
      }
    ]
  },
  {
    "name" : "South Wimbledon",
    "id" : "940GZZLUSWN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUSWN"
      }
    ]
  },
  {
    "name" : "South Woodford",
    "id" : "940GZZLUSWF",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUSWF"
      }
    ]
  },
  {
    "name" : "Southall",
    "id" : "910GSTHALL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GSTHALL"
      }
    ]
  },
  {
    "name" : "Southfields",
    "id" : "940GZZLUSFS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUSFS"
      }
    ]
  },
  {
    "name" : "Southgate",
    "id" : "940GZZLUSGT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUSGT"
      }
    ]
  },
  {
    "name" : "Southwark",
    "id" : "940GZZLUSWK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUSWK"
      }
    ]
  },
  {
    "name" : "St. James's Park",
    "id" : "940GZZLUSJP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUSJP"
      }
    ]
  },
  {
    "name" : "St. John's Wood",
    "id" : "940GZZLUSJW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUSJW"
      }
    ]
  },
  {
    "name" : "St. Paul's",
    "id" : "940GZZLUSPU",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUSPU"
      }
    ]
  },
  {
    "name" : "Stamford Brook",
    "id" : "940GZZLUSFB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUSFB"
      }
    ]
  },
  {
    "name" : "Stanmore",
    "id" : "940GZZLUSTM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUSTM"
      }
    ]
  },
  {
    "name" : "Star Lane",
    "id" : "940GZZDLSTL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLSTL"
      }
    ]
  },
  {
    "name" : "Stepney Green",
    "id" : "940GZZLUSGN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUSGN"
      }
    ]
  },
  {
    "name" : "Stockwell",
    "id" : "940GZZLUSKW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUSKW"
      },
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUSKW"
      }
    ]
  },
  {
    "name" : "Stonebridge Park",
    "id" : "HUBSBP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUSGP"
      }
    ]
  },
  {
    "name" : "Stratford",
    "id" : "HUBSRA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUSTD"
      },
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLSTD"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GSTFD"
      },
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUSTD"
      }
    ]
  },
  {
    "name" : "Stratford High Street",
    "id" : "940GZZDLSHS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLSHS"
      }
    ]
  },
  {
    "name" : "Stratford International",
    "id" : "940GZZDLSIT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLSIT"
      }
    ]
  },
  {
    "name" : "Sudbury Hill",
    "id" : "940GZZLUSUH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUSUH"
      }
    ]
  },
  {
    "name" : "Sudbury Town",
    "id" : "940GZZLUSUT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUSUT"
      }
    ]
  },
  {
    "name" : "Swiss Cottage",
    "id" : "940GZZLUSWC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUSWC"
      }
    ]
  },
  {
    "name" : "Taplow",
    "id" : "910GTAPLOW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GTAPLOW"
      }
    ]
  },
  {
    "name" : "Temple",
    "id" : "940GZZLUTMP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUTMP"
      }
    ]
  },
  {
    "name" : "Therapia Lane",
    "id" : "940GZZCRTPA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRTPA"
      }
    ]
  },
  {
    "name" : "Theydon Bois",
    "id" : "940GZZLUTHB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUTHB"
      }
    ]
  },
  {
    "name" : "Tooting Bec",
    "id" : "940GZZLUTBC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUTBC"
      }
    ]
  },
  {
    "name" : "Tooting Broadway",
    "id" : "940GZZLUTBY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUTBY"
      }
    ]
  },
  {
    "name" : "Tottenham Court Road",
    "id" : "HUBTCR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUTCR"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GTOTCTRD"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUTCR"
      }
    ]
  },
  {
    "name" : "Tottenham Hale",
    "id" : "HUBTOM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUTMH"
      }
    ]
  },
  {
    "name" : "Totteridge & Whetstone",
    "id" : "940GZZLUTAW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUTAW"
      }
    ]
  },
  {
    "name" : "Tower Gateway",
    "id" : "HUBTOG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLTWG"
      }
    ]
  },
  {
    "name" : "Tower Hill",
    "id" : "940GZZLUTWH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUTWH"
      }
    ]
  },
  {
    "name" : "Tufnell Park",
    "id" : "940GZZLUTFP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUTFP"
      }
    ]
  },
  {
    "name" : "Turnham Green",
    "id" : "940GZZLUTNG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUTNG"
      },
      {
        "lineIds" : [
          "district",
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUTNG"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUTNG"
      }
    ]
  },
  {
    "name" : "Turnpike Lane",
    "id" : "940GZZLUTPN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUTPN"
      }
    ]
  },
  {
    "name" : "Twyford",
    "id" : "910GTWYFORD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GTWYFORD"
      }
    ]
  },
  {
    "name" : "Upminster",
    "id" : "HUBUPM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUUPM"
      }
    ]
  },
  {
    "name" : "Upminster Bridge",
    "id" : "940GZZLUUPB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUUPB"
      }
    ]
  },
  {
    "name" : "Upney",
    "id" : "940GZZLUUPY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUUPY"
      }
    ]
  },
  {
    "name" : "Upton Park",
    "id" : "940GZZLUUPK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUUPK"
      }
    ]
  },
  {
    "name" : "Uxbridge",
    "id" : "940GZZLUUXB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUUXB"
      }
    ]
  },
  {
    "name" : "Vauxhall",
    "id" : "HUBVXH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUVXL"
      }
    ]
  },
  {
    "name" : "Victoria",
    "id" : "HUBVIC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle"
        ],
        "atcoCode" : "940GZZLUVIC"
      },
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUVIC"
      },
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUVIC"
      }
    ]
  },
  {
    "name" : "Waddon Marsh",
    "id" : "940GZZCRWAD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRWAD"
      }
    ]
  },
  {
    "name" : "Walthamstow Central",
    "id" : "HUBWHC",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUWWL"
      }
    ]
  },
  {
    "name" : "Wandle Park",
    "id" : "940GZZCRWAN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRWAN"
      }
    ]
  },
  {
    "name" : "Wanstead",
    "id" : "940GZZLUWSD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUWSD"
      }
    ]
  },
  {
    "name" : "Warren Street",
    "id" : "940GZZLUWRR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUWRR"
      },
      {
        "lineIds" : [
          "victoria"
        ],
        "atcoCode" : "940GZZLUWRR"
      }
    ]
  },
  {
    "name" : "Warwick Avenue",
    "id" : "940GZZLUWKA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUWKA"
      }
    ]
  },
  {
    "name" : "Waterloo",
    "id" : "HUBWAT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUWLO"
      },
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUWLO"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUWLO"
      },
      {
        "lineIds" : [
          "waterloo-city"
        ],
        "atcoCode" : "940GZZLUWLO"
      }
    ]
  },
  {
    "name" : "Watford",
    "id" : "940GZZLUWAF",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUWAF"
      }
    ]
  },
  {
    "name" : "Wellesley Road",
    "id" : "940GZZCRWEL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRWEL"
      }
    ]
  },
  {
    "name" : "Wembley Central",
    "id" : "HUBWMB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUWYC"
      }
    ]
  },
  {
    "name" : "Wembley Park",
    "id" : "940GZZLUWYP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUWYP"
      },
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUWYP"
      }
    ]
  },
  {
    "name" : "West Acton",
    "id" : "940GZZLUWTA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUWTA"
      }
    ]
  },
  {
    "name" : "West Brompton",
    "id" : "HUBWBP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUWBN"
      }
    ]
  },
  {
    "name" : "West Croydon",
    "id" : "HUBWCY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRWCR"
      }
    ]
  },
  {
    "name" : "West Drayton",
    "id" : "910GWDRYTON",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GWDRYTON"
      }
    ]
  },
  {
    "name" : "West Ealing",
    "id" : "910GWEALING",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GWEALING"
      }
    ]
  },
  {
    "name" : "West Finchley",
    "id" : "940GZZLUWFN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUWFN"
      }
    ]
  },
  {
    "name" : "West Ham",
    "id" : "HUBWEH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUWHM"
      },
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLWHM"
      },
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUWHM"
      }
    ]
  },
  {
    "name" : "West Hampstead",
    "id" : "HUBWHD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUWHP"
      }
    ]
  },
  {
    "name" : "West Harrow",
    "id" : "940GZZLUWHW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUWHW"
      }
    ]
  },
  {
    "name" : "West India Quay",
    "id" : "940GZZDLWIQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLWIQ"
      }
    ]
  },
  {
    "name" : "West Kensington",
    "id" : "940GZZLUWKN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUWKN"
      }
    ]
  },
  {
    "name" : "West Ruislip",
    "id" : "HUBWRU",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUWRP"
      }
    ]
  },
  {
    "name" : "West Silvertown",
    "id" : "940GZZDLWSV",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLWSV"
      }
    ]
  },
  {
    "name" : "Westbourne Park",
    "id" : "940GZZLUWSP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUWSP"
      }
    ]
  },
  {
    "name" : "Westferry",
    "id" : "940GZZDLWFE",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLWFE"
      }
    ]
  },
  {
    "name" : "Westminster",
    "id" : "HUBWSM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUWSM"
      },
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUWSM"
      }
    ]
  },
  {
    "name" : "White City",
    "id" : "940GZZLUWCY",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUWCY"
      }
    ]
  },
  {
    "name" : "Whitechapel",
    "id" : "HUBZWL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUWPL"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GWCHAPXR"
      }
    ]
  },
  {
    "name" : "Willesden Green",
    "id" : "940GZZLUWIG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUWIG"
      },
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUWIG"
      }
    ]
  },
  {
    "name" : "Willesden Junction",
    "id" : "HUBWIJ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUWJN"
      }
    ]
  },
  {
    "name" : "Wimbledon",
    "id" : "HUBWIM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUWIM"
      },
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRWMB"
      }
    ]
  },
  {
    "name" : "Wimbledon Park",
    "id" : "940GZZLUWIP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUWIP"
      }
    ]
  },
  {
    "name" : "Wood Green",
    "id" : "940GZZLUWOG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUWOG"
      }
    ]
  },
  {
    "name" : "Wood Lane",
    "id" : "940GZZLUWLA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUWLA"
      }
    ]
  },
  {
    "name" : "Woodford",
    "id" : "940GZZLUWOF",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUWOF"
      }
    ]
  },
  {
    "name" : "Woodside",
    "id" : "940GZZCRWOD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "tram"
        ],
        "atcoCode" : "940GZZCRWOD"
      }
    ]
  },
  {
    "name" : "Woodside Park",
    "id" : "940GZZLUWOP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUWOP"
      }
    ]
  },
  {
    "name" : "Woolwich",
    "id" : "910GWOLWXR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GWOLWXR"
      }
    ]
  },
  {
    "name" : "Woolwich Arsenal",
    "id" : "HUBWWA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLWLA"
      }
    ]
  }
]
""".data(using: .utf8)!


#endif
