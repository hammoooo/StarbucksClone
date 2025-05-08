import SwiftUI

struct ShopView_GridSection: View {
    let title: String
    let items: [ShopModel]
    let columns: [GridItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if !title.isEmpty {
                Text(title)
                    .font(.headline)
                    .padding(.leading)
            }
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(items) { item in
                    VStack(spacing: 6) {
                        Image(item.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        Text(item.name)
                            .font(.subheadline)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
        }
    }
}
