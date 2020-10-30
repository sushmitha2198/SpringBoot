package com.mindtree.helloworld.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {

	@GetMapping("/")
	public String getStudentName() {
		return "Hello World";
	}
}
