//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

struct ViewConfig {
    
    var counter: Int
    var viewBackgroundColor: UIColor
}

enum ViewState {
    
    case loaded(ViewConfig)
    case initial
    case error
    
    var viewInfo: ViewConfig {
        get {
            switch self {
            case .initial: return ViewConfig(counter: 0, viewBackgroundColor: .yellow)
            case .loaded(let state):
                return state
            case .error: return ViewConfig(counter: -1, viewBackgroundColor: .red)
            }
        }
        set {
            switch self {
            case .initial:
                var info = newValue
                info.viewBackgroundColor = .green
                self = .loaded(info)
            case .loaded:
                self = .loaded(newValue)
            case .error:
                self = .error
            }
        }
    }
    
    var labelHidden: Bool {
        guard case .error = self else { return false }
        return true
    }
    
    var recoverButtonHidden: Bool {
        guard case .error = self else { return true }
        return false
    }
    
    var errorButtonHidden: Bool {
        return !recoverButtonHidden
    }
    
}


class MyViewController : UIViewController {
    
    var viewState: ViewState = .initial {
        didSet {
            self.render(state: viewState)
        }
    }
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 100, y: 200, width: 200, height: 20)
        label.text = "Hello World!"
        label.textColor = .black
        return label
    }()
    
    lazy var button: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 240, width: 200, height: 42)
        button.setTitle("incrementar", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(increment), for: .touchUpInside)
        return button
    }()
    
    lazy var errorButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 290, width: 200, height: 42)
        button.setTitle("error", for: .normal)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(goError), for: .touchUpInside)
        return button
    }()
    
    lazy var recoverButton: UIButton = {
        let button: UIButton = UIButton(type: .custom)
        button.frame = CGRect(x: 100, y: 340, width: 200, height: 42)
        button.setTitle("recover", for: .normal)
        button.backgroundColor = .green
        button.addTarget(self, action: #selector(recoverFromError), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(self.label)
        view.addSubview(self.button)
        view.addSubview(self.errorButton)
        view.addSubview(self.recoverButton)
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        render(state: self.viewState, animated: false)
    }
    
    private func render(state: ViewState, animated: Bool = true) {
        if animated {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.5)
        }
        self.label.text = "Counter: \(state.viewInfo.counter)"
        self.view.backgroundColor = state.viewInfo.viewBackgroundColor
        self.label.isHidden = state.labelHidden
        self.recoverButton.isHidden = state.recoverButtonHidden
        self.errorButton.isHidden = state.errorButtonHidden
        if animated {
            CATransaction.commit()
        }
    }
    
    @objc func increment() {
        self.viewState.viewInfo.counter += 1
    }
    
    @objc func goError() {
        self.viewState = .error
    }
    
    @objc func recoverFromError() {
        self.viewState = .initial
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()


var viewState = ViewState.initial
viewState.viewInfo.counter == 0
viewState.labelHidden == false
viewState.viewInfo.counter += 10
if case let .loaded(info) = viewState {
    info.counter == 10
}

