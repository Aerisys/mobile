package fr.aerisys.mobile.ui

import androidx.compose.runtime.Composable
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import androidx.navigation.toRoute
import fr.aerisys.mobile.model.Drone
import fr.aerisys.mobile.ui.screens.drone.DroneScreen
import fr.aerisys.mobile.ui.screens.droneHome.DroneHomeScreen
import fr.aerisys.mobile.ui.screens.dronelist.DroneListScreen
import fr.aerisys.mobile.ui.screens.home.HomeScreen
import fr.aerisys.mobile.ui.viewmodel.DroneViewModel
import kotlinx.serialization.Serializable
import org.koin.compose.viewmodel.koinViewModel

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data object DroneListRoute

    @Serializable
    data class DroneRoute(val id: Long?)

    @Serializable
    data class DroneHomeRoute(val id: Long)
}

@Composable
fun AppNavHost() {
    val viewModel: DroneViewModel = koinViewModel<DroneViewModel>()
    val navController = rememberNavController()
    val onBack: () -> Unit = {
        navController.popBackStack()
    }

    NavHost(navController = navController, startDestination = Routes.DroneListRoute) {
        composable<Routes.HomeRoute> {
            HomeScreen({
                navController.navigate(Routes.DroneListRoute)
            })
        }
        composable<Routes.DroneListRoute> {
            DroneListScreen(viewModel = viewModel,
                onBack = onBack,
                addDrone = {navController.navigate(Routes.DroneRoute(it))},
                openDrone = {navController.navigate(Routes.DroneHomeRoute(it))})
        }
        composable<Routes.DroneRoute> {
            val idDrone= it.toRoute<Routes.DroneRoute>().id
            var isAdd = true
            var drone = Drone()
            if(idDrone != null){
                drone = viewModel.drones.collectAsStateWithLifecycle().value.first(predicate = {it.id == idDrone})
                isAdd = false
            }

            DroneScreen(
                viewModel = viewModel,
                isAdd= isAdd,
                onBack = onBack,
                drone = drone,
                onDeleteBack = {navController.navigate(Routes.DroneListRoute)}
            )
        }
        composable<Routes.DroneHomeRoute> {
            val idDrone= it.toRoute<Routes.DroneHomeRoute>().id
            val drone = viewModel.drones.collectAsStateWithLifecycle().value.first(predicate = {it.id == idDrone})
            DroneHomeScreen(
                onBack = onBack,
                drone = drone,
                onEdit = {drone->navController.navigate(Routes.DroneRoute(drone.id))}
            )
        }
    }
}

