package fr.aerisys.mobile.ui.screens.listDrone

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Edit
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.lifecycle.viewmodel.compose.viewModel
import androidx.navigation.NavController
import fr.aerisys.mobile.ui.screens.composantExterne.BottomNavigationBar
import fr.aerisys.mobile.ui.viewmodel.MainViewModel
@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ListDroneScreen(
    navController: NavController,
    viewModel: MainViewModel = viewModel()
) {
    val drones = viewModel.drones

    Scaffold(
        containerColor = Color(0x1E1E1E),
        topBar = {
            TopAppBar(
                title = { Text("Drones list", color = Color.White) },
                navigationIcon = {
                    IconButton(onClick = { navController.popBackStack() }) {
                        Icon(Icons.Default.ArrowBack, contentDescription = "Back", tint = Color.White)
                    }
                },
                actions = {
                    IconButton(onClick = { /* TODO: ajouter drone */ }) {
                        Icon(Icons.Default.Add, contentDescription = "Add", tint = Color.White)
                    }
                },
                colors = TopAppBarDefaults.topAppBarColors(
                    containerColor = Color(0xFF2A2A2A)
                )
            )
        },
        bottomBar = {
            BottomNavigationBar()
        }
    ) { padding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(padding)
                .background(Color(0xFF1E1E1E)),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(Modifier.height(20.dp))

            Card(
                colors = CardDefaults.cardColors(containerColor = Color(0xFF2C2C2C)),
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
                        Text("Name", color = Color.Gray, fontSize = 14.sp)
                        Text("Status", color = Color.Gray, fontSize = 14.sp)
                        Spacer(Modifier.width(24.dp))
                    }

                    Divider(color = Color.DarkGray, thickness = 1.dp)

                    LazyColumn {
                        items(drones) { drone ->
                            Row(
                                Modifier
                                    .fillMaxWidth()
                                    .padding(vertical = 8.dp),
                                horizontalArrangement = Arrangement.SpaceBetween,
                                verticalAlignment = Alignment.CenterVertically
                            ) {
                                Text(drone.name, color = Color.White, fontWeight = FontWeight.SemiBold)
                                Text("OK", color = Color(0xFF3DDC84))

                            }
                            Divider(color = Color.DarkGray, thickness = 0.5.dp)
                        }
                    }
                }
            }
        }
    }
}
