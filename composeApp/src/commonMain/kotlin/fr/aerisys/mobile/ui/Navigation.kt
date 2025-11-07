package fr.aerisys.mobile.ui

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute
import fr.aerisys.mobile.ui.screens.CameraScreen
import fr.aerisys.mobile.ui.screens.HomeScreen
import fr.aerisys.mobile.viewModel.CameraViewModel
import fr.aerisys.mobile.viewModel.MainViewModel
import kotlinx.serialization.Serializable
import org.koin.compose.viewmodel.koinViewModel

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data class CameraRoute(val id: Long)
}

@Composable
fun AppNavigation(modifier: Modifier = Modifier) {

    val navHostController = rememberNavController()
    val cameraViewModel = koinViewModel<CameraViewModel>()
    val mainViewModel = koinViewModel<MainViewModel>()

    Scaffold { innerPadding ->

        NavHost(
            navController = navHostController,
            startDestination = Routes.HomeRoute,
            modifier = modifier.padding(innerPadding)
        ) {

            composable<Routes.HomeRoute> {
                HomeScreen(mainViewModel = mainViewModel)
            }

            composable<Routes.CameraRoute> {
                val cameraRoute = it.toRoute<Routes.CameraRoute>()
                val weatherBean = cameraViewModel.cameras.collectAsStateWithLifecycle()
                    .value.first { w -> w.id == cameraRoute.id }

                CameraScreen(
                    cameraBean = weatherBean,
                )
            }

        }
    }
}
