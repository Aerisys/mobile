package fr.aerisys.mobile.ui

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import fr.aerisys.mobile.ui.screens.dronelist.DroneListScreen
import fr.aerisys.mobile.ui.screens.home.HomeScreen
import kotlinx.serialization.Serializable

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data object DroneListRoute
}

@Composable
fun AppNavHost(navController: NavHostController) {
    val onBack: () -> Unit = {
        navController.popBackStack()
    }

    NavHost(navController = navController, startDestination = Routes.HomeRoute) {
        composable<Routes.HomeRoute> {
            HomeScreen({
                navController.navigate(Routes.DroneListRoute)
            })
        }
        composable<Routes.DroneListRoute> {
            DroneListScreen(onBack)
        }
    }
}

