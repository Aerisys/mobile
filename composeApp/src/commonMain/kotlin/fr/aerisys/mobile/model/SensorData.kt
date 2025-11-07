package fr.aerisys.mobile.model

data class Vector3(val x: Double, val y: Double, val z: Double)

data class Orientation(
    val yaw: Double,
    val roll: Double,
    val pitch: Double
)

data class SensorData(
    val gyroscope: Vector3,
    val accelerometer: Vector3,
    val orientation: Orientation
)
