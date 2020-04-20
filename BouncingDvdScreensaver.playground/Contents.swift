//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

private var randomImage: String {
    let colors = [
        "blue",
        "green",
        "pink",
        "red",
        "yellow"
    ];
    return String(format: "dvd_%@.png",
                  colors.randomElement()!)
}

struct LogoProperties {
    let vX: CGFloat
    let vY: CGFloat
    let imageName: String

    init(vX: CGFloat,
         vY: CGFloat) {
        self.vX = vX
        self.vY = vY
        self.imageName = randomImage
    }
}

extension LogoProperties {
    public func reverseVX() -> LogoProperties {
        return LogoProperties(vX: self.vX * -1,
                              vY: self.vY)
    }

    public func reverseVY() -> LogoProperties {
        return LogoProperties(vX: self.vX,
                              vY: self.vY * -1)
    }
}

class LogoImageView: UIImageView {

    var properties: LogoProperties {
        didSet {
            setImage()
        }
    }

    var x: CGFloat    { return frame.origin.x }
    var maxX: CGFloat { return frame.maxX }
    var y: CGFloat    { return frame.origin.y }
    var maxY: CGFloat { return frame.maxY }

    init(frame: CGRect,
         properties: LogoProperties) {
        self.properties = properties
        super.init(frame: frame)
        contentMode = .scaleAspectFit
        setImage()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    public func updateProperties(_ properties: LogoProperties) {
        self.properties = properties
    }

    private func setImage() {
        image = UIImage(named: String(format: "images/%@",
                                      properties.imageName))
    }
}

class BouncingDvdScreensaverViewController : UIViewController {

    enum Settings {
        static let viewSize: CGSize = CGSize(width: 375.0,
                                             height: 668.0)
        static let logoSize = CGSize(width: 70,
                                     height: 35)
        static let smoothFps: Double = 1/60
    }

    var x: CGFloat { return view.frame.origin.x }
    var y: CGFloat { return view.frame.origin.y }

    var logo: LogoImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        let logoFrame = CGRect(origin: randomOrigin,
                               size: Settings.logoSize)
        let properties = LogoProperties(vX: randomVector,
                                        vY: randomVector)
        logo = LogoImageView(frame: logoFrame,
                        properties: properties)
        view.addSubview(logo)
        update()
    }

    private func update() {
        let newOrigin = CGPoint(x: logo.frame.origin.x + logo.properties.vX,
                                y: logo.frame.origin.y + logo.properties.vY)
        UIView.animate(withDuration: Settings.smoothFps,
                       animations: {
            self.logo.frame = CGRect(origin: newOrigin,
                                     size: self.logo.frame.size)
        }) { _ in
            self.checkForCollision()
            self.update()
        }
    }

    private func checkForCollision() {
        var updatedProperties: LogoProperties = logo.properties
        if
            logo.x <= 0 ||
            logo.maxX >= Settings.viewSize.width {
                updatedProperties = updatedProperties.reverseVX()
                logo.updateProperties(updatedProperties)
        }
        if
            logo.y <= 0 ||
            logo.maxY >= Settings.viewSize.height {
                updatedProperties = updatedProperties.reverseVY()
                logo.updateProperties(updatedProperties)
        }
    }

    // Random Helpers
    private var randomOrigin: CGPoint {
        let x = Int.random(in: 1..<Int(Settings.viewSize.width - Settings.logoSize.width))
        let y = Int.random(in: 1..<Int(Settings.viewSize.height - Settings.logoSize.height))
        return CGPoint(x: CGFloat(x),
                       y: CGFloat(y))
    }

    private var randomVector: CGFloat {
        let `true` = Bool.random()
        return `true` ? 1.0 : -1.0
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = BouncingDvdScreensaverViewController()
