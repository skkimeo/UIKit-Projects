//
//  PageViewController.swift
//  PageViewPractice
//
//  Created by sun on 2022/02/15.
//

import UIKit

class PageViewController: UIPageViewController {
    
    lazy var pages: [UIViewController] = {
        [self.pageInstance(name: "FirstVC"),
         self.pageInstance(name: "SecondVC"),
         self.pageInstance(name: "ThirdVC")]
    }()
    
    private func pageInstance(name: String) -> UIViewController {
        UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self

        if let firstPage = pages.first {
            setViewControllers([firstPage],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            } else if view is UIPageControl {
                view.backgroundColor = .clear
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreatd
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension PageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = pageIndex - 1
        
        // left most page
        guard previousIndex >= 0 else {
            return pages.last
        }
        
        // right most page
        guard pages.count > previousIndex else {
            return nil
        }
        
        return pages[previousIndex]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let pageIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = pageIndex + 1
        
        //
        guard nextIndex < pages.count else {
            return pages.first
        }
        
        guard nextIndex >= 0 else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        pages.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstPage = viewControllers?.first,
              let firstPageIndex = pages.firstIndex(of: firstPage)
        else { return 0 }
        print(firstPageIndex)
        return firstPageIndex
    }
}

extension PageViewController: UIPageViewControllerDelegate {
    
}
