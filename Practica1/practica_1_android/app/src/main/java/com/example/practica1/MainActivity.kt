package com.example.practica1

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.google.android.material.floatingactionbutton.FloatingActionButton

class MainActivity : AppCompatActivity() {
    
    private var counter = 0
    private lateinit var counterValueText: TextView
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Configurar el título de la ActionBar
        supportActionBar?.title = getString(R.string.app_name)
        
        // Inicializar las vistas
        counterValueText = findViewById(R.id.counterValueText)
        val incrementButton: FloatingActionButton = findViewById(R.id.incrementButton)
        
        // Configurar el listener del botón
        incrementButton.setOnClickListener {
            incrementCounter()
        }
        
        // Actualizar la UI inicial
        updateCounterDisplay()
    }
    
    private fun incrementCounter() {
        counter++
        updateCounterDisplay()
    }
    
    private fun updateCounterDisplay() {
        counterValueText.text = counter.toString()
    }
    
    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putInt("counter", counter)
    }
    
    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)
        counter = savedInstanceState.getInt("counter", 0)
        updateCounterDisplay()
    }
}