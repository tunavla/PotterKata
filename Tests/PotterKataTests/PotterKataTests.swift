import XCTest
@testable import PotterKata

final class PotterKataTests: XCTestCase {
    var sut: PotterBookDiscountCalculation!

    override func setUp() {
        super.setUp()
        sut = PotterBookDiscountCalculation()
    }

    func test_selectOneBook_getZeroDiscountPrice() {
        let books = [1]
        let result = 0

        let discount = sut.calculateDiscount(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select1_2_2Books_get0_8DollarsDiscount(){
        let books = [1, 2, 2]
        let result = (8 + 8) * 0.05

        let discount = sut.calculateDiscount(books: books)

        XCTAssertEqual(discount, result)
    }

    func test_select1_2x2_3x2Books_get0_8DollarsDiscount(){
        let books = [1, 2, 2, 3, 3]
        let result = (8 + 8) * 0.05

        let discount = sut.calculateDiscount(books: books)

        XCTAssertEqual(discount, result)
    }
}

