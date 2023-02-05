import Foundation

public func fixErrors(_ prompt: String) -> String {
  """
  Correct the text into standard English and fix the grammar.
  \"""
  \(prompt)
  \"""
  Correct spelling and grammar:
  """
}

public func explain(_ prompt: String) -> String {
  """
  Explain the following text to a high schooler:
  \"""
  \(prompt)
  \"""
  Simplification:
  """
}

public func chat(_ prompt: String) -> String {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "YYYY-MM-dd"

  return """
  You are ChatGPT, a large language model trained by OpenAI. Answer conversationally. Do not answer as the user. Current date: \(dateFormatter
    .string(from: Date()))

  User: \(prompt)



  ChatGPT:
  """
}
