import GiphyUISDK

let kDZRemoveGifButtonWidth: CGFloat = 22.0
private let kDZMaxGifWidth = 250
    
func gifWidth(_ mediaView: GPHMediaView) -> CGFloat {
    if let width = mediaView.media?.images?.original?.width {
        return CGFloat(width > kDZMaxGifWidth ? kDZMaxGifWidth : width)
    }
    return 0.0
}

func gifHeight(_ mediaView: GPHMediaView) -> CGFloat {
    if let height = mediaView.media?.images?.original?.height {
        return CGFloat(height > kDZMaxGifWidth ? kDZMaxGifWidth : height)
    }
    return 0.0
}

func safeAreaInsets() -> UIEdgeInsets {
    if #available(iOS 15.0, *) {
        let window = UIApplication.shared.connectedScenes.compactMap { ($0 as? UIWindowScene)?.keyWindow}.last
        return window!.safeAreaInsets
    } else {
        let window = UIApplication.shared.windows.first
        return window!.safeAreaInsets
    }
}

