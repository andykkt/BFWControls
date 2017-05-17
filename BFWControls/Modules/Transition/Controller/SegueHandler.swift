//
//  SegueHandler.swift
//
//  Created by Tom Brodhurst-Hill on 7/12/16.
//  Copyright © 2016 BareFeetWare.
//  Free to use at your own risk, with acknowledgement to BareFeetWare.
//
/*
 Inspired by:
    https://www.bignerdranch.com/blog/using-swift-enumerations-makes-segues-safer/
    https://developer.apple.com/library/content/samplecode/Lister/Listings/Lister_SegueHandlerType_swift.html
    https://www.natashatherobot.com/protocol-oriented-segue-identifiers-swift/
 
 but changed to allow (ie not crash) blank segue identifiers with no code handling.

 Example usage:
 
 class RootViewController: UITableViewController, SegueHandler {
 
    enum SegueIdentifier: String {
        case account, products, recentProducts, contacts, login
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let segueIdentifier = segueIdentifier(for: identifier)
            else { return true }
        let should: Bool
        switch segueIdentifier {
        case .account:
            should = isLoggedIn
            if !should {
                performSegue(with: .login, sender: sender)
            }
        default:
            should = true
        }
        return should
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueIdentifier = segueIdentifier(for: segue.identifier)
            else { return }
        switch segueIdentifier {
        case .account:
            if let accountViewController = segue.destination as? AccountViewController {
                accountViewController.account = account
            }
        case .products, .recentProducts:
            if let productsViewController = segue.destination as? ProductsViewController {
                productsViewController.products = ??
            }
        case .contacts:
            if let contactsViewController = segue.destination as? ContactsViewController {
                contactsViewController.contacts = [String]()
            }
        case .login:
            break
        }
    }
 
 }
 
 */

import UIKit

public protocol SegueHandler {
    
    associatedtype SegueIdentifier: RawRepresentable
    
}

public extension SegueHandler where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegue(segueIdentifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: segueIdentifier.rawValue, sender: sender)
    }
    
    /// To perform the segue after already queued UI actions. For instance, use in an unwind segue to perform a forward segue after viewDidAppear has finished.
    func performOnMainQueueSegue(segueIdentifier: SegueIdentifier, sender: Any?) {
        DispatchQueue.main.sync { [weak self] in
            self?.performSegue(segueIdentifier: segueIdentifier, sender: sender)
        }
    }
    
    func segueIdentifier(for identifier: String?) -> SegueIdentifier? {
        return identifier.flatMap { SegueIdentifier(rawValue: $0) }
    }
    
}