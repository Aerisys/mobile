package fr.aerisys.mobile.di

import org.koin.core.context.startKoin
import org.koin.dsl.KoinAppDeclaration

fun initKoin(appDeclaration: KoinAppDeclaration = {}) =
    startKoin {
        appDeclaration()
//        modules(apiModule, viewModelModule)
    }

fun initKoin() = initKoin {}

//val viewModelModule = module {
//    viewModelOf(::HomeViewModel)
//}
