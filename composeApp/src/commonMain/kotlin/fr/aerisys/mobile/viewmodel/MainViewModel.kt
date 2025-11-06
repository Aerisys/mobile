package fr.aerisys.mobile.ui.viewmodel

import androidx.lifecycle.ViewModel
import androidx.compose.runtime.mutableStateListOf
import fr.aerisys.mobile.model.Drone

class MainViewModel : ViewModel() {

    private val _drones = mutableStateListOf<Drone>()
    val drones: List<Drone> get() = _drones

    init {
        _drones.addAll(
            listOf(
                Drone(1, "DJI Mini 4 Pro"),
                Drone(2, "Parrot Anafi"),
                Drone(3, "Autel Evo Lite+")
            )
        )
    }
}
