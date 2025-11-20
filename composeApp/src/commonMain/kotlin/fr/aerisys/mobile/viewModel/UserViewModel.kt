package fr.aerisys.mobile.viewModel

import androidx.lifecycle.ViewModel
import fr.aerisys.mobile.db.AerisysDatabase
import fr.aerisys.mobile.utils.Hashing
import fraerisysmobile.db.Users

class UserViewModel(
    private val database: AerisysDatabase
) : ViewModel() {

    fun checkEmail(email: String): Users? {
        val userQueries = database.usersQueries
        return userQueries.selectUserByEmail(email).executeAsOneOrNull()
    }

    fun createUser(email: String, password : String, username : String) : Users? {
        val userQueries = database.usersQueries
        val hashedPassword = Hashing.hashPassword(password)
        userQueries.insertUser(
            username = username,
            email = email,
            password = hashedPassword
        )
        return userQueries.selectUserByEmail(email).executeAsOneOrNull()
    }

    fun login(email: String, password: String): Users? {
        val userQueries = database.usersQueries
        val hashedPassword = Hashing.hashPassword(password)
        return userQueries.loginUserByEmailAndPassword(email, hashedPassword).executeAsOneOrNull()
    }
}
