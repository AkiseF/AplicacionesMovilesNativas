package com.example.tarea_1

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView

class MainActivity : AppCompatActivity() {

    private lateinit var bottomNavigation: BottomNavigationView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.menu_principal)
        
        // Obtener la referencia a la barra de navegación inferior
        bottomNavigation = findViewById(R.id.bottom_navigation)
        
        // Configurar el navegador inferior
        bottomNavigation.setOnItemSelectedListener { item ->
            when (item.itemId) {
                R.id.nav_textfields -> {
                    loadFragment(TextFieldsFragment())
                    true
                }
                R.id.nav_buttons -> {
                    loadFragment(ButtonsFragment())
                    true
                }
                R.id.nav_selection -> {
                    loadFragment(SelectionElementsFragment())
                    true
                }
                R.id.nav_lists -> {
                    loadFragment(ListsFragment())
                    true
                }
                R.id.nav_information -> {
                    loadFragment(InformationElementsFragment())
                    true
                }
                else -> false
            }
        }
        
        // Cargar el fragment inicial basado en el intent recibido
        val fragmentType = intent.getStringExtra("fragment_type")
        val initialFragment = when (fragmentType) {
            "textfields" -> {
                bottomNavigation.selectedItemId = R.id.nav_textfields
                TextFieldsFragment()
            }
            "buttons" -> {
                bottomNavigation.selectedItemId = R.id.nav_buttons
                ButtonsFragment()
            }
            "selection" -> {
                bottomNavigation.selectedItemId = R.id.nav_selection
                SelectionElementsFragment()
            }
            "lists" -> {
                bottomNavigation.selectedItemId = R.id.nav_lists
                ListsFragment()
            }
            "information" -> {
                bottomNavigation.selectedItemId = R.id.nav_information
                InformationElementsFragment()
            }
            else -> {
                bottomNavigation.selectedItemId = R.id.nav_textfields
                TextFieldsFragment() // Fragment por defecto
            }
        }
        
        loadFragment(initialFragment)
    }
    
    // Método para cargar un fragment en el contenedor
    private fun loadFragment(fragment: Fragment) {
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, fragment)
            .commit()
    }
}
