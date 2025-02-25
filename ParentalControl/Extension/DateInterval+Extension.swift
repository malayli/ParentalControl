import Foundation

extension DateInterval {
    static var present: DateInterval {
        DateInterval(start: .now, duration: 3600)
    }
}
