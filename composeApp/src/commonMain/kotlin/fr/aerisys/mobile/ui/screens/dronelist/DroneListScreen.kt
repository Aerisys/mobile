package fr.aerisys.mobile.ui.screens.dronelist

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
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.Card
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FabPosition
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.HorizontalDivider
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.lifecycle.compose.collectAsStateWithLifecycle
import androidx.lifecycle.viewmodel.compose.viewModel
import fr.aerisys.mobile.di.droneViewModelModule
import fr.aerisys.mobile.ui.components.BottomNavigationBar
import fr.aerisys.mobile.ui.viewmodel.DroneViewModel
import org.jetbrains.compose.resources.stringResource
import org.koin.compose.viewmodel.koinViewModel

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DroneListScreen(
    onBack: ()-> Unit={},
    addDrone: (Int?)-> Unit={},
    viewModel: DroneViewModel = koinViewModel<DroneViewModel>()
) {
    LaunchedEffect(Unit) {
        // ✅ Code exécuté une seule fois
        viewModel.loadDrones()
    }


    val list = viewModel.drones.collectAsStateWithLifecycle().value
    val errorMessage by viewModel.errorMessage.collectAsStateWithLifecycle()
    val runInProgress by viewModel.runInProgress.collectAsStateWithLifecycle()

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("Drones list") },
                navigationIcon = {
                    IconButton(onClick = { onBack() }) {
                        Icon(Icons.AutoMirrored.Filled.ArrowBack, contentDescription = "Back")
                    }
                },
                actions = {
                    IconButton(onClick = { addDrone(null) }) {
                        Icon(Icons.Default.Add, contentDescription = "Add")
                    }
                },
            )
        },
        bottomBar = {
            BottomNavigationBar()
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = { addDrone(null) },
                containerColor = MaterialTheme.colorScheme.primary
            ) {
                Icon(Icons.Default.Add, contentDescription = "Add Drone", tint = Color.White)
            }
        },
        floatingActionButtonPosition = FabPosition.End
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(Modifier.height(20.dp))

            Card(
                modifier = Modifier
                    .padding(16.dp)
                    .fillMaxWidth()
                    .wrapContentHeight(),
                shape = MaterialTheme.shapes.medium
            ) {
                Column(
                    Modifier
                        .padding(16.dp)
                        .fillMaxWidth()
                ) {
                    Row(
                        Modifier
                            .fillMaxWidth()
                            .padding(bottom = 8.dp),
                        horizontalArrangement = Arrangement.SpaceBetween
                    ) {
                        Text(stringResource(Res.string.en_name))
                        Text(stringResource(Res.string.en_status))
                        Spacer(Modifier.width(24.dp))
                    }

                    HorizontalDivider(Modifier, 1.dp)

                    LazyColumn {
                        items(list.size) {
                            Row(
                                Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 8.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(list[it].name, fontWeight = FontWeight.SemiBold)
                                Text(stringResource(Res.string.en_ok), color = Color.Green)

                            }
                            HorizontalDivider(Modifier,0.5.dp)
                        }
                    }
                }
            }
        }
    }
}
