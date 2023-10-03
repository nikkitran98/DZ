import UIKit

private let kDZLabelFontSize: CGFloat = 12.0
private let kDZMillionValue = 1000000
private let kDZThousandValue = 1000

struct DZProfileHeaderViewModel {
    
    let user: DZUser
    
    var postText: NSAttributedString? {
        return attributedText(withValue: user.postCount, text: "Posts")
    }
    
    var followersText: NSAttributedString? {
        return attributedText(withValue: user.followerCount, text: "Followers")
    }
    
    var followingText: NSAttributedString? {
        return attributedText(withValue: user.followingCount, text: "Following")
    }
    
    init(user: DZUser) {
        self.user = user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        var valueString = ""
        if value > kDZMillionValue {
            valueString = String(format: "%.1f", Double(value / kDZMillionValue)) + "M"
        } else if value > kDZThousandValue {
            valueString = String(format: "%.1f", Double(value / kDZThousandValue)) + "K"
        } else {
            valueString = String(value)
        }
        
        let attributedText = NSMutableAttributedString(string: valueString, attributes: [.font : UIFont.boldSystemFont(ofSize: kDZLabelFontSize),
                                                                                         .foregroundColor: DZLabelColor()])

        attributedText.append(NSAttributedString(string: " \(text)", attributes: [.font : UIFont.systemFont(ofSize: kDZLabelFontSize),
                                                                                  .foregroundColor: DZLabelColor()]))
        return attributedText
    }
}
