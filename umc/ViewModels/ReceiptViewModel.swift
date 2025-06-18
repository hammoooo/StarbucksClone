import Foundation
import SwiftUI
import SwiftData      
import Vision
import VisionKit


@Observable
final class ReceiptViewModel {
    var showImagePicker = false
    var showCamera = false
    var showActionSheet = false
    var showFullImage = false
    var selectedImageData: Data? = nil

    func save(image: UIImage, into context: ModelContext) {
        self.selectedImageData = image.jpegData(compressionQuality: 0.8)
        let text = extractText(from: image)
        let storeName = extractStoreName(from: text)
        let amount = extractAmount(from: text)
        let date = extractDate(from: text)

        let receipt = Receipt(storeName: storeName, amount: amount, date: date, imageData: selectedImageData)
        context.insert(receipt)
    }

    private func extractText(from image: UIImage) -> String {
        guard let cgImage = image.cgImage else { return "" }
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest()

        do {
            try handler.perform([request])
            return request.results?
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: " ") ?? ""
        } catch {
            print("OCR 실패: \(error)")
            return ""
        }
    }

    private func extractStoreName(from text: String) -> String {
        return text.contains("스타벅스") ? "스타벅스" : "알 수 없음"
    }

    private func extractAmount(from text: String) -> Int {
        let pattern = "\\d{1,3}(,\\d{3})*(원)?"
        let regex = try? NSRegularExpression(pattern: pattern)
        let nsrange = NSRange(text.startIndex..., in: text)

        if let match = regex?.firstMatch(in: text, range: nsrange),
           let range = Range(match.range, in: text) {
            let str = text[range].replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")
            return Int(str) ?? 0
        }
        return 0
    }

    private func extractDate(from text: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"

        let pattern = "\\d{4}\\.\\d{2}\\.\\d{2}"
        let regex = try? NSRegularExpression(pattern: pattern)
        let nsrange = NSRange(text.startIndex..., in: text)

        if let match = regex?.firstMatch(in: text, range: nsrange),
           let range = Range(match.range, in: text) {
            return formatter.date(from: String(text[range])) ?? .now
        }
        return .now
    }

    func total(_ receipts: [Receipt]) -> Int {
        receipts.map { $0.amount }.reduce(0, +)
    }
}
