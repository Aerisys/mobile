package fr.aerisys.mobile.di

import fr.aerisys.mobile.viewModel.MainViewModel
import org.koin.core.context.startKoin
import org.koin.core.module.Module
import org.koin.dsl.KoinAppDeclaration
import org.koin.dsl.module

expect fun databaseModule(): Module

val viewModelModule = module {
    factory { MainViewModel(get()) }
}

fun initKoin(appDeclaration: KoinAppDeclaration = {}) =
    startKoin {
        appDeclaration()
        modules(databaseModule(), viewModelModule)
    }

fun initKoin() = initKoin {}
