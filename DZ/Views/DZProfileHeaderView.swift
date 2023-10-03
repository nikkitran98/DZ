import UIKit

private let kDZProfileHeaderViewPadding: CGFloat = 10.0
private let kDZProfileImageViewWidth: CGFloat = 60.0
private let kDZUserDetailsStackHeight: CGFloat = 12.0
private let kDZUserDetailsStackSpacing: CGFloat = 4.0
private let kDZUsernameLabelHeight: CGFloat = 24.0
private let kDZUsernameLabelFontSize: CGFloat = 24.0

class DZProfileHeaderView: UIView {
    
    private let postsLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    private let profileImageView = UIImageView()
    private let usernameLabel = UILabel()
    private let userDetailsStack: UIStackView
    private let viewModel: DZProfileHeaderViewModel
    
    
    // MARK: - Life Cycle
    
    init(viewModel: DZProfileHeaderViewModel) {
        self.viewModel = viewModel
        userDetailsStack = UIStackView(arrangedSubviews: [postsLabel, followersLabel, followingLabel])
        
        super.init(frame: CGRectZero)
        
        self.backgroundColor = DZProfileHeaderViewBackgroundColor()
        
        profileImageView.image = viewModel.user.profileImage
        profileImageView.backgroundColor = DZProfileBackgroundColor()
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        
        usernameLabel.text = viewModel.user.username
        usernameLabel.accessibilityLabel = viewModel.user.username
        usernameLabel.font = UIFont(name: "NeueBit-Bold", size: kDZUsernameLabelFontSize)
        usernameLabel.textColor = DZLabelColor()
        
        postsLabel.attributedText = viewModel.postText
        postsLabel.accessibilityLabel = viewModel.postText?.string
        
        followersLabel.attributedText = viewModel.followersText
        followersLabel.accessibilityLabel = viewModel.followersText?.string
        
        followingLabel.attributedText = viewModel.followingText
        followingLabel.accessibilityLabel = viewModel.followingText?.string
        
        userDetailsStack.axis = .horizontal
        userDetailsStack.distribution = .fillProportionally
        userDetailsStack.spacing = kDZUserDetailsStackSpacing
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(userDetailsStack)
    }
    
    override func layoutSubviews() {
        profileImageView.frame = CGRectMake(CGRectGetMinX(self.bounds) + kDZProfileHeaderViewPadding,
                                            CGRectGetMinY(self.bounds) + kDZProfileHeaderViewPadding,
                                            kDZProfileImageViewWidth,
                                            kDZProfileImageViewWidth)
        profileImageView.layer.cornerRadius = kDZProfileImageViewWidth / 2
        
        usernameLabel.frame = CGRectMake(CGRectGetMaxX(profileImageView.frame) + kDZProfileHeaderViewPadding,
                                         CGRectGetMidY(self.bounds) - kDZUsernameLabelHeight,
                                         CGRectGetWidth(self.bounds) - CGRectGetWidth(profileImageView.frame) - 3 * kDZProfileHeaderViewPadding,
                                         kDZUsernameLabelHeight)
        
        userDetailsStack.frame = CGRectMake(CGRectGetMaxX(profileImageView.frame) + kDZProfileHeaderViewPadding,
                                            CGRectGetMidY(self.bounds) + kDZUserDetailsStackHeight / 2,
                                            CGRectGetWidth(self.bounds) - CGRectGetWidth(profileImageView.frame) - 3 * kDZProfileHeaderViewPadding,
                                            kDZUserDetailsStackHeight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
