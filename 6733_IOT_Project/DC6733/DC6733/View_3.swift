//
//  View3.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

import SwiftUI
import UIKit
import CoreMotion
import Combine

struct View3: View {
    @StateObject private var motionManager = MotionManager()
    @State private var CM = CMMotionManager()
    
    @State private var startTime: Date?
    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0

    @State private var isCollecting = false
    @State private var navigateToView4 = false
    
    @State private var showShareSheet = false
    @State private var showDCing = false
    @State private var filesToShare: [URL] = []
    
    @State private var selectedActivity = "----"
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if let start = startTime {
                elapsedTime = Date().timeIntervalSince(start)
                }
            }
        }
    
    func saveCSV(filename: String, data: [[Double]], header: String) {
            let csvString = ([header] + data.map { $0.map { String($0) }.joined(separator: ",") }).joined(separator: "\n")
            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
            
            do {
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                print("Saved to: \(fileURL.path)")
            } catch {
                print("Failed to write \(filename): \(error)")
            }
        }
    func generateFileName() -> String {
        let activitySuffix = selectedActivity.replacingOccurrences(of: " ", with: "_")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())
        return "Data_Collection_\(activitySuffix)_\(timestamp).csv"
    }
    
    func saveDataToFiles() {
        let filename = generateFileName()
        
        saveCSV(filename: filename,
                data: motionManager.allData,
                header: "TimeStamp,Acc_x,Acc_y,Acc_z,Gyro_x,Gyro_y,Gyro_z,Mag_x,Mag_y,Mag_z")
    }

    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func shareFiles(_ urls: [URL]) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = scene.windows.first?.rootViewController else { return }

        let activityVC = UIActivityViewController(activityItems: urls, applicationActivities: nil)

        // ✅ 必须先设置 handler 再 present
        activityVC.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            if completed {
                print("File Sent Successfully")
                if activityType == .airDrop {
                    navigateToView4 = true
                }
            } else {
                print("Airdrop Canceled")
            }
        }

        rootVC.present(activityVC, animated: true, completion: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            let activityOptions = ["----", "Walking", "Running", "Sitting", "Standing"]
            Text("Please Select Activity:")
                .font(.title2)
            
            Picker("Select Activity", selection: $selectedActivity) {
                ForEach(activityOptions, id: \.self) { activity in Text(activity)
                }
            }
            .pickerStyle(.wheel)
            .onChange(of: selectedActivity) {showDCing = true}
            .padding(.bottom)
            
            if showDCing{
                if CM.isAccelerometerAvailable && CM.isGyroAvailable && CM.isMagnetometerAvailable  {
                    Text("Data Collecting...\n").font(.title2)
                    Spacer()
                    Color.clear
                        .frame(height: 0)
                        .onAppear {
                            startTime = Date()
                            motionManager.start()
                            startTimer()
                        }
                    
                    Text("Duration: \(String(format: "%.1f", elapsedTime))s")
                    Text("Data Collected: \(motionManager.allData.count) packets")
                    if let latest_data = motionManager.allData.last {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Latest Colllected Values:").font(.headline)
                            Text("Acc\nx: \(String(format: "%.2f", latest_data[1])), y: \(String(format: "%.2f", latest_data[2])), z: \(String(format: "%.2f", latest_data[3]))")
                            Text("Gyro\nx: \(String(format: "%.2f", latest_data[4])), y: \(String(format: "%.2f", latest_data[5])), z: \(String(format: "%.2f", latest_data[6]))")
                            Text("Mag\nx: \(String(format: "%.2f", latest_data[7])), y: \(String(format: "%.2f", latest_data[8])), z: \(String(format: "%.2f", latest_data[9]))")
                        }
                        .font(.footnote)
                        .padding(.top, 10)
                    }
                    HStack {
                        Spacer()
                        Button("Stop") {
                            timer?.invalidate()
                            timer = nil
                            motionManager.stop()
                            saveDataToFiles()
                            
                            let filename = generateFileName()
                            filesToShare = [getDocumentsDirectory().appendingPathComponent(filename)]
                            DispatchQueue.main.async {
                                shareFiles(filesToShare)
                            }
                        }
                        .font(.title2)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 15)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        Spacer()
                    }
                } else {
                    Text("Something went wrong")
                }
            }
        }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .navigationDestination(isPresented: $navigateToView4) {
                    View4()
                }
                .sheet(isPresented: $showShareSheet) {
                    FileSharer(fileURLs: filesToShare)
                }
        }
        }
    
    
    
    
    #Preview {
        ContentView()

    }

