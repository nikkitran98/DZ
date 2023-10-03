import GiphyUISDK
import UIKit

protocol DZGifViewDelegate: AnyObject {
    func didTapRemoveGifButton(_ gifView: DZGifView)
}

class DZGifView: UIView {
    
    weak var delegate: DZGifViewDelegate?
    
    let mediaView = GPHMediaView()
    
    private let removeButton = UIButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        self.isMultipleTouchEnabled = true
        
        removeButton.tintColor = DZButtonColor()
        removeButton.accessibilityLabel = "remove-gif-button"
        removeButton.clipsToBounds = true
        removeButton.layer.cornerRadius = kDZRemoveGifButtonWidth / 2
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "delete")
        configuration.cornerStyle = .fixed
        
        removeButton.configuration = configuration
        removeButton.addTarget(self, action: #selector(didTapRemoveGifButton), for: .touchUpInside)
        
        addSubview(mediaView)
        addSubview(removeButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        mediaView.frame = CGRectMake(0.0,
                                     kDZRemoveGifButtonWidth / 2,
                                     gifWidth(mediaView),
                                     gifHeight(mediaView))
        
        removeButton.frame = CGRectMake(mediaView.frame.maxX - kDZRemoveGifButtonWidth / 2,
                                        mediaView.frame.minY - kDZRemoveGifButtonWidth / 2,
                                        kDZRemoveGifButtonWidth,
                                        kDZRemoveGifButtonWidth)
    }
    
    // MARK: - Helpers
    
    @objc private func didTapRemoveGifButton() {
        delegate?.didTapRemoveGifButton(self)
    }
    
}
