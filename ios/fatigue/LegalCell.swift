import UIKit

class LegalCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var delegate: OnboardingDelegate?
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "A few formalities"
        label.textAlignment = .center
        return label
    }()
    
    func setupViews() {
        addSubview(placeholderLabel)
        placeholderLabel.anchorToTop(
            topAnchor,
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor
        )
    }
}
