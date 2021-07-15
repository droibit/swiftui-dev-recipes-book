import SwiftUI

struct FilterContentView: View {
    @State private var filteredImage: UIImage?

    var body: some View {
        NavigationView {
            ZStack {
                if let filteredImage = self.filteredImage {
                    Image(uiImage: filteredImage)
                } else {
                    EmptyView()
                }
            }
            .navigationBarTitle("Filter App")
            .navigationBarItems(trailing: HStack {
                Button {} label: {
                    Image(systemName: "square.and.arrow.down")
                }
                Button {} label: {
                    Image(systemName: "photo")
                }
            })
        }
    }
}

struct FilterContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterContentView()
    }
}
