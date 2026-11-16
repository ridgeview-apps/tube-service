public enum KnownLines {

    /// The TfL modes whose lines the app shows.
    public static let modes = ["tube", "dlr", "tram", "elizabeth-line", "overground"]

    /// Keep in step with `TrainLineID` in the Models package: the app can't decode a line ID it doesn't know.
    public static let ids = [
        "bakerloo",
        "central",
        "circle",
        "district",
        "dlr",
        "elizabeth",
        "hammersmith-city",
        "jubilee",
        "liberty",
        "lioness",
        "metropolitan",
        "mildmay",
        "northern",
        "piccadilly",
        "suffragette",
        "tram",
        "victoria",
        "waterloo-city",
        "weaver",
        "windrush"
    ]
}
