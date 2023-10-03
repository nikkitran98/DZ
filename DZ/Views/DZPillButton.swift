import UIKit

private let kDZButtonFontSize: CGFloat = 14.0
private let kDZButtonImagePadding: CGFloat = 6.0

class DZPillButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.tintColor = DZButtonColor()
        self.clipsToBounds = true
        self.layer.cornerRadius = CGRectGetWidth(self.bounds) / 2
        
        var configuration = UIButton.Configuration.filled()
        configuration.image = UIImage(named: "add")
        configuration.imagePadding = kDZButtonImagePadding
        configuration.cornerStyle = .fixed
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: kDZButtonFontSize)
            return outgoing
        }
        
        self.configuration = configuration
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
