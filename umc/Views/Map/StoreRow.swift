import SwiftUI
import CoreLocation

struct StoreRow: View {
    let store: Store
    var userLocation: CLLocationCoordinate2D?

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(store.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .clipped()

            VStack(alignment: .leading, spacing: 6) {
                Text(store.name)
                    .font(.headline)

                Text(store.address ?? "주소 미제공")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)

                HStack(spacing: 6) {
                    if store.category == .reserve {
                        TagView(label: "R", color: .brown)
                    }
                    if store.category == .dt {
                        TagView(label: "D", color: .green)
                    }
                }
            }

            Spacer()

            Text(distanceText)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 4)
        }
        .padding(.horizontal)
    }

    private var distanceText: String {
        guard let userLoc = userLocation else {
            return "거리 계산 불가"
        }

        let storeLoc = CLLocation(latitude: store.latitude, longitude: store.longitude)
        let userLocCL = CLLocation(latitude: userLoc.latitude, longitude: userLoc.longitude)

        let distance = userLocCL.distance(from: storeLoc) // in meters
        let km = distance / 1000.0
        return String(format: "%.1fkm", km)
    }
}

struct TagView: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(color)
            .cornerRadius(4)
    }
}
