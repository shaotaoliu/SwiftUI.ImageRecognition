import SwiftUI
import ImagePicker

struct ContentView: View {
    @StateObject var vm = ViewModel()
    
    var body: some View {
        VStack {
            Group {
                if let image = vm.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }
                else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.6)
                }
            }
            .frame(maxWidth: UIScreen.main.bounds.width / 1.3)
            .cornerRadius(20)
            .padding(.top)
            
            HStack(spacing: 20) {
                Group {
                    Button("Camera") {
                        vm.openCamera()
                    }
                    .sheet(isPresented: $vm.showCamera) {
                        ImagePicker(sourceType: .camera, selectedImage: $vm.selectedImage)
                    }

                    Button("Album") {
                        vm.openAlbum()
                    }
                    .sheet(isPresented: $vm.showAlbum) {
                        ImagePicker(sourceType: .library, selectedImage: $vm.selectedImage)
                    }

                    Button("Recognize") {
                        vm.recognize()
                    }
                }
                .foregroundColor(.white)
                .padding(.vertical, 8)
                .padding(.horizontal, 15)
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
            
            if !vm.results.isEmpty {
                List {
                    Section(header: HStack {
                        Text("Label")
                        Spacer()
                        Text("%")
                    }.font(.headline.bold())) {
                        ForEach(vm.results, id: \.name) { result in
                            HStack {
                                Text(result.name)
                                Spacer()
                                Text(String(format: "%.2f", arguments: [result.probability * 100]))
                            }
                        }
                    }
                }
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
