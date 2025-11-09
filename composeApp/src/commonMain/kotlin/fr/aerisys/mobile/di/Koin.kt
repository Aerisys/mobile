package fr.aerisys.mobile.di

import fr.aerisys.mobile.viewModel.MainViewModel
import fr.aerisys.mobile.model.KtorCameraStreamClient
import fr.aerisys.mobile.viewModel.CameraStreamViewModel
import fr.aerisys.mobile.viewModel.CameraViewModel
import io.ktor.client.HttpClient
import io.ktor.client.plugins.logging.LogLevel
import io.ktor.client.plugins.logging.Logger
import io.ktor.client.plugins.logging.Logging
import org.koin.core.context.startKoin
import org.koin.core.module.Module
import org.koin.core.module.dsl.singleOf
import org.koin.dsl.KoinAppDeclaration
import org.koin.dsl.module

expect fun databaseModule(): Module

fun initKoin(appDeclaration: KoinAppDeclaration = {}) =
    startKoin {
        appDeclaration()
        modules(apiModule, databaseModule(), viewModelModule)
    }

val apiModule = module {
    single {
        HttpClient {
            install(Logging) {
                logger = object : Logger {
                    override fun log(message: String) {
                        println(message)
                    }
                }
                level = LogLevel.INFO  // TRACE, HEADERS, BODY, etc.
            }
        }
    }

    singleOf(::KtorCameraStreamClient)
}

val viewModelModule = module {
    factory {
        MainViewModel(get())
        CameraViewModel()
        CameraStreamViewModel(get())
    }
}