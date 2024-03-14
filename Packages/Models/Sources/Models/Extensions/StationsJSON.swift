//
// Stations source of truth
//
let allStationsRawJSON = """
[
  {
    "icsCode" : "1003006",
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
    "icsCode" : "1001001",
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
      "lat" : 51.491241,
      "lon" : 0.121374
    },
    "name" : "Abbey Wood"
  },
  {
    "icsCode" : "1001003",
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
    "icsCode" : "1000002",
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
    "icsCode" : "1002001",
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
      "lat" : 51.356241,
      "lon" : -0.032694
    },
    "name" : "Addington Village"
  },
  {
    "icsCode" : "1002002",
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
      "lat" : 51.379753,
      "lon" : -0.073058
    },
    "name" : "Addiscombe"
  },
  {
    "icsCode" : "1000003",
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
    "icsCode" : "1000004",
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
    "icsCode" : "1002003",
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
    "icsCode" : "1000005",
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
    "icsCode" : "1000006",
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
    "icsCode" : "1002004",
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
    "icsCode" : "1000007",
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
    "icsCode" : "1000008",
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
    "icsCode" : "1002005",
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
      "lat" : 51.391362,
      "lon" : -0.058297
    },
    "name" : "Arena"
  },
  {
    "icsCode" : "1000009",
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
    "icsCode" : "1000010",
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
    "icsCode" : "1002006",
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
      "lat" : 51.4068,
      "lon" : -0.049476
    },
    "name" : "Avenue Road"
  },
  {
    "icsCode" : "1000011",
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
    "icsCode" : "1000012",
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
    "icsCode" : "1000013",
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
      "lat" : 51.513552,
      "lon" : -0.088919
    },
    "name" : "Bank"
  },
  {
    "icsCode" : "1000014",
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
    "icsCode" : "1000015",
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
    "icsCode" : "1000016",
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
    "icsCode" : "1000017",
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
    "icsCode" : "1002195",
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
    "icsCode" : "1000018",
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
    "icsCode" : "1001018",
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
    "icsCode" : "1002010",
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
      "lat" : 51.409639,
      "lon" : -0.042855
    },
    "name" : "Beckenham Road"
  },
  {
    "icsCode" : "1002011",
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
    "icsCode" : "1002012",
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
    "icsCode" : "1000019",
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
    "icsCode" : "1002013",
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
      "lat" : 51.3893,
      "lon" : -0.142409
    },
    "name" : "Beddington Lane"
  },
  {
    "icsCode" : "1002014",
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
      "lat" : 51.399722,
      "lon" : -0.180256
    },
    "name" : "Belgrave Walk"
  },
  {
    "icsCode" : "1000020",
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
      "lat" : 51.550311,
      "lon" : -0.164648
    },
    "name" : "Belsize Park"
  },
  {
    "icsCode" : "1000021",
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
    "icsCode" : "1000022",
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
    "icsCode" : "1001027",
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
    "icsCode" : "1000023",
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
    "icsCode" : "1002017",
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
      "lat" : 51.384748,
      "lon" : -0.070563
    },
    "name" : "Blackhorse Lane"
  },
  {
    "icsCode" : "1000024",
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
    "icsCode" : "1002018",
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
    "icsCode" : "1000025",
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
    "icsCode" : "1000026",
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
    "icsCode" : "1000027",
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
    "icsCode" : "1000028",
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
    "icsCode" : "1002019",
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
    "icsCode" : "1000029",
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
    "icsCode" : "1000030",
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
    "icsCode" : "1000292",
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
    "icsCode" : "1000031",
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
    "icsCode" : "1000032",
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
    "icsCode" : "1000033",
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
    "icsCode" : "1000860",
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
    "icsCode" : "1000034",
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
    "icsCode" : "1000035",
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
    "icsCode" : "1000036",
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
    "icsCode" : "1000037",
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
    "icsCode" : "1000038",
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
    "icsCode" : "1000039",
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
    "icsCode" : "1000040",
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
    "icsCode" : "1000041",
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
    "icsCode" : "1002042",
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
      "lat" : 51.376229,
      "lon" : -0.103424
    },
    "name" : "Centrale"
  },
  {
    "icsCode" : "1001055",
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
    "icsCode" : "1000042",
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
    "icsCode" : "1000043",
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
    "icsCode" : "1000044",
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
    "icsCode" : "1000045",
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
    "icsCode" : "1000046",
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
    "icsCode" : "1000047",
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
    "icsCode" : "1000048",
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
    "icsCode" : "1000049",
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
    "icsCode" : "1002023",
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
      "lat" : 51.373708,
      "lon" : -0.104361
    },
    "name" : "Church Street"
  },
  {
    "icsCode" : "1000050",
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
    "icsCode" : "1000051",
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
    "icsCode" : "1000052",
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
    "icsCode" : "1000053",
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
    "icsCode" : "1000054",
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
    "icsCode" : "1000055",
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
    "icsCode" : "1002024",
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
      "lat" : 51.359875,
      "lon" : -0.058623
    },
    "name" : "Coombe Lane"
  },
  {
    "icsCode" : "1000056",
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
    "icsCode" : "1002025",
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
    "icsCode" : "1000057",
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
    "icsCode" : "1001079",
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
    "icsCode" : "1002027",
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
    "icsCode" : "1002028",
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
    "icsCode" : "1000058",
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
    "icsCode" : "1000059",
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
    "icsCode" : "1000060",
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
    "icsCode" : "1002029",
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
    "icsCode" : "1002030",
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
    "icsCode" : "1000061",
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
    "icsCode" : "1002031",
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
      "lat" : 51.417608,
      "lon" : -0.207648
    },
    "name" : "Dundonald Road"
  },
  {
    "icsCode" : "1000062",
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
    "icsCode" : "1000063",
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
    "icsCode" : "1000064",
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
    "icsCode" : "1000065",
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
    "icsCode" : "1001089",
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
    "icsCode" : "1000067",
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
    "icsCode" : "1000068",
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
    "icsCode" : "1002033",
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
    "icsCode" : "1000069",
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
    "icsCode" : "1000066",
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
    "icsCode" : "1000070",
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
    "icsCode" : "1000071",
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
    "icsCode" : "1000072",
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
    "icsCode" : "1000073",
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
    "icsCode" : "1000074",
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
    "icsCode" : "1001094",
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
    "icsCode" : "1002035",
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
    "icsCode" : "1000075",
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
    "icsCode" : "1000076",
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
    "icsCode" : "1000077",
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
      "lat" : 51.528055,
      "lon" : -0.132182
    },
    "name" : "Euston"
  },
  {
    "icsCode" : "1000078",
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
    "icsCode" : "1000079",
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
    "icsCode" : "1000080",
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
    "icsCode" : "1002038",
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
    "icsCode" : "1000081",
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
    "icsCode" : "1000082",
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
    "icsCode" : "1000083",
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
    "icsCode" : "1001111",
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
    "icsCode" : "1000084",
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
    "icsCode" : "1002039",
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
    "icsCode" : "1000085",
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
    "icsCode" : "1002040",
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
    "icsCode" : "1001115",
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
    "icsCode" : "1000086",
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
    "icsCode" : "1000087",
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
    "icsCode" : "1000088",
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
    "icsCode" : "1000089",
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
    "icsCode" : "1001117",
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
    "icsCode" : "1000090",
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
    "icsCode" : "1002041",
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
    "icsCode" : "1000091",
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
    "icsCode" : "1000093",
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
    "icsCode" : "1000092",
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
    "icsCode" : "1001123",
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
    "icsCode" : "1000094",
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
    "icsCode" : "1000095",
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
    "icsCode" : "1000096",
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
    "icsCode" : "1000098",
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
    "icsCode" : "1000099",
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
    "icsCode" : "1001135",
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
    "icsCode" : "1000100",
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
    "icsCode" : "1001137",
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
    "icsCode" : "1002045",
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
      "lat" : 51.399793,
      "lon" : -0.060729
    },
    "name" : "Harrington Road"
  },
  {
    "icsCode" : "1000101",
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
    "icsCode" : "1000102",
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
    "icsCode" : "1000103",
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
    "icsCode" : "1001144",
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
    "icsCode" : "1000104",
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
    "icsCode" : "1016430",
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
    "icsCode" : "1000105",
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
    "icsCode" : "1000106",
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
    "icsCode" : "1002046",
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
    "icsCode" : "1000107",
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
    "icsCode" : "1000110",
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
    "icsCode" : "1000108",
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
    "icsCode" : "1000109",
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
    "icsCode" : "1000111",
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
    "icsCode" : "1000112",
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
    "icsCode" : "1000113",
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
    "icsCode" : "1000114",
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
    "icsCode" : "1000115",
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
    "icsCode" : "1000116",
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
    "icsCode" : "1000117",
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
    "icsCode" : "1000118",
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
    "icsCode" : "1000119",
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
    "icsCode" : "1000120",
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
    "icsCode" : "1001157",
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
    "icsCode" : "1002048",
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
    "icsCode" : "1000955",
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
    "icsCode" : "1000121",
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
    "icsCode" : "1000122",
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
    "icsCode" : "1000170",
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
    "icsCode" : "1000123",
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
    "icsCode" : "1000124",
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
    "icsCode" : "1000125",
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
    "icsCode" : "1000126",
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
    "icsCode" : "1000127",
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
    "icsCode" : "1002009",
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
    "icsCode" : "1002050",
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
      "lat" : 51.34614,
      "lon" : -0.020849
    },
    "name" : "King Henry's Drive"
  },
  {
    "icsCode" : "1000129",
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
    "icsCode" : "1000128",
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
    "icsCode" : "1000130",
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
    "icsCode" : "1000131",
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
    "icsCode" : "1000132",
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
    "icsCode" : "1000133",
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
    "icsCode" : "1002034",
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
    "icsCode" : "1000957",
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
    "icsCode" : "1000134",
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
    "icsCode" : "1002052",
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
    "icsCode" : "1000135",
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
    "icsCode" : "1001177",
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
    "icsCode" : "1000136",
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
    "icsCode" : "1000137",
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
    "icsCode" : "1001180",
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
    "icsCode" : "1000138",
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
    "icsCode" : "1002055",
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
      "lat" : 51.364193,
      "lon" : -0.082229
    },
    "name" : "Lloyd Park"
  },
  {
    "icsCode" : "1000139",
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
    "icsCode" : "1002000",
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
    "icsCode" : "1000140",
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
    "icsCode" : "1000141",
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
    "icsCode" : "1000964",
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
    "icsCode" : "1000142",
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
    "icsCode" : "1001189",
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
    "icsCode" : "1000143",
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
    "icsCode" : "1000144",
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
    "icsCode" : "1001190",
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
    "icsCode" : "1000145",
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
    "icsCode" : "1002057",
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
    "icsCode" : "1000146",
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
    "icsCode" : "1000147",
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
    "icsCode" : "1002058",
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
      "lat" : 51.397787,
      "lon" : -0.172585
    },
    "name" : "Mitcham"
  },
  {
    "icsCode" : "1001194",
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
    "icsCode" : "1000148",
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
    "icsCode" : "1000150",
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
    "icsCode" : "1000149",
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
    "icsCode" : "1000151",
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
    "icsCode" : "1002060",
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
      "lat" : 51.408874,
      "lon" : -0.192834
    },
    "name" : "Morden Road"
  },
  {
    "icsCode" : "1000152",
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
    "icsCode" : "1002061",
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
    "icsCode" : "1000153",
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
    "icsCode" : "1002062",
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
      "lat" : 51.34313,
      "lon" : -0.017805
    },
    "name" : "New Addington"
  },
  {
    "icsCode" : "1000154",
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
    "icsCode" : "1002196",
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
    "icsCode" : "1000157",
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
    "icsCode" : "1000158",
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
    "icsCode" : "1000160",
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
    "icsCode" : "1000161",
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
    "icsCode" : "1000163",
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
    "icsCode" : "1000159",
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
    "icsCode" : "1000162",
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
    "icsCode" : "1000164",
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
    "icsCode" : "1000165",
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
    "icsCode" : "1000166",
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
    "icsCode" : "1000167",
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
    "icsCode" : "1000168",
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
    "icsCode" : "1000169",
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
    "icsCode" : "1000171",
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
    "icsCode" : "1000172",
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
    "icsCode" : "1000173",
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
    "icsCode" : "1000174",
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
    "icsCode" : "1000176",
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
    "icsCode" : "1000177",
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
    "icsCode" : "1000178",
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
    "icsCode" : "1002063",
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
    "icsCode" : "1000179",
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
    "icsCode" : "1000180",
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
    "icsCode" : "1000181",
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
    "icsCode" : "1000182",
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
    "icsCode" : "1002099",
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
    "icsCode" : "1002064",
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
    "icsCode" : "1000183",
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
    "icsCode" : "1002065",
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
    "icsCode" : "1002066",
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
    "icsCode" : "1000184",
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
    "icsCode" : "1000186",
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
    "icsCode" : "1000185",
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
    "icsCode" : "1000187",
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
    "icsCode" : "1000188",
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
    "icsCode" : "1000189",
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
    "icsCode" : "1000972",
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
    "icsCode" : "1000190",
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
    "icsCode" : "1002068",
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
      "lat" : 51.375279,
      "lon" : -0.106408
    },
    "name" : "Reeves Corner"
  },
  {
    "icsCode" : "1000191",
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
    "icsCode" : "1000192",
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
    "icsCode" : "1000193",
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
    "icsCode" : "1000194",
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
    "icsCode" : "1001243",
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
    "icsCode" : "1002070",
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
    "icsCode" : "1000196",
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
    "icsCode" : "1002071",
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
    "icsCode" : "1000197",
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
    "icsCode" : "1000198",
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
    "icsCode" : "1000199",
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
    "icsCode" : "1000200",
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
    "icsCode" : "1002072",
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
      "lat" : 51.375006,
      "lon" : -0.078027
    },
    "name" : "Sandilands"
  },
  {
    "icsCode" : "1001246",
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
    "icsCode" : "1000201",
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
    "icsCode" : "1000202",
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
    "icsCode" : "1006448",
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
    "icsCode" : "1000203",
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
    "icsCode" : "1000204",
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
    "icsCode" : "1000206",
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
    "icsCode" : "1000951",
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
    "icsCode" : "1000207",
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
    "icsCode" : "1000208",
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
    "icsCode" : "1000211",
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
    "icsCode" : "1000212",
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
    "icsCode" : "1000213",
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
    "icsCode" : "1002074",
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
    "icsCode" : "1000214",
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
    "icsCode" : "1000216",
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
    "icsCode" : "1000217",
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
    "icsCode" : "1001255",
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
    "icsCode" : "1000209",
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
    "icsCode" : "1000210",
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
    "icsCode" : "1000215",
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
    "icsCode" : "1000221",
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
    "icsCode" : "1000222",
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
    "icsCode" : "1000225",
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
    "icsCode" : "1000218",
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
    "icsCode" : "1000219",
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
    "icsCode" : "1003005",
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
    "icsCode" : "1000220",
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
    "icsCode" : "1000223",
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
    "icsCode" : "1000224",
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
    "icsCode" : "1000226",
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
    "icsCode" : "1003007",
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
    "icsCode" : "1003009",
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
    "icsCode" : "1000227",
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
    "icsCode" : "1000228",
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
    "icsCode" : "1000230",
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
    "icsCode" : "1000960",
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
    "icsCode" : "1000231",
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
    "icsCode" : "1002075",
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
      "lat" : 51.385296,
      "lon" : -0.128702
    },
    "name" : "Therapia Lane"
  },
  {
    "icsCode" : "1000232",
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
    "icsCode" : "1000233",
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
    "icsCode" : "1000234",
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
    "icsCode" : "1000235",
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
    "icsCode" : "1000236",
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
    "icsCode" : "1000237",
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
    "icsCode" : "1002076",
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
    "icsCode" : "1000238",
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
    "icsCode" : "1000239",
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
    "icsCode" : "1000240",
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
    "icsCode" : "1000241",
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
    "icsCode" : "1000969",
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
    "icsCode" : "1000242",
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
    "icsCode" : "1000243",
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
    "icsCode" : "1000244",
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
    "icsCode" : "1000245",
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
    "icsCode" : "1000246",
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
    "icsCode" : "1000247",
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
    "icsCode" : "1000248",
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
    "icsCode" : "1002078",
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
    "icsCode" : "1000249",
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
    "icsCode" : "1002079",
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
    "icsCode" : "1000250",
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
    "icsCode" : "1000252",
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
    "icsCode" : "1000253",
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
    "icsCode" : "1000254",
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
    "icsCode" : "1000255",
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
    "icsCode" : "1002081",
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
      "lat" : 51.37537,
      "lon" : -0.097554
    },
    "name" : "Wellesley Road"
  },
  {
    "icsCode" : "1000256",
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
    "icsCode" : "1000257",
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
    "icsCode" : "1000258",
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
    "icsCode" : "1000260",
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
    "icsCode" : "1001324",
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
    "icsCode" : "1001325",
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
    "icsCode" : "1001327",
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
    "icsCode" : "1000261",
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
    "icsCode" : "1000262",
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
    "icsCode" : "1000263",
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
    "icsCode" : "1000264",
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
    "icsCode" : "1002084",
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
    "icsCode" : "1000265",
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
    "icsCode" : "1000267",
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
    "icsCode" : "1002098",
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
    "icsCode" : "1000259",
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
    "icsCode" : "1002083",
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
    "icsCode" : "1000266",
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
    "icsCode" : "1000269",
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
    "icsCode" : "1000268",
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
    "icsCode" : "1000270",
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
    "icsCode" : "1000271",
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
    "icsCode" : "1000272",
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
    "icsCode" : "1000273",
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
    "icsCode" : "1000275",
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
    "icsCode" : "1000278",
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
    "icsCode" : "1000274",
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
    "icsCode" : "1002086",
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
    "icsCode" : "1000276",
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
    "icsCode" : "1002162",
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
    "icsCode" : "1001344",
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
