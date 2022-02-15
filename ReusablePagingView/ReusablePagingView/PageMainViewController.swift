//
//  PageMainViewController.swift
//  ReusablePagingView
//
//  Created by sun on 2022/02/15.
//

import UIKit

class PageMainViewController: UIViewController {
    @IBOutlet private weak var mainView: UIView!
    
    private var pageViewController: UIPageViewController!
    private var pageImages: [String]!
    private var pageColors: [UIColor]!
    private var currentIndex: Int = 0
    private var choosenIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageImages = ["1", "2", "3", "4", "5", "6", "7"]
        self.pageColors = [.systemOrange, .systemYellow, .systemCyan, .systemMint, .systemIndigo, .systemBrown, .systemPurple].shuffled()
        self.pageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        
        let startViewController = self.viewController(at: choosenIndex)
        let viewControllers = NSArray(object: startViewController)
        
        self.pageViewController.setViewControllers(
            viewControllers as? [UIViewController],
            direction: .forward,
            animated: true,
            completion: nil
        )
        self.addChild(self.pageViewController)
        self.mainView.addSubview(self.pageViewController.view)
        
        // Autolayout
        self.pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addConstraint(NSLayoutConstraint(
            item: self.pageViewController.view!,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.mainView,
            attribute: .top,
            multiplier: 1,
            constant: 0))
        self.mainView.addConstraint(NSLayoutConstraint(
            item: self.pageViewController.view!,
            attribute: .left,
            relatedBy: .equal,
            toItem: self.mainView,
            attribute: .left,
            multiplier: 1,
            constant: 0))
        self.mainView.addConstraint(NSLayoutConstraint(
            item: self.pageViewController.view!,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.mainView,
            attribute: .bottom,
            multiplier: 1,
            constant: 0))
        self.mainView.addConstraint(NSLayoutConstraint(
            item: self.pageViewController.view!,
            attribute: .right,
            relatedBy: .equal,
            toItem: self.mainView,
            attribute: .right,
            multiplier: 1,
            constant: 0))
    }
    
    /// updates the contents of the resuable view controller for the given index
    /// and then returns the reusable view controller
    func viewController(at index: Int) -> PageContentViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageContentViewController") as? PageContentViewController
        else {
            return PageContentViewController()
        }
        
        viewController.index = index
        viewController.imageString = self.pageImages[index]
        viewController.color = self.pageColors[index]
        
        return viewController
    }
}

extension PageMainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! PageContentViewController
        let index = viewController.index as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        return self.viewController(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let viewController = viewController as! PageContentViewController
        let index = viewController.index as Int
        
        if index == NSNotFound || index + 1 == self.pageImages.count {
            return nil
        }
        
        return self.viewController(at: index + 1)
    }
}

extension PageMainViewController: UIPageViewControllerDelegate {
    
    /// updates currentIndex after current page finishes loading
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let currentViewController = pageViewController.viewControllers![0] as? PageContentViewController {
                currentIndex = currentViewController.index
            }
        }
    }
}
