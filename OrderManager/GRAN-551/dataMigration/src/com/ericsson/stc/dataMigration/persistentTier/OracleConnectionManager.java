package com.ericsson.stc.dataMigration.persistentTier;

import com.ericsson.stc.dataMigration.persistentTier.pojo.CustomerData;
import com.ericsson.stc.dataMigration.persistentTier.pojo.ServiceData;
import com.ericsson.stc.dataMigration.utility.PropertyReader;
import org.apache.log4j.Logger;

import java.sql.*;
import java.util.HashMap;

public class OracleConnectionManager {

  private static OracleConnectionManager s_instance = null;

  private Logger _logger = Logger.getLogger(getClass());

  private String _dbURL      = null;
  private String _dbUserName = null;
  private String _dbPassword = null;

  private String _selectStatementForCustomer = null;
  private String _updateStatementForCustomer = null;

  private String _selectStatementForService = null;
  private String _updateStatementForService = null;

  private OracleConnectionManager() {
    initializeConnectionParameters();
    extractStatementsForCustomer();
  }

  public static OracleConnectionManager getInstance() {
    if(s_instance == null) {
      s_instance = new OracleConnectionManager();
    }

    return s_instance;
  }

  /**
   * To gather connection parameters.
   */
  private void initializeConnectionParameters() {
    try {
      Class.forName("oracle.jdbc.driver.OracleDriver");
      PropertyReader reader = PropertyReader.getInstance();
      _dbURL = reader.getProperty("dbInputURL");
      _dbUserName = reader.getProperty("dbInputUserName");
      _dbPassword = reader.getProperty("dbInputPassword");
    }
    catch (Exception exc) {
      _logger.error("Error in initializing connections parameters", exc);
    }
  }

  private void extractStatementsForCustomer() {
    PropertyReader reader = PropertyReader.getInstance();
    _selectStatementForCustomer = reader.getProperty("dbQueryStringForCustomer");
    if(_selectStatementForCustomer == null) {
      _logger.error("Unable to get the 'dbQueryStringForCustomer' statement from the configuration file");
    }
    _updateStatementForCustomer = reader.getProperty("dbUpdateResultStringForCustomer");
    if(_updateStatementForCustomer == null) {
      _logger.error("Unable to get the 'dbUpdateResultStringForCustomer' statement from the configuration file");
    }
    _selectStatementForService = reader.getProperty("dbQueryStringForService");
    if(_selectStatementForService == null) {
      _logger.error("Unable to get the 'dbQueryStringForService' statement from the configuration file");
    }
    _updateStatementForService = reader.getProperty("dbUpdateResultStringForService");
    if(_updateStatementForService == null) {
      _logger.error("Unable to get the 'dbUpdateResultStringForService' statement from the configuration file");
    }
  }

  /**
   * To load all the customerInfo.
   */
  public HashMap<Integer, CustomerData> extractAllRecordsForCustomers() {
    Connection connection = null;

    HashMap<Integer, CustomerData> result = new HashMap<>();
    try {
      connection = getConnection();

      if (connection != null) {

        if(_selectStatementForCustomer != null) {
          PreparedStatement preparedStatementForSelect = connection.prepareStatement(_selectStatementForCustomer);
          ResultSet rs = preparedStatementForSelect.executeQuery();
          while (rs.next()) {
            CustomerData customerData = new CustomerData();
            customerData.setId(rs.getInt("ID"));
            customerData.setCustomerRef(rs.getString("CUSTOMER_REF"));
            customerData.setCustomerType(rs.getString("CUSTOMER_TYPE"));
            customerData.setCustomerSubType(rs.getString("CUSTOMER_SUBTYPE"));
            customerData.setIdType(rs.getString("ID_TYPE"));
            customerData.setIdNO(rs.getString("ID_NO"));
            customerData.setSegment(rs.getString("SEGMENT"));
            customerData.setAccountNO(rs.getString("ACCOUNT_NO"));
            customerData.setServiceNumber(rs.getString("SERVICE_NUMBER"));
            customerData.setSne(rs.getString("SNE"));
            customerData.setServiceCode(rs.getString("SERVICE_CODE"));
            customerData.setSneStartDt(rs.getString("SNE_START_DT"));
            customerData.setAccessNumber(rs.getString("ACCESS_NUMBER"));

            result.put(customerData.getId(), customerData);
          }
          preparedStatementForSelect.close();

          connection.rollback();
        }
        else { // if (_selectStatementForCustomer != null)
          _logger.error("Statement for searching Customers is missing; see previous logs");
          result = null;
        }
      }
      else { // if (connection != null)
        _logger.error("Connection failed; see previous logs");
        result = null;
      }
    }
    catch (SQLException sqlExc) {
      _logger.error("Unable to gather the info for CUSTOMER from the DB due to SQL exception;  message = " + sqlExc.getMessage(), sqlExc);
      result = null;
    }
    finally {
      if(connection != null) {
        try {
          connection.close();
        }
        catch(Throwable t) {
          _logger.error("Error in closing connection with the DB", t);
        }
      }
    }
    return result;
  }

