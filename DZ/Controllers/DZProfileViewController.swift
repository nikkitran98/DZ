import GiphyUISDK
import UIKit

private let kDZBackgroundPillButtonString = "Background"
private let kDZGifPillButtonString = "Gif"
private let kDZGiphyAPIKey = "voYbY8HlVaC2hpylTVBiNZAbS4dyALFt"
private let kDZPillButtonHeight: CGFloat = 40.0
private let kDZPillButtonWidth: CGFloat = 155.0
private let kDZPillContainerViewSpacing = 12.0
private let kDZProfileHeaderViewHeight: CGFloat = 80.0
private let kDZProfileHeaderViewWidth: CGFloat = 350.0
private let kDZProfileViewBottomMargin: CGFloat = 20.0
private let kDZProfileViewTopMargin: CGFloat = 30.0

class DZProfileViewController: UIViewController {
    
    private let user: DZUser
    private var backgroundImageView = UIImageView()
    private let gifContainerView = UIView()
    private let headerView: DZProfileHeaderView
    private let backgroundButton = DZPillButton()
    private let gifButton = DZPillButton()
    private let pillContainerView: UIStackView
    private let leftGuardLineView = UIView()
    private let topGuardLineView = UIView()
    private let rightGuardLineView = UIView()
    private let bottomGuardLineView = UIView()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        
        return imagePicker
    }()
    
    private lazy var giphyViewController: GiphyViewController = {
        let giphyViewController = GiphyViewController()
        giphyViewController.delegate = self
        giphyViewController.mediaTypeConfig = [.recents, .gifs, .stickers, .text, .emoji]
        giphyViewController.theme = GPHTheme(type: .automatic)
        
        return giphyViewController
    }()
    
    // MARK: - Life Cycle
    
    init(user: DZUser) {
        self.user = user
        self.pillContainerView = UIStackView(arrangedSubviews: [backgroundButton, gifButton])
        self.headerView = DZProfileHeaderView(viewModel: DZProfileHeaderViewModel(user: user))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Giphy.configure(apiKey: kDZGiphyAPIKey)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(didTapClearButton))
        self.navigationItem.rightBarButtonItem?.isHidden = true
        
        backgroundImageView.backgroundColor = DZBackgroundViewColor()
        backgroundImageView.contentMode = .scaleAspectFill
        
        headerView.layer.cornerRadius = kDZProfileHeaderViewHeight / 2
        
        backgroundButton.configuration?.title = kDZBackgroundPillButtonString
        backgroundButton.accessibilityLabel = "add-background-button"
        backgroundButton.layer.cornerRadius = kDZPillButtonHeight / 2
        backgroundButton.addTarget(self, action: #selector(didTapBackgroundButton), for: .touchUpInside)
        
        gifButton.configuration?.title = kDZGifPillButtonString
        gifButton.accessibilityLabel = "add-gif-button"
        gifButton.layer.cornerRadius = kDZPillButtonHeight / 2
        gifButton.addTarget(self, action: #selector(didTapGifButton), for: .touchUpInside)
        
        pillContainerView.axis = .horizontal
        pillContainerView.distribution = .fillEqually
        pillContainerView.spacing = kDZPillContainerViewSpacing
        
        topGuardLineView.layer.borderColor = DZGuardLineViewColor()
        topGuardLineView.layer.borderWidth = 1.0
        topGuardLineView.alpha = 0.0
        
        bottomGuardLineView.layer.borderColor = DZGuardLineViewColor()
        bottomGuardLineView.layer.borderWidth = 1.0
        bottomGuardLineView.alpha = 0.0
        
        leftGuardLineView.layer.borderColor = DZGuardLineViewColor()
        leftGuardLineView.layer.borderWidth = 1.0
        leftGuardLineView.alpha = 0.0
        
        rightGuardLineView.layer.borderColor = DZGuardLineViewColor()
        rightGuardLineView.layer.borderWidth = 1.0
        rightGuardLineView.alpha = 0.0
        
        view.addSubview(backgroundImageView)
        view.addSubview(gifContainerView)
        view.addSubview(pillContainerView)
        view.addSubview(headerView)
        view.addSubview(topGuardLineView)
        view.addSubview(bottomGuardLineView)
        view.addSubview(leftGuardLineView)
        view.addSubview(rightGuardLineView)
    }
    
    override func viewDidLayoutSubviews() {
        backgroundImageView.frame = self.view.bounds
        
        gifContainerView.frame = self.view.bounds
        
        headerView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - kDZProfileHeaderViewWidth / 2,
                                      CGRectGetMinY(self.view.bounds) + safeAreaInsets().top + kDZProfileViewTopMargin ,
                                      kDZProfileHeaderViewWidth,
                                      kDZProfileHeaderViewHeight)
        
        pillContainerView.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - (2 * kDZPillButtonWidth) / 2,
                                             CGRectGetMaxY(self.view.bounds) - kDZPillButtonHeight - safeAreaInsets().bottom - kDZProfileViewBottomMargin,
                                             2 * kDZPillButtonWidth,
                                             kDZPillButtonHeight)
        
        topGuardLineView.frame = CGRectMake(0.0, CGRectGetMaxY(headerView.frame), CGRectGetWidth(self.view.bounds), 1.0)
        bottomGuardLineView.frame = CGRectMake(0.0, CGRectGetMinY(pillContainerView.frame), CGRectGetWidth(self.view.bounds), 1.0)
        leftGuardLineView.frame = CGRectMake(CGRectGetMinX(headerView.frame), 0.0, 1.0, CGRectGetHeight(self.view.bounds))
        rightGuardLineView.frame = CGRectMake(CGRectGetMaxX(headerView.frame), 0.0, 1.0, CGRectGetHeight(self.view.bounds))
        
        self.navigationItem.rightBarButtonItem?.isHidden = !(gifContainerView.subviews.count > 1)
    }
    
    // MARK: - Helpers
    
    @objc private func didTapBackgroundButton() {
        present(imagePickerController, animated: true)
    }
    
    @objc private func didTapGifButton() {
        present(giphyViewController, animated: true)
    }
    
    @objc private func didTapClearButton() {
        for view in gifContainerView.subviews {
            view.removeFromSuperview()
        }
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let gif = recognizer.view {
            switch(recognizer.state) {
                case .began:
                    setEditingMode(true)
                    view.bringSubviewToFront(gif)
                case .changed:
                    setEditingMode(true)
                    gif.center = CGPoint(x: gif.center.x + translation.x, y: gif.center.y + translation.y)
                case .ended:
                    setEditingMode(false)
                default:
                    break
            }
        }
        
        recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    @objc private func handlePinchGesture(_ recognizer: UIPinchGestureRecognizer) {
        if let gif = recognizer.view {
            switch(recognizer.state) {
                case .began:
                    setEditingMode(true)
                    view.bringSubviewToFront(gif)
                case .changed:
                    setEditingMode(true)
                    gif.transform = gif.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
                    recognizer.scale = 1
                case .ended:
                setEditingMode(false)
                default:
                    break
            }
        }
    }
    
    @objc private func handleRotationGesture(_ recognizer: UIRotationGestureRecognizer) {
        if let gif = recognizer.view {
            switch(recognizer.state) {
                case .began:
                    setEditingMode(true)
                    view.bringSubviewToFront(gif)
                case .changed:
                    setEditingMode(true)
                    gif.transform = gif.transform.rotated(by: recognizer.rotation)
                    recognizer.rotation = 0
                case .ended:
                    setEditingMode(false)
                default:
                    break
            }
        }
    }
    
    private func setEditingMode(_ isInEditingMode: Bool) {
        UIView.animate(withDuration: 0.3) {
            self.pillContainerView.alpha = isInEditingMode ? 0.0 : 1.0
            self.headerView.alpha = isInEditingMode ? 0.0 : 1.0
            
            self.topGuardLineView.alpha = isInEditingMode ? 1.0 : 0.0
            self.bottomGuardLineView.alpha = isInEditingMode ? 1.0 : 0.0
            self.leftGuardLineView.alpha = isInEditingMode ? 1.0 : 0.0
            self.rightGuardLineView.alpha = isInEditingMode ? 1.0 : 0.0
        }
    }
    
    private func addNewGifToView(_ media: GPHMedia) {
        let newGif = DZGifView()
        newGif.mediaView.media = media
        newGif.delegate = self
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(_:)))
        
        newGif.addGestureRecognizer(panGestureRecognizer)
        newGif.addGestureRecognizer(pinchGestureRecognizer)
        newGif.addGestureRecognizer(rotateGestureRecognizer)
        
        gifContainerView.addSubview(newGif)
        
        let height = gifHeight(newGif.mediaView)
        let width = gifWidth(newGif.mediaView)
        newGif.frame = CGRectMake(CGRectGetMidX(self.view.bounds) - width / 2,
                                  CGRectGetMidY(self.view.bounds) - height / 2,
                                  width + kDZRemoveGifButtonWidth / 2,
                                  height + kDZRemoveGifButtonWidth / 2)
    }
    
}

// MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate

extension DZProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            backgroundImageView.image = editedimage
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            backgroundImageView.image = image
        }
        
        dismiss(animated: true)
    }
}

// MARK: - GiphyDelegate

extension DZProfileViewController: GiphyDelegate {
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        addNewGifToView(media)
        giphyViewController.dismiss(animated: true)
    }
    func didDismiss(controller: GiphyUISDK.GiphyViewController?) {
        // NO-ACTION
    }
}

// MARK: - DZGifViewDelegate

extension DZProfileViewController: DZGifViewDelegate {
    func didTapRemoveGifButton(_ gifView: DZGifView) {
        gifView.removeFromSuperview()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DZProfileViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
