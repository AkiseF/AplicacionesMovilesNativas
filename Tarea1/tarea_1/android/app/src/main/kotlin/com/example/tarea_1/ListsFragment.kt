package com.example.tarea_1

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView

class ListsFragment : Fragment() {

    private val itemList = mutableListOf(
        ListItem(1, "Elemento 1", "Descripción del elemento 1"),
        ListItem(2, "Elemento 2", "Descripción del elemento 2"),
        ListItem(3, "Elemento 3", "Descripción del elemento 3"),
        ListItem(4, "Elemento 4", "Descripción del elemento 4"),
        ListItem(5, "Elemento 5", "Descripción del elemento 5")
    )

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_lists, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        
        val recyclerView = view.findViewById<RecyclerView>(R.id.recycler_view)
        recyclerView.layoutManager = LinearLayoutManager(context)
        
        val adapter = ListAdapter(itemList) { item ->
            Toast.makeText(context, "Seleccionaste: ${item.title}", Toast.LENGTH_SHORT).show()
        }
        recyclerView.adapter = adapter
    }
}

data class ListItem(val id: Int, val title: String, val description: String)

class ListAdapter(
    private val items: List<ListItem>,
    private val onItemClick: (ListItem) -> Unit
) : RecyclerView.Adapter<ListAdapter.ViewHolder>() {

    class ViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val titleTextView: TextView = view.findViewById(R.id.item_title)
        val descriptionTextView: TextView = view.findViewById(R.id.item_description)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.list_item, parent, false)
        return ViewHolder(view)
    }

    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val item = items[position]
        holder.titleTextView.text = item.title
        holder.descriptionTextView.text = item.description
        
        holder.itemView.setOnClickListener {
            onItemClick(item)
        }
    }

    override fun getItemCount() = items.size
}
