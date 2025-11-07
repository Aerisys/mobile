package fr.aerisys.mobile.ui.components.navbar

import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import org.jetbrains.compose.resources.painterResource
import org.jetbrains.compose.resources.stringResource

@Composable
fun BottomNavigationBar(
    barType: NavBarType,
    currentRoute: String,
    onNavEvent: (NavEvent) -> Unit,
    modifier: Modifier = Modifier,
    containerColor: Color = MaterialTheme.colorScheme.surfaceContainer,
    contentColor: Color = MaterialTheme.colorScheme.onSurface,
    elevation: Dp = 10.dp
) {
    NavigationBar(
        modifier = modifier,
        containerColor = containerColor,
        contentColor = contentColor,
        tonalElevation = elevation
    ) {
        navBarItemsByType[barType]?.forEach { item ->
            NavigationBarItem(
                selected = currentRoute == item.route,
                onClick = {
                    if (currentRoute == item.route) {
                        onNavEvent(NavEvent.Stay)
                    } else {
                        onNavEvent(NavEvent.Navigate(item.route))
                    }
                },
                icon = {
                    when (val icon = item.icon) {
                        is NavBarIcon.Vector -> Icon(
                            imageVector = icon.icon,
                            contentDescription = stringResource(item.labelRes),
                            tint = contentColor
                        )
                        is NavBarIcon.Drawable -> Icon(
                            painter = painterResource(icon.res),
                            contentDescription = stringResource(item.labelRes),
                            tint = contentColor
                        )
                    }
                },
                label = { Text(stringResource(item.labelRes)) }
            )
        }
    }
}
