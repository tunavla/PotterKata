typealias BookTitleId = Int

typealias BooksTitles = [BookTitleId]

struct PotterBookStore {
    let bookPrice: Double = 8

    func calculateTotalPrice(books: BooksTitles) -> Double {
        let discountBooksPrice = calculatePriceForBooksWithDiscount(books: books)
        let booksWithoutDiscountPrice = calculatePriceForBooksWithoutDiscount(books: books)


        return discountBooksPrice + booksWithoutDiscountPrice
    }

    private func calculatePriceForBooksWithDiscount(books: BooksTitles) -> Double {
        let lengthSets = getDiscountSets(books: books)
        return lengthSets.reduce(Double.zero) { partialResult, length in
            partialResult + getPriceWithDiscount(count: length)
        }
    }

    private func calculatePriceForBooksWithoutDiscount(books: BooksTitles) -> Double {
        let discountLengthSets = getDiscountSets(books: books)
        let discountBooksCount = discountLengthSets.reduce(0, +)
        let booksWithoutDiscountCount = books.count - discountBooksCount
        return Double(booksWithoutDiscountCount) * bookPrice
    }

    private func getPriceWithDiscount(count: Int) -> Double {
        let totalPrice = Double(count) * 8
        let discount: Double = {
            switch count {
            case 2: return 0.05
            case 3: return 0.1
            case 4: return 0.15
            case 5: return 0.25
            case 6: return 0.3
            case 7: return 0.35
            default: return 0
            }
        }()
        return (1 - discount) * totalPrice
    }

    private func getDiscountSets(books: BooksTitles) -> [Int] {
        guard books.count > 1 else { return [] }
        var deletableBooks = books
        var result: [Int] = []
        while Set(deletableBooks).count > 1 {
            let set = Set(deletableBooks)
            result.append(set.count)
            deletableBooks.remove(set: set)
        }
        return result
    }
}

extension BooksTitles {
    mutating func remove(_ element: BookTitleId) {
        let index = firstIndex { $0 == element }
        remove(at: index!)
    }

    mutating func remove(set: Set<BookTitleId>) {
        set.forEach { remove($0) }
    }
}
