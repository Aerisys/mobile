package fr.aerisys.mobile.di

import org.koin.core.context.startKoin
import org.koin.core.module.Module
import org.koin.dsl.KoinAppDeclaration

expect fun databaseModule(): Module
fun initKoin(appDeclaration: KoinAppDeclaration = {}) =
    startKoin {
        appDeclaration()
        modules(databaseModule())
    }

fun initKoin() = initKoin {}

//val viewModelModule = module {
//    viewModelOf(::HomeViewModel)
//}
