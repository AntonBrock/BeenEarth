//
//  MainScreenView.swift
//  BeenEarth
//
//  Created by ANTON DOBRYNIN on 11.09.2024.
//

import SwiftUI
import MapKit
import Foundation
import PopupView
import CoreLocation

enum MapStyle {
    case satellite
    case hybrid
    case hybridFlyover
}

struct MapPoint: Identifiable {
    let id = UUID()
    var name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}

struct MainScreenView: View {
    @State var globalMap = GlobeMapView()
    @StateObject private var userDefaultsObserver = UserDefaultsObserver()
    
    @Environment(\.scenePhase) var scenePhase

    @State private var mapType: MKMapType = .satelliteFlyover
    @State private var mapStyle: MapStyle = .satellite

    @State private var isNeedToOpenProfileScreen: Bool = false
    @State private var isNeedToOpenFeedbackScreen: Bool = false
    
    @State private var isNeedToOpenMapStyleBottomSheet: Bool = false
    
    @State private var showInscriptions = true
    @State private var showCaps = true
    
    @State private var isNeedToOpenTermsScreen: Bool = false
    @State private var isNeedToOpenPrivacy: Bool = false
    
    @State private var isNeedToShowPoints: Bool = true
    @State private var isNeedToShowPopupAboutCreatePoint: Bool = false
    @State private var isNeedToShowPopupWithPoint: Bool = false
    
    @State private var focusedPointName: String = "Name of a point"
    @State var isEditingFocusedPointMode: Bool = false
    
    @FocusState private var isPointTextFieldFocused: Bool
    @State private var foucesPointCoordinate: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    
    @State private var savedCoordinates: [MapPoint] = []
        
