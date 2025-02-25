import Foundation

extension Bundle {

    var appGroupName: String {
        guard let value = Bundle.main.infoDictionary?["APP_GROUP_NAME"] as? String else {
            fatalError("APP_GROUP_NAME not set in Info.plist")
        }
        return value
    }
}
