package fr.aerisys.mobile.ui

import androidx.compose.foundation.layout.padding
import androidx.compose.material3.Scaffold
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.navigation.compose.NavHost
import androidx.navigation.compose.composable
import androidx.navigation.compose.rememberNavController
import fr.aerisys.mobile.ui.screens.HomeScreen
import fr.aerisys.mobile.viewModel.MainViewModel
import kotlinx.serialization.Serializable

class Routes {
    @Serializable
    data object HomeRoute

    @Serializable
    data class DetailRoute(val id: Int)
}

@Composable
fun AppNavigation(modifier: Modifier = Modifier, mainViewModel: MainViewModel) {

    val navHostController = rememberNavController()

    Scaffold { innerPadding ->

        NavHost(
            navController = navHostController,
            startDestination = Routes.HomeRoute,
            modifier = modifier.padding(innerPadding)
        ) {

            composable<Routes.HomeRoute> {
                HomeScreen(mainViewModel = mainViewModel)
            }

            /*
            composable<Routes.DetailRoute> {
                val detailRoute = it.toRoute<Routes.DetailRoute>()
                val weatherBean = mainViewModel.dataList.collectAsStateWithLifecycle()
                    .value.first { w -> w.id == detailRoute.id }

                DetailScreen(
                    data = weatherBean,
                    onBack = { navHostController.popBackStack() }
                )
            }
            */
        }
    }
}
