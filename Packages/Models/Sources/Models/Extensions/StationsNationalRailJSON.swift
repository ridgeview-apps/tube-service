//
// National rail stations source of truth
//
// Generated (with tweaks) from: https://api.tfl.gov.uk/StopPoint/Type/NaptanRailStation?page=1
//
// swiftlint:disable file_length
let allStationsNationalRailRawJSON = """
[
  {
    "commonName" : "Abbey Wood",
    "icsCode" : "1001001",
    "lat" : 51.491225,
    "lon" : 0.12084,
    "naptanId" : "910GABWDXR"
  },
  {
    "commonName" : "Acton Central",
    "icsCode" : "1001002",
    "lat" : 51.508716,
    "lon" : -0.262971,
    "naptanId" : "910GACTNCTL"
  },
  {
    "commonName" : "Acton Main Line",
    "icsCode" : "1001003",
    "lat" : 51.51718,
    "lon" : -0.266756,
    "naptanId" : "910GACTONML"
  },
  {
    "commonName" : "Addlestone",
    "icsCode" : "1001275",
    "lat" : 51.373046,
    "lon" : -0.484457,
    "naptanId" : "910GADLESTN"
  },
  {
    "commonName" : "Albany Park",
    "icsCode" : "1001004",
    "lat" : 51.435453,
    "lon" : 0.125737,
    "naptanId" : "910GALBNYPK"
  },
  {
    "commonName" : "Alexandra Palace",
    "icsCode" : "1001005",
    "lat" : 51.597924,
    "lon" : -0.120235,
    "naptanId" : "910GALEXNDP"
  },
  {
    "commonName" : "Amersham",
    "icsCode" : "1000006",
    "lat" : 51.674206,
    "lon" : -0.607596,
    "naptanId" : "910GAMERSHM"
  },
  {
    "commonName" : "Anerley",
    "icsCode" : "1001007",
    "lat" : 51.412153,
    "lon" : -0.065886,
    "naptanId" : "910GANERLEY"
  },
  {
    "commonName" : "Apsley",
    "icsCode" : "1000808",
    "lat" : 51.732522,
    "lon" : -0.462935,
    "naptanId" : "910GAPSLEY"
  },
  {
    "commonName" : "Ascot",
    "icsCode" : "90000250",
    "lat" : 51.406244,
    "lon" : -0.675833,
    "naptanId" : "910GASCOT"
  },
  {
    "commonName" : "Ash Vale",
    "icsCode" : "90000301",
    "lat" : 51.272247,
    "lon" : -0.721649,
    "naptanId" : "910GASHVALE"
  },
  {
    "commonName" : "Ashford (Surrey)",
    "icsCode" : "1001500",
    "lat" : 51.436507,
    "lon" : -0.468071,
    "naptanId" : "910GASFDMSX"
  },
  {
    "commonName" : "Ashtead",
    "icsCode" : "1001548",
    "lat" : 51.317874,
    "lon" : -0.307572,
    "naptanId" : "910GASHD"
  },
  {
    "commonName" : "Ashurst (Kent)",
    "icsCode" : "90000300",
    "lat" : 51.128663,
    "lon" : 0.152652,
    "naptanId" : "910GASHURST"
  },
  {
    "commonName" : "Aylesford",
    "icsCode" : "90000346",
    "lat" : 51.301318,
    "lon" : 0.466171,
    "naptanId" : "910GAYLESFD"
  },
  {
    "commonName" : "Bagshot",
    "icsCode" : "90000369",
    "lat" : 51.364368,
    "lon" : -0.688662,
    "naptanId" : "910GBAGSHOT"
  },
  {
    "commonName" : "Balham",
    "icsCode" : "1000328",
    "lat" : 51.443225,
    "lon" : -0.152424,
    "naptanId" : "910GBALHAM"
  },
  {
    "commonName" : "Banstead",
    "icsCode" : "1001552",
    "lat" : 51.329349,
    "lon" : -0.213159,
    "naptanId" : "910GBANSTED"
  },
  {
    "commonName" : "Barking",
    "icsCode" : "1000015",
    "lat" : 51.539495,
    "lon" : 0.080903,
    "naptanId" : "910GBARKING"
  },
  {
    "commonName" : "Barking Riverside",
    "icsCode" : "1002272",
    "lat" : 51.519349,
    "lon" : 0.116626,
    "naptanId" : "910GBKRVS"
  },
  {
    "commonName" : "Barming",
    "icsCode" : "90000417",
    "lat" : 51.284895,
    "lon" : 0.478958,
    "naptanId" : "910GBARMING"
  },
  {
    "commonName" : "Barnehurst",
    "icsCode" : "1001013",
    "lat" : 51.464959,
    "lon" : 0.159646,
    "naptanId" : "910GBRNHRST"
  },
  {
    "commonName" : "Barnes",
    "icsCode" : "1001014",
    "lat" : 51.467086,
    "lon" : -0.242164,
    "naptanId" : "910GBARNES"
  },
  {
    "commonName" : "Barnes Bridge",
    "icsCode" : "1001015",
    "lat" : 51.472009,
    "lon" : -0.25263,
    "naptanId" : "910GBNSBDGE"
  },
  {
    "commonName" : "Basildon",
    "icsCode" : "1000724",
    "lat" : 51.568106,
    "lon" : 0.456789,
    "naptanId" : "910GBASILDN"
  },
  {
    "commonName" : "Bat & Ball",
    "icsCode" : "90000437",
    "lat" : 51.289761,
    "lon" : 0.194228,
    "naptanId" : "910GBATABAL"
  },
  {
    "commonName" : "Battersea Park",
    "icsCode" : "1001016",
    "lat" : 51.47696,
    "lon" : -0.147533,
    "naptanId" : "910GBATRSPK"
  },
  {
    "commonName" : "Battlesbridge",
    "icsCode" : "1000571",
    "lat" : 51.624825,
    "lon" : 0.565286,
    "naptanId" : "910GBTLSBDG"
  },
  {
    "commonName" : "Bayford",
    "icsCode" : "1000476",
    "lat" : 51.757716,
    "lon" : -0.09561,
    "naptanId" : "910GBAYFORD"
  },
  {
    "commonName" : "Beaconsfield",
    "icsCode" : "1000338",
    "lat" : 51.611291,
    "lon" : -0.643822,
    "naptanId" : "910GBCNSFLD"
  },
  {
    "commonName" : "Beckenham Hill",
    "icsCode" : "1001017",
    "lat" : 51.424583,
    "lon" : -0.015951,
    "naptanId" : "910GBCKNHMH"
  },
  {
    "commonName" : "Beckenham Junction",
    "icsCode" : "1001018",
    "lat" : 51.411035,
    "lon" : -0.025813,
    "naptanId" : "910GBCKNHMJ"
  },
  {
    "commonName" : "Bellingham",
    "icsCode" : "1001019",
    "lat" : 51.432913,
    "lon" : -0.019331,
    "naptanId" : "910GBELNGHM"
  },
  {
    "commonName" : "Belmont",
    "icsCode" : "1001020",
    "lat" : 51.343815,
    "lon" : -0.198855,
    "naptanId" : "910GBELM"
  },
  {
    "commonName" : "Beltring",
    "icsCode" : "1001010",
    "lat" : 51.204709,
    "lon" : 0.403496,
    "naptanId" : "910GBLTRNAB"
  },
  {
    "commonName" : "Belvedere",
    "icsCode" : "1001021",
    "lat" : 51.492118,
    "lon" : 0.152286,
    "naptanId" : "910GBELVEDR"
  },
  {
    "commonName" : "Benfleet",
    "icsCode" : "1000727",
    "lat" : 51.543945,
    "lon" : 0.561713,
    "naptanId" : "910GBENFLET"
  },
  {
    "commonName" : "Berkhamsted",
    "icsCode" : "1000814",
    "lat" : 51.763134,
    "lon" : -0.562013,
    "naptanId" : "910GBERKHMD"
  },
  {
    "commonName" : "Berrylands",
    "icsCode" : "1001022",
    "lat" : 51.399045,
    "lon" : -0.280714,
    "naptanId" : "910GBRLANDS"
  },
  {
    "commonName" : "Betchworth",
    "icsCode" : "1001315",
    "lat" : 51.248269,
    "lon" : -0.266884,
    "naptanId" : "910GBTCHWTH"
  },
  {
    "commonName" : "Bethnal Green",
    "icsCode" : "1001023",
    "lat" : 51.523917,
    "lon" : -0.059568,
    "naptanId" : "910GBTHNLGR"
  },
  {
    "commonName" : "Bexley",
    "icsCode" : "1001024",
    "lat" : 51.440219,
    "lon" : 0.147903,
    "naptanId" : "910GBEXLEY"
  },
  {
    "commonName" : "Bexleyheath",
    "icsCode" : "1001025",
    "lat" : 51.4635,
    "lon" : 0.133735,
    "naptanId" : "910GBXLYHTH"
  },
  {
    "commonName" : "Bickley",
    "icsCode" : "1001026",
    "lat" : 51.400104,
    "lon" : 0.045241,
    "naptanId" : "910GBICKLEY"
  },
  {
    "commonName" : "Billericay",
    "icsCode" : "1000573",
    "lat" : 51.628884,
    "lon" : 0.41863,
    "naptanId" : "910GBILERCY"
  },
  {
    "commonName" : "Birkbeck",
    "icsCode" : "1000330",
    "lat" : 51.403892,
    "lon" : -0.055739,
    "naptanId" : "910GBIRKBCK"
  },
  {
    "commonName" : "Bishops Stortford",
    "icsCode" : "1000576",
    "lat" : 51.866691,
    "lon" : 0.164894,
    "naptanId" : "910GBSHPSFD"
  },
  {
    "commonName" : "Blackheath",
    "icsCode" : "1001029",
    "lat" : 51.465796,
    "lon" : 0.008872,
    "naptanId" : "910GBLKHTH"
  },
  {
    "commonName" : "Blackhorse Road",
    "icsCode" : "1000024",
    "lat" : 51.586605,
    "lon" : -0.041236,
    "naptanId" : "910GBLCHSRD"
  },
  {
    "commonName" : "Blackwater",
    "icsCode" : "90000463",
    "lat" : 51.331582,
    "lon" : -0.776741,
    "naptanId" : "910GBCKWATR"
  },
  {
    "commonName" : "Bond Street",
    "icsCode" : "1000025",
    "lat" : 51.513895,
    "lon" : -0.147246,
    "naptanId" : "910GBONDST"
  },
  {
    "commonName" : "Bookham",
    "icsCode" : "1001511",
    "lat" : 51.288739,
    "lon" : -0.384021,
    "naptanId" : "910GBOOKHAM"
  },
  {
    "commonName" : "Borough Green & Wrotham",
    "icsCode" : "1001012",
    "lat" : 51.293219,
    "lon" : 0.306245,
    "naptanId" : "910GBORWGAW"
  },
  {
    "commonName" : "Bourne End",
    "icsCode" : "1000856",
    "lat" : 51.577118,
    "lon" : -0.710473,
    "naptanId" : "910GBORNEND"
  },
  {
    "commonName" : "Bowes Park",
    "icsCode" : "1001031",
    "lat" : 51.607012,
    "lon" : -0.120582,
    "naptanId" : "910GBOWESPK"
  },
  {
    "commonName" : "Box Hill & Westhumble",
    "icsCode" : "1001509",
    "lat" : 51.254012,
    "lon" : -0.32849,
    "naptanId" : "910GBOXHAWH"
  },
  {
    "commonName" : "Bracknell",
    "icsCode" : "1001356",
    "lat" : 51.413092,
    "lon" : -0.751704,
    "naptanId" : "910GBRACKNL"
  },
  {
    "commonName" : "Brent Cross West Station",
    "icsCode" : "1002310",
    "lat" : 51.568429,
    "lon" : -0.225488,
    "naptanId" : "910GBRENTX"
  },
  {
    "commonName" : "Brentford",
    "icsCode" : "1001032",
    "lat" : 51.487547,
    "lon" : -0.309651,
    "naptanId" : "910GBNTFORD"
  },
  {
    "commonName" : "Brentwood",
    "icsCode" : "1000292",
    "lat" : 51.613605,
    "lon" : 0.299586,
    "naptanId" : "910GBRTWOOD"
  },
  {
    "commonName" : "Bricket Wood",
    "icsCode" : "1000770",
    "lat" : 51.705428,
    "lon" : -0.359115,
    "naptanId" : "910GBCWD"
  },
  {
    "commonName" : "Brimsdown",
    "icsCode" : "1001033",
    "lat" : 51.655583,
    "lon" : -0.030817,
    "naptanId" : "910GBRIMSDN"
  },
  {
    "commonName" : "Brixton",
    "icsCode" : "1000325",
    "lat" : 51.463299,
    "lon" : -0.114183,
    "naptanId" : "910GBRIXTON"
  },
  {
    "commonName" : "Brockley",
    "icsCode" : "1001035",
    "lat" : 51.464649,
    "lon" : -0.037537,
    "naptanId" : "910GBROCKLY"
  },
  {
    "commonName" : "Bromley North",
    "icsCode" : "1001036",
    "lat" : 51.408328,
    "lon" : 0.016993,
    "naptanId" : "910GBROMLYN"
  },
  {
    "commonName" : "Bromley South",
    "icsCode" : "1001037",
    "lat" : 51.399976,
    "lon" : 0.017344,
    "naptanId" : "910GBROMLYS"
  },
  {
    "commonName" : "Brondesbury",
    "icsCode" : "1001038",
    "lat" : 51.545166,
    "lon" : -0.202309,
    "naptanId" : "910GBRBY"
  },
  {
    "commonName" : "Brondesbury Park",
    "icsCode" : "1001039",
    "lat" : 51.540699,
    "lon" : -0.210128,
    "naptanId" : "910GBRBYPK"
  },
  {
    "commonName" : "Brookmans Park",
    "icsCode" : "1000291",
    "lat" : 51.721062,
    "lon" : -0.204549,
    "naptanId" : "910GBRKMNPK"
  },
  {
    "commonName" : "Brookwood",
    "icsCode" : "90000955",
    "lat" : 51.303758,
    "lon" : -0.635748,
    "naptanId" : "910GBRKWOOD"
  },
  {
    "commonName" : "Broxbourne",
    "icsCode" : "1000583",
    "lat" : 51.74691,
    "lon" : -0.011087,
    "naptanId" : "910GBROXBRN"
  },
  {
    "commonName" : "Bruce Grove",
    "icsCode" : "1001040",
    "lat" : 51.593959,
    "lon" : -0.069867,
    "naptanId" : "910GBRUCGRV"
  },
  {
    "commonName" : "Burnham (Berks)",
    "icsCode" : "1000860",
    "lat" : 51.523506,
    "lon" : -0.646374,
    "naptanId" : "910GBNHAM"
  },
  {
    "commonName" : "Bush Hill Park",
    "icsCode" : "1001042",
    "lat" : 51.641519,
    "lon" : -0.069221,
    "naptanId" : "910GBHILLPK"
  },
  {
    "commonName" : "Bushey",
    "icsCode" : "1001041",
    "lat" : 51.645582,
    "lon" : -0.384749,
    "naptanId" : "910GBUSHEY"
  },
  {
    "commonName" : "Byfleet & New Haw",
    "icsCode" : "90001189",
    "lat" : 51.349797,
    "lon" : -0.48139,
    "naptanId" : "910GBYFLANH"
  },
  {
    "commonName" : "Caledonian Road & Barnsbury",
    "icsCode" : "1001043",
    "lat" : 51.543041,
    "lon" : -0.116729,
    "naptanId" : "910GCLDNNRB"
  },
  {
    "commonName" : "Camberley",
    "icsCode" : "1001361",
    "lat" : 51.336328,
    "lon" : -0.744272,
    "naptanId" : "910GCMBLEY"
  },
  {
    "commonName" : "Cambridge Heath (London)",
    "icsCode" : "1001044",
    "lat" : 51.531973,
    "lon" : -0.057279,
    "naptanId" : "910GCAMHTH"
  },
  {
    "commonName" : "Camden Road",
    "icsCode" : "1001045",
    "lat" : 51.541791,
    "lon" : -0.138701,
    "naptanId" : "910GCMDNRD"
  },
  {
    "commonName" : "Canada Water",
    "icsCode" : "1000037",
    "lat" : 51.49799,
    "lon" : -0.04972,
    "naptanId" : "910GCNDAW"
  },
  {
    "commonName" : "Canary Wharf",
    "icsCode" : "1002163",
    "lat" : 51.506098,
    "lon" : -0.020121,
    "naptanId" : "910GCANWHRF"
  },
  {
    "commonName" : "Canonbury",
    "icsCode" : "1001048",
    "lat" : 51.548732,
    "lon" : -0.092191,
    "naptanId" : "910GCNNB"
  },
  {
    "commonName" : "Carpenders Park",
    "icsCode" : "1001049",
    "lat" : 51.628351,
    "lon" : -0.385939,
    "naptanId" : "910GCRPNDPK"
  },
  {
    "commonName" : "Carshalton",
    "icsCode" : "1001051",
    "lat" : 51.368454,
    "lon" : -0.166368,
    "naptanId" : "910GCRSHLTN"
  },
  {
    "commonName" : "Carshalton Beeches",
    "icsCode" : "1001050",
    "lat" : 51.357411,
    "lon" : -0.169797,
    "naptanId" : "910GCRSHLTB"
  },
  {
    "commonName" : "Castle Bar Park",
    "icsCode" : "1001052",
    "lat" : 51.522931,
    "lon" : -0.331549,
    "naptanId" : "910GCBARPAR"
  },
  {
    "commonName" : "Caterham",
    "icsCode" : "1001539",
    "lat" : 51.282141,
    "lon" : -0.078307,
    "naptanId" : "910GCATERHM"
  },
  {
    "commonName" : "Catford",
    "icsCode" : "1001053",
    "lat" : 51.444407,
    "lon" : -0.026317,
    "naptanId" : "910GCATFORD"
  },
  {
    "commonName" : "Catford Bridge",
    "icsCode" : "1001054",
    "lat" : 51.444741,
    "lon" : -0.024791,
    "naptanId" : "910GCATFBDG"
  },
  {
    "commonName" : "Chadwell Heath",
    "icsCode" : "1001055",
    "lat" : 51.568039,
    "lon" : 0.128958,
    "naptanId" : "910GCHDWLHT"
  },
  {
    "commonName" : "Chafford Hundred",
    "icsCode" : "1000729",
    "lat" : 51.485557,
    "lon" : 0.287447,
    "naptanId" : "910GCHADHDD"
  },
  {
    "commonName" : "Chalfont & Latimer",
    "icsCode" : "1000042",
    "lat" : 51.668108,
    "lon" : -0.560526,
    "naptanId" : "910GCHLFNAL"
  },
  {
    "commonName" : "Charlton",
    "icsCode" : "1001058",
    "lat" : 51.486813,
    "lon" : 0.031258,
    "naptanId" : "910GCRLN"
  },
  {
    "commonName" : "Chatham",
    "icsCode" : "90001362",
    "lat" : 51.380379,
    "lon" : 0.521151,
    "naptanId" : "910GCHATHAM"
  },
  {
    "commonName" : "Cheam",
    "icsCode" : "1001059",
    "lat" : 51.355479,
    "lon" : -0.214167,
    "naptanId" : "910GCHEAM"
  },
  {
    "commonName" : "Chelmsford",
    "icsCode" : "1000591",
    "lat" : 51.736373,
    "lon" : 0.468572,
    "naptanId" : "910GCHLMSFD"
  },
  {
    "commonName" : "Chelsfield",
    "icsCode" : "1001060",
    "lat" : 51.356256,
    "lon" : 0.10907,
    "naptanId" : "910GCHLSFLD"
  },
  {
    "commonName" : "Chertsey",
    "icsCode" : "1001526",
    "lat" : 51.387069,
    "lon" : -0.509317,
    "naptanId" : "910GCHTSEY"
  },
  {
    "commonName" : "Cheshunt",
    "icsCode" : "1001532",
    "lat" : 51.702876,
    "lon" : -0.02396,
    "naptanId" : "910GCHESHNT"
  },
  {
    "commonName" : "Chessington North",
    "icsCode" : "1001061",
    "lat" : 51.364041,
    "lon" : -0.300699,
    "naptanId" : "910GCHSSN"
  },
  {
    "commonName" : "Chessington South",
    "icsCode" : "1001062",
    "lat" : 51.35655,
    "lon" : -0.308157,
    "naptanId" : "910GCHSSS"
  },
  {
    "commonName" : "Chilworth",
    "icsCode" : "1001364",
    "lat" : 51.215213,
    "lon" : -0.524824,
    "naptanId" : "910GCHLWTH"
  },
  {
    "commonName" : "Chingford",
    "icsCode" : "1001063",
    "lat" : 51.633087,
    "lon" : 0.009897,
    "naptanId" : "910GCHINGFD"
  },
  {
    "commonName" : "Chipstead",
    "icsCode" : "1001557",
    "lat" : 51.309277,
    "lon" : -0.169503,
    "naptanId" : "910GCHSD"
  },
  {
    "commonName" : "Chislehurst",
    "icsCode" : "1001064",
    "lat" : 51.405557,
    "lon" : 0.057418,
    "naptanId" : "910GCHSLHRS"
  },
  {
    "commonName" : "Chiswick",
    "icsCode" : "1001065",
    "lat" : 51.481137,
    "lon" : -0.267835,
    "naptanId" : "910GCHISWCK"
  },
  {
    "commonName" : "Chorleywood",
    "icsCode" : "1000049",
    "lat" : 51.654249,
    "lon" : -0.51832,
    "naptanId" : "910GCHRW"
  },
  {
    "commonName" : "City Thameslink",
    "icsCode" : "1001067",
    "lat" : 51.513936,
    "lon" : -0.10359,
    "naptanId" : "910GCTMSLNK"
  },
  {
    "commonName" : "Clandon",
    "icsCode" : "1001577",
    "lat" : 51.264005,
    "lon" : -0.502766,
    "naptanId" : "910GCLANDON"
  },
  {
    "commonName" : "Clapham High Street",
    "icsCode" : "1001068",
    "lat" : 51.465481,
    "lon" : -0.132522,
    "naptanId" : "910GCLPHHS"
  },
  {
    "commonName" : "Clapham Junction",
    "icsCode" : "1001069",
    "lat" : 51.464187,
    "lon" : -0.170221,
    "naptanId" : "910GCLPHMJ1"
  },
  {
    "commonName" : "Clapton",
    "icsCode" : "1001070",
    "lat" : 51.561644,
    "lon" : -0.057025,
    "naptanId" : "910GCLAPTON"
  },
  {
    "commonName" : "Claygate",
    "icsCode" : "1001517",
    "lat" : 51.361214,
    "lon" : -0.348248,
    "naptanId" : "910GCLYGATE"
  },
  {
    "commonName" : "Clock House",
    "icsCode" : "1001071",
    "lat" : 51.408586,
    "lon" : -0.040657,
    "naptanId" : "910GCLOCKHS"
  },
  {
    "commonName" : "Cobham & Stoke d'Abernon",
    "icsCode" : "1001515",
    "lat" : 51.318101,
    "lon" : -0.389346,
    "naptanId" : "910GCBHMSDA"
  },
  {
    "commonName" : "Cookham",
    "icsCode" : "1000863",
    "lat" : 51.557463,
    "lon" : -0.722079,
    "naptanId" : "910GCOOKHAM"
  },
  {
    "commonName" : "Coulsdon South",
    "icsCode" : "1001072",
    "lat" : 51.315838,
    "lon" : -0.137887,
    "naptanId" : "910GCOLSDNS"
  },
  {
    "commonName" : "Coulsdon Town",
    "icsCode" : "1001253",
    "lat" : 51.322043,
    "lon" : -0.134464,
    "naptanId" : "910GCOLSTWN"
  },
  {
    "commonName" : "Cowden",
    "icsCode" : "1001588",
    "lat" : 51.155637,
    "lon" : 0.110033,
    "naptanId" : "910GCOWDEN"
  },
  {
    "commonName" : "Crawley",
    "icsCode" : "1001590",
    "lat" : 51.112214,
    "lon" : -0.186673,
    "naptanId" : "910GCRAWLEY"
  },
  {
    "commonName" : "Crayford",
    "icsCode" : "1001073",
    "lat" : 51.44828,
    "lon" : 0.178936,
    "naptanId" : "910GCRFD"
  },
  {
    "commonName" : "Crews Hill",
    "icsCode" : "1001074",
    "lat" : 51.684486,
    "lon" : -0.106887,
    "naptanId" : "910GCRHL"
  },
  {
    "commonName" : "Cricklewood",
    "icsCode" : "1001075",
    "lat" : 51.558453,
    "lon" : -0.212677,
    "naptanId" : "910GCRKLWD"
  },
  {
    "commonName" : "Crofton Park",
    "icsCode" : "1001076",
    "lat" : 51.455189,
    "lon" : -0.036503,
    "naptanId" : "910GCFPK"
  },
  {
    "commonName" : "Crouch Hill",
    "icsCode" : "1001077",
    "lat" : 51.571302,
    "lon" : -0.117149,
    "naptanId" : "910GCROUCHH"
  },
  {
    "commonName" : "Crystal Palace",
    "icsCode" : "1001078",
    "lat" : 51.418109,
    "lon" : -0.07261,
    "naptanId" : "910GCRYSTLP"
  },
  {
    "commonName" : "Cuffley",
    "icsCode" : "1001504",
    "lat" : 51.708722,
    "lon" : -0.109783,
    "naptanId" : "910GCUFFLEY"
  },
  {
    "commonName" : "Custom House",
    "icsCode" : "1001079",
    "lat" : 51.509436,
    "lon" : 0.027681,
    "naptanId" : "910GCSTMHSXR"
  },
  {
    "commonName" : "Cuxton",
    "icsCode" : "90001992",
    "lat" : 51.373927,
    "lon" : 0.461709,
    "naptanId" : "910GCXTN"
  },
  {
    "commonName" : "Dagenham Dock",
    "icsCode" : "1001080",
    "lat" : 51.526156,
    "lon" : 0.145904,
    "naptanId" : "910GDGNHMDC"
  },
  {
    "commonName" : "Dalston Junction",
    "icsCode" : "1001568",
    "lat" : 51.546116,
    "lon" : -0.075137,
    "naptanId" : "910GDALS"
  },
  {
    "commonName" : "Dalston Kingsland",
    "icsCode" : "1001081",
    "lat" : 51.548148,
    "lon" : -0.075701,
    "naptanId" : "910GDALSKLD"
  },
  {
    "commonName" : "Dartford",
    "icsCode" : "1001082",
    "lat" : 51.447371,
    "lon" : 0.219248,
    "naptanId" : "910GDARTFD"
  },
  {
    "commonName" : "Datchet",
    "icsCode" : "1001350",
    "lat" : 51.483077,
    "lon" : -0.579422,
    "naptanId" : "910GDATCHET"
  },
  {
    "commonName" : "Denham",
    "icsCode" : "1001505",
    "lat" : 51.578837,
    "lon" : -0.497437,
    "naptanId" : "910GDENHAM"
  },
  {
    "commonName" : "Denham Golf Club",
    "icsCode" : "1001506",
    "lat" : 51.580598,
    "lon" : -0.517787,
    "naptanId" : "910GDENHMGC"
  },
  {
    "commonName" : "Denmark Hill",
    "icsCode" : "1001083",
    "lat" : 51.468203,
    "lon" : -0.089361,
    "naptanId" : "910GDENMRKH"
  },
  {
    "commonName" : "Deptford",
    "icsCode" : "1001084",
    "lat" : 51.478848,
    "lon" : -0.02627,
    "naptanId" : "910GDEPTFD"
  },
  {
    "commonName" : "Dorking",
    "icsCode" : "1001507",
    "lat" : 51.24093,
    "lon" : -0.324251,
    "naptanId" : "910GDORKING"
  },
  {
    "commonName" : "Dorking Deepdene",
    "icsCode" : "1001372",
    "lat" : 51.238804,
    "lon" : -0.324643,
    "naptanId" : "910GDEPDENE"
  },
  {
    "commonName" : "Dorking West",
    "icsCode" : "1001375",
    "lat" : 51.236226,
    "lon" : -0.339978,
    "naptanId" : "910GDRKGW"
  },
  {
    "commonName" : "Dormans",
    "icsCode" : "90002279",
    "lat" : 51.155792,
    "lon" : -0.004308,
    "naptanId" : "910GDORMANS"
  },
  {
    "commonName" : "Drayton Green",
    "icsCode" : "1001085",
    "lat" : 51.516617,
    "lon" : -0.330194,
    "naptanId" : "910GDRAYGRN"
  },
  {
    "commonName" : "Drayton Park",
    "icsCode" : "1001086",
    "lat" : 51.55277,
    "lon" : -0.105509,
    "naptanId" : "910GDRYP"
  },
  {
    "commonName" : "Dunton Green",
    "icsCode" : "1002470",
    "lat" : 51.29649,
    "lon" : 0.170937,
    "naptanId" : "910GDTNG"
  },
  {
    "commonName" : "Ealing Broadway",
    "icsCode" : "1000062",
    "lat" : 51.514841,
    "lon" : -0.301752,
    "naptanId" : "910GEALINGB"
  },
  {
    "commonName" : "Earlsfield",
    "icsCode" : "1001088",
    "lat" : 51.442337,
    "lon" : -0.187715,
    "naptanId" : "910GERLFLD"
  },
  {
    "commonName" : "Earlswood (Surrey)",
    "icsCode" : "90002418",
    "lat" : 51.227328,
    "lon" : -0.170823,
    "naptanId" : "910GEARLSWD"
  },
  {
    "commonName" : "East Croydon",
    "icsCode" : "1001089",
    "lat" : 51.375454,
    "lon" : -0.09278,
    "naptanId" : "910GECROYDN"
  },
  {
    "commonName" : "East Dulwich",
    "icsCode" : "1001090",
    "lat" : 51.461494,
    "lon" : -0.080572,
    "naptanId" : "910GEDULWCH"
  },
  {
    "commonName" : "East Grinstead",
    "icsCode" : "90002488",
    "lat" : 51.126274,
    "lon" : -0.0179,
    "naptanId" : "910GEGRNSTD"
  },
  {
    "commonName" : "East Malling",
    "icsCode" : "90002569",
    "lat" : 51.28581,
    "lon" : 0.43928,
    "naptanId" : "910GEMALING"
  },
  {
    "commonName" : "East Tilbury",
    "icsCode" : "1000733",
    "lat" : 51.484831,
    "lon" : 0.412928,
    "naptanId" : "910GETILBRY"
  },
  {
    "commonName" : "Ebbsfleet International",
    "icsCode" : "1001903",
    "lat" : 51.442973,
    "lon" : 0.320921,
    "naptanId" : "910GEBSFDOM"
  },
  {
    "commonName" : "Eden Park",
    "icsCode" : "1001091",
    "lat" : 51.390091,
    "lon" : -0.026355,
    "naptanId" : "910GEDPK"
  },
  {
    "commonName" : "Edenbridge",
    "icsCode" : "90002463",
    "lat" : 51.208436,
    "lon" : 0.060646,
    "naptanId" : "910GEDNB"
  },
  {
    "commonName" : "Edenbridge Town",
    "icsCode" : "90002464",
    "lat" : 51.200083,
    "lon" : 0.067173,
    "naptanId" : "910GEDNT"
  },
  {
    "commonName" : "Edmonton Green",
    "icsCode" : "1001092",
    "lat" : 51.624929,
    "lon" : -0.061112,
    "naptanId" : "910GEDMNGRN"
  },
  {
    "commonName" : "Effingham Junction",
    "icsCode" : "1001512",
    "lat" : 51.291495,
    "lon" : -0.419965,
    "naptanId" : "910GEFNGHMJ"
  },
  {
    "commonName" : "Egham",
    "icsCode" : "1001502",
    "lat" : 51.429647,
    "lon" : -0.546512,
    "naptanId" : "910GEGHAM"
  },
  {
    "commonName" : "Elephant & Castle",
    "icsCode" : "1000326",
    "lat" : 51.494029,
    "lon" : -0.098725,
    "naptanId" : "910GELPHNAC"
  },
  {
    "commonName" : "Elmers End",
    "icsCode" : "1001094",
    "lat" : 51.398492,
    "lon" : -0.04957,
    "naptanId" : "910GELMERSE"
  },
  {
    "commonName" : "Elmstead Woods",
    "icsCode" : "1001095",
    "lat" : 51.417118,
    "lon" : 0.044274,
    "naptanId" : "910GELMW"
  },
  {
    "commonName" : "Elstree & Borehamwood",
    "icsCode" : "1001096",
    "lat" : 51.653069,
    "lon" : -0.280081,
    "naptanId" : "910GELTR"
  },
  {
    "commonName" : "Eltham",
    "icsCode" : "1001097",
    "lat" : 51.455644,
    "lon" : 0.052472,
    "naptanId" : "910GELTHAM"
  },
  {
    "commonName" : "Emerson Park",
    "icsCode" : "1001098",
    "lat" : 51.568642,
    "lon" : 0.220113,
    "naptanId" : "910GEMRSPKH"
  },
  {
    "commonName" : "Enfield Chase",
    "icsCode" : "1001099",
    "lat" : 51.653254,
    "lon" : -0.090696,
    "naptanId" : "910GENFC"
  },
  {
    "commonName" : "Enfield Lock",
    "icsCode" : "1001100",
    "lat" : 51.670922,
    "lon" : -0.028532,
    "naptanId" : "910GENFLDLK"
  },
  {
    "commonName" : "Enfield Town",
    "icsCode" : "1001101",
    "lat" : 51.652026,
    "lon" : -0.079328,
    "naptanId" : "910GENFLDTN"
  },
  {
    "commonName" : "Epsom",
    "icsCode" : "1001545",
    "lat" : 51.334393,
    "lon" : -0.268778,
    "naptanId" : "910GEPSM"
  },
  {
    "commonName" : "Epsom Downs",
    "icsCode" : "1001553",
    "lat" : 51.323688,
    "lon" : -0.238955,
    "naptanId" : "910GEPSDNS"
  },
  {
    "commonName" : "Erith",
    "icsCode" : "1001102",
    "lat" : 51.481671,
    "lon" : 0.175055,
    "naptanId" : "910GERITH"
  },
  {
    "commonName" : "Esher",
    "icsCode" : "1001519",
    "lat" : 51.379891,
    "lon" : -0.353338,
    "naptanId" : "910GESHER"
  },
  {
    "commonName" : "Essex Road",
    "icsCode" : "1001103",
    "lat" : 51.540705,
    "lon" : -0.096276,
    "naptanId" : "910GESSEXRD"
  },
  {
    "commonName" : "Ewell East",
    "icsCode" : "1001534",
    "lat" : 51.3453,
    "lon" : -0.24153,
    "naptanId" : "910GEWELLE"
  },
  {
    "commonName" : "Ewell West",
    "icsCode" : "1001535",
    "lat" : 51.350045,
    "lon" : -0.256987,
    "naptanId" : "910GEWELW"
  },
  {
    "commonName" : "Eynsford",
    "icsCode" : "1002251",
    "lat" : 51.36272,
    "lon" : 0.204393,
    "naptanId" : "910GEYNSFD"
  },
  {
    "commonName" : "Falconwood",
    "icsCode" : "1001105",
    "lat" : 51.459154,
    "lon" : 0.079305,
    "naptanId" : "910GFALCNWD"
  },
  {
    "commonName" : "Farnborough North",
    "icsCode" : "90002820",
    "lat" : 51.302045,
    "lon" : -0.743027,
    "naptanId" : "910GFRBRNTH"
  },
  {
    "commonName" : "Farncombe",
    "icsCode" : "1001381",
    "lat" : 51.197154,
    "lon" : -0.604549,
    "naptanId" : "910GFRNCMB"
  },
  {
    "commonName" : "Farningham Road",
    "icsCode" : "1001389",
    "lat" : 51.401666,
    "lon" : 0.235452,
    "naptanId" : "910GFRNNGRD"
  },
  {
    "commonName" : "Farringdon",
    "icsCode" : "1000080",
    "lat" : 51.51969,
    "lon" : -0.10459,
    "naptanId" : "910GFRNDXR"
  },
  {
    "commonName" : "Faygate",
    "icsCode" : "1001610",
    "lat" : 51.095891,
    "lon" : -0.263019,
    "naptanId" : "910GFAYGATE"
  },
  {
    "commonName" : "Feltham",
    "icsCode" : "1001107",
    "lat" : 51.447898,
    "lon" : -0.409838,
    "naptanId" : "910GFELTHAM"
  },
  {
    "commonName" : "Finchley Road & Frognal",
    "icsCode" : "1001109",
    "lat" : 51.550266,
    "lon" : -0.183141,
    "naptanId" : "910GFNCHLYR"
  },
  {
    "commonName" : "Finsbury Park",
    "icsCode" : "1000334",
    "lat" : 51.564302,
    "lon" : -0.106285,
    "naptanId" : "910GFNPK"
  },
  {
    "commonName" : "Forest Gate",
    "icsCode" : "1001111",
    "lat" : 51.549432,
    "lon" : 0.024353,
    "naptanId" : "910GFRSTGT"
  },
  {
    "commonName" : "Forest Hill",
    "icsCode" : "1001112",
    "lat" : 51.43928,
    "lon" : -0.053157,
    "naptanId" : "910GFORESTH"
  },
  {
    "commonName" : "Frimley",
    "icsCode" : "90002831",
    "lat" : 51.311862,
    "lon" : -0.746991,
    "naptanId" : "910GFRIMLEY"
  },
  {
    "commonName" : "Fulwell",
    "icsCode" : "1001113",
    "lat" : 51.433935,
    "lon" : -0.349468,
    "naptanId" : "910GFULWELL"
  },
  {
    "commonName" : "Furze Platt",
    "icsCode" : "1001403",
    "lat" : 51.53302,
    "lon" : -0.728473,
    "naptanId" : "910GFURZEP"
  },
  {
    "commonName" : "Garston (Herts)",
    "icsCode" : "1000772",
    "lat" : 51.686616,
    "lon" : -0.381741,
    "naptanId" : "910GGRSTH"
  },
  {
    "commonName" : "Gatwick Airport",
    "icsCode" : "90003213",
    "lat" : 51.156491,
    "lon" : -0.161041,
    "naptanId" : "910GGTWK"
  },
  {
    "commonName" : "Gerrards Cross",
    "icsCode" : "1000561",
    "lat" : 51.589023,
    "lon" : -0.555275,
    "naptanId" : "910GGERRDSX"
  },
  {
    "commonName" : "Gidea Park",
    "icsCode" : "1001115",
    "lat" : 51.581904,
    "lon" : 0.205964,
    "naptanId" : "910GGIDEAPK"
  },
  {
    "commonName" : "Gillingham (Kent)",
    "icsCode" : "90002999",
    "lat" : 51.386565,
    "lon" : 0.54985,
    "naptanId" : "910GGLNGHMK"
  },
  {
    "commonName" : "Gipsy Hill",
    "icsCode" : "1001116",
    "lat" : 51.424453,
    "lon" : -0.083836,
    "naptanId" : "910GGIPSYH"
  },
  {
    "commonName" : "Godstone",
    "icsCode" : "90003051",
    "lat" : 51.218157,
    "lon" : -0.050085,
    "naptanId" : "910GGODSTON"
  },
  {
    "commonName" : "Gomshall",
    "icsCode" : "1001412",
    "lat" : 51.219399,
    "lon" : -0.441852,
    "naptanId" : "910GGOMSHAL"
  },
  {
    "commonName" : "Goodmayes",
    "icsCode" : "1001117",
    "lat" : 51.565579,
    "lon" : 0.110807,
    "naptanId" : "910GGODMAYS"
  },
  {
    "commonName" : "Gordon Hill",
    "icsCode" : "1001118",
    "lat" : 51.664113,
    "lon" : -0.094997,
    "naptanId" : "910GGORDONH"
  },
  {
    "commonName" : "Gospel Oak",
    "icsCode" : "1001119",
    "lat" : 51.555335,
    "lon" : -0.15077,
    "naptanId" : "910GGOSPLOK"
  },
  {
    "commonName" : "Grange Park",
    "icsCode" : "1001120",
    "lat" : 51.642607,
    "lon" : -0.097358,
    "naptanId" : "910GGRPK"
  },
  {
    "commonName" : "Gravesend",
    "icsCode" : "1001540",
    "lat" : 51.441348,
    "lon" : 0.366643,
    "naptanId" : "910GGRVSEND"
  },
  {
    "commonName" : "Grays",
    "icsCode" : "1001563",
    "lat" : 51.476248,
    "lon" : 0.321832,
    "naptanId" : "910GGRAYS"
  },
  {
    "commonName" : "Great Missenden",
    "icsCode" : "1001121",
    "lat" : 51.703519,
    "lon" : -0.709141,
    "naptanId" : "910GGTMSNDN"
  },
  {
    "commonName" : "Greenford",
    "icsCode" : "1000092",
    "lat" : 51.542331,
    "lon" : -0.345837,
    "naptanId" : "910GGFORD"
  },
  {
    "commonName" : "Greenhithe for Bluewater",
    "icsCode" : "1001543",
    "lat" : 51.450372,
    "lon" : 0.28029,
    "naptanId" : "910GGNHT"
  },
  {
    "commonName" : "Greenwich",
    "icsCode" : "1001123",
    "lat" : 51.478135,
    "lon" : -0.01334,
    "naptanId" : "910GGNWH"
  },
  {
    "commonName" : "Grove Park",
    "icsCode" : "1001124",
    "lat" : 51.430863,
    "lon" : 0.021726,
    "naptanId" : "910GGRVPK"
  },
  {
    "commonName" : "Guildford",
    "icsCode" : "1001424",
    "lat" : 51.23697,
    "lon" : -0.580425,
    "naptanId" : "910GGUILDFD"
  },
  {
    "commonName" : "Gunnersbury",
    "icsCode" : "1000094",
    "lat" : 51.491678,
    "lon" : -0.275286,
    "naptanId" : "910GGNRSBRY"
  },
  {
    "commonName" : "Hackbridge",
    "icsCode" : "1001126",
    "lat" : 51.377872,
    "lon" : -0.153907,
    "naptanId" : "910GHKBG"
  },
  {
    "commonName" : "Hackney Central",
    "icsCode" : "1001127",
    "lat" : 51.547105,
    "lon" : -0.056058,
    "naptanId" : "910GHACKNYC"
  },
  {
    "commonName" : "Hackney Downs",
    "icsCode" : "1001128",
    "lat" : 51.548757,
    "lon" : -0.060819,
    "naptanId" : "910GHAKNYNM"
  },
  {
    "commonName" : "Hackney Wick",
    "icsCode" : "1001129",
    "lat" : 51.54341,
    "lon" : -0.02492,
    "naptanId" : "910GHACKNYW"
  },
  {
    "commonName" : "Hadley Wood",
    "icsCode" : "1001130",
    "lat" : 51.668497,
    "lon" : -0.176172,
    "naptanId" : "910GHADLYWD"
  },
  {
    "commonName" : "Haggerston",
    "icsCode" : "1001569",
    "lat" : 51.538705,
    "lon" : -0.075666,
    "naptanId" : "910GHAGGERS"
  },
  {
    "commonName" : "Halling",
    "icsCode" : "90003258",
    "lat" : 51.352478,
    "lon" : 0.444932,
    "naptanId" : "910GHALG"
  },
  {
    "commonName" : "Hampstead Heath",
    "icsCode" : "1001131",
    "lat" : 51.55521,
    "lon" : -0.165705,
    "naptanId" : "910GHMPSTDH"
  },
  {
    "commonName" : "Hampton (London)",
    "icsCode" : "1001132",
    "lat" : 51.415934,
    "lon" : -0.372119,
    "naptanId" : "910GHAMPTON"
  },
  {
    "commonName" : "Hampton Court",
    "icsCode" : "1001133",
    "lat" : 51.402556,
    "lon" : -0.342748,
    "naptanId" : "910GHCRT"
  },
  {
    "commonName" : "Hampton Wick",
    "icsCode" : "1001134",
    "lat" : 51.414524,
    "lon" : -0.312489,
    "naptanId" : "910GHAMWICK"
  },
  {
    "commonName" : "Hanwell",
    "icsCode" : "1001135",
    "lat" : 51.511835,
    "lon" : -0.338583,
    "naptanId" : "910GHANWELL"
  },
  {
    "commonName" : "Harlesden",
    "icsCode" : "1000100",
    "lat" : 51.536289,
    "lon" : -0.257667,
    "naptanId" : "910GHARLSDN"
  },
  {
    "commonName" : "Harlow Mill",
    "icsCode" : "90003662",
    "lat" : 51.790365,
    "lon" : 0.132308,
    "naptanId" : "910GHRLWMIL"
  },
  {
    "commonName" : "Harlow Town",
    "icsCode" : "90003664",
    "lat" : 51.78107,
    "lon" : 0.095132,
    "naptanId" : "910GHRLWTWN"
  },
  {
    "commonName" : "Harold Wood",
    "icsCode" : "1001137",
    "lat" : 51.592766,
    "lon" : 0.233129,
    "naptanId" : "910GHRLDWOD"
  },
  {
    "commonName" : "Harpenden",
    "icsCode" : "1000480",
    "lat" : 51.814645,
    "lon" : -0.35148,
    "naptanId" : "910GHRPNDN"
  },
  {
    "commonName" : "Harringay",
    "icsCode" : "1001138",
    "lat" : 51.577358,
    "lon" : -0.105136,
    "naptanId" : "910GHRGY"
  },
  {
    "commonName" : "Harringay Green Lanes",
    "icsCode" : "1001139",
    "lat" : 51.577182,
    "lon" : -0.098144,
    "naptanId" : "910GHRGYGL"
  },
  {
    "commonName" : "Harrow & Wealdstone",
    "icsCode" : "1000101",
    "lat" : 51.592169,
    "lon" : -0.334571,
    "naptanId" : "910GHROW"
  },
  {
    "commonName" : "Harrow-on-the-Hill",
    "icsCode" : "1000102",
    "lat" : 51.579186,
    "lon" : -0.337225,
    "naptanId" : "910GHAROOTH"
  },
  {
    "commonName" : "Hatch End",
    "icsCode" : "1001142",
    "lat" : 51.609417,
    "lon" : -0.368601,
    "naptanId" : "910GHTCHEND"
  },
  {
    "commonName" : "Hatfield (Herts)",
    "icsCode" : "1026129",
    "lat" : 51.763879,
    "lon" : -0.215589,
    "naptanId" : "910GHATFILD"
  },
  {
    "commonName" : "Haydons Road",
    "icsCode" : "1001143",
    "lat" : 51.425448,
    "lon" : -0.188815,
    "naptanId" : "910GHYDNSRD"
  },
  {
    "commonName" : "Hayes & Harlington",
    "icsCode" : "1001144",
    "lat" : 51.503096,
    "lon" : -0.420683,
    "naptanId" : "910GHAYESAH"
  },
  {
    "commonName" : "Hayes (Kent)",
    "icsCode" : "1001145",
    "lat" : 51.376334,
    "lon" : 0.010557,
    "naptanId" : "910GHAYS"
  },
  {
    "commonName" : "Headstone Lane",
    "icsCode" : "1001146",
    "lat" : 51.602649,
    "lon" : -0.35722,
    "naptanId" : "910GHEDSTNL"
  },
  {
    "commonName" : "Heathrow Central Bus Stn (Rail-Air)",
    "icsCode" : "1008016",
    "lat" : 51.471095,
    "lon" : -0.453306,
    "naptanId" : "910GHTRWCBS"
  },
  {
    "commonName" : "Heathrow Terminal 4",
    "icsCode" : "1000104",
    "lat" : 51.458268,
    "lon" : -0.445463,
    "naptanId" : "910GHTRWTM4"
  },
  {
    "commonName" : "Heathrow Terminal 5",
    "icsCode" : "1016430",
    "lat" : 51.470053,
    "lon" : -0.490589,
    "naptanId" : "910GHTRWTM5"
  },
  {
    "commonName" : "Heathrow Terminals 2 & 3",
    "icsCode" : "1001147",
    "lat" : 51.470976,
    "lon" : -0.458033,
    "naptanId" : "910GHTRWAPT"
  },
  {
    "commonName" : "Hemel Hempstead",
    "icsCode" : "1000812",
    "lat" : 51.742333,
    "lon" : -0.490774,
    "naptanId" : "910GHEMLHMP"
  },
  {
    "commonName" : "Hendon",
    "icsCode" : "1001148",
    "lat" : 51.580068,
    "lon" : -0.238674,
    "naptanId" : "910GHDON"
  },
  {
    "commonName" : "Herne Hill",
    "icsCode" : "1001149",
    "lat" : 51.453305,
    "lon" : -0.102289,
    "naptanId" : "910GHERNEH"
  },
  {
    "commonName" : "Hersham",
    "icsCode" : "1001520",
    "lat" : 51.376812,
    "lon" : -0.389959,
    "naptanId" : "910GHERSHAM"
  },
  {
    "commonName" : "Hertford East",
    "icsCode" : "1026133",
    "lat" : 51.799035,
    "lon" : -0.072941,
    "naptanId" : "910GHERTFDE"
  },
  {
    "commonName" : "Hertford North",
    "icsCode" : "1026132",
    "lat" : 51.798857,
    "lon" : -0.091788,
    "naptanId" : "910GHFDN"
  },
  {
    "commonName" : "Hever",
    "icsCode" : "90003422",
    "lat" : 51.181411,
    "lon" : 0.095069,
    "naptanId" : "910GHEVER"
  },
  {
    "commonName" : "High Brooms",
    "icsCode" : "90003358",
    "lat" : 51.149405,
    "lon" : 0.277332,
    "naptanId" : "910GHBROOMS"
  },
  {
    "commonName" : "High Wycombe",
    "icsCode" : "1000553",
    "lat" : 51.629586,
    "lon" : -0.74541,
    "naptanId" : "910GHWYCOMB"
  },
  {
    "commonName" : "Higham",
    "icsCode" : "90003447",
    "lat" : 51.426559,
    "lon" : 0.466278,
    "naptanId" : "910GHIGM"
  },
  {
    "commonName" : "Highams Park",
    "icsCode" : "1001150",
    "lat" : 51.60835,
    "lon" : -0.000222,
    "naptanId" : "910GHGHMSPK"
  },
  {
    "commonName" : "Highbury & Islington",
    "icsCode" : "1000108",
    "lat" : 51.546177,
    "lon" : -0.103764,
    "naptanId" : "910GHGHI"
  },
  {
    "commonName" : "Hildenborough",
    "icsCode" : "90003482",
    "lat" : 51.214486,
    "lon" : 0.22759,
    "naptanId" : "910GHLDNBRO"
  },
  {
    "commonName" : "Hinchley Wood",
    "icsCode" : "1001518",
    "lat" : 51.374998,
    "lon" : -0.340524,
    "naptanId" : "910GHNCHLYW"
  },
  {
    "commonName" : "Hither Green",
    "icsCode" : "1001152",
    "lat" : 51.452025,
    "lon" : -0.000944,
    "naptanId" : "910GHTHRGRN"
  },
  {
    "commonName" : "Holmwood",
    "icsCode" : "90003489",
    "lat" : 51.181196,
    "lon" : -0.320809,
    "naptanId" : "910GHLMW"
  },
  {
    "commonName" : "Homerton",
    "icsCode" : "1001153",
    "lat" : 51.547012,
    "lon" : -0.04236,
    "naptanId" : "910GHOMRTON"
  },
  {
    "commonName" : "Honor Oak Park",
    "icsCode" : "1001154",
    "lat" : 51.449989,
    "lon" : -0.045505,
    "naptanId" : "910GHONROPK"
  },
  {
    "commonName" : "Horley",
    "icsCode" : "1001637",
    "lat" : 51.168775,
    "lon" : -0.161054,
    "naptanId" : "910GHORLEY"
  },
  {
    "commonName" : "Hornsey",
    "icsCode" : "1001155",
    "lat" : 51.586461,
    "lon" : -0.111975,
    "naptanId" : "910GHRNSY"
  },
  {
    "commonName" : "Horsley",
    "icsCode" : "1001513",
    "lat" : 51.279347,
    "lon" : -0.435409,
    "naptanId" : "910GHRSLEY"
  },
  {
    "commonName" : "Hounslow",
    "icsCode" : "1001156",
    "lat" : 51.461946,
    "lon" : -0.362277,
    "naptanId" : "910GHOUNSLW"
  },
  {
    "commonName" : "How Wood (Herts)",
    "icsCode" : "1000768",
    "lat" : 51.717742,
    "lon" : -0.34467,
    "naptanId" : "910GHOWWOOD"
  },
  {
    "commonName" : "Hoxton",
    "icsCode" : "1001570",
    "lat" : 51.531512,
    "lon" : -0.075681,
    "naptanId" : "910GHOXTON"
  },
  {
    "commonName" : "Hurst Green",
    "icsCode" : "1001643",
    "lat" : 51.244431,
    "lon" : 0.003939,
    "naptanId" : "910GHRSTGRN"
  },
  {
    "commonName" : "Ifield",
    "icsCode" : "1001648",
    "lat" : 51.115623,
    "lon" : -0.214772,
    "naptanId" : "910GIFIELD"
  },
  {
    "commonName" : "Ilford",
    "icsCode" : "1001157",
    "lat" : 51.559118,
    "lon" : 0.06968,
    "naptanId" : "910GILFORD"
  },
  {
    "commonName" : "Imperial Wharf",
    "icsCode" : "1001347",
    "lat" : 51.474949,
    "lon" : -0.182823,
    "naptanId" : "910GCSEAH"
  },
  {
    "commonName" : "Ingatestone",
    "icsCode" : "1000635",
    "lat" : 51.667043,
    "lon" : 0.384247,
    "naptanId" : "910GINGTSTN"
  },
  {
    "commonName" : "Isleworth",
    "icsCode" : "1001158",
    "lat" : 51.474763,
    "lon" : -0.336907,
    "naptanId" : "910GISLEWTH"
  },
  {
    "commonName" : "Iver",
    "icsCode" : "1000955",
    "lat" : 51.508503,
    "lon" : -0.506726,
    "naptanId" : "910GIVER"
  },
  {
    "commonName" : "Kempton Park",
    "icsCode" : "1001564",
    "lat" : 51.420983,
    "lon" : -0.409751,
    "naptanId" : "910GKMPTNPK"
  },
  {
    "commonName" : "Kemsing",
    "icsCode" : "90004003",
    "lat" : 51.297187,
    "lon" : 0.247428,
    "naptanId" : "910GKEMSING"
  },
  {
    "commonName" : "Kenley",
    "icsCode" : "1001159",
    "lat" : 51.324777,
    "lon" : -0.100925,
    "naptanId" : "910GKNLY"
  },
  {
    "commonName" : "Kensal Green",
    "icsCode" : "1000122",
    "lat" : 51.53054,
    "lon" : -0.225088,
    "naptanId" : "910GKENSLG"
  },
  {
    "commonName" : "Kensal Rise",
    "icsCode" : "1001161",
    "lat" : 51.534554,
    "lon" : -0.219957,
    "naptanId" : "910GKENR"
  },
  {
    "commonName" : "Kensington (Olympia)",
    "icsCode" : "1000170",
    "lat" : 51.497899,
    "lon" : -0.210364,
    "naptanId" : "910GKENOLYM"
  },
  {
    "commonName" : "Kent House",
    "icsCode" : "1001163",
    "lat" : 51.412215,
    "lon" : -0.045247,
    "naptanId" : "910GKENTHOS"
  },
  {
    "commonName" : "Kentish Town",
    "icsCode" : "1000123",
    "lat" : 51.550495,
    "lon" : -0.140365,
    "naptanId" : "910GKNTSHTN"
  },
  {
    "commonName" : "Kentish Town West",
    "icsCode" : "1001165",
    "lat" : 51.546548,
    "lon" : -0.146655,
    "naptanId" : "910GKNTSHTW"
  },
  {
    "commonName" : "Kenton",
    "icsCode" : "1000124",
    "lat" : 51.581802,
    "lon" : -0.316981,
    "naptanId" : "910GKTON"
  },
  {
    "commonName" : "Kew Bridge",
    "icsCode" : "1001167",
    "lat" : 51.489513,
    "lon" : -0.287108,
    "naptanId" : "910GKEWBDGE"
  },
  {
    "commonName" : "Kew Gardens",
    "icsCode" : "1000125",
    "lat" : 51.477073,
    "lon" : -0.285054,
    "naptanId" : "910GKEWGRDN"
  },
  {
    "commonName" : "Kidbrooke",
    "icsCode" : "1001169",
    "lat" : 51.462121,
    "lon" : 0.027498,
    "naptanId" : "910GKIDBROK"
  },
  {
    "commonName" : "Kilburn High Road",
    "icsCode" : "1001170",
    "lat" : 51.537277,
    "lon" : -0.192237,
    "naptanId" : "910GKLBRNHR"
  },
  {
    "commonName" : "Kings Langley",
    "icsCode" : "1000810",
    "lat" : 51.706356,
    "lon" : -0.438422,
    "naptanId" : "910GKLGL"
  },
  {
    "commonName" : "Kingston",
    "icsCode" : "1001173",
    "lat" : 51.412751,
    "lon" : -0.301166,
    "naptanId" : "910GKGSTON"
  },
  {
    "commonName" : "Kingswood",
    "icsCode" : "1001558",
    "lat" : 51.294725,
    "lon" : -0.211247,
    "naptanId" : "910GKGWD"
  },
  {
    "commonName" : "Knebworth",
    "icsCode" : "1000468",
    "lat" : 51.866855,
    "lon" : -0.187289,
    "naptanId" : "910GKNEBWTH"
  },
  {
    "commonName" : "Knockholt",
    "icsCode" : "1001174",
    "lat" : 51.34579,
    "lon" : 0.130847,
    "naptanId" : "910GKNCKHLT"
  },
  {
    "commonName" : "Ladywell",
    "icsCode" : "1001175",
    "lat" : 51.456244,
    "lon" : -0.019041,
    "naptanId" : "910GLDYW"
  },
  {
    "commonName" : "Laindon",
    "icsCode" : "1000737",
    "lat" : 51.567524,
    "lon" : 0.424289,
    "naptanId" : "910GLAINDON"
  },
  {
    "commonName" : "Langley (Berks)",
    "icsCode" : "1000957",
    "lat" : 51.508062,
    "lon" : -0.541756,
    "naptanId" : "910GLANGLEY"
  },
  {
    "commonName" : "Lea Bridge",
    "icsCode" : "1001349",
    "lat" : 51.566548,
    "lon" : -0.036673,
    "naptanId" : "910GLEABDGE"
  },
  {
    "commonName" : "Leagrave",
    "icsCode" : "90004300",
    "lat" : 51.905159,
    "lon" : -0.458503,
    "naptanId" : "910GLEAGRVE"
  },
  {
    "commonName" : "Leatherhead",
    "icsCode" : "1001510",
    "lat" : 51.298818,
    "lon" : -0.333232,
    "naptanId" : "910GLETHRHD"
  },
  {
    "commonName" : "Lee",
    "icsCode" : "1001176",
    "lat" : 51.449755,
    "lon" : 0.013493,
    "naptanId" : "910GLEEE"
  },
  {
    "commonName" : "Leigh (Kent)",
    "icsCode" : "1001658",
    "lat" : 51.193901,
    "lon" : 0.210495,
    "naptanId" : "910GLEIGHK"
  },
  {
    "commonName" : "Lewisham",
    "icsCode" : "1000332",
    "lat" : 51.465692,
    "lon" : -0.014024,
    "naptanId" : "910GLEWISHM"
  },
  {
    "commonName" : "Leyton Midland Road",
    "icsCode" : "1001178",
    "lat" : 51.569725,
    "lon" : -0.008051,
    "naptanId" : "910GLEYTNMR"
  },
  {
    "commonName" : "Leytonstone High Road",
    "icsCode" : "1001179",
    "lat" : 51.563554,
    "lon" : 0.008416,
    "naptanId" : "910GLYTNSHR"
  },
  {
    "commonName" : "Limehouse",
    "icsCode" : "1001180",
    "lat" : 51.512537,
    "lon" : -0.039803,
    "naptanId" : "910GLIMHSE"
  },
  {
    "commonName" : "Lingfield",
    "icsCode" : "90004408",
    "lat" : 51.176453,
    "lon" : -0.007165,
    "naptanId" : "910GLINGFLD"
  },
  {
    "commonName" : "Littlehaven",
    "icsCode" : "1001669",
    "lat" : 51.079751,
    "lon" : -0.30798,
    "naptanId" : "910GLHVN"
  },
  {
    "commonName" : "Liverpool Street",
    "icsCode" : "1000138",
    "lat" : 51.517066,
    "lon" : -0.08367,
    "naptanId" : "910GLIVSTLL"
  },
  {
    "commonName" : "London Blackfriars",
    "icsCode" : "1000023",
    "lat" : 51.51181,
    "lon" : -0.103332,
    "naptanId" : "910GBLFR"
  },
  {
    "commonName" : "London Bridge",
    "icsCode" : "1000139",
    "lat" : 51.505019,
    "lon" : -0.086092,
    "naptanId" : "910GLNDNBDC"
  },
  {
    "commonName" : "London Cannon Street",
    "icsCode" : "1000337",
    "lat" : 51.511382,
    "lon" : -0.090293,
    "naptanId" : "910GCANONST"
  },
  {
    "commonName" : "London Charing Cross",
    "icsCode" : "1000045",
    "lat" : 51.508027,
    "lon" : -0.124802,
    "naptanId" : "910GCHRX"
  },
  {
    "commonName" : "London Euston",
    "icsCode" : "1000077",
    "lat" : 51.528136,
    "lon" : -0.133924,
    "naptanId" : "910GEUSTON"
  },
  {
    "commonName" : "London Fenchurch Street",
    "icsCode" : "1001108",
    "lat" : 51.511646,
    "lon" : -0.078897,
    "naptanId" : "910GFENCHRS"
  },
  {
    "commonName" : "London Fields",
    "icsCode" : "1001183",
    "lat" : 51.541153,
    "lon" : -0.057753,
    "naptanId" : "910GLONFLDS"
  },
  {
    "commonName" : "London King's Cross",
    "icsCode" : "1001171",
    "lat" : 51.530883,
    "lon" : -0.122926,
    "naptanId" : "910GKNGX"
  },
  {
    "commonName" : "London Marylebone",
    "icsCode" : "1000145",
    "lat" : 51.522524,
    "lon" : -0.162911,
    "naptanId" : "910GMARYLBN"
  },
  {
    "commonName" : "London Paddington",
    "icsCode" : "1001221",
    "lat" : 51.515996,
    "lon" : -0.176174,
    "naptanId" : "910GPADTON"
  },
  {
    "commonName" : "London Road (Guildford)",
    "icsCode" : "90004580",
    "lat" : 51.24065,
    "lon" : -0.565069,
    "naptanId" : "910GLRDGFD"
  },
  {
    "commonName" : "London St Pancras International LL",
    "icsCode" : "1001276",
    "lat" : 51.532168,
    "lon" : -0.127343,
    "naptanId" : "910GSTPXBOX"
  },
  {
    "commonName" : "London Victoria",
    "icsCode" : "1000248",
    "lat" : 51.495257,
    "lon" : -0.144559,
    "naptanId" : "910GVICTRIC"
  },
  {
    "commonName" : "London Waterloo",
    "icsCode" : "1000254",
    "lat" : 51.503299,
    "lon" : -0.113109,
    "naptanId" : "910GWATRLMN"
  },
  {
    "commonName" : "London Waterloo East",
    "icsCode" : "1001313",
    "lat" : 51.504076,
    "lon" : -0.108898,
    "naptanId" : "910GWLOE"
  },
  {
    "commonName" : "Longcross",
    "icsCode" : "90004492",
    "lat" : 51.385173,
    "lon" : -0.59457,
    "naptanId" : "910GLNGCROS"
  },
  {
    "commonName" : "Longfield",
    "icsCode" : "1001483",
    "lat" : 51.396155,
    "lon" : 0.300364,
    "naptanId" : "910GLGFD"
  },
  {
    "commonName" : "Loughborough Junction",
    "icsCode" : "1001184",
    "lat" : 51.466298,
    "lon" : -0.102182,
    "naptanId" : "910GLBGHJN"
  },
  {
    "commonName" : "Lower Sydenham",
    "icsCode" : "1001185",
    "lat" : 51.424831,
    "lon" : -0.033345,
    "naptanId" : "910GLSYDNHM"
  },
  {
    "commonName" : "Luton",
    "icsCode" : "1001187",
    "lat" : 51.882305,
    "lon" : -0.41404,
    "naptanId" : "910GLUTON"
  },
  {
    "commonName" : "Luton Airport Parkway",
    "icsCode" : "1001678",
    "lat" : 51.872438,
    "lon" : -0.395881,
    "naptanId" : "910GLUTOAPY"
  },
  {
    "commonName" : "Maidenhead",
    "icsCode" : "1000964",
    "lat" : 51.518669,
    "lon" : -0.72266,
    "naptanId" : "910GMDNHEAD"
  },
  {
    "commonName" : "Malden Manor",
    "icsCode" : "1001188",
    "lat" : 51.38473,
    "lon" : -0.261274,
    "naptanId" : "910GMALDENM"
  },
  {
    "commonName" : "Manor Park",
    "icsCode" : "1001189",
    "lat" : 51.552477,
    "lon" : 0.046342,
    "naptanId" : "910GMANRPK"
  },
  {
    "commonName" : "Marlow",
    "icsCode" : "1001497",
    "lat" : 51.570993,
    "lon" : -0.766431,
    "naptanId" : "910GMARLOW"
  },
  {
    "commonName" : "Martins Heron",
    "icsCode" : "1001499",
    "lat" : 51.407412,
    "lon" : -0.724397,
    "naptanId" : "910GMHERON"
  },
  {
    "commonName" : "Maryland",
    "icsCode" : "1001190",
    "lat" : 51.546081,
    "lon" : 0.005815,
    "naptanId" : "910GMRYLAND"
  },
  {
    "commonName" : "Maze Hill",
    "icsCode" : "1001192",
    "lat" : 51.482625,
    "lon" : 0.002914,
    "naptanId" : "910GMAZEH"
  },
  {
    "commonName" : "Meopham",
    "icsCode" : "90004811",
    "lat" : 51.386424,
    "lon" : 0.356952,
    "naptanId" : "910GMEOPHAM"
  },
  {
    "commonName" : "Meridian Water",
    "icsCode" : "1002134",
    "lat" : 51.610102,
    "lon" : -0.050898,
    "naptanId" : "910GMWRWSTN"
  },
  {
    "commonName" : "Merstham",
    "icsCode" : "1001527",
    "lat" : 51.264154,
    "lon" : -0.150226,
    "naptanId" : "910GMERSTHM"
  },
  {
    "commonName" : "Mill Hill Broadway",
    "icsCode" : "1001193",
    "lat" : 51.613093,
    "lon" : -0.24924,
    "naptanId" : "910GMLHB"
  },
  {
    "commonName" : "Mitcham Eastfields",
    "icsCode" : "1001555",
    "lat" : 51.407739,
    "lon" : -0.154646,
    "naptanId" : "910GESTFLDS"
  },
  {
    "commonName" : "Mitcham Junction",
    "icsCode" : "1001194",
    "lat" : 51.39295,
    "lon" : -0.157757,
    "naptanId" : "910GMITCHMJ"
  },
  {
    "commonName" : "Moorgate",
    "icsCode" : "1000149",
    "lat" : 51.518491,
    "lon" : -0.088943,
    "naptanId" : "910GMRGT"
  },
  {
    "commonName" : "Morden South",
    "icsCode" : "1001197",
    "lat" : 51.396116,
    "lon" : -0.199461,
    "naptanId" : "910GMORDENS"
  },
  {
    "commonName" : "Mortlake",
    "icsCode" : "1001198",
    "lat" : 51.468087,
    "lon" : -0.267106,
    "naptanId" : "910GMRTLKE"
  },
  {
    "commonName" : "Motspur Park",
    "icsCode" : "1001199",
    "lat" : 51.395196,
    "lon" : -0.239531,
    "naptanId" : "910GMOTSPRP"
  },
  {
    "commonName" : "Mottingham",
    "icsCode" : "1001200",
    "lat" : 51.440218,
    "lon" : 0.050054,
    "naptanId" : "910GMOTNGHM"
  },
  {
    "commonName" : "New Barnet",
    "icsCode" : "1001201",
    "lat" : 51.648575,
    "lon" : -0.172997,
    "naptanId" : "910GNBARNET"
  },
  {
    "commonName" : "New Beckenham",
    "icsCode" : "1001202",
    "lat" : 51.41677,
    "lon" : -0.035273,
    "naptanId" : "910GNBCKNHM"
  },
  {
    "commonName" : "New Cross ELL",
    "icsCode" : "1000155",
    "lat" : 51.476344,
    "lon" : -0.032441,
    "naptanId" : "910GNWCRELL"
  },
  {
    "commonName" : "New Cross Gate",
    "icsCode" : "1000156",
    "lat" : 51.475128,
    "lon" : -0.040399,
    "naptanId" : "910GNEWXGTE"
  },
  {
    "commonName" : "New Eltham",
    "icsCode" : "1001205",
    "lat" : 51.43806,
    "lon" : 0.070533,
    "naptanId" : "910GNWELTHM"
  },
  {
    "commonName" : "New Hythe",
    "icsCode" : "90005376",
    "lat" : 51.313003,
    "lon" : 0.45493,
    "naptanId" : "910GNWHYTHE"
  },
  {
    "commonName" : "New Malden",
    "icsCode" : "1001206",
    "lat" : 51.404075,
    "lon" : -0.25594,
    "naptanId" : "910GNEWMLDN"
  },
  {
    "commonName" : "New Southgate",
    "icsCode" : "1001207",
    "lat" : 51.614114,
    "lon" : -0.143038,
    "naptanId" : "910GNEWSGAT"
  },
  {
    "commonName" : "Newbury Park Station",
    "icsCode" : "1000154",
    "lat" : 51.57504,
    "lon" : 0.089684,
    "naptanId" : "910GILFENBP"
  },
  {
    "commonName" : "Norbiton",
    "icsCode" : "1001208",
    "lat" : 51.412358,
    "lon" : -0.284025,
    "naptanId" : "910GNRBITON"
  },
  {
    "commonName" : "Norbury",
    "icsCode" : "1001209",
    "lat" : 51.411446,
    "lon" : -0.121926,
    "naptanId" : "910GNORBURY"
  },
  {
    "commonName" : "North Camp",
    "icsCode" : "1001514",
    "lat" : 51.275795,
    "lon" : -0.731199,
    "naptanId" : "910GNTHCAMP"
  },
  {
    "commonName" : "North Dulwich",
    "icsCode" : "1001210",
    "lat" : 51.45451,
    "lon" : -0.087917,
    "naptanId" : "910GNDULWCH"
  },
  {
    "commonName" : "North Sheen",
    "icsCode" : "1001212",
    "lat" : 51.465155,
    "lon" : -0.287876,
    "naptanId" : "910GNSHEEN"
  },
  {
    "commonName" : "North Wembley",
    "icsCode" : "1000163",
    "lat" : 51.562596,
    "lon" : -0.303984,
    "naptanId" : "910GNWEMBLY"
  },
  {
    "commonName" : "Northfleet",
    "icsCode" : "1001541",
    "lat" : 51.445846,
    "lon" : 0.324334,
    "naptanId" : "910GNRTHFLT"
  },
  {
    "commonName" : "Northolt Park",
    "icsCode" : "1001211",
    "lat" : 51.55754,
    "lon" : -0.359466,
    "naptanId" : "910GNTHOLTP"
  },
  {
    "commonName" : "Northumberland Park",
    "icsCode" : "1001213",
    "lat" : 51.601969,
    "lon" : -0.053932,
    "naptanId" : "910GNMBRLPK"
  },
  {
    "commonName" : "Norwood Junction",
    "icsCode" : "1001216",
    "lat" : 51.397019,
    "lon" : -0.075221,
    "naptanId" : "910GNORWDJ"
  },
  {
    "commonName" : "Nunhead",
    "icsCode" : "1001217",
    "lat" : 51.466828,
    "lon" : -0.052273,
    "naptanId" : "910GNUNHEAD"
  },
  {
    "commonName" : "Nutfield",
    "icsCode" : "1001693",
    "lat" : 51.226814,
    "lon" : -0.132531,
    "naptanId" : "910GNUTFILD"
  },
  {
    "commonName" : "Oakleigh Park",
    "icsCode" : "1001218",
    "lat" : 51.637678,
    "lon" : -0.166209,
    "naptanId" : "910GOKLGHPK"
  },
  {
    "commonName" : "Ockendon",
    "icsCode" : "1001565",
    "lat" : 51.521992,
    "lon" : 0.290469,
    "naptanId" : "910GOCKENDN"
  },
  {
    "commonName" : "Ockley",
    "icsCode" : "90005418",
    "lat" : 51.151512,
    "lon" : -0.336014,
    "naptanId" : "910GOCKLYAC"
  },
  {
    "commonName" : "Old Street",
    "icsCode" : "1000169",
    "lat" : 51.525832,
    "lon" : -0.088535,
    "naptanId" : "910GOLDST"
  },
  {
    "commonName" : "Orpington",
    "icsCode" : "1001220",
    "lat" : 51.373296,
    "lon" : 0.089091,
    "naptanId" : "910GORPNGTN"
  },
  {
    "commonName" : "Otford",
    "icsCode" : "1001606",
    "lat" : 51.313158,
    "lon" : 0.196779,
    "naptanId" : "910GOTFORD"
  },
  {
    "commonName" : "Oxshott",
    "icsCode" : "1001608",
    "lat" : 51.336396,
    "lon" : -0.362419,
    "naptanId" : "910GOXSHOTT"
  },
  {
    "commonName" : "Oxted",
    "icsCode" : "1001695",
    "lat" : 51.257908,
    "lon" : -0.004833,
    "naptanId" : "910GOXTED"
  },
  {
    "commonName" : "Palmers Green",
    "icsCode" : "1001222",
    "lat" : 51.618314,
    "lon" : -0.110437,
    "naptanId" : "910GPALMRSG"
  },
  {
    "commonName" : "Park Street",
    "icsCode" : "1000767",
    "lat" : 51.725458,
    "lon" : -0.340276,
    "naptanId" : "910GPKST"
  },
  {
    "commonName" : "Peckham Rye",
    "icsCode" : "1001223",
    "lat" : 51.470034,
    "lon" : -0.069414,
    "naptanId" : "910GPCKHMRY"
  },
  {
    "commonName" : "Penge East",
    "icsCode" : "1001224",
    "lat" : 51.419334,
    "lon" : -0.05422,
    "naptanId" : "910GPNGEE"
  },
  {
    "commonName" : "Penge West",
    "icsCode" : "1001225",
    "lat" : 51.417555,
    "lon" : -0.06084,
    "naptanId" : "910GPENEW"
  },
  {
    "commonName" : "Penshurst",
    "icsCode" : "1001701",
    "lat" : 51.197338,
    "lon" : 0.173472,
    "naptanId" : "910GPNSHRST"
  },
  {
    "commonName" : "Petts Wood",
    "icsCode" : "1001226",
    "lat" : 51.388619,
    "lon" : 0.074481,
    "naptanId" : "910GPETSWD"
  },
  {
    "commonName" : "Pitsea",
    "icsCode" : "1000741",
    "lat" : 51.560359,
    "lon" : 0.506293,
    "naptanId" : "910GPITSEA"
  },
  {
    "commonName" : "Plumstead",
    "icsCode" : "1001227",
    "lat" : 51.489795,
    "lon" : 0.084257,
    "naptanId" : "910GPLMS"
  },
  {
    "commonName" : "Ponders End",
    "icsCode" : "1001228",
    "lat" : 51.642256,
    "lon" : -0.03508,
    "naptanId" : "910GPNDRSEN"
  },
  {
    "commonName" : "Potters Bar",
    "icsCode" : "1011145",
    "lat" : 51.697067,
    "lon" : -0.192605,
    "naptanId" : "910GPOTRSBR"
  },
  {
    "commonName" : "Purfleet",
    "icsCode" : "1001566",
    "lat" : 51.481013,
    "lon" : 0.236767,
    "naptanId" : "910GPURFLET"
  },
  {
    "commonName" : "Purley",
    "icsCode" : "1001229",
    "lat" : 51.337579,
    "lon" : -0.114035,
    "naptanId" : "910GPURLEY"
  },
  {
    "commonName" : "Purley Oaks",
    "icsCode" : "1001230",
    "lat" : 51.347046,
    "lon" : -0.098856,
    "naptanId" : "910GPURLEYO"
  },
  {
    "commonName" : "Putney",
    "icsCode" : "1001231",
    "lat" : 51.461303,
    "lon" : -0.216475,
    "naptanId" : "910GPUTNEY"
  },
  {
    "commonName" : "Queens Park (London)",
    "icsCode" : "1000186",
    "lat" : 51.533966,
    "lon" : -0.204985,
    "naptanId" : "910GQPRK"
  },
  {
    "commonName" : "Queens Road Peckham",
    "icsCode" : "1001233",
    "lat" : 51.473566,
    "lon" : -0.057313,
    "naptanId" : "910GPCKHMQD"
  },
  {
    "commonName" : "Queenstown Road (Battersea)",
    "icsCode" : "1001234",
    "lat" : 51.474968,
    "lon" : -0.146678,
    "naptanId" : "910GQTRDBAT"
  },
  {
    "commonName" : "Radlett",
    "icsCode" : "1000486",
    "lat" : 51.685188,
    "lon" : -0.317244,
    "naptanId" : "910GRADLETT"
  },
  {
    "commonName" : "Rainham (London)",
    "icsCode" : "1001235",
    "lat" : 51.516723,
    "lon" : 0.190634,
    "naptanId" : "910GRNHAME"
  },
  {
    "commonName" : "Ravensbourne",
    "icsCode" : "1001236",
    "lat" : 51.414188,
    "lon" : -0.007557,
    "naptanId" : "910GRBRN"
  },
  {
    "commonName" : "Raynes Park",
    "icsCode" : "1001237",
    "lat" : 51.409173,
    "lon" : -0.230151,
    "naptanId" : "910GRAYNSPK"
  },
  {
    "commonName" : "Rectory Road",
    "icsCode" : "1001238",
    "lat" : 51.558502,
    "lon" : -0.068267,
    "naptanId" : "910GRCTRYRD"
  },
  {
    "commonName" : "Redhill",
    "icsCode" : "1001721",
    "lat" : 51.240201,
    "lon" : -0.1659,
    "naptanId" : "910GREDHILL"
  },
  {
    "commonName" : "Reedham (Surrey)",
    "icsCode" : "1001239",
    "lat" : 51.33112,
    "lon" : -0.123416,
    "naptanId" : "910GREEDHMS"
  },
  {
    "commonName" : "Reigate",
    "icsCode" : "1001722",
    "lat" : 51.241958,
    "lon" : -0.203825,
    "naptanId" : "910GREIGATE"
  },
  {
    "commonName" : "Richmond (London)",
    "icsCode" : "1000192",
    "lat" : 51.463061,
    "lon" : -0.301558,
    "naptanId" : "910GRICHMND"
  },
  {
    "commonName" : "Rickmansworth",
    "icsCode" : "1000193",
    "lat" : 51.640247,
    "lon" : -0.473282,
    "naptanId" : "910GRCKMNSW"
  },
  {
    "commonName" : "Riddlesdown",
    "icsCode" : "1001242",
    "lat" : 51.332486,
    "lon" : -0.099387,
    "naptanId" : "910GRDLSDWN"
  },
  {
    "commonName" : "Rochester",
    "icsCode" : "90005970",
    "lat" : 51.389652,
    "lon" : 0.506855,
    "naptanId" : "910GRCHT"
  },
  {
    "commonName" : "Romford",
    "icsCode" : "1001243",
    "lat" : 51.574829,
    "lon" : 0.183237,
    "naptanId" : "910GROMFORD"
  },
  {
    "commonName" : "Rotherhithe",
    "icsCode" : "1000195",
    "lat" : 51.500817,
    "lon" : -0.052048,
    "naptanId" : "910GRTHERHI"
  },
  {
    "commonName" : "Roydon",
    "icsCode" : "1000666",
    "lat" : 51.775487,
    "lon" : 0.036252,
    "naptanId" : "910GROYDON"
  },
  {
    "commonName" : "Rye House",
    "icsCode" : "90006236",
    "lat" : 51.769413,
    "lon" : 0.005628,
    "naptanId" : "910GRYEHOUS"
  },
  {
    "commonName" : "Salfords (Surrey)",
    "icsCode" : "90006250",
    "lat" : 51.201748,
    "lon" : -0.162489,
    "naptanId" : "910GSALFDS"
  },
  {
    "commonName" : "Sanderstead",
    "icsCode" : "1001244",
    "lat" : 51.348283,
    "lon" : -0.093678,
    "naptanId" : "910GSDSD"
  },
  {
    "commonName" : "Sawbridgeworth",
    "icsCode" : "1000668",
    "lat" : 51.814348,
    "lon" : 0.160411,
    "naptanId" : "910GSBDGWTH"
  },
  {
    "commonName" : "Seer Green",
    "icsCode" : "1000559",
    "lat" : 51.609845,
    "lon" : -0.607818,
    "naptanId" : "910GSEERGRN"
  },
  {
    "commonName" : "Selhurst",
    "icsCode" : "1001245",
    "lat" : 51.391927,
    "lon" : -0.0883,
    "naptanId" : "910GSELHRST"
  },
  {
    "commonName" : "Seven Kings",
    "icsCode" : "1001246",
    "lat" : 51.564026,
    "lon" : 0.0971,
    "naptanId" : "910GSVNKNGS"
  },
  {
    "commonName" : "Seven Sisters",
    "icsCode" : "1000201",
    "lat" : 51.582268,
    "lon" : -0.07527,
    "naptanId" : "910GSEVNSIS"
  },
  {
    "commonName" : "Sevenoaks",
    "icsCode" : "1001748",
    "lat" : 51.276865,
    "lon" : 0.181669,
    "naptanId" : "910GSVNOAKS"
  },
  {
    "commonName" : "Shadwell",
    "icsCode" : "1000329",
    "lat" : 51.511284,
    "lon" : -0.056934,
    "naptanId" : "910GSHADWEL"
  },
  {
    "commonName" : "Shalford (Surrey)",
    "icsCode" : "1001752",
    "lat" : 51.214323,
    "lon" : -0.566804,
    "naptanId" : "910GSHALFD"
  },
  {
    "commonName" : "Shenfield",
    "icsCode" : "1006448",
    "lat" : 51.630877,
    "lon" : 0.329851,
    "naptanId" : "910GSHENFLD"
  },
  {
    "commonName" : "Shepherds Bush",
    "icsCode" : "1001348",
    "lat" : 51.505285,
    "lon" : -0.217654,
    "naptanId" : "910GSHPDSB"
  },
  {
    "commonName" : "Shepperton",
    "icsCode" : "1001559",
    "lat" : 51.396805,
    "lon" : -0.446786,
    "naptanId" : "910GSHEPRTN"
  },
  {
    "commonName" : "Shoreditch High Street",
    "icsCode" : "1001571",
    "lat" : 51.523375,
    "lon" : -0.075246,
    "naptanId" : "910GSHRDHST"
  },
  {
    "commonName" : "Shoreham (Kent)",
    "icsCode" : "90006506",
    "lat" : 51.332219,
    "lon" : 0.18889,
    "naptanId" : "910GSHRMKT"
  },
  {
    "commonName" : "Shortlands",
    "icsCode" : "1001248",
    "lat" : 51.405801,
    "lon" : 0.001784,
    "naptanId" : "910GSHRTLND"
  },
  {
    "commonName" : "Sidcup",
    "icsCode" : "1001249",
    "lat" : 51.43387,
    "lon" : 0.103795,
    "naptanId" : "910GSIDCUP"
  },
  {
    "commonName" : "Silver Street",
    "icsCode" : "1001250",
    "lat" : 51.614688,
    "lon" : -0.06724,
    "naptanId" : "910GSIVRST"
  },
  {
    "commonName" : "Slade Green",
    "icsCode" : "1001252",
    "lat" : 51.467786,
    "lon" : 0.190491,
    "naptanId" : "910GSLADEGN"
  },
  {
    "commonName" : "Slough",
    "icsCode" : "1000951",
    "lat" : 51.51188,
    "lon" : -0.59151,
    "naptanId" : "910GSLOUGH"
  },
  {
    "commonName" : "Snodland",
    "icsCode" : "1001770",
    "lat" : 51.330231,
    "lon" : 0.448241,
    "naptanId" : "910GSNODLND"
  },
  {
    "commonName" : "Sole Street",
    "icsCode" : "90006682",
    "lat" : 51.383081,
    "lon" : 0.378194,
    "naptanId" : "910GSOLEST"
  },
  {
    "commonName" : "South Acton",
    "icsCode" : "1001254",
    "lat" : 51.499695,
    "lon" : -0.270157,
    "naptanId" : "910GSACTON"
  },
  {
    "commonName" : "South Bermondsey",
    "icsCode" : "1001256",
    "lat" : 51.488136,
    "lon" : -0.054678,
    "naptanId" : "910GSBRMNDS"
  },
  {
    "commonName" : "South Croydon",
    "icsCode" : "1001258",
    "lat" : 51.362965,
    "lon" : -0.093457,
    "naptanId" : "910GSCROYDN"
  },
  {
    "commonName" : "South Greenford",
    "icsCode" : "1001259",
    "lat" : 51.533749,
    "lon" : -0.336704,
    "naptanId" : "910GSGFORD"
  },
  {
    "commonName" : "South Hampstead",
    "icsCode" : "1001260",
    "lat" : 51.541432,
    "lon" : -0.178878,
    "naptanId" : "910GSHMPSTD"
  },
  {
    "commonName" : "South Kenton",
    "icsCode" : "1000213",
    "lat" : 51.570214,
    "lon" : -0.308462,
    "naptanId" : "910GSKENTON"
  },
  {
    "commonName" : "South Merton",
    "icsCode" : "1001262",
    "lat" : 51.402993,
    "lon" : -0.205157,
    "naptanId" : "910GSMERTON"
  },
  {
    "commonName" : "South Ruislip",
    "icsCode" : "1000214",
    "lat" : 51.55692,
    "lon" : -0.399259,
    "naptanId" : "910GSRUISLP"
  },
  {
    "commonName" : "South Tottenham",
    "icsCode" : "1001264",
    "lat" : 51.580372,
    "lon" : -0.072103,
    "naptanId" : "910GSTOTNHM"
  },
  {
    "commonName" : "Southall",
    "icsCode" : "1001255",
    "lat" : 51.505957,
    "lon" : -0.37861,
    "naptanId" : "910GSTHALL"
  },
  {
    "commonName" : "Southbury",
    "icsCode" : "1001257",
    "lat" : 51.648705,
    "lon" : -0.052437,
    "naptanId" : "910GSBURY"
  },
  {
    "commonName" : "St Albans Abbey",
    "icsCode" : "1000484",
    "lat" : 51.744733,
    "lon" : -0.342569,
    "naptanId" : "910GSTALBNA"
  },
  {
    "commonName" : "St Albans City",
    "icsCode" : "1000482",
    "lat" : 51.750473,
    "lon" : -0.327538,
    "naptanId" : "910GSTALBCY"
  },
  {
    "commonName" : "St Helier (London)",
    "icsCode" : "1001267",
    "lat" : 51.389901,
    "lon" : -0.198771,
    "naptanId" : "910GSHLIER"
  },
  {
    "commonName" : "St James Street (London)",
    "icsCode" : "1001268",
    "lat" : 51.580981,
    "lon" : -0.032918,
    "naptanId" : "910GSTJMSST"
  },
  {
    "commonName" : "St Johns (London)",
    "icsCode" : "1001269",
    "lat" : 51.469391,
    "lon" : -0.022719,
    "naptanId" : "910GSTJOHNS"
  },
  {
    "commonName" : "St Margarets (Herts)",
    "icsCode" : "1000681",
    "lat" : 51.787841,
    "lon" : 0.001269,
    "naptanId" : "910GSMARGRT"
  },
  {
    "commonName" : "St Margarets (London)",
    "icsCode" : "1001270",
    "lat" : 51.455236,
    "lon" : -0.3202,
    "naptanId" : "910GSTMGTS"
  },
  {
    "commonName" : "St Mary Cray",
    "icsCode" : "1001271",
    "lat" : 51.394749,
    "lon" : 0.106384,
    "naptanId" : "910GSTMRYC"
  },
  {
    "commonName" : "Staines",
    "icsCode" : "1001501",
    "lat" : 51.432455,
    "lon" : -0.503164,
    "naptanId" : "910GSTAINES"
  },
  {
    "commonName" : "Stamford Hill",
    "icsCode" : "1001265",
    "lat" : 51.574467,
    "lon" : -0.076682,
    "naptanId" : "910GSTMFDHL"
  },
  {
    "commonName" : "Stanford-le-Hope",
    "icsCode" : "1000750",
    "lat" : 51.514364,
    "lon" : 0.423036,
    "naptanId" : "910GSLEHOPE"
  },
  {
    "commonName" : "Stansted Airport",
    "icsCode" : "1001266",
    "lat" : 51.888591,
    "lon" : 0.260816,
    "naptanId" : "910GSTANAIR"
  },
  {
    "commonName" : "Stansted Mountfitchet",
    "icsCode" : "90006771",
    "lat" : 51.901438,
    "lon" : 0.199781,
    "naptanId" : "910GSTANMFC"
  },
  {
    "commonName" : "Stevenage",
    "icsCode" : "1023126",
    "lat" : 51.901688,
    "lon" : -0.207109,
    "naptanId" : "910GSTEVNGE"
  },
  {
    "commonName" : "Stoke Newington",
    "icsCode" : "1001273",
    "lat" : 51.565233,
    "lon" : -0.072887,
    "naptanId" : "910GSTKNWNG"
  },
  {
    "commonName" : "Stone Crossing",
    "icsCode" : "90006795",
    "lat" : 51.45133,
    "lon" : 0.263771,
    "naptanId" : "910GSTCR"
  },
  {
    "commonName" : "Stonebridge Park",
    "icsCode" : "1000224",
    "lat" : 51.544111,
    "lon" : -0.275828,
    "naptanId" : "910GSTNBGPK"
  },
  {
    "commonName" : "Stoneleigh",
    "icsCode" : "1000900",
    "lat" : 51.363401,
    "lon" : -0.248665,
    "naptanId" : "910GSTLEIGH"
  },
  {
    "commonName" : "Stratford (London)",
    "icsCode" : "1000226",
    "lat" : 51.541895,
    "lon" : -0.003397,
    "naptanId" : "910GSTFD"
  },
  {
    "commonName" : "Stratford International",
    "icsCode" : "1001556",
    "lat" : 51.544828,
    "lon" : -0.008778,
    "naptanId" : "910GSTFODOM"
  },
  {
    "commonName" : "Strawberry Hill",
    "icsCode" : "1001278",
    "lat" : 51.438963,
    "lon" : -0.339358,
    "naptanId" : "910GSTRWBYH"
  },
  {
    "commonName" : "Streatham",
    "icsCode" : "1001279",
    "lat" : 51.425808,
    "lon" : -0.13155,
    "naptanId" : "910GSTRETHM"
  },
  {
    "commonName" : "Streatham Common",
    "icsCode" : "1001280",
    "lat" : 51.41873,
    "lon" : -0.13601,
    "naptanId" : "910GSTRHCOM"
  },
  {
    "commonName" : "Streatham Hill",
    "icsCode" : "1001281",
    "lat" : 51.438193,
    "lon" : -0.12716,
    "naptanId" : "910GSTRHILL"
  },
  {
    "commonName" : "Strood",
    "icsCode" : "90006982",
    "lat" : 51.396549,
    "lon" : 0.500188,
    "naptanId" : "910GSTROOD"
  },
  {
    "commonName" : "Sudbury & Harrow Road",
    "icsCode" : "1001282",
    "lat" : 51.554398,
    "lon" : -0.315468,
    "naptanId" : "910GSDBRYHR"
  },
  {
    "commonName" : "Sudbury Hill Harrow",
    "icsCode" : "1001283",
    "lat" : 51.558465,
    "lon" : -0.335803,
    "naptanId" : "910GSDBRYHH"
  },
  {
    "commonName" : "Sunbury",
    "icsCode" : "1001549",
    "lat" : 51.418313,
    "lon" : -0.417783,
    "naptanId" : "910GSUNBURY"
  },
  {
    "commonName" : "Sundridge Park",
    "icsCode" : "1001284",
    "lat" : 51.413782,
    "lon" : 0.021446,
    "naptanId" : "910GSNDP"
  },
  {
    "commonName" : "Sunningdale",
    "icsCode" : "1001796",
    "lat" : 51.39194,
    "lon" : -0.633041,
    "naptanId" : "910GSUNNGDL"
  },
  {
    "commonName" : "Sunnymeads",
    "icsCode" : "1002790",
    "lat" : 51.470288,
    "lon" : -0.559374,
    "naptanId" : "910GSUNYMDS"
  },
  {
    "commonName" : "Surbiton",
    "icsCode" : "1001285",
    "lat" : 51.39246,
    "lon" : -0.303958,
    "naptanId" : "910GSURBITN"
  },
  {
    "commonName" : "Surrey Quays",
    "icsCode" : "1000229",
    "lat" : 51.493196,
    "lon" : -0.047519,
    "naptanId" : "910GSURREYQ"
  },
  {
    "commonName" : "Sutton (London)",
    "icsCode" : "1001286",
    "lat" : 51.359533,
    "lon" : -0.191215,
    "naptanId" : "910GSUTTON"
  },
  {
    "commonName" : "Sutton Common",
    "icsCode" : "1019461",
    "lat" : 51.374891,
    "lon" : -0.196343,
    "naptanId" : "910GSUTTONC"
  },
  {
    "commonName" : "Swanley",
    "icsCode" : "1001802",
    "lat" : 51.393387,
    "lon" : 0.169225,
    "naptanId" : "910GSWLY"
  },
  {
    "commonName" : "Swanscombe",
    "icsCode" : "1001542",
    "lat" : 51.449071,
    "lon" : 0.309543,
    "naptanId" : "910GSWNSCMB"
  },
  {
    "commonName" : "Sydenham",
    "icsCode" : "1001289",
    "lat" : 51.427248,
    "lon" : -0.054244,
    "naptanId" : "910GSYDENHM"
  },
  {
    "commonName" : "Sydenham Hill",
    "icsCode" : "1001290",
    "lat" : 51.432714,
    "lon" : -0.080339,
    "naptanId" : "910GSYDNHMH"
  },
  {
    "commonName" : "Syon Lane",
    "icsCode" : "1001291",
    "lat" : 51.481785,
    "lon" : -0.324842,
    "naptanId" : "910GSYONLA"
  },
  {
    "commonName" : "Tadworth",
    "icsCode" : "1001572",
    "lat" : 51.291638,
    "lon" : -0.235965,
    "naptanId" : "910GTADWTH"
  },
  {
    "commonName" : "Taplow",
    "icsCode" : "1000960",
    "lat" : 51.523562,
    "lon" : -0.68137,
    "naptanId" : "910GTAPLOW"
  },
  {
    "commonName" : "Tattenham Corner",
    "icsCode" : "1001560",
    "lat" : 51.309183,
    "lon" : -0.242609,
    "naptanId" : "910GTATNHMC"
  },
  {
    "commonName" : "Teddington",
    "icsCode" : "1001292",
    "lat" : 51.424481,
    "lon" : -0.332706,
    "naptanId" : "910GTEDNGTN"
  },
  {
    "commonName" : "Thames Ditton",
    "icsCode" : "1001293",
    "lat" : 51.389097,
    "lon" : -0.339152,
    "naptanId" : "910GTDITTON"
  },
  {
    "commonName" : "Theobalds Grove",
    "icsCode" : "1001533",
    "lat" : 51.692457,
    "lon" : -0.034831,
    "naptanId" : "910GTHBLDSG"
  },
  {
    "commonName" : "Thornton Heath",
    "icsCode" : "1001294",
    "lat" : 51.398777,
    "lon" : -0.100306,
    "naptanId" : "910GTHTH"
  },
  {
    "commonName" : "Three Bridges",
    "icsCode" : "1001817",
    "lat" : 51.116924,
    "lon" : -0.161184,
    "naptanId" : "910GTHBDGS"
  },
  {
    "commonName" : "Tilbury Town",
    "icsCode" : "1000758",
    "lat" : 51.462359,
    "lon" : 0.354039,
    "naptanId" : "910GTLBYTWN"
  },
  {
    "commonName" : "Tolworth",
    "icsCode" : "1001295",
    "lat" : 51.37686,
    "lon" : -0.279461,
    "naptanId" : "910GTOLWTH"
  },
  {
    "commonName" : "Tonbridge",
    "icsCode" : "1001812",
    "lat" : 51.191411,
    "lon" : 0.270973,
    "naptanId" : "910GTONBDG"
  },
  {
    "commonName" : "Tooting",
    "icsCode" : "1001296",
    "lat" : 51.419848,
    "lon" : -0.161278,
    "naptanId" : "910GTOOTING"
  },
  {
    "commonName" : "Tottenham Court Road",
    "icsCode" : "1000235",
    "lat" : 51.515542,
    "lon" : -0.129682,
    "naptanId" : "910GTOTCTRD"
  },
  {
    "commonName" : "Tottenham Hale",
    "icsCode" : "1000236",
    "lat" : 51.58831,
    "lon" : -0.059929,
    "naptanId" : "910GTTNHMHL"
  },
  {
    "commonName" : "Tring",
    "icsCode" : "1000816",
    "lat" : 51.800741,
    "lon" : -0.622439,
    "naptanId" : "910GTRING"
  },
  {
    "commonName" : "Tulse Hill",
    "icsCode" : "1001298",
    "lat" : 51.439861,
    "lon" : -0.105077,
    "naptanId" : "910GTULSEH"
  },
  {
    "commonName" : "Tunbridge Wells",
    "icsCode" : "1001824",
    "lat" : 51.130234,
    "lon" : 0.26281,
    "naptanId" : "910GTUNWELL"
  },
  {
    "commonName" : "Turkey Street",
    "icsCode" : "1001299",
    "lat" : 51.672628,
    "lon" : -0.047217,
    "naptanId" : "910GTURKYST"
  },
  {
    "commonName" : "Twickenham",
    "icsCode" : "1001300",
    "lat" : 51.450031,
    "lon" : -0.330394,
    "naptanId" : "910GTWCKNHM"
  },
  {
    "commonName" : "Upminster",
    "icsCode" : "1000242",
    "lat" : 51.559018,
    "lon" : 0.25088,
    "naptanId" : "910GUPMNSTR"
  },
  {
    "commonName" : "Upper Halliford",
    "icsCode" : "1002820",
    "lat" : 51.413067,
    "lon" : -0.430906,
    "naptanId" : "910GUHALIFD"
  },
  {
    "commonName" : "Upper Holloway",
    "icsCode" : "1001302",
    "lat" : 51.563631,
    "lon" : -0.129513,
    "naptanId" : "910GUPRHLWY"
  },
  {
    "commonName" : "Upper Warlingham",
    "icsCode" : "1001538",
    "lat" : 51.308512,
    "lon" : -0.077952,
    "naptanId" : "910GUWRLNGH"
  },
  {
    "commonName" : "Vauxhall",
    "icsCode" : "1000344",
    "lat" : 51.48619,
    "lon" : -0.122889,
    "naptanId" : "910GVAUXHLM"
  },
  {
    "commonName" : "Virginia Water",
    "icsCode" : "1001547",
    "lat" : 51.401802,
    "lon" : -0.562174,
    "naptanId" : "910GVRGNWTR"
  },
  {
    "commonName" : "Waddon",
    "icsCode" : "1001305",
    "lat" : 51.367398,
    "lon" : -0.117336,
    "naptanId" : "910GWADDON"
  },
  {
    "commonName" : "Wallington",
    "icsCode" : "1001306",
    "lat" : 51.360386,
    "lon" : -0.150833,
    "naptanId" : "910GWALNGTN"
  },
  {
    "commonName" : "Waltham Cross",
    "icsCode" : "1000684",
    "lat" : 51.685061,
    "lon" : -0.026558,
    "naptanId" : "910GWALHAMX"
  },
  {
    "commonName" : "Walthamstow Central",
    "icsCode" : "1000249",
    "lat" : 51.582919,
    "lon" : -0.019815,
    "naptanId" : "910GWLTWCEN"
  },
  {
    "commonName" : "Walthamstow Queens Road",
    "icsCode" : "1001308",
    "lat" : 51.581503,
    "lon" : -0.023846,
    "naptanId" : "910GWLTHQRD"
  },
  {
    "commonName" : "Walton-on-Thames",
    "icsCode" : "1001829",
    "lat" : 51.372931,
    "lon" : -0.414635,
    "naptanId" : "910GWONT"
  },
  {
    "commonName" : "Wanborough",
    "icsCode" : "90007568",
    "lat" : 51.244523,
    "lon" : -0.667588,
    "naptanId" : "910GWANBRO"
  },
  {
    "commonName" : "Wandsworth Common",
    "icsCode" : "1001309",
    "lat" : 51.446185,
    "lon" : -0.163386,
    "naptanId" : "910GWANDCMN"
  },
  {
    "commonName" : "Wandsworth Road",
    "icsCode" : "1001310",
    "lat" : 51.470216,
    "lon" : -0.13852,
    "naptanId" : "910GWNDSWRD"
  },
  {
    "commonName" : "Wandsworth Town",
    "icsCode" : "1001311",
    "lat" : 51.461048,
    "lon" : -0.188125,
    "naptanId" : "910GWDWTOWN"
  },
  {
    "commonName" : "Wanstead Park",
    "icsCode" : "1001312",
    "lat" : 51.551693,
    "lon" : 0.026213,
    "naptanId" : "910GWNSTDPK"
  },
  {
    "commonName" : "Wapping",
    "icsCode" : "1000251",
    "lat" : 51.504388,
    "lon" : -0.055931,
    "naptanId" : "910GWAPPING"
  },
  {
    "commonName" : "Ware",
    "icsCode" : "1026137",
    "lat" : 51.80796,
    "lon" : -0.028781,
    "naptanId" : "910GWARE"
  },
  {
    "commonName" : "Warnham",
    "icsCode" : "1001832",
    "lat" : 51.092902,
    "lon" : -0.329464,
    "naptanId" : "910GWARNHAM"
  },
  {
    "commonName" : "Wateringbury",
    "icsCode" : "90008124",
    "lat" : 51.249735,
    "lon" : 0.422467,
    "naptanId" : "910GWTRNGBY"
  },
  {
    "commonName" : "Watford High Street",
    "icsCode" : "1001316",
    "lat" : 51.652655,
    "lon" : -0.391711,
    "naptanId" : "910GWATFDHS"
  },
  {
    "commonName" : "Watford Junction",
    "icsCode" : "1001317",
    "lat" : 51.663908,
    "lon" : -0.395925,
    "naptanId" : "910GWATFDJ"
  },
  {
    "commonName" : "Watford North",
    "icsCode" : "1000774",
    "lat" : 51.675704,
    "lon" : -0.389926,
    "naptanId" : "910GWATFDN"
  },
  {
    "commonName" : "Watton-at-Stone",
    "icsCode" : "1000474",
    "lat" : 51.856438,
    "lon" : -0.119427,
    "naptanId" : "910GWATONAS"
  },
  {
    "commonName" : "Welham Green",
    "icsCode" : "1000478",
    "lat" : 51.736352,
    "lon" : -0.210692,
    "naptanId" : "910GWELHAMG"
  },
  {
    "commonName" : "Welling",
    "icsCode" : "1001318",
    "lat" : 51.464798,
    "lon" : 0.10169,
    "naptanId" : "910GWELLING"
  },
  {
    "commonName" : "Welwyn Garden City",
    "icsCode" : "1000455",
    "lat" : 51.801048,
    "lon" : -0.20407,
    "naptanId" : "910GWLWYNGC"
  },
  {
    "commonName" : "Welwyn North",
    "icsCode" : "1000470",
    "lat" : 51.823497,
    "lon" : -0.192091,
    "naptanId" : "910GWLWYNN"
  },
  {
    "commonName" : "Wembley Central",
    "icsCode" : "1000256",
    "lat" : 51.552325,
    "lon" : -0.296433,
    "naptanId" : "910GWMBY"
  },
  {
    "commonName" : "Wembley Stadium",
    "icsCode" : "1001320",
    "lat" : 51.554416,
    "lon" : -0.285608,
    "naptanId" : "910GWEMBLSM"
  },
  {
    "commonName" : "West Brompton",
    "icsCode" : "1000260",
    "lat" : 51.487061,
    "lon" : -0.195593,
    "naptanId" : "910GWBRMPTN"
  },
  {
    "commonName" : "West Byfleet",
    "icsCode" : "1001834",
    "lat" : 51.339226,
    "lon" : -0.505485,
    "naptanId" : "910GWBYFLET"
  },
  {
    "commonName" : "West Croydon",
    "icsCode" : "1001324",
    "lat" : 51.378428,
    "lon" : -0.102585,
    "naptanId" : "910GWCROYDN"
  },
  {
    "commonName" : "West Drayton",
    "icsCode" : "1001325",
    "lat" : 51.510055,
    "lon" : -0.472234,
    "naptanId" : "910GWDRYTON"
  },
  {
    "commonName" : "West Dulwich",
    "icsCode" : "1001326",
    "lat" : 51.440718,
    "lon" : -0.091371,
    "naptanId" : "910GWDULWCH"
  },
  {
    "commonName" : "West Ealing",
    "icsCode" : "1001327",
    "lat" : 51.513506,
    "lon" : -0.320133,
    "naptanId" : "910GWEALING"
  },
  {
    "commonName" : "West Ham",
    "icsCode" : "1000262",
    "lat" : 51.528489,
    "lon" : 0.005431,
    "naptanId" : "910GWHAMHL"
  },
  {
    "commonName" : "West Hampstead",
    "icsCode" : "1000321",
    "lat" : 51.547468,
    "lon" : -0.191185,
    "naptanId" : "910GWHMDSTD"
  },
  {
    "commonName" : "West Hampstead Thameslink",
    "icsCode" : "1001330",
    "lat" : 51.548476,
    "lon" : -0.191837,
    "naptanId" : "910GWHMPSTM"
  },
  {
    "commonName" : "West Horndon",
    "icsCode" : "1002848",
    "lat" : 51.567945,
    "lon" : 0.340644,
    "naptanId" : "910GWHORNDN"
  },
  {
    "commonName" : "West Malling",
    "icsCode" : "90007937",
    "lat" : 51.292021,
    "lon" : 0.418653,
    "naptanId" : "910GWMALING"
  },
  {
    "commonName" : "West Norwood",
    "icsCode" : "1001331",
    "lat" : 51.431748,
    "lon" : -0.10383,
    "naptanId" : "910GWNORWOD"
  },
  {
    "commonName" : "West Ruislip",
    "icsCode" : "1000267",
    "lat" : 51.569758,
    "lon" : -0.437768,
    "naptanId" : "910GWRUISLP"
  },
  {
    "commonName" : "West Sutton",
    "icsCode" : "1001333",
    "lat" : 51.365854,
    "lon" : -0.205173,
    "naptanId" : "910GWSUTTON"
  },
  {
    "commonName" : "West Wickham",
    "icsCode" : "1001334",
    "lat" : 51.381301,
    "lon" : -0.014432,
    "naptanId" : "910GWWICKHM"
  },
  {
    "commonName" : "Westcombe Park",
    "icsCode" : "1001323",
    "lat" : 51.484203,
    "lon" : 0.018395,
    "naptanId" : "910GWCOMBEP"
  },
  {
    "commonName" : "Weybridge",
    "icsCode" : "1001846",
    "lat" : 51.361771,
    "lon" : -0.457739,
    "naptanId" : "910GWEYBDGB"
  },
  {
    "commonName" : "White Hart Lane",
    "icsCode" : "1001335",
    "lat" : 51.605037,
    "lon" : -0.070914,
    "naptanId" : "910GWHHRTLA"
  },
  {
    "commonName" : "Whitechapel",
    "icsCode" : "1000268",
    "lat" : 51.519555,
    "lon" : -0.059537,
    "naptanId" : "910GWCHAPXR"
  },
  {
    "commonName" : "Whitton",
    "icsCode" : "1001336",
    "lat" : 51.449607,
    "lon" : -0.357681,
    "naptanId" : "910GWHTTON"
  },
  {
    "commonName" : "Whyteleafe",
    "icsCode" : "1001536",
    "lat" : 51.309958,
    "lon" : -0.081148,
    "naptanId" : "910GWHYTELF"
  },
  {
    "commonName" : "Whyteleafe South",
    "icsCode" : "1001537",
    "lat" : 51.303387,
    "lon" : -0.076918,
    "naptanId" : "910GWHYTLFS"
  },
  {
    "commonName" : "Wickford",
    "icsCode" : "1000693",
    "lat" : 51.615023,
    "lon" : 0.519185,
    "naptanId" : "910GWIKFORD"
  },
  {
    "commonName" : "Willesden Junction",
    "icsCode" : "1000271",
    "lat" : 51.532497,
    "lon" : -0.244548,
    "naptanId" : "910GWLSDJHL"
  },
  {
    "commonName" : "Wimbledon",
    "icsCode" : "1000272",
    "lat" : 51.421222,
    "lon" : -0.206385,
    "naptanId" : "910GWDON"
  },
  {
    "commonName" : "Wimbledon Chase",
    "icsCode" : "1001339",
    "lat" : 51.409558,
    "lon" : -0.214031,
    "naptanId" : "910GWIMLCHS"
  },
  {
    "commonName" : "Winchmore Hill",
    "icsCode" : "1001340",
    "lat" : 51.633942,
    "lon" : -0.1009,
    "naptanId" : "910GWNMHILL"
  },
  {
    "commonName" : "Windsor & Eton Central",
    "icsCode" : "1001855",
    "lat" : 51.483268,
    "lon" : -0.61038,
    "naptanId" : "910GWINDSEC"
  },
  {
    "commonName" : "Windsor & Eton Riverside",
    "icsCode" : "1001856",
    "lat" : 51.48565,
    "lon" : -0.606534,
    "naptanId" : "910GWSORAER"
  },
  {
    "commonName" : "Woking",
    "icsCode" : "1001865",
    "lat" : 51.318469,
    "lon" : -0.55696,
    "naptanId" : "910GWOKING"
  },
  {
    "commonName" : "Woldingham",
    "icsCode" : "1001567",
    "lat" : 51.290158,
    "lon" : -0.05187,
    "naptanId" : "910GWLDNGHM"
  },
  {
    "commonName" : "Wood Street",
    "icsCode" : "1001343",
    "lat" : 51.58658,
    "lon" : -0.002405,
    "naptanId" : "910GWDST"
  },
  {
    "commonName" : "Woodgrange Park",
    "icsCode" : "1001341",
    "lat" : 51.549264,
    "lon" : 0.044423,
    "naptanId" : "910GWDGRNPK"
  },
  {
    "commonName" : "Woodmansterne",
    "icsCode" : "1001342",
    "lat" : 51.31902,
    "lon" : -0.154262,
    "naptanId" : "910GWDMNSTR"
  },
  {
    "commonName" : "Woolwich",
    "icsCode" : "1002162",
    "lat" : 51.491851,
    "lon" : 0.070737,
    "naptanId" : "910GWOLWXR"
  },
  {
    "commonName" : "Woolwich Arsenal",
    "icsCode" : "1001344",
    "lat" : 51.489909,
    "lon" : 0.069194,
    "naptanId" : "910GWOLWCHA"
  },
  {
    "commonName" : "Woolwich Dockyard",
    "icsCode" : "1001345",
    "lat" : 51.491127,
    "lon" : 0.054642,
    "naptanId" : "910GWOLWCDY"
  },
  {
    "commonName" : "Worcester Park",
    "icsCode" : "1001346",
    "lat" : 51.381253,
    "lon" : -0.245167,
    "naptanId" : "910GWRCSTRP"
  },
  {
    "commonName" : "Worplesdon",
    "icsCode" : "90008069",
    "lat" : 51.289017,
    "lon" : -0.582578,
    "naptanId" : "910GWRPLSDN"
  },
  {
    "commonName" : "Wraysbury",
    "icsCode" : "1001878",
    "lat" : 51.457708,
    "lon" : -0.541922,
    "naptanId" : "910GWRYSBRY"
  },
  {
    "commonName" : "Yalding",
    "icsCode" : "90008157",
    "lat" : 51.226484,
    "lon" : 0.412164,
    "naptanId" : "910GYALDING"
  }
]
"""
