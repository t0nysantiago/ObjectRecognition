//
//  ContentView.swift
//  ObjectRecognition
//
//  Created by Tony Santiago on 17/12/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = RecognitionViewModel()
    @State private var isShowingCamera = false

    var body: some View {
        ZStack{
            Color(hex: "e5e5e5").ignoresSafeArea()
            VStack (alignment: .center){
                
                Spacer(minLength: 160)
                
                Image(systemName: "waveform.badge.magnifyingglass")
                    .resizable()
                    .frame(width: 180, height: 150)
                    .foregroundStyle(Color(hex: "fca311"))
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("Recon")
                        .font(.title)
                        .foregroundStyle(Color(hex: "14213d"))
                        .padding(.horizontal)
                    
                    
                    
                    Image(systemName: "magnifyingglass")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(Color(hex: "14213d"))
                    
                    Text("bject")
                        .font(.title)
                        .foregroundStyle(Color(hex: "14213d"))
                }
                
                Text("Identify objects with photos from your cell phone. Point, click, discover.")
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(hex: "14213d"))
                    .padding(.horizontal)
                    .padding(.top, 1)

                    
                Spacer(minLength: 200)
                
                Button(action: {
                    isShowingCamera = true
                }) {
                    Text("Get Started")
                        .foregroundColor(Color(hex: "14213d"))
                        .frame(width: 200, height: 50)
                        .background(Color(hex: "fca311"))
                        .cornerRadius(10)
                }
                .sheet(isPresented: $isShowingCamera) {
                    CameraView(viewModel: viewModel)
                }

                Spacer()
            }
        }
    }
}


#Preview {
    ContentView()
}
