import UIKit

class ActivityIndicator {
    static let shared = ActivityIndicator()
    
    private var backgroundView: UIView?
    private var activityIndicator: UIActivityIndicatorView?
    
    private init() {}
    
    func show(in view: UIView) {
        if backgroundView == nil {
            backgroundView = UIView(frame: view.bounds)
            backgroundView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        
        if activityIndicator == nil {
            activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator?.center = view.center
            activityIndicator?.color = .white
            activityIndicator?.hidesWhenStopped = true
        }
        
        if let backgroundView = backgroundView, let activityIndicator = activityIndicator {
            backgroundView.addSubview(activityIndicator)
            view.addSubview(backgroundView)
            activityIndicator.startAnimating()
        }
    }
    
    func hide() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        backgroundView?.removeFromSuperview()
    }
}
