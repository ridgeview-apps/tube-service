let journeyWithLongDisruptionMessageJSON = #"""
  {
    "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Journey, Tfl.Api.Presentation.Entities",
    "startDateTime": "2024-04-08T14:02:00",
    "duration": 134,
    "arrivalDateTime": "2024-04-08T16:16:00",
    "alternativeRoute": false,
    "legs": [
      {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
        "duration": 9,
        "instruction": {
          "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
          "summary": "Walk to Piccadilly Circus",
          "detailed": "Walk to Piccadilly Circus",
          "steps": [
            {
              "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
              "description": " for 80 metres",
              "turnDirection": "STRAIGHT",
              "streetName": "",
              "distance": 80,
              "cumulativeDistance": 80,
              "skyDirection": 240,
              "skyDirectionDescription": "SouthWest",
              "cumulativeTravelTime": 73,
              "latitude": 51.51001152578,
              "longitude": -0.13372754557,
              "pathAttribute": {
                "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
              },
              "descriptionHeading": "Continue along ",
              "trackType": "None"
            },
            {
              "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
              "description": "on to Regent Street, continue for 13 metres",
              "turnDirection": "LEFT",
              "streetName": "Regent Street",
              "distance": 13,
              "cumulativeDistance": 93,
              "skyDirection": 157,
              "skyDirectionDescription": "SouthEast",
              "cumulativeTravelTime": 85,
              "latitude": 51.50984943251,
              "longitude": -0.13484381468,
              "pathAttribute": {
                "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
              },
              "descriptionHeading": "Turn left",
              "trackType": "None"
            },
            {
              "$type": "Tfl.Api.Presentation.Entities.InstructionStep, Tfl.Api.Presentation.Entities",
              "description": "on to Piccadilly, continue for 19 metres",
              "turnDirection": "RIGHT",
              "streetName": "Piccadilly",
              "distance": 19,
              "cumulativeDistance": 112,
              "skyDirection": 245,
              "skyDirectionDescription": "SouthWest",
              "cumulativeTravelTime": 101,
              "latitude": 51.509740447190005,
              "longitude": -0.13477621103999998,
              "pathAttribute": {
                "$type": "Tfl.Api.Presentation.Entities.PathAttribute, Tfl.Api.Presentation.Entities"
              },
              "descriptionHeading": "Turn right",
              "trackType": "None"
            }
          ]
        },
        "obstacles": [
          {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
            "type": "STAIRS",
            "incline": "DOWN",
            "stopId": 1000179,
            "position": "IDEST"
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
            "type": "ESCALATOR",
            "incline": "DOWN",
            "stopId": 1000179,
            "position": "IDEST"
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
            "type": "ESCALATOR",
            "incline": "DOWN",
            "stopId": 1000179,
            "position": "IDEST"
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
            "type": "STAIRS",
            "incline": "DOWN",
            "stopId": 1000179,
            "position": "IDEST"
          }
        ],
        "departureTime": "2024-04-08T14:02:00",
        "arrivalTime": "2024-04-08T14:11:00",
        "departurePoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "platformName": "",
          "icsCode": "99999997",
          "commonName": "60 Malden Road, Camden",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.51001129661999,
          "lon": -0.13371314391000003
        },
        "arrivalPoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "940GZZLUPCC",
          "platformName": "",
          "icsCode": "1000179",
          "individualStopId": "9400ZZLUPCC1",
          "commonName": "Piccadilly Circus Underground Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.51009018522,
          "lon": -0.13528072454
        },
        "path": {
          "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
          "lineString": "[[51.51001129662, -0.13371314391],[51.51001152578, -0.13372754557],[51.50984943251, -0.13484381468],[51.50974044719, -0.13477621104],[51.50967244705, -0.13502397393],[51.50967249540, -0.13502398750],[51.50979579486, -0.13429838891],[51.50996437166, -0.13528586173],[51.51009487517, -0.13444469207],[51.50995539540, -0.13528618750]]",
          "stopPoints": [],
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
          "motType": "100",
          "network": ""
        },
        "disruptions": [],
        "plannedWorks": [],
        "distance": 112.0,
        "isDisrupted": false,
        "hasFixedLocations": true,
        "scheduledDepartureTime": "2024-04-08T14:02:00",
        "scheduledArrivalTime": "2024-04-08T14:11:00",
        "interChangeDuration": "7",
        "interChangePosition": "IDEST"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
        "duration": 1,
        "instruction": {
          "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
          "summary": "Bakerloo line to Oxford Circus",
          "detailed": "Bakerloo line towards Queen's Park",
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
        "departureTime": "2024-04-08T14:11:00",
        "arrivalTime": "2024-04-08T14:12:00",
        "departurePoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "940GZZLUPCC",
          "platformName": "",
          "icsCode": "1000179",
          "individualStopId": "9400ZZLUPCC1",
          "commonName": "Piccadilly Circus Underground Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.51009018522,
          "lon": -0.13528072454
        },
        "arrivalPoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "940GZZLUOXC",
          "platformName": "",
          "icsCode": "1000173",
          "individualStopId": "9400ZZLUOXC4",
          "commonName": "Oxford Circus Underground Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.51570432013,
          "lon": -0.14225785971
        },
        "path": {
          "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
          "lineString": "[[51.50995527877, -0.13528617652],[51.50991771739, -0.13631094724],[51.50991004028, -0.13695975507],[51.50997013649, -0.13734640067],[51.51007447888, -0.13768800986],[51.51023228320, -0.13799861868],[51.51049815569, -0.13831923529],[51.51101771190, -0.13875921757],[51.51405459181, -0.14143141735],[51.51451122977, -0.14187402851],[51.51570383402, -0.14226153510]]",
          "stopPoints": [
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
            "name": "Bakerloo",
            "directions": [
              "Queen's Park Underground Station"
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
            "direction": "Outbound"
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
            "description": "Bakerloo Line: Minor delays due to train cancellations.",
            "summary": "",
            "additionalInfo": "",
            "created": "2024-04-08T06:12:00",
            "lastUpdate": "2024-04-08T06:12:00"
          }
        ],
        "plannedWorks": [],
        "isDisrupted": true,
        "hasFixedLocations": true,
        "scheduledDepartureTime": "2024-04-08T14:11:00",
        "scheduledArrivalTime": "2024-04-08T14:12:00",
        "interChangeDuration": "2",
        "interChangePosition": "AFTER"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
        "duration": 4,
        "instruction": {
          "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
          "summary": "Victoria line to King's Cross St.Pancras",
          "detailed": "Victoria line towards Walthamstow Central",
          "steps": []
        },
        "obstacles": [],
        "departureTime": "2024-04-08T14:14:00",
        "arrivalTime": "2024-04-08T14:18:00",
        "departurePoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "940GZZLUOXC",
          "platformName": "",
          "icsCode": "1000173",
          "individualStopId": "9400ZZLUOXC2",
          "commonName": "Oxford Circus Underground Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.51574948182,
          "lon": -0.14227043503
        },
        "arrivalPoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "940GZZLUKSX",
          "platformName": "",
          "icsCode": "1000129",
          "individualStopId": "9400ZZLUKSX1",
          "commonName": "King's Cross St. Pancras Underground Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.53044013799,
          "lon": -0.12230978124
        },
        "path": {
          "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
          "lineString": "[[51.51574876830, -0.14227613575],[51.51593035666, -0.14233514015],[51.51657046612, -0.14243881405],[51.51715323345, -0.14232862448],[51.52408133923, -0.13868116890],[51.52408133923, -0.13868116890],[51.52566996631, -0.13784463148],[51.52597923903, -0.13750044403],[51.52622331599, -0.13701475135],[51.52807223270, -0.13215478385],[51.52807223270, -0.13215478385],[51.52884728553, -0.13011724258],[51.52898372132, -0.12965030752],[51.53044027906, -0.12230988114]]",
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
              "id": "940GZZLUEUS",
              "name": "Euston Underground Station",
              "uri": "/StopPoint/940GZZLUEUS",
              "type": "StopPoint",
              "routeType": "Unknown",
              "status": "Unknown"
            },
            {
              "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
              "id": "940GZZLUKSX",
              "name": "King's Cross St. Pancras Underground Station",
              "uri": "/StopPoint/940GZZLUKSX",
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
              "Walthamstow Central Underground Station"
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
            "direction": "Outbound"
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
            "type": "stopInfo",
            "categoryDescription": "Information",
            "description": "Kings Cross St Pancras Station: Mini ramps are available at this station on the Circle, Hammersmith & City, Metropolitan, Northern and Victoria line platforms. They are designed to cover the small remaining step / or gap between the platform and the train on step-free to train platforms. They make it easier for customers people to get on and off the train, in particular for people whose mobility aids have small or swivel wheels. The ramps are quick and easy to use. Staff are trained to use them and will be happy to provide one for you to use. If you would like to use a mini ramp, please ask for help from staff or press the information button on a help point.",
            "summary": "",
            "additionalInfo": "",
            "created": "2024-02-13T10:31:00",
            "lastUpdate": "2024-02-13T10:32:00"
          }
        ],
        "plannedWorks": [],
        "isDisrupted": true,
        "hasFixedLocations": true,
        "scheduledDepartureTime": "2024-04-08T14:14:00",
        "scheduledArrivalTime": "2024-04-08T14:18:00"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
        "duration": 9,
        "instruction": {
          "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
          "summary": "Walk to King's Cross Rail Station",
          "detailed": "Walk to King's Cross Rail Station",
          "steps": []
        },
        "obstacles": [
          {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
            "type": "ESCALATOR",
            "incline": "UP",
            "stopId": 1000129,
            "position": "IDEST"
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
            "type": "STAIRS",
            "incline": "UP",
            "stopId": 1000129,
            "position": "IDEST"
          },
          {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
            "type": "WALKWAY",
            "incline": "LEVEL",
            "stopId": 1000129,
            "position": "IDEST"
          }
        ],
        "departureTime": "2024-04-08T14:18:00",
        "arrivalTime": "2024-04-08T14:27:00",
        "departurePoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "940GZZLUKSX",
          "platformName": "",
          "icsCode": "1000129",
          "individualStopId": "9400ZZLUKSX1",
          "commonName": "King's Cross St. Pancras Underground Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.53044013799,
          "lon": -0.12230978124
        },
        "arrivalPoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "910GKNGX",
          "platformName": "",
          "icsCode": "1001171",
          "individualStopId": "9100KNGX",
          "commonName": "London King's Cross Rail Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.53157914035,
          "lon": -0.12324332867
        },
        "path": {
          "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
          "lineString": "[[51.53044009541, -0.12230978748],[51.53028507338, -0.12385882890],[51.53057449541, -0.12339998748],[51.53157914035, -0.12324332867]]",
          "stopPoints": [
            {
              "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
              "name": "King's Cross Rail Station",
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
        "scheduledDepartureTime": "2024-04-08T14:18:00",
        "scheduledArrivalTime": "2024-04-08T14:27:00",
        "interChangeDuration": "9",
        "interChangePosition": "IDEST"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
        "duration": 106,
        "instruction": {
          "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
          "summary": "Grand Central to York",
          "detailed": "Grand Central towards Sunderland",
          "steps": []
        },
        "obstacles": [],
        "departureTime": "2024-04-08T14:27:00",
        "arrivalTime": "2024-04-08T16:13:00",
        "departurePoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "910GKNGX",
          "platformName": "",
          "icsCode": "1001171",
          "individualStopId": "9100KNGX",
          "commonName": "London King's Cross Rail Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 51.53157914035,
          "lon": -0.12324332867
        },
        "arrivalPoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "910GYORK",
          "platformName": "",
          "icsCode": "90008178",
          "individualStopId": "9100YORK0",
          "commonName": "York Rail Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 53.95796429883,
          "lon": -1.0931821339499999
        },
        "path": {
          "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
          "stopPoints": [
            {
              "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
              "id": "910GYORK",
              "name": "York Rail Station",
              "uri": "/StopPoint/910GYORK",
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
            "name": "Grand Central",
            "directions": [
              "Sunderland Rail Station"
            ],
            "lineIdentifier": {
              "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
              "id": "grand-central",
              "name": "Grand Central",
              "uri": "/Line/grand-central",
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
        "scheduledDepartureTime": "2024-04-08T14:27:00",
        "scheduledArrivalTime": "2024-04-08T16:13:00"
      },
      {
        "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Leg, Tfl.Api.Presentation.Entities",
        "duration": 3,
        "instruction": {
          "$type": "Tfl.Api.Presentation.Entities.Instruction, Tfl.Api.Presentation.Entities",
          "summary": "Walk to York Rail Station",
          "detailed": "Walk to York Rail Station",
          "steps": []
        },
        "obstacles": [
          {
            "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Obstacle, Tfl.Api.Presentation.Entities",
            "type": "WALKWAY",
            "incline": "LEVEL",
            "stopId": 90008178,
            "position": "IDEST"
          }
        ],
        "departureTime": "2024-04-08T16:13:00",
        "arrivalTime": "2024-04-08T16:16:00",
        "departurePoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "naptanId": "910GYORK",
          "platformName": "",
          "icsCode": "90008178",
          "individualStopId": "9100YORK0",
          "commonName": "York Rail Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 53.95796429883,
          "lon": -1.0931821339499999
        },
        "arrivalPoint": {
          "$type": "Tfl.Api.Presentation.Entities.StopPoint, Tfl.Api.Presentation.Entities",
          "platformName": "",
          "icsCode": "90008178",
          "individualStopId": "3290YORK0",
          "commonName": "York Rail Station",
          "placeType": "StopPoint",
          "additionalProperties": [],
          "lat": 53.95797594511,
          "lon": -1.0923436579199999
        },
        "path": {
          "$type": "Tfl.Api.Presentation.Entities.JourneyPlanner.Path, Tfl.Api.Presentation.Entities",
          "lineString": "[[53.95819669745, -1.09419818671],[53.95796569745, -1.09217618671]]",
          "stopPoints": [
            {
              "$type": "Tfl.Api.Presentation.Entities.Identifier, Tfl.Api.Presentation.Entities",
              "name": "York Rail Station",
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
        "scheduledDepartureTime": "2024-04-08T16:13:00",
        "scheduledArrivalTime": "2024-04-08T16:16:00",
        "interChangeDuration": "3",
        "interChangePosition": "IDEST"
      }
    ]
  }
"""#
