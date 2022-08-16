import XCTest
@testable import PotterKata

final class PotterKataTests: XCTestCase {
    var sut: PotterBookStore!

    override func setUp() {
        super.setUp()
        sut = PotterBookStore()
    }

    func test_selectOneBook_getFullPrice() {
        let books = [1]
        let result: Float = 8

        assertPrice(result, for: books)
    }

    func test_select2SameBooks_getFullPrice() {
        let books = [1, 1]
        let result: Float = 2 * 8

        assertPrice(result, for: books)
    }

    func test_select2DifferentBooks_getPriceWithDiscount() {
        let books = [1, 2]
        let result: Float = 2 * 8 * 0.95

        assertPrice(result, for: books)
    }

    func test_select1_2_2Books_getPriceWithDiscount(){
        let books = [1, 2, 2]
        let result: Float = (8 + 8) * 0.95 + 8

        assertPrice(result, for: books)
    }

    func test_select1_2x2_3x2Books_getPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3]
        let result: Float = (8 + 8 + 8) * 0.9 + (8 + 8) * 0.95

        assertPrice(result, for: books)
    }

    func test_select1_2x2_3x2_4x2Books_getPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3, 4, 4]
        let result: Float = 8 * 4 * 0.85 + 8 * 3 * 0.9

        assertPrice(result, for: books)
    }

    func test_select1_2x2_3x2_4x2_5x2_Books_getPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3, 4, 4, 5, 5]
        let result: Float =  8 * 5 * 0.75 + 8 * 4 * 0.85

        assertPrice(result, for: books)
    }

    /// In this case 1 each of books one through five make a set of 5 unique books eligible for 25% off, and one each of books two through
    /// six make a similar set, resulting in 10 books at 25% off of $8 (10 * $8 * .75) = $60. If the algorithm had "greedily" used all six unique
    ///  books to get a 30% discount, the remaining 4 books (Two, Three, Four, Five) would only have been eligible for a 15% discount.
    ///  The cost would thus have been (6 * $8 * .7) = $33.60 + (4 * $8 * .85) = $27.20 for a total of $60.80.
    func test_select1_2x2_3x2_4x2_5x2_6x1Books_getOptimalPriceWithDiscount(){
        let books = [1, 2, 2, 3, 3, 4, 4, 5, 5, 6]
        let result: Float =  8 * 5 * 0.75 + 8 * 5 * 0.75
        assertPrice(result, for: books)
    }

    func assertPrice(
        _ expectedPrice: Float,
        for books: [Int],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(sut.calculateOptimalPrice(books), expectedScore, file: file, line: line)
    }

}

