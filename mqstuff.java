config.java
package org.abc.mqconnectivity.config;

import com.ibm.mq.jms.MQQueueConnectionFactory;
import com.ibm.msg.client.wmq.WMQConstants;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import javax.jms.QueueConnectionFactory;

@Configuration
public class MqConfig {

    @Bean
    public QueueConnectionFactory mqConnectionFactory() throws Exception {
        MQQueueConnectionFactory factory = new MQQueueConnectionFactory();
        factory.setHostName("your-mq-host");          // or pass as env var
        factory.setPort(1414);                        // MQ port
        factory.setQueueManager("QMGR1");             // Your queue manager
        factory.setChannel("DEV.APP.SVRCONN");        // MQ channel
        factory.setTransportType(WMQConstants.WMQ_CM_CLIENT);

        return factory;
    }
}



service.java


package org.abc.mqconnectivity.service;

import javax.jms.Connection;
import javax.jms.QueueConnectionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MqService {

    @Autowired
    private QueueConnectionFactory mqConnectionFactory;

    public String testMqConnection() {
        try (Connection connection = mqConnectionFactory.createConnection("username", "password")) {
            connection.start();
            return "MQ Connection Successful";
        } catch (Exception e) {
            return "MQ Connection Failed: " + e.getMessage();
        }
    }
}


connectionhandler.java
package org.abc.mqconnectivity.handler;

import org.abc.mqconnectivity.service.MqService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.function.Function;

@Service
public class MqConnectivityHandler {

    @Autowired
    private MqService mqService;

    @Bean
    public Function<String, String> handleRequest() {
        return input -> {
            // Input can be ignored or logged if needed
            return mqService.testMqConnection();
        };
    }
}
