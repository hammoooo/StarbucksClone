//import SwiftUI
//import MapKit
//
//struct MapView: View {
//    @Binding var region: MKCoordinateRegion
//    let stores: [Store]
//    let routeCoordinates: [CLLocationCoordinate2D]
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                Map(coordinateRegion: $region, annotationItems: stores) { store in
//                    MapAnnotation(coordinate: store.coordinate) {
//                        CustomPinView(store: store)
//                    }
//                }
//
//                // 폴리라인 오버레이
//                if routeCoordinates.count >= 2 {
//                    Path { path in
//                        let points = routeCoordinates.map { coordinate in
//                            CGPoint(
//                                x: geometry.size.width * (coordinate.longitude - region.center.longitude) / region.span.longitudeDelta + geometry.size.width / 2,
//                                y: geometry.size.height * (region.center.latitude - coordinate.latitude) / region.span.latitudeDelta + geometry.size.height / 2
//                            )
//                        }
//
//                        path.addLines(points)
//                    }
//                    .stroke(Color.blue, lineWidth: 3)
//                }
//            }
//        }
//    }
//}
//
////struct MapView: View {
////    @Binding var region: MKCoordinateRegion
////    let stores: [Store]
////
////    var body: some View {
////        Map(coordinateRegion: $region, annotationItems: stores) { store in
////            MapAnnotation(coordinate: store.coordinate) {
////                CustomPinView(store: store)
////            }
////        }
////    }
////}
////
//
//
//
//struct CustomPinView: View {
//    let store: Store
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Image("starbucks_pin")
//                .resizable()
//                .frame(width: 40, height: 40)
//                .clipShape(Circle())
//                .shadow(radius: 3)
//
//            Text(store.name)
//                .font(.caption2)
//                .padding(4)
//                .background(Color.white)
//                .cornerRadius(6)
//                .shadow(radius: 2)
//        }
//    }
//}

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    let stores: [Store]
    let routeCoordinates: [CLLocationCoordinate2D]

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Map(coordinateRegion: $region, annotationItems: stores) { store in
                    MapAnnotation(coordinate: store.coordinate) {
                        CustomPinView(store: store)
                    }
                }
                .edgesIgnoringSafeArea(.all)

                // 폴리라인 경로 오버레이
                if routeCoordinates.count >= 2 {
                    Path { path in
                        let points = routeCoordinates.map { coordinate in
                            CGPoint(
                                x: geometry.size.width * (coordinate.longitude - region.center.longitude) / region.span.longitudeDelta + geometry.size.width / 2,
                                y: geometry.size.height * (region.center.latitude - coordinate.latitude) / region.span.latitudeDelta + geometry.size.height / 2
                            )
                        }

                        path.addLines(points)
                    }
                    .stroke(Color.green, lineWidth: 4)
                }
            }
        }
    }
}


struct CustomPinView: View {
    let store: Store

    var body: some View {
        VStack(spacing: 0) {
            Image("starbucks_pin")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .shadow(radius: 3)

            Text(store.name)
                .font(.caption2)
                .padding(4)
                .background(Color.white)
                .cornerRadius(6)
                .shadow(radius: 2)
        }
    }
}
