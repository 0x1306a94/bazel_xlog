import Foundation
import KKXlog

public final class Xlog {
   private let wrapper: KKXlogWrapper
    private let consoleLog: Bool
    public init(logdir: String, logname: String, publicKey: String? = nil, level: KKXlogLogLevel, consoleLog: Bool) {
       self.wrapper = KKXlogWrapper(logdir, logName: logname, publicKey: publicKey, level: level)
        self.consoleLog = consoleLog
    }
}

public extension Xlog {
    func flush(async: Bool = true) {
       self.wrapper.asyncFlush(async)
    }

   func log(level: KKXlogLogLevel = .levelNone, tag: String = "default", message: @autoclosure @escaping () -> String, metadata: [String: Any] = [:], fileName: String = #file, funcName: String = #function, line: Int = #line) {
       let time = DateFormatter.log.string(from: Date())

       let basename = (fileName as NSString).lastPathComponent
       var str = "ShowStartPro: |\(time)|\(level.description)|\(tag)|\(basename):\(line)|\(funcName)|message: \(message())|"
       if !metadata.isEmpty {
           let s = metadata.map { "\($0):\(String(describing: $1))" }.joined(separator: "|")
           str = "\(str)\t|extra|\(s)"
       }
       #if DEBUG
       print(str)
       #endif
       self.wrapper.write(str, level: level)
   }

   func callAsFunction(level: KKXlogLogLevel = .levelNone, tag: String = "default", message: @autoclosure @escaping () -> String, metadata: [String: Any] = [:], fileName: String = #file, funcName: String = #function, line: Int = #line) {
       log(level: level, tag: tag, message: message(), metadata: metadata, fileName: fileName, funcName: funcName, line: line)
   }
}

extension KKXlogLogLevel: Equatable {}

extension KKXlogLogLevel: CustomStringConvertible {
   public var description: String {
       switch self {
       case .levelAll:
           return "all"
       case .levelVerbose:
           return "V"
       case .levelDebug:
           return "D"
       case .levelInfo:
           return "I"
       case .levelWarn:
           return "W"
       case .levelError:
           return "E"
       case .levelFatal:
           return "F"
       case .levelNone:
           return "none"
       @unknown default:
           return "unknown"
       }
   }
}

extension DateFormatter {
    static let log: DateFormatter = {
        let formatter = DateFormatter()
        // 2019.09.28
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss:SSS"
        return formatter
    }()
}
