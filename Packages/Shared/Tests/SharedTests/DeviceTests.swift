import Testing
@testable import Shared

struct DeviceTests {

    @Test
    func latestIPhoneModelNames() {
        #expect(Device.modelName(forIdentifier: "iPhone17,5") == "iPhone 16e")
        #expect(Device.modelName(forIdentifier: "iPhone18,3") == "iPhone 17")
        #expect(Device.modelName(forIdentifier: "iPhone18,4") == "iPhone Air")
        #expect(Device.modelName(forIdentifier: "iPhone18,1") == "iPhone 17 Pro")
        #expect(Device.modelName(forIdentifier: "iPhone18,2") == "iPhone 17 Pro Max")
        #expect(Device.modelName(forIdentifier: "iPhone18,5") == "iPhone 17e")
    }

    @Test
    func latestIPadModelNames() {
        #expect(Device.modelName(forIdentifier: "iPad15,7") == "iPad (A16)")
        #expect(Device.modelName(forIdentifier: "iPad15,3") == "iPad Air (11-inch) (M3)")
        #expect(Device.modelName(forIdentifier: "iPad15,5") == "iPad Air (13-inch) (M3)")
        #expect(Device.modelName(forIdentifier: "iPad16,8") == "iPad Air (11-inch) (M4)")
        #expect(Device.modelName(forIdentifier: "iPad16,10") == "iPad Air (13-inch) (M4)")
        #expect(Device.modelName(forIdentifier: "iPad16,1") == "iPad mini (A17 Pro)")
        #expect(Device.modelName(forIdentifier: "iPad17,1") == "iPad Pro (11-inch) (M5)")
        #expect(Device.modelName(forIdentifier: "iPad17,3") == "iPad Pro (13-inch) (M5)")
    }

    @Test
    func appleTVAndHomePodModelNames() {
        #expect(Device.modelName(forIdentifier: "AppleTV14,1") == "Apple TV 4K (3rd generation)")
        #expect(Device.modelName(forIdentifier: "AudioAccessory6,1") == "HomePod (2nd generation)")
        #expect(Device.modelName(forIdentifier: "AudioAccessorySingle5,1") == "HomePod mini")
    }

    @Test
    func modelDescriptionIncludesNameAndIdentifier() {
        #expect(Device.modelDescription(forIdentifier: "iPhone18,1") == "iPhone 17 Pro (iPhone18,1)")
    }

    @Test
    func unknownIdentifierFallsBackToIdentifier() {
        #expect(Device.modelName(forIdentifier: "UnknownDevice1,1") == "UnknownDevice1,1")
        #expect(Device.modelDescription(forIdentifier: "UnknownDevice1,1") == "UnknownDevice1,1")
    }
}
