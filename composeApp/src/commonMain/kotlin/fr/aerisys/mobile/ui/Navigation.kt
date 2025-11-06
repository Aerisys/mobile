package fr.aerisys.mobile.ui

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import fr.aerisys.mobile.ui.screens.Home.HomeScreen
import fr.aerisys.mobile.ui.screens.ListDrone.ListDroneScreen
import fr.aerisys.mobile.ui.screens.homeScreen.HomeScreen
import fr.aerisys.mobile.ui.screens.listDrone.ListDroneScreen
import kotlinx.serialization.Serializable

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data object ListDroneRoute
}

@Composable
fun AppNavHost(navController: NavHostController) {
    NavHost(navController = navController, startDestination = "home") {
        composable<Routes.HomeRoute> {
            HomeScreen({
                navController.navigate("listDrone")
            })
        }
        composable<Routes.ListDroneRoute> {
            ListDroneScreen(onBack = {navController.popBackStack()})
        }
    }
}

