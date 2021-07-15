import SwiftUI

struct DrawingView: View {
    @State private var endedDrawPoints: [DrawPoints] = []
    @State private var selectedColor: DrawColor = .red
    @State private var canvasRect: CGRect = .zero

    @StateObject private var viewModel: DrawingViewModel = .init()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                Canvas(
                    endedDrawPoints: $endedDrawPoints,
                    selectedColor: $selectedColor,
                    canvasRect: $canvasRect
                )

                HStack(spacing: 10) {
                    Spacer()
                    Button {
                        selectedColor = .red
                    } label: {
                        Text("赤")
                            .frame(width: 80, height: 100, alignment: .center)
                            .background(Color.red)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                    }
                    Button {
                        selectedColor = .clear
                    } label: {
                        Text("消しゴム")
                            .frame(width: 80, height: 100, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(20)
                            .foregroundColor(.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 4)
                            )
                    }
                    Button {
                        let capturedImage = capture(rect: geometry.frame(in: .global))
                        viewModel.apply(inputs: .tappedCaptureButton(canvasRect: canvasRect, image: capturedImage))
                    } label: {
                        Text("保存")
                            .frame(width: 80, height: 100, alignment: .center)
                            .background(Color.white)
                            .cornerRadius(20)
                            .foregroundColor(.blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.black, lineWidth: 4)
                            )
                    }
                    Spacer()
                }
            }
        }
        .background(Color.white)
        .alert(isPresented: $viewModel.isShowAlert) {
            Alert(title: Text(viewModel.alertTitle))
        }
    }
}

extension DrawingView {
    func capture(rect: CGRect) -> UIImage {
        let window = UIWindow(frame: rect)
        let hosting = UIHostingController(rootView: body)
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()
        return hosting.view.renderedImage
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
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
