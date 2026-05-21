package com.lishe;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@EnableAsync
@SpringBootApplication
public class LisheApplication {

	public static void main(String[] args) {
		SpringApplication.run(LisheApplication.class, args);
	}

}
