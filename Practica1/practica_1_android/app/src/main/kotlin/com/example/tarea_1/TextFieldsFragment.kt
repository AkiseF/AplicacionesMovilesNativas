package com.example.tarea_1

import android.os.Bundle
import android.text.Editable
import android.text.TextWatcher
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.EditText
import android.widget.TextView
import androidx.fragment.app.Fragment

class TextFieldsFragment : Fragment() {

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_textfields, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        val editTextNormal = view.findViewById<EditText>(R.id.edittext_normal)
        val editTextPassword = view.findViewById<EditText>(R.id.edittext_password)
        val editTextMultiline = view.findViewById<EditText>(R.id.edittext_multiline)
        val editTextNumber = view.findViewById<EditText>(R.id.edittext_number)
        val textViewResult = view.findViewById<TextView>(R.id.textview_result)

        val textWatcher = object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}

            override fun afterTextChanged(s: Editable?) {
                val normalText = editTextNormal.text.toString()
                val passwordText = editTextPassword.text.toString()
                val multilineText = editTextMultiline.text.toString()
                val numberText = editTextNumber.text.toString()

                var resultText = "Campos completados:\n"
                if (normalText.isNotEmpty()) resultText += "- Texto normal: $normalText\n"
                if (passwordText.isNotEmpty()) resultText += "- Contraseña: $passwordText\n"
                if (multilineText.isNotEmpty()) resultText += "- Texto multilínea: $multilineText\n"
                if (numberText.isNotEmpty()) resultText += "- Número: $numberText\n"

                textViewResult.text = resultText
            }
        }

        editTextNormal.addTextChangedListener(textWatcher)
        editTextPassword.addTextChangedListener(textWatcher)
        editTextMultiline.addTextChangedListener(textWatcher)
        editTextNumber.addTextChangedListener(textWatcher)
    }
}
