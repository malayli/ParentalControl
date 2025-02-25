import Foundation
import os

/// Logs messages in the console.
///
/// - note: This is the log levels order: trace, debug, info, notice, warning, error, critical.
/// - note: messages are only logged in debug mode.
///
/// - reference: https://apple.github.io/swift-log/docs/current/Logging/Structs/Logger/Level.html
public enum PLogger {
    private static let logger = Logger()

    public static func error(_ message: String) {
        #if DEBUG
        logger.error("🔴 PLogger: \(message)")
        #endif
    }

    public static func warning(_ message: String) {
        #if DEBUG
        logger.warning("🟡 PLogger: \(message)")
        #endif
    }

    public static func notice(_ message: String) {
        #if DEBUG
        logger.notice("🟢 PLogger: \(message)")
        #endif
    }

    public static func info(_ message: String) {
        #if DEBUG
        logger.info("🔵 PLogger: \(message)")
        #endif
    }

    public static func debug(_ message: String) {
        #if DEBUG
        logger.debug("🟣 PLogger: \(message)")
        #endif
    }

    public static func trace(_ message: String) {
        #if DEBUG
        logger.trace("⚪ PLogger: \(message)")
        #endif
    }
}
