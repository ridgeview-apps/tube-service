let stationsJSON =
"""
[
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
          "waterloo-city"
        ],
        "atcoCode" : "940GZZLUBNK"
      },
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
    "name" : "Barking",
    "id" : "HUBBKG",
    "arrivalsGroups" : [
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
      },
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUBKG"
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
    "name" : "Canary Wharf",
    "id" : "HUBCAW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUCYF"
      },
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLCAN"
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
    "name" : "Ealing Broadway",
    "id" : "HUBEAL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUEBY"
      },
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUEBY"
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
    "name" : "Elephant & Castle",
    "id" : "HUBEPH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUEAC"
      },
      {
        "lineIds" : [
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUEAC"
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
    "name" : "Heathrow Terminals 2 & 3",
    "id" : "HUBH13",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHRC"
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
    "name" : "Hammersmith",
    "id" : "HUBHMS",
    "arrivalsGroups" : [
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
      },
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUHSC"
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
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUHR5"
      }
    ]
  },
  {
    "name" : "King's Cross & St Pancras International",
    "id" : "HUBKGX",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan",
          "circle",
          "hammersmith-city"
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
          "northern"
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
    "name" : "London Bridge",
    "id" : "HUBLBG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLULNB"
      },
      {
        "lineIds" : [
          "jubilee"
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
          "metropolitan",
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLULVT"
      },
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLULVT"
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
    "name" : "Paddington",
    "id" : "HUBPAD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "hammersmith-city"
        ],
        "atcoCode" : "940GZZLUPAH"
      },
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
    "name" : "Stratford",
    "id" : "HUBSRA",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLSTD"
      },
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUSTD"
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
          "district",
          "circle"
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
    "name" : "Waterloo",
    "id" : "HUBWAT",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "waterloo-city"
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
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUWLO"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUWLO"
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
    "name" : "West Ham",
    "id" : "HUBWEH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLWHM"
      },
      {
        "lineIds" : [
          "hammersmith-city",
          "district"
        ],
        "atcoCode" : "940GZZLUWHM"
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
          "tram"
        ],
        "atcoCode" : "940GZZCRWMB"
      },
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUWIM"
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
    "name" : "Westminster",
    "id" : "HUBWSM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUWSM"
      },
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUWSM"
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
      }
    ]
  },
  {
    "name" : "Moorgate",
    "id" : "HUBZMG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLUMGT"
      },
      {
        "lineIds" : [
          "metropolitan",
          "hammersmith-city",
          "circle"
        ],
        "atcoCode" : "940GZZLUMGT"
      }
    ]
  },
  {
    "name" : "Whitechapel",
    "id" : "HUBZWL",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "hammersmith-city",
          "district"
        ],
        "atcoCode" : "940GZZLUWPL"
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
    "name" : "Custom House (for ExCel)",
    "id" : "940GZZDLCUS",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "dlr"
        ],
        "atcoCode" : "940GZZDLCUS"
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
    "name" : "Barbican",
    "id" : "940GZZLUBBN",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "metropolitan",
          "hammersmith-city",
          "circle"
        ],
        "atcoCode" : "940GZZLUBBN"
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
    "name" : "Bond Street",
    "id" : "940GZZLUBND",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "jubilee"
        ],
        "atcoCode" : "940GZZLUBND"
      },
      {
        "lineIds" : [
          "central"
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
    "name" : "Baker Street",
    "id" : "940GZZLUBST",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "hammersmith-city",
          "circle"
        ],
        "atcoCode" : "940GZZLUBST"
      },
      {
        "lineIds" : [
          "metropolitan"
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
          "bakerloo"
        ],
        "atcoCode" : "940GZZLUBST"
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
    "name" : "Bow Road",
    "id" : "940GZZLUBWR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "hammersmith-city",
          "district"
        ],
        "atcoCode" : "940GZZLUBWR"
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
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUECT"
      },
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUECT"
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
    "name" : "East Ham",
    "id" : "940GZZLUEHM",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "hammersmith-city",
          "district"
        ],
        "atcoCode" : "940GZZLUEHM"
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
          "northern"
        ],
        "atcoCode" : "940GZZLUEMB"
      },
      {
        "lineIds" : [
          "district",
          "circle"
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
          "district",
          "circle"
        ],
        "atcoCode" : "940GZZLUERC"
      },
      {
        "lineIds" : [
          "hammersmith-city",
          "circle"
        ],
        "atcoCode" : "940GZZLUERC"
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
          "hammersmith-city",
          "circle"
        ],
        "atcoCode" : "940GZZLUGHK"
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
          "victoria"
        ],
        "atcoCode" : "940GZZLUGPK"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUGPK"
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
    "name" : "Gloucester Road",
    "id" : "940GZZLUGTR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district"
        ],
        "atcoCode" : "940GZZLUGTR"
      },
      {
        "lineIds" : [
          "circle"
        ],
        "atcoCode" : "940GZZLUGTR"
      },
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLUGTR"
      },
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUGTR"
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
    "name" : "Hillingdon",
    "id" : "940GZZLUHGD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUHGD"
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
    "name" : "High Street Kensington",
    "id" : "940GZZLUHSK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "circle"
        ],
        "atcoCode" : "940GZZLUHSK"
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
    "name" : "Ickenham",
    "id" : "940GZZLUICK",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUICK"
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
    "name" : "Latimer Road",
    "id" : "940GZZLULRD",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "hammersmith-city",
          "circle"
        ],
        "atcoCode" : "940GZZLULRD"
      }
    ]
  },
  {
    "name" : "Leicester Square",
    "id" : "940GZZLULSQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLULSQ"
      },
      {
        "lineIds" : [
          "northern"
        ],
        "atcoCode" : "940GZZLULSQ"
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
    "name" : "Mansion House",
    "id" : "940GZZLUMSH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "circle"
        ],
        "atcoCode" : "940GZZLUMSH"
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
    "name" : "Notting Hill Gate",
    "id" : "940GZZLUNHG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "circle",
          "district"
        ],
        "atcoCode" : "940GZZLUNHG"
      },
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUNHG"
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
          "victoria"
        ],
        "atcoCode" : "940GZZLUOXC"
      },
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
    "name" : "Plaistow",
    "id" : "940GZZLUPLW",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "hammersmith-city",
          "district"
        ],
        "atcoCode" : "940GZZLUPLW"
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
          "piccadilly",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLURSM"
      }
    ]
  },
  {
    "name" : "Ruislip",
    "id" : "940GZZLURSP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
        ],
        "atcoCode" : "940GZZLURSP"
      },
      {
        "lineIds" : [
          "metropolitan"
        ],
        "atcoCode" : "940GZZLURSP"
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
    "name" : "Royal Oak",
    "id" : "940GZZLURYO",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "hammersmith-city",
          "circle"
        ],
        "atcoCode" : "940GZZLURYO"
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
    "name" : "St. James's Park",
    "id" : "940GZZLUSJP",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "circle"
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
    "name" : "Sloane Square",
    "id" : "940GZZLUSSQ",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "circle"
        ],
        "atcoCode" : "940GZZLUSSQ"
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
    "id" : "940GZZLUTCR",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "central"
        ],
        "atcoCode" : "940GZZLUTCR"
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
    "name" : "Turnham Green",
    "id" : "940GZZLUTNG",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly"
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
          "district"
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
    "name" : "Tower Hill",
    "id" : "940GZZLUTWH",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "district",
          "circle"
        ],
        "atcoCode" : "940GZZLUTWH"
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
    "name" : "Uxbridge",
    "id" : "940GZZLUUXB",
    "arrivalsGroups" : [
      {
        "lineIds" : [
          "piccadilly",
          "metropolitan"
        ],
        "atcoCode" : "940GZZLUUXB"
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
  }
]
""".data(using: .utf8)!
