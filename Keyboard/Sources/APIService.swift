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
    let response = try await openAI.chats(query: ChatQuery(
      model: isChatModel ? .gpt4 : .textDavinci_003,
      messages: [Chat(role: .user, content: text)],
      temperature: temperature,
      topP: 1,
      stop: ["\n\n\n", "<|im_end|>"],
      maxTokens: maxTokens,
      presencePenalty: 0,
      frequencyPenalty: 0
    ))
    return response.choices.first?.message.content.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
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
