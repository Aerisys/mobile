package fr.aerisys.mobile.ui

import androidx.compose.runtime.Composable
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import fr.aerisys.mobile.ui.screens.Home.HomeScreen
import fr.aerisys.mobile.ui.screens.ListDrone.ListDroneScreen

@Composable
fun AppNavHost(navController: NavHostController) {
    NavHost(navController = navController, startDestination = "home") {
        composable("home") {
            HomeScreen({
                navController.navigate("listDrone")
            })
        }
        composable("listDrone") {
            ListDroneScreen(onBack = {navController.popBackStack()})
        }
    }
}

