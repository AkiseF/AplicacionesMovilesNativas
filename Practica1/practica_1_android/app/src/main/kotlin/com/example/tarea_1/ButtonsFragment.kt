package com.example.tarea_1

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageButton
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.google.android.material.floatingactionbutton.FloatingActionButton

class ButtonsFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_buttons, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        val buttonNormal = view.findViewById<Button>(R.id.button_normal)
        val buttonColored = view.findViewById<Button>(R.id.button_colored)
        val imageButton = view.findViewById<ImageButton>(R.id.image_button)
        val fabButton = view.findViewById<FloatingActionButton>(R.id.fab_button)
        val textViewClicks = view.findViewById<TextView>(R.id.textview_clicks)
        
        var clickCount = 0
        
        val updateClicksText = {
            textViewClicks.text = "Has hecho clic ${clickCount} veces"
        }
        
        buttonNormal.setOnClickListener {
            clickCount++
            updateClicksText()
            Toast.makeText(context, "Clic en botón normal", Toast.LENGTH_SHORT).show()
        }
        
        buttonColored.setOnClickListener {
            clickCount++
            updateClicksText()
            Toast.makeText(context, "Clic en botón de color", Toast.LENGTH_SHORT).show()
        }
        
        imageButton.setOnClickListener {
            clickCount++
            updateClicksText()
            Toast.makeText(context, "Clic en botón de imagen", Toast.LENGTH_SHORT).show()
        }
        
        fabButton.setOnClickListener {
            clickCount++
            updateClicksText()
            Toast.makeText(context, "Clic en botón flotante", Toast.LENGTH_SHORT).show()
        }
    }
}
