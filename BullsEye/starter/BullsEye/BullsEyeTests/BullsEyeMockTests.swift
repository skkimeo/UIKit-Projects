/// Copyright (c) 2022 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import XCTest
@testable import BullsEye

final class MockUserDefaults: UserDefaults {
  var gameStyleChanged = Int.zero
  
  override func set(_ value: Int, forKey defaultName: String) {
    if defaultName == "gameStyle" {
      self.gameStyleChanged += 1
    }
  }
}

class BullsEyeMockTests: XCTestCase {
  
  private var sut: ViewController!
  private var mockUserDefaults: MockUserDefaults!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    self.sut = UIStoryboard(
      name: "Main",
      bundle: nil
    ).instantiateInitialViewController() as? ViewController
    self.mockUserDefaults = MockUserDefaults(suiteName: "testing")
    self.sut.defaults = self.mockUserDefaults
  }
  
  override func tearDownWithError() throws {
    self.sut = nil
    self.mockUserDefaults = nil
    try super.tearDownWithError()
  }
  
  func testGameStyleCanBeChange() {
    // given
    let segmentedControl = UISegmentedControl()
    
    // when
    XCTAssertEqual(
      self.mockUserDefaults.gameStyleChanged,
      .zero,
      "gameStyleChanged should be 0 b/f sendActions"
    )
    
    segmentedControl.addTarget(
      self.sut,
      action: #selector(ViewController.chooseGameStyle(_:)),
      for: .valueChanged
    )
    segmentedControl.sendActions(for: .valueChanged)
    
    // then
    XCTAssertEqual(
      self.mockUserDefaults.gameStyleChanged,
      1,
      "gameStyle user default wasn't changed"
    )
  }
}
