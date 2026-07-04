import Foundation

// Adapted from: https://stackoverflow.com/questions/26028918/how-to-determine-the-current-iphone-device-model

// MARK: Device

public struct Device {

    public static let modelIdentifier = currentModelIdentifier()

    public static let modelName = modelName(forIdentifier: modelIdentifier)

    public static let modelDescription = modelDescription(forIdentifier: modelIdentifier)

    static func modelName(forIdentifier identifier: String) -> String {
        if simulatorIdentifiers.contains(identifier) {
            return simulatorModelName()
        }

        return modelNamesByIdentifier[identifier] ?? identifier
    }

    static func modelDescription(forIdentifier identifier: String) -> String {
        let name = modelName(forIdentifier: identifier)
        guard name != identifier else { return identifier }
        return "\(name) (\(identifier))"
    }
}

// MARK: - Private helpers

private extension Device {

    static func currentModelIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)

        return machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
    }

    static func simulatorModelName() -> String {
        let identifier = ProcessInfo.processInfo.environment["SIMULATOR_MODEL_IDENTIFIER"] ?? defaultSimulatorIdentifier
        return "Simulator \(modelName(forIdentifier: identifier))"
    }

    static var defaultSimulatorIdentifier: String {
        #if os(tvOS)
            "tvOS"
        #elseif os(visionOS)
            "visionOS"
        #elseif os(iOS)
            "iOS"
        #else
            "Unknown"
        #endif
    }

    static let simulatorIdentifiers: Set<String> = ["i386", "x86_64", "arm64"]

    static let modelNamesByIdentifier: [String: String] = {
        var names = iOSModelNamesByIdentifier
        names.merge(tvOSModelNamesByIdentifier) { current, _ in current }
        names.merge(visionOSModelNamesByIdentifier) { current, _ in current }
        names.merge(homePodModelNamesByIdentifier) { current, _ in current }
        return names
    }()

    static let iOSModelNamesByIdentifier = [
        "iPod5,1": "iPod touch (5th generation)",
        "iPod7,1": "iPod touch (6th generation)",
        "iPod9,1": "iPod touch (7th generation)",
        "iPhone3,1": "iPhone 4",
        "iPhone3,2": "iPhone 4",
        "iPhone3,3": "iPhone 4",
        "iPhone4,1": "iPhone 4s",
        "iPhone5,1": "iPhone 5",
        "iPhone5,2": "iPhone 5",
        "iPhone5,3": "iPhone 5c",
        "iPhone5,4": "iPhone 5c",
        "iPhone6,1": "iPhone 5s",
        "iPhone6,2": "iPhone 5s",
        "iPhone7,2": "iPhone 6",
        "iPhone7,1": "iPhone 6 Plus",
        "iPhone8,1": "iPhone 6s",
        "iPhone8,2": "iPhone 6s Plus",
        "iPhone9,1": "iPhone 7",
        "iPhone9,3": "iPhone 7",
        "iPhone9,2": "iPhone 7 Plus",
        "iPhone9,4": "iPhone 7 Plus",
        "iPhone10,1": "iPhone 8",
        "iPhone10,4": "iPhone 8",
        "iPhone10,2": "iPhone 8 Plus",
        "iPhone10,5": "iPhone 8 Plus",
        "iPhone10,3": "iPhone X",
        "iPhone10,6": "iPhone X",
        "iPhone11,2": "iPhone XS",
        "iPhone11,4": "iPhone XS Max",
        "iPhone11,6": "iPhone XS Max",
        "iPhone11,8": "iPhone XR",
        "iPhone12,1": "iPhone 11",
        "iPhone12,3": "iPhone 11 Pro",
        "iPhone12,5": "iPhone 11 Pro Max",
        "iPhone13,1": "iPhone 12 mini",
        "iPhone13,2": "iPhone 12",
        "iPhone13,3": "iPhone 12 Pro",
        "iPhone13,4": "iPhone 12 Pro Max",
        "iPhone14,4": "iPhone 13 mini",
        "iPhone14,5": "iPhone 13",
        "iPhone14,2": "iPhone 13 Pro",
        "iPhone14,3": "iPhone 13 Pro Max",
        "iPhone14,7": "iPhone 14",
        "iPhone14,8": "iPhone 14 Plus",
        "iPhone15,2": "iPhone 14 Pro",
        "iPhone15,3": "iPhone 14 Pro Max",
        "iPhone15,4": "iPhone 15",
        "iPhone15,5": "iPhone 15 Plus",
        "iPhone16,1": "iPhone 15 Pro",
        "iPhone16,2": "iPhone 15 Pro Max",
        "iPhone17,3": "iPhone 16",
        "iPhone17,4": "iPhone 16 Plus",
        "iPhone17,1": "iPhone 16 Pro",
        "iPhone17,2": "iPhone 16 Pro Max",
        "iPhone17,5": "iPhone 16e",
        "iPhone18,3": "iPhone 17",
        "iPhone18,4": "iPhone Air",
        "iPhone18,1": "iPhone 17 Pro",
        "iPhone18,2": "iPhone 17 Pro Max",
        "iPhone18,5": "iPhone 17e",
        "iPhone8,4": "iPhone SE",
        "iPhone12,8": "iPhone SE (2nd generation)",
        "iPhone14,6": "iPhone SE (3rd generation)",
        "iPad2,1": "iPad 2",
        "iPad2,2": "iPad 2",
        "iPad2,3": "iPad 2",
        "iPad2,4": "iPad 2",
        "iPad3,1": "iPad (3rd generation)",
        "iPad3,2": "iPad (3rd generation)",
        "iPad3,3": "iPad (3rd generation)",
        "iPad3,4": "iPad (4th generation)",
        "iPad3,5": "iPad (4th generation)",
        "iPad3,6": "iPad (4th generation)",
        "iPad6,11": "iPad (5th generation)",
        "iPad6,12": "iPad (5th generation)",
        "iPad7,5": "iPad (6th generation)",
        "iPad7,6": "iPad (6th generation)",
        "iPad7,11": "iPad (7th generation)",
        "iPad7,12": "iPad (7th generation)",
        "iPad11,6": "iPad (8th generation)",
        "iPad11,7": "iPad (8th generation)",
        "iPad12,1": "iPad (9th generation)",
        "iPad12,2": "iPad (9th generation)",
        "iPad13,18": "iPad (10th generation)",
        "iPad13,19": "iPad (10th generation)",
        "iPad15,7": "iPad (A16)",
        "iPad15,8": "iPad (A16)",
        "iPad4,1": "iPad Air",
        "iPad4,2": "iPad Air",
        "iPad4,3": "iPad Air",
        "iPad5,3": "iPad Air 2",
        "iPad5,4": "iPad Air 2",
        "iPad11,3": "iPad Air (3rd generation)",
        "iPad11,4": "iPad Air (3rd generation)",
        "iPad13,1": "iPad Air (4th generation)",
        "iPad13,2": "iPad Air (4th generation)",
        "iPad13,16": "iPad Air (5th generation)",
        "iPad13,17": "iPad Air (5th generation)",
        "iPad14,8": "iPad Air (11-inch) (M2)",
        "iPad14,9": "iPad Air (11-inch) (M2)",
        "iPad14,10": "iPad Air (13-inch) (M2)",
        "iPad14,11": "iPad Air (13-inch) (M2)",
        "iPad15,3": "iPad Air (11-inch) (M3)",
        "iPad15,4": "iPad Air (11-inch) (M3)",
        "iPad15,5": "iPad Air (13-inch) (M3)",
        "iPad15,6": "iPad Air (13-inch) (M3)",
        "iPad16,8": "iPad Air (11-inch) (M4)",
        "iPad16,9": "iPad Air (11-inch) (M4)",
        "iPad16,10": "iPad Air (13-inch) (M4)",
        "iPad16,11": "iPad Air (13-inch) (M4)",
        "iPad2,5": "iPad mini",
        "iPad2,6": "iPad mini",
        "iPad2,7": "iPad mini",
        "iPad4,4": "iPad mini 2",
        "iPad4,5": "iPad mini 2",
        "iPad4,6": "iPad mini 2",
        "iPad4,7": "iPad mini 3",
        "iPad4,8": "iPad mini 3",
        "iPad4,9": "iPad mini 3",
        "iPad5,1": "iPad mini 4",
        "iPad5,2": "iPad mini 4",
        "iPad11,1": "iPad mini (5th generation)",
        "iPad11,2": "iPad mini (5th generation)",
        "iPad14,1": "iPad mini (6th generation)",
        "iPad14,2": "iPad mini (6th generation)",
        "iPad16,1": "iPad mini (A17 Pro)",
        "iPad16,2": "iPad mini (A17 Pro)",
        "iPad6,3": "iPad Pro (9.7-inch)",
        "iPad6,4": "iPad Pro (9.7-inch)",
        "iPad7,3": "iPad Pro (10.5-inch)",
        "iPad7,4": "iPad Pro (10.5-inch)",
        "iPad8,1": "iPad Pro (11-inch) (1st generation)",
        "iPad8,2": "iPad Pro (11-inch) (1st generation)",
        "iPad8,3": "iPad Pro (11-inch) (1st generation)",
        "iPad8,4": "iPad Pro (11-inch) (1st generation)",
        "iPad8,9": "iPad Pro (11-inch) (2nd generation)",
        "iPad8,10": "iPad Pro (11-inch) (2nd generation)",
        "iPad13,4": "iPad Pro (11-inch) (3rd generation)",
        "iPad13,5": "iPad Pro (11-inch) (3rd generation)",
        "iPad13,6": "iPad Pro (11-inch) (3rd generation)",
        "iPad13,7": "iPad Pro (11-inch) (3rd generation)",
        "iPad14,3": "iPad Pro (11-inch) (4th generation)",
        "iPad14,4": "iPad Pro (11-inch) (4th generation)",
        "iPad16,3": "iPad Pro (11-inch) (M4)",
        "iPad16,4": "iPad Pro (11-inch) (M4)",
        "iPad17,1": "iPad Pro (11-inch) (M5)",
        "iPad17,2": "iPad Pro (11-inch) (M5)",
        "iPad6,7": "iPad Pro (12.9-inch) (1st generation)",
        "iPad6,8": "iPad Pro (12.9-inch) (1st generation)",
        "iPad7,1": "iPad Pro (12.9-inch) (2nd generation)",
        "iPad7,2": "iPad Pro (12.9-inch) (2nd generation)",
        "iPad8,5": "iPad Pro (12.9-inch) (3rd generation)",
        "iPad8,6": "iPad Pro (12.9-inch) (3rd generation)",
        "iPad8,7": "iPad Pro (12.9-inch) (3rd generation)",
        "iPad8,8": "iPad Pro (12.9-inch) (3rd generation)",
        "iPad8,11": "iPad Pro (12.9-inch) (4th generation)",
        "iPad8,12": "iPad Pro (12.9-inch) (4th generation)",
        "iPad13,8": "iPad Pro (12.9-inch) (5th generation)",
        "iPad13,9": "iPad Pro (12.9-inch) (5th generation)",
        "iPad13,10": "iPad Pro (12.9-inch) (5th generation)",
        "iPad13,11": "iPad Pro (12.9-inch) (5th generation)",
        "iPad14,5": "iPad Pro (12.9-inch) (6th generation)",
        "iPad14,6": "iPad Pro (12.9-inch) (6th generation)",
        "iPad16,5": "iPad Pro (13-inch) (M4)",
        "iPad16,6": "iPad Pro (13-inch) (M4)",
        "iPad17,3": "iPad Pro (13-inch) (M5)",
        "iPad17,4": "iPad Pro (13-inch) (M5)"
    ]

    static let tvOSModelNamesByIdentifier = [
        "AppleTV5,3": "Apple TV HD",
        "AppleTV6,2": "Apple TV 4K",
        "AppleTV11,1": "Apple TV 4K (2nd generation)",
        "AppleTV14,1": "Apple TV 4K (3rd generation)"
    ]

    static let visionOSModelNamesByIdentifier = [
        "RealityDevice14,1": "Apple Vision Pro"
    ]

    static let homePodModelNamesByIdentifier = [
        "AudioAccessory1,1": "HomePod",
        "AudioAccessory6,1": "HomePod (2nd generation)",
        "AudioAccessory5,1": "HomePod mini",
        "AudioAccessorySingle5,1": "HomePod mini"
    ]
}
