import Combine
import Foundation
import UIKit

class FilterContentViewModel: ObservableObject {
    enum Inputs {
        case onAppear
    }
    
    @Published var image: UIImage?
    @Published var isShowActionseet = false
    
    func apply(_ inputs: Inputs) {
        switch inputs {
        case .onAppear:
            if image == nil {
                isShowActionseet = true
            }
        }
    }
}
