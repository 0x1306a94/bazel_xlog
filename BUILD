load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")
load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load("@rules_cc//cc:defs.bzl", "objc_library")
load(
    "@build_bazel_rules_apple//apple:apple.bzl",
    "apple_dynamic_xcframework_import",
    "apple_static_xcframework_import",
)

apple_static_xcframework_import(
    name="mars_static_xcframework",
    # library_identifiers={
    #     "ios_device": "ios-arm64",
    #     "ios_simulator": "ios-arm64_x86_64-simulator",
    # },
    sdk_dylibs=[
        "libc++",
        "libz",
    ],
    sdk_frameworks=[
        "SystemConfiguration",
    ],
    xcframework_imports=glob(["xcframeworks/mars.xcframework/**"]),
)

objc_library(
    name="KKXlog",
    srcs=[
        "src/oc/KKXlog.h",
        "src/oc/KKXlogWrapper.h",
        "src/oc/KKXlogWrapper.mm",
    ],
    hdrs=glob(["src/oc/*.h"]),
    enable_modules=1,
    module_name="KKXlog",
    deps=[
        ":mars_static_xcframework"
    ],
    visibility=["//visibility:public"],
)

swift_library(
    name="XlogSwift",
    srcs=[
        "src/swift/xlog.swift",
    ],
    visibility=["//visibility:public"],
    deps=[
        ":KKXlog"
    ]
)

filegroup(
    name="APP_Assets",
    srcs=glob(["ios-app/Resources/xcassets/Assets.xcassets/**"]),
    visibility=["//visibility:public"],
)

swift_library(
    name="App_Classes",
    srcs=glob(["ios-app/src/**/*.swift"]),
    data=[
        ":APP_Assets",
        "ios-app/Resources/xib/Main.storyboard",
    ],
    deps=[
        ":XlogSwift",
    ],
)

ios_application(
    name="App-iOS",
    bundle_id="com.taihe.xlogsample",
    minimum_os_version="13.0",
    families=["iphone"],
    launch_storyboard=":ios-app/Resources/xib/LaunchScreen.storyboard",
    infoplists=[":ios-app/Info.plist"],
    visibility=["//visibility:public"],
    deps=[
        ":App_Classes",
    ],
)
