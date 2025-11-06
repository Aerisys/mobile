package fr.aerisys.mobile.ui.screens

import aerisys.composeapp.generated.resources.Res
import aerisys.composeapp.generated.resources.app_name
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import fr.aerisys.mobile.viewModel.MainViewModel
import org.jetbrains.compose.resources.stringResource

@Composable
fun HomeScreen(mainViewModel: MainViewModel) {
    Text(stringResource(Res.string.app_name))
}
