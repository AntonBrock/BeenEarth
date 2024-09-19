//
//  ProfileView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 12.09.2024.
//

import SwiftUI
import MapKit
import PopupView

struct ProfileView: View {
    @Environment(\.dismiss) var dismiss

    @State private var mapType: MKMapType = .standard
    
    var willDismiss: (() -> Void)
    var needToShowPointInTheMap: ((MapPoint) -> Void)

    @State var isEditingNameMode: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    @State var name: String = "Your name"
    
    @State private var otherParams: [UIImage]?
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    
    @State private var isNeedToOpenProjects: Bool = false
    @State private var isNeedToOpenFeedbackScreen: Bool = false
    @State private var isNeedToOpenMapsPoints: Bool = false
    
    @State private var isTermsWebViewActive: Bool = false
    @State private var isPolicyWebViewActive: Bool = false

    @State private var isNeedToOpenMapStyleBottomSheet: Bool = false
    
    @State private var showInscriptions = true
    @State private var showCaps = true
    
    @State private var isNeedToOpenTermsScreen: Bool = false
    @State private var isNeedToOpenPrivacy: Bool = false
        
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle())
                        .overlay(
                            Circle().stroke(Color(hex: "#2C85FF"), lineWidth: 2)
                        )
                        .onTapGesture {
                            showImagePicker.toggle()
                        }
                } else {
                    ZStack {
                        Image("empty-user-icon")
                            .resizable()
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(Color(hex: "#2C85FF"), lineWidth: 2)
                            )
                            .onTapGesture {
                                showImagePicker.toggle()
                            }
                        
                        Image("profile_empty-ic")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .onTapGesture {
                                showImagePicker.toggle()
                            }
                    }
                }
                
                HStack {
                    if isEditingNameMode {
                        TextField("Your name", text: $name, onEditingChanged: { editing in
                            isEditingNameMode = editing
                        }, onCommit: {
                            isEditingNameMode = false
                            isTextFieldFocused = false
                            
                            UserDefaults.standard.setValue(name, forKey: "UserName")
                        })
                        .frame(maxWidth: 200, alignment: .center)
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.black)
                        .focused($isTextFieldFocused)
                    } else {
                        Text(name)
                            .foregroundStyle(.black)
                            .font(.system(size: 24, weight: .bold))
                    }
                    
                    Button {
                        isEditingNameMode.toggle()
                        isTextFieldFocused.toggle()
                        
                        UserDefaults.standard.setValue(name, forKey: "UserName")
                    } label: {
                        Image(isEditingNameMode ? "profile_edit-done-ic" : "profile_edit_ic")
                            .resizable()
                            .frame(width: isEditingNameMode ? 14 : 18, height: isEditingNameMode ? 12 : 23)
                    }                    
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 10)
                
                VStack(spacing: 19) {
                    NavigationLink(destination: MapsPointView() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss.callAsFunction()
                        }
                    } needToShowPointInTheMap: { point in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                            needToShowPointInTheMap(point)
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            dismiss.callAsFunction()
                        }
                    }, isActive: $isNeedToOpenMapsPoints) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#EFEFEF"))
                            .frame(height: 46)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image("mapsPoints-icon")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                    
                                    Text("Map’s points")
                                        .foregroundStyle(Color(hex: "#2C85FF"))
                                        .font(.system(size: 16, weight: .bold))
                                    
                                    Spacer()
                                    
                                    Image("arrow-to_view")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 9)
                                .padding(.vertical, 9)
                            }
                            .onTapGesture {
                                isNeedToOpenMapsPoints.toggle()
                            }
                    }

                    HStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#EFEFEF"))
                            .frame(height: 46)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image("mapsStyle-icon")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                    
                                    Text("Map style")
                                        .foregroundStyle(Color(hex: "#2C85FF"))
                                        .font(.system(size: 16, weight: .bold))

                                    Spacer()
                                    
                                    Image("arrow-to_view")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 9)
                                .padding(.vertical, 9)
                            }
                            .onTapGesture {
                                withAnimation {
                                    isNeedToOpenMapStyleBottomSheet = true
                                }
                            }
                    }

                    NavigationLink(destination: FeedbackView(), isActive: $isNeedToOpenFeedbackScreen) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#EFEFEF"))
                            .frame(height: 46)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image("feedback-icon")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                    
                                    Text("Fedback submissions")
                                        .foregroundStyle(Color(hex: "#2C85FF"))
                                        .font(.system(size: 16, weight: .bold))

                                    Spacer()
                                    
                                    Image("arrow-to_view")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 9)
                                .padding(.vertical, 9)
                            }
                            .onTapGesture {
                                isNeedToOpenFeedbackScreen.toggle()
                            }
                    }

                    NavigationLink(destination: WebViewScreen(link: "https://sites.google.com/view/3d-journey-planet/terms-of-use",
                                                              navTitle: "Terms and conditions"),
                                   isActive: $isTermsWebViewActive) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#EFEFEF"))
                            .frame(height: 46)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image("terms-icon")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                    
                                    Text("Terms and conditions")
                                        .foregroundStyle(Color(hex: "#2C85FF"))
                                        .font(.system(size: 16, weight: .bold))

                                    Spacer()
                                    
                                    Image("arrow-to_view")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 9)
                                .padding(.vertical, 9)
                            }
                            .onTapGesture {
                                isTermsWebViewActive = true
                            }
                    }

                    NavigationLink(destination: WebViewScreen(link: "https://sites.google.com/view/3d-journey-planet/privacy-policy",
                                                              navTitle: "Privacy policy"),
                                   isActive: $isPolicyWebViewActive) {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "#EFEFEF"))
                            .frame(height: 46)
                            .overlay(alignment: .leading) {
                                HStack(spacing: 10) {
                                    Image("policy-icon")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                    
                                    Text("Privacy policy")
                                        .foregroundStyle(Color(hex: "#2C85FF"))
                                        .font(.system(size: 16, weight: .bold))

                                    Spacer()
                                    
                                    Image("arrow-to_view")
                                        .resizable()
                                        .frame(width: 28, height: 28)
                                }
                                .padding(.leading, 12)
                                .padding(.trailing, 9)
                                .padding(.vertical, 9)
                            }
                            .onTapGesture {
                                isPolicyWebViewActive = true
                            }
                    }
                    
                }
                .padding(.top, 40)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .padding(.top, 40)
            .padding(.horizontal, 45)
        }
        .background(.white)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(.white)
        .onDisappear {
            willDismiss()
        }
        .sheet(isPresented: $showImagePicker) {
            PhotoPicker(selectedImages: $otherParams, selectedImage: $selectedImage, countForSelected: 1) {
                self.selectedImage = selectedImage
                saveImageToUserDefaults()
            }
        }
        .onAppear {
            if let name = UserDefaults.standard.string(forKey: "UserName") {
                self.name = name
            }
            
            loadImageFromUserDefaults()
        }
        .popup(isPresented: $isNeedToOpenMapStyleBottomSheet) {
            BottomSheetContentView(dismiss: {
                withAnimation {
                    isNeedToOpenMapStyleBottomSheet = false
                }
            }, didChange: { mapStyle in
                switch mapStyle {
                case .satellite:
                    print("satellite save")
                case .hybrid:
                    print("hybrid save")
                case .hybridFlyover:
                    print("hybridFlyover save")
                }
            }, mapType: $mapType, showInscriptions: $showInscriptions, showCaps: $showCaps)
                .frame(maxWidth: .infinity, maxHeight: 300)
                .cornerRadius(24)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: -5)
        } customize: {
            $0
                .type(.toast)
                .position(.bottom)
                .animation(.spring)
                .closeOnTapOutside(true)
                .closeOnTap(false)
        }
        .onAppear {
            if let name = UserDefaults.standard.string(forKey: "UserName") {
                self.name = name
            }
            
            loadImageFromUserDefaults()
        }
    }
        
    private func saveImageToUserDefaults() {
        guard let selectedImage = selectedImage else { return }
        if let imageData = selectedImage.pngData() {
            UserDefaults.standard.set(imageData, forKey: "selectedImage")
        }
    }
    
    private func loadImageFromUserDefaults() {
        if let imageData = UserDefaults.standard.data(forKey: "selectedImage"),
           let image = UIImage(data: imageData) {
            selectedImage = image
        }
    }
}
