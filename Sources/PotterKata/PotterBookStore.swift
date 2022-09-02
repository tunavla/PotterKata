import Foundation

class PotterBookStore {

    var prices = [Float](
        repeating: 0,
        count: Constants.librarySize * 2.pow(Constants.librarySize))

    let discount: [Float] = [0, 0, 0.05, 0.10, 0.15, 0.25, 0.30, 0.35]

    init() {
        fillBasePrices()
    }

    func calculateOptimalPrice(_ books: [Int]) -> Float {
        let library = createLibrary(books: books).sorted()
        return getMinPrice(library)
    }

    private func getMinPrice(_ library: [Int]) -> Float {
        let key = getPriceKey(library: library)
        var minPrice: Float = prices[key]

        guard minPrice == 0 else { return minPrice }
        minPrice = .infinity

        var (libraries1, libraries2) = splitLibrary(library)

        for column in 0..<libraries1.count {
            libraries1[column] = libraries1[column].sorted()
            libraries2[column] = libraries2[column].sorted()

            let p1 = getMinPrice(libraries1[column])
            let p2 = getMinPrice(libraries2[column])

            if minPrice > p1+p2 {
                minPrice = p1 + p2
            }
        }

        if canAddDiscount(library) {
            let discountPrice = getDiscountPrice(library)

            if discountPrice < minPrice {
                minPrice = discountPrice
            }
        }

        prices[key] = minPrice
        return minPrice
    }

    /// return array where index is book's title and value is count of that book
    private func createLibrary(books: [Int]) -> [Int] {
        var library = createEmptyLibrary()
        books.forEach { book in
            library[book] += 1
        }
        return library
    }

    /// return the ability to sell at a time
    private func canAddDiscount(_ library: [Int]) -> Bool {
        !library.contains { $0 > 1 }
    }

    private func getDiscountPrice(_ library: [Int]) -> Float {
        var countBookForDiscount: Int = 0
        library.forEach { book in
            if book != 0 { countBookForDiscount += 1 }
        }

        let discount = discount[safe: countBookForDiscount] ?? 0
        let result = (1.0 - discount) * Float(countBookForDiscount) * Constants.bookPrice
        return result
    }

    /// Split library into all possible double subsets
    /// example: [1 1] = [0 1] + [1 0]
    /// example: [2 1] = [1 1] + [1 0] && [2 0] + [0 1]
    private func splitLibrary(_ library: [Int]) -> ([[Int]], [[Int]]) {
        var libraries1: [[Int]] = []
        var libraries2: [[Int]] = []

        library.enumerated().forEach { row, bookCount in
            guard bookCount != 0 else { return }
            var library1 = createEmptyLibrary()
            var library2 = library

            library1[row] += 1
            library2[row] -= 1

            libraries1.append(library1)
            libraries2.append(library2)


            for column in 0..<libraries1.count - 1 {
                guard
                    libraries2[safe: column]?[row] != nil,
                    libraries2[safe: column]?[row] != 0
                else { return }

                library1 = libraries1[column]
                library2 = libraries2[column]

                library1[row] += 1
                library2[row] -= 1

                if getPriceKey(library: library2) != 0 {
                    libraries1.append(library1)
                    libraries2.append(library2)
                }
            }
        }
        return (libraries1, libraries2)

    }

    private func fillBasePrices() {
        for index in 0..<Constants.librarySize {
            var library: [Int] = createEmptyLibrary()
            library[index] = 1
            let key = getPriceKey(library: library)
            prices[key] = Constants.bookPrice
        }
    }

    private func getPriceKey(library: [Int]) -> Int {
        var key = 0

        library.enumerated().forEach { index, book in
            key += book * 2.pow(index)
        }

        return key
    }

    private func createEmptyLibrary() -> [Int] {
        [Int](repeating: 0, count: Constants.librarySize)
    }
}

private extension Int {
    func pow(_ exponent: Int) -> Int {
        NSDecimalNumber(decimal: Foundation.pow(Decimal(self), exponent)).intValue
    }
}

private extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
