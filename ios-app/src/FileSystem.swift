//
//  FileSystem.swift
//  xlog
//
//  Created by king on 2022/4/22.
//

import Foundation

struct FileSystem {
    enum Path {
        static var cache: URL {
            try! FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        }

        static var document: URL {
            try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        }

        static var temp: URL {
            URL(fileURLWithPath: NSTemporaryDirectory())
        }

        static var appLogDir: URL {
            var root = document.appendingPathComponent("applog")
            if !FileManager.default.fileExists(atPath: root.path, isDirectory: nil) {
                try? FileManager.default.createDirectory(at: root, withIntermediateDirectories: true, attributes: nil)
                var values = URLResourceValues()
                values.isExcludedFromBackup = true
                try? root.setResourceValues(values)
            }
            return root
        }
    }
}
