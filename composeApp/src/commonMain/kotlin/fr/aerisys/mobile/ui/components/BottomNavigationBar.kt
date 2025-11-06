package fr.aerisys.mobile.ui.components

import aerisys.composeapp.generated.resources.Res
import aerisys.composeapp.generated.resources.en_controller
import aerisys.composeapp.generated.resources.en_drone
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Flight
import androidx.compose.material.icons.filled.SettingsRemote
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import org.jetbrains.compose.resources.stringResource

/* TODO: Ajouter des paramétres */
@Composable
fun BottomNavigationBar() {
    NavigationBar(tonalElevation = 10.dp) {
        NavigationBarItem(
            selected = true,
            onClick = { /* TODO: stay */ },
            icon = { Icon(Icons.Default.Flight, contentDescription = stringResource(Res.string.en_drone), tint = Color.White) },
            label = { Text(stringResource(Res.string.en_drone)) }
        )
        NavigationBarItem(
            selected = false,
            onClick = { /* TODO: navigate controller */ },
            icon = { Icon(Icons.Default.SettingsRemote, contentDescription = stringResource(Res.string.en_controller), tint = Color.White) },
            label = { Text(stringResource(Res.string.en_controller)) }
        )
    }
}
