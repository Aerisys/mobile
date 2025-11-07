package fr.aerisys.mobile.ui.screens

import aerisys.composeapp.generated.resources.Res
import aerisys.composeapp.generated.resources.app_name
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.material3.Card
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
<<<<<<< Updated upstream
import fr.aerisys.mobile.viewModel.MainViewModel
import org.jetbrains.compose.resources.stringResource

@Composable
fun HomeScreen(mainViewModel: MainViewModel) {
    Text(stringResource(Res.string.app_name))
}
=======
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import org.jetbrains.compose.resources.stringResource

@Composable
fun HomeScreen(
    modifier: Modifier = Modifier
) {
    Column(
        modifier = modifier
            .fillMaxWidth(),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {

        Card(
            modifier = Modifier
                .fillMaxWidth()
        ) {
            Row {

            }
        }
    }
}
>>>>>>> Stashed changes
