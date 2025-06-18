import SwiftUI

struct StoreSearchResultListView: View {
    let results: [Store]
    let onSelect: (Store) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(results, id: \.id) { store in
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.name)
                        .font(.PretendardRegular(16))
                    Text(store.address)
                        .font(.PretendardRegular(13))
                        .foregroundColor(.gray01)
                }
                .padding(.vertical, 8)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .onTapGesture {
                    onSelect(store)
                }

                Divider()
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}
