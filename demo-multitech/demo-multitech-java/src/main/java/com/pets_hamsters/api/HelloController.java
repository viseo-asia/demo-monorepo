package com.demo_java.api;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

import java.net.InetAddress;
import java.net.UnknownHostException;

@RestController
public class HelloController {

    @RequestMapping("/")
    public String index() {
        try {
            return "java @" + InetAddress.getLocalHost().getHostName() + " (Java 8 v1)\n";
        } catch (UnknownHostException e) {
            return "java @Error (Java 8)";
        }
    }

}
