package fr.aerisys.mobile.ui

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import fr.aerisys.mobile.ui.screens.home.HomeScreen
import fr.aerisys.mobile.ui.screens.listdrone.ListDroneScreen
import kotlinx.serialization.Serializable

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data object ListDroneRoute
}

@Composable
fun AppNavHost(navController: NavHostController) {
    NavHost(navController = navController, startDestination = Routes.HomeRoute) {
        composable<Routes.HomeRoute> {
            HomeScreen({
                navController.navigate(Routes.ListDroneRoute)
            })
        }
        composable<Routes.ListDroneRoute> {
            ListDroneScreen(onBack = {navController.popBackStack()})
        }
    }
}