  /**
   * To load all the info about services.
   */
  public HashMap<String, ServiceData> extractAllRecordsForServices() {
    Connection connection = null;

    HashMap<String, ServiceData> result = new HashMap<>();
    try {
      connection = getConnection();

      if (connection != null) {

        if(_selectStatementForService != null) {
          PreparedStatement preparedStatementForSelect = connection.prepareStatement(_selectStatementForService);
          ResultSet rs = preparedStatementForSelect.executeQuery();
          while (rs.next()) {
            ServiceData serviceData = new ServiceData();
            serviceData.setPathName(rs.getString("PATH_NAME"));
            serviceData.setOrderNumber(rs.getString("ORDER_NUMBER"));

            result.put(serviceData.getPathName(), serviceData);
          }
          preparedStatementForSelect.close();

          connection.rollback();
        }
        else { // if (_selectStatementForCustomer != null)
          _logger.error("Statement for searching Services is missing; see previous logs");
          result = null;
        }
      }
      else { // if (connection != null)
        _logger.error("Connection failed; see previous logs");
        result = null;
      }
    }
    catch (SQLException sqlExc) {
      _logger.error("Unable to gather the info for SERVICE from the DB due to SQL exception;  message = " + sqlExc.getMessage(), sqlExc);
      result = null;
    }
    finally {
      if(connection != null) {
        try {
          connection.close();
        }
        catch(Throwable t) {
          _logger.error("Error in closing connection with the DB", t);
        }
      }
    }
    return result;
  }

  /**
   * To update the record in STC_CUSTOMER_DSLSKY identified by id with the provided result.
   */
  public void markCustomerRecordAsProcessed(Integer id, Integer resultValue) {
    Connection connection = null;

    try {
      connection = getConnection();

      if (connection != null) {
        if(_updateStatementForCustomer != null) {
          PreparedStatement preparedStatementForUpdate = connection.prepareStatement(_updateStatementForCustomer);
          preparedStatementForUpdate.setInt(2, id);
          preparedStatementForUpdate.setInt(1, resultValue);
          int rowsUpdated = preparedStatementForUpdate.executeUpdate();
          if(rowsUpdated > 0) {
            _logger.debug("Record in CUSTOMER with id '" + id + "' updated with value '" + resultValue + "'");
          }
          else {
            _logger.error("Unable to find record in CUSTOMER with id '" + id + "'");
          }
          preparedStatementForUpdate.close();

          connection.commit();
        }
      }
      else { // if (connection != null)
        _logger.error("Connection failed; see previous logs");
      }
    }
    catch (SQLException sqlExc) {
      _logger.error("Unable to update the info for CUSTOMER from the DB due to SQL exception; DB Error: " + sqlExc.getMessage(), sqlExc);
    }
    finally {
      if(connection != null) {
        try {
          connection.close();
        }
        catch(Throwable t) {
          _logger.error("Error in closing connection", t);
        }
      }
    }
  }

  /**
   * To update the record in STC_SERVICE_DSLSKY identified by id with the provided result.
   */
  public void markServiceRecordAsProcessed(String pathName, Integer resultValue) {
    Connection connection = null;

    try {
      connection = getConnection();

      if (connection != null) {
        if(_updateStatementForService != null) {
          PreparedStatement preparedStatementForUpdate = connection.prepareStatement(_updateStatementForService);
          preparedStatementForUpdate.setString(2, pathName);
          preparedStatementForUpdate.setInt(1, resultValue);
          int rowsUpdated = preparedStatementForUpdate.executeUpdate();
          if(rowsUpdated > 0) {
            _logger.debug("Record in SERVICE with pathName <" + pathName + "> updated with value '" + resultValue + "'");
          }
          else {
            _logger.error("Unable to find record in SERVICE with pathName <" + pathName + ">");
          }
          preparedStatementForUpdate.close();

          connection.commit();
        }
      }
      else { // if (connection != null)
        _logger.error("Connection failed; see previous logs");
      }
    }
    catch (SQLException sqlExc) {
      _logger.error("Unable to update the info for SERVICE from the DB due to SQL exception; DB Error: " + sqlExc.getMessage(), sqlExc);
    }
    finally {
      if(connection != null) {
        try {
          connection.close();
        }
        catch(Throwable t) {
          _logger.error("Error in closing connection", t);
        }
      }
    }

  }

  /**
   * To get the connection to the DB.
   * @return the connection to the DB or null if any error occurs.
   */
  private Connection getConnection() {
    _logger.debug("Getting connection...");

    Connection instanceConnection;
    try {
      instanceConnection = DriverManager.getConnection(_dbURL, _dbUserName, _dbPassword);
      instanceConnection.setAutoCommit(false);
      _logger.debug("connection acquired...");
    }
    catch (SQLException sqlEx) {
      _logger.error("Unable to connect to the DB with the provided information. Please double-check the configuration file");
      _logger.error("  url: " + _dbURL + "; user : " + _dbUserName, sqlEx);
      instanceConnection = null;
    }
    return instanceConnection;
  }
}
