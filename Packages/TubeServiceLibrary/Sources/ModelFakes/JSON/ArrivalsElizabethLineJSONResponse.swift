let arrivalsElizabethLineJSONResponse =

"""
[
    {
        "$type": "Tfl.Api.Presentation.Entities.ArrivalDeparture, Tfl.Api.Presentation.Entities",
        "platformName": "Platform Unknown",
        "destinationName": "Abbey Wood",
        "naptanId": "910GPADTON",
        "stationName": "London Paddington Rail Station",
        "estimatedTimeOfDeparture": "2022-06-01T20:08:00Z",
        "scheduledTimeOfDeparture": "2022-06-01T20:08:00Z",
        "minutesAndSecondsToArrival": "",
        "minutesAndSecondsToDeparture": "2:10",
        "departureStatus": "OnTime"
    },
    {
        "$type": "Tfl.Api.Presentation.Entities.ArrivalDeparture, Tfl.Api.Presentation.Entities",
        "platformName": "Platform Unknown",
        "destinationName": "Abbey Wood",
        "naptanId": "910GPADTON",
        "stationName": "London Paddington Rail Station",
        "estimatedTimeOfDeparture": "2022-06-01T20:13:02Z",
        "scheduledTimeOfDeparture": "2022-06-01T20:13:00Z",
        "minutesAndSecondsToArrival": "",
        "minutesAndSecondsToDeparture": "9:10",
        "departureStatus": "Delayed"
    },
    {
        "$type": "Tfl.Api.Presentation.Entities.ArrivalDeparture, Tfl.Api.Presentation.Entities",
        "platformName": "Platform Unknown",
        "destinationName": "Abbey Wood",
        "naptanId": "910GPADTON",
        "stationName": "London Paddington Rail Station",
        "estimatedTimeOfDeparture": "2022-06-01T20:18:00Z",
        "scheduledTimeOfDeparture": "2022-06-01T20:18:00Z",
        "minutesAndSecondsToArrival": "",
        "minutesAndSecondsToDeparture": "12:10",
        "departureStatus": "Cancelled"
    },
    {
        "$type": "Tfl.Api.Presentation.Entities.ArrivalDeparture, Tfl.Api.Presentation.Entities",
        "platformName": "Platform Unknown",
        "destinationName": "Abbey Wood",
        "naptanId": "910GPADTON",
        "stationName": "London Paddington Rail Station",
        "estimatedTimeOfDeparture": "2022-06-01T20:23:00Z",
        "scheduledTimeOfDeparture": "2022-06-01T20:23:00Z",
        "minutesAndSecondsToArrival": "",
        "minutesAndSecondsToDeparture": "17:10",
        "departureStatus": "NotStoppingAtStation"
    }
]
""".data(using: .utf8)!
