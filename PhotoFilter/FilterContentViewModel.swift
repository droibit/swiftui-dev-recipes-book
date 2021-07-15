import Combine
import Foundation
import UIKit

class FilterContentViewModel: NSObject, ObservableObject {
    enum Inputs {
        case onAppear
        case tappedActionSheet(selectType: UIImagePickerController.SourceType)
        case tappedImageIcon
        case tappedSaveIcon
    }

    @Published var image: UIImage?
    @Published var isShowActionSheet = false
    @Published var selectedSourceType: UIImagePickerController.SourceType = .camera
    @Published var isShowImagePickerView = false
    @Published var filteredImage: UIImage?
    @Published var isShowBanner: Bool = false
    @Published var applyingFilter: FilterType?
    @Published var isShowAlert = false
    var alertTitle: String = ""

    private var cancellables: [AnyCancellable] = []

    override init() {
        super.init()

        $image.sink { [weak self] image in
            guard let self = self,
                  let image = image
            else {
                return
            }
            self.filteredImage = image
        }.store(in: &cancellables)

        $applyingFilter.sink { [weak self] filterType in
            guard let self = self,
                  let filterType = filterType,
                  let image = self.image
            else {
                return
            }
            guard let filteredUIImage = self.updateImage(with: image, type: filterType) else {
                return
            }
            self.filteredImage = filteredUIImage
        }.store(in: &cancellables)
    }

    func apply(_ inputs: Inputs) {
        switch inputs {
        case .onAppear:
            if image == nil {
                isShowActionSheet = true
            }
        case let .tappedActionSheet(selectType):
            selectedSourceType = selectType
            isShowImagePickerView = true
        case .tappedImageIcon:
            applyingFilter = nil
            isShowActionSheet = true
        case .tappedSaveIcon:
            UIImageWriteToSavedPhotosAlbum(filteredImage!, self, #selector(imageSaveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }

    private func updateImage(with image: UIImage, type filter: FilterType) -> UIImage? {
        filter.filter(inputImage: image)
    }

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
