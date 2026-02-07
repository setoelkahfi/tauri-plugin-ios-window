import SwiftRs
import Tauri
import UIKit
import WebKit

class OpenArgs: Decodable {
    let url: String
}

class IosWindow: Plugin {

    @objc public func open(_ invoke: Invoke) throws {
        let args = try invoke.parseArgs(OpenArgs.self)

        guard let viewController = manager.viewController else {
            invoke.reject("Cannot get root view controller.")
            return
        }

        // Resolve immediately before presenting
        invoke.resolve()

        // Present on main thread
        DispatchQueue.main.async {
            // Create the new view controller
            let newVC = NewViewController()
            newVC.url = args.url

            // Wrap in navigation controller for proper presentation
            let navController = UINavigationController(rootViewController: newVC)

            // Configure as popover on iPad, modal on iPhone
            navController.modalPresentationStyle = .popover
            navController.preferredContentSize = CGSize(width: 400, height: 600)

            if let popover = navController.popoverPresentationController {
                popover.sourceView = viewController.view
                popover.sourceRect = CGRect(
                    x: viewController.view.bounds.midX,
                    y: viewController.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                popover.permittedArrowDirections = [.up, .down]
            }

            // Present the popover
            viewController.present(navController, animated: true)
        }
    }
}

@_cdecl("init_plugin_ios_window")
func initPlugin() -> Plugin {
    return IosWindow()
}
