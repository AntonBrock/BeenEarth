//
//  UserDefaultsOvservable.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 19.09.2024.
//

import SwiftUI
import Combine

class UserDefaultsObserver: ObservableObject {
    private var defaultsObserver: NSObjectProtocol?
    private var cancellables = Set<AnyCancellable>()

    @Published var changeDetected: Bool = false

    init() {
        defaultsObserver = NotificationCenter.default.addObserver(
            forName: UserDefaults.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.changeDetected = true
            self?.notifyChange()
        }
    }

    deinit {
        if let observer = defaultsObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func notifyChange() {
        // Логика обработки изменения, если нужно
        print("Изменения в UserDefaults обнаружены")
        
        // Сброс состояния уведомления через короткий промежуток времени
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.changeDetected = false
        }
    }
}
