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

struct View3_2: View {
    @EnvironmentObject var appState: AppState
    
    @StateObject private var motionManager = MotionManager()
    @State private var CM = CMMotionManager()
    
    @State private var startTime: Date?
    @State private var timer: Timer?
    @State private var elapsedTime: TimeInterval = 0
    
    @State private var isCollecting = false
    @State private var navigateToView4 = false

    @State private var showShareSheet = false
    @State private var showDC_User = false
    @State private var showDCing = false
    @State private var filesToShare: [URL] = []
    @State private var msg_preparing: [String] = []
    @State private var DC_USER_CNT = false
    @State private var DC_USER_show = false
    @State private var S1Text_prepare = "\nGo ahead and start any activity — we’re now collecting motion data!"
    
    @State private var countdown: Int = 3
    @State private var showCountdown = false
    @State private var DC_total: Int = 30
    
    @State private var savedFileName: String = ""
    
    func startTimer() {
        print("---3_2_starttimer------")
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
        print("---3_2_generatefilename------")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss"
        let timestamp = formatter.string(from: Date())
        return "User_Data_\(timestamp).csv"
    }
    
    func saveDataToFiles() {
        print("---3_2_savefiles------")
        let filename = generateFileName()
        savedFileName = filename
        saveCSV(filename: filename,
                data: motionManager.allData,
                header: "TimeStamp,Acc_x,Acc_y,Acc_z,Gyro_x,Gyro_y,Gyro_z,Mag_x,Mag_y,Mag_z")
    }
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    

    func runSequence() {
        print("---runsequence------")
        let MSG_Pre = [
            "\nGo ahead and start any activity — we’re now collecting motion data!",
            "Get ready...",
            "Ready?"]
        
        for (i, msg) in MSG_Pre.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i * 2 + 1)) {
                withAnimation {
                    msg_preparing.append(msg)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(MSG_Pre.count  * 2 + 1)) {
            startCountdown()
        }
    }
    
    func startCountdown() {
        print("---3_2_startcountdown------")
        showCountdown = true
        countdown = 3
        for i in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                countdown = 3 - i
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.1) {
            showCountdown = false
            msg_preparing.append("Starting data collection...")
            DC_USER_CNT = true
            DC_Countdown()
        }
    }
    
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!changed the time to 30; 2 is used for test!
    func DC_Countdown() {
        print("---3_2_dc_countdown------")
        DC_total = 2
        for i in 0..<2 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                DC_total = 2 - i
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
            DC_USER_CNT = false
            msg_preparing.append("Collection Finished!")
            motionManager.stop()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                DC_USER_show = true
                saveDataToFiles()
            }
            
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Step 1").font(.title).padding().frame(alignment: .leading)
            ScrollView {
                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(msg_preparing.enumerated()), id: \.offset) { index, msg in
                        Text(msg)
                            .font(index == msg_preparing.count - 1 ? .title2 : .headline)
                            .foregroundColor(index == msg_preparing.count - 1 ? .primary : .gray)
                            .opacity(index == msg_preparing.count - 1 ? 1.0 : 0.6)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.8), value: msg_preparing)
            }
            .frame(height: 180)
            .padding(.horizontal)
            if showCountdown {
                Text("⌛️\(countdown)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .transition(.scale)
                    .padding(.top)
            }
            if DC_USER_CNT {
                Text("Remaining：\(DC_total)")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
                    .transition(.scale)
                    .padding(.top)
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
                    
       
                    Text("Data Collected: \(motionManager.allData.count) packets")
                    if let latest_data = motionManager.allData.last {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Latest Colllected Values:").font(.headline)
                            Text("Acc\nx: \(String(format: "%.2f", latest_data[1])), y: \(String(format: "%.2f", latest_data[2])), z: \(String(format: "%.2f", latest_data[3]))")
                            Text("Gyro\nx: \(String(format: "%.2f", latest_data[4])), y: \(String(format: "%.2f", latest_data[5])), z: \(String(format: "%.2f", latest_data[6]))")
                            Text("Mag\nx: \(String(format: "%.2f", latest_data[7])), y: \(String(format: "%.2f", latest_data[8])), z: \(String(format: "%.2f", latest_data[9]))")
                        }
                        .font(.callout)
                        .padding(.top, 10)
                    }
                    
                    
            }else {
                Text("Something went wrong")
            }
       }
            
            if DC_USER_show {
                
                Text("Total collected samples: \(motionManager.allData.count)").font(.title2)
                    .padding(.top, 10)
                NavigationLink(destination: View4_2(csvFileName: savedFileName)) {
                    Text("Next Step")
                        .font(.title2).fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                Spacer().frame(height: 60)
            }
            
            
        }
        .padding()
        .onAppear {
            if appState.hasAppeared_V4_2 {
                  return
              }
            appState.hasAppeared_V3_2 = true
            runSequence()
        }
    }
    
}
    #Preview {
       ContentView()
    
        
    }
    
    

