import Foundation
import KeyboardKit
import UIKit

@MainActor
final class KeyboardViewModel: ObservableObject {
  @Published var lastResult: String = "-"
  @Published var error: String = ""
  @Published var isLoading: Bool = false
  @Published var selectedIndex = 0

  private var keyboardContext: KeyboardContext
  weak var controller: KeyboardInputViewController?

  init(keyboardContext: KeyboardContext, controller: KeyboardInputViewController) {
    self.keyboardContext = keyboardContext
    self.controller = controller
  }

  func reset() {
    error = ""
    lastResult = "-"
  }

  func replaceSelectionWithResult() {
    if keyboardContext.textDocumentProxy.selectedText?.count ?? 0 > 0 {
      keyboardContext.textDocumentProxy.deleteBackward()
    }
    insertAfter()
  }

  func insertAfter() {
    keyboardContext.textDocumentProxy.insertText(lastResult)
  }

  func replaceDocumentWithResult() {
    while keyboardContext.textDocumentProxy.documentContext?.count ?? 0 > 0 {
      keyboardContext.textDocumentProxy.adjustTextPosition(byCharacterOffset: keyboardContext.textDocumentProxy.documentContextAfterInput?.count ?? 0)
      keyboardContext.textDocumentProxy.deleteBackward(times: keyboardContext.textDocumentProxy.documentContext?.count ?? 0)
    }
    keyboardContext.textDocumentProxy.insertText(lastResult)
  }

  func execute(_ transformPrompt: @escaping (String) -> String = { $0 }, asChat: Bool = false) {
    let text = keyboardContext.textDocumentProxy.selectedText
      ?? keyboardContext.textDocumentProxy.documentContext

    guard let text else {
      error = "No text in document"
      return
    }

    let prompt = transformPrompt(text)
    generate(prompt: prompt, temperature: 0.7, maxTokens: 1000, asChat: asChat)
  }

  func generate(prompt: String, temperature: Double, maxTokens: Int, asChat: Bool = false) {
    reset()

    isLoading = true
    Task {
      do {
        lastResult = try await APIService.getCompletion(for: prompt, temperature: temperature, maxTokens: maxTokens, isChatModel: asChat)
        selectedIndex = 1
      } catch {
        print(error.localizedDescription)
        self.error = error.localizedDescription
        selectedIndex = 0
      }
      isLoading = false
    }
  }
}
