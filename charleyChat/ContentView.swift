//
//  ContentView.swift
//  charleyChat
//
//  Created by Charley Ho on 1/15/24.
//

import SwiftUI


struct ContentView: View {
    @State private var input = ""
    @State private var result: String = ""
    @State private var isLoading = false
    private var openAIManager = OpenAIManager()

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                TextField("Enter text here", text: $input, onCommit: onSubmitStream)
                    .padding()
                    .border(Color.gray, width: 1)

                Button("Submit", action: onSubmit)
                    .padding()

                Text(result)
            }
        }
        .padding()
    }

    private func onSubmit() {
        guard !self.isLoading else {
            return
        }
        self.isLoading = true
        result = ""
        Task {
            result = await openAIManager.getResult(input)
            self.isLoading = false
        }
    }

    private func onSubmitStream() {
        guard !self.isLoading else {
            return
        }
        self.isLoading = true
        result = ""
        openAIManager.getResultStream(input) { streamData in
            self.isLoading = false
            if let streamData {
                result = result + streamData
            }
        }
    }

}

#Preview {
    ContentView()
}

