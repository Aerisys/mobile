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