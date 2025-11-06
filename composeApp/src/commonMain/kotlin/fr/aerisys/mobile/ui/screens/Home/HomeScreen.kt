package fr.aerisys.mobile.ui.screens.Home

import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun HomeScreen(onClickDrone: ()-> Unit={}) {
    Scaffold(
        topBar = { TopAppBar(title = { Text("Accueil") }) }
    ) { padding ->
        Column(
            modifier = Modifier
                .padding(padding)
                .fillMaxSize(),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Text("Bienvenue dans l’application Drone !")
            Spacer(Modifier.height(16.dp))
            Button(onClick = { onClickDrone() }) {
                Text("Voir la liste des drones")
            }
        }
    }
}
