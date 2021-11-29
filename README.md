# SwiftUI.ImageRecognition

This app shows how to use a model to recognize an image. The user can select an image and the app returns a list of labels (top 10) with probabilities.

```Swift
let model = try! MobileNetV2(configuration: MLModelConfiguration())

if let output = try? model.prediction(image: buffer) {
    results = output.classLabelProbs
        .sorted { $0.value > $1.value }
        .prefix(10)
        .map { RecogResult(name: $0.key, probability: $0.value) }
}
```

![image](https://user-images.githubusercontent.com/15805568/143957197-3379c184-b15f-4a51-9377-1c6fd1d8a951.png)
![image](https://user-images.githubusercontent.com/15805568/143957044-8cd61255-808e-4d7a-ac62-d21e200f589c.png)

