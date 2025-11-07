package fr.aerisys.mobile.ui.components.navbar

sealed class NavEvent {
    object Stay : NavEvent()
    data class Navigate(val route: String) : NavEvent()
}
