import SwiftUI
import ImagePicker
import CoreML

class ViewModel: ObservableObject {
    @Published var showCamera = false
    @Published var showAlbum = false
    
    @Published var selectedImage = UIImage(named: "banana") {
        didSet {
            name = ""
            results = []
        }
    }
    
    func openCamera() {
        do {
            try ImagePicker.checkCameraStatus()
        }
        catch {
            print("Cannot open cemera: \(error)")
            return
        }
        
        showCamera = true
    }
    
    func openAlbum() {
        showAlbum = true
    }
    
    private let model = try! MobileNetV2(configuration: MLModelConfiguration())
    @Published var name = ""
    @Published var results: [RecogResult] = []
    
    func recognize() {
        guard let image = selectedImage,
              let resizedImage = image.resizeTo(size: CGSize(width: 224, height: 224)),
              let buffer = resizedImage.toBuffer() else {
            return
        }

        if let output = try? model.prediction(image: buffer) {
            self.name = output.classLabel

            results = output.classLabelProbs
                .sorted { $0.value > $1.value }
                .prefix(10)
                .map { RecogResult(name: $0.key, probability: $0.value) }
        }
    }
}

struct RecogResult {
    let name: String
    let probability: Double
}
