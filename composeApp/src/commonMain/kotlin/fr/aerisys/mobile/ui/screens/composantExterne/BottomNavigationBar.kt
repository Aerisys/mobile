package fr.aerisys.mobile.ui.screens.composantExterne

import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Flight
import androidx.compose.material.icons.filled.SettingsRemote
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
/* TODO: Ajouter des paramétres */
@Composable
fun BottomNavigationBar() {
    NavigationBar(containerColor = Color(0xFF2A2A2A), tonalElevation = 10.dp) {
        NavigationBarItem(
            selected = true,
            onClick = { /* TODO: stay */ },
            icon = { Icon(Icons.Default.Flight, contentDescription = "Drone", tint = Color.White) },
            label = { Text("Drone", color = Color.White) }
        )
        NavigationBarItem(
            selected = false,
            onClick = { /* TODO: navigate controller */ },
            icon = { Icon(Icons.Default.SettingsRemote, contentDescription = "Controller", tint = Color.White) },
            label = { Text("Controller", color = Color.White) }
        )
    }
}
