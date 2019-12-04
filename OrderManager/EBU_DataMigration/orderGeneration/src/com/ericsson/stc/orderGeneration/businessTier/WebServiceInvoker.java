package com.ericsson.stc.orderGeneration.businessTier;

import com.ericsson.stc.orderGeneration.persistentTier.pojo.ServiceData;
import com.ericsson.stc.orderGeneration.utility.PropertyReader;
import org.apache.log4j.Logger;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.UnknownHostException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;

/**
 * This is the class responsible to invoke the remote WS sending the data found in the DB.
 *
 * It's a singleton and uses socket to send and receive messages from WS.
 */
public class WebServiceInvoker {

  private static WebServiceInvoker s_webServiceInvoker = null;

  // connection parameters
  private String _eocEBUHostName;
  private int    _eocEBUPort;
  private String _eocEBUURL;

  // submitOrderTemplate
  private String _submitOrderTemplate;


  private Logger _logger = Logger.getLogger(getClass());

  /**
   * The constructor; it sets the 3 internal properties and throws exception if
   * one of them is null or invalid.
   *
   * @throws InvokerException if any of the property read is null or invalid.
   */
  private WebServiceInvoker() throws InvokerException {
    _eocEBUHostName = getConfigurationProperty("eoc_ebu_hostname");

    try {
      _eocEBUPort = Integer.parseInt(getConfigurationProperty("eoc_ebu_port"));
    }
    catch (NumberFormatException exc) {
      throw new InvokerException("Error in parsing property 'eoc_ebu_port'; not a valid number", exc);
    }
    _eocEBUURL = getConfigurationProperty("eoc_ebu_URL");

    readSubmitOrderTemplate();
    if(_submitOrderTemplate == null) {
      throw new InvokerException("Error in reading 'submitOrderTemplate.xml' file; check previous errors in the log");
    }
  }


  public static WebServiceInvoker getInstance() throws InvokerException {
    if (s_webServiceInvoker == null) {
      s_webServiceInvoker = new WebServiceInvoker();
    }
    return s_webServiceInvoker;
  }


  /**
   * This is the class responsible to invoke the remote WS sending the data found in the DB.
   *
   * @return the xml message output of the operation.
   * @param serviceData the data with all the info for the service and the customer
   * @throws InvokerException if any error occurs.
   */
  public String invoke(ServiceData serviceData) throws InvokerException {

    StringBuilder serverResponse = new StringBuilder();
    try {
      GregorianCalendar now = new GregorianCalendar();
      GregorianCalendar tomorrow = new GregorianCalendar();
      tomorrow.add(Calendar.DAY_OF_MONTH, 1);

      SimpleDateFormat sdfNow = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'+03:00'");
      SimpleDateFormat sdfTomorrow = new SimpleDateFormat("yyyy-MM-dd'T12:00:00+03:00'");

      // checking that the msg read has the soap header otherwise it's added
      String soapMsg = _submitOrderTemplate;
      soapMsg = soapMsg.replaceAll("CUSTOMER_NUMBER", serviceData.getCustomerNumber()).
                        replaceAll("ACCOUNT_NUMBER", serviceData.getAccountNumber()).
                        replaceAll("ORDER_NUMBER", serviceData.getOrderNumber()).
                        replaceAll("CREATION_DATE", sdfNow.format(now.getTime())).
                        replaceAll("SERVICE_DATE", sdfTomorrow.format(tomorrow.getTime())).
                        replaceAll("CIRCUIT_CATEGORY", serviceData.getCircuitCategory()).
                        replaceAll("PATH_NAME", serviceData.getPathName()).
                        replaceAll("REMARKS", serviceData.getRemarks()).
                        replaceAll("ACCESS_NUMBER", serviceData.getAccessNumber()).
                        replaceAll("BANDWIDTH", serviceData.getBandwidth()).
                        replaceAll("SITE_A", serviceData.getSiteA()).
                        replaceAll("SITE_B", serviceData.getSiteB());

      URL wsURL = new URL("http://" + _eocEBUHostName + ":" + _eocEBUPort + _eocEBUURL);

      HttpURLConnection httpURLConnection = (HttpURLConnection)wsURL.openConnection();
      httpURLConnection.setDoOutput(true);
      httpURLConnection.setDoInput(true);

      httpURLConnection.setRequestMethod("POST");
      httpURLConnection.setConnectTimeout(120*1000);
      httpURLConnection.setReadTimeout(120*1000);
      httpURLConnection.setRequestProperty("Host", _eocEBUHostName + ":" + _eocEBUPort);
      httpURLConnection.setRequestProperty("Content-Type", "text/xml; charset=utf-8");
      httpURLConnection.setRequestProperty("Content-Length", Integer.toString(soapMsg.length()*5));
      httpURLConnection.setRequestProperty("SOAPAction", "operation_SubmitOrder");
      httpURLConnection.setRequestProperty("User-Agent", "GENERIC_SUBMITORDER_TOOL (java 1.7)");
      httpURLConnection.setRequestProperty("Accept", "text/xml; charset=utf-8");

      // sending data
      OutputStream reqStream = httpURLConnection.getOutputStream();
      reqStream.write(soapMsg.getBytes());
      reqStream.flush();

      // receiving data
      byte[] byteBuf = new byte[1];
      InputStream resStream = httpURLConnection.getInputStream();
      int len = resStream.read(byteBuf);

      while (len > -1) {
        serverResponse.append(new String(byteBuf, "UTF-8"));
        len = resStream.read(byteBuf);
      }

      // closing input and output stream
      reqStream.close();
      resStream.close();
    }
    catch (UnknownHostException exc) {
      _logger.error("Unknown host " + _eocEBUHostName, exc);
      throw new InvokerException(exc);
    }
    catch (IOException exc) {
      _logger.error("Unable to reach host " + _eocEBUHostName, exc);
      throw new InvokerException(exc);
    }
    return serverResponse.toString();
  }

  private void readSubmitOrderTemplate() {
    try {
      InputStream wosuInputStream = getClass().getClassLoader().getResourceAsStream("submitOrderTemplate.xml");
      BufferedReader reader = new BufferedReader(new InputStreamReader(wosuInputStream, "UTF-8"));
      String line = reader.readLine();
      StringBuilder stringBuilder = new StringBuilder();
      while (line != null) {
        stringBuilder.append(line);
        line = reader.readLine();
      }
      reader.close();
      wosuInputStream.close();

      _submitOrderTemplate = stringBuilder.toString();
    }
    catch (UnsupportedEncodingException exc) {
      _logger.error("Error in reading submitOrderTemplate XML message for invalid encoding exception", exc);
    }
    catch (IOException exc) {
      _logger.error("Unexpected Error in reading submitOrderTemplate XML message", exc);
    }
  }

  private String getConfigurationProperty(String propertyName) throws InvokerException {
    PropertyReader propertyReader = PropertyReader.getInstance();
    String propertyValue = propertyReader.getProperty(propertyName);

    if (propertyValue == null) {
      throw new InvokerException("Unable to load property '" + propertyName + "'");
    }

    return propertyValue;
  }
}