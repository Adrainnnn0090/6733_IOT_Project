//
//  MotionDC.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

import Foundation
import CoreMotion
import Combine

class MotionManager: ObservableObject {
    private let MotionList = CMMotionManager()
    private let updateInterval = 1.0 / 100.0  //100Hz
    private var timer: Timer?
    
    @Published var allData: [[Double]] = []
    @Published var accData: [[Double]] = []
    @Published var gyroData: [[Double]] = []
    @Published var magData: [[Double]] = []
    @Published var startTime: Date?
    
    func start() {
        print("start collection here")
        allData.removeAll()
        accData.removeAll()
        gyroData.removeAll()
        magData.removeAll()

        
        startTime = Date()
        MotionList.startAccelerometerUpdates()
        MotionList.startGyroUpdates()
        MotionList.startMagnetometerUpdates()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
    
         //   if let acc = self.MotionList.accelerometerData {
         //       print("5")
         //       self.accData.append([Date().timeIntervalSince1970,acc.acceleration.x,acc.acceleration.y,acc.acceleration.z])
         //       print("ACC → x:\(acc.acceleration.x), y:\(acc.acceleration.y), z:\(acc.acceleration.z)")
         //   }
         //   if let gyro = self.MotionList.gyroData {
         //       self.gyroData.append([Date().timeIntervalSince1970, gyro.rotationRate.x, gyro.rotationRate.y, gyro.rotationRate.z])
         //       print("Gyro → x:\(gyro.rotationRate), y:\(gyro.rotationRate.y), z:\(gyro.rotationRate.z)")
         //   }
         //   if let mag = self.MotionList.magnetometerData {
         //       self.magData.append([Date().timeIntervalSince1970, mag.magneticField.x, mag.magneticField.y, mag.magneticField.z])
         //       print("mag → x:\(mag.magneticField.x), y:\(mag.magneticField.y), z:\(mag.magneticField.z)")
            //   }
        guard let acc = self.MotionList.accelerometerData,
            let gyro = self.MotionList.gyroData,
            let mag = self.MotionList.magnetometerData else {
            print("Waiting for all sensor data...")
            return
        }
            let row: [Double] = [Date().timeIntervalSince1970,
                acc.acceleration.x, acc.acceleration.y, acc.acceleration.z,
                gyro.rotationRate.x, gyro.rotationRate.y, gyro.rotationRate.z,
                mag.magneticField.x, mag.magneticField.y, mag.magneticField.z
            ]

            self.allData.append(row)

            print("Merged: \(row.map { String(format: "%.3f", $0) }.joined(separator: ", "))")
        
        
            
        }
    }
        
        
    func stop() {
        print("stop collection here")
            timer?.invalidate()
            MotionList.stopAccelerometerUpdates()
            MotionList.stopGyroUpdates()
            MotionList.stopMagnetometerUpdates()
        }
        
        
    }

