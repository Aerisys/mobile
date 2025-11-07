package fr.aerisys.mobile.viewModel

import androidx.compose.runtime.mutableStateListOf
import androidx.lifecycle.ViewModel
import fr.aerisys.mobile.db.AerisysDatabase
import fr.aerisys.mobile.model.Drone



class MainViewModel(
    private val database: AerisysDatabase
) : ViewModel() {

    init {
        insertAndDisplayUser()
    }

    private fun insertAndDisplayUser() {
        val userQueries = database.usersQueries
        val dronesQueries = database.dronesQueries

        dronesQueries.deleteAllDrones()
        userQueries.deleteAllUsers()

       userQueries.insertUser(
           username = "John Doe",
           email = "john.doe@example.com",
            password = "password123"
        )

        val users = userQueries.selectAllUsers().executeAsList()
        println("Users in database: $users")
    }


    private val _drones = mutableStateListOf<Drone>()
    val drones: List<Drone> get() = _drones

    init {
        _drones.addAll(
            listOf(
                Drone(
                    1,
                    100,
                    "DJI Mini 4 Pro",
                    "AA:BB:CC:DD:01",
                    "192.168.1.1",
                    "Auto",
                    80,
                    120,
                    "2024-10-20"
                ),
                Drone(
                    2,
                    100,
                    "Parrot Anafi",
                    "AA:BB:CC:DD:02",
                    "192.168.1.2",
                    "Manual",
                    60,
                    100,
                    "2024-09-14"
                ),
                Drone(
                    3,
                    100,
                    "Autel Evo Lite+",
                    "AA:BB:CC:DD:03",
                    "192.168.1.3",
                    "GPS",
                    70,
                    150,
                    "2024-09-01"
                ),
            )
        )
    }

    fun getDroneById(id: Long): Drone? = _drones.find { it.id == id }

}
