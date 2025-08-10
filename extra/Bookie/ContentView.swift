import SwiftUI

// MARK: - Book Model

struct Book: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var author: String
    var note: String
    var status: ReadingStatus
    var isFavorite: Bool = false
    
    // For BookExplore, add optional synopsis & image URL (dummy)
    var synopsis: String? = nil
    var imageName: String? = nil
}

enum ReadingStatus: String, Codable, CaseIterable {
    case notStarted = "Not Started"
    case reading = "Reading"
    case completed = "Completed"
    
    mutating func toggle() {
        let all = ReadingStatus.allCases
        if let index = all.firstIndex(of: self) {
            self = all[(index + 1) % all.count]
        }
    }
    
    var emoji: String {
        switch self {
        case .notStarted: return "📕"
        case .reading: return "📘"
        case .completed: return "📗"
        }
    }
}

// MARK: - ViewModel

class BookViewModel: ObservableObject {
    @Published var books: [Book] = [] {
        didSet { saveBooks() }
    }
    
    init() {
        loadBooks()
    }
    
    func addBook(title: String, author: String, note: String, status: ReadingStatus) {
        let newBook = Book(title: title, author: author, note: note, status: status)
        books.append(newBook)
    }
    
    func addBook(_ book: Book) {
        // Add only if not already in My Books (check by title+author)
        if !books.contains(where: { $0.title == book.title && $0.author == book.author }) {
            books.append(book)
        }
    }
    
    func update(book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = book
        }
    }
    
    func deleteBooks(at offsets: IndexSet) {
        books.remove(atOffsets: offsets)
    }
    
    private func saveBooks() {
        if let encoded = try? JSONEncoder().encode(books) {
            UserDefaults.standard.set(encoded, forKey: "books")
        }
    }
    
    private func loadBooks() {
        if let data = UserDefaults.standard.data(forKey: "books"),
           let decoded = try? JSONDecoder().decode([Book].self, from: data) {
            books = decoded
        }
    }
    
    func toggleFavorite(for book: Book) {
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index].isFavorite.toggle()
        }
    }
}

// MARK: - Main ContentView with Tabs

struct ContentView: View {
    @StateObject var viewModel = BookViewModel()
    
    var body: some View {
        TabView {
            MyBooksView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("My Books", systemImage: "book.closed")
                }
            
            BookExploreView()
                .environmentObject(viewModel)
                .tabItem {
                    Label("BookExplore", systemImage: "magnifyingglass")
                }
        }
    }
}

// MARK: - MyBooksView (Your existing library UI)

struct MyBooksView: View {
    @EnvironmentObject var viewModel: BookViewModel
    @State private var showAddBook = false
    @State private var selectedBook: Book?
    @State private var selectedFilter: ReadingStatus? = nil
    @State private var showFavoritesOnly = false
    @State private var searchText = ""
    
