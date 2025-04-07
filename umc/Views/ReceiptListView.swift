//import SwiftUI
//
//struct ReceiptListView: View {
//    @StateObject var viewModel: ReceiptViewModel
//    
//    // 액션시트(ConfirmationDialog) 제어
//    @State private var showActionSheet = false
//    // ImagePicker용 sheet 제어
//    @State private var showImagePicker = false
//    @State private var imagePickerSource: UIImagePickerController.SourceType = .photoLibrary
//    
//    // 선택된 영수증 이미지 보기
//    @State private var selectedReceiptImageData: Data? = nil
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                // 상단에 총 수량/합계 표시
//                let totalCount = viewModel.receipts.count
//                let totalSpent = viewModel.receipts.reduce(0) { $0 + $1.totalPrice }
//                
//                Text("총 \(totalCount)건, 사용합계 \(Int(totalSpent))원")
//                    .font(.headline)
//                    .padding(.top)
//                
//                List {
//                    ForEach(viewModel.receipts, id: \.id) { receipt in
//                        HStack {
//                            VStack(alignment: .leading) {
//                                Text(receipt.storeName)
//                                    .font(.body)
//                                Text("\(formattedDate(receipt.purchaseDate))")
//                                    .font(.caption)
//                                    .foregroundColor(.gray)
//                            }
//                            Spacer()
//                            // 총액 표시
//                            Text(String(format: "%.2f", receipt.totalPrice))
//                                .font(.body)
//                            
//                            // $ 버튼 -> 영수증 이미지 sheet
//                            if let image = receipt.receiptImage {
//                                Button {
//                                    selectedReceiptImageData = image.imageData
//                                } label: {
//                                    Text("$")
//                                        .font(.title2)
//                                        .padding(.leading, 8)
//                                }
//                            }
//                        }
//                        // 스와이프 삭제
//                        .swipeActions {
//                            Button(role: .destructive) {
//                                viewModel.deleteReceipt(receipt)
//                            } label: {
//                                Text("Delete")
//                            }
//                        }
//                    }
//                }
//                .listStyle(.plain)
//            }
//            .navigationTitle("전자 영수증")
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button {
//                        // 액션시트 열기
//                        showActionSheet = true
//                    } label: {
//                        Image(systemName: "plus")
//                    }
//                }
//            }
//            // + 버튼 클릭 시 뜨는 액션시트
//            .confirmationDialog("영수증 사진 가져오기", isPresented: $showActionSheet) {
//                Button("앨범에서 가져오기") {
//                    imagePickerSource = .photoLibrary
//                    showImagePicker = true
//                }
//                Button("카메라로 촬영하기") {
//                    imagePickerSource = .camera
//                    showImagePicker = true
//                }
//                Button("취소", role: .cancel) {}
//            }
//            // 실제 이미지 피커
//            .sheet(isPresented: $showImagePicker) {
//                ImagePicker(sourceType: imagePickerSource) { pickedImage in
//                    // OCR 로직(테스트용 가짜 함수)
//                    let (storeName, date, price) = performFakeOCR(on: pickedImage)
//                    // JPEG -> Data
//                    if let imageData = pickedImage.jpegData(compressionQuality: 0.8) {
//                        // ViewModel에 등록
//                        viewModel.addReceipt(storeName: storeName,
//                                             date: date,
//                                             price: price,
//                                             imageData: imageData)
//                    }
//                }
//            }
//            // 영수증 원본 이미지 표시 Sheet
//            .sheet(item: $selectedReceiptImageData) { imageData in
//                ReceiptImageView(imageData: imageData)
//            }
//        }
//    }
//    
//    // 임시 OCR 가짜 함수
//    func performFakeOCR(on image: UIImage) -> (String, Date, Double) {
//        // 실제로는 Vision/MLKit 등으로 파싱
//        // 여기서는 테스트용 더미 결과
//        return ("스타벅스 강남점", Date(), Double.random(in: 3000...10000))
//    }
//    
//    func formattedDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy.MM.dd"
//        return formatter.string(from: date)
//    }
//}
