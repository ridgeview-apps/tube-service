//
// Stations source of truth
//
let allStationsRawJSON = """
[
  {
    "name" : "Abbey Road",
    "id" : "940GZZDLABR",
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUBND"
      },
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GBONDST"
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
      {
        "lineIds" : [
          "elizabeth"
        ],
        "atcoCode" : "910GHTRWTM4"
      },
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
      }
    ]
  },
  {
    "name" : "Lloyd Park",
    "id" : "940GZZCRLOY",
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
        "atcoCode" : "910GPADTON"
      }
    ]
  },
  {
    "name" : "Park Royal",
    "id" : "940GZZLUPKR",
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUWIG"
      }
    ]
  },
  {
    "name" : "Willesden Junction",
    "id" : "HUBWIJ",
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
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
    "lineGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLWLA"
      }
    ]
  }
]
"""