    var filteredBooks: [Book] {
        viewModel.books.filter { book in
            (selectedFilter == nil || book.status == selectedFilter) &&
            (!showFavoritesOnly || book.isFavorite) &&
            (searchText.isEmpty ||
             book.title.localizedCaseInsensitiveContains(searchText) ||
             book.author.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("My Books")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Menu {
                        Button("All", action: { selectedFilter = nil })
                        ForEach(ReadingStatus.allCases, id: \.self) { status in
                            Button(status.rawValue, action: { selectedFilter = status })
                        }
                    } label: {
                        Label("Filter", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    
                    Button(action: {
                        showFavoritesOnly.toggle()
                    }) {
                        Image(systemName: showFavoritesOnly ? "star.fill" : "star")
                            .foregroundColor(showFavoritesOnly ? .yellow : .gray)
                            .imageScale(.large)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.leading, 8)
                    
                    Button(action: { showAddBook = true }) {
                        Text("+ Add Book")
                    }
                }
                .padding(.horizontal)
                
                TextField("Search by title or author", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.horizontal, .top])
                
                List {
                    ForEach(filteredBooks) { book in
                        HStack {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(book.status.emoji) \(book.title)").font(.headline)
                                Text("✍️ \(book.author)").font(.subheadline)
                                if !book.note.isEmpty {
                                    Text("📝 \(book.note)").font(.caption)
                                }
                            }
                            Spacer()
                            Button(action: {
                                viewModel.toggleFavorite(for: book)
                            }) {
                                Image(systemName: book.isFavorite ? "star.fill" : "star")
                                    .foregroundColor(book.isFavorite ? .yellow : .gray)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .padding(.vertical, 6)
                        .onTapGesture {
                            selectedBook = book
                        }
                    }
                    .onDelete(perform: viewModel.deleteBooks)
                }
                .listStyle(PlainListStyle())
                .sheet(item: $selectedBook) { book in
                    EditBookView(book: book, viewModel: viewModel)
                }
            }
            .sheet(isPresented: $showAddBook) {
                AddBookView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - BookExploreView (Browse catalog & add to My Books)

struct BookExploreView: View {
    @EnvironmentObject var viewModel: BookViewModel
    @State private var selectedBook: Book?
    
    // Sample catalog data (replace with real API or database later)
    let catalog: [Book] = [
        Book(title: "1984", author: "George Orwell", note: "", status: .notStarted,
             synopsis: "Dystopian novel about totalitarian regime.", imageName: "book.closed"),
        Book(title: "Pride and Prejudice", author: "Jane Austen", note: "", status: .notStarted,
             synopsis: "Classic romance novel set in 19th century England.", imageName: "book.closed"),
        Book(title: "The Hobbit", author: "J.R.R. Tolkien", note: "", status: .notStarted,
             synopsis: "Fantasy adventure of Bilbo Baggins in Middle-earth.", imageName: "book.closed"),
        Book(title: "To Kill a Mockingbird", author: "Harper Lee", note: "", status: .notStarted,
             synopsis: "Novel about racial injustice in the American South.", imageName: "book.closed"),
        
        // Additional books
        Book(title: "The Great Gatsby", author: "F. Scott Fitzgerald", note: "", status: .notStarted,
             synopsis: "A critique of the American Dream in the Roaring Twenties.", imageName: "book.closed"),
        Book(title: "Moby-Dick", author: "Herman Melville", note: "", status: .notStarted,
             synopsis: "Captain Ahab's obsessive quest to hunt the white whale.", imageName: "book.closed"),
        Book(title: "War and Peace", author: "Leo Tolstoy", note: "", status: .notStarted,
             synopsis: "Epic novel covering Russian society during Napoleonic wars.", imageName: "book.closed"),
        Book(title: "Crime and Punishment", author: "Fyodor Dostoevsky", note: "", status: .notStarted,
             synopsis: "Psychological novel about guilt and redemption.", imageName: "book.closed"),
        Book(title: "The Catcher in the Rye", author: "J.D. Salinger", note: "", status: .notStarted,
             synopsis: "Teenager Holden Caulfield's struggle with identity and alienation.", imageName: "book.closed"),
        Book(title: "Brave New World", author: "Aldous Huxley", note: "", status: .notStarted,
             synopsis: "Dystopian future with engineered society and loss of individuality.", imageName: "book.closed"),
        Book(title: "Jane Eyre", author: "Charlotte Brontë", note: "", status: .notStarted,
             synopsis: "A young woman's journey for independence and love.", imageName: "book.closed"),
        Book(title: "The Odyssey", author: "Homer", note: "", status: .notStarted,
             synopsis: "Epic poem about Odysseus' long journey home after the Trojan War.", imageName: "book.closed"),
        Book(title: "Frankenstein", author: "Mary Shelley", note: "", status: .notStarted,
             synopsis: "A scientist creates a living being with tragic consequences.", imageName: "book.closed"),
        Book(title: "The Brothers Karamazov", author: "Fyodor Dostoevsky", note: "", status: .notStarted,
             synopsis: "Philosophical novel about faith, doubt, and morality.", imageName: "book.closed"),
        Book(title: "Great Expectations", author: "Charles Dickens", note: "", status: .notStarted,
             synopsis: "The personal growth and trials of an orphan named Pip.", imageName: "book.closed"),
        Book(title: "Wuthering Heights", author: "Emily Brontë", note: "", status: .notStarted,
             synopsis: "A dark tale of passionate but doomed love.", imageName: "book.closed"),
        Book(title: "Anna Karenina", author: "Leo Tolstoy", note: "", status: .notStarted,
             synopsis: "Tragic story of love and societal expectations.", imageName: "book.closed"),
        Book(title: "Don Quixote", author: "Miguel de Cervantes", note: "", status: .notStarted,
             synopsis: "Adventures of a man who believes he is a knight-errant.", imageName: "book.closed"),
    ]

    
    var body: some View {
        NavigationView {
            List(catalog) { book in
                HStack(spacing: 12) {
                    Image(systemName: book.imageName ?? "book")
                        .resizable()
                        .frame(width: 40, height: 50)
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text(book.title).font(.headline)
                        Text(book.author).font(.subheadline)
                        if let synopsis = book.synopsis {
                            Text(synopsis)
                                .font(.caption)
                                .lineLimit(2)
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedBook = book
                }
            }
            .navigationTitle("BookExplore")
            .sheet(item: $selectedBook) { book in
                BookExploreDetailView(book: book, viewModel: _viewModel)
            }
        }
    }
}

// MARK: - BookExploreDetailView (Show details & add button)

struct BookExploreDetailView: View {
    var book: Book
    @EnvironmentObject var viewModel: BookViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Image(systemName: book.imageName ?? "book")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 150)
                    .foregroundColor(.blue)
                    .padding()
                
                Text(book.title)
                    .font(.title)
                    .bold()
                Text("by \(book.author)")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                if let synopsis = book.synopsis {
                    Text(synopsis)
                        .font(.body)
                        .padding(.top)
                }
                
                Spacer()
                
                Button(action: {
                    // Add to My Books with default status and empty note
                    let newBook = Book(title: book.title,
                                       author: book.author,
                                       note: "",
                                       status: .notStarted)
                    viewModel.addBook(newBook)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Add to My Books")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.cornerRadius(10))
                        .foregroundColor(.white)
                        .font(.headline)
                }
            }
            .padding()
            .navigationBarTitle("Book Details", displayMode: .inline)
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Add Book View

struct AddBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BookViewModel
    
    @State private var title = ""
    @State private var author = ""
    @State private var note = ""
    @State private var status: ReadingStatus = .notStarted
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextField("Note", text: $note)
                Picker("Status", selection: $status) {
                    ForEach(ReadingStatus.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
            .navigationBarTitle("Add Book")
            .navigationBarItems(trailing: Button("Save") {
                viewModel.addBook(title: title, author: author, note: note, status: status)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// MARK: - Edit Book View

struct EditBookView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: BookViewModel
    
    @State private var title: String
    @State private var author: String
    @State private var note: String
    @State private var status: ReadingStatus
    var book: Book
    
    init(book: Book, viewModel: BookViewModel) {
        self.book = book
        self.viewModel = viewModel
        _title = State(initialValue: book.title)
        _author = State(initialValue: book.author)
        _note = State(initialValue: book.note)
        _status = State(initialValue: book.status)
    }
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextField("Note", text: $note)
                Picker("Status", selection: $status) {
                    ForEach(ReadingStatus.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
            }
            .navigationBarTitle("Edit Book")
            .navigationBarItems(trailing: Button("Save") {
                var updatedBook = book
                updatedBook.title = title
                updatedBook.author = author
                updatedBook.note = note
                updatedBook.status = status
                viewModel.update(book: updatedBook)
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

