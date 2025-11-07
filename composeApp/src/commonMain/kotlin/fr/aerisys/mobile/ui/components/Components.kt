package fr.aerisys.mobile.ui.components

import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import fr.aerisys.mobile.ui.components.navbar.BottomNavigationBar
import fr.aerisys.mobile.ui.components.navbar.NavBarType
import org.jetbrains.compose.ui.tooling.preview.Preview

@Composable
fun MyButton(
    text: String,
    onClick: () -> Unit,
    modifier: Modifier = Modifier,
    color: Color = MaterialTheme.colorScheme.primary,
    textColor: Color = MaterialTheme.colorScheme.onPrimary,
    padding: Int = 16
) {
    Button(
        onClick = onClick,
        colors = ButtonDefaults.buttonColors(containerColor = color),
        modifier = modifier.padding(padding.dp).width(150.dp)
    ) {
        Text(text, color = textColor)
    }
}

@Composable
fun MyFloatingButton(
    onClick: () -> Unit,
    content: @Composable () -> Unit,
    modifier: Modifier = Modifier,
) {
    FloatingActionButton(
        onClick = onClick,
        modifier = modifier.padding(16.dp),
        containerColor = MaterialTheme.colorScheme.primary,
        contentColor = MaterialTheme.colorScheme.onPrimary,
        content = content
    )
}

@Preview
@Composable
fun Preview() {
    Column(modifier = Modifier.padding(16.dp)) {
        MyButton(
            text = "Add to the list",
            onClick = { println("Button clicked !") },
        )
        MyFloatingButton(
            onClick = { println("Floating button clicked !") },
            content = { Icon(Icons.Default.Add, contentDescription = "Add") }
        )
        BottomNavigationBar(
            barType = NavBarType.DRONE,
            currentRoute = "3d",
            onNavEvent = {}
        )
    }
}