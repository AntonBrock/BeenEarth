//
//  FeedbackView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 12.09.2024.
//

import SwiftUI
import CustomTextField

struct FeedbackView: View {
    @State var maxCount: Int = 160
    
    @State private var nameText: String = ""
    @State private var surName: String = ""
    @State private var email: String = ""
    @State private var message: String = ""
    
    @State private var errorEmail = "Wrong E-mail type"
    @State private var errorName = "Name is empty"
    @State private var errorSurename = "Surename is empty"
    
    @State private var isValidName = false
    @State private var isNeedToShowNameError = false
    
    @State private var isValidSurname = false
    @State private var isNeedToShowSurnameError = false
    
    @State private var isValidEmail = false
    @State private var isNeedToShowEmailError = false
    
    @State private var isValidMessage = false

    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color(hex: "#C6C6C8").opacity(0.2))
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        
        let backButtonAppearance = UIBarButtonItemAppearance(style: .plain)
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
//        NavigationView {
            VStack {
                Text("Fill in the fields\nbelow so we can\ncontact you")
                    .foregroundColor(Color(hex: "#0A2245"))
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.system(size: 32, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                
                Text("We will definitely answer you")
                    .foregroundColor(Color(hex: "#0A2245"))
                    .font(.system(size: 18, weight: .light))
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                
                ScrollView {
                    VStack(spacing: 22) {
                        EGTextField(text: $nameText)
                            .setBorderColor(Color(hex: "#B0B0B0"))
                            .setPlaceHolderText("Name")
                            .setFocusedBorderColorEnable(true)
                            .setFocusedBorderColor(Color(hex: "#2C85FF"))
                            .setPlaceHolderTextColor(.black.opacity(0.5))
                            .setError(errorText: $errorName, error: $isNeedToShowNameError)
                            .setCornerRadius(10)
                            .onChange(of: email) { newValue in
                                var value = newValue.trimmingCharacters(in: .whitespaces)
                                
                                if value.isEmpty {
                                    isNeedToShowNameError = false
                                } else {
                                    isNeedToShowNameError = !isValidSurname(value)
                                }
                                
                                isValidName = isValidName(value)
                            }
                        
                        
                        EGTextField(text: $surName)
                            .setBorderColor(Color(hex: "#B0B0B0"))
                            .setPlaceHolderText("Surname")
                            .setFocusedBorderColorEnable(true)
                            .setFocusedBorderColor(Color(hex: "#2C85FF"))
                            .setPlaceHolderTextColor(.black.opacity(0.5))
                            .setError(errorText: $errorSurename, error: $isNeedToShowSurnameError)
                            .setCornerRadius(10)
                            .onChange(of: email) { newValue in
                                var value = newValue.trimmingCharacters(in: .whitespaces)
                                
                                if value.isEmpty {
                                    isNeedToShowSurnameError = false
                                } else {
                                    isNeedToShowSurnameError = !isValidSurname(value)
                                }
                                isValidSurname = isValidSurname(value)
                            }
                        
                        EGTextField(text: $email)
                            .setBorderColor(Color(hex: "#B0B0B0"))
                            .setPlaceHolderText("E-mail")
                            .setFocusedBorderColorEnable(true)
                            .setFocusedBorderColor(Color(hex: "#2C85FF"))
                            .setPlaceHolderTextColor(.black.opacity(0.5))
                            .setError(errorText: $errorEmail, error: $isNeedToShowEmailError)
                            .setCornerRadius(10)
                            .onChange(of: email) { newValue in
                                var value = newValue.trimmingCharacters(in: .whitespaces)
                                
                                if value.isEmpty {
                                    isNeedToShowEmailError = false
                                } else {
                                    isNeedToShowEmailError = !isValidEmail(value)
                                }
                                isValidEmail = isValidEmail(value)
                            }
                        
                        EGTextField(text: $message)
                            .setBorderColor(Color(hex: "#B0B0B0"))
                            .setPlaceHolderText("Enter your message")
                            .setFocusedBorderColorEnable(true)
                            .setFocusedBorderColor(Color(hex: "#2C85FF"))
                            .setPlaceHolderTextColor(.black.opacity(0.5))
                            .setCornerRadius(10)
                        
//                        ZStack {
//                            VStack {
//                                ZStack(alignment: .topLeading) {
//                                    TextEditor(text: $message)
//                                        .foregroundColor(message == "Enter your message" ? Color(hex: "#B0B0B0") : .black)
//                                        .frame(height: 140)
//                                        .padding()
//                                        .padding(.leading, -5)
//                                        .onTapGesture {
//                                            message = ""
//                                        }
//                                        .onChange(of: message) { newValue in
//                                            if newValue == "Enter your message" && newValue != "" {
//                                                message = "Enter your message"
//                                            }
//                                            isValidMessage = isValidMessage(newValue)
//                                        }
//                                }
//                                .background(Color.white)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .strokeBorder(Color(hex: "D6D6D6"), lineWidth: 1)
//                                )
//                                .cornerRadius(10)
//                                .frame(height: 160)
//                                .multilineTextAlignment(.leading)
//                                .lineSpacing(5)
//                            }
//                        }
                    }
                    .padding(.top, 60)
                    .padding(.horizontal, 16)
                }
                
                Spacer()
                
                Button {
                    nameText = ""
                    surName = ""
                    email = ""
                    message = ""
                    
                    UIApplication.shared.sendAction(#selector( UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                } label: {
                    Text("Send")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(isValidName && isValidSurname && isValidEmail ? .white : .white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                .frame(height: 50)
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [
                                isValidName && isValidSurname && isValidEmail ? Color(hex: "#1DA0FF") : Color(hex: "#0e446b"),
                                isValidName && isValidSurname && isValidEmail ? Color(hex: "#1DA0FF") : Color(hex: "#0e446b")
                            ]
                        ),
                        startPoint: .bottomTrailing,
                        endPoint: .topLeading
                    )
                    .cornerRadius(12)
                )
                .padding(.bottom, 28)
                .disabled(!isValidName && !isValidSurname && !isValidEmail)
                .padding(.horizontal, 55)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.horizontal, 5)
            .background(.white)
//        }
//        .navigationTitle("")
//        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func isValidMessage(_ message: String) -> Bool {
        withAnimation {
            return !message.isEmpty && message.count <= 160
        }
    }
    
    private func isValidName(_ name: String) -> Bool {
        withAnimation {
            return !name.isEmpty
        }
    }
    
    private func isValidSurname(_ surname: String) -> Bool {
        withAnimation {
            return !surname.isEmpty
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        withAnimation {
            let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailPredicate.evaluate(with: email)
        }
    }
}
