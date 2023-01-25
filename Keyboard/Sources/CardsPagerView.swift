import SwiftUI
import KeyboardKit

// MARK: - CardsPagerView

struct CardsPagerView: View {
  @ObservedObject private var viewModel: KeyboardViewModel
  @EnvironmentObject private var keyboardContext: KeyboardContext

  @EnvironmentObject private var keyboardTextContext: KeyboardTextContext

  init(viewModel: KeyboardViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {
    ZStack {
      Color(.systemGray4)

      VStack(spacing: 4) {
        if !viewModel.error.isEmpty {
          Text("Error: \(viewModel.error)").font(.caption)
            .lineLimit(3)
            .foregroundColor(.red)
        }

        TabView {
          CardView {
            HStack(spacing: 8) {
              Button { viewModel.rewriteSelected() } label: {
                Text("Rewrite selected (\(keyboardContext.textDocumentProxy.selectedText?.count ?? 0)c)")
                  .blueButtonStyle()
              }
              // Button { viewModel.rewriteClipboard() } label: {
              //   Text("Rewrite from clipboard")
              //     .blueButtonStyle()
              // }
              Button { viewModel.rewriteDocument() } label: {
                Text("Rewrite document")
                  .blueButtonStyle()
              }
            }
            HStack(spacing: 8) {
              Button { viewModel.executeSelected() } label: {
                Text("Execute selected (\(keyboardContext.textDocumentProxy.selectedText?.count ?? 0)c)")
                  .blueButtonStyle()
              }
              // Button { viewModel.executeClipboard() } label: {
              //   Text("Execute from clipboard")
              //     .blueButtonStyle()
              // }
              Button { viewModel.executeDocument() } label: {
                Text("Continue document")
                  .blueButtonStyle()
              }
            }
          }
            .padding(.bottom, KeyboardLayoutConfiguration.standard(for: keyboardContext).rowHeight)

          CardView {
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
                    .blueButtonStyle()
                }
                Button { viewModel.replaceSelectionWithResult() } label: {
                  Text("Replace selection")
                    .blueButtonStyle()
                }
                Button { viewModel.insertAfter() } label: {
                  Text("Insert after")
                    .blueButtonStyle()
                }
              }
            }
          }
            .padding(.bottom, KeyboardLayoutConfiguration.standard(for: keyboardContext).rowHeight)

          CardView {
            SystemKeyboard()
              .clipped()
          }
            .padding(.bottom, KeyboardLayoutConfiguration.standard(for: keyboardContext).rowHeight)

        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
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
