import KeyboardKit
import SwiftUI

// MARK: - ContentView

struct ContentView: View {
  @StateObject private var keyboardState = KeyboardEnabledState(bundleId: "me.igortarasenko.SmartKey.Keyboard")
  @State private var text: String = "Write something and send it to AI\nOr don't do that"

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Try it"), footer: Text("c: \(text.count)")) {
          TextEditor(text: $text)
            .frame(height: 100)
        }
        Section(header: Text("Keyboard State"), footer: footerText) {
          KeyboardEnabledLabel(
            isEnabled: keyboardState.isKeyboardEnabled,
            enabledText: "Keyboard is enabled",
            disabledText: "Keyboard not enabled"
          )
          KeyboardEnabledLabel(
            isEnabled: keyboardState.isKeyboardActive,
            enabledText: "Keyboard is active",
            disabledText: "Keyboard is not active"
          )
          KeyboardEnabledLabel(
            isEnabled: keyboardState.isFullAccessEnabled,
            enabledText: "Full Access is enabled",
            disabledText: "Full Access is disabled"
          )
        }
        Section(header: Text("Settings")) {
          KeyboardSettingsLink()
        }
      }
      .buttonStyle(.plain)
      .navigationTitle("SmartKey")
    }
    .navigationViewStyle(.stack)
  }

  var footerText: some View {
    Text("You must enable the keyboard in System Settings, then select it with 🌐 when typing.")
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

