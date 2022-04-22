//
//  Xlog.swift
//  xlog
//
//  Created by king on 2022/4/22.
//

import Foundation
import XlogSwift
import KKXlog

let logdir = FileSystem.Path.appLogDir.path
let logname = "test"
#if DEBUG
let level: KKXlogLogLevel = .levelAll
let consoleLog = true
#else
let level: KKXlogLogLevel = .levelInfo
let consoleLog = false
#endif

let LOG = Xlog(logdir: logdir, logname: logname, publicKey: nil, level: level, consoleLog: consoleLog)
