package com.example.tarea_1

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.CheckBox
import android.widget.RadioButton
import android.widget.RadioGroup
import android.widget.Switch
import android.widget.TextView
import androidx.fragment.app.Fragment

class SelectionElementsFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_selection_elements, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        val checkBoxWifi = view.findViewById<CheckBox>(R.id.checkbox_wifi)
        val checkBoxBluetooth = view.findViewById<CheckBox>(R.id.checkbox_bluetooth)
        val checkBoxData = view.findViewById<CheckBox>(R.id.checkbox_data)
        
        val radioGroup = view.findViewById<RadioGroup>(R.id.radio_group)
        val radioLight = view.findViewById<RadioButton>(R.id.radio_light)
        val radioDark = view.findViewById<RadioButton>(R.id.radio_dark)
        val radioAuto = view.findViewById<RadioButton>(R.id.radio_auto)
        
        val switchNotifications = view.findViewById<Switch>(R.id.switch_notifications)
        val switchLocation = view.findViewById<Switch>(R.id.switch_location)
        
        val textViewResult = view.findViewById<TextView>(R.id.textview_selection_result)
        
        val updateResultText = {
            var resultText = "Configuración seleccionada:\n\n"
            
            resultText += "Conectividad:\n"
            if (checkBoxWifi.isChecked) resultText += "- WiFi: Activado\n"
            else resultText += "- WiFi: Desactivado\n"
            
            if (checkBoxBluetooth.isChecked) resultText += "- Bluetooth: Activado\n"
            else resultText += "- Bluetooth: Desactivado\n"
            
            if (checkBoxData.isChecked) resultText += "- Datos móviles: Activado\n"
            else resultText += "- Datos móviles: Desactivado\n"
            
            resultText += "\nTema de la aplicación: "
            when (radioGroup.checkedRadioButtonId) {
                R.id.radio_light -> resultText += "Claro"
                R.id.radio_dark -> resultText += "Oscuro"
                R.id.radio_auto -> resultText += "Automático"
            }
            
            resultText += "\n\nOtras configuraciones:\n"
            if (switchNotifications.isChecked) resultText += "- Notificaciones: Activadas\n"
            else resultText += "- Notificaciones: Desactivadas\n"
            
            if (switchLocation.isChecked) resultText += "- Ubicación: Activada\n"
            else resultText += "- Ubicación: Desactivada\n"
            
            textViewResult.text = resultText
        }
        
        // Establecer oyentes para todos los elementos de selección
        checkBoxWifi.setOnCheckedChangeListener { _, _ -> updateResultText() }
        checkBoxBluetooth.setOnCheckedChangeListener { _, _ -> updateResultText() }
        checkBoxData.setOnCheckedChangeListener { _, _ -> updateResultText() }
        
        radioGroup.setOnCheckedChangeListener { _, _ -> updateResultText() }
        
        switchNotifications.setOnCheckedChangeListener { _, _ -> updateResultText() }
        switchLocation.setOnCheckedChangeListener { _, _ -> updateResultText() }
        
        // Inicializar el texto de resultado
        updateResultText()
    }
}
