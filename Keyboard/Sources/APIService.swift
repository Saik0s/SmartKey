import Foundation
import OpenAI

// MARK: - APIServiceError

public enum APIServiceError: Error {
  case invalidResponse
  case invalidData
}

// MARK: - APIService

public enum APIService {
  public struct Completion: Codable {
    public let choices: [Choice]
  }

  public struct Choice: Codable {
    public let text: String
  }

  private static let openAI = OpenAI(apiToken: Secrets.openAIKey)
  public static func getCompletion(for text: String, temperature: Double, maxTokens: Int, isChatModel: Bool = false) async throws -> String {
    print("Getting completion for: \(text)")
    let response = try await openAI.completions(query: CompletionsQuery(
      model: isChatModel ? .gpt3_5Turbo : .textDavinci_003,
      prompt: text,
      temperature: temperature,
      maxTokens: maxTokens,
      topP: 1,
      frequencyPenalty: 0,
      presencePenalty: 0,
      stop: ["\n\n\n", "<|im_end|>"]
    ))
    return response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
  }
}
//
// extension OpenAI {
//   func completions(query: CompletionsQuery) async throws -> CompletionsResult {
//     try await withCheckedThrowingContinuation { continuation in
//       completions(query: query) { result in
//         switch result {
//         case let .success(result):
//           continuation.resume(returning: result)
//         case let .failure(error):
//           continuation.resume(throwing: error)
//         }
//       }
//     }
//   }
// }
