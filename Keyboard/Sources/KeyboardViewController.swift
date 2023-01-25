import KeyboardKit
import SwiftUI
import UIKit

// MARK: - KeyboardViewModel

@MainActor
final class KeyboardViewModel: ObservableObject {
  @Published var lastResult: String = "-"
  @Published var error: String = ""
  @Published var isLoading: Bool = false

  private var keyboardContext: KeyboardContext

  init(keyboardContext: KeyboardContext) {
    self.keyboardContext = keyboardContext
  }

  func reset() {
    error = ""
    lastResult = "-"
  }

  func replaceSelectionWithResult() {
    keyboardContext.textDocumentProxy.replaceCurrentWord(with: lastResult)
  }

  func insertAfter() {
    keyboardContext.textDocumentProxy.insertText(lastResult)
  }

  func rewriteSelected() {
    executeSelected { "Rewrite the following text: \($0)\n" }
  }

  func rewriteClipboard() {
    executeClipboard { "Rewrite the following text: \($0)\n" }
  }

  func rewriteDocument() {
    executeDocument { "Rewrite the following text: \($0)\n" }
  }

  func executeSelected(_ transformPrompt: (String) -> String = { $0 }) {
    guard let text = keyboardContext.textDocumentProxy.selectedText else {
      error = "No selected text"
      return
    }
    let prompt = transformPrompt(text)
    generate(prompt: prompt, temperature: 0.7, maxTokens: 500)
  }

  func executeClipboard(_ transformPrompt: (String) -> String = { $0 }) {
    guard let text = UIPasteboard.general.string else {
      error = "No text in clipboard"
      return
    }

    let prompt = transformPrompt(text)
    generate(prompt: prompt, temperature: 0.7, maxTokens: 500)
  }

  func executeDocument(_ transformPrompt: (String) -> String = { $0 }) {
    guard let text = keyboardContext.textDocumentProxy.documentContext else {
      error = "No text in document"
      return
    }

    let prompt = transformPrompt(text)
    generate(prompt: prompt, temperature: 0.7, maxTokens: 500)
  }

  func generate(prompt: String, temperature: Double, maxTokens: Int) {
    reset()

    isLoading = true
    Task {
      do {
        lastResult = try await APIService.getCompletion(for: prompt, temperature: temperature, maxTokens: maxTokens)
      } catch {
        print(error.localizedDescription)
        self.error = error.localizedDescription
      }
      isLoading = false
    }
  }
}

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
    .overlay {
      if viewModel.isLoading {
        Color.black.opacity(0.5).overlay(ProgressView())
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
