//
//  KKXlogWrapper.h
//
//
//  Created by king on 2022/1/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KKXlogLogLevel) {
    KKXlogLevelAll = 0,
    KKXlogLevelVerbose = 0,
    KKXlogLevelDebug,  // Detailed information on the flow through the system.
    KKXlogLevelInfo,   // Interesting runtime events (startup/shutdown), should be conservative and KKXlogeep to a minimum.
    KKXlogLevelWarn,   // Other runtime situations that are undesirable or unexpected, but not necessarily "wrong".
    KKXlogLevelError,  // Other runtime errors or unexpected conditions.
    KKXlogLevelFatal,  // Severe errors that cause premature termination.
    KKXlogLevelNone,   // Special level used to disable all log messages.
};

@interface KKXlogWrapper : NSObject
@property (nonatomic, assign, readonly) KKXlogLogLevel level;
- (instancetype)initWith:(NSString *)logDir logName:(NSString *)logName publicKey:(NSString *_Nullable)publicKey level:(KKXlogLogLevel)level;

- (void)flush;

- (void)asyncFlush:(bool)is_sync;

- (void)write:(NSString *)logString level:(KKXlogLogLevel)level;
@end

NS_ASSUME_NONNULL_END