    var body: some View {
        NavigationView {
            ZStack {
                globalMap
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    HStack {
                        
                        VStack {
                            Circle()
                                .fill(.white)
                                .frame(width: 50, height: 50)
                                .overlay {
                                    Image(!isNeedToShowPoints ? "mainScreen-hidePoint-icon" : "mainScreen-showPoint-icon")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .background(Color.white)
                                }
                                .onTapGesture {
                                    if !isNeedToShowPoints {
                                        isNeedToShowPoints = true
                                        globalMap.hideAllAnnotations(on: globalMap.mapView, isHidden: false)
                                    } else {
                                        isNeedToShowPoints = false
                                        globalMap.hideAllAnnotations(on: globalMap.mapView, isHidden: true)
                                    }
                                }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 24) {
                            NavigationLink(isActive: $isNeedToOpenProfileScreen) {
                                ProfileView {
                                    
                                    let savedMapStyle = UserDefaults.standard.string(forKey: "savedMapStyle")

                                    if savedMapStyle == "satellite" {
                                        self.mapStyle = .satellite
                                        self.mapType = .satellite
                                    }
                                    
                                    if savedMapStyle == "hybrid" {
                                        self.mapStyle = .hybrid
                                        self.mapType = .hybrid
                                    }
                                    
                                    if savedMapStyle == "hybridFlyover" {
                                        self.mapStyle = .hybridFlyover
                                        self.mapType = .hybridFlyover
                                    }
                                    
                                    globalMap.mapType = self.mapType
                                    
                                    withAnimation {
                                        globalMap.mapView.removeAnnotations(globalMap.mapView.annotations)
                                    }
                                    
                                    savedCoordinates.removeAll()
                                    loadCoordinates()
                                                                        
                                    if !savedCoordinates.isEmpty {
                                        globalMap.savedCoordinats = savedCoordinates
                                        savedCoordinates.forEach { point in
                                            let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                                            globalMap.addAnnotation(coordinate: coordinate, title: point.name)
                                        }
                                    }
                                }
                                needToShowPointInTheMap: { point in
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        let location = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                                        
                                        globalMap.animateToLocation(coordinate: location, withZoomLevel: 10000)
                                    }
                                }
                            } label: {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        Image("mainScreen-settings-icon")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .background(Color.white)
                                    }
                                    .onTapGesture {
                                        isNeedToOpenProfileScreen.toggle()
                                    }
                            }
                            
                            VStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        Image("mainScreen-layers-icon")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .background(Color.white)
                                    }
                                    .onTapGesture {
                                        withAnimation {
                                            isNeedToOpenMapStyleBottomSheet = true
                                        }
                                    }
                            }
                            
                            VStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 50, height: 50)
                                    .overlay {
                                        Image("mainScreen-walking")
                                            .resizable()
                                            .frame(width: 35, height: 35)
                                            .background(Color.white)
                                    }
                                
                            }
                            .onTapGesture {
                                print("Попап про будущий функционал")
                                
                            }
                        }
                    }
                    .padding()
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    globalMap.resetCamera()
                                }
                            }) {
                                Image("mainScreen-backToDefault-icon")
                                    .resizable()
                                    .frame(width: 50, height: 52)
                            }
                            .frame(width: 60, height: 60)
                        }
                        .padding(.trailing, 15)
                    }
                    
                }
                .padding(.top, 60)
                .padding(.horizontal, 15)
            }
            .popup(isPresented: $isNeedToShowPopupAboutCreatePoint) {
                HStack {
                    VStack {
                        HStack {
                            if isEditingFocusedPointMode {
                                TextField("Name of a point", text: $focusedPointName, onEditingChanged: { editing in
                                    isEditingFocusedPointMode = editing
                                }, onCommit: {
                                    isEditingFocusedPointMode = false
                                    isPointTextFieldFocused = false
                                })
                                .frame(maxWidth: 150, alignment: .leading)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .focused($isPointTextFieldFocused)
                            } else {
                                Text(focusedPointName)
                                    .frame(maxWidth: 150, alignment: .leading)
                                    .foregroundStyle(.black)
                                    .font(.system(size: 16, weight: .bold))
                            }
                            
                            Button {
                                isEditingFocusedPointMode.toggle()
                                isPointTextFieldFocused.toggle()
                            } label: {
                                Image(isEditingFocusedPointMode ? "profile_edit-done-ic" : "profile_edit_ic")
                                    .resizable()
                                    .frame(width: isEditingFocusedPointMode ? 14 : 18,
                                           height: isEditingFocusedPointMode ? 12 : 23)
                            }
                            
                        }
                        
                        VStack {
                            Divider()
                                .frame(width: 160)
                                .padding(.top, -5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Selected coordinates:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color(hex: "#2C85FF"))
                            .fixedSize()
                            .font(.system(size: 14))
                            .padding(.leading, -10)
                        
                        VStack {
                            Text("latitude: \(foucesPointCoordinate.latitude)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14))

                            Text("longtitude: \(foucesPointCoordinate.longitude)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, 10)
                    .padding(.top, 15)
                    .padding(.bottom, 10)

                    Spacer()
                    
                    VStack {
                        Image("mainScreen-closePoupAboutPoint-icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 40)
                            .padding(.bottom, -10)
                            .padding(.top, 15)
                            .onTapGesture {
                                isNeedToShowPopupAboutCreatePoint = false
                                foucesPointCoordinate = .init(latitude: 0, longitude: 0)
                            }
                        
                        Image("mainScreen-savePoint-icon")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .padding(.trailing, 22)
                            .padding(.bottom, 30)
                            .onTapGesture {
                                let newPoint = MapPoint(name: focusedPointName, latitude: foucesPointCoordinate.latitude, longitude: foucesPointCoordinate.longitude)
                                
                                saveCoordinate(newPoint) {
                                    focusedPointName = "Name of a point"
                                    isNeedToShowPopupAboutCreatePoint = false
                                }
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(width: 330, height: 105)
                .background(.white)
                .cornerRadius(15)
            } customize: {
                $0
                    .type(.floater(verticalPadding: 50, horizontalPadding: 10, useSafeAreaInset: true))
                    .position(.bottom)
                    .animation(.spring)
                    .closeOnTapOutside(true)
                    .closeOnTap(false)
            }
            .popup(isPresented: $isNeedToShowPopupWithPoint) {
                HStack {
                    VStack {
                        HStack {
                            if isEditingFocusedPointMode {
                                TextField("Name of a point", text: $focusedPointName, onEditingChanged: { editing in
                                    isEditingFocusedPointMode = editing
                                }, onCommit: {
                                    isEditingFocusedPointMode = false
                                    isPointTextFieldFocused = false
                                })
                                .frame(maxWidth: 150, alignment: .leading)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.black)
                                .focused($isPointTextFieldFocused)
                            } else {
                                Text(focusedPointName)
                                    .frame(maxWidth: 150, alignment: .leading)
                                    .foregroundStyle(.black)
                                    .font(.system(size: 16, weight: .bold))
                            }
                        }
                        
                        VStack {
                            Divider()
                                .frame(width: 160)
                                .padding(.top, -5)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Selected coordinates:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(Color(hex: "#2C85FF"))
                            .fixedSize()
                            .font(.system(size: 14))
                            .padding(.leading, -10)
                        
                        VStack {
                            Text("latitude: \(foucesPointCoordinate.latitude)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14))

                            Text("longtitude: \(foucesPointCoordinate.longitude)")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14))
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.leading, 10)
                    .padding(.top, 15)
                    .padding(.bottom, 10)

                    Spacer()
                    
                    VStack {
                        Image("mainScreen-closePoupAboutPoint-icon")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(.leading, 40)
                            .padding(.bottom, -10)
                            .padding(.top, 15)
                            .onTapGesture {
                                isNeedToShowPopupWithPoint = false
                                focusedPointName = "Name of a point"
                                foucesPointCoordinate = .init(latitude: 0, longitude: 0)
                            }
                        
                        Image("mainScreen-deletePoint-icon")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .padding(.trailing, 22)
                            .padding(.bottom, 30)
                            .onTapGesture {
                                if let pointId = savedCoordinates.firstIndex(where: {
                                    $0.latitude == foucesPointCoordinate.latitude && $0.longitude == foucesPointCoordinate.longitude
                                }) {
                                    savedCoordinates.remove(at: pointId)
                                    
                                    let annotationsToRemove = globalMap.mapView.annotations.filter { annotation in
                                        let annotationCoordinate = annotation.coordinate
                                        return annotationCoordinate.latitude == foucesPointCoordinate.latitude &&
                                        annotationCoordinate.longitude == foucesPointCoordinate.longitude
                                    }
                                    
                                    globalMap.mapView.removeAnnotations(annotationsToRemove)
                                    updateSavedPoints()
                                }
                                
                                isNeedToShowPopupWithPoint = false
                            }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(width: 330, height: 105)
                .background(.white)
                .cornerRadius(15)
                
            } customize: {
                $0
                    .type(.floater(verticalPadding: 50, horizontalPadding: 10, useSafeAreaInset: true))
                    .position(.bottom)
                    .animation(.spring)
                    .closeOnTapOutside(true)
                    .closeOnTap(false)
            }
            .popup(isPresented: $isNeedToOpenMapStyleBottomSheet) {
                BottomSheetContentView(dismiss: {
                    withAnimation {
                        isNeedToOpenMapStyleBottomSheet = false
                    }
                }, didChange: { mapStyle in 
                    switch mapStyle {
                    case .satellite:
                        self.mapStyle = .satellite
                        self.mapType = .satellite
                        UserDefaults.standard.set("\(mapStyle)", forKey: "savedMapStyle")
//                        self.mapType = .satelliteFlyover
                    case .hybrid:
                        self.mapStyle = .hybrid
                        self.mapType = .hybrid
                        UserDefaults.standard.set("\(mapStyle)", forKey: "savedMapStyle")
                    case .hybridFlyover:
                        self.mapStyle = .hybridFlyover
                        self.mapType = .hybridFlyover
                        UserDefaults.standard.set("\(mapStyle)", forKey: "savedMapStyle")
                    }
                    
                    globalMap.mapType = self.mapType
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
        }
        .navigationViewStyle(.stack)
        .tint(.black)
        .onAppear {
            
            let savedMapStyle = UserDefaults.standard.string(forKey: "savedMapStyle")

            if savedMapStyle == "satellite" {
                self.mapStyle = .satellite
                self.mapType = .satellite
            }
            
            if savedMapStyle == "hybrid" {
                self.mapStyle = .hybrid
                self.mapType = .hybrid
            }
            
            if savedMapStyle == "hybridFlyover" {
                self.mapStyle = .hybridFlyover
                self.mapType = .hybridFlyover
            }
            
            globalMap.mapType = self.mapType
            
            globalMap.needToShowCreatedPointPopup = { coordinate, title in
                self.isNeedToShowPopupAboutCreatePoint = false
                
                self.foucesPointCoordinate = coordinate
                self.focusedPointName = title!
                
                withAnimation {
                    isNeedToShowPopupWithPoint = true
                }
            }
            
            globalMap.needToShowPopup = { coordinate in
                self.isNeedToShowPopupWithPoint = false
                self.foucesPointCoordinate = coordinate
                
                withAnimation {
                    isNeedToShowPopupAboutCreatePoint = true
                }
            }
        }
        .onAppear {
            loadCoordinates()
            
            if !savedCoordinates.isEmpty {
                print(savedCoordinates)
                
                globalMap.savedCoordinats = savedCoordinates
                savedCoordinates.forEach { point in
                    let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                    globalMap.addAnnotation(coordinate: coordinate, title: point.name)
                }
            }
        }
    }
    
    // Save
    // Сохранение координат в UserDefaults
    private func saveCoordinate(_ coordinate: MapPoint, completion: @escaping (() -> Void)) {
        savedCoordinates.append(coordinate)
        saveToUserDefaults()
        
        savedCoordinates.forEach { point in
            let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
            
            globalMap.addAnnotation(coordinate: coordinate, title: point.name)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                completion()
            }
        }
    }
    
    // update
    private func updateSavedPoints() {
        if !savedCoordinates.isEmpty {
            var pointOfArray = [[:]]

            savedCoordinates.forEach { coordinate in
                let point = [
                    "name": coordinate.name,
                    "latitude": coordinate.latitude,
                    "longitude": coordinate.longitude
                ] as [String : Any]
                
                pointOfArray.append(point)
                UserDefaults.standard.set(pointOfArray, forKey: "savedCoordinatesWithNames")
            }
        } else {
            UserDefaults.standard.set([], forKey: "savedCoordinatesWithNames")
        }
        
        if !savedCoordinates.isEmpty {
            savedCoordinates.forEach { point in
                let coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                globalMap.addAnnotation(coordinate: coordinate, title: point.name)
            }
        }
    }
    
    // Сериализация и сохранение в UserDefaults
    private func saveToUserDefaults() {
        
        var pointOfArray = [[:]]
        savedCoordinates.forEach { point in
            let point = [
                "name": point.name,
                "latitude": point.latitude,
                "longitude": point.longitude
            ] as [String : Any]
            
            pointOfArray.append(point)
            UserDefaults.standard.set(pointOfArray, forKey: "savedCoordinatesWithNames")
        }
    }
    
    private func loadCoordinates() {
        if let savedData = UserDefaults.standard.array(forKey: "savedCoordinatesWithNames") as? [[String: Any]] {
            
            if savedData.isEmpty {
                savedCoordinates = []
                
                globalMap.mapView.removeAnnotations(globalMap.mapView.annotations)
                return
            }
            
            savedData.forEach { point in
                guard let name = point["name"] as? String else {
                    return
                }
                
                guard let latitude = point["latitude"] as? CLLocationDegrees else {
                    return
                }
                
                guard let longitude = point["longitude"] as? CLLocationDegrees else {
                    return
                }
                
                let point: MapPoint = MapPoint(name: name, latitude: latitude, longitude: longitude)
                savedCoordinates.append(point)
            }
        }
    }
}


struct GlobeMapView: UIViewRepresentable {
        
    var needToShowPopup: ((CLLocationCoordinate2D) -> Void)?
    var needToShowCreatedPointPopup:  ((CLLocationCoordinate2D, String?) -> Void)?
    
    var mapType: MKMapType = .satelliteFlyover
    let mapView = MKMapView(frame: .zero)
    
    var savedCoordinats: [MapPoint] = []
    
    func makeUIView(context: Context) -> MKMapView {
        mapView.mapType = .satelliteFlyover
        mapView.isRotateEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsBuildings = true
        
        mapView.delegate = context.coordinator
        
        let tapGesture = UITapGestureRecognizer(
            target: context.coordinator,
            action: #selector(context.coordinator.addAnnotationOnTap(gesture:))
        )
        
        mapView.addGestureRecognizer(tapGesture)
        resetCamera()
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        if uiView.mapType != mapType {
            uiView.mapType = mapType
            
            uiView.setNeedsDisplay()
            uiView.layoutIfNeeded()
        }
    }
        
    func animateToLocation(coordinate: CLLocationCoordinate2D, withZoomLevel zoomLevel: Double = 1000) {
        let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: zoomLevel, pitch: mapView.camera.pitch, heading: mapView.camera.heading)
        
        mapView.setCamera(camera, animated: true)
    }
    
    func resetCamera() {
        let camera = MKMapCamera()
        camera.centerCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        camera.centerCoordinateDistance = 10000000000
        camera.pitch = 0
        
        mapView.setCamera(camera, animated: true)
    }
    
    func addAnnotation(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        
        DispatchQueue.main.async {
            mapView.addAnnotation(annotation)
        }
    }
    
    func hideAllAnnotations(on mapView: MKMapView, isHidden: Bool) {
        for annotation in mapView.annotations {
            if let annotationView = mapView.view(for: annotation) {
                annotationView.isHidden = isHidden
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: GlobeMapView
                
        init(_ parent: GlobeMapView) {
            self.parent = parent
        }
        
        @objc func addAnnotationOnTap(gesture: UITapGestureRecognizer) {
            let location = gesture.location(in: parent.mapView)
            let coordinate = parent.mapView.convert(location, toCoordinateFrom: parent.mapView)
            
            parent.needToShowPopup?(coordinate)
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation {
                let title = annotation.title ?? ""
                let coordinate = annotation.coordinate
                
                parent.needToShowCreatedPointPopup?(coordinate, title)
            }
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5.0
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let identifier = "customAnnotation"
            
            if annotation is MKPointAnnotation {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                
                annotationView?.image = UIImage(named: "maps-point-icon")?.resize(to: CGSize(width: 25, height: 25))
                
                return annotationView
            }
            
            return nil
        }
    }
}

extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
