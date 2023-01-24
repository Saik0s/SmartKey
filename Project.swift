import Foundation
import ProjectDescription

let projectSettings: SettingsDictionary = [
  "GCC_TREAT_WARNINGS_AS_ERRORS": "YES",
  "SWIFT_TREAT_WARNINGS_AS_ERRORS": "YES",
  "OTHER_SWIFT_FLAGS[config=Debug][sdk=*][arch=*]": "-D DEBUG $(inherited) -Xfrontend -warn-long-function-bodies=500 -Xfrontend -warn-long-expression-type-checking=500 -Xfrontend -debug-time-function-bodies -Xfrontend -enable-actor-data-race-checks",
  "OTHER_LDFLAGS[config=Debug][sdk=*][arch=*]": "$(inherited) -Xlinker -interposable -all_load",
  "CODE_SIGN_STYLE": "Automatic",
  "IPHONEOS_DEPLOYMENT_TARGET": "16.0",
]

let project = Project(
  name: "SmartKey",
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2
    )
  ),
  settings: .settings(configurations: [
    .debug(name: "Debug", settings: projectSettings, xcconfig: nil),
    .release(name: "Release", settings: projectSettings, xcconfig: nil),
  ]),
  targets: [
    Target(
      name: "SmartKey",
      platform: .iOS,
      product: .app,
      bundleId: "me.igortarasenko.SmartKey",
      deploymentTarget: .iOS(targetVersion: "16.0", devices: .iphone),
      infoPlist: .extendingDefault(with: [
        "CFBundleURLTypes": [
          [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLName": "SmartKey",
            "CFBundleURLSchemes": [
              "smartkey",
            ],
          ],
        ],
        "UIApplicationSceneManifest": [
          "UIApplicationSupportsMultipleScenes": false,
          "UISceneConfigurations": [
          ],
        ],
        "ITSAppUsesNonExemptEncryption": false,
        "UILaunchScreen": [
          "UILaunchScreen": [:],
        ],
      ]),
      sources: .paths([.relativeToManifest("App/Sources/**")]),
      resources: [
        "App/Resources/**",
      ],
      dependencies: [
        .external(name: "AppDevUtils"),
        .external(name: "Inject"),
        .target(name: "SmartKeyKeyboard"),
        .external(name: "KeyboardKit"),
      ]
    ),
    Target(
      name: "SmartKeyKeyboard",
      platform: .iOS,
      product: .appExtension,
      bundleId: "me.igortarasenko.SmartKey.Keyboard",
      infoPlist: .extendingDefault(with: [
        "CFBundleDisplayName": "SmartKey Keyboard",
        "NSExtension": [
          "NSExtensionAttributes": [
            "PrimaryLanguage": "en-US",
            "PrefersRightToLeft": false,
            "IsASCIICapable": false,
            "RequestsOpenAccess": true,
          ],
          "NSExtensionPointIdentifier": "com.apple.keyboard-service",
          "NSExtensionPrincipalClass": "$(PRODUCT_MODULE_NAME).KeyboardViewController",
        ],
      ]),
      sources: .paths([.relativeToManifest("Keyboard/Sources/**")]),
      resources: [
        "Keyboard/Resources/**",
      ],
      dependencies: [
        .external(name: "KeyboardKit"),
        .external(name: "OpenAI"),
      ]
    ),
  ]
)
