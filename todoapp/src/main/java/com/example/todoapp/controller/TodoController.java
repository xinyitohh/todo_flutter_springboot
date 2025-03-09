package com.example.todoapp.controller;

import com.example.todoapp.model.Todo;
import com.example.todoapp.repository.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/todos")

public class TodoController {

    @Autowired
    private TodoRepository todoRepository;

    // Get all todos
    @GetMapping
    public List<Todo> getALlTodos(){
        return todoRepository.findAll();
    }

    // Add a new todo
    @PostMapping
    public Todo createTodo(@RequestBody Todo todo){
        return todoRepository.save(todo);
    }

    // Delete a todo by ID
    @DeleteMapping("/{id}")
    public void deleteTodo(@PathVariable Long id){
        todoRepository.deleteById(id);
    }

    // Update an existing todo
    @PutMapping("/{id}")
    public Todo updateTodo(@PathVariable Long id, @RequestBody Todo updatedTodo) {
        return todoRepository.findById(id)
                .map(todo -> {
                    todo.setTitle(updatedTodo.getTitle());
                    todo.setCompleted(updatedTodo.isCompleted());
                    return todoRepository.save(todo);
                })
                .orElseThrow(() -> new RuntimeException("Todo not found with id: " + id));
    }
}
