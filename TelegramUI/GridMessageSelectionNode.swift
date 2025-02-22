import Foundation
import AsyncDisplayKit
import Display

final class GridMessageSelectionNode: ASDisplayNode {
    private let toggle: (Bool) -> Void
    
    private var selected = false
    private let checkNode: CheckNode
    
    init(theme: PresentationTheme, toggle: @escaping (Bool) -> Void) {
        self.toggle = toggle
        self.checkNode = CheckNode(strokeColor: theme.list.itemCheckColors.strokeColor, fillColor: theme.list.itemCheckColors.fillColor, foregroundColor: theme.list.itemCheckColors.foregroundColor, style: .overlay)
        self.checkNode.isUserInteractionEnabled = false
        
        super.init()
        
        self.addSubnode(self.checkNode)
    }
    
    override func didLoad() {
        super.didLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapGesture(_:))))
    }
    
    func animateIn() {
        self.checkNode.layer.animateAlpha(from: 0.0, to: 1.0, duration: 0.5, timingFunction: kCAMediaTimingFunctionSpring)
        self.checkNode.layer.animateScale(from: 0.2, to: 1.0, duration: 0.5, timingFunction: kCAMediaTimingFunctionSpring)
    }
    
    func animateOut(completion: @escaping () -> Void) {
        self.checkNode.layer.animateAlpha(from: 1.0, to: 0.0, duration: 0.3, timingFunction: kCAMediaTimingFunctionSpring, removeOnCompletion: false)
        self.checkNode.layer.animateScale(from: 1.0, to: 0.2, duration: 0.3, timingFunction: kCAMediaTimingFunctionSpring, removeOnCompletion: false, completion: { _ in
            completion()
        })
    }
    
    func updateSelected(_ selected: Bool, animated: Bool) {
        if self.selected != selected {
            self.selected = selected
            self.checkNode.setIsChecked(selected, animated: animated)
        }
    }
    
    @objc func tapGesture(_ recognizer: UITapGestureRecognizer) {
        if case .ended = recognizer.state {
            self.toggle(!self.selected)
        }
    }
    
    override func layout() {
        super.layout()
        
        let checkSize = CGSize(width: 32.0, height: 32.0)
        self.checkNode.frame = CGRect(origin: CGPoint(x: self.bounds.size.width - checkSize.width, y: 0.0), size: checkSize)
    }
}
