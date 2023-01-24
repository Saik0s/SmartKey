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
    guard let text = keyboardContext.textDocumentProxy.selectedText else {
      error = "No selected text"
      return
    }
    let prompt = "Rewrite the following text: \(text)\n"
    generate(prompt: prompt, temperature: 0.7, maxTokens: 500)
  }

  func rewriteClipboard() {
    guard let text = UIPasteboard.general.string else {
      error = "No text in clipboard"
      return
    }
    let prompt = "Rewrite the following text: \(text)\n"
    generate(prompt: prompt, temperature: 0.7, maxTokens: 500)
  }

  func rewriteDocument() {
    guard let text = keyboardContext.textDocumentProxy.documentContext else {
      error = "No text in document"
      return
    }
    let prompt = "Rewrite the following text: \(text)\n"
    generate(prompt: prompt, temperature: 0.7, maxTokens: 500)
  }

  func executeSelected() {
    guard let text = keyboardContext.textDocumentProxy.selectedText else {
      error = "No selected text"
      return
    }
    generate(prompt: text, temperature: 0.7, maxTokens: 500)
  }

  func executeClipboard() {
    guard let text = UIPasteboard.general.string else {
      error = "No text in clipboard"
      return
    }
    generate(prompt: text, temperature: 0.7, maxTokens: 500)
  }

  func executeDocument() {
    guard let text = keyboardContext.textDocumentProxy.documentContext else {
      error = "No text in document"
      return
    }
    generate(prompt: text, temperature: 0.7, maxTokens: 500)
  }

  func generate(prompt: String, temperature _: Double, maxTokens _: Int) {
    reset()

    isLoading = true
    Task {
      do {
        lastResult = try await APIService.getCompletion(for: prompt, temperature: 0.7, maxTokens: 300)
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
        Text("Please enable full access for this keyboard in Settings")
          .font(.headline)
          .multilineTextAlignment(.center)
          .padding(2)

        KeyboardSettingsLink()
      } else {
        TabView {
          VStack {
            if !viewModel.error.isEmpty {
              Text("Error: \(viewModel.error)").font(.headline)
                .lineLimit(0)
                .foregroundColor(.red)
            }

            Text("Result: ").font(.headline)
            ScrollView {
              Text(viewModel.lastResult)
                .lineLimit(5)
                .font(.body)
                .padding(2)
            }
            .textSelection(.enabled)

            if !viewModel.lastResult.isEmpty {
              HStack(spacing: 4) {
                Button { viewModel.reset() } label: {
                  Text("Reset")
                    .font(.caption)
                    .padding(4)

                    .background(Color.blue)
                    .cornerRadius(8)
                }
                Button { viewModel.replaceSelectionWithResult() } label: {
                  Text("Replace selection")
                    .font(.caption)
                    .padding(4)

                    .background(Color.blue)
                    .cornerRadius(8)
                }
                Button { viewModel.insertAfter() } label: {
                  Text("Insert after")
                    .font(.caption)
                    .padding(4)

                    .background(Color.blue)
                    .cornerRadius(8)
                }
              }
            }

            HStack(spacing: 8) {
              Button { viewModel.rewriteSelected() } label: {
                Text("Rewrite selected (\(keyboardContext.textDocumentProxy.selectedText?.count ?? 0)c)")
                  .font(.caption)
                  .padding(4)

                  .background(Color.blue)
                  .cornerRadius(8)
              }
              Button { viewModel.rewriteClipboard() } label: {
                Text("Rewrite from clipboard")
                  .font(.caption)
                  .padding(4)

                  .background(Color.blue)
                  .cornerRadius(8)
              }
              Button { viewModel.rewriteDocument() } label: {
                Text("Rewrite document")
                  .font(.caption)
                  .padding(4)

                  .background(Color.blue)
                  .cornerRadius(8)
              }
            }
            HStack(spacing: 8) {
              Button { viewModel.executeSelected() } label: {
                Text("Execute selected (\(keyboardContext.textDocumentProxy.selectedText?.count ?? 0)c)")
                  .font(.caption)
                  .padding(4)

                  .background(Color.blue)
                  .cornerRadius(8)
              }
              Button { viewModel.executeClipboard() } label: {
                Text("Execute from clipboard")
                  .font(.caption)
                  .padding(4)

                  .background(Color.blue)
                  .cornerRadius(8)
              }
              Button { viewModel.executeDocument() } label: {
                Text("Execute document")
                  .font(.caption)
                  .padding(4)

                  .background(Color.blue)
                  .cornerRadius(8)
              }
            }
          }
          .padding(2)
          .overlay(viewModel.isLoading
            ? Color.black.opacity(0.5).overlay(ProgressView())
            : nil)

          VStack(alignment: .leading, spacing: 4) {
            Text("Document: ").font(.headline) + Text(keyboardTextContext.documentContext ?? "No documentContext")
            Text("Selected: ").font(.headline) + Text(keyboardTextContext.selectedText ?? "No selection")
          }
          .padding(2)
        }
      }
    }
    .foregroundColor(.white)
    .keyboardAppearance(.dark)
  }
}

// MARK: - KeyboardViewController

class KeyboardViewController: KeyboardInputViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewWillSetupKeyboard() {
    super.viewWillSetupKeyboard()
    keyboardContext.keyboardType = .custom(named: "SmartKey")
    keyboardContext.keyboardType = .custom(named: "SmartKey")
    setup(with: KeyboardView(viewModel: KeyboardViewModel(keyboardContext: keyboardContext)))
  }
}
