import SwiftUI

struct CustomNavigationBarView: View {
    let title: String
    let showBackButton: Bool
    let onBack: () -> Void
    let onAdd: () -> Void

    var body: some View {
        HStack {
            if showBackButton {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
            }
            
            Spacer()
            
            Text(title)
                .font(.headline)
            
            Spacer()
            
            // + 버튼
            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.title2)
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            Divider(), alignment: .bottom
        )
    }
}
