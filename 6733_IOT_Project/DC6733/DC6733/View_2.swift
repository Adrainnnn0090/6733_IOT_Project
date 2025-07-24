//
//  View2.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

import SwiftUI
import CoreMotion
import Combine





struct View2: View {
    private let motionManager = CMMotionManager()
    @State private var showSensorInfo = false
    @State private var accStatus0 = ""
    @State private var gyroStatus0 = ""
    @State private var magStatus0 = ""
    
    @State private var show_acc = false
    @State private var show_gyro = false
    @State private var show_mag = false
    @State private var show_continous = false
    @State private var demo_continous = false
    
    
    
    @AppStorage("userID") var userID: String = ""
    @State private var showUserInput = false
    @State private var tempInput = ""

    
    func SensorStatusPrint(manager: CMMotionManager, mode: String) -> (String, String, String) {
        print("Mode: \(mode)")
        print("View2_--__--___$#$#")
        let accStatus = manager.isAccelerometerAvailable ? "✅" : "❌"
        let gyroStatus = manager.isGyroAvailable ? "✅" : "❌ "
        let magStatus = manager.isMagnetometerAvailable ? "✅" : "❌"
        
        print("Accelerometer:\(accStatus)")
        print("Gyroscope:\(gyroStatus)")
        print("Magnetometer:\(magStatus)")
        
        return (accStatus, gyroStatus, magStatus)
    }
    
    func startAnimationSequence(mode: String) {
        show_acc = false
        show_gyro = false
        show_mag = false
        showSensorInfo = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            show_acc = true
           }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            show_gyro = true
           }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            show_mag = true
           }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if mode == "Developer" {
                show_continous = true
            }else if mode == "User" {
                demo_continous = true
            }
            
           }
       }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                Text("\nWhat would you like to do now?").font(.title2)
                Text("\nCollect Data: Used for Developer").font(.callout)
                Text("Demo Text: Used for User").font(.callout)
                
                // 可选：显示用户 ID
                if !userID.isEmpty {
                    Text("🤷🏻‍♀️Current User: \(userID)")
                        .foregroundColor(.black)
                }
                    
                Spacer()
                
                HStack{
                    Spacer().frame(width: 30)
                    Button("Collect Data") {
                        let _ = SensorStatusPrint(manager: motionManager, mode: "Developer")
                        withAnimation {
                            showSensorInfo = true
                            startAnimationSequence(mode: "Developer")
                        }
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    Spacer().frame(width: 30)
                    
//                    Button("Demo Test") {
//                        let _ = SensorStatusPrint(manager: motionManager, mode: "User")
//                        withAnimation {
//                            showSensorInfo = true
//                            startAnimationSequence(mode: "User")
//                        }
                    
                    Button("Demo Test") {
                        showUserInput = true
                    }
                   
                    .buttonStyle(.borderedProminent)
                    Spacer().frame(width: 30)
                    .alert("Enter Your Name", isPresented: $showUserInput) {
                        TextField("e.g. ios_user_1", text: $tempInput)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                            .padding(.horizontal)
                        Button("OK") {
                            if !tempInput.isEmpty {
                                userID = tempInput  // 存入全局
                                print("✅ Saved userID: \(userID)")

                                
                                let _ = SensorStatusPrint(manager: motionManager, mode: "User")
                                withAnimation {
                                    showSensorInfo = true
                                    startAnimationSequence(mode: "User")
                                }
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Your name will be used to tag your activity records.")
                    }


                    }
                    .padding()
                    .background(Color.orange)
               
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 400)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if showSensorInfo {
                Text("Sensor monitoring in progress...")
                    .font(.callout)
                    .foregroundColor(.blue)
                    .padding().frame(maxWidth: .infinity, alignment: .leading)
                let (accStatus0, gyroStatus0, magStatus0) = SensorStatusPrint(manager: motionManager, mode: "Show on screen")
                if show_acc {
                    Text("Accelerometer: \(accStatus0)").transition(.opacity)
                }
                if show_gyro {
                    Text("Gyroscope: \(gyroStatus0)").transition(.opacity)
                }
                if show_mag {
                    Text("Magnetometer: \(magStatus0)").transition(.opacity)
                }
                if show_continous{
                    NavigationLink(destination: View3()) {
                        Text("Continue")
                            .font(.title2).fontWeight(.bold)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                Spacer().frame(height: 100)
                } else if demo_continous{
                    NavigationLink(destination: View3_2()) {
                        Text("Let's Start!")
                            .font(.title2).fontWeight(.bold)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                Spacer().frame(height: 100)
                }
                Spacer()
                
            }
        }
    }
    

    

#Preview {
    ContentView()
    //View2()
}
