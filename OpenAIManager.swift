//
//  OpenAIManager.swift
//  charleyChat
//
//  Created by Charley Ho on 1/15/24.
//

import Foundation
import OpenAI

struct OpenAIManager {
    static private var APIKey = "<add your api key here>"

    var openAI = OpenAI(apiToken: Self.APIKey)

    func getResult(_ message: String) async -> String {
        do {
            let chatQuery = ChatQuery(model: .gpt3_5Turbo, messages: [
                Chat(role: .user, content: message)
            ])

            let result = try await openAI.chats(query: chatQuery)
            let choice = result.choices[0]
            if let outputMessage = choice.message.content {
                return outputMessage
            }
        } catch {
            print("Error thrown", error)
        }
        return "boo failed"
    }

    func getResultStream(_ message: String, streamResult: @escaping (String?) -> Void ) {
            let chatQuery = ChatQuery(model: .gpt3_5Turbo, messages: [
                Chat(role: .user, content: message)
            ])

            openAI.chatsStream(query: chatQuery) { partialResult in
                switch partialResult {
                case .success(let result):
                    if let resultText = result.choices[0].delta.content {
                        streamResult(resultText)
                    }
                case .failure(let error):
                    streamResult(error.localizedDescription)
                }
            } completion: { error in
                streamResult(error?.localizedDescription)
            }
    }
}
