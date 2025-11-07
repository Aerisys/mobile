package fr.aerisys.mobile.ui.screens.drone

import aerisys.composeapp.generated.resources.Res
import aerisys.composeapp.generated.resources.en_name
import aerisys.composeapp.generated.resources.en_ok
import aerisys.composeapp.generated.resources.en_status
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.layout.wrapContentHeight
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Card
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FabPosition
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import fr.aerisys.mobile.model.Drone
import fr.aerisys.mobile.ui.components.BottomNavigationBar
import fr.aerisys.mobile.ui.viewmodel.DroneViewModel
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DroneScreen(
    isAdd: Boolean,
    drone: Drone,
    viewModel: DroneViewModel = koinViewModel<DroneViewModel>(),
    onBack: () -> Unit = {}
) {
    var name by remember { mutableStateOf(drone.name) }
    val errorMessage by viewModel.errorMessage.collectAsStateWithLifecycle()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Drone Details") },
                navigationIcon = {
                    IconButton(onClick = { onBack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                }
            )
        },
        content = { padding ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(padding)
                    .padding(16.dp),
                horizontalAlignment = Alignment.CenterHorizontally
            ) {
                // ID non modifiable
                OutlinedTextField(
                    value = drone.id.toString(),
                    onValueChange = {},
                    label = { Text("ID") },
                    enabled = false,
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(16.dp))

                // Nom modifiable
                OutlinedTextField(
                    value = name,
                    onValueChange = { name = it },
                    label = { Text("Name") },
                    modifier = Modifier.fillMaxWidth()
                )

                Spacer(modifier = Modifier.height(24.dp))

                if(errorMessage != ""){
                    Text(errorMessage)
                }
                // Bouton Valider
                Button(
                    onClick = {
                        val droneSend = drone.copy(name = name)
                        if(isAdd){viewModel.addDrone(droneSend)}
                        else {viewModel.updateDrone(droneSend)}
                        onBack()},
                    colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2196F3)), // bleu
                    modifier = Modifier.fillMaxWidth()
                ) {
                    Text("Valider", color = Color.White)
                }

                if(!isAdd){
                    Spacer(modifier = Modifier.height(16.dp))

                    // Bouton Supprimer
                    Button(
                        onClick = {  },
                        colors = ButtonDefaults.buttonColors(containerColor = Color(0xFFF44336)), // rouge
                        modifier = Modifier.fillMaxWidth()
                    ) {
                        Text("Supprimer", color = Color.White)
                    }
                }
            }
        }
    )
}
