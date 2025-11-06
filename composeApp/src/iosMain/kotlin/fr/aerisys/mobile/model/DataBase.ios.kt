package fr.aerisys.mobile.model

import app.cash.sqldelight.driver.native.NativeSqliteDriver
import fr.aerisys.mobile.db.AerisysDatabase
import org.koin.dsl.module

actual fun databaseModule() = module {
    single {
        val driver = NativeSqliteDriver(AerisysDatabase.Schema, "AerisysDatabase.db")
        AerisysDatabase(driver)
    }
}