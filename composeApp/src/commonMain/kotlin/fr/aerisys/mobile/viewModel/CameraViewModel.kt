package fr.aerisys.mobile.viewModel

import androidx.lifecycle.ViewModel
import fr.aerisys.mobile.model.CameraBean
import kotlinx.coroutines.flow.MutableStateFlow

class CameraViewModel() : ViewModel() {
    val cameras = MutableStateFlow(emptyList<CameraBean>())
    val runInProgress = MutableStateFlow(false)
    val errorMessage = MutableStateFlow("")

    fun loadFakeData(runInProgress: Boolean = false, errorMessage: String = "") {
        this.runInProgress.value = runInProgress
        this.errorMessage.value = errorMessage

        cameras.value = listOf(
            CameraBean(
                id = 1,
                name = "Camera 1",
                ipAddress = "http://10.173.141.144/stream",
                userId = 45,
                macAddress = "00:1A:7D:DA:71:13",
                flightMode = "acrobat",
                motorPower = 10,
                altitudeLimit = 2000,
                firmwareVersion = "v1.0.0",
                firmwareUpdatedAt = 1254587,
                addedAt = 454989,
                updatedAt = 89789465
            )
        )
    }
}