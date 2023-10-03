import UIKit

struct DZUser {
    let username: String
    let postCount: Int
    let followerCount: Int
    let followingCount: Int
    let profileImage: UIImage
    
    init(username: String, postCount: Int, followerCount: Int, followingCount: Int, profileImage: UIImage) {
        self.username = username
        self.postCount = postCount
        self.followerCount = followerCount
        self.followingCount = followingCount
        self.profileImage = profileImage
    }
}
