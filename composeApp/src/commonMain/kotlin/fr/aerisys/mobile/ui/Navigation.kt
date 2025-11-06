package fr.aerisys.mobile.ui

import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.NavHostController
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import fr.aerisys.mobile.ui.screens.HomeScreen
import kotlinx.serialization.Serializable

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data class DetailRoute(val id: Int)
}

@Composable
fun AppNavigation(modifier: Modifier = Modifier) {

    val navHostController: NavHostController = rememberNavController()
//    val homeViewModel: HomeViewModel = koinViewModel<HomeViewModel>()

    NavHost(
        navController = navHostController, startDestination = Routes.HomeRoute,
        modifier = modifier
    ) {
        composable<Routes.HomeRoute> {

            HomeScreen(
//                mainViewModel = homeViewModel,
            )
        }

//        composable<Routes.DetailRoute> {
//            val detailRoute = it.toRoute<Routes.DetailRoute>()
//            val weatherBean = mainViewModel.dataList.collectAsStateWithLifecycle().value.first { it.id == detailRoute.id }
//
//            DetailScreen(
//                data = weatherBean,
//                onBack = {
//                    navHostController.popBackStack()
//                }
//            )
//        }
    }
}