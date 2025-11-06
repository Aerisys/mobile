package fr.aerisys.mobile

import android.app.Application
import fr.aerisys.mobile.di.initKoin
import org.koin.android.ext.koin.androidContext

class MyApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        initKoin { androidContext(this@MyApplication) }
    }
}