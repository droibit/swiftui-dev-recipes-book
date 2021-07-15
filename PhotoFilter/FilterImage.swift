import SwiftUI

struct FilterImage: View {
    @State private var image: Image?
    let filterType: FilterType
    @Binding var selectingFilter: FilterType?
    var body: some View {
        Button {
            selectingFilter = filterType
        } label: {
            VStack {
                image?
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .scaledToFit()
            }
        }
        .frame(width: 70, height: 80)
        .border(Color.white, width: selectingFilter == filterType ? 4 : 0)
        .onAppear(perform: loadImage)
    }

    private func loadImage() {
        guard let inputImage = UIImage(named: "photo_icon") else {
            return
        }
        DispatchQueue.global(qos: .background).async {
            guard let outImage = self.filterType.filter(inputImage: inputImage) else {
                return
            }

            DispatchQueue.main.async {
                self.image = Image(uiImage: outImage)
            }
        }
    }
}

struct FilterImage_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HStack {
                Image("photo_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                FilterImage(filterType: .pixellate, selectingFilter: .constant(nil))
            }
            .previewLayout(.fixed(width: 200, height: 200))
            .previewDisplayName("pixellate")
        }
    }
}
