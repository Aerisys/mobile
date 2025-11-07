package fr.aerisys.mobile.ui.components.navbar

import aerisys.composeapp.generated.resources.Res
import aerisys.composeapp.generated.resources.controller
import aerisys.composeapp.generated.resources.drone
import aerisys.composeapp.generated.resources.graph
import aerisys.composeapp.generated.resources.third_dimension
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Flight
import androidx.compose.material.icons.filled.Info
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.filled.SettingsRemote
import androidx.compose.ui.graphics.vector.ImageVector
import org.jetbrains.compose.resources.StringResource

enum class NavBarType {
    HOME,
    DRONE
}

data class NavBarItem(
    val icon: ImageVector,
    val labelRes: StringResource,
    val route: String
)

val navBarItemsByType = mapOf(
    NavBarType.HOME to listOf(
        NavBarItem(Icons.Default.Flight, Res.string.drone, "drone"),
        NavBarItem(Icons.Default.SettingsRemote, Res.string.controller, "controller")
    ),
    NavBarType.DRONE to listOf(
        NavBarItem(Icons.Default.Settings, Res.string.graph, "graph"),
        NavBarItem(Icons.Default.Info, Res.string.third_dimension, "3d")
    )
)
