import UIKit

@MainActor
class ReminderViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Int, DetailRow>

    var reminder: Reminder
    private var dataSource: DataSource?

    init(reminder: Reminder) {
        self.reminder = reminder
        var listConfiguration = UICollectionLayoutListConfiguration(
            appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        let listLayout = UICollectionViewCompositionalLayout.list(
            using: listConfiguration
        )
        super.init(collectionViewLayout: listLayout)
    }

    required init?(coder: NSCoder) {
        fatalError("Always initialize ReminderViewController using init(reminder:)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: DetailRow) {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont
            .preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .todayPrimaryTint
    }

    func text(for row: DetailRow) -> String? {
        switch row {
        case .date: return reminder.dueDate.dayText
        case .notes: return reminder.notes
        case .time: return reminder.dueDate.formatted(
            date: .omitted,
            time: .shortened
        )
        case .title: return reminder.title
        }
    }

}
