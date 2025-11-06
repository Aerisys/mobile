package fr.aerisys.mobile

import androidx.compose.runtime.Composable
import fr.aerisys.mobile.ui.AppNavigation
import fr.aerisys.mobile.ui.theme.AppTheme
import org.jetbrains.compose.ui.tooling.preview.Preview

@Composable
@Preview
fun App() {
    AppTheme {
        AppNavigation()
    }
}