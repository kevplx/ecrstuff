package org.frb.kc.tsd.cir.testmqconnectivitylambda.handler;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import javax.jms.Connection;
import javax.jms.QueueConnectionFactory;
import java.util.function.Function;

import static org.junit.jupiter.api.Assertions.*;

public class ConnectivityHandlerTest {

    @Test
    public void testHandleRequest_success() throws Exception {
        // Mock JMS connection
        Connection mockConnection = Mockito.mock(Connection.class);
        QueueConnectionFactory mockFactory = Mockito.mock(QueueConnectionFactory.class);
        Mockito.when(mockFactory.createConnection()).thenReturn(mockConnection);

        // Create handler
        ConnectivityHandler handler = new ConnectivityHandler(mockFactory);
        Function<String, String> function = handler.handleRequest();

        // Call the function
        String result = function.apply("anyInput");

        assertEquals("MQ connection successful", result);
        Mockito.verify(mockConnection).start();
    }

    @Test
    public void testHandleRequest_failure() throws Exception {
        QueueConnectionFactory mockFactory = Mockito.mock(QueueConnectionFactory.class);
        Mockito.when(mockFactory.createConnection()).thenThrow(new RuntimeException("boom"));

        ConnectivityHandler handler = new ConnectivityHandler(mockFactory);
        Function<String, String> function = handler.handleRequest();

        String result = function.apply("anyInput");
        assertTrue(result.contains("MQ connection failed"));
    }
}
