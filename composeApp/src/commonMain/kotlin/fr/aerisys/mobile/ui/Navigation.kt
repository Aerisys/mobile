package fr.aerisys.mobile.ui

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute
import fr.aerisys.mobile.ui.screens.CameraDetailsScreen
import fr.aerisys.mobile.ui.screens.CameraStreamScreen
import fr.aerisys.mobile.ui.screens.HomeScreen
import fr.aerisys.mobile.viewModel.CameraViewModel
import kotlinx.serialization.Serializable
import org.koin.compose.viewmodel.koinViewModel

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data class CameraStreamRoute(val id: Long)
    data class CameraDetailsRoute(val id: Long)
}

@Composable
fun AppNavigation(modifier: Modifier = Modifier) {

    val navHostController = rememberNavController()
    val cameraViewModel = koinViewModel<CameraViewModel>()

    NavHost(
        navController = navHostController,
        startDestination = Routes.HomeRoute,
        modifier = modifier
    ) {
        composable<Routes.HomeRoute> {
            HomeScreen()
        }

        composable<Routes.CameraDetailsRoute> {
            val cameraRoute = it.toRoute<Routes.CameraDetailsRoute>()
            val cameraBean = cameraViewModel.camerasList.collectAsStateWithLifecycle()
                .value.first { w -> w.id == cameraRoute.id }

            CameraDetailsScreen(
                cameraBean = cameraBean,
            )
        }

        composable<Routes.CameraStreamRoute> {
            val cameraRoute = it.toRoute<Routes.CameraStreamRoute>()
            val cameraBean = cameraViewModel.camerasList.collectAsStateWithLifecycle()
                .value.first { w -> w.id == cameraRoute.id }

            CameraStreamScreen(
                cameraBean = cameraBean,
            )
        }
    }
}
