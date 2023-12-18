//
//  CameraView.swift
//  ObjectRecognition
//
//  Created by Tony Santiago on 17/12/23.
//

import SwiftUI
import UIKit

struct CameraView: View {
    @ObservedObject var viewModel: RecognitionViewModel
    @State private var isShowingImagePicker = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        ZStack{
            Color(hex: "e5e5e5").ignoresSafeArea()
            VStack {
                if let capturedImage = capturedImage {
                    
                    Spacer()
                    
                    Text("Object Found! It's: \(viewModel.identifiedObject.identifier)")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        .padding(8)
                        .offset(y: -20)
                        .opacity(viewModel.identifiedObject.identifier.isEmpty ? 0 : 1)
                    
                    Image(uiImage: capturedImage)
                        .resizable()
                        .scaledToFit()
                        .padding()
                    
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.recognizeObject(image: capturedImage)
                    }) {
                        Text("Recognize")
                            .foregroundColor(Color(hex: "14213d"))
                            .frame(width: 200, height: 50)
                            .background(Color(hex: "fca311"))
                            .cornerRadius(10)
                    }
                    
                    HStack (spacing: 3) {
                        Text("Would you like to take a new photo?")
                            .font(.footnote)
                            .foregroundColor(Color(hex: "14213d"))
                        
                        Text("Click here")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundColor(Color(hex: "fca311"))
                            .onTapGesture {
                                isShowingImagePicker = true
                            }
                    }.padding(.top)
                    
                } else {
                    Spacer(minLength: 300)
                    ZStack {
                        Image(systemName: "camera.shutter.button")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundStyle(Color(hex: "14213d"))
                        
                        Image(systemName: "hand.point.down.fill")
                            .resizable()
                            .frame(width: 80, height: 90)
                            .foregroundStyle(Color(hex: "14213d"))
                            .offset(CGSize(width: -42.0, height: -90.0))
                    }
                    
                    Text("ATTENTION!! This app uses the MobileNetV2 model, which has an accuracy that varies between 70% and 75% or more.")
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 14))
                        .foregroundStyle(Color(hex: "14213d"))
                        .padding(.horizontal)
                        .padding(.top, 40)
                    
                    Spacer(minLength: 150)
                    
                    Button(action: {
                        isShowingImagePicker = true
                    }) {
                        Text("Take a Photo")
                            .foregroundColor(Color(hex: "14213d"))
                            .frame(width: 200, height: 50)
                            .background(Color(hex: "fca311"))
                            .cornerRadius(10)
                    }
                    
                    Spacer()
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(capturedImage: $capturedImage)
            }
        }
    }
}

#Preview {
    CameraView(viewModel: RecognitionViewModel())
}
