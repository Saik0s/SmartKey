import KeyboardKit
import SwiftUI
import UIKit

// MARK: - KeyboardView

struct KeyboardView: View {
  @EnvironmentObject
  private var keyboardContext: KeyboardContext

  var body: some View {
    VStack(spacing: 0) {
      SystemKeyboard()
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
    setup(with: KeyboardView())
  }
}
