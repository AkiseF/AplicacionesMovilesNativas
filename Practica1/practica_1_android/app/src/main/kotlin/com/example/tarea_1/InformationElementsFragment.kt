package com.example.tarea_1

import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageView
import android.widget.ProgressBar
import android.widget.TextView
import androidx.fragment.app.Fragment

class InformationElementsFragment : Fragment() {

    private lateinit var progressBar: ProgressBar
    private lateinit var progressText: TextView
    private lateinit var progressBarHorizontal: ProgressBar
    private lateinit var progressPercentage: TextView
    private lateinit var btnStartProgress: Button
    private lateinit var imageView: ImageView
    private var currentImageIndex = 0
    
    // Lista de imágenes predefinidas (usaremos drawables del sistema para simplificar)
    private val imageList = arrayOf(
        android.R.drawable.ic_menu_camera,
        android.R.drawable.ic_menu_gallery,
        android.R.drawable.ic_menu_myplaces,
        android.R.drawable.ic_menu_mapmode
    )

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_information_elements, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        // Referencias a las vistas
        progressBar = view.findViewById(R.id.progress_circular)
        progressText = view.findViewById(R.id.text_loading)
        progressBarHorizontal = view.findViewById(R.id.progress_horizontal)
        progressPercentage = view.findViewById(R.id.text_percentage)
        btnStartProgress = view.findViewById(R.id.btn_start_progress)
        imageView = view.findViewById(R.id.image_view)
        
        val btnNextImage = view.findViewById<Button>(R.id.btn_next_image)
        
        // Mostrar la primera imagen
        imageView.setImageResource(imageList[currentImageIndex])
        
        // Configurar el botón para cambiar imágenes
        btnNextImage.setOnClickListener {
            currentImageIndex = (currentImageIndex + 1) % imageList.size
            imageView.setImageResource(imageList[currentImageIndex])
        }
        
        // Configurar el botón de progreso
        btnStartProgress.setOnClickListener {
            startProgressSimulation()
        }
    }
    
    private fun startProgressSimulation() {
        // Hacemos visibles los elementos de progreso
        progressBar.visibility = View.VISIBLE
        progressText.visibility = View.VISIBLE
        progressBarHorizontal.progress = 0
        progressPercentage.text = "0%"
        btnStartProgress.isEnabled = false
        
        val handler = Handler(Looper.getMainLooper())
        var progressStatus = 0
        
        Thread {
            while (progressStatus < 100) {
                progressStatus += 1
                // Actualizar UI desde el hilo principal
                handler.post {
                    progressBarHorizontal.progress = progressStatus
                    progressPercentage.text = "$progressStatus%"
                }
                try {
                    Thread.sleep(50) // Simular proceso con retraso
                } catch (e: InterruptedException) {
                    e.printStackTrace()
                }
            }
            
            // Proceso completado
            handler.post {
                progressText.text = "¡Carga completada!"
                progressBar.visibility = View.GONE
                btnStartProgress.isEnabled = true
                btnStartProgress.text = "Reiniciar progreso"
            }
        }.start()
    }
}
