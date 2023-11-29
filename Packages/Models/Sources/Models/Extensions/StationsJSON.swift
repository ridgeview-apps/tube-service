//
// Stations source of truth
//
let allStationsRawJSON = """
[
  {
    "id" : "940GZZDLABR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLABR",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.531926,
      "lon" : 0.003737
    },
    "name" : "Abbey Road"
  },
  {
    "id" : "HUBABW",
    "lineGroups" : [
      {
        "atcoCode" : "910GABWDXR",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.491225,
      "lon" : 0.12084
    },
    "name" : "Abbey Wood"
  },
  {
    "id" : "910GACTONML",
    "lineGroups" : [
      {
        "atcoCode" : "910GACTONML",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.51718,
      "lon" : -0.266756
    },
    "name" : "Acton Main Line"
  },
  {
    "id" : "940GZZLUACT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUACT",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUACT",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.503057,
      "lon" : -0.280462
    },
    "name" : "Acton Town"
  },
  {
    "id" : "940GZZCRADV",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRADV",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.356599,
      "lon" : -0.032607
    },
    "name" : "Addington Village"
  },
  {
    "id" : "940GZZCRADD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRADD",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.37981,
      "lon" : -0.073242
    },
    "name" : "Addiscombe"
  },
  {
    "id" : "940GZZLUALD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUALD",
        "lineIds" : [
          "circle"
        ]
      },
      {
        "atcoCode" : "940GZZLUALD",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.514246,
      "lon" : -0.075689
    },
    "name" : "Aldgate"
  },
  {
    "id" : "940GZZLUADE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUADE",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.515037,
      "lon" : -0.072384
    },
    "name" : "Aldgate East"
  },
  {
    "id" : "940GZZDLALL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLALL",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.511,
      "lon" : -0.013135
    },
    "name" : "All Saints"
  },
  {
    "id" : "940GZZLUALP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUALP",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.540627,
      "lon" : -0.29961
    },
    "name" : "Alperton"
  },
  {
    "id" : "HUBAMR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUAMS",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.674126,
      "lon" : -0.607714
    },
    "name" : "Amersham"
  },
  {
    "id" : "940GZZCRAMP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRAMP",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.382238,
      "lon" : -0.123654
    },
    "name" : "Ampere Way"
  },
  {
    "id" : "940GZZLUAGL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUAGL",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.532624,
      "lon" : -0.105898
    },
    "name" : "Angel"
  },
  {
    "id" : "940GZZLUACY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUACY",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.565478,
      "lon" : -0.134819
    },
    "name" : "Archway"
  },
  {
    "id" : "940GZZCRARA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRARA",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.391525,
      "lon" : -0.058347
    },
    "name" : "Arena"
  },
  {
    "id" : "940GZZLUASG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUASG",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.616446,
      "lon" : -0.133062
    },
    "name" : "Arnos Grove"
  },
  {
    "id" : "940GZZLUASL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUASL",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.558655,
      "lon" : -0.107457
    },
    "name" : "Arsenal"
  },
  {
    "id" : "940GZZCRAVE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRAVE",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.407037,
      "lon" : -0.049092
    },
    "name" : "Avenue Road"
  },
  {
    "id" : "940GZZLUBST",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBST",
        "lineIds" : [
          "bakerloo"
        ]
      },
      {
        "atcoCode" : "940GZZLUBST",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      },
      {
        "atcoCode" : "940GZZLUBST",
        "lineIds" : [
          "jubilee"
        ]
      },
      {
        "atcoCode" : "940GZZLUBST",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.522883,
      "lon" : -0.15713
    },
    "name" : "Baker Street"
  },
  {
    "id" : "HUBBAL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBLM",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.443288,
      "lon" : -0.152997
    },
    "name" : "Balham"
  },
  {
    "id" : "HUBBAN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBNK",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "940GZZDLBNK",
        "lineIds" : [
          "dlr"
        ]
      },
      {
        "atcoCode" : "940GZZLUBNK",
        "lineIds" : [
          "northern"
        ]
      },
      {
        "atcoCode" : "940GZZLUBNK",
        "lineIds" : [
          "waterloo-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.513585,
      "lon" : -0.08814
    },
    "name" : "Bank"
  },
  {
    "id" : "940GZZLUBBN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBBN",
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.520275,
      "lon" : -0.097993
    },
    "name" : "Barbican"
  },
  {
    "id" : "HUBBKG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBKG",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUBKG",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      },
      {
        "atcoCode" : "940GZZLUBKG",
        "lineIds" : [
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.539321,
      "lon" : 0.081053
    },
    "name" : "Barking"
  },
  {
    "id" : "940GZZLUBKE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBKE",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.585689,
      "lon" : 0.088585
    },
    "name" : "Barkingside"
  },
  {
    "id" : "940GZZLUBSC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBSC",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUBSC",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.490311,
      "lon" : -0.213427
    },
    "name" : "Barons Court"
  },
  {
    "id" : "940GZZBPSUST",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZBPSUST",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.479932,
      "lon" : -0.142142
    },
    "name" : "Battersea Power Station"
  },
  {
    "id" : "940GZZLUBWT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBWT",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.512284,
      "lon" : -0.187938
    },
    "name" : "Bayswater"
  },
  {
    "id" : "HUBBEK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRBEK",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.410952,
      "lon" : -0.02619
    },
    "name" : "Beckenham Junction"
  },
  {
    "id" : "940GZZCRBRD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRBRD",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.409532,
      "lon" : -0.043421
    },
    "name" : "Beckenham Road"
  },
  {
    "id" : "940GZZDLBEC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLBEC",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.514362,
      "lon" : 0.061453
    },
    "name" : "Beckton"
  },
  {
    "id" : "940GZZDLBPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLBPK",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.508793,
      "lon" : 0.054932
    },
    "name" : "Beckton Park"
  },
  {
    "id" : "940GZZLUBEC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBEC",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.540331,
      "lon" : 0.127016
    },
    "name" : "Becontree"
  },
  {
    "id" : "940GZZCRBED",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRBED",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.389242,
      "lon" : -0.142167
    },
    "name" : "Beddington Lane"
  },
  {
    "id" : "940GZZCRBGV",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRBGV",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.40133,
      "lon" : -0.177806
    },
    "name" : "Belgrave Walk"
  },
  {
    "id" : "940GZZLUBZP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBZP",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.550529,
      "lon" : -0.164783
    },
    "name" : "Belsize Park"
  },
  {
    "id" : "940GZZLUBMY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBMY",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.49775,
      "lon" : -0.063993
    },
    "name" : "Bermondsey"
  },
  {
    "id" : "940GZZLUBLG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBLG",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.527222,
      "lon" : -0.055506
    },
    "name" : "Bethnal Green"
  },
  {
    "id" : "HUBBIR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRBIR",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.40405,
      "lon" : -0.056063
    },
    "name" : "Birkbeck"
  },
  {
    "id" : "HUBBFR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBKF",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.511581,
      "lon" : -0.103659
    },
    "name" : "Blackfriars"
  },
  {
    "id" : "940GZZCRBLA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRBLA",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.384757,
      "lon" : -0.070562
    },
    "name" : "Blackhorse Lane"
  },
  {
    "id" : "HUBBHO",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBLR",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.586919,
      "lon" : -0.04115
    },
    "name" : "Blackhorse Road"
  },
  {
    "id" : "940GZZDLBLA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLBLA",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.507991,
      "lon" : -0.006969
    },
    "name" : "Blackwall"
  },
  {
    "id" : "HUBBDS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBND",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "910GBONDST",
        "lineIds" : [
          "elizabeth"
        ]
      },
      {
        "atcoCode" : "940GZZLUBND",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.514304,
      "lon" : -0.149723
    },
    "name" : "Bond Street"
  },
  {
    "id" : "940GZZLUBOR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBOR",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.501199,
      "lon" : -0.09337
    },
    "name" : "Borough"
  },
  {
    "id" : "940GZZLUBOS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBOS",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.495635,
      "lon" : -0.324939
    },
    "name" : "Boston Manor"
  },
  {
    "id" : "940GZZLUBDS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBDS",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.607034,
      "lon" : -0.124235
    },
    "name" : "Bounds Green"
  },
  {
    "id" : "940GZZDLBOW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLBOW",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.527858,
      "lon" : -0.020936
    },
    "name" : "Bow Church"
  },
  {
    "id" : "940GZZLUBWR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBWR",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.52694,
      "lon" : -0.025128
    },
    "name" : "Bow Road"
  },
  {
    "id" : "940GZZLUBTX",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBTX",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.57665,
      "lon" : -0.213622
    },
    "name" : "Brent Cross"
  },
  {
    "id" : "910GBRTWOOD",
    "lineGroups" : [
      {
        "atcoCode" : "910GBRTWOOD",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.613605,
      "lon" : 0.299586
    },
    "name" : "Brentwood"
  },
  {
    "id" : "HUBBRX",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBXN",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.462618,
      "lon" : -0.114888
    },
    "name" : "Brixton"
  },
  {
    "id" : "940GZZLUBBB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBBB",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.524839,
      "lon" : -0.011538
    },
    "name" : "Bromley-by-Bow"
  },
  {
    "id" : "940GZZLUBKH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBKH",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.626605,
      "lon" : 0.046757
    },
    "name" : "Buckhurst Hill"
  },
  {
    "id" : "910GBNHAM",
    "lineGroups" : [
      {
        "atcoCode" : "910GBNHAM",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.523506,
      "lon" : -0.646374
    },
    "name" : "Burnham (Berks)"
  },
  {
    "id" : "940GZZLUBTK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUBTK",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.602774,
      "lon" : -0.264048
    },
    "name" : "Burnt Oak"
  },
  {
    "id" : "940GZZLUCAR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCAR",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.548519,
      "lon" : -0.118493
    },
    "name" : "Caledonian Road"
  },
  {
    "id" : "940GZZLUCTN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCTN",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.539292,
      "lon" : -0.14274
    },
    "name" : "Camden Town"
  },
  {
    "id" : "HUBZCW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCWR",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.497931,
      "lon" : -0.049405
    },
    "name" : "Canada Water"
  },
  {
    "id" : "HUBCAW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLCAN",
        "lineIds" : [
          "dlr"
        ]
      },
      {
        "atcoCode" : "910GCANWHRF",
        "lineIds" : [
          "elizabeth"
        ]
      },
      {
        "atcoCode" : "940GZZLUCYF",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.504838,
      "lon" : -0.020997
    },
    "name" : "Canary Wharf"
  },
  {
    "id" : "HUBCAN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLCGT",
        "lineIds" : [
          "dlr"
        ]
      },
      {
        "atcoCode" : "940GZZLUCGT",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.514127,
      "lon" : 0.008101
    },
    "name" : "Canning Town"
  },
  {
    "id" : "HUBCST",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCST",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.51151,
      "lon" : -0.090432
    },
    "name" : "Cannon Street"
  },
  {
    "id" : "940GZZLUCPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCPK",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.607701,
      "lon" : -0.294693
    },
    "name" : "Canons Park"
  },
  {
    "id" : "940GZZCRCTR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRCTR",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.375769,
      "lon" : -0.103917
    },
    "name" : "Centrale"
  },
  {
    "id" : "910GCHDWLHT",
    "lineGroups" : [
      {
        "atcoCode" : "910GCHDWLHT",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.568039,
      "lon" : 0.128958
    },
    "name" : "Chadwell Heath"
  },
  {
    "id" : "HUBCFO",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCAL",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.667985,
      "lon" : -0.560689
    },
    "name" : "Chalfont & Latimer"
  },
  {
    "id" : "940GZZLUCFM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCFM",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.544118,
      "lon" : -0.153388
    },
    "name" : "Chalk Farm"
  },
  {
    "id" : "940GZZLUCHL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCHL",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.518247,
      "lon" : -0.111583
    },
    "name" : "Chancery Lane"
  },
  {
    "id" : "HUBCHX",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCHX",
        "lineIds" : [
          "bakerloo"
        ]
      },
      {
        "atcoCode" : "940GZZLUCHX",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.50741,
      "lon" : -0.127277
    },
    "name" : "Charing Cross"
  },
  {
    "id" : "940GZZLUCSM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCSM",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.705208,
      "lon" : -0.611247
    },
    "name" : "Chesham"
  },
  {
    "id" : "940GZZLUCWL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCWL",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.617916,
      "lon" : 0.075041
    },
    "name" : "Chigwell"
  },
  {
    "id" : "940GZZLUCWP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCWP",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.494627,
      "lon" : -0.267972
    },
    "name" : "Chiswick Park"
  },
  {
    "id" : "HUBCLW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCYD",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.654358,
      "lon" : -0.518461
    },
    "name" : "Chorleywood"
  },
  {
    "id" : "940GZZCRCHR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRCHR",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.373774,
      "lon" : -0.103985
    },
    "name" : "Church Street"
  },
  {
    "id" : "940GZZLUCPC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCPC",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.461742,
      "lon" : -0.138317
    },
    "name" : "Clapham Common"
  },
  {
    "id" : "940GZZLUCPN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCPN",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.465135,
      "lon" : -0.130016
    },
    "name" : "Clapham North"
  },
  {
    "id" : "940GZZLUCPS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCPS",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.452654,
      "lon" : -0.147582
    },
    "name" : "Clapham South"
  },
  {
    "id" : "940GZZLUCKS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCKS",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.65152,
      "lon" : -0.149171
    },
    "name" : "Cockfosters"
  },
  {
    "id" : "940GZZLUCND",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCND",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.595424,
      "lon" : -0.249919
    },
    "name" : "Colindale"
  },
  {
    "id" : "940GZZLUCSD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCSD",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.41816,
      "lon" : -0.178086
    },
    "name" : "Colliers Wood"
  },
  {
    "id" : "940GZZCRCOO",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRCOO",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.359791,
      "lon" : -0.05956
    },
    "name" : "Coombe Lane"
  },
  {
    "id" : "940GZZLUCGN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCGN",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.513093,
      "lon" : -0.124436
    },
    "name" : "Covent Garden"
  },
  {
    "id" : "940GZZDLCLA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLCLA",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.495728,
      "lon" : -0.014606
    },
    "name" : "Crossharbour"
  },
  {
    "id" : "940GZZLUCXY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUCXY",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.647044,
      "lon" : -0.441718
    },
    "name" : "Croxley"
  },
  {
    "id" : "HUBCUS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLCUS",
        "lineIds" : [
          "dlr"
        ]
      },
      {
        "atcoCode" : "910GCSTMHSXR",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.509716,
      "lon" : 0.026699
    },
    "name" : "Custom House"
  },
  {
    "id" : "HUBCUT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLCUT",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.481671,
      "lon" : -0.01081
    },
    "name" : "Cutty Sark"
  },
  {
    "id" : "940GZZDLCYP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLCYP",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.508473,
      "lon" : 0.063925
    },
    "name" : "Cyprus"
  },
  {
    "id" : "940GZZLUDGE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUDGE",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.544096,
      "lon" : 0.166017
    },
    "name" : "Dagenham East"
  },
  {
    "id" : "940GZZLUDGY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUDGY",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.541639,
      "lon" : 0.147527
    },
    "name" : "Dagenham Heathway"
  },
  {
    "id" : "940GZZLUDBN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUDBN",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.645386,
      "lon" : 0.083782
    },
    "name" : "Debden"
  },
  {
    "id" : "940GZZDLDEP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLDEP",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.474215,
      "lon" : -0.022438
    },
    "name" : "Deptford Bridge"
  },
  {
    "id" : "940GZZDLDEV",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLDEV",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.522667,
      "lon" : -0.017615
    },
    "name" : "Devons Road"
  },
  {
    "id" : "940GZZLUDOH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUDOH",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.551955,
      "lon" : -0.239068
    },
    "name" : "Dollis Hill"
  },
  {
    "id" : "940GZZCRDDR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRDDR",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.417555,
      "lon" : -0.207679
    },
    "name" : "Dundonald Road"
  },
  {
    "id" : "HUBEAL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEBY",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "940GZZLUEBY",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "910GEALINGB",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.515017,
      "lon" : -0.301457
    },
    "name" : "Ealing Broadway"
  },
  {
    "id" : "940GZZLUECM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUECM",
        "lineIds" : [
          "district",
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.51014,
      "lon" : -0.288265
    },
    "name" : "Ealing Common"
  },
  {
    "id" : "940GZZLUECT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUECT",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUECT",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.492063,
      "lon" : -0.193378
    },
    "name" : "Earl's Court"
  },
  {
    "id" : "940GZZLUEAN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEAN",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.516612,
      "lon" : -0.247248
    },
    "name" : "East Acton"
  },
  {
    "id" : "HUBECY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRECR",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.374854,
      "lon" : -0.092417
    },
    "name" : "East Croydon"
  },
  {
    "id" : "940GZZLUEFY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEFY",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.587131,
      "lon" : -0.165012
    },
    "name" : "East Finchley"
  },
  {
    "id" : "940GZZLUEHM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEHM",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.538948,
      "lon" : 0.051186
    },
    "name" : "East Ham"
  },
  {
    "id" : "940GZZDLEIN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLEIN",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.509359,
      "lon" : -0.002326
    },
    "name" : "East India"
  },
  {
    "id" : "940GZZLUEPY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEPY",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.459205,
      "lon" : -0.211
    },
    "name" : "East Putney"
  },
  {
    "id" : "940GZZLUEAE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEAE",
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.576506,
      "lon" : -0.397373
    },
    "name" : "Eastcote"
  },
  {
    "id" : "940GZZLUEGW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEGW",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.613653,
      "lon" : -0.274928
    },
    "name" : "Edgware"
  },
  {
    "id" : "940GZZLUERB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUERB",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.520299,
      "lon" : -0.17015
    },
    "name" : "Edgware Road (Bakerloo)"
  },
  {
    "id" : "940GZZLUERC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUERC",
        "lineIds" : [
          "circle"
        ]
      },
      {
        "atcoCode" : "940GZZLUERC",
        "lineIds" : [
          "circle",
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUERC",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.519858,
      "lon" : -0.167832
    },
    "name" : "Edgware Road (Circle Line)"
  },
  {
    "id" : "HUBEPH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEAC",
        "lineIds" : [
          "bakerloo"
        ]
      },
      {
        "atcoCode" : "940GZZLUEAC",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.494536,
      "lon" : -0.100606
    },
    "name" : "Elephant & Castle"
  },
  {
    "id" : "940GZZLUEPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEPK",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.549775,
      "lon" : 0.19864
    },
    "name" : "Elm Park"
  },
  {
    "id" : "HUBELM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRELM",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.39851,
      "lon" : -0.049555
    },
    "name" : "Elmers End"
  },
  {
    "id" : "940GZZDLELV",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLELV",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.469074,
      "lon" : -0.016728
    },
    "name" : "Elverson Road"
  },
  {
    "id" : "940GZZLUEMB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEMB",
        "lineIds" : [
          "bakerloo"
        ]
      },
      {
        "atcoCode" : "940GZZLUEMB",
        "lineIds" : [
          "circle",
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUEMB",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.507058,
      "lon" : -0.122666
    },
    "name" : "Embankment"
  },
  {
    "id" : "940GZZLUEPG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEPG",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.69368,
      "lon" : 0.113767
    },
    "name" : "Epping"
  },
  {
    "id" : "HUBEUS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUEUS",
        "lineIds" : [
          "northern"
        ]
      },
      {
        "atcoCode" : "940GZZLUEUS",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.527999,
      "lon" : -0.133785
    },
    "name" : "Euston"
  },
  {
    "id" : "940GZZLUESQ",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUESQ",
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.525604,
      "lon" : -0.135829
    },
    "name" : "Euston Square"
  },
  {
    "id" : "940GZZLUFLP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUFLP",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.595618,
      "lon" : 0.091004
    },
    "name" : "Fairlop"
  },
  {
    "id" : "HUBZFD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUFCN",
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ]
      },
      {
        "atcoCode" : "910GFRNDXR",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.520252,
      "lon" : -0.104913
    },
    "name" : "Farringdon"
  },
  {
    "id" : "940GZZCRFLD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRFLD",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.351305,
      "lon" : -0.024245
    },
    "name" : "Fieldway"
  },
  {
    "id" : "940GZZLUFYC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUFYC",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.600921,
      "lon" : -0.192527
    },
    "name" : "Finchley Central"
  },
  {
    "id" : "940GZZLUFYR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUFYR",
        "lineIds" : [
          "jubilee"
        ]
      },
      {
        "atcoCode" : "940GZZLUFYR",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.546825,
      "lon" : -0.179845
    },
    "name" : "Finchley Road"
  },
  {
    "id" : "HUBFPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUFPK",
        "lineIds" : [
          "piccadilly"
        ]
      },
      {
        "atcoCode" : "940GZZLUFPK",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.564158,
      "lon" : -0.106825
    },
    "name" : "Finsbury Park"
  },
  {
    "id" : "910GFRSTGT",
    "lineGroups" : [
      {
        "atcoCode" : "910GFRSTGT",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.549432,
      "lon" : 0.024353
    },
    "name" : "Forest Gate"
  },
  {
    "id" : "940GZZLUFBY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUFBY",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.480081,
      "lon" : -0.195422
    },
    "name" : "Fulham Broadway"
  },
  {
    "id" : "940GZZDLGAL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLGAL",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.508941,
      "lon" : 0.071555
    },
    "name" : "Gallions Reach"
  },
  {
    "id" : "940GZZLUGTH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGTH",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.576544,
      "lon" : 0.066185
    },
    "name" : "Gants Hill"
  },
  {
    "id" : "940GZZCRCEN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRCEN",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.373977,
      "lon" : -0.098746
    },
    "name" : "George Street"
  },
  {
    "id" : "910GGIDEAPK",
    "lineGroups" : [
      {
        "atcoCode" : "910GGIDEAPK",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.581904,
      "lon" : 0.205964
    },
    "name" : "Gidea Park"
  },
  {
    "id" : "940GZZLUGTR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGTR",
        "lineIds" : [
          "circle"
        ]
      },
      {
        "atcoCode" : "940GZZLUGTR",
        "lineIds" : [
          "circle",
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUGTR",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUGTR",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.494316,
      "lon" : -0.182658
    },
    "name" : "Gloucester Road"
  },
  {
    "id" : "940GZZLUGGN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGGN",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.572259,
      "lon" : -0.194039
    },
    "name" : "Golders Green"
  },
  {
    "id" : "940GZZLUGHK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGHK",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.502005,
      "lon" : -0.226715
    },
    "name" : "Goldhawk Road"
  },
  {
    "id" : "940GZZLUGDG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGDG",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.520599,
      "lon" : -0.134361
    },
    "name" : "Goodge Street"
  },
  {
    "id" : "910GGODMAYS",
    "lineGroups" : [
      {
        "atcoCode" : "910GGODMAYS",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.565579,
      "lon" : 0.110807
    },
    "name" : "Goodmayes"
  },
  {
    "id" : "940GZZLUGGH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGGH",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.613378,
      "lon" : 0.092066
    },
    "name" : "Grange Hill"
  },
  {
    "id" : "940GZZCRGRA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRGRA",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.354676,
      "lon" : -0.042355
    },
    "name" : "Gravel Hill"
  },
  {
    "id" : "940GZZLUGPS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGPS",
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.52384,
      "lon" : -0.144262
    },
    "name" : "Great Portland Street"
  },
  {
    "id" : "940GZZLUGPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGPK",
        "lineIds" : [
          "jubilee"
        ]
      },
      {
        "atcoCode" : "940GZZLUGPK",
        "lineIds" : [
          "piccadilly"
        ]
      },
      {
        "atcoCode" : "940GZZLUGPK",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.506947,
      "lon" : -0.142787
    },
    "name" : "Green Park"
  },
  {
    "id" : "HUBGFD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGFD",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.542424,
      "lon" : -0.34605
    },
    "name" : "Greenford"
  },
  {
    "id" : "HUBGNW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLGRE",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.478087,
      "lon" : -0.013673
    },
    "name" : "Greenwich"
  },
  {
    "id" : "HUBGUN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUGBY",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.491803,
      "lon" : -0.275267
    },
    "name" : "Gunnersbury"
  },
  {
    "id" : "940GZZLUHLT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHLT",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.603659,
      "lon" : 0.093482
    },
    "name" : "Hainault"
  },
  {
    "id" : "HUBHMS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHSC",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      },
      {
        "atcoCode" : "940GZZLUHSD",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUHSD",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.493535,
      "lon" : -0.225013
    },
    "name" : "Hammersmith"
  },
  {
    "id" : "940GZZLUHTD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHTD",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.556239,
      "lon" : -0.177464
    },
    "name" : "Hampstead"
  },
  {
    "id" : "940GZZLUHGR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHGR",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.530177,
      "lon" : -0.292704
    },
    "name" : "Hanger Lane"
  },
  {
    "id" : "910GHANWELL",
    "lineGroups" : [
      {
        "atcoCode" : "910GHANWELL",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.511835,
      "lon" : -0.338583
    },
    "name" : "Hanwell"
  },
  {
    "id" : "HUBHDN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHSN",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.53631,
      "lon" : -0.257883
    },
    "name" : "Harlesden"
  },
  {
    "id" : "910GHRLDWOD",
    "lineGroups" : [
      {
        "atcoCode" : "910GHRLDWOD",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.592766,
      "lon" : 0.233129
    },
    "name" : "Harold Wood"
  },
  {
    "id" : "940GZZCRHAR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRHAR",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.399609,
      "lon" : -0.060478
    },
    "name" : "Harrington Road"
  },
  {
    "id" : "HUBHRW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHAW",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.592268,
      "lon" : -0.335217
    },
    "name" : "Harrow & Wealdstone"
  },
  {
    "id" : "HUBHOH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHOH",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.579195,
      "lon" : -0.337225
    },
    "name" : "Harrow-on-the-Hill"
  },
  {
    "id" : "940GZZLUHNX",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHNX",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.466747,
      "lon" : -0.423191
    },
    "name" : "Hatton Cross"
  },
  {
    "id" : "910GHAYESAH",
    "lineGroups" : [
      {
        "atcoCode" : "910GHAYESAH",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.503096,
      "lon" : -0.420683
    },
    "name" : "Hayes & Harlington"
  },
  {
    "id" : "HUBHX4",
    "lineGroups" : [
      {
        "atcoCode" : "910GHTRWTM4",
        "lineIds" : [
          "elizabeth"
        ]
      },
      {
        "atcoCode" : "940GZZLUHR4",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.458268,
      "lon" : -0.445463
    },
    "name" : "Heathrow Airport Terminal 4"
  },
  {
    "id" : "HUBHX5",
    "lineGroups" : [
      {
        "atcoCode" : "910GHTRWTM5",
        "lineIds" : [
          "elizabeth"
        ]
      },
      {
        "atcoCode" : "940GZZLUHR5",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.470053,
      "lon" : -0.490589
    },
    "name" : "Heathrow Airport Terminal 5"
  },
  {
    "id" : "HUBH13",
    "lineGroups" : [
      {
        "atcoCode" : "910GHTRWAPT",
        "lineIds" : [
          "elizabeth"
        ]
      },
      {
        "atcoCode" : "940GZZLUHRC",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.470976,
      "lon" : -0.458033
    },
    "name" : "Heathrow Terminals 2 & 3"
  },
  {
    "id" : "940GZZLUHCL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHCL",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.583301,
      "lon" : -0.226424
    },
    "name" : "Hendon Central"
  },
  {
    "id" : "940GZZDLHEQ",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLHEQ",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.503379,
      "lon" : -0.021421
    },
    "name" : "Heron Quays"
  },
  {
    "id" : "940GZZLUHBT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHBT",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.650541,
      "lon" : -0.194298
    },
    "name" : "High Barnet"
  },
  {
    "id" : "940GZZLUHSK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHSK",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.501055,
      "lon" : -0.192792
    },
    "name" : "High Street Kensington"
  },
  {
    "id" : "HUBHHY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHAI",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.54635,
      "lon" : -0.103324
    },
    "name" : "Highbury & Islington"
  },
  {
    "id" : "940GZZLUHGT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHGT",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.577532,
      "lon" : -0.145857
    },
    "name" : "Highgate"
  },
  {
    "id" : "940GZZLUHGD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHGD",
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.553715,
      "lon" : -0.449828
    },
    "name" : "Hillingdon"
  },
  {
    "id" : "940GZZLUHBN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHBN",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "940GZZLUHBN",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.51758,
      "lon" : -0.120475
    },
    "name" : "Holborn"
  },
  {
    "id" : "940GZZLUHPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHPK",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.507143,
      "lon" : -0.205679
    },
    "name" : "Holland Park"
  },
  {
    "id" : "940GZZLUHWY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHWY",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.552697,
      "lon" : -0.113244
    },
    "name" : "Holloway Road"
  },
  {
    "id" : "940GZZLUHCH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHCH",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.554093,
      "lon" : 0.219116
    },
    "name" : "Hornchurch"
  },
  {
    "id" : "940GZZLUHWC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHWC",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.471295,
      "lon" : -0.366578
    },
    "name" : "Hounslow Central"
  },
  {
    "id" : "940GZZLUHWE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHWE",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.473213,
      "lon" : -0.356474
    },
    "name" : "Hounslow East"
  },
  {
    "id" : "940GZZLUHWT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHWT",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.473469,
      "lon" : -0.386544
    },
    "name" : "Hounslow West"
  },
  {
    "id" : "940GZZLUHPC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUHPC",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.503035,
      "lon" : -0.152441
    },
    "name" : "Hyde Park Corner"
  },
  {
    "id" : "940GZZLUICK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUICK",
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.562025,
      "lon" : -0.441899
    },
    "name" : "Ickenham"
  },
  {
    "id" : "910GILFORD",
    "lineGroups" : [
      {
        "atcoCode" : "910GILFORD",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.559118,
      "lon" : 0.06968
    },
    "name" : "Ilford"
  },
  {
    "id" : "940GZZDLISL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLISL",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.487811,
      "lon" : -0.010139
    },
    "name" : "Island Gardens"
  },
  {
    "id" : "910GIVER",
    "lineGroups" : [
      {
        "atcoCode" : "910GIVER",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.508503,
      "lon" : -0.506726
    },
    "name" : "Iver"
  },
  {
    "id" : "940GZZLUKNG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKNG",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.488337,
      "lon" : -0.105963
    },
    "name" : "Kennington"
  },
  {
    "id" : "HUBKNL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKSL",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.530539,
      "lon" : -0.225016
    },
    "name" : "Kensal Green"
  },
  {
    "id" : "HUBKPA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKOY",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.497624,
      "lon" : -0.210015
    },
    "name" : "Kensington (Olympia)"
  },
  {
    "id" : "HUBKTN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKSH",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.550312,
      "lon" : -0.140733
    },
    "name" : "Kentish Town"
  },
  {
    "id" : "HUBKNT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKEN",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.581756,
      "lon" : -0.31691
    },
    "name" : "Kenton"
  },
  {
    "id" : "HUBKWG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKWG",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.477058,
      "lon" : -0.285241
    },
    "name" : "Kew Gardens"
  },
  {
    "id" : "940GZZLUKBN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKBN",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.547183,
      "lon" : -0.204248
    },
    "name" : "Kilburn"
  },
  {
    "id" : "940GZZLUKPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKPK",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.534979,
      "lon" : -0.194232
    },
    "name" : "Kilburn Park"
  },
  {
    "id" : "940GZZDLKGV",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLKGV",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.502003,
      "lon" : 0.062624
    },
    "name" : "King George V"
  },
  {
    "id" : "940GZZCRKGH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRKGH",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.346138,
      "lon" : -0.020849
    },
    "name" : "King Henry's Drive"
  },
  {
    "id" : "HUBKGX",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKSX",
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ]
      },
      {
        "atcoCode" : "940GZZLUKSX",
        "lineIds" : [
          "northern"
        ]
      },
      {
        "atcoCode" : "940GZZLUKSX",
        "lineIds" : [
          "piccadilly"
        ]
      },
      {
        "atcoCode" : "940GZZLUKSX",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.530663,
      "lon" : -0.123194
    },
    "name" : "King's Cross & St Pancras International"
  },
  {
    "id" : "940GZZLUKBY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKBY",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.584845,
      "lon" : -0.27879
    },
    "name" : "Kingsbury"
  },
  {
    "id" : "940GZZLUKNB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUKNB",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.501669,
      "lon" : -0.160508
    },
    "name" : "Knightsbridge"
  },
  {
    "id" : "940GZZLULAD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULAD",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.517449,
      "lon" : -0.210391
    },
    "name" : "Ladbroke Grove"
  },
  {
    "id" : "940GZZLULBN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULBN",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.498808,
      "lon" : -0.112315
    },
    "name" : "Lambeth North"
  },
  {
    "id" : "940GZZLULGT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULGT",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.511723,
      "lon" : -0.175494
    },
    "name" : "Lancaster Gate"
  },
  {
    "id" : "940GZZDLLDP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLLDP",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.515172,
      "lon" : -0.01415
    },
    "name" : "Langdon Park"
  },
  {
    "id" : "910GLANGLEY",
    "lineGroups" : [
      {
        "atcoCode" : "910GLANGLEY",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.508062,
      "lon" : -0.541756
    },
    "name" : "Langley (Berks)"
  },
  {
    "id" : "940GZZLULRD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULRD",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.513389,
      "lon" : -0.217799
    },
    "name" : "Latimer Road"
  },
  {
    "id" : "940GZZCRLEB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRLEB",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.375075,
      "lon" : -0.084418
    },
    "name" : "Lebanon Road"
  },
  {
    "id" : "940GZZLULSQ",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULSQ",
        "lineIds" : [
          "northern"
        ]
      },
      {
        "atcoCode" : "940GZZLULSQ",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.511386,
      "lon" : -0.128426
    },
    "name" : "Leicester Square"
  },
  {
    "id" : "HUBLEW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLLEW",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.464665,
      "lon" : -0.012874
    },
    "name" : "Lewisham"
  },
  {
    "id" : "940GZZLULYN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULYN",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.556589,
      "lon" : -0.005523
    },
    "name" : "Leyton"
  },
  {
    "id" : "940GZZLULYS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULYS",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.568324,
      "lon" : 0.008194
    },
    "name" : "Leytonstone"
  },
  {
    "id" : "HUBLHS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLLIM",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.512393,
      "lon" : -0.039809
    },
    "name" : "Limehouse"
  },
  {
    "id" : "HUBLST",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULVT",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "940GZZLULVT",
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ]
      },
      {
        "atcoCode" : "910GLIVST",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.517372,
      "lon" : -0.083182
    },
    "name" : "Liverpool Street"
  },
  {
    "id" : "940GZZCRLOY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRLOY",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.364278,
      "lon" : -0.080775
    },
    "name" : "Lloyd Park"
  },
  {
    "id" : "HUBLBG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULNB",
        "lineIds" : [
          "jubilee"
        ]
      },
      {
        "atcoCode" : "940GZZLULNB",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.505721,
      "lon" : -0.088873
    },
    "name" : "London Bridge"
  },
  {
    "id" : "HUBLCY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLLCA",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.503416,
      "lon" : 0.048739
    },
    "name" : "London City Airport"
  },
  {
    "id" : "940GZZLULGN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLULGN",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.641443,
      "lon" : 0.055476
    },
    "name" : "Loughton"
  },
  {
    "id" : "940GZZLUMVL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMVL",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.529777,
      "lon" : -0.185758
    },
    "name" : "Maida Vale"
  },
  {
    "id" : "910GMDNHEAD",
    "lineGroups" : [
      {
        "atcoCode" : "910GMDNHEAD",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.518669,
      "lon" : -0.72266
    },
    "name" : "Maidenhead"
  },
  {
    "id" : "940GZZLUMRH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMRH",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.570738,
      "lon" : -0.096118
    },
    "name" : "Manor House"
  },
  {
    "id" : "910GMANRPK",
    "lineGroups" : [
      {
        "atcoCode" : "910GMANRPK",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.552477,
      "lon" : 0.046342
    },
    "name" : "Manor Park"
  },
  {
    "id" : "940GZZLUMSH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMSH",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.512117,
      "lon" : -0.094009
    },
    "name" : "Mansion House"
  },
  {
    "id" : "940GZZLUMBA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMBA",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.513424,
      "lon" : -0.158953
    },
    "name" : "Marble Arch"
  },
  {
    "id" : "910GMRYLAND",
    "lineGroups" : [
      {
        "atcoCode" : "910GMRYLAND",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.546081,
      "lon" : 0.005815
    },
    "name" : "Maryland"
  },
  {
    "id" : "HUBMYB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMYB",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.522322,
      "lon" : -0.163207
    },
    "name" : "Marylebone"
  },
  {
    "id" : "940GZZCRMTP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRMTP",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.413589,
      "lon" : -0.201219
    },
    "name" : "Merton Park"
  },
  {
    "id" : "940GZZLUMED",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMED",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "940GZZLUMED",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.525122,
      "lon" : -0.03364
    },
    "name" : "Mile End"
  },
  {
    "id" : "940GZZLUMHL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMHL",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.608229,
      "lon" : -0.209986
    },
    "name" : "Mill Hill East"
  },
  {
    "id" : "940GZZCRMCH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRMCH",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.39749,
      "lon" : -0.1709
    },
    "name" : "Mitcham"
  },
  {
    "id" : "HUBMJT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRMJT",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.392859,
      "lon" : -0.158795
    },
    "name" : "Mitcham Junction"
  },
  {
    "id" : "940GZZLUMMT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMMT",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.5107,
      "lon" : -0.085969
    },
    "name" : "Monument"
  },
  {
    "id" : "940GZZLUMPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMPK",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.629845,
      "lon" : -0.432454
    },
    "name" : "Moor Park"
  },
  {
    "id" : "HUBZMG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMGT",
        "lineIds" : [
          "circle",
          "hammersmith-city",
          "metropolitan"
        ]
      },
      {
        "atcoCode" : "940GZZLUMGT",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.518176,
      "lon" : -0.088322
    },
    "name" : "Moorgate"
  },
  {
    "id" : "940GZZLUMDN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMDN",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.402142,
      "lon" : -0.194839
    },
    "name" : "Morden"
  },
  {
    "id" : "940GZZCRMDN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRMDN",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.40905,
      "lon" : -0.192597
    },
    "name" : "Morden Road"
  },
  {
    "id" : "940GZZLUMTC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUMTC",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.534679,
      "lon" : -0.138789
    },
    "name" : "Mornington Crescent"
  },
  {
    "id" : "940GZZDLMUD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLMUD",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.490704,
      "lon" : -0.014738
    },
    "name" : "Mudchute"
  },
  {
    "id" : "940GZZLUNDN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNDN",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.553986,
      "lon" : -0.249837
    },
    "name" : "Neasden"
  },
  {
    "id" : "940GZZCRNWA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRNWA",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.342593,
      "lon" : -0.017412
    },
    "name" : "New Addington"
  },
  {
    "id" : "940GZZLUNBP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNBP",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.575726,
      "lon" : 0.090004
    },
    "name" : "Newbury Park"
  },
  {
    "id" : "940GZZNEUGST",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZNEUGST",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.479912,
      "lon" : -0.128476
    },
    "name" : "Nine Elms"
  },
  {
    "id" : "940GZZLUNAN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNAN",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.523524,
      "lon" : -0.259755
    },
    "name" : "North Acton"
  },
  {
    "id" : "940GZZLUNEN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNEN",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.517505,
      "lon" : -0.288868
    },
    "name" : "North Ealing"
  },
  {
    "id" : "HUBNGW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNGW",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.50047,
      "lon" : 0.004287
    },
    "name" : "North Greenwich"
  },
  {
    "id" : "940GZZLUNHA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNHA",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.584872,
      "lon" : -0.362408
    },
    "name" : "North Harrow"
  },
  {
    "id" : "HUBNWB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNWY",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.562551,
      "lon" : -0.304
    },
    "name" : "North Wembley"
  },
  {
    "id" : "940GZZLUNFD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNFD",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.499319,
      "lon" : -0.314719
    },
    "name" : "Northfields"
  },
  {
    "id" : "940GZZLUNHT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNHT",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.548236,
      "lon" : -0.368699
    },
    "name" : "Northolt"
  },
  {
    "id" : "940GZZLUNKP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNKP",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.578481,
      "lon" : -0.318056
    },
    "name" : "Northwick Park"
  },
  {
    "id" : "940GZZLUNOW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNOW",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.611053,
      "lon" : -0.423829
    },
    "name" : "Northwood"
  },
  {
    "id" : "940GZZLUNWH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNWH",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.600572,
      "lon" : -0.409464
    },
    "name" : "Northwood Hills"
  },
  {
    "id" : "940GZZLUNHG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUNHG",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "940GZZLUNHG",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.509128,
      "lon" : -0.196104
    },
    "name" : "Notting Hill Gate"
  },
  {
    "id" : "940GZZLUOAK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUOAK",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.647726,
      "lon" : -0.132182
    },
    "name" : "Oakwood"
  },
  {
    "id" : "HUBOLD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUODS",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.525864,
      "lon" : -0.08777
    },
    "name" : "Old Street"
  },
  {
    "id" : "940GZZLUOSY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUOSY",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.481274,
      "lon" : -0.352224
    },
    "name" : "Osterley"
  },
  {
    "id" : "940GZZLUOVL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUOVL",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.48185,
      "lon" : -0.112439
    },
    "name" : "Oval"
  },
  {
    "id" : "940GZZLUOXC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUOXC",
        "lineIds" : [
          "bakerloo"
        ]
      },
      {
        "atcoCode" : "940GZZLUOXC",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "940GZZLUOXC",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.515224,
      "lon" : -0.141903
    },
    "name" : "Oxford Circus"
  },
  {
    "id" : "HUBPAD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPAC",
        "lineIds" : [
          "bakerloo"
        ]
      },
      {
        "atcoCode" : "940GZZLUPAC",
        "lineIds" : [
          "circle",
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUPAH",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      },
      {
        "atcoCode" : "910GPADTON",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.516581,
      "lon" : -0.175689
    },
    "name" : "Paddington"
  },
  {
    "id" : "940GZZLUPKR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPKR",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.527123,
      "lon" : -0.284341
    },
    "name" : "Park Royal"
  },
  {
    "id" : "940GZZLUPSG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPSG",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.475277,
      "lon" : -0.20117
    },
    "name" : "Parsons Green"
  },
  {
    "id" : "940GZZLUPVL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPVL",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.536717,
      "lon" : -0.323446
    },
    "name" : "Perivale"
  },
  {
    "id" : "940GZZCRPHI",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRPHI",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.40423,
      "lon" : -0.182249
    },
    "name" : "Phipps Bridge"
  },
  {
    "id" : "940GZZLUPCC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPCC",
        "lineIds" : [
          "bakerloo"
        ]
      },
      {
        "atcoCode" : "940GZZLUPCC",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.51005,
      "lon" : -0.133798
    },
    "name" : "Piccadilly Circus"
  },
  {
    "id" : "940GZZLUPCO",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPCO",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.489097,
      "lon" : -0.133761
    },
    "name" : "Pimlico"
  },
  {
    "id" : "940GZZLUPNR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPNR",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.592901,
      "lon" : -0.381161
    },
    "name" : "Pinner"
  },
  {
    "id" : "940GZZLUPLW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPLW",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.531341,
      "lon" : 0.017451
    },
    "name" : "Plaistow"
  },
  {
    "id" : "940GZZDLPDK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLPDK",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.502212,
      "lon" : 0.032115
    },
    "name" : "Pontoon Dock"
  },
  {
    "id" : "940GZZDLPOP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLPOP",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.507744,
      "lon" : -0.017384
    },
    "name" : "Poplar"
  },
  {
    "id" : "940GZZLUPRD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPRD",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.571972,
      "lon" : -0.295107
    },
    "name" : "Preston Road"
  },
  {
    "id" : "940GZZDLPRE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLPRE",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.509263,
      "lon" : 0.034158
    },
    "name" : "Prince Regent"
  },
  {
    "id" : "940GZZDLPUD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLPUD",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.534302,
      "lon" : -0.012755
    },
    "name" : "Pudding Mill Lane"
  },
  {
    "id" : "940GZZLUPYB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUPYB",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.468262,
      "lon" : -0.208731
    },
    "name" : "Putney Bridge"
  },
  {
    "id" : "HUBQPW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUQPS",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.534158,
      "lon" : -0.204574
    },
    "name" : "Queen's Park"
  },
  {
    "id" : "940GZZLUQBY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUQBY",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.594188,
      "lon" : -0.286219
    },
    "name" : "Queensbury"
  },
  {
    "id" : "940GZZLUQWY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUQWY",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.510312,
      "lon" : -0.187152
    },
    "name" : "Queensway"
  },
  {
    "id" : "940GZZLURVP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURVP",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.494122,
      "lon" : -0.235881
    },
    "name" : "Ravenscourt Park"
  },
  {
    "id" : "940GZZLURYL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURYL",
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.575147,
      "lon" : -0.371127
    },
    "name" : "Rayners Lane"
  },
  {
    "id" : "910GRDNGSTN",
    "lineGroups" : [
      {
        "atcoCode" : "910GRDNGSTN",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.458786,
      "lon" : -0.971863
    },
    "name" : "Reading"
  },
  {
    "id" : "940GZZLURBG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURBG",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.576243,
      "lon" : 0.04536
    },
    "name" : "Redbridge"
  },
  {
    "id" : "940GZZCRRVC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRRVC",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.37527,
      "lon" : -0.10638
    },
    "name" : "Reeves Corner"
  },
  {
    "id" : "940GZZLURGP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURGP",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.523344,
      "lon" : -0.146444
    },
    "name" : "Regent's Park"
  },
  {
    "id" : "HUBRMD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURMD",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.463237,
      "lon" : -0.301336
    },
    "name" : "Richmond"
  },
  {
    "id" : "HUBRIC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURKW",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.640207,
      "lon" : -0.473703
    },
    "name" : "Rickmansworth"
  },
  {
    "id" : "940GZZLURVY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURVY",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.617199,
      "lon" : 0.043647
    },
    "name" : "Roding Valley"
  },
  {
    "id" : "910GROMFORD",
    "lineGroups" : [
      {
        "atcoCode" : "910GROMFORD",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.574829,
      "lon" : 0.183237
    },
    "name" : "Romford"
  },
  {
    "id" : "940GZZDLRAL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLRAL",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.508357,
      "lon" : 0.045935
    },
    "name" : "Royal Albert"
  },
  {
    "id" : "940GZZLURYO",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURYO",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.519113,
      "lon" : -0.188748
    },
    "name" : "Royal Oak"
  },
  {
    "id" : "HUBRVC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLRVC",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.509336,
      "lon" : 0.018497
    },
    "name" : "Royal Victoria"
  },
  {
    "id" : "940GZZLURSP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURSP",
        "lineIds" : [
          "metropolitan"
        ]
      },
      {
        "atcoCode" : "940GZZLURSP",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.571354,
      "lon" : -0.421898
    },
    "name" : "Ruislip"
  },
  {
    "id" : "940GZZLURSG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURSG",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.560736,
      "lon" : -0.41071
    },
    "name" : "Ruislip Gardens"
  },
  {
    "id" : "940GZZLURSM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURSM",
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.573202,
      "lon" : -0.412973
    },
    "name" : "Ruislip Manor"
  },
  {
    "id" : "940GZZLURSQ",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLURSQ",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.523073,
      "lon" : -0.124285
    },
    "name" : "Russell Square"
  },
  {
    "id" : "940GZZCRSAN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRSAN",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.375024,
      "lon" : -0.078041
    },
    "name" : "Sandilands"
  },
  {
    "id" : "910GSVNKNGS",
    "lineGroups" : [
      {
        "atcoCode" : "910GSVNKNGS",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.564026,
      "lon" : 0.0971
    },
    "name" : "Seven Kings"
  },
  {
    "id" : "HUBSVS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSVS",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.58333,
      "lon" : -0.072584
    },
    "name" : "Seven Sisters"
  },
  {
    "id" : "HUBSDE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLSHA",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.511693,
      "lon" : -0.056643
    },
    "name" : "Shadwell"
  },
  {
    "id" : "910GSHENFLD",
    "lineGroups" : [
      {
        "atcoCode" : "910GSHENFLD",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.630877,
      "lon" : 0.329851
    },
    "name" : "Shenfield"
  },
  {
    "id" : "HUBSPB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSBC",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.504376,
      "lon" : -0.218813
    },
    "name" : "Shepherd's Bush"
  },
  {
    "id" : "940GZZLUSBM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSBM",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.505579,
      "lon" : -0.226375
    },
    "name" : "Shepherd's Bush Market"
  },
  {
    "id" : "940GZZLUSSQ",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSSQ",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.49227,
      "lon" : -0.156377
    },
    "name" : "Sloane Square"
  },
  {
    "id" : "910GSLOUGH",
    "lineGroups" : [
      {
        "atcoCode" : "910GSLOUGH",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.51188,
      "lon" : -0.59151
    },
    "name" : "Slough"
  },
  {
    "id" : "940GZZLUSNB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSNB",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.580678,
      "lon" : 0.02144
    },
    "name" : "Snaresbrook"
  },
  {
    "id" : "940GZZLUSEA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSEA",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.501003,
      "lon" : -0.307424
    },
    "name" : "South Ealing"
  },
  {
    "id" : "940GZZLUSHH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSHH",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.564888,
      "lon" : -0.352492
    },
    "name" : "South Harrow"
  },
  {
    "id" : "940GZZLUSKS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSKS",
        "lineIds" : [
          "circle",
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUSKS",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.494094,
      "lon" : -0.174138
    },
    "name" : "South Kensington"
  },
  {
    "id" : "HUBSOK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSKT",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.570232,
      "lon" : -0.308433
    },
    "name" : "South Kenton"
  },
  {
    "id" : "940GZZDLSOQ",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLSOQ",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.50005,
      "lon" : -0.015975
    },
    "name" : "South Quay"
  },
  {
    "id" : "HUBSRU",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSRP",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.556853,
      "lon" : -0.398915
    },
    "name" : "South Ruislip"
  },
  {
    "id" : "940GZZLUSWN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSWN",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.415309,
      "lon" : -0.192005
    },
    "name" : "South Wimbledon"
  },
  {
    "id" : "940GZZLUSWF",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSWF",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.591907,
      "lon" : 0.027338
    },
    "name" : "South Woodford"
  },
  {
    "id" : "910GSTHALL",
    "lineGroups" : [
      {
        "atcoCode" : "910GSTHALL",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.505957,
      "lon" : -0.37861
    },
    "name" : "Southall"
  },
  {
    "id" : "940GZZLUSFS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSFS",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.445073,
      "lon" : -0.206602
    },
    "name" : "Southfields"
  },
  {
    "id" : "940GZZLUSGT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSGT",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.632315,
      "lon" : -0.127816
    },
    "name" : "Southgate"
  },
  {
    "id" : "940GZZLUSWK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSWK",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.50427,
      "lon" : -0.105331
    },
    "name" : "Southwark"
  },
  {
    "id" : "940GZZLUSJP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSJP",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.499544,
      "lon" : -0.133608
    },
    "name" : "St. James's Park"
  },
  {
    "id" : "940GZZLUSJW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSJW",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.534521,
      "lon" : -0.173948
    },
    "name" : "St. John's Wood"
  },
  {
    "id" : "940GZZLUSPU",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSPU",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.514936,
      "lon" : -0.097567
    },
    "name" : "St. Paul's"
  },
  {
    "id" : "940GZZLUSFB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSFB",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.494917,
      "lon" : -0.245704
    },
    "name" : "Stamford Brook"
  },
  {
    "id" : "940GZZLUSTM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSTM",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.619839,
      "lon" : -0.303266
    },
    "name" : "Stanmore"
  },
  {
    "id" : "940GZZDLSTL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLSTL",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.520786,
      "lon" : 0.004156
    },
    "name" : "Star Lane"
  },
  {
    "id" : "940GZZLUSGN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSGN",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.521858,
      "lon" : -0.046596
    },
    "name" : "Stepney Green"
  },
  {
    "id" : "940GZZLUSKW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSKW",
        "lineIds" : [
          "northern"
        ]
      },
      {
        "atcoCode" : "940GZZLUSKW",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.472184,
      "lon" : -0.122644
    },
    "name" : "Stockwell"
  },
  {
    "id" : "HUBSBP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSGP",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.543959,
      "lon" : -0.275892
    },
    "name" : "Stonebridge Park"
  },
  {
    "id" : "HUBSRA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSTD",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "940GZZDLSTD",
        "lineIds" : [
          "dlr"
        ]
      },
      {
        "atcoCode" : "910GSTFD",
        "lineIds" : [
          "elizabeth"
        ]
      },
      {
        "atcoCode" : "940GZZLUSTD",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.541806,
      "lon" : -0.003458
    },
    "name" : "Stratford"
  },
  {
    "id" : "940GZZDLSHS",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLSHS",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.538196,
      "lon" : -0.001078
    },
    "name" : "Stratford High Street"
  },
  {
    "id" : "940GZZDLSIT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLSIT",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.545265,
      "lon" : -0.009638
    },
    "name" : "Stratford International"
  },
  {
    "id" : "940GZZLUSUH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSUH",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.556946,
      "lon" : -0.336435
    },
    "name" : "Sudbury Hill"
  },
  {
    "id" : "940GZZLUSUT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSUT",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.550815,
      "lon" : -0.315745
    },
    "name" : "Sudbury Town"
  },
  {
    "id" : "940GZZLUSWC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUSWC",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.543681,
      "lon" : -0.174894
    },
    "name" : "Swiss Cottage"
  },
  {
    "id" : "910GTAPLOW",
    "lineGroups" : [
      {
        "atcoCode" : "910GTAPLOW",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.523562,
      "lon" : -0.68137
    },
    "name" : "Taplow"
  },
  {
    "id" : "940GZZLUTMP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTMP",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.511006,
      "lon" : -0.11426
    },
    "name" : "Temple"
  },
  {
    "id" : "940GZZCRTPA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRTPA",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.385697,
      "lon" : -0.129045
    },
    "name" : "Therapia Lane"
  },
  {
    "id" : "940GZZLUTHB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTHB",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.671759,
      "lon" : 0.103085
    },
    "name" : "Theydon Bois"
  },
  {
    "id" : "940GZZLUTBC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTBC",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.435678,
      "lon" : -0.159736
    },
    "name" : "Tooting Bec"
  },
  {
    "id" : "940GZZLUTBY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTBY",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.42763,
      "lon" : -0.168374
    },
    "name" : "Tooting Broadway"
  },
  {
    "id" : "HUBTCR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTCR",
        "lineIds" : [
          "central"
        ]
      },
      {
        "atcoCode" : "910GTOTCTRD",
        "lineIds" : [
          "elizabeth"
        ]
      },
      {
        "atcoCode" : "940GZZLUTCR",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.516426,
      "lon" : -0.13041
    },
    "name" : "Tottenham Court Road"
  },
  {
    "id" : "HUBTOM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTMH",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.588108,
      "lon" : -0.060241
    },
    "name" : "Tottenham Hale"
  },
  {
    "id" : "940GZZLUTAW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTAW",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.630597,
      "lon" : -0.17921
    },
    "name" : "Totteridge & Whetstone"
  },
  {
    "id" : "HUBTOG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLTWG",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.510617,
      "lon" : -0.074818
    },
    "name" : "Tower Gateway"
  },
  {
    "id" : "940GZZLUTWH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTWH",
        "lineIds" : [
          "circle",
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.509971,
      "lon" : -0.076546
    },
    "name" : "Tower Hill"
  },
  {
    "id" : "940GZZLUTFP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTFP",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.556822,
      "lon" : -0.138433
    },
    "name" : "Tufnell Park"
  },
  {
    "id" : "940GZZLUTNG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTNG",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUTNG",
        "lineIds" : [
          "district",
          "piccadilly"
        ]
      },
      {
        "atcoCode" : "940GZZLUTNG",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.495148,
      "lon" : -0.254555
    },
    "name" : "Turnham Green"
  },
  {
    "id" : "940GZZLUTPN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUTPN",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.590272,
      "lon" : -0.102953
    },
    "name" : "Turnpike Lane"
  },
  {
    "id" : "910GTWYFORD",
    "lineGroups" : [
      {
        "atcoCode" : "910GTWYFORD",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.475534,
      "lon" : -0.863293
    },
    "name" : "Twyford"
  },
  {
    "id" : "HUBUPM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUUPM",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.559063,
      "lon" : 0.250882
    },
    "name" : "Upminster"
  },
  {
    "id" : "940GZZLUUPB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUUPB",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.55856,
      "lon" : 0.235809
    },
    "name" : "Upminster Bridge"
  },
  {
    "id" : "940GZZLUUPY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUUPY",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.538372,
      "lon" : 0.10153
    },
    "name" : "Upney"
  },
  {
    "id" : "940GZZLUUPK",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUUPK",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.53534,
      "lon" : 0.035263
    },
    "name" : "Upton Park"
  },
  {
    "id" : "940GZZLUUXB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUUXB",
        "lineIds" : [
          "metropolitan",
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.546565,
      "lon" : -0.477949
    },
    "name" : "Uxbridge"
  },
  {
    "id" : "HUBVXH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUVXL",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.485743,
      "lon" : -0.124204
    },
    "name" : "Vauxhall"
  },
  {
    "id" : "HUBVIC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUVIC",
        "lineIds" : [
          "circle",
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUVIC",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.496359,
      "lon" : -0.143102
    },
    "name" : "Victoria"
  },
  {
    "id" : "940GZZCRWAD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRWAD",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.377076,
      "lon" : -0.118016
    },
    "name" : "Waddon Marsh"
  },
  {
    "id" : "HUBWHC",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWWL",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.582965,
      "lon" : -0.019885
    },
    "name" : "Walthamstow Central"
  },
  {
    "id" : "940GZZCRWAN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRWAN",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.373022,
      "lon" : -0.113082
    },
    "name" : "Wandle Park"
  },
  {
    "id" : "940GZZLUWSD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWSD",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.575501,
      "lon" : 0.028527
    },
    "name" : "Wanstead"
  },
  {
    "id" : "940GZZLUWRR",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWRR",
        "lineIds" : [
          "northern"
        ]
      },
      {
        "atcoCode" : "940GZZLUWRR",
        "lineIds" : [
          "victoria"
        ]
      }
    ],
    "location" : {
      "lat" : 51.524951,
      "lon" : -0.138321
    },
    "name" : "Warren Street"
  },
  {
    "id" : "940GZZLUWKA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWKA",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.523263,
      "lon" : -0.183783
    },
    "name" : "Warwick Avenue"
  },
  {
    "id" : "HUBWAT",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWLO",
        "lineIds" : [
          "bakerloo"
        ]
      },
      {
        "atcoCode" : "940GZZLUWLO",
        "lineIds" : [
          "jubilee"
        ]
      },
      {
        "atcoCode" : "940GZZLUWLO",
        "lineIds" : [
          "northern"
        ]
      },
      {
        "atcoCode" : "940GZZLUWLO",
        "lineIds" : [
          "waterloo-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.503299,
      "lon" : -0.11478
    },
    "name" : "Waterloo"
  },
  {
    "id" : "940GZZLUWAF",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWAF",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.657446,
      "lon" : -0.417377
    },
    "name" : "Watford"
  },
  {
    "id" : "940GZZCRWEL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRWEL",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.375369,
      "lon" : -0.097539
    },
    "name" : "Wellesley Road"
  },
  {
    "id" : "HUBWMB",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWYC",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.552304,
      "lon" : -0.296852
    },
    "name" : "Wembley Central"
  },
  {
    "id" : "940GZZLUWYP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWYP",
        "lineIds" : [
          "jubilee"
        ]
      },
      {
        "atcoCode" : "940GZZLUWYP",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.563198,
      "lon" : -0.279262
    },
    "name" : "Wembley Park"
  },
  {
    "id" : "940GZZLUWTA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWTA",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.518001,
      "lon" : -0.28098
    },
    "name" : "West Acton"
  },
  {
    "id" : "HUBWBP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWBN",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.487268,
      "lon" : -0.195599
    },
    "name" : "West Brompton"
  },
  {
    "id" : "HUBWCY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRWCR",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.379083,
      "lon" : -0.101984
    },
    "name" : "West Croydon"
  },
  {
    "id" : "910GWDRYTON",
    "lineGroups" : [
      {
        "atcoCode" : "910GWDRYTON",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.510055,
      "lon" : -0.472234
    },
    "name" : "West Drayton"
  },
  {
    "id" : "910GWEALING",
    "lineGroups" : [
      {
        "atcoCode" : "910GWEALING",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.513506,
      "lon" : -0.320133
    },
    "name" : "West Ealing"
  },
  {
    "id" : "940GZZLUWFN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWFN",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.609426,
      "lon" : -0.188362
    },
    "name" : "West Finchley"
  },
  {
    "id" : "HUBWEH",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWHM",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      },
      {
        "atcoCode" : "940GZZDLWHM",
        "lineIds" : [
          "dlr"
        ]
      },
      {
        "atcoCode" : "940GZZLUWHM",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.528136,
      "lon" : 0.005055
    },
    "name" : "West Ham"
  },
  {
    "id" : "HUBWHD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWHP",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.546638,
      "lon" : -0.191059
    },
    "name" : "West Hampstead"
  },
  {
    "id" : "940GZZLUWHW",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWHW",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.57971,
      "lon" : -0.3534
    },
    "name" : "West Harrow"
  },
  {
    "id" : "940GZZDLWIQ",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLWIQ",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.50703,
      "lon" : -0.020311
    },
    "name" : "West India Quay"
  },
  {
    "id" : "940GZZLUWKN",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWKN",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.490459,
      "lon" : -0.206636
    },
    "name" : "West Kensington"
  },
  {
    "id" : "HUBWRU",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWRP",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.569688,
      "lon" : -0.437886
    },
    "name" : "West Ruislip"
  },
  {
    "id" : "940GZZDLWSV",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLWSV",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.502838,
      "lon" : 0.02246
    },
    "name" : "West Silvertown"
  },
  {
    "id" : "940GZZLUWSP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWSP",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.52111,
      "lon" : -0.201065
    },
    "name" : "Westbourne Park"
  },
  {
    "id" : "940GZZDLWFE",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLWFE",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.509431,
      "lon" : -0.02675
    },
    "name" : "Westferry"
  },
  {
    "id" : "HUBWSM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWSM",
        "lineIds" : [
          "circle",
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZLUWSM",
        "lineIds" : [
          "jubilee"
        ]
      }
    ],
    "location" : {
      "lat" : 51.50132,
      "lon" : -0.124861
    },
    "name" : "Westminster"
  },
  {
    "id" : "940GZZLUWCY",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWCY",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.511959,
      "lon" : -0.224297
    },
    "name" : "White City"
  },
  {
    "id" : "HUBZWL",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWPL",
        "lineIds" : [
          "district",
          "hammersmith-city"
        ]
      },
      {
        "atcoCode" : "910GWCHAPXR",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.519518,
      "lon" : -0.059971
    },
    "name" : "Whitechapel"
  },
  {
    "id" : "940GZZLUWIG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWIG",
        "lineIds" : [
          "jubilee"
        ]
      },
      {
        "atcoCode" : "940GZZLUWIG",
        "lineIds" : [
          "metropolitan"
        ]
      }
    ],
    "location" : {
      "lat" : 51.549146,
      "lon" : -0.221537
    },
    "name" : "Willesden Green"
  },
  {
    "id" : "HUBWIJ",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWJN",
        "lineIds" : [
          "bakerloo"
        ]
      }
    ],
    "location" : {
      "lat" : 51.532259,
      "lon" : -0.244283
    },
    "name" : "Willesden Junction"
  },
  {
    "id" : "HUBWIM",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWIM",
        "lineIds" : [
          "district"
        ]
      },
      {
        "atcoCode" : "940GZZCRWMB",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.421207,
      "lon" : -0.206573
    },
    "name" : "Wimbledon"
  },
  {
    "id" : "940GZZLUWIP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWIP",
        "lineIds" : [
          "district"
        ]
      }
    ],
    "location" : {
      "lat" : 51.434573,
      "lon" : -0.199719
    },
    "name" : "Wimbledon Park"
  },
  {
    "id" : "940GZZLUWOG",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWOG",
        "lineIds" : [
          "piccadilly"
        ]
      }
    ],
    "location" : {
      "lat" : 51.597479,
      "lon" : -0.109886
    },
    "name" : "Wood Green"
  },
  {
    "id" : "940GZZLUWLA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWLA",
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ]
      }
    ],
    "location" : {
      "lat" : 51.509669,
      "lon" : -0.22453
    },
    "name" : "Wood Lane"
  },
  {
    "id" : "940GZZLUWOF",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWOF",
        "lineIds" : [
          "central"
        ]
      }
    ],
    "location" : {
      "lat" : 51.606899,
      "lon" : 0.03397
    },
    "name" : "Woodford"
  },
  {
    "id" : "940GZZCRWOD",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZCRWOD",
        "lineIds" : [
          "tram"
        ]
      }
    ],
    "location" : {
      "lat" : 51.38732,
      "lon" : -0.064576
    },
    "name" : "Woodside"
  },
  {
    "id" : "940GZZLUWOP",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZLUWOP",
        "lineIds" : [
          "northern"
        ]
      }
    ],
    "location" : {
      "lat" : 51.618014,
      "lon" : -0.18542
    },
    "name" : "Woodside Park"
  },
  {
    "id" : "910GWOLWXR",
    "lineGroups" : [
      {
        "atcoCode" : "910GWOLWXR",
        "lineIds" : [
          "elizabeth"
        ]
      }
    ],
    "location" : {
      "lat" : 51.491851,
      "lon" : 0.070737
    },
    "name" : "Woolwich"
  },
  {
    "id" : "HUBWWA",
    "lineGroups" : [
      {
        "atcoCode" : "940GZZDLWLA",
        "lineIds" : [
          "dlr"
        ]
      }
    ],
    "location" : {
      "lat" : 51.490009,
      "lon" : 0.069127
    },
    "name" : "Woolwich Arsenal"
  }
]
"""
