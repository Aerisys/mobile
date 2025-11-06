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
    NavHost(navController = navController, startDestination = "home") {
        composable<Routes.HomeRoute> {
            HomeScreen({
                navController.navigate("listDrone")
            })
        }
        composable<Routes.DroneListRoute> {
            DroneListScreen(onBack = {navController.popBackStack()})
        }
    }
}

