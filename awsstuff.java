import software.amazon.awssdk.services.secretsmanager.SecretsManagerClient;
import software.amazon.awssdk.services.secretsmanager.model.*;
import java.util.Base64;
import java.security.KeyStore;
import javax.net.ssl.SSLContext;
import javax.net.ssl.TrustManagerFactory;
import javax.net.ssl.KeyManagerFactory;
import java.io.ByteArrayInputStream;

@Bean
public QueueConnectionFactory mqConnectionFactory() throws Exception {
    // Fetch cert and password from AWS Secrets Manager
    SecretsManagerClient client = SecretsManagerClient.create();
    GetSecretValueRequest getSecretValueRequest = GetSecretValueRequest.builder()
        .secretId("YourSecretNameHere")
        .build();
    GetSecretValueResponse secretValue = client.getSecretValue(getSecretValueRequest);

    JSONObject secretJson = new JSONObject(secretValue.secretString());
    String base64Cert = secretJson.getString("mqCert");
    String certPassword = secretJson.getString("mqCertPassword");

    // Decode certificate
    byte[] certBytes = Base64.getDecoder().decode(base64Cert);
    KeyStore keyStore = KeyStore.getInstance("PKCS12"); // or "JKS" if applicable
    keyStore.load(new ByteArrayInputStream(certBytes), certPassword.toCharArray());

    // Init KeyManager
    KeyManagerFactory kmf = KeyManagerFactory.getInstance("SunX509");
    kmf.init(keyStore, certPassword.toCharArray());

    // Trust manager (optional if needed)
    TrustManagerFactory tmf = TrustManagerFactory.getInstance("SunX509");
    tmf.init((KeyStore) null);

    // SSLContext
    SSLContext sslContext = SSLContext.getInstance("TLS");
    sslContext.init(kmf.getKeyManagers(), tmf.getTrustManagers(), null);

    MQQueueConnectionFactory factory = new MQQueueConnectionFactory();
    factory.setHostName("qa.cir.mq-w1.abc.com");
    factory.setPort(20380);
    factory.setQueueManager("QACIR01");
    factory.setChannel("CIRF.SVRCONN");
    factory.setTransportType(WMQConstants.WMQ_CM_CLIENT);
    factory.setSSLSocketFactory(sslContext.getSocketFactory());

    return factory;
}
