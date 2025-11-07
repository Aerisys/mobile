package fr.aerisys.mobile.di

import fr.aerisys.mobile.ui.viewmodel.DroneViewModel
import fr.aerisys.mobile.viewModel.MainViewModel
import kotlinx.coroutines.CoroutineDispatcher
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import org.koin.core.context.startKoin
import org.koin.core.module.Module
import org.koin.dsl.KoinAppDeclaration
import org.koin.dsl.module

expect fun databaseModule(): Module

val droneViewModelModule = module {
    factory<CoroutineDispatcher> { Dispatchers.IO } // Fournit le dispatcher
    factory { DroneViewModel(dispatcher = get(), myDatabase = get()) }
}

fun initKoin(appDeclaration: KoinAppDeclaration = {}) =
    startKoin {
        appDeclaration()
        modules(databaseModule(), droneViewModelModule)
    }

fun initKoin() = initKoin {}
