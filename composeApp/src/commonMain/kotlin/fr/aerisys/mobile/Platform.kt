package fr.aerisys.mobile

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform