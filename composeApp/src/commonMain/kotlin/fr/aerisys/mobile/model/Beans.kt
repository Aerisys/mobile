package fr.aerisys.mobile.model

data class CameraBean(
    val id: Long,
    val userId: Long,
    val name: String,
    val macAddress: String,
    val ipAddress: String,
    val flightMode: String,
    val motorPower: Int,
    val altitudeLimit: Int,
    val firmwareVersion: String,
    val firmwareUpdatedAt: Int, // timestamp
    val addedAt: Int, // timestamp
    val updatedAt: Int // timestamp
)

data class DroneBean(
    val id: Long,
    val userId: Long,
    val name: String,
    val macAddress: String?,
    val ipAddress: String?,
    val flightMode: String?,
    val motorPower: Long?,
    val altitudeLimit: Long?,
    val firmwareVersion: String?,
    val firmwareLastUpdate: Long?,
    val addedAt: Long?,
    val updatedAt: Long?
)

data class UserBean(
    val id: Long,
    val userName: String,
    val email: String,
    val password: String,
    val createdAt: Long,
)
