package fr.aerisys.mobile.ui.screens.droneHome

import aerisys.composeapp.generated.resources.Res
import aerisys.composeapp.generated.resources.back
import aerisys.composeapp.generated.resources.delete
import aerisys.composeapp.generated.resources.drone
import aerisys.composeapp.generated.resources.edit
import aerisys.composeapp.generated.resources.validate
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
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
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import fr.aerisys.mobile.model.Drone
import fr.aerisys.mobile.ui.components.MyButton
import fr.aerisys.mobile.ui.viewmodel.DroneViewModel
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DroneHomeScreen(
    drone: Drone,
    viewModel: DroneViewModel = koinViewModel<DroneViewModel>(),
    onBack: () -> Unit = {},
    onEdit: (Drone) -> Unit = {}
) {
//    var name by remember { mutableStateOf(drone.name) }
//    val errorMessage by viewModel.errorMessage.collectAsStateWithLifecycle()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text(stringResource(Res.string.drone)) },
                navigationIcon = {
                    IconButton(onClick = { onBack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = stringResource(Res.string.back))
                    }
                },
                actions = {
                    IconButton(onClick = { onEdit(drone) }) {
                        Icon(Icons.Default.Edit, contentDescription = stringResource(Res.string.edit))
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
                Text(drone.name)
            }
        }
    )
}