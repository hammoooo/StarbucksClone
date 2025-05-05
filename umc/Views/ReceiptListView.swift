import SwiftUI
import SwiftData

struct ReceiptListView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    
    // SwiftData의 @Query 사용: Receipt 전체를 날짜순 정렬로 가져오기 예시
    @Query(sort: \.date, order: .forward)
    private var receipts: [Receipt]
    
    // 새 액션시트 표기 여부
    @State private var showActionSheet = false
    
    // 영수증 상세 입력 폼(직접 입력) Sheet 제어
    @State private var showAddForm = false
    
    // 선택된 영수증 이미지 Sheet 제어
    @State private var selectedReceiptImage: ReceiptImage? = nil
    
    var body: some View {
        VStack(spacing: 0) {
            // 요구사항: 상단의 이전 버튼, 타이틀, + 버튼을 커스텀 뷰로 구성
            CustomNavigationBarView(
                title: "전자 영수증",
                showBackButton: true,
                onBack: {
                    dismiss() // 이전 화면으로
                },
                onAdd: {
                    // + 버튼 누르면 액션시트 표시
                    showActionSheet = true
                }
            )
            
            // "총 x건, 사용합계 yyy"
            let totalCount = receipts.count
            let totalSum = receipts.map { $0.totalPrice }.reduce(0, +)
            
            Text("총 \(totalCount)건, 사용합계 \(Int(totalSum))원")
                .font(.subheadline)
                .padding(.vertical, 8)
            
            Divider()
            
            // 등록된 영수증 목록
            List {
                ForEach(receipts) { receipt in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(receipt.storeName)
                                .font(.headline)
                            Text("\(receipt.date, style: .date) | \(Int(receipt.totalPrice))원")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // 달러 표시 기호 → 영수증 이미지 Sheet 열기
                        if let _ = receipt.receiptImage?.data {
                            Button {
                                selectedReceiptImage = receipt.receiptImage
                            } label: {
                                Image(systemName: "dollarsign.circle")
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteItems)
            }
        }
        .confirmationDialog(
            "영수증 등록",
            isPresented: $showActionSheet,
            titleVisibility: .visible
        ) {
            Button("앨범에서 가져오기") {
                // 실제로는 PhotosPicker 등을 띄워서 이미지 선택 → ReceiptFormView로 전달
                showAddForm = true
            }
            Button("카메라로 촬영하기") {
                // 실제로는 카메라 띄워서 이미지 촬영 → ReceiptFormView로 전달
                showAddForm = true
            }
            Button("취소", role: .cancel) { }
        }
        // 새 영수증 등록 폼
        .sheet(isPresented: $showAddForm) {
            ReceiptFormView()
        }
        // 선택된 영수증 이미지 확대/확인 Sheet
        .sheet(item: $selectedReceiptImage) { image in
            ReceiptDetailView(receiptImage: image)
        }
    }
    
    // 왼쪽 스와이프 삭제
    private func deleteItems(offsets: IndexSet) {
        for index in offsets {
            let receipt = receipts[index]
            context.delete(receipt)
        }
        do {
            try context.save()
        } catch {
            print("Error while deleting receipts: \(error)")
        }
    }
}
#Preview {
    ReceiptListView()
}
