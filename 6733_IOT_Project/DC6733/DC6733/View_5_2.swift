//
//  View_5_2.swift
//  DC6733
//
//  Created by Jo on 2025/7/16.
//

import SwiftUI
import CoreMotion
import Combine
import Foundation
import SwiftOpenAI

extension Array {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

struct View5_2: View {

    let selectedModel: String
    let data_analyze: [MotionSample]

    @State private var msg_show: [String] = []
    @State private var displayedLines: [String] = []
    @State private var isLineFinished: [Bool] = []

    @State private var currentLineIndex = 0
    @State private var currentCharIndex = 0
    @State private var resultText: String?
    @State private var isLoading = false
    @State private var timer: Timer?
    @State private var analysisFinished = false

    func appendMessageAndStartTyping(_ newMessage: String) {
        msg_show.append(newMessage)
        displayedLines.append("")
        isLineFinished.append(false)

        // Only start typing if not already typing another line
        if currentLineIndex == msg_show.count - 1 {
            startTypingNextLine()
        }
    }

    func startTypingNextLine() {
        
        guard currentLineIndex < msg_show.count else {
            analysisFinished = true
            return
        }

        let line = msg_show[currentLineIndex]
        currentCharIndex = 0

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true) { t in
            if currentCharIndex < line.count {
                let index = line.index(line.startIndex, offsetBy: currentCharIndex)
                displayedLines[currentLineIndex] += String(line[index])
                currentCharIndex += 1
            } else {
                t.invalidate()
                isLineFinished[currentLineIndex] = true
                currentLineIndex += 1

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                    startTypingNextLine()
                }
            }
        }
    }

    func analyzeWithGPT() {
        isLoading = true
        resultText = nil

        let data = data_analyze

        let userPrompt =  """
            !!!!!Think step by step!!!!!!!
            You are a professional activity recognition Human Expert.
            Given IMU data with format[time, accelerator_x]:
            IMU Data: \(data)
            Provide ONE of: running, standing, walking, climbing stairs, swimming, Unknown.
            !!!!!Think step by step and Return bridfly!!!!!!!
            response in few sentences
            """

        let messages: [MessageChatGPT] = [
            MessageChatGPT(text: "You are an activity recognition expert.", role: .system),
            MessageChatGPT(text: userPrompt, role: .user)
        ]

        Task {
            do {
                let response = try await openAI.createChatCompletions(
                    model: .gpt4o(.base),
                    messages: messages
                )
                if let result = response?.choices.first?.message.content {
                    resultText = result
                    appendMessageAndStartTyping("*** The Result***:\n \(result)")
                    appendMessageAndStartTyping("End of session.")
                } else {
                    appendMessageAndStartTyping("No response from GPT")
                }
            } catch {
                appendMessageAndStartTyping("Error: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    
    
    
    func GetResultwithBackEnd() {
        let data = data_analyze
        
        
        guard let url = URL(string: "http://172.20.10.9:8251/latest") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                if let res = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Activity: \(res["activity"] ?? "")")
                    appendMessageAndStartTyping("*** The Result***:\n \(res)")
                    appendMessageAndStartTyping("End of session.")
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }

        task.resume()
        
    }
    
    
    struct IMURequest: Codable {
        let user_id: String
        let samples: [MotionSample]
    }

    func analyzewithBackEnd() {
      
        let sampleData = data_analyze
        let imuRequest = IMURequest(user_id: "ios_user_1", samples: sampleData)

        guard let url = URL(string: "http://172.20.10.9:8251/imu-data") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(imuRequest)
            request.httpBody = jsonData
        } catch {
            print("Encoding error: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("Activity: \(json["activity"] ?? "")")
                }
            } catch {
                print("Failed to parse JSON: \(error)")
            }
        }

        task.resume()
    }
    
    
    

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Step 3").font(.title).padding().frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(displayedLines.indices, id: \.self) { i in
                    let finished = isLineFinished[safe: i] == true
                    Text(displayedLines[i])
                        .font(finished ? .footnote : .title3)
                        .foregroundColor(finished ? .gray : .primary)
                        .animation(.easeInOut(duration: 0.3), value: finished)
                }
            }
            .padding()
            .onAppear {
                let initialMessages = [
                    "We will use \(selectedModel) to analyze your data.",
                    "Initializing model...",
                    "Constructing prompt...",
                    "Loading data...",
                    "Analyzing data..."
                ]
                for msg in initialMessages {
                    appendMessageAndStartTyping(msg)
                }
                if selectedModel == "GPT" {
                    analyzeWithGPT()
                } else if selectedModel == "Cloud Back End" {
                    analyzewithBackEnd()
                    GetResultwithBackEnd()
                    
                }
            }
            
            if analysisFinished {
                Divider().padding(.top)
                NavigationLink(destination: View6_2()) {
                    Text("Finished")
                        .font(.title2)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.top, 20)
            }
            
            
        }
    }

    #Preview {
        ContentView()
    }
}
