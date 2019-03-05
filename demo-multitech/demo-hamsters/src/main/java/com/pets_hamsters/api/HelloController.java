package com.demo_hamsters.api;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.InetAddress;
import java.net.UnknownHostException;

@RestController
public class HelloController {

    @RequestMapping("/")
    public String index() {
        try {
            return "Hamsters @" + InetAddress.getLocalHost().getHostName() + " (Java 8)\n";
        } catch (UnknownHostException e) {
            return "Hamsters @Error (Java 8)";
        }
    }

}
