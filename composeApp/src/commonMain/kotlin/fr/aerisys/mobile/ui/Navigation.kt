package fr.aerisys.mobile.ui

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute
import fr.aerisys.mobile.model.Drone
import fr.aerisys.mobile.ui.screens.drone.DroneScreen
import fr.aerisys.mobile.ui.screens.dronelist.DroneListScreen
import fr.aerisys.mobile.ui.screens.home.HomeScreen
import kotlinx.serialization.Serializable

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data object DroneListRoute

    @Serializable
    data class DroneRoute(val id: Int?)
}

@Composable
fun AppNavHost() {
    val navController = rememberNavController()
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
            DroneListScreen(onBack = onBack,
                addDrone = {navController.navigate(Routes.DroneRoute(it))} )
        }
        composable<Routes.DroneRoute> {
            val idDrone= it.toRoute<Routes.DroneRoute>().id
            var isAdd = true
            val drone= Drone()
            if(idDrone != null){
                isAdd = false
                //drone = ...
                //val droned = mainViewModel.dataList.collectAsStateWithLifecycle().value.first { it.id == detailRoute.id }
            }

            DroneScreen(
                isAdd= isAdd,
                onBack = onBack,
                drone = drone
            )
        }
    }
}

