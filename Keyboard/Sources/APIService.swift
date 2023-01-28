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
  public static func getCompletion(for text: String, temperature: Double, maxTokens: Int) async throws -> String {
    print("Getting completion for: \(text)")
    let response = try await openAI.completions(query: OpenAI.CompletionsQuery(
      model: .textDavinci_003,
      prompt: text,
      temperature: temperature,
      max_tokens: maxTokens,
      top_p: 1,
      frequency_penalty: 0,
      presence_penalty: 0
    ))
    return response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
  }
}

extension OpenAI {
  func completions(query: CompletionsQuery) async throws -> CompletionsResult {
    try await withCheckedThrowingContinuation { continuation in
      completions(query: query) { result in
        switch result {
        case let .success(result):
          continuation.resume(returning: result)
        case let .failure(error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
