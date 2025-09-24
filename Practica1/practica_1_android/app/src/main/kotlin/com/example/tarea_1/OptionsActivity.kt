package com.example.tarea_1

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.cardview.widget.CardView

class OptionsActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        
        // Configurar botones del menú principal para ir a MainActivity con diferentes fragments
        findViewById<CardView>(R.id.card_textfields).setOnClickListener {
            navigateToMainActivity("textfields")
        }
        
        findViewById<CardView>(R.id.card_buttons).setOnClickListener {
            navigateToMainActivity("buttons")
        }
        
        findViewById<CardView>(R.id.card_selection).setOnClickListener {
            navigateToMainActivity("selection")
        }
        
        findViewById<CardView>(R.id.card_lists).setOnClickListener {
            navigateToMainActivity("lists")
        }
        
        findViewById<CardView>(R.id.card_information).setOnClickListener {
            navigateToMainActivity("information")
        }
    }
    
    private fun navigateToMainActivity(fragmentType: String) {
        val intent = Intent(this, MainActivity::class.java)
        intent.putExtra("fragment_type", fragmentType)
        startActivity(intent)
    }
}