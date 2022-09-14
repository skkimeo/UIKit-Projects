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

class BullsEyeTests: XCTestCase {
  
  /// System Under Test: 테스트 클래스가 테스트하려는 객체
  /// 테스트 클래스 내부의 모든 메서드와 프로퍼티가 테스트 대상 객체에 접근할 수 있도록 선언
  private var sut: BullsEyeGame!
  
  override func setUpWithError() throws {
    try super.setUpWithError()
    self.sut = BullsEyeGame()
    
  }
  
  override func tearDownWithError() throws {
    self.sut = nil
    try super.tearDownWithError()
  }
  
  func testScoreIsComputedWhenGuessIsHigherThanTarget() {
    // given: set up values needed
    let guess = self.sut.targetValue - 5
    
    // when: executed code being tested
    self.sut.check(guess: guess)
    
    // then: assert the expected result with a failure message
    XCTAssertEqual(self.sut.scoreRound, 95, "Score computed from guess is wrong")
  }
  
  func testScoreIsComputedPerformanc() {
    self.measure(
      metrics: [
        XCTClockMetric(),
        XCTCPUMetric(),
        XCTStorageMetric(),
        XCTMemoryMetric()
      ]) {
        self.sut.check(guess: 100)
      }
  }
}
