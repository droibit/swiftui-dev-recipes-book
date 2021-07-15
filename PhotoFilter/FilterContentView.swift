import SwiftUI

struct FilterContentView: View {
    @StateObject private var viewModel = FilterContentViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                if let filteredImage = self.viewModel.filteredImage {
                    Image(uiImage: filteredImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .border(Color.gray, width: 2)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                viewModel.isShowBanner.toggle()
                            }
                        }
                } else {
                    EmptyView()
                }

                GeometryReader { geometry in
                    FilterBannerView(
                        isShowBanner: $viewModel.isShowBanner,
                        applyingFilter: $viewModel.applyingFilter,
                        bottomSafeAreaInsets: geometry.safeAreaInsets.bottom
                    )
                }
            }
            .navigationBarTitle("Filter App")
            .navigationBarItems(trailing: HStack {
                Button {
                    viewModel.apply(.tappedSaveIcon)
                } label: {
                    Image(systemName: "square.and.arrow.down")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
                Button {
                    viewModel.apply(.tappedImageIcon)
                } label: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                }
            })
            .onAppear {
                viewModel.apply(.onAppear)
            }
            .actionSheet(isPresented: $viewModel.isShowActionSheet) {
                actionSheet
            }
            .sheet(isPresented: $viewModel.isShowImagePickerView) {
                ImagePicker(
                    isShown: $viewModel.isShowImagePickerView,
                    image: $viewModel.image,
                    sourceType: $viewModel.selectedSourceType
                )
            }
            .alert(isPresented: $viewModel.isShowAlert) {
                Alert(title: Text(viewModel.alertTitle))
            }
        }
    }

    private var actionSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            buttons.append(.default(Text("写真を撮る")) {
                viewModel.apply(.tappedActionSheet(selectType: .camera))
            })
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            buttons.append(.default(Text("アルバムから選択")) {
                viewModel.apply(.tappedActionSheet(selectType: .photoLibrary))
            })
        }
        buttons.append(.cancel(Text("キャンセル")))

        return ActionSheet(title: Text("画像選択"), buttons: buttons)
    }
}

struct FilterContentView_Previews: PreviewProvider {
    static var previews: some View {
        FilterContentView()
    }
}
