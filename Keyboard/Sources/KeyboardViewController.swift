import KeyboardKit
import SwiftUI
import UIKit

// MARK: - KeyboardView

struct KeyboardView: View {
  @ObservedObject private var viewModel: KeyboardViewModel

  @EnvironmentObject private var keyboardContext: KeyboardContext

  @EnvironmentObject private var keyboardTextContext: KeyboardTextContext

  init(viewModel: KeyboardViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ZStack {
      if !keyboardContext.hasFullAccess {
        VStack {
          Text("Please enable full access for this keyboard in Settings")
            .font(.headline)
            .multilineTextAlignment(.center)
            .padding(2)

          KeyboardSettingsLink()
        }
      } else {
        CardsPagerView(viewModel: viewModel)
          .frame(height: KeyboardLayoutConfiguration.standard(for: keyboardContext).rowHeight * 5)
      }
    }
  }
}

// MARK: - KeyboardViewController

class KeyboardViewController: KeyboardInputViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillSetupKeyboard() {
    super.viewWillSetupKeyboard()
    setup(with: KeyboardView(viewModel: KeyboardViewModel(keyboardContext: keyboardContext)))
  }
}
