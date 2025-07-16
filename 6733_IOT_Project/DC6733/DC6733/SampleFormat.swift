//
//  SampleFormat.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

import Foundation

//struct MotionSample {
//    let timestamp: Double
//    let accX: Double
//    let accY: Double
//    let accZ: Double
//    let gyroX: Double
//    let gyroY: Double
//    let gyroZ: Double
//    let magX: Double
//    let magY: Double
//    let magZ: Double
//}
struct MotionSample: Codable {
    let timestamp: Double
    let accX: Double
    let accY: Double
    let accZ: Double
    let gyroX: Double
    let gyroY: Double
    let gyroZ: Double
    let magX: Double
    let magY: Double
    let magZ: Double
}
