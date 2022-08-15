import XCTest
@testable import PotterKata

final class PotterKataTests: XCTestCase {
    var sut: PotterBookDiscountCalculation!

    override func setUp() {
        super.setUp()
        sut = PotterBookDiscountCalculation()
    }

    func test_selectOneBook_getZeroDiscountPrice() {
        XCTAssertEqual(sut.calculateDiscount(books: [1]), 0)
    }

    func test_select1_2_2Books_get80CentsDiscount() {
        let books = [1, 2, 2]

        let discount = sut.calculateDiscount(books: books)

        let result = (8 + 8) * 0.05
        XCTAssertEqual(discount, result)
    }
}

