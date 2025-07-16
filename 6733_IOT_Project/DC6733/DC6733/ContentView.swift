//
//  ContentView.swift
//  DC6733
//
//  Created by Jo on 2025/7/15.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack{
                    Text("\nWelcome To 6733 Project").font(.title).fontWeight(.bold)
                    Spacer()
                }
                
                Text("\nDesigned By AIoT Group").font(.title2).fontWeight(.bold)
                //Spacer().frame(height: 20)
                Text("\nThis app is designed for activity recognition using real-time motion data collected from iPhone sensors.")
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)

            }
            Spacer()
            
                NavigationLink(destination: View2()) {
                    Text("Let's Go!")
                        .font(.title2).fontWeight(.bold)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
            Spacer().frame(height: 100)

                
                .padding()
            }
        }
    }

#Preview {
    ContentView()
}


