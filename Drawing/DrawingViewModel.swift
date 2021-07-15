import Combine
import Foundation
import UIKit

class DrawingViewModel: NSObject, ObservableObject {
    enum Inputs {
        case tappedCaptureButton(canvasRect: CGRect, image: UIImage)
    }

    @Published var isShowAlert: Bool = false
    private(set) var alertTitle: String = ""

    func apply(inputs: Inputs) {
        switch inputs {
        case let .tappedCaptureButton(canvasRect, image):
            guard let croppedImage = cropImage(with: image, rect: canvasRect) else {
                alertTitle = "画像の保存に失敗しました。"
                isShowAlert = true
                return
            }
            UIImageWriteToSavedPhotosAlbum(croppedImage, self, #selector(imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    private func cropImage(with image: UIImage, rect: CGRect) -> UIImage? {
        let ajustRect = CGRect(
            x: rect.origin.x * image.scale,
            y: rect.origin.y * image.scale,
            width: rect.width * image.scale,
            height: rect.height * image.scale
        )
        guard let img = image.cgImage?.cropping(to: ajustRect) else {
            return nil
        }
        return UIImage(cgImage: img, scale: image.scale, orientation: image.imageOrientation)
    }

    // MARK: - Add image to Library

    @objc
    func imageSaveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            alertTitle = error.localizedDescription
        } else {
            alertTitle = "画像の保存に成功しました。"
        }
        isShowAlert = true
    }
}
