import SwiftUI
import MapKit

struct MapView: View {
    @Binding var region: MKCoordinateRegion
    let stores: [Store]

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: stores) { store in
            MapAnnotation(coordinate: store.coordinate) {
                CustomPinView(store: store)
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
