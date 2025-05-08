//import SwiftUI
//import SwiftData
//
//struct ReceiptListView: View {
//    @Environment(\.dismiss) private var dismiss
//    @Environment(\.modelContext) private var context
//    @Query private var receipts: [Receipt]
//    @StateObject private var vm = ReceiptViewModel()
//
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 12) {
//                header
//
//                if receipts.isEmpty {
//                    Spacer()
//                    Text("등록된 영수증이 없습니다.")
//                        .foregroundColor(.gray)
//                    Spacer()
//                } else {
//                    List {
//                        ForEach(receipts) { receipt in
//                            HStack {
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(receipt.storeName).font(.headline)
//                                    Text(receipt.date, style: .date)
//                                        .font(.subheadline).foregroundColor(.gray)
//                                }
//                                Spacer()
//                                Button(action: {
//                                    vm.selectedImageData = receipt.imageData
//                                    vm.showFullImage = true
//                                }) {
//                                    Text("\(receipt.amount)원").foregroundColor(.blue)
//                                }
//                            }
//                        }
//                        .onDelete { indexSet in
//                            indexSet.forEach { context.delete(receipts[$0]) }
//                        }
//                    }
//                }
//            }
//            .navigationTitle("전자영수증")
//            .toolbar(.hidden)
//            .confirmationDialog("영수증 추가", isPresented: $vm.showActionSheet) {
//                Button("앨범에서 가져오기") { vm.showImagePicker = true }
//                Button("카메라로 촬영하기") { vm.showCamera = true }
//                Button("취소", role: .cancel) {}
//            }
//            .fullScreenCover(isPresented: $vm.showImagePicker) {
//                ImagePicker(sourceType: .photoLibrary) { vm.save(image: $0, into: context) }
//            }
//            .fullScreenCover(isPresented: $vm.showCamera) {
//                ImagePicker(sourceType: .camera) { vm.save(image: $0, into: context) }
//            }
//            .sheet(isPresented: $vm.showFullImage) {
//                if let data = vm.selectedImageData, let uiImage = UIImage(data: data) {
//                    ZStack(alignment: .topTrailing) {
//                        Image(uiImage: uiImage)
//                            .resizable().scaledToFit().ignoresSafeArea()
//                        Button(action: { vm.showFullImage = false }) {
//                            Image(systemName: "xmark.circle.fill")
//                                .font(.largeTitle).padding()
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    private var header: some View {
//        VStack(spacing: 4) {
//            HStack {
//                Button { dismiss() } label: {
//                    Image(systemName: "chevron.left")
//                        .font(.title3).foregroundColor(.black)
//                }
//                Spacer()
//                Text("전자영수증").font(.headline)
//                Spacer()
//                Button { vm.showActionSheet = true } label: {
//                    Image(systemName: "plus")
//                        .font(.title3).foregroundColor(.black)
//                }
//            }
//            .padding(.horizontal)
//            Text("총 \(receipts.count)건, 합계: \(vm.total(receipts))원")
//                .font(.subheadline).foregroundColor(.gray)
//        }
//    }
//}
//
//// MARK: - UIKit Wrapper
//
//import UIKit
//
//struct ImagePicker: UIViewControllerRepresentable {
//    var sourceType: UIImagePickerController.SourceType
//    var completion: (UIImage) -> Void
//
//    func makeUIViewController(context: Context) -> UIImagePickerController {
//        let picker = UIImagePickerController()
//        picker.sourceType = sourceType
//        picker.delegate = context.coordinator
//        return picker
//    }
//
//    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
//        let parent: ImagePicker
//        init(_ parent: ImagePicker) {
//            self.parent = parent
//        }
//
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if let image = info[.originalImage] as? UIImage {
//                parent.completion(image)
//            }
//            picker.dismiss(animated: true)
//        }
//
//        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//            picker.dismiss(animated: true)
//        }
//    }
//}
//
//#Preview {
//    ReceiptListView()
//}
