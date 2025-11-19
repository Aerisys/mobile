package fr.aerisys.mobile.viewModel

import androidx.lifecycle.ViewModel
import fr.aerisys.mobile.db.AerisysDatabase
import fraerisysmobile.db.Users

class UserViewModel(
    private val database: AerisysDatabase
) : ViewModel() {

//    init {
////        insertAndDisplayUser()
//    }

//    private fun insertAndDisplayUser() {
//        val userQueries = database.usersQueries
//        userQueries.deleteAllUsers()
//
//        userQueries.insertUser(
//            username = "John Doe",
//            email = "john.doe@example.com",
//            password = "password123"
//        )
//
//        val users = userQueries.selectAllUsers().executeAsList()
//        println("Users in database: $users")
//    }


    fun checkEmail(email: String): Users? {
        val userQueries = database.usersQueries
        return userQueries.selectUserByEmail(email).executeAsOneOrNull()
    }

    fun createUser(email: String, password : String, username : String) : Users? {
        val userQueries = database.usersQueries
        userQueries.insertUser(
            username = username,
            email = email,
            password = password
        )
        return userQueries.selectUserByEmail(email).executeAsOneOrNull()
    }

    fun login(email: String, password: String): Users? {
        val userQueries = database.usersQueries
        return userQueries.loginUserByEmailAndPassword(email, password).executeAsOneOrNull()
    }
}
