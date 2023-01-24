import SwiftUI

// MARK: - ContentView

struct ContentView: View {
  @State private var text: String = ""

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text("Hello, world!")

      TextField("Test", text: $text)
      Text("Keyboard app")
    }
    .padding()
  }
}

// MARK: - ContentView_Previews

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
