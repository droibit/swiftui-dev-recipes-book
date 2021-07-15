import CoreImage
import CoreImage.CIFilterBuiltins
import Foundation
import UIKit

enum FilterType: String {
    case pixellate = "モザイク"
    case sepiaTone = "セピア"
    case sharpenLuminance = "シャープ"
    case photoEffectMono = "モノクロ"
    case gaussianBlur = "ブラー"

    func filter(inputImage: UIImage) -> UIImage? {
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()
        let currentFilter = makeFilter(inputImage: beginImage)
        guard let outputImage = currentFilter.outputImage else {
            return nil
        }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage, scale: 0, orientation: inputImage.imageOrientation)
    }

    private func makeFilter(inputImage: CIImage?) -> CIFilterProtocol {
        switch self {
        case .pixellate:
            let currentFilter = CIFilter.pixellate()
            currentFilter.inputImage = inputImage
            currentFilter.scale = 40
            return currentFilter
        case .sepiaTone:
            let currentFilter = CIFilter.sepiaTone()
            currentFilter.inputImage = inputImage
            currentFilter.intensity = 1
            return currentFilter
        case .sharpenLuminance:
            let currentFilter = CIFilter.sharpenLuminance()
            currentFilter.inputImage = inputImage
            currentFilter.sharpness = 0.5
            currentFilter.radius = 100
            return currentFilter
        case .photoEffectMono:
            let currentFilter = CIFilter.photoEffectMono()
            currentFilter.inputImage = inputImage
            return currentFilter
        case .gaussianBlur:
            let currentFilter = CIFilter.gaussianBlur()
            currentFilter.inputImage = inputImage
            currentFilter.radius = 10
            return currentFilter
        }
    }
}
