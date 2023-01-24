import SwiftUI
import KeyboardKit

// MARK: - ContentView

struct ContentView: View {
  @State private var appearance = ColorScheme.light
  @State private var isAppearanceDark = false
  @StateObject private var keyboardState = KeyboardEnabledState(bundleId: "me.igortarasenko.SmartKey.Keyboard")
  @State private var text: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

  var body: some View {
    NavigationView {
      List {
        Section(header: Text("Text Field")) {
          TextEditor(text: $text)
            .frame(height: 100)
            .keyboardAppearance(appearance)
          Toggle(isOn: $isAppearanceDark) {
            Text("Dark appearance")
          }
        }
        Section(header: Text("Keyboard State"), footer: footerText) {
          KeyboardEnabledLabel(
            isEnabled: keyboardState.isKeyboardEnabled,
            enabledText: "Demo keyboard is enabled",
            disabledText: "Demo keyboard not enabled")
          KeyboardEnabledLabel(
            isEnabled: keyboardState.isKeyboardActive,
            enabledText: "Demo keyboard is active",
            disabledText: "Demo keyboard is not active")
          KeyboardEnabledLabel(
            isEnabled: keyboardState.isFullAccessEnabled,
            enabledText: "Full Access is enabled",
            disabledText: "Full Access is disabled")
        }
        Section(header: Text("Settings")) {
          KeyboardSettingsLink()
        }
      }
        .buttonStyle(.plain)
        .navigationTitle("KeyboardKit")
        .onChange(of: isAppearanceDark) { newValue in
          appearance = isAppearanceDark ? .dark : .light
        }
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
