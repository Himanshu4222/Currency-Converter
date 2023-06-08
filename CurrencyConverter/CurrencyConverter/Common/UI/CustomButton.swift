//
//  CustomButton.swift
//  CurrencyConverter
//
//  Created by Himanshu Dawar on 27/05/23.
//


import UIKit

class CustomButton: UIButton {
    
    enum Style {
        case primary
        case secondary
        case disabled
        case clear(titleColor: UIColor? = nil, borderColor: UIColor? = nil)
        case custom(backgroundColor: UIColor? = nil, titleColor: UIColor? = nil, borderColor: UIColor? = nil)

        var backgroundColor: UIColor {
            switch self {
            case .primary, .disabled:
                return .systemBlue
            case .secondary:
                return .systemYellow
            case .clear:
                return .clear
            case .custom(let backgroundColor, _, _):
                return backgroundColor ?? .systemBlue
            }
        }

        var titleColor: UIColor {
            switch self {
            case .primary, .disabled:
                return .white
            case .secondary:
                return .black
            case .clear(let titleColor, _):
                return titleColor ?? .black
            case .custom(_, let titleColor, _):
                return titleColor ?? .white
            }
        }

        var borderColor: CGColor {
            switch self {
            case .primary, .disabled:
                return UIColor.clear.cgColor
            case .secondary:
                return UIColor.systemBlue.cgColor
            case .clear(_, let borderColor):
                return (borderColor ?? .systemBlue).cgColor
            case .custom(_, _, let borderColor):
                return (borderColor ?? .clear).cgColor
            }
        }
    }
    
    var didPress: VoidCompletion?
    
    var title: String = "" {
        didSet {
            setTitle(title, for: .normal)
        }
    }
    
    var titleColor: UIColor = .clear {
        didSet {
            setTitleColor(titleColor, for: .normal)
        }
    }
    
    var height: CGFloat = 40 {
        didSet {
            heightConstraint?.constant = height
        }
    }
    
    var width: CGFloat = 40 {
        didSet {
            widthConstraint?.constant = width
        }
    }
    
    var widthActive: Bool = false {
        didSet {
            widthConstraint?.isActive = widthActive
        }
    }
    
    var heightActive: Bool = true {
        didSet {
            heightConstraint?.isActive = heightActive
        }
    }
    
    private var isButtonColor = false
    private var isTitleColor = false
    
    private var heightConstraint: NSLayoutConstraint?
    private var widthConstraint: NSLayoutConstraint?
    
    init(title: String = "",
         image: UIImage? = nil,
         font: UIFont = .systemFont(ofSize: Constants.fontSize, weight: .bold),
         style: Style = .primary,
         didPress: VoidCompletion? = nil
    ) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        self.didPress = didPress
        self.title = title
        setTitle(title, for: .normal)
        setImage(image, for: .normal)
        activateConstraints()
        setUp(style: style, font: font)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func activateConstraints() {
        heightConstraint = heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = heightActive
        widthConstraint = widthAnchor.constraint(equalToConstant: width)
        widthConstraint?.isActive = widthActive
    }
    
    private func setUp(style: Style, font: UIFont) {
        switch style {
        case .disabled:
            isUserInteractionEnabled = false
            alpha = Constants.disabledAlpha
        default:
            break
        }

        layer.borderColor = style.borderColor
        backgroundColor = style.backgroundColor
        setTitleColor(style.titleColor, for: .normal)

        layer.borderWidth = Constants.borderWidth
        layer.masksToBounds = true
        layer.cornerRadius = Constants.cornerRadius
        setContentHuggingPriority(.required, for: .horizontal)
        titleLabel?.font = font
        addTarget(self, action: #selector(pressed), for: .touchUpInside)
    }
    
    @objc func pressed() {
        didPress?()
    }
    
    private struct Constants {
        static let disabledAlpha: CGFloat = 0.5
        static let borderWidth: CGFloat = 1.0
        static let fontSize: CGFloat = 14.0
        static let cornerRadius: CGFloat = 4.0
    }
}
