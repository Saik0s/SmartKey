import KeyboardKit
import SwiftUI

// MARK: - CardsPagerView

struct CardsPagerView: View {
  @ObservedObject private var viewModel: KeyboardViewModel
  @EnvironmentObject private var keyboardContext: KeyboardContext

  @EnvironmentObject private var keyboardTextContext: KeyboardTextContext

  var hasSelectedText: Bool {
    keyboardContext.textDocumentProxy.selectedText?.count ?? 0 > 0
  }

  init(viewModel: KeyboardViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ZStack {
      Color(.systemGray4)

      VStack(spacing: 4) {
        Picker("Tab", selection: $viewModel.selectedIndex) {
          Text("Buttons").tag(0)
          Text("Results").tag(1)
          Text("Keyboard").tag(2)
        }
        .pickerStyle(.segmented)
        .padding(4)

        TabView(selection: $viewModel.selectedIndex) {
          buttonsCard()
            .tag(0)

          resultsCard()
            .tag(1)

          keyboardCard()
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .overlay(alignment: .bottomLeading) {
          if viewModel.isLoading {
            ProgressView()
          }
        }
      }
    }
  }

  private func keyboardCard() -> some View {
    CardView {
      SystemKeyboard()
        .clipped()
    }
  }

  private func resultsCard() -> some View {
    CardView {
      Text("Result: ").font(.headline)
      ScrollView {
        Text(viewModel.lastResult)
          .lineLimit(nil)
          .font(.body)
          .fixedSize(horizontal: false, vertical: true)
          .padding(4)
          .background(Color(.lightGray).opacity(0.3))
      }
      .textSelection(.enabled)

      if !viewModel.lastResult.isEmpty {
        HStack(spacing: 4) {
          if hasSelectedText {
            Button { viewModel.replaceSelectionWithResult() } label: {
              Text("Replace selection")
                .blueButtonStyle()
            }
          }
          Button { viewModel.insertAfter() } label: {
            Text("Insert after")
              .blueButtonStyle()
          }
          Button { viewModel.replaceDocumentWithResult() } label: {
            Text("Replace document")
              .blueButtonStyle()
          }
        }
      }
    }
  }

  private func buttonsCard() -> some View {
    CardView {
      if !viewModel.error.isEmpty {
        Text("Error: \(viewModel.error)").font(.caption)
          .lineLimit(3)
          .foregroundColor(.red)
      }

      Button { viewModel.execute() } label: {
        Text("Send to AI")
          .font(.headline)
          .padding()
          .blueButtonStyle()
      }
      .padding(12)

      HStack(spacing: 8) {
        // Button { viewModel.execute(chat, asChat: true) } label: {
        //   Text("Chat")
        //     .blueButtonStyle()
        // }
        Button { viewModel.execute { "Improve: \($0)" } } label: {
          Text("Improve")
            .blueButtonStyle()
        }
        Button { viewModel.execute(explain) } label: {
          Text("Simplify")
            .blueButtonStyle()
        }
        Button { viewModel.execute(fixErrors) } label: {
          Text("Fix")
            .blueButtonStyle()
        }
      }
      HStack(spacing: 8) {
        Button { viewModel.execute { "Rewrite in casual style: \($0)" } } label: {
          Text("Casual Rewrite")
            .blueButtonStyle()
        }
        Button { viewModel.execute { "Rewrite in professional style: \($0)" } } label: {
          Text("Professional Rewrite")
            .blueButtonStyle()
        }
      }
    }
    .overlay {
      if viewModel.isLoading {
        Color.black.opacity(0.7)
          .overlay {
            VStack(spacing: 4) {
              ProgressView()
              Text("Generating...")
                .padding(.bottom, 4)
              Text("It may take up to 10 seconds\ndepending on the length of the text.")
                .font(.footnote)
            }
            .multilineTextAlignment(.center)
          }
          .padding(8)
      }
    }
  }
}

extension View {
  func blueButtonStyle() -> some View {
    font(.body)
      .foregroundColor(.white)
      .padding(8)
      .background(Color(.systemBlue))
      .cornerRadius(8)
      .shadow(color: Color(.black).opacity(0.5), radius: 2, y: 2)
      .padding(2)
  }
}

// MARK: - CardView

struct CardView<Content: View>: View {
  let content: Content

  init(@ViewBuilder content: () -> Content) {
    self.content = content()
  }

  var body: some View {
    ZStack {
      Color(.systemGray3)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(8)
        .shadow(color: .black.opacity(0.5), radius: 4, y: 3)

      VStack(spacing: 4) {
        content
      }
      .frame(maxHeight: .infinity)
      .padding(16)
    }
  }
}
