package fr.aerisys.mobile.model


data class Drone(
    val id: Long,
    val user_id: Long,
    val name: String,
    val mac_adress: String,
    val ip_adress: String,
    val flight_mode: String,
    val motor_power: Int,
    val altitude_limit: Int,
    val added_at: String
)