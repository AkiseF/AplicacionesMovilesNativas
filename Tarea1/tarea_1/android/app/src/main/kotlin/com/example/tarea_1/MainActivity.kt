package com.example.tarea_1

import android.os.Bundle
import android.view.View
import android.widget.LinearLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.cardview.widget.CardView
import androidx.fragment.app.Fragment
import com.google.android.material.bottomnavigation.BottomNavigationView

class MainActivity : AppCompatActivity() {

    private lateinit var menuPrincipal: View
    private lateinit var fragmentContainer: View
    private lateinit var bottomNavigation: BottomNavigationView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Obtener referencias a las vistas
        menuPrincipal = findViewById(R.id.menu_principal_layout)
        fragmentContainer = findViewById(R.id.fragment_container)
        bottomNavigation = findViewById(R.id.bottom_navigation)
        
        // Configurar botones del menú principal
        findViewById<CardView>(R.id.card_textfields).setOnClickListener {
            showFragment(TextFieldsFragment())
        }
        
        findViewById<CardView>(R.id.card_buttons).setOnClickListener {
            showFragment(ButtonsFragment())
        }
        
        findViewById<CardView>(R.id.card_selection).setOnClickListener {
            showFragment(SelectionElementsFragment())
        }
        
        findViewById<CardView>(R.id.card_lists).setOnClickListener {
            showFragment(ListsFragment())
        }
        
        findViewById<CardView>(R.id.card_information).setOnClickListener {
            showFragment(InformationElementsFragment())
        }
        
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
    }

    // Método para mostrar un fragment desde el menú principal
    private fun showFragment(fragment: Fragment) {
        // Ocultar el menú principal
        menuPrincipal.visibility = View.GONE
        
        // Mostrar el contenedor de fragments y la barra de navegación
        fragmentContainer.visibility = View.VISIBLE
        bottomNavigation.visibility = View.VISIBLE
        
        // Actualizar el ítem seleccionado en la navegación
        when (fragment) {
            is TextFieldsFragment -> bottomNavigation.selectedItemId = R.id.nav_textfields
            is ButtonsFragment -> bottomNavigation.selectedItemId = R.id.nav_buttons
            is SelectionElementsFragment -> bottomNavigation.selectedItemId = R.id.nav_selection
            is ListsFragment -> bottomNavigation.selectedItemId = R.id.nav_lists
            is InformationElementsFragment -> bottomNavigation.selectedItemId = R.id.nav_information
        }
        
        // Cargar el fragment
        loadFragment(fragment)
    }
    
    // Método para cargar un fragment en el contenedor
    private fun loadFragment(fragment: Fragment) {
        supportFragmentManager.beginTransaction()
            .replace(R.id.fragment_container, fragment)
            .commit()
    }
    
    // Sobreescribir el método onBackPressed para volver al menú principal
    @Deprecated("Deprecated in Java")
    override fun onBackPressed() {
        if (fragmentContainer.visibility == View.VISIBLE) {
            // Si estamos en un fragment, volver al menú principal
            fragmentContainer.visibility = View.GONE
            bottomNavigation.visibility = View.GONE
            menuPrincipal.visibility = View.VISIBLE
        } else {
            // Si ya estamos en el menú principal, comportamiento normal (salir)
            super.onBackPressed()
        }
    }
    
    // Para las versiones más recientes de Android
    override fun onSupportNavigateUp(): Boolean {
        if (fragmentContainer.visibility == View.VISIBLE) {
            // Si estamos en un fragment, volver al menú principal
            fragmentContainer.visibility = View.GONE
            bottomNavigation.visibility = View.GONE
            menuPrincipal.visibility = View.VISIBLE
            return true
        }
        return super.onSupportNavigateUp()
    }
}
