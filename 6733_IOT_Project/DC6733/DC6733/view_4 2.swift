//
//  view_4.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

//
//  View2.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

import SwiftUI
import CoreMotion
import Combine
import Foundation

struct View4_2: View {
    let csvFileName: String
    @EnvironmentObject var appState: AppState
    @State private var samples: [MotionSample] = []
    @State private var Samples_filtered: [MotionSample] = []
    @State private var messages = []
    @State private var progress: Double = 0.0
    @State private var displayedText = ""
    @State private var resultText: String?
    @State private var isLoading = false
    @State private var Samplestart = false
    

    
    @State private var DownSampleFinished = false
    @State private var model_selection = false
    
    @State private var currentIndex = 0

    
    func CSV_read(fileName: String) -> [MotionSample] {
        print("4-2 csv read")
        var samples: [MotionSample] = []

        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(fileName)
        
        do {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            
            // Skip header
            for line in lines.dropFirst() where !line.isEmpty {
                let fields = line.split(separator: ",").map { Double($0) ?? 0.0 }
                if fields.count == 10 {
                    let sample = MotionSample(
                        timestamp: fields[0],
                        accX: fields[1], accY: fields[2], accZ: fields[3],
                        gyroX: fields[4], gyroY: fields[5], gyroZ: fields[6],
                        magX: fields[7], magY: fields[8], magZ: fields[9]
                    )
                    samples.append(sample)
                }
            }
        } catch {
            print("Error reading file: \(error)")
        }

        return samples
    }
    func sampleData() {
        print("---4_2_sample data------")
        Samples_filtered.removeAll()
        let total = samples.count
        let step = 10
        let indices = Array(stride(from: 0, to: total, by: step))
        
        for (i, index) in indices.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.05) {
                Samples_filtered.append(samples[index])
                progress = Double(i + 1) / Double(indices.count)
            }
        }
        Samplestart = false
        
    }
    


    var body: some View {
        VStack {
            Text("Step 2").font(.title).padding().frame(maxWidth: .infinity, alignment: .leading)
            Text("Please Wait for a moment...").font(.title3).padding().frame(alignment: .leading)
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle())
                .frame(maxWidth: .infinity, minHeight: 12)
                .padding(.horizontal)
            
            Text("Progress: \(Int(progress * 100))%")
                .font(.caption)
                .foregroundColor(.gray)
            
            let messages = [
                "We will only use total \(Samples_filtered.count) samples for analysis here.",
                "May I ask you which model would you like to use?"
            ]
            if DownSampleFinished {
                if currentIndex >= 0 {
                    Text("\nWe will only use total \(Samples_filtered.count) samples for analysis here.")
                        .font(currentIndex == 0 ? .title3 : .subheadline)
                        .foregroundColor(currentIndex == 0 ? .primary : .gray)
                        .opacity(currentIndex == 0 ? 1.0 : 0.5)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.8), value: currentIndex)
                }
                
                if currentIndex >= 1 {
                    Text("\nMay I ask which model would you like to use?")
                        .font(currentIndex == 1 ? .title3 : .subheadline)
                        .foregroundColor(currentIndex == 1 ? .primary : .gray)
                        .opacity(currentIndex == 1 ? 1.0 : 0.5)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut(duration: 0.8), value: currentIndex)
                }
            }
            Spacer()
            if model_selection {
                NavigationStack {
                        HStack {
                            NavigationLink(destination: View5_2(selectedModel: "GPT", data_analyze: Samples_filtered)) {
                                Text("ChatGPT")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            Spacer().frame(width: 50)


                            NavigationLink(destination: View5_2(selectedModel: "Other Model", data_analyze: Samples_filtered)) {
                                Text("****")
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            
                            NavigationLink(destination: View5_2(selectedModel: "Cloud Back End", data_analyze: Samples_filtered)) {
                                Text("Cloud Back End")
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.bottom, 40)

                        Spacer().frame(height: 60)
                    }
                }
                
            }
        
        
        .onAppear {
            if appState.hasAppeared_V4_2 {
                  return
              }
            appState.hasAppeared_V4_2 = true
            samples = CSV_read(fileName: csvFileName)
            Samplestart = true
            if Samplestart{
                print(samples[1])
                sampleData()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                DownSampleFinished = true
                print("4-2 on appear  1")
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                   currentIndex = 0
                print("4-2 on appear  2")
               }

               DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                   withAnimation {
                       currentIndex = 1
                       print("4-2 on appear  3")
                   }
               }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
                model_selection = true
                print("4-2 on appear  4")
            }
        }
    }
}
    
    
    
    #Preview {
        ContentView()
        //View2()
    }





