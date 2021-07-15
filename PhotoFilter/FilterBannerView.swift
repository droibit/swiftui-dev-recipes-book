import SwiftUI

struct FilterBannerView: View {
    @Binding var isShowBanner: Bool
    @Binding var applyingFilter: FilterType?
    @State private var selectingFilter: FilterType?
    let bottomSafeAreaInsets: CGFloat

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                VStack {
                    FilterTitleView(title: selectingFilter?.rawValue)
                    if isShowBanner {
                        FilterIconContainerView(selectingFilter: $selectingFilter)
                    }
                    FilterButtonContainerView(
                        isShowBanner: $isShowBanner,
                        selectingFilter: $selectingFilter,
                        applyingFilter: $applyingFilter
                    )
                }
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .offset(x: 0, y: self.isShowBanner ? 0 : geometry.size.height)
            }

            Rectangle()
                .foregroundColor(.black.opacity(0.8))
                .frame(height: bottomSafeAreaInsets)
                .edgesIgnoringSafeArea(.bottom)
                .offset(x: 0, y: self.isShowBanner ? 0 : geometry.size.height)
        }
    }
}

private struct FilterTitleView: View {
    let title: String?

    var body: some View {
        Text("\(title ?? "フィルターを選択")")
            .font(.title)
            .fontWeight(.bold)
            .padding(.top)
    }
}

private struct FilterIconContainerView: View {
    @Binding var selectingFilter: FilterType?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                FilterImage(filterType: .pixellate, selectingFilter: $selectingFilter)
                FilterImage(filterType: .sepiaTone, selectingFilter: $selectingFilter)
                FilterImage(filterType: .sharpenLuminance, selectingFilter: $selectingFilter)
                FilterImage(filterType: .photoEffectMono, selectingFilter: $selectingFilter)
                FilterImage(filterType: .gaussianBlur, selectingFilter: $selectingFilter)
            }
            .padding(.horizontal, 16)
        }
    }
}

private struct FilterButtonContainerView: View {
    @Binding var isShowBanner: Bool
    @Binding var selectingFilter: FilterType?
    @Binding var applyingFilter: FilterType?

    var body: some View {
        HStack {
            Button {
                withAnimation {
                    isShowBanner = false
                    selectingFilter = nil
                }
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding()
            }
            Spacer()
            Button {
                withAnimation {
                    isShowBanner = false
                    applyingFilter = self.selectingFilter
                    selectingFilter = nil
                }
            } label: {
                Image(systemName: "checkmark")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .padding()
            }
        }
    }
}

struct FilterBannerView_Previews: PreviewProvider {
    struct FilterContainer: View {
        @State var isShowBanner: Bool = false
        @State var applyingFilter: FilterType?

        var body: some View {
            FilterBannerView(
                isShowBanner: $isShowBanner,
                applyingFilter: $applyingFilter,
                bottomSafeAreaInsets: 0
            )
        }
    }

    static var previews: some View {
        FilterContainer()
    }
}
