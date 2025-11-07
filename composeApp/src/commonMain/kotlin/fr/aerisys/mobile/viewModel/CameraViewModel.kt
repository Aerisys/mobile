package fr.aerisys.mobile.viewModel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import fr.aerisys.mobile.model.CameraBean
import fr.aerisys.mobile.model.KtorCameraClient
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.IO
import kotlinx.coroutines.Job
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch

class CameraViewModel(
    val cameraClient: KtorCameraClient,
) : ViewModel() {
    val cameras = MutableStateFlow(emptyList<CameraBean>())
    val runInProgress = MutableStateFlow(false)
    val errorMessage = MutableStateFlow("")

    fun loadFakeData(runInProgress: Boolean = false, errorMessage: String = "") {
        this.runInProgress.value = runInProgress
        this.errorMessage.value = errorMessage

        cameras.value = listOf(
        )
    }
}