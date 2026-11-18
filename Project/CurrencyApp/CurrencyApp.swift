//  База, источник, библиотека и модели экранов создаются
//  один раз здесь и раздаются готовыми. Иначе каждый экран
//  завёл бы себе собственный кэш и ходил в сеть отдельно.
//

import SwiftUI
import SwiftData
import CurrencyCore

@main
@MainActor
struct CurrencyApp: App {

    @State private var hub = Hub()

    var body: some Scene {
        WindowGroup {
            RootScreen(hub: hub)
        }
    }
}

/// Общие зависимости приложения.
@MainActor
@Observable
final class Hub {

    let library: RateLibrary
    let store: RateStore
    let favourites: Favourites

    //  Модели экранов живут столько же, сколько приложение:
    //  при переключении вкладок состояние не сбрасывается.
    let rates: RatesModel
    let converter: ConverterModel
    let favouritesModel: FavouritesModel
    let settings: SettingsModel

    init() {
        //  Если база не открылась — работаем на памяти.
        //  Приложение без сохранения лучше, чем не запустившееся.
        let хранилище: RateStore & Favourites
        if let контейнер = try? ModelContainer(
            for: SavedRate.self, SavedFavourite.self) {
            хранилище = SwiftDataStore(modelContainer: контейнер)
        } else {
            хранилище = MemoryRateStore()
        }

        let библиотека = RateLibrary(source: CBRSource(),
                                     store: хранилище)

        self.store = хранилище
        self.favourites = хранилище
        self.library = библиотека

        self.rates = RatesModel(library: библиотека,
                                favourites: хранилище)
        self.converter = ConverterModel(library: библиотека)
        self.favouritesModel = FavouritesModel(library: библиотека,
                                               favourites: хранилище)
        self.settings = SettingsModel(store: хранилище,
                                      library: библиотека)
    }
}
