//
//  ShareViewController.swift
//  ShareExtension
//

import UIKit
import Social
import CoreServices

class ShareViewController: UIViewController {
    
    // NOT WORKING, UI FREEZING
    
    private let typeJSON = String(kUTTypeJSON)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Get the all encompasing object that holds whatever was shared. If not, dismiss view.
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let itemProvider = extensionItem.attachments?.first else {
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
            return
        }
        
        // Check if object is of type text
        if itemProvider.hasItemConformingToTypeIdentifier(typeJSON) {
            handleIncomingJSON(itemProvider: itemProvider)
            // Check if object is of type JSON
            print("IS JSON")
        } else {
            print("Error: No JSON file found")
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
        
        
    }
    
    private func handleIncomingJSON(itemProvider: NSItemProvider) {
        itemProvider.loadItem(forTypeIdentifier: typeJSON, options: nil) { (item, error) in
            if let error = error {
                print("JSON-Error: \(error.localizedDescription)")
            }
            
            print("Found JSON file")
            
            self.extensionContext?.completeRequest(returningItems: nil, completionHandler: nil)
        }
    }
    
    // https://stackoverflow.com/a/44499222/13363449
    // Function must be named exactly like this so a selector can be found by the compiler!
    // Anyway - it's another selector in another instance that would be "performed" instead.
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
    
}

