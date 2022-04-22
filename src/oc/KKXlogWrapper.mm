//
//  KKXlogWrapper.m
//
//
//  Created by king on 2022/1/27.
//

#import "KKXlogWrapper.h"

#import <algorithm>
#import <assert.h>
#import <limits.h>
#import <stdio.h>
#import <sys/xattr.h>

#import <mars/xlog/xlogger_interface.h>

using namespace mars::xlog;

@interface KKXlogWrapper ()
@property (nonatomic, copy) NSString *logDir;
@property (nonatomic, copy) NSString *logName;
@property (nonatomic, copy) NSString *publicKey;
@property (nonatomic, assign) KKXlogLogLevel level;
@end
@implementation KKXlogWrapper
- (instancetype)initWith:(NSString *)logDir logName:(NSString *)logName publicKey:(NSString *)publicKey level:(KKXlogLogLevel)level {
    if (self == [super init]) {
        self.logDir = logDir;
        self.logName = logName;
        self.publicKey = publicKey;
        self.level = level;
    }
    return self;
}

- (void)flush {
    [self asyncFlush:true];
}

- (void)asyncFlush:(bool)is_sync {
    mars::comm::XloggerCategory *logger = mars::xlog::GetXloggerInstance(self.logName.UTF8String);
    if (logger == nullptr) {
        return;
    }
    mars::xlog::Flush(uintptr_t(logger), is_sync);
}

- (void)write:(NSString *)logString level:(KKXlogLogLevel)level {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        XLogConfig config;
        config.logdir_ = self.logDir.UTF8String;
        config.nameprefix_ = self.logName.UTF8String;
        if (self.publicKey != nil && self.publicKey.length > 0) {
            config.pub_key_ = self.publicKey.UTF8String;
        }

        mars::comm::XloggerCategory *logger = mars::xlog::NewXloggerInstance(config, (TLogLevel)self.level);
        mars::xlog::SetConsoleLogOpen(uintptr_t(logger), false);
        // 单个日志文件最大文件大小 64k
        mars::xlog::SetMaxFileSize(uintptr_t(logger), 64 * 1024);
        // 日志存活时间
        mars::xlog::SetMaxAliveTime(uintptr_t(logger), 7 * 24 * 60 * 60);
    });

    mars::comm::XloggerCategory *logger = mars::xlog::GetXloggerInstance(self.logName.UTF8String);
    if (logger == nullptr) {
        return;
    }

    if (mars::xlog::IsEnabledFor(uintptr_t(logger), (TLogLevel)level) == false) {
        return;
    }

    mars::xlog::XloggerWrite(uintptr_t(logger), NULL, logString.UTF8String);
}
@end

